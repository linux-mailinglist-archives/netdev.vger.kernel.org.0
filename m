Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8BE6543F0
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 16:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbiLVPIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 10:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235996AbiLVPHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 10:07:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4737A23E9F
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 07:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671721568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G2Z+e3lpRTRMfr3QLon/NWineem6j5xBVR3FbcUSdc8=;
        b=DFwhu3v4QzdKy16DHh9MFmqOxb+Y9B3vfBC6QfaYZEi2fFLnqDHe+oAKLKzHLgOs2iMznW
        h9aAbSmqZoK0jZUGdpBhlOHR9WcBgeEzq7jOyz/8MOwn8ULtJ5Gn3QCyzcy9NTM0cyEnF+
        HGepki9xHHE9GSDWmtERPf/YMPb3f6c=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-547-9d5dqPHvMyiUb6S1m-cB1w-1; Thu, 22 Dec 2022 10:06:02 -0500
X-MC-Unique: 9d5dqPHvMyiUb6S1m-cB1w-1
Received: by mail-yb1-f199.google.com with SMTP id x188-20020a2531c5000000b00716de19d76bso2170493ybx.19
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 07:06:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G2Z+e3lpRTRMfr3QLon/NWineem6j5xBVR3FbcUSdc8=;
        b=bXAa6hs6ohNpVHldeaihsq7lzKhTY7iZBhdFIua6MzmlNXfxWCIBKRL/DCQ7pAJRKF
         Xq3V6IY5FUTfYRCHm7X/S6q50LpszdTX2IBzYx68SN+JIWtc1WeeNfqV5mEjOiaq3Mwl
         9hD+wrGDfY/1BwLPM7T03m3UpLHE4cBC5Rlr+n9ZwI9TQpUo+q2acEIFMv7aKsR6uVds
         yNfvGpqVb4RnWDscm+0T4ySuS7u7hVZW2U6Jn7bWH3BjhN16JwXsjMVtHOr5MmVayiya
         Bo78nfpRzuUeJwxisihGESX5xxxrV2JaAMUQLdv1bl9ljvi6IJTSeN6kmBC7AK1fsQOj
         +bfw==
X-Gm-Message-State: AFqh2kqM1aaF4GwLu8EyMOPAo64dasd2o1xeh4yLoz6xhpS0s1M5gaOc
        AtfA3edrbqx3Tu04/qQ0B4zWpPFOr6eKiyVRJvTzacOZ0ilyYcAo6zJSr1N9wBZOuO+REdqgzvf
        luav9v51y6UeQVpcz
X-Received: by 2002:a05:7508:2582:b0:47:bbd:b4fe with SMTP id h2-20020a057508258200b000470bbdb4femr1255554gbc.2.1671721561248;
        Thu, 22 Dec 2022 07:06:01 -0800 (PST)
X-Google-Smtp-Source: AMrXdXu30kZL1Qg9ASZEzxw13Wsbmt3IVuc9abLc/d3475Ex8SBodtfWUocXsKoaOLoLnThWmtY7yQ==
X-Received: by 2002:a05:7508:2582:b0:47:bbd:b4fe with SMTP id h2-20020a057508258200b000470bbdb4femr1255509gbc.2.1671721560759;
        Thu, 22 Dec 2022 07:06:00 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-101-173.dyn.eolo.it. [146.241.101.173])
        by smtp.gmail.com with ESMTPSA id i25-20020a05620a0a1900b006b615cd8c13sm400458qka.106.2022.12.22.07.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 07:06:00 -0800 (PST)
Message-ID: <95544fb4dd85d5acaca883bb8bae0e43821758bd.camel@redhat.com>
Subject: Re: [PATCH RFC net 1/2] tcp: Add TIME_WAIT sockets in bhash2.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
Date:   Thu, 22 Dec 2022 16:05:56 +0100
In-Reply-To: <20221221151258.25748-2-kuniyu@amazon.com>
References: <20221221151258.25748-1-kuniyu@amazon.com>
         <20221221151258.25748-2-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-12-22 at 00:12 +0900, Kuniyuki Iwashima wrote:
> Jiri Slaby reported regression of bind() with a simple repro. [0]
> 
> The repro creates a TIME_WAIT socket and tries to bind() a new socket
> with the same local address and port.  Before commit 28044fc1d495 ("net:
> Add a bhash2 table hashed by port and address"), the bind() failed with
> -EADDRINUSE, but now it succeeds.
> 
> The cited commit should have put TIME_WAIT sockets into bhash2; otherwise,
> inet_bhash2_conflict() misses TIME_WAIT sockets when validating bind()
> requests if the address is not a wildcard one.

How does keeping the timewait sockets inside bhash2 affect the bind
loopup performance? I fear that could defeat completely the goal of
28044fc1d495, on quite busy server we could have quite a bit of tw with
the same address/port. If so, we could even consider reverting
28044fc1d495.

> [0]: https://lore.kernel.org/netdev/6b971a4e-c7d8-411e-1f92-fda29b5b2fb9@kernel.org/
> 
> Fixes: 28044fc1d495 ("net: Add a bhash2 table hashed by port and address")
> Reported-by: Jiri Slaby <jirislaby@kernel.org>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  include/net/inet_timewait_sock.h |  2 ++
>  include/net/sock.h               |  5 +++--
>  net/ipv4/inet_hashtables.c       |  5 +++--
>  net/ipv4/inet_timewait_sock.c    | 31 +++++++++++++++++++++++++++++--
>  4 files changed, 37 insertions(+), 6 deletions(-)
> 
> diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
> index 5b47545f22d3..c46ed239ad9a 100644
> --- a/include/net/inet_timewait_sock.h
> +++ b/include/net/inet_timewait_sock.h
> @@ -44,6 +44,7 @@ struct inet_timewait_sock {
>  #define tw_bound_dev_if		__tw_common.skc_bound_dev_if
>  #define tw_node			__tw_common.skc_nulls_node
>  #define tw_bind_node		__tw_common.skc_bind_node
> +#define tw_bind2_node		__tw_common.skc_bind2_node
>  #define tw_refcnt		__tw_common.skc_refcnt
>  #define tw_hash			__tw_common.skc_hash
>  #define tw_prot			__tw_common.skc_prot
> @@ -73,6 +74,7 @@ struct inet_timewait_sock {
>  	u32			tw_priority;
>  	struct timer_list	tw_timer;
>  	struct inet_bind_bucket	*tw_tb;
> +	struct inet_bind2_bucket	*tw_tb2;
>  };
>  #define tw_tclass tw_tos
>  
> diff --git a/include/net/sock.h b/include/net/sock.h
> index dcd72e6285b2..aaec985c1b5b 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -156,6 +156,7 @@ typedef __u64 __bitwise __addrpair;
>   *	@skc_tw_rcv_nxt: (aka tw_rcv_nxt) TCP window next expected seq number
>   *		[union with @skc_incoming_cpu]
>   *	@skc_refcnt: reference count
> + *	@skc_bind2_node: bind node in the bhash2 table
>   *
>   *	This is the minimal network layer representation of sockets, the header
>   *	for struct sock and struct inet_timewait_sock.
> @@ -241,6 +242,7 @@ struct sock_common {
>  		u32		skc_window_clamp;
>  		u32		skc_tw_snd_nxt; /* struct tcp_timewait_sock */
>  	};
> +	struct hlist_node	skc_bind2_node;

I *think* it would be better adding a tw_bind2_node field to the
inet_timewait_sock struct, so that we leave unmodified the request
socket and we don't change the struct sock binary layout. That could
affect performances moving hot fields on different cachelines.


Thanks,

Paolo

