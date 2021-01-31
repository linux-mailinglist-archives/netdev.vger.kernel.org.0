Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0FA6309E94
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 21:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhAaTrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 14:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbhAaThj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 14:37:39 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D693CC061355
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 09:33:16 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id h192so16240153oib.1
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 09:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PQHXOzGu7y+0QIzFQLDWq5UApGnfDwCjwN5aeuGmz5s=;
        b=jhDsHVzWtgxlnt6MTMUU1sNfZyz9yU6F36A+UVx3CPIbDvXvb0Nd8Pj54s4GSb3wDR
         Qc/jQRnM4UQZweOMk4DBeLsgYs8w7sTS60xg/z54QpKUpcm5BLdHywsSt6HEaRqg/UNM
         WgURBNBOHz8drPr8nonSIHhdjxTzEkjfMm1Hj/jRnw5zLKHHngNtYF5L4WwFZgltdh0Q
         1gj+ZKNt047oakUDbNWS2Ryy/jqSpVhF6z5p1Ym98n1VLV443KeK1JoLJsDeM2ky0Rr2
         7XW7niKHtSHRFAwEAquQzNfyTsCWoGaVD2laU9qNe3YczYhIpmDcKUb6h4mMr46Vpymi
         1Zaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PQHXOzGu7y+0QIzFQLDWq5UApGnfDwCjwN5aeuGmz5s=;
        b=ag9t+wIxgSZZ3fAeV1IQnX4oikEnrd6x7FQWSAoMuM4eaf2lT2NpXDStfUlNBfCpHt
         hwswLQ17cmRFSbEDRl92ZDgDf/lnrDiE9VxuhtEvM3ssjKzX58RD9DZ2gyJ7bDFCJxTw
         O00LRb5F+SCtjrDIjCP3vL6kAW28NmNsaiFLdVnzqJlO3FZEB6f7OBEL+l/t7bHYb9r0
         yqJEORgNY3zDECCET+E++bztsLUc33NT91LCjsK2E1U+8BSeJN+YULcL1Mf3QMIwimZs
         3Tnt9xBfYAD+PpbLK5ZLMVS7X0F4bFr/pd2d8NXK4SjXUYrLmFZA4yWH3GaDeXtC6dUe
         cyGw==
X-Gm-Message-State: AOAM533vF7S757LKrwc1UfFK5+joaErIj37j/DlNpUwRJm/H2eUcw0WT
        6vdNOKlmhwJehaLa/+8QzteWZciZQ5w=
X-Google-Smtp-Source: ABdhPJzP6fT6dkLIHCpjdfyeHc/hyxeBWhqRvaW8ujoOkiqX/MmAQxikwAVbVjigQm14O6HNaQvgMg==
X-Received: by 2002:aca:31c2:: with SMTP id x185mr8502759oix.35.1612114396193;
        Sun, 31 Jan 2021 09:33:16 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id t2sm3530308otj.47.2021.01.31.09.33.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jan 2021 09:33:15 -0800 (PST)
Subject: Re: [PATCH] NET: SRv6: seg6_local: Fixed SRH processing when segments
 left is 0
To:     Suprit Japagal <suprit.japagal@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        David Lebrun <david.lebrun@uclouvain.be>
Cc:     netdev@vger.kernel.org
References: <20210131130840.32384-1-suprit.japagal@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5ac9c562-6bd6-1ab5-3504-b83dc58c15cc@gmail.com>
Date:   Sun, 31 Jan 2021 10:33:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210131130840.32384-1-suprit.japagal@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ cc David Lebrun, author of the original code ]

On 1/31/21 6:08 AM, Suprit Japagal wrote:
> From: "Suprit.Japagal" <suprit.japagal@gmail.com>
> 
> According to the standard IETF RFC 8754, section 4.3.1.1
> (https://tools.ietf.org/html/rfc8754#section-4.3.1.1)
> When the segments left in SRH equals to 0, proceed to process the
> next header in the packet, whose type is identified by the
> Next header field of the routing header.
> 
> Signed-off-by: Suprit.Japagal <suprit.japagal@gmail.com>
> ---
>  net/ipv6/seg6_local.c | 54 +++++++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 48 insertions(+), 6 deletions(-)
> 
> diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
> index b07f7c1..b17f9dc 100644
> --- a/net/ipv6/seg6_local.c
> +++ b/net/ipv6/seg6_local.c
> @@ -273,11 +273,25 @@ static int input_action_end(struct sk_buff *skb, struct seg6_local_lwt *slwt)
>  {
>  	struct ipv6_sr_hdr *srh;
>  
> -	srh = get_and_validate_srh(skb);
> +	srh = get_srh(skb);
>  	if (!srh)
>  		goto drop;
>  
> -	advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
> +#ifdef CONFIG_IPV6_SEG6_HMAC
> +	if (srh->segments_left > 0)
> +		if (!seg6_hmac_validate_skb(skb))
> +			goto drop;
> +#endif
> +
> +	if (srh->segments_left == 0) {
> +		if (!decap_and_validate(skb, srh->nexthdr))
> +			goto drop;
> +
> +		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
> +			goto drop;
> +	} else {
> +		advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
> +	}
>  
>  	seg6_lookup_nexthop(skb, NULL, 0);
>  
> @@ -293,11 +307,25 @@ static int input_action_end_x(struct sk_buff *skb, struct seg6_local_lwt *slwt)
>  {
>  	struct ipv6_sr_hdr *srh;
>  
> -	srh = get_and_validate_srh(skb);
> +	srh = get_srh(skb);
>  	if (!srh)
>  		goto drop;
>  
> -	advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
> +#ifdef CONFIG_IPV6_SEG6_HMAC
> +	if (srh->segments_left > 0)
> +		if (!seg6_hmac_validate_skb(skb))
> +			goto drop;
> +#endif
> +
> +	if (srh->segments_left == 0) {
> +		if (!decap_and_validate(skb, srh->nexthdr))
> +			goto drop;
> +
> +		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
> +			goto drop;
> +	} else {
> +		advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
> +	}
>  
>  	seg6_lookup_nexthop(skb, &slwt->nh6, 0);
>  
> @@ -312,11 +340,25 @@ static int input_action_end_t(struct sk_buff *skb, struct seg6_local_lwt *slwt)
>  {
>  	struct ipv6_sr_hdr *srh;
>  
> -	srh = get_and_validate_srh(skb);
> +	srh = get_srh(skb);
>  	if (!srh)
>  		goto drop;
>  
> -	advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
> +#ifdef CONFIG_IPV6_SEG6_HMAC
> +	if (srh->segments_left > 0)
> +		if (!seg6_hmac_validate_skb(skb))
> +			goto drop;
> +#endif
> +
> +	if (srh->segments_left == 0) {
> +		if (!decap_and_validate(skb, srh->nexthdr))
> +			goto drop;
> +
> +		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
> +			goto drop;
> +	} else {
> +		advance_nextseg(srh, &ipv6_hdr(skb)->daddr);
> +	}
>  
>  	seg6_lookup_nexthop(skb, NULL, slwt->table);
>  
> 

