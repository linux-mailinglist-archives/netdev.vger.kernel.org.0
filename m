Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8664915BC36
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 10:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729731AbgBMJ4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 04:56:12 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:37186 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729494AbgBMJ4M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 04:56:12 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id AB0C7200A7;
        Thu, 13 Feb 2020 10:56:11 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FmHkWUO7sfKK; Thu, 13 Feb 2020 10:56:11 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 480E820082;
        Thu, 13 Feb 2020 10:56:11 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 13 Feb 2020
 10:56:11 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id E863F31805ED;
 Thu, 13 Feb 2020 10:56:10 +0100 (CET)
Date:   Thu, 13 Feb 2020 10:56:10 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Trent Jaeger <tjaeger@cse.psu.edu>,
        Jamal Hadi Salim <hadi@cyberus.ca>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCH ipsec] xfrm: add the missing verify_sec_ctx_len check in
 xfrm_add_acquire
Message-ID: <20200213095610.GG3469@gauss3.secunet.de>
References: <3745867d50c4527853579f09b243acf3d8b5b850.1581254198.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3745867d50c4527853579f09b243acf3d8b5b850.1581254198.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 09, 2020 at 09:16:38PM +0800, Xin Long wrote:
> Without doing verify_sec_ctx_len() check in xfrm_add_acquire(), it may be
> out-of-bounds to access uctx->ctx_str with uctx->ctx_len, as noticed by
> syz:
> 
>   BUG: KASAN: slab-out-of-bounds in selinux_xfrm_alloc_user+0x237/0x430
>   Read of size 768 at addr ffff8880123be9b4 by task syz-executor.1/11650
> 
>   Call Trace:
>    dump_stack+0xe8/0x16e
>    print_address_description.cold.3+0x9/0x23b
>    kasan_report.cold.4+0x64/0x95
>    memcpy+0x1f/0x50
>    selinux_xfrm_alloc_user+0x237/0x430
>    security_xfrm_policy_alloc+0x5c/0xb0
>    xfrm_policy_construct+0x2b1/0x650
>    xfrm_add_acquire+0x21d/0xa10
>    xfrm_user_rcv_msg+0x431/0x6f0
>    netlink_rcv_skb+0x15a/0x410
>    xfrm_netlink_rcv+0x6d/0x90
>    netlink_unicast+0x50e/0x6a0
>    netlink_sendmsg+0x8ae/0xd40
>    sock_sendmsg+0x133/0x170
>    ___sys_sendmsg+0x834/0x9a0
>    __sys_sendmsg+0x100/0x1e0
>    do_syscall_64+0xe5/0x660
>    entry_SYSCALL_64_after_hwframe+0x6a/0xdf
> 
> So fix it by adding the missing verify_sec_ctx_len check there.
> 
> Fixes: 980ebd25794f ("[IPSEC]: Sync series - acquire insert")
> Reported-by: Hangbin Liu <liuhangbin@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Also applied, thanks a lot!
