Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A88D566505
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 10:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiGEIZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 04:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiGEIZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 04:25:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D00B1E9
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 01:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657009552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xAcs4uI2D9ndZkKQdA+a/49FdnR9QR+eumc/VDmA6z0=;
        b=IwS91fWv7iO5bP1vaLUoQd8wf9OWARojoGZjmxxOXobUl39JuQekbUDxRQZgWxSd8X3AP7
        aXZXjBp5y7UBYF66IxVJoP8ytKFFj5/zI+CbF/CqMHQzOFjBK+hnwpiAat64APRFn6cnzB
        pPF2QvzBrGx0LTsIjlpUXWT3CEaD9ec=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-9TLzcW5PNAa_GpZY_P2NaA-1; Tue, 05 Jul 2022 04:25:50 -0400
X-MC-Unique: 9TLzcW5PNAa_GpZY_P2NaA-1
Received: by mail-wm1-f72.google.com with SMTP id bg6-20020a05600c3c8600b003a03d5d19e4so6468301wmb.1
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 01:25:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=xAcs4uI2D9ndZkKQdA+a/49FdnR9QR+eumc/VDmA6z0=;
        b=HdQJgwPX+lQfZCas+lTlFnIQAX40WC7h0I+geygsrWLyLOkOaEpNtnzcpzkAnjDbIK
         a0DBhRC5TpiYmXcNT+VOuo7j+pfQra/3s/CAHxQkP63UcicjnkPqGwCGrGe3gUNwjQD8
         s1CI2xV9COuDsB6dMSAMTzJjjHU7HRiHszx4XooNar0qhddfjkL78Xi301G768bdnLhu
         pNBCjK/9tCmzurcsEF4buCxq7OcXjWWV4L9CU3+wKDn03Qz6QLy4ia3sW0Sp8EiAw5lx
         VXFhv5ZPD7JidhDXfDArc3TqEJeURi9+ph91Iqu7R/kZ3ufng91ZR8GIPUEbRQMqwVTg
         Di3g==
X-Gm-Message-State: AJIora/2F+vBP+OwF0ZRhDRqVHL6kUN1YgaRB5NR+JR76ty0NGcggJkP
        ecakHhC+cPhUTd5E+/DQUfbvI6dbulr54XU8asIRwys5T6HFfDhXV7EVn0SMfzxofHe74W5nvfk
        h/YUxNdUwl78WLEc+
X-Received: by 2002:a5d:4382:0:b0:21b:8c03:639f with SMTP id i2-20020a5d4382000000b0021b8c03639fmr31398635wrq.406.1657009549658;
        Tue, 05 Jul 2022 01:25:49 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vWtkjq8AjSeGOvuG6SZGB7iTMzsl14ms9EYp0tO9xmVGRVz86gratsuVxdCGmqGDDBRyDFCg==
X-Received: by 2002:a5d:4382:0:b0:21b:8c03:639f with SMTP id i2-20020a5d4382000000b0021b8c03639fmr31398610wrq.406.1657009549406;
        Tue, 05 Jul 2022 01:25:49 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-106-148.dyn.eolo.it. [146.241.106.148])
        by smtp.gmail.com with ESMTPSA id d10-20020adff2ca000000b0021a38089e99sm32208030wrp.57.2022.07.05.01.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 01:25:48 -0700 (PDT)
Message-ID: <7dc20590ff5ab471a6cd94a6cc63bb2459782706.camel@redhat.com>
Subject: Re: [PATCH v2] net-tcp: Find dst with sk's xfrm policy not ctl_sk
From:   Paolo Abeni <pabeni@redhat.com>
To:     Sewook Seo <ssewook@gmail.com>, Sewook Seo <sewookseo@google.com>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Maciej =?UTF-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sehee Lee <seheele@google.com>
Date:   Tue, 05 Jul 2022 10:25:47 +0200
In-Reply-To: <20220701154413.868096-1-ssewook@gmail.com>
References: <20220621202240.4182683-1-ssewook@gmail.com>
         <20220701154413.868096-1-ssewook@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, 2022-07-01 at 15:44 +0000, Sewook Seo wrote:
