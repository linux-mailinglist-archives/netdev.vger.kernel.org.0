Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E2D4CD33D
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 12:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237604AbiCDLUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 06:20:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbiCDLUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 06:20:38 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2E1128DFC
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 03:19:49 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id ACCEE205CB;
        Fri,  4 Mar 2022 12:19:46 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id aOGmHbYFlfGq; Fri,  4 Mar 2022 12:19:46 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 052EB204E0;
        Fri,  4 Mar 2022 12:19:46 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id F385B80004A;
        Fri,  4 Mar 2022 12:19:45 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Fri, 4 Mar 2022 12:19:45 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Fri, 4 Mar
 2022 12:19:45 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 4B3C13180625; Fri,  4 Mar 2022 12:19:45 +0100 (CET)
Date:   Fri, 4 Mar 2022 12:19:45 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Haimin Zhang <tcs.kernel@gmail.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Haimin Zhang <tcs_kernel@tencent.com>,
        TCS Robot <tcs_robot@tencent.com>
Subject: Re: [PATCH] af_key: add __GFP_ZERO flag for compose_sadb_supported
 in function pfkey_register
Message-ID: <20220304111945.GE90740@gauss3.secunet.de>
References: <20220304083327.13514-1-tcs.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220304083327.13514-1-tcs.kernel@gmail.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 04:33:27PM +0800, Haimin Zhang wrote:
> From: Haimin Zhang <tcs_kernel@tencent.com>
> 
> Add __GFP_ZERO flag for compose_sadb_supported in function pfkey_register
> to initialize the buffer of supp_skb.
> 
> Reported-by: TCS Robot <tcs_robot@tencent.com>
> Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>

Can you please add at least a bit of the below problem description
to the commit message? Also please add a 'Fixes:' tag so that
it can be backtpored to the stable trees.

Thanks!

> ---
> This can cause a kernel-info-leak problem.
> 1. Function pfkey_register calls compose_sadb_supported to request a sk_buff.
> 2. compose_sadb_supported calls alloc_sbk to allocate a sk_buff, but it doesn't zero it.
> 3. If auth_len is greater 0, then compose_sadb_supported treats the memory as a struct sadb_supported and begins to initialize.
>  But it just initializes the field sadb_supported_len and field sadb_supported_exttype without field sadb_supported_reserved.
> ```
>  slab_post_alloc_hook build/../mm/slab.h:737 [inline]
>  slab_alloc_node build/../mm/slub.c:3247 [inline]
>  __kmalloc_node_track_caller+0x8da/0x11d0 build/../mm/slub.c:4975
>  kmalloc_reserve build/../net/core/skbuff.c:354 [inline]
>  __alloc_skb+0x545/0xf90 build/../net/core/skbuff.c:426
>  alloc_skb build/../include/linux/skbuff.h:1158 [inline]
>  compose_sadb_supported build/../net/key/af_key.c:1631 [inline]
>  pfkey_register+0x3c6/0xdb0 build/../net/key/af_key.c:1702
>  pfkey_process build/../net/key/af_key.c:2837 [inline]
>  pfkey_sendmsg+0x16bb/0x1c60 build/../net/key/af_key.c:3676
>  sock_sendmsg_nosec build/../net/socket.c:705 [inline]
>  sock_sendmsg build/../net/socket.c:725 [inline]
>  ____sys_sendmsg+0xe11/0x12c0 build/../net/socket.c:2413
>  ___sys_sendmsg+0x4a7/0x530 build/../net/socket.c:2467
>  __sys_sendmsg build/../net/socket.c:2496 [inline]
>  __do_sys_sendmsg build/../net/socket.c:2505 [inline]
>  __se_sys_sendmsg build/../net/socket.c:2503 [inline]
>  __x64_sys_sendmsg+0x3ef/0x570 build/../net/socket.c:2503
>  do_syscall_x64 build/../arch/x86/entry/common.c:51 [inline]
>  do_syscall_64+0x54/0xd0 build/../arch/x86/entry/common.c:82
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>  ```
> 
> 4. When this message was received, pfkey_recvmsg calls skb_copy_datagram_msg to copy the data to a userspace buffer.
> ```
> instrument_copy_to_user build/../include/linux/instrumented.h:121 [inline]
>  copyout build/../lib/iov_iter.c:154 [inline]
>  _copy_to_iter+0x65d/0x2510 build/../lib/iov_iter.c:668
>  copy_to_iter build/../include/linux/uio.h:162 [inline]
>  simple_copy_to_iter+0xf3/0x140 build/../net/core/datagram.c:519
>  __skb_datagram_iter+0x2d5/0x11b0 build/../net/core/datagram.c:425
>  skb_copy_datagram_iter+0xdc/0x270 build/../net/core/datagram.c:533
>  skb_copy_datagram_msg build/../include/linux/skbuff.h:3696 [inline]
>  pfkey_recvmsg+0x43e/0xb50 build/../net/key/af_key.c:3710
>  ____sys_recvmsg+0x590/0xb00
>  ___sys_recvmsg+0x37a/0xb70 build/../net/socket.c:2674
>  do_recvmmsg+0x6b3/0x11a0 build/../net/socket.c:2768
>  __sys_recvmmsg build/../net/socket.c:2847 [inline]
>  __do_sys_recvmmsg build/../net/socket.c:2870 [inline]
>  __se_sys_recvmmsg build/../net/socket.c:2863 [inline]
>  __x64_sys_recvmmsg+0x2af/0x500 build/../net/socket.c:2863
>  do_syscall_x64 build/../arch/x86/entry/common.c:51 [inline]
>  do_syscall_64+0x54/0xd0 build/../arch/x86/entry/common.c:82
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> ```
> 
> 5. The following is debug information:
> Bytes 20-23 of 176 are uninitialized
> Memory access of size 176 starts at ffff88815e686000
> Data copied to user address 0000000020000300
> 
>  net/key/af_key.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/key/af_key.c b/net/key/af_key.c
> index de24a7d474df..cf5433a2e31a 100644
> --- a/net/key/af_key.c
> +++ b/net/key/af_key.c
> @@ -1699,7 +1699,7 @@ static int pfkey_register(struct sock *sk, struct sk_buff *skb, const struct sad
>  
>  	xfrm_probe_algs();
>  
> -	supp_skb = compose_sadb_supported(hdr, GFP_KERNEL);
> +	supp_skb = compose_sadb_supported(hdr, GFP_KERNEL | __GFP_ZERO);
>  	if (!supp_skb) {
>  		if (hdr->sadb_msg_satype != SADB_SATYPE_UNSPEC)
>  			pfk->registered &= ~(1<<hdr->sadb_msg_satype);
> -- 
> 2.32.0 (Apple Git-132)
