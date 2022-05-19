Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBE452CC15
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 08:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiESGmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 02:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiESGmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 02:42:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26982E0C
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 23:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652942560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XlTlmOwilrqD3cHVhZ9FBZQAvJeiR+NCJ9hretUDHmw=;
        b=aZIfgbo/knncs2zhhrr9gVbAofpkoK8uGwoczDb/HempUQMv3EvsQ39Y7OpSOCnkElSoPc
        Nt35nrcI6qPkoxtcbuSTpEWkZV9d8scFzlfXeCUwF9oi+q6t+AJvR4Edm0QGc4D2Jfs1Wn
        4mYGsQ9mA9/moTzbfbajBI5c47n82sw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-265-zXkUmuGIOsqo7WPQ7x8Y9w-1; Thu, 19 May 2022 02:42:36 -0400
X-MC-Unique: zXkUmuGIOsqo7WPQ7x8Y9w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAE071C05145;
        Thu, 19 May 2022 06:42:35 +0000 (UTC)
Received: from samus.usersys.redhat.com (unknown [10.43.17.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F462492C14;
        Thu, 19 May 2022 06:42:34 +0000 (UTC)
Date:   Thu, 19 May 2022 08:42:32 +0200
From:   Artem Savkov <asavkov@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, borisp@nvidia.com, john.fastabend@gmail.com,
        daniel@iogearbox.net
Subject: Re: [PATCH net-next] net: tls: fix messing up lists when bpf enabled
Message-ID: <YoXm2MIxa6XOvUZe@samus.usersys.redhat.com>
References: <20220518205644.2059468-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220518205644.2059468-1-kuba@kernel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 01:56:44PM -0700, Jakub Kicinski wrote:
> Artem points out that skb may try to take over the skb and
                        ^^^ I think you meant "bpf"

> queue it to its own list. Unlink the skb before calling out.
> 
> Fixes: b1a2c1786330 ("tls: rx: clear ctx->recv_pkt earlier")
> Reported-by: Artem Savkov <asavkov@redhat.com>
Tested-by: Artem Savkov <asavkov@redhat.com>

> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: borisp@nvidia.com
> CC: john.fastabend@gmail.com
> CC: daniel@iogearbox.net
> ---
>  net/tls/tls_sw.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 939d1673f508..0513f82b8537 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -1837,15 +1837,17 @@ int tls_sw_recvmsg(struct sock *sk,
>  			bool partially_consumed = chunk > len;
>  
>  			if (bpf_strp_enabled) {
> +				/* BPF may try to queue the skb */
> +				__skb_unlink(skb, &ctx->rx_list);
>  				err = sk_psock_tls_strp_read(psock, skb);
>  				if (err != __SK_PASS) {
>  					rxm->offset = rxm->offset + rxm->full_len;
>  					rxm->full_len = 0;
> -					__skb_unlink(skb, &ctx->rx_list);
>  					if (err == __SK_DROP)
>  						consume_skb(skb);
>  					continue;
>  				}
> +				__skb_queue_tail(&ctx->rx_list, skb);
>  			}
>  
>  			if (partially_consumed)
> -- 
> 2.34.3
> 

-- 
 Artem