> From: sewookseo <sewookseo@google.com>
> 
> If we set XFRM security policy by calling setsockopt with option
> IPV6_XFRM_POLICY, the policy will be stored in 'sock_policy' in 'sock'
> struct. However tcp_v6_send_response doesn't look up dst_entry with the
> actual socket but looks up with tcp control socket. This may cause a
> problem that a RST packet is sent without ESP encryption & peer's TCP
> socket can't receive it.
> This patch will make the function look up dest_entry with actual socket,
> if the socket has XFRM policy(sock_policy), so that the TCP response
> packet via this function can be encrypted, & aligned on the encrypted
> TCP socket.
> 
> Tested: We encountered this problem when a TCP socket which is encrypted
> in ESP transport mode encryption, receives challenge ACK at SYN_SENT
> state. After receiving challenge ACK, TCP needs to send RST to
> establish the socket at next SYN try. But the RST was not encrypted &
> peer TCP socket still remains on ESTABLISHED state.
> So we verified this with test step as below.
> [Test step]
> 1. Making a TCP state mismatch between client(IDLE) & server(ESTABLISHED).
> 2. Client tries a new connection on the same TCP ports(src & dst).
> 3. Server will return challenge ACK instead of SYN,ACK.
> 4. Client will send RST to server to clear the SOCKET.
> 5. Client will retransmit SYN to server on the same TCP ports.
> [Expected result]
> The TCP connection should be established.
> 
> Effort: net-tcp

This looks like a stray "internal" tag?

> Cc: Maciej Żenczykowski <maze@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: Sehee Lee <seheele@google.com>
> Signed-off-by: Sewook Seo <sewookseo@google.com>

Is this targeting -net -or -net-next? IMHO this could land in either
trees. If you are targting net, please add a suitable Fixes: tag.


> ---
> Changelog since v1:
> - Remove unnecessary null check of sk at ip_output.c
>   Narrow down patch scope: sending RST at SYN_SENT state
>   Remove unnecessay condition to call xfrm_sk_free_policy()
>   Verified at KASAN build
> 
>  net/ipv4/ip_output.c | 7 ++++++-
>  net/ipv4/tcp_ipv4.c  | 5 +++++
>  net/ipv6/tcp_ipv6.c  | 7 ++++++-
>  3 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 00b4bf26fd93..1da430c8fee2 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -1704,7 +1704,12 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
>  			   tcp_hdr(skb)->source, tcp_hdr(skb)->dest,
>  			   arg->uid);
>  	security_skb_classify_flow(skb, flowi4_to_flowi_common(&fl4));
> -	rt = ip_route_output_key(net, &fl4);
> +#ifdef CONFIG_XFRM
> +	if (sk->sk_policy[XFRM_POLICY_OUT])
> +		rt = ip_route_output_flow(net, &fl4, sk);
> +	else
> +#endif
> +		rt = ip_route_output_key(net, &fl4);
>  	if (IS_ERR(rt))
>  		return;
>  
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index fda811a5251f..459669f9e13f 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -819,6 +819,10 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
>  		ctl_sk->sk_priority = (sk->sk_state == TCP_TIME_WAIT) ?
>  				   inet_twsk(sk)->tw_priority : sk->sk_priority;
>  		transmit_time = tcp_transmit_time(sk);
> +#ifdef CONFIG_XFRM
> +		if (sk->sk_policy[XFRM_POLICY_OUT] && sk->sk_state == TCP_SYN_SENT)
> +			xfrm_sk_clone_policy(ctl_sk, sk);
> +#endif

It looks like the cloned policy will be overwrited by later resets and
possibly leaked? nobody calls xfrm_sk_free_policy() on the old policy.

Thanks!

Paolo

