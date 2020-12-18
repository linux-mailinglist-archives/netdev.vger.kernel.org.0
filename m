Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33C52DE655
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 16:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgLRPQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 10:16:57 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:47798 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbgLRPQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 10:16:56 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1EEF72057E;
        Fri, 18 Dec 2020 16:16:14 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id eC8_xBHs8Rf3; Fri, 18 Dec 2020 16:16:13 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 98FA420569;
        Fri, 18 Dec 2020 16:16:13 +0100 (CET)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 18 Dec 2020 16:16:13 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Fri, 18 Dec
 2020 16:16:12 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 185A331806B6; Fri, 18 Dec 2020 16:16:12 +0100 (CET)
Date:   Fri, 18 Dec 2020 16:16:12 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Shmulik Ladkani <shmulik@metanetworks.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: Re: [PATCH] xfrm: Fix oops in xfrm_replay_advance_bmp
Message-ID: <20201218151612.GC3576117@gauss3.secunet.de>
References: <20201214133832.438945-1-shmulik.ladkani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201214133832.438945-1-shmulik.ladkani@gmail.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-dresden-01.secunet.de (10.53.40.199)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 03:38:32PM +0200, Shmulik Ladkani wrote:
> When setting xfrm replay_window to values higher than 32, a rare
> page-fault occurs in xfrm_replay_advance_bmp:
> 
>   BUG: unable to handle page fault for address: ffff8af350ad7920
>   #PF: supervisor write access in kernel mode
>   #PF: error_code(0x0002) - not-present page
>   PGD ad001067 P4D ad001067 PUD 0
>   Oops: 0002 [#1] SMP PTI
>   CPU: 3 PID: 30 Comm: ksoftirqd/3 Kdump: loaded Not tainted 5.4.52-050452-generic #202007160732
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
>   RIP: 0010:xfrm_replay_advance_bmp+0xbb/0x130
>   RSP: 0018:ffffa1304013ba40 EFLAGS: 00010206
>   RAX: 000000000000010d RBX: 0000000000000002 RCX: 00000000ffffff4b
>   RDX: 0000000000000018 RSI: 00000000004c234c RDI: 00000000ffb3dbff
>   RBP: ffffa1304013ba50 R08: ffff8af330ad7920 R09: 0000000007fffffa
>   R10: 0000000000000800 R11: 0000000000000010 R12: ffff8af29d6258c0
>   R13: ffff8af28b95c700 R14: 0000000000000000 R15: ffff8af29d6258fc
>   FS:  0000000000000000(0000) GS:ffff8af339ac0000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: ffff8af350ad7920 CR3: 0000000015ee4000 CR4: 00000000001406e0
>   Call Trace:
>    xfrm_input+0x4e5/0xa10
>    xfrm4_rcv_encap+0xb5/0xe0
>    xfrm4_udp_encap_rcv+0x140/0x1c0
> 
> Analysis revealed offending code is when accessing:
> 
> 	replay_esn->bmp[nr] |= (1U << bitnr);
> 
> with 'nr' being 0x07fffffa.
> 
> This happened in an SMP system when reordering of packets was present;
> A packet arrived with a "too old" sequence number (outside the window,
> i.e 'diff > replay_window'), and therefore the following calculation:
> 
> 			bitnr = replay_esn->replay_window - (diff - pos);
> 
> yields a negative result, but since bitnr is u32 we get a large unsigned
> quantity (in crash dump above: 0xffffff4b seen in ecx).
> 
> This was supposed to be protected by xfrm_input()'s former call to:
> 
> 		if (x->repl->check(x, skb, seq)) {
> 
> However, the state's spinlock x->lock is *released* after '->check()'
> is performed, and gets re-acquired before '->advance()' - which gives a
> chance for a different core to update the xfrm state, e.g. by advancing
> 'replay_esn->seq' when it encounters more packets - leading to a
> 'diff > replay_window' situation when original core continues to
> xfrm_replay_advance_bmp().
> 
> An attempt to fix this issue was suggested in commit bcf66bf54aab
> ("xfrm: Perform a replay check after return from async codepaths"),
> by calling 'x->repl->recheck()' after lock is re-acquired, but fix
> applied only to asyncronous crypto algorithms.
> 
> Augment the fix, by *always* calling 'recheck()' - irrespective if we're
> using async crypto.
> 
> Fixes: 0ebea8ef3559 ("[IPSEC]: Move state lock into x->type->input")
> Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>

Applied, thanks a lot Shmulik!
