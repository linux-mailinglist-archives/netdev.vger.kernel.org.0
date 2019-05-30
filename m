Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09CAA300D0
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 19:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfE3RRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 13:17:07 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42874 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfE3RRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 13:17:07 -0400
Received: by mail-pg1-f196.google.com with SMTP id e6so1130575pgd.9;
        Thu, 30 May 2019 10:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=bNE39eRqZdSpT9RvxiKlg9hyxVS+PZXMDoR6uxMzz78=;
        b=GPwDOuY6sotWaA5gMqPD2xoe9iaW5HBDmhFsFqf+W6weVeLDOPJxjF1/6HHDz8Hoo/
         QMQDo2h5X/Y2jpS574nR2DtnBkji+LiwsrYrrF9fZY+2R0n8MURf8CCEeQerwhMnEQqN
         bqdVblu4bg1T4GIlT3F+DHbrKv3P5zIk4QT/GJ7RYMQg451VwI5VeBBFUjry/wejtNl4
         z7gAqcTtK2D63TQR45atYV2Pzd+KhQSZ5LTPGO1mZgwg5Xx2O5W0hG6sAGkjnJigFvdR
         97FiI8jXM/qLRcLHNvJ0QKtc13Hw63H7XUsF6tFbOAN/dztUHtl3ECmwcbtQVAP+UJGx
         x5+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bNE39eRqZdSpT9RvxiKlg9hyxVS+PZXMDoR6uxMzz78=;
        b=tRXg9moId0z1Ite1yKO/wu8CXeLbdAB8huTUoQ1pzX/6IE4W6HZK9EcBAaOX0reez+
         RfsIpaOkNVow/6nLurNC3dhUxn2b7NBBWGl3G5LYMqJ/kLHHCLMs4+bfsfpSC35VFYsu
         WBomNKcRPMnYgoJOmyXBVBRvSew8KSWS9OxCThtJvvIsJ7PjFcfbxfrT9WO/zH/nvOfE
         fARBnuWWSK8sGMcWCWQCuMVnAnYP4r/RNrafdp8LgOWQRYMMxxRJjaZ7tCS9l+3vGoG2
         3yGRpukpZBi7+FPG83ciqlRfKXsiekbS55oGFNsJa+83PqdBoY9Z27+NEKn2j29IFPv5
         LTHQ==
X-Gm-Message-State: APjAAAVDiMcXiOVONQJ3+azSR+F0+wI4aiA1c0IMiEV8uHIeKBsSZar0
        11Nz7f3WVRWaYH8NigZKYs4=
X-Google-Smtp-Source: APXvYqxEXP+Kspht6JQWbLrrmS0S6zI44Bror6FHffDv+mgQvfVogDcCVZY4nUtvjc0dh/o2xVy9MA==
X-Received: by 2002:aa7:8296:: with SMTP id s22mr4797826pfm.52.1559236626867;
        Thu, 30 May 2019 10:17:06 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id p21sm3459080pfn.129.2019.05.30.10.17.05
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 10:17:05 -0700 (PDT)
Subject: Re: [PATCH] ipv6: Prevent overrun when parsing v6 header options
To:     Young Xiao <92siuyang@gmail.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <1559230098-1543-1-git-send-email-92siuyang@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c83f8777-f6be-029b-980d-9f974b4e28ce@gmail.com>
Date:   Thu, 30 May 2019 10:17:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1559230098-1543-1-git-send-email-92siuyang@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/30/19 8:28 AM, Young Xiao wrote:
> The fragmentation code tries to parse the header options in order
> to figure out where to insert the fragment option.  Since nexthdr points
> to an invalid option, the calculation of the size of the network header
> can made to be much larger than the linear section of the skb and data
> is read outside of it.
> 
> This vulnerability is similar to CVE-2017-9074.
> 
> Signed-off-by: Young Xiao <92siuyang@gmail.com>
> ---
>  net/ipv6/mip6.c | 24 ++++++++++++++----------
>  1 file changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/net/ipv6/mip6.c b/net/ipv6/mip6.c
> index 64f0f7b..30ed1c5 100644
> --- a/net/ipv6/mip6.c
> +++ b/net/ipv6/mip6.c
> @@ -263,8 +263,6 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
>  			       u8 **nexthdr)
>  {
>  	u16 offset = sizeof(struct ipv6hdr);
> -	struct ipv6_opt_hdr *exthdr =
> -				   (struct ipv6_opt_hdr *)(ipv6_hdr(skb) + 1);
>  	const unsigned char *nh = skb_network_header(skb);
>  	unsigned int packet_len = skb_tail_pointer(skb) -
>  		skb_network_header(skb);
> @@ -272,7 +270,8 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
>  
>  	*nexthdr = &ipv6_hdr(skb)->nexthdr;
>  
> -	while (offset + 1 <= packet_len) {
> +	while (offset <= packet_len) {
> +		struct ipv6_opt_hdr *exthdr;
>  
>  		switch (**nexthdr) {
>  		case NEXTHDR_HOP:
> @@ -299,12 +298,15 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
>  			return offset;
>  		}
>  
> +		if (offset + sizeof(struct ipv6_opt_hdr) > packet_len)
> +			return -EINVAL;
> +
> +		exthdr = (struct ipv6_opt_hdr *)(nh + offset);
>  		offset += ipv6_optlen(exthdr);
>  		*nexthdr = &exthdr->nexthdr;
> -		exthdr = (struct ipv6_opt_hdr *)(nh + offset);
>  	}
>  
> -	return offset;
> +	return -EINVAL;
>  }
>


Ok, but have you checked that callers have been fixed ?

xfrm6_transport_output() seems buggy as well,
unless the skbs are linearized before entering these functions ?

Thanks.



