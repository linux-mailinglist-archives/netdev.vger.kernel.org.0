Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A90009726C
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 08:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbfHUGle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 02:41:34 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:43330 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbfHUGld (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 02:41:33 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5125C2057A;
        Wed, 21 Aug 2019 08:41:32 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ebeQAsY2uJbj; Wed, 21 Aug 2019 08:41:31 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1544520573;
        Wed, 21 Aug 2019 08:41:31 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 21 Aug 2019
 08:41:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id B5E6C31827CE;
 Wed, 21 Aug 2019 08:41:30 +0200 (CEST)
Date:   Wed, 21 Aug 2019 08:41:30 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Florian Westphal <fw@strlen.de>
CC:     <netdev@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>,
        <syzbot+8cc27ace5f6972910b31@syzkaller.appspotmail.com>
Subject: Re: [PATCH ipsec] xfrm: policy: avoid warning splat when merging
 nodes
Message-ID: <20190821064130.GN2879@gauss3.secunet.de>
References: <000000000000a585f2058f9dc7b3@google.com>
 <20190812083213.5010-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190812083213.5010-1-fw@strlen.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 10:32:13AM +0200, Florian Westphal wrote:
> syzbot reported a splat:
>  xfrm_policy_inexact_list_reinsert+0x625/0x6e0 net/xfrm/xfrm_policy.c:877
>  CPU: 1 PID: 6756 Comm: syz-executor.1 Not tainted 5.3.0-rc2+ #57
>  Call Trace:
>   xfrm_policy_inexact_node_reinsert net/xfrm/xfrm_policy.c:922 [inline]
>   xfrm_policy_inexact_node_merge net/xfrm/xfrm_policy.c:958 [inline]
>   xfrm_policy_inexact_insert_node+0x537/0xb50 net/xfrm/xfrm_policy.c:1023
>   xfrm_policy_inexact_alloc_chain+0x62b/0xbd0 net/xfrm/xfrm_policy.c:1139
>   xfrm_policy_inexact_insert+0xe8/0x1540 net/xfrm/xfrm_policy.c:1182
>   xfrm_policy_insert+0xdf/0xce0 net/xfrm/xfrm_policy.c:1574
>   xfrm_add_policy+0x4cf/0x9b0 net/xfrm/xfrm_user.c:1670
>   xfrm_user_rcv_msg+0x46b/0x720 net/xfrm/xfrm_user.c:2676
>   netlink_rcv_skb+0x1f0/0x460 net/netlink/af_netlink.c:2477
>   xfrm_netlink_rcv+0x74/0x90 net/xfrm/xfrm_user.c:2684
>   netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
>   netlink_unicast+0x809/0x9a0 net/netlink/af_netlink.c:1328
>   netlink_sendmsg+0xa70/0xd30 net/netlink/af_netlink.c:1917
>   sock_sendmsg_nosec net/socket.c:637 [inline]
>   sock_sendmsg net/socket.c:657 [inline]
> 
> There is no reproducer, however, the warning can be reproduced
> by adding rules with ever smaller prefixes.
> 
> The sanity check ("does the policy match the node") uses the prefix value
> of the node before its updated to the smaller value.
> 
> To fix this, update the prefix earlier.  The bug has no impact on tree
> correctness, this is only to prevent a false warning.
> 
> Reported-by: syzbot+8cc27ace5f6972910b31@syzkaller.appspotmail.com
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks Florian!
