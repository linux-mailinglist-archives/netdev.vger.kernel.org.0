Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE18A63EC93
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 10:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiLAJcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 04:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiLAJcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 04:32:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05D7900E6
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 01:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669887061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u/iFWcb6lk61NYrGYwPNwjbI1wwMR1ABxD7gcOpCxTQ=;
        b=ATWss8eCe1KOpQaTLdFJyWrlwQ/GFNVcaGr+8hoIbpc0A1ON5c14c6wijblvK8eVcsLYIp
        ji1lY3izqa6V+4lHZiqzvIFhPg/5KAY8byLx42aGSfXZRRwPd/sMiUmG+INV1k9Yx8yEdb
        Til1CW21TiYfoHfStA+1kjG/RsECDwU=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-459-0Bk-GQlPPMW13BrIDEuV-g-1; Thu, 01 Dec 2022 04:31:00 -0500
X-MC-Unique: 0Bk-GQlPPMW13BrIDEuV-g-1
Received: by mail-qt1-f199.google.com with SMTP id k1-20020ac84781000000b003a6894cdd5eso2988526qtq.14
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 01:30:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u/iFWcb6lk61NYrGYwPNwjbI1wwMR1ABxD7gcOpCxTQ=;
        b=Jdeet7nryPmCWEATCD6FqkQDdUuHXnU6GEBefXI9qlLfUi6UAl7VseV/Z6faUXOaR8
         2TqIfRxOrFII1BqBJIq+nbMq5xnfN0IB6fMDThHdYuvNEbC/l8U+YFFxrdQ7B4RRaX4G
         j9ORLXYwq5P733KiyWaDzrBNKz1sgk3z2XMH8Q+N7S0kw3NMLjpMM1abl2Cx+vSmu9i9
         m5L4l8Fi3oXqevyb0eDz0CmCB7VhVQYbk5cKFq9ucnoQXTULJXdx2tXhfOZ4SvUnF9+S
         bwTou0ythpDDMnsnkimVAEEAR/kY7/jGWz9iCtd+NhMd5erjHZ8r94qUx4KBMeHsmX/U
         YGhg==
X-Gm-Message-State: ANoB5plCgi5gL+8mtgK+bGcGW8QtcAusqWlfeCOnksSVIWmzYlf7DVFw
        OX637YDt1HwxfC8xvCBz2K3sM8g3H5G2rBO0ihUZ+VDt6DmVyoqHDw3nWIYzqBozmQPsBbbw9Xa
        8hUH9hDOIXuGnBo2h
X-Received: by 2002:a05:620a:1466:b0:6fc:9f27:751c with SMTP id j6-20020a05620a146600b006fc9f27751cmr4769323qkl.581.1669887059042;
        Thu, 01 Dec 2022 01:30:59 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6ObInhKxnj+Y8OIfwAyq8W7j4ejraBLHWb4dyLVbolMXGenjKm5xLcYanZOa6a9oq8denEYg==
X-Received: by 2002:a05:620a:1466:b0:6fc:9f27:751c with SMTP id j6-20020a05620a146600b006fc9f27751cmr4769304qkl.581.1669887058806;
        Thu, 01 Dec 2022 01:30:58 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id g8-20020a05620a40c800b006cebda00630sm3334156qko.60.2022.12.01.01.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 01:30:58 -0800 (PST)
Message-ID: <7f1277b54a76280cfdaa25d0765c825d665146b9.camel@redhat.com>
Subject: Re: [PATCH net v2] unix: Fix race in SOCK_SEQPACKET's
 unix_dgram_sendmsg()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kirill Tkhai <tkhai@ya.ru>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Date:   Thu, 01 Dec 2022 10:30:55 +0100
In-Reply-To: <bd4d533b-15d2-6c0a-7667-70fd95dbea20@ya.ru>
References: <bd4d533b-15d2-6c0a-7667-70fd95dbea20@ya.ru>
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

On Sun, 2022-11-27 at 01:46 +0300, Kirill Tkhai wrote:
> There is a race resulting in alive SOCK_SEQPACKET socket
> may change its state from TCP_ESTABLISHED to TCP_CLOSE:
> 
> unix_release_sock(peer)                  unix_dgram_sendmsg(sk)
>   sock_orphan(peer)
>     sock_set_flag(peer, SOCK_DEAD)
>                                            sock_alloc_send_pskb()
>                                              if !(sk->sk_shutdown & SEND_SHUTDOWN)
>                                                OK
>                                            if sock_flag(peer, SOCK_DEAD)
>                                              sk->sk_state = TCP_CLOSE
>   sk->sk_shutdown = SHUTDOWN_MASK
> 
> 
> After that socket sk remains almost normal: it is able to connect, listen, accept
> and recvmsg, while it can't sendmsg.
> 
> Since this is the only possibility for alive SOCK_SEQPACKET to change
> the state in such way, we should better fix this strange and potentially
> danger corner case.
> 
> Also, move TCP_CLOSE assignment for SOCK_DGRAM sockets under state lock
> to fix race with unix_dgram_connect():
> 
> unix_dgram_connect(other)            unix_dgram_sendmsg(sk)
>                                        unix_peer(sk) = NULL
>                                        unix_state_unlock(sk)
>   unix_state_double_lock(sk, other)
>   sk->sk_state  = TCP_ESTABLISHED
>   unix_peer(sk) = other
>   unix_state_double_unlock(sk, other)
>                                        sk->sk_state  = TCP_CLOSED
> 
> This patch fixes both of these races.
> 
> Fixes: 83301b5367a9 ("af_unix: Set TCP_ESTABLISHED for datagram sockets too")

I don't think this commmit introduces the issues, both behavior
described above appear to be present even before?


Thank!

Paolo

