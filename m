Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3462207961
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 18:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404897AbgFXQnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 12:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404017AbgFXQnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 12:43:51 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74CACC061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 09:43:51 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id s14so1264121plq.6
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 09:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y1IhjNNb7fUJICRcToQnRGGcbyhtcEjuvXR0xQ38qg4=;
        b=ac2Az0DLPAkpFswzjp7LZ7zUcIX2e2iBToBTfZWs0tkxKJF35/J1k0mngafYfRTdw9
         Oyft2HaRQ8BUbjk4Vg+HV35luW/De994gRu8Y6HwhhMqsgJX6hZbXXuX4j0RjfjHpKNX
         mGlVxGwIzGa0ULtFl67R0nCK1nOp9zNtotqQMAzMndNQMk50twZ1yyhPmpo5YOHpvF/a
         fyV4D6RNaTrNdNU23tKsfJyeYIi+iRQw/QmXRIC58z30OD5ad9vaTNATaPo/hK/8r7Tl
         TZB7UmSi8PtBeoDJW0SErliCXH7RjR8k3P9oES65NkwLVzO9vUMM6WWwKjCPRnQbsSZQ
         R7jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y1IhjNNb7fUJICRcToQnRGGcbyhtcEjuvXR0xQ38qg4=;
        b=kfDrpWuE7HLOFY4+w0g4ISFvliBnTBhtCnzKG/8LpNTB3tXk0sdPIABJorD7aMIVC3
         wBnXaCyRLo2ag7n6ZV3OjF+TonnEQJzIi2Fct4T5zYdBTtUQjL7kplTRCSEkGrPX6fDF
         SfZI70xj8UJuOFyBDrDh9DNcPHQymmk10hyhh0Nyb5zmJLXLfYnpIvmR7OFKJahoQRuZ
         Cwc2Ode7Y3qCYB7z0qx5Oi0KqJstTZ59ogoOEjlo5uRw6wPjLW8qBDBKeX1oAq5BWObr
         nOAndM/vsLqscuo1sD0q0rOPtEcP22sGekF94E4weOuaoYUF747Bd4Gcw+EiffjVczeb
         MkaA==
X-Gm-Message-State: AOAM530JoqILlDqDnHyPeqX0gzTyA7Su3owReuoIppn4KHnqzJM4uz0A
        9pxynKh5GHYT2Q+l6KvytZE=
X-Google-Smtp-Source: ABdhPJw6Rp2Rr8giG60f5D/VOexaHx/5Mr3HU5ewSvOLEGalKRgfHZ7zecDC1GdTZjZ69dZgbJd73Q==
X-Received: by 2002:a17:902:8508:: with SMTP id bj8mr27411069plb.231.1593017031062;
        Wed, 24 Jun 2020 09:43:51 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id c2sm16928108pgk.77.2020.06.24.09.43.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 09:43:50 -0700 (PDT)
Subject: Re: [PATCH] IPv4: Tunnel: Fix effective path mtu calculation
To:     Oliver Herms <oliver.peter.herms@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
References: <20200624114852.GA153778@tws>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a3d6baa0-7f72-adf3-0082-df42a05858b1@gmail.com>
Date:   Wed, 24 Jun 2020 09:43:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200624114852.GA153778@tws>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/20 4:48 AM, Oliver Herms wrote:
> The calculation of the effective tunnel mtu, that is used to create
> mtu exceptions if necessary, is currently not done correctly. This
> leads to unnecessary entries in the IPv6 route cache for any packet
> to be sent through the tunnel.
> 
> The root cause is, that "dev->hard_header_len" is subtracted from the
> tunnel destinations path mtu. Thus subtracting too much, if
> dev->hard_header_len is filled in. This is that case for SIT tunnels
> where hard_header_len is the underlyings dev's hard_header_len (e.g. 14
> for ethernet) + 20 bytes IP header (see net/ipv6/sit.c:1091).
> 
> However, the MTU of the path is exclusive of the ethernet header
> and the 20 bytes for the IP header are being subtracted separately
> already. Thus hard_header_len is removed from this calculation.
> 
> For IPIP and GRE tunnels this doesn't change anything as hard_header_len
> is zero in those cases anyways.
> 
> Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
> ---
>  net/ipv4/ip_tunnel.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
> index f4f1d11eab50..871d28bd29fa 100644
> --- a/net/ipv4/ip_tunnel.c
> +++ b/net/ipv4/ip_tunnel.c
> @@ -495,8 +495,7 @@ static int tnl_update_pmtu(struct net_device *dev, struct sk_buff *skb,
>  	pkt_size = skb->len - tunnel_hlen - dev->hard_header_len;
>  
>  	if (df)
> -		mtu = dst_mtu(&rt->dst) - dev->hard_header_len
> -					- sizeof(struct iphdr) - tunnel_hlen;
> +		mtu = dst_mtu(&rt->dst) - sizeof(struct iphdr) - tunnel_hlen;
>  	else
>  		mtu = skb_valid_dst(skb) ? dst_mtu(skb_dst(skb)) : dev->mtu;
>  
> 


Can you add a Fixes: tag, to help stable teams work ?

Thanks.
