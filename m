Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82AFD5F67F
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 12:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfGDKVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 06:21:30 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:50708 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727303AbfGDKVa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 06:21:30 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 20DA5201BE;
        Thu,  4 Jul 2019 12:21:28 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9yCiVXySrQ8E; Thu,  4 Jul 2019 12:21:27 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 9907E200AC;
        Thu,  4 Jul 2019 12:21:27 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 4 Jul 2019
 12:21:27 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 2CBD631804EF;
 Thu,  4 Jul 2019 12:21:27 +0200 (CEST)
Date:   Thu, 4 Jul 2019 12:21:27 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Florian Westphal <fw@strlen.de>
CC:     <netdev@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>,
        <syzbot+0165480d4ef07360eeda@syzkaller.appspotmail.com>
Subject: Re: [PATCH ipsec] xfrm: policy: fix bydst hlist corruption on hash
 rebuild
Message-ID: <20190704102127.GJ17989@gauss3.secunet.de>
References: <000000000000db481c058c462e4c@google.com>
 <20190702104600.9744-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190702104600.9744-1-fw@strlen.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 02, 2019 at 12:46:00PM +0200, Florian Westphal wrote:
> syzbot reported following spat:
> 
> BUG: KASAN: use-after-free in __write_once_size include/linux/compiler.h:221
> BUG: KASAN: use-after-free in hlist_del_rcu include/linux/rculist.h:455
> BUG: KASAN: use-after-free in xfrm_hash_rebuild+0xa0d/0x1000 net/xfrm/xfrm_policy.c:1318
> Write of size 8 at addr ffff888095e79c00 by task kworker/1:3/8066
> Workqueue: events xfrm_hash_rebuild
> Call Trace:
>  __write_once_size include/linux/compiler.h:221 [inline]
>  hlist_del_rcu include/linux/rculist.h:455 [inline]
>  xfrm_hash_rebuild+0xa0d/0x1000 net/xfrm/xfrm_policy.c:1318
>  process_one_work+0x814/0x1130 kernel/workqueue.c:2269
> Allocated by task 8064:
>  __kmalloc+0x23c/0x310 mm/slab.c:3669
>  kzalloc include/linux/slab.h:742 [inline]
>  xfrm_hash_alloc+0x38/0xe0 net/xfrm/xfrm_hash.c:21
>  xfrm_policy_init net/xfrm/xfrm_policy.c:4036 [inline]
>  xfrm_net_init+0x269/0xd60 net/xfrm/xfrm_policy.c:4120
>  ops_init+0x336/0x420 net/core/net_namespace.c:130
>  setup_net+0x212/0x690 net/core/net_namespace.c:316
> 
> The faulting address is the address of the old chain head,
> free'd by xfrm_hash_resize().
> 
> In xfrm_hash_rehash(), chain heads get re-initialized without
> any hlist_del_rcu:
> 
>  for (i = hmask; i >= 0; i--)
>     INIT_HLIST_HEAD(odst + i);
> 
> Then, hlist_del_rcu() gets called on the about to-be-reinserted policy
> when iterating the per-net list of policies.
> 
> hlist_del_rcu() will then make chain->first be nonzero again:
> 
> static inline void __hlist_del(struct hlist_node *n)
> {
>    struct hlist_node *next = n->next;   // address of next element in list
>    struct hlist_node **pprev = n->pprev;// location of previous elem, this
>                                         // can point at chain->first
>         WRITE_ONCE(*pprev, next);       // chain->first points to next elem
>         if (next)
>                 next->pprev = pprev;
> 
> Then, when we walk chainlist to find insertion point, we may find a
> non-empty list even though we're supposedly reinserting the first
> policy to an empty chain.
> 
> To fix this first unlink all exact and inexact policies instead of
> zeroing the list heads.
> 
> Add the commands equivalent to the syzbot reproducer to xfrm_policy.sh,
> without fix KASAN catches the corruption as it happens, SLUB poisoning
> detects it a bit later.
> 
> Reported-by: syzbot+0165480d4ef07360eeda@syzkaller.appspotmail.com
> Fixes: 1548bc4e0512 ("xfrm: policy: delete inexact policies from inexact list on hash rebuild")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks Florian!
