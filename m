Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9B7652BD10
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 16:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236566AbiERMsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238273AbiERMrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:47:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6B3BE1BB114
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 05:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652877815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UYuTXRT1KWoD9ySxSkLnG1NBBugOSznwSwCOE9KRgWE=;
        b=d8kQ0lHVpQdZoh6MRTCLppcZ2QMEkR4DYnt74arPtqNjUk7S6aLRp8FT/FqZJf/b2DERXX
        Mb6nk9TKuukNNLEVctkX8VyNUYaPoPSgKI1wsNL7zNOIBBbZwKHfDOtwpRtMhNRud6N4VK
        T9msAk7vrVD4oiH9C8ZulzeAE9vKOgc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-117-JXMIlMU3PFCxSYC2H94bjA-1; Wed, 18 May 2022 08:43:30 -0400
X-MC-Unique: JXMIlMU3PFCxSYC2H94bjA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17301899EC4;
        Wed, 18 May 2022 12:43:30 +0000 (UTC)
Received: from samus.usersys.redhat.com (unknown [10.43.17.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A6BA91410DD5;
        Wed, 18 May 2022 12:43:28 +0000 (UTC)
Date:   Wed, 18 May 2022 14:43:26 +0200
From:   Artem Savkov <asavkov@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru
Subject: Re: [PATCH net-next 10/11] tls: rx: clear ctx->recv_pkt earlier
Message-ID: <YoTp7kwXN1WdTakF@samus.usersys.redhat.com>
References: <20220408183134.1054551-1-kuba@kernel.org>
 <20220408183134.1054551-11-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220408183134.1054551-11-kuba@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Apr 08, 2022 at 11:31:33AM -0700, Jakub Kicinski wrote:
> Whatever we do in the loop the skb should not remain on as
> ctx->recv_pkt afterwards. We can clear that pointer and
> restart strparser earlier.
> 
> This adds overhead of extra linking and unlinking to rx_list
> but that's not large (upcoming change will switch to unlocked
> skb list operations).
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/tls/tls_sw.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 3aa8fe1c6e77..71d8082647c8 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -1826,6 +1826,10 @@ int tls_sw_recvmsg(struct sock *sk,
>  		if (err <= 0)
>  			goto recv_end;
>  
> +		ctx->recv_pkt = NULL;
> +		__strp_unpause(&ctx->strp);
> +		skb_queue_tail(&ctx->rx_list, skb);
> +
>  		if (async) {
>  			/* TLS 1.2-only, to_decrypt must be text length */
>  			chunk = min_t(int, to_decrypt, len);
> @@ -1840,10 +1844,9 @@ int tls_sw_recvmsg(struct sock *sk,
>  				if (err != __SK_PASS) {
>  					rxm->offset = rxm->offset + rxm->full_len;
>  					rxm->full_len = 0;
> +					skb_unlink(skb, &ctx->rx_list);

I have found this patch to be breaking __SK_REDIRECT case as queuing the skb
onto psock_other->ingress_skb while already having it in rx_list breaks
the latter (at least) ultimately resulting in a null pointer dereference
in __skb_queue_purge() during tls_sw_release_resources_rx.

This is easily reproducible with selftests/bpf/test_sockmap

[ 4363.845728][  T370] BUG: kernel NULL pointer dereference, address: 0000000000000008
[ 4363.851749][  T370] #PF: supervisor write access in kernel mode
[ 4363.856364][  T370] #PF: error_code(0x0002) - not-present page
[ 4363.862678][  T370] PGD 0 P4D 0
[ 4363.866893][  T370] Oops: 0002 [#1] PREEMPT SMP PTI
[ 4363.871576][  T370] CPU: 1 PID: 370 Comm: test_sockmap Not tainted 5.18.0-rc3.bpf-00792-g98a90feedc4e-dirty #649 22ffa66a3068b39367ed1f9d77b2a5bb8f7921a2
[ 4363.882164][  T370] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1.fc35 04/01/2014
[ 4363.890561][  T370] RIP: 0010:tls_sw_release_resources_rx+0xac/0x120
[ 4363.895582][  T370] Code: 00 48 89 ef be 01 00 00 00 83 e8 01 89 83 e8 01 00 00 48 8b 55 00 48 8b 45 08 48 c7 45 00 00 00 00 00 48 c7 45 08 00 00 00 00 <48> 89 42 08 48 89 10 e8 48 ed d4 ff 48 8b ab d8 01 00 00 49 39 ec
[ 4363.912545][  T370] RSP: 0018:ffffc90000cabb98 EFLAGS: 00010297
[ 4363.917672][  T370] RAX: 0000000000000000 RBX: ffff888113e10c00 RCX: 0000000000000000
[ 4363.922860][  T370] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff888100810400
[ 4363.929092][  T370] RBP: ffff888100810400 R08: 0000000000000040 R09: ffff8881099bc740
[ 4363.935344][  T370] R10: 0000000000000001 R11: ffff8881099cebc8 R12: ffff888113e10dd8
[ 4363.940657][  T370] R13: ffff88810759c500 R14: ffff88810759c8a0 R15: 0000000000000001
[ 4363.944835][  T370] FS:  0000000000000000(0000) GS:ffff88813bd00000(0000) knlGS:0000000000000000
[ 4363.948247][  T370] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4363.949967][  T370] CR2: 0000000000000008 CR3: 0000000003e72005 CR4: 0000000000170ea0
[ 4363.952346][  T370] Call Trace:
[ 4363.953458][  T370]  <TASK>
[ 4363.954472][  T370]  tls_sk_proto_close+0x29e/0x3b0
[ 4363.956060][  T370]  ? __sock_release+0xf0/0xf0
[ 4363.957432][  T370]  inet_release+0x63/0xb0
[ 4363.958857][  T370]  __sock_release+0x56/0xf0
[ 4363.960319][  T370]  sock_close+0x1d/0x30
[ 4363.961668][  T370]  __fput+0xd3/0x360
[ 4363.962969][  T370]  task_work_run+0x7b/0xc0
[ 4363.964415][  T370]  do_exit+0x25f/0x610
[ 4363.965577][  T370]  do_group_exit+0x44/0xe0
[ 4363.966802][  T370]  get_signal+0xa48/0xa60
[ 4363.967993][  T370]  arch_do_signal_or_restart+0x25/0x100
[ 4363.969706][  T370]  ? lockdep_hardirqs_on+0xbf/0x130
[ 4363.971241][  T370]  exit_to_user_mode_prepare+0x123/0x190
[ 4363.972904][  T370]  syscall_exit_to_user_mode+0x19/0x50
[ 4363.974630][  T370]  do_syscall_64+0x69/0x80
[ 4363.976075][  T370]  ? do_syscall_64+0x69/0x80
[ 4363.977562][  T370]  ? lockdep_hardirqs_on+0xbf/0x130
[ 4363.979998][  T370]  ? do_syscall_64+0x69/0x80
[ 4363.981466][  T370]  ? syscall_exit_to_user_mode+0x1e/0x50
[ 4363.983414][  T370]  ? do_syscall_64+0x69/0x80
[ 4363.984805][  T370]  ? lockdep_hardirqs_on+0xbf/0x130
[ 4363.986498][  T370]  ? do_syscall_64+0x69/0x80
[ 4363.988110][  T370]  ? exc_page_fault+0xbd/0x170
[ 4363.989749][  T370]  ? asm_exc_page_fault+0x8/0x30
[ 4363.991203][  T370]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 4363.993175][  T370] RIP: 0033:0x7ffff7e45a26
[ 4363.994479][  T370] Code: Unable to access opcode bytes at RIP 0x7ffff7e459fc.
[ 4363.996791][  T370] RSP: 002b:00007fffffffe0f8 EFLAGS: 00000246 ORIG_RAX: 000000000000003d
[ 4363.999448][  T370] RAX: fffffffffffffe00 RBX: 000000000045c720 RCX: 00007ffff7e45a26
[ 4364.001904][  T370] RDX: 0000000000000000 RSI: 00007fffffffe11c RDI: 0000000000000238
[ 4364.004265][  T370] RBP: 00007fffffffe180 R08: 0000000000000000 R09: 00007ffff7f0d0c0
[ 4364.006574][  T370] R10: 0000000000000000 R11: 0000000000000246 R12: 000000000040a970
[ 4364.009478][  T370] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 4364.011687][  T370]  </TASK>
[ 4364.012530][  T370] Modules linked in:
[ 4364.013470][  T370] CR2: 0000000000000008
[ 4364.014658][  T370] ---[ end trace 0000000000000000 ]---


>  					if (err == __SK_DROP)
>  						consume_skb(skb);
> -					ctx->recv_pkt = NULL;
> -					__strp_unpause(&ctx->strp);
>  					continue;
>  				}
>  			}
> @@ -1869,14 +1872,9 @@ int tls_sw_recvmsg(struct sock *sk,
>  		len -= chunk;
>  
>  		/* For async or peek case, queue the current skb */
> -		if (async || is_peek || retain_skb) {
> -			skb_queue_tail(&ctx->rx_list, skb);
> -			ctx->recv_pkt = NULL;
> -			__strp_unpause(&ctx->strp);
> -		} else {
> +		if (!(async || is_peek || retain_skb)) {
> +			skb_unlink(skb, &ctx->rx_list);
>  			consume_skb(skb);
> -			ctx->recv_pkt = NULL;
> -			__strp_unpause(&ctx->strp);
>  
>  			/* Return full control message to
>  			 * userspace before trying to parse
> -- 
> 2.34.1
> 

-- 
 Artem

