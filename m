Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3CD2AC289
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 18:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732102AbgKIRhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 12:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729723AbgKIRhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 12:37:42 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BFFC0613CF;
        Mon,  9 Nov 2020 09:37:42 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id r17so5718174wrw.1;
        Mon, 09 Nov 2020 09:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2mg6hdTFKBAP/XEWuXhZe5qjYQilvjRccoHsB6cLuSo=;
        b=gOncIsc2uSf8Y/0XgShdWgdFYAl69e+NUURJ1GklcQLgK4ILvYDkkZ7ycmRMXjSFYR
         1TXnpIenOWfIgf+txKPO6UKcrbX+2n94O/1egkcOUzHLss3yBBEKIgwYqdrhKp2JlyxR
         nBmhTklk3WZBMKrzTlWOrTCEi6d657r7WrBfVd2AZt+iFLRAVhp2998ZgMhXVgTdtet2
         qtOdN1K0G+fDg5UVvQ7DgbjYZZ8GCoLnVeN94MtjVjAdca3qpIqKsxa9t2W9DN24tlQg
         Ytf9poMmtsNrinwOyEIKzLPXjHoaI5GWFzzWbwG+yv8VRQHxkoKmUgRcfuz9nlF9y03r
         QxMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2mg6hdTFKBAP/XEWuXhZe5qjYQilvjRccoHsB6cLuSo=;
        b=RUgb+Mc22/3oRDgAkRtQvXyZFiAJdM6LCc6uDfqQBkpA61Z3FrF/QoMUXG9YYDFqFS
         CWgLBTdY1XgXtYPdThDJ+ZjtDbWTN1kTZrEAibr7zDmvXrDtYTmZ0GS9M9Q8MluotXtx
         7X3xxuWfMSWrpQq0K5FbA/PmB4HlJuyKvtHMtf1Uw8GAEBARpaFvWlXGgGb9jJ2CPGXY
         1W+5d03vqL7J7zSF+bCbtrB4eirOL5g5kos1NgKxrAJmYkLDYMYKaSbV0laRdP5rk+/5
         QEna3ogOyCQUygFScG2s6uSY3zbpqWPxzfNzxDE7XGBhpft+1b8AzsK1ZmjEGkrx9fab
         lbKQ==
X-Gm-Message-State: AOAM533rIkVdgBHX/r0RpD6p9HC0MaeR41LVOxCqF9QOkJEJK9Y93OVa
        GkW6riv0DC89IzTuzrulVjrQKOrTvHk=
X-Google-Smtp-Source: ABdhPJx+3zG93RfEPCdlXNi7AlXH+fPq6l0PQvXKjhYbn6TPAlupvvIszTAgt4jEyST2HyhOyQo5gQ==
X-Received: by 2002:adf:f3c7:: with SMTP id g7mr20529226wrp.394.1604943460930;
        Mon, 09 Nov 2020 09:37:40 -0800 (PST)
Received: from [192.168.8.114] ([37.170.31.34])
        by smtp.gmail.com with ESMTPSA id u23sm127692wmc.32.2020.11.09.09.37.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 09:37:40 -0800 (PST)
Subject: Re: [PATCH v2 net] net: udp: fix Fast/frag0 UDP GRO
To:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <0eaG8xtbtKY1dEKCTKUBubGiC9QawGgB3tVZtNqVdY@cp4-web-030.plabs.ch>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d9d09931-8cd3-1eb6-673c-3ae5ebc3ee57@gmail.com>
Date:   Mon, 9 Nov 2020 18:37:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <0eaG8xtbtKY1dEKCTKUBubGiC9QawGgB3tVZtNqVdY@cp4-web-030.plabs.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/9/20 5:56 PM, Alexander Lobakin wrote:
> While testing UDP GSO fraglists forwarding through driver that uses
> Fast GRO (via napi_gro_frags()), I was observing lots of out-of-order
> iperf packets:
> 
> [ ID] Interval           Transfer     Bitrate         Jitter
> [SUM]  0.0-40.0 sec  12106 datagrams received out-of-order
> 
> Simple switch to napi_gro_receive() any other method without frag0
> shortcut completely resolved them.
> 
> I've found that UDP GRO uses udp_hdr(skb) in its .gro_receive()
> callback. While it's probably OK for non-frag0 paths (when all
> headers or even the entire frame are already in skb->data), this
> inline points to junk when using Fast GRO (napi_gro_frags() or
> napi_gro_receive() with only Ethernet header in skb->data and all
> the rest in shinfo->frags) and breaks GRO packet compilation and
> the packet flow itself.
> To support both modes, skb_gro_header_fast() + skb_gro_header_slow()
> are typically used. UDP even has an inline helper that makes use of
> them, udp_gro_udphdr(). Use that instead of troublemaking udp_hdr()
> to get rid of the out-of-order delivers.
> 
> Present since the introduction of plain UDP GRO in 5.0-rc1.
> 
> Since v1 [1]:
>  - added a NULL pointer check for "uh" as suggested by Willem.
> 
> [1] https://lore.kernel.org/netdev/YazU6GEzBdpyZMDMwJirxDX7B4sualpDG68ADZYvJI@cp4-web-034.plabs.ch
> 
> Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  net/ipv4/udp_offload.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index e67a66fbf27b..7f6bd221880a 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -366,13 +366,18 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
>  static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
>  					       struct sk_buff *skb)
>  {
> -	struct udphdr *uh = udp_hdr(skb);
> +	struct udphdr *uh = udp_gro_udphdr(skb);
>  	struct sk_buff *pp = NULL;
>  	struct udphdr *uh2;
>  	struct sk_buff *p;
>  	unsigned int ulen;
>  	int ret = 0;
>  
> +	if (unlikely(!uh)) {

How uh could be NULL here ?

My understanding is that udp_gro_receive() is called
only after udp4_gro_receive() or udp6_gro_receive()
validated that udp_gro_udphdr(skb) was not NULL.


> +		NAPI_GRO_CB(skb)->flush = 1;
> +		return NULL;
> +	}
> +
>  	/* requires non zero csum, for symmetry with GSO */
>  	if (!uh->check) {
>  		NAPI_GRO_CB(skb)->flush = 1;
> 

Why uh2 is left unchanged ?

    uh2 = udp_hdr(p);

...

