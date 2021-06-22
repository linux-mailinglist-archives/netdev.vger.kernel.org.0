Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372863B00F2
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 12:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhFVKJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 06:09:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27462 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229490AbhFVKJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 06:09:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624356451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CTyYFtUo7DXlPqn2/2ZO1xGoB9VIXcRUOYILpRn3xFI=;
        b=LXos4pZOf1Xd9AzEPRwwvUk0hYyZufy2uzEvBQNIIvy0+cmDZlVV00Y/ji2xxUd7jioJrC
        G6HMxQC4bqSwaPVc/1/rH4K9rtVR1oXi/us9E3m4LBZ2xOif24ShjMJT+th0lab04BN32v
        oiDwTeIjglYfhwbpWGizR0ZlLIo1KPY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-ajFqi97vPz2bG30ro9irZw-1; Tue, 22 Jun 2021 06:07:30 -0400
X-MC-Unique: ajFqi97vPz2bG30ro9irZw-1
Received: by mail-wr1-f72.google.com with SMTP id d8-20020adfef880000b029011a9391927aso3216377wro.22
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 03:07:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=CTyYFtUo7DXlPqn2/2ZO1xGoB9VIXcRUOYILpRn3xFI=;
        b=BcSonqhp6SFha8X7aX9XqHsAU7/BbtdP/c4gxP+Ofgdk3Sa0IzPy/590DuDz4IXjm+
         F1iSmQ52lH3NIxoH1iVcgy+rwdcSPE528pAgmwhGFtJ+gWC0qUFuJ96krda0niDmR+8a
         HBIn6xhTWDoDPQv0zwDaTloZZ+spx/sePgrIGE3AoTzScgJWlHFN5hU1C9etzwxPqtuv
         Uo34ZJTdg22qdUcjf5cd9BsgosS30m+NsEXKx0mq9yjr1eCOav8VT7xaMVbrft9/ai1N
         awrrZ+iT+8ZTyM67IRUP/b8WH5yCuJ9pdf//sQHnRqIFKEJbkE65juL9FPwqE8euQxv1
         iDig==
X-Gm-Message-State: AOAM532EtlPTmAhKWrNAr3AFjWuOQvqnPrEZqcdqUGpjOMz8ZSTliIAX
        J/MblbPVAi8ow9qLN4kR80YccHRFI4HllelPtKdm0E+cbmS+JvNfvXSzECZSgyDal17VP3gIlp9
        2Rrba2ViRfdYwJr0/
X-Received: by 2002:a1c:a445:: with SMTP id n66mr3587323wme.140.1624356448941;
        Tue, 22 Jun 2021 03:07:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxocBBcD3RcoZQhtw9d9pcPwlIGpegAVcvjMI2iF8OY13AZ5TpHihpChymHcKQQ05gky8LNfg==
X-Received: by 2002:a1c:a445:: with SMTP id n66mr3587307wme.140.1624356448754;
        Tue, 22 Jun 2021 03:07:28 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-109-224.dyn.eolo.it. [146.241.109.224])
        by smtp.gmail.com with ESMTPSA id v1sm11315059wru.61.2021.06.22.03.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 03:07:28 -0700 (PDT)
Message-ID: <fe0640023aa1142300651a32833ec44340b62943.camel@redhat.com>
Subject: Re: [PATCH net-next] ip: avoid OOM kills with large UDP sends over
 loopback
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, eric.dumazet@gmail.com,
        dsahern@gmail.com, yoshfuji@linux-ipv6.org, Dave Jones <dsj@fb.com>
Date:   Tue, 22 Jun 2021 12:07:27 +0200
In-Reply-To: <20210621231307.1917413-1-kuba@kernel.org>
References: <20210621231307.1917413-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-06-21 at 16:13 -0700, Jakub Kicinski wrote:
> Dave observed number of machines hitting OOM on the UDP send
> path. The workload seems to be sending large UDP packets over
> loopback. Since loopback has MTU of 64k kernel will try to
> allocate an skb with up to 64k of head space. This has a good
> chance of failing under memory pressure. What's worse if
> the message length is <32k the allocation may trigger an
> OOM killer.

Out of sheer curiosity, are there a large number of UDP sockets in such
workload? did you increase rmem_default/rmem_max? If so, could tuning
udp_mem help?

> include/net/sock.h    | 11 +++++++++++
>  net/ipv4/ip_output.c  | 19 +++++++++++++++++--
>  net/ipv6/ip6_output.c | 19 +++++++++++++++++--
>  3 files changed, 45 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 7a7058f4f265..4134fb718b97 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -924,6 +924,17 @@ static inline gfp_t sk_gfp_mask(const struct sock *sk, gfp_t gfp_mask)
>  	return gfp_mask | (sk->sk_allocation & __GFP_MEMALLOC);
>  }
>  
> +static inline void sk_allocation_push(struct sock *sk, gfp_t flag, gfp_t *old)
> +{
> +	*old = sk->sk_allocation;
> +	sk->sk_allocation |= flag;
> +}
> +
> +static inline void sk_allocation_pop(struct sock *sk, gfp_t old)
> +{
> +	sk->sk_allocation = old;
> +}
> +
>  static inline void sk_acceptq_removed(struct sock *sk)
>  {
>  	WRITE_ONCE(sk->sk_ack_backlog, sk->sk_ack_backlog - 1);
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index c3efc7d658f6..a300c2c65d57 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -1095,9 +1095,24 @@ static int __ip_append_data(struct sock *sk,
>  				alloclen += rt->dst.trailer_len;
>  
>  			if (transhdrlen) {
> -				skb = sock_alloc_send_skb(sk,
> -						alloclen + hh_len + 15,
> +				size_t header_len = alloclen + hh_len + 15;
> +				gfp_t sk_allocation;
> +
> +				if (header_len > PAGE_SIZE)
> +					sk_allocation_push(sk, __GFP_NORETRY,
> +							   &sk_allocation);

Could an additional __GFP_NOWARN be relevant here?

Thanks!

Paolo

