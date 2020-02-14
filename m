Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA71A15F1F4
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391516AbgBNSE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 13:04:59 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:38984 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388160AbgBNSE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 13:04:56 -0500
Received: by mail-il1-f195.google.com with SMTP id f70so8788594ill.6
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 10:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R4NN/uANES2nujn+HbpW+H7CPBzT9YuAGgfTqQSdJqA=;
        b=W8cGW5unrL0rmbcnyYr1EGay64jiwLnOzgWkIoVc/f0nR9nqjeGOJLlLjtS5lB0McT
         WgFavHC27m7f1Sbvi/6xVV7HumlC2S/l/vnZ5K8+PGG7o+PPjfWeVQK4Pi0aX+r9Rd+6
         324ENck6ngNHRlJEWZK7dkBmshADywGcTp8sp2kDlrwQGf5g+3MFfBwVNM8a4V+PBr3k
         VTXPq8FjyN69u6n9jGCc2Xu7nd1JEej/aX8Rf6o2uNx/xm7qKHU4/w+zRsQbMB5EjTZB
         o3s0nC5iVaHdOFifMSVPz6octpBYVc192/nAWH6JgXGl+pS8sDxb89zcq009KmCCvsH8
         SWOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R4NN/uANES2nujn+HbpW+H7CPBzT9YuAGgfTqQSdJqA=;
        b=nnw43VUym0wmCJryzzTF3H8sQComtXvOTmeG9TtOWnu7ClM72NlyJWMKFa/yD4Hdxl
         EexWBXuK+cCL2BEekzosRJmQcQAZufnNUMNpTu1XRnz/mDLXBZWY4oWqIPbC1XquSjnO
         2MgW9QhUWJDmdvwQQLonIY2tE9yfDGZVeh6p95orI5HELdb+qifWsZrAUzTbGfVgM4fU
         iI1yWcKAfwGK5wDUflVAhQns2l0DSw7CeMcOAvqv5BC5K3zfjmVAqe2Bjqo/5YIHNslG
         /4MPj8DS1bdrDZiklaLVtLeY1BchqCC9Ih7ReDdDPvBkov8GmUpiu8n77WGksP3v+QIO
         0/Lg==
X-Gm-Message-State: APjAAAV5gBQ5/Ps8edOE02iTWn0R+Gw2ipu+FQPSfijScTUmZjcVEhp7
        vREnRLO/K+oHe3U5FzYwzZytE5S5
X-Google-Smtp-Source: APXvYqwHekk1HPfxfeG5CRY8oEBUBVp/k27R2M+sMlP0/D8E0XvuSFz+KthaHGE0iIqTov0lgkE+DQ==
X-Received: by 2002:a65:5a48:: with SMTP id z8mr4586256pgs.157.1581703004482;
        Fri, 14 Feb 2020 09:56:44 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id 23sm7651152pfh.28.2020.02.14.09.56.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 09:56:43 -0800 (PST)
Subject: Re: [PATCH v2 net 3/3] wireguard: send: account for mtu=0 devices
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>
References: <20200214173407.52521-1-Jason@zx2c4.com>
 <20200214173407.52521-4-Jason@zx2c4.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <135ffa7a-f06a-80e3-4412-17457b202c77@gmail.com>
Date:   Fri, 14 Feb 2020 09:56:42 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214173407.52521-4-Jason@zx2c4.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/14/20 9:34 AM, Jason A. Donenfeld wrote:
> It turns out there's an easy way to get packets queued up while still
> having an MTU of zero, and that's via persistent keep alive. This commit
> makes sure that in whatever condition, we don't wind up dividing by
> zero. Note that an MTU of zero for a wireguard interface is something
> quasi-valid, so I don't think the correct fix is to limit it via
> min_mtu. This can be reproduced easily with:
> 
> ip link add wg0 type wireguard
> ip link add wg1 type wireguard
> ip link set wg0 up mtu 0
> ip link set wg1 up
> wg set wg0 private-key <(wg genkey)
> wg set wg1 listen-port 1 private-key <(wg genkey) peer $(wg show wg0 public-key)
> wg set wg0 peer $(wg show wg1 public-key) persistent-keepalive 1 endpoint 127.0.0.1:1
> 
> However, while min_mtu=0 seems fine, it makes sense to restrict the
> max_mtu. This commit also restricts the maximum MTU to the greatest
> number for which rounding up to the padding multiple won't overflow a
> signed integer. Packets this large were always rejected anyway
> eventually, due to checks deeper in, but it seems more sound not to even
> let the administrator configure something that won't work anyway.
> 
> We use this opportunity to clean up this function a bit so that it's
> clear which paths we're expecting.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Eric Dumazet <edumazet@google.com>
> ---
>  drivers/net/wireguard/device.c |  7 ++++---
>  drivers/net/wireguard/send.c   | 16 +++++++++++-----
>  2 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
> index 43db442b1373..cdc96968b0f4 100644
> --- a/drivers/net/wireguard/device.c
> +++ b/drivers/net/wireguard/device.c
> @@ -258,6 +258,8 @@ static void wg_setup(struct net_device *dev)
>  	enum { WG_NETDEV_FEATURES = NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
>  				    NETIF_F_SG | NETIF_F_GSO |
>  				    NETIF_F_GSO_SOFTWARE | NETIF_F_HIGHDMA };
> +	const int overhead = MESSAGE_MINIMUM_LENGTH + sizeof(struct udphdr) +
> +			     max(sizeof(struct ipv6hdr), sizeof(struct iphdr));
>  
>  	dev->netdev_ops = &netdev_ops;
>  	dev->hard_header_len = 0;
> @@ -271,9 +273,8 @@ static void wg_setup(struct net_device *dev)
>  	dev->features |= WG_NETDEV_FEATURES;
>  	dev->hw_features |= WG_NETDEV_FEATURES;
>  	dev->hw_enc_features |= WG_NETDEV_FEATURES;
> -	dev->mtu = ETH_DATA_LEN - MESSAGE_MINIMUM_LENGTH -
> -		   sizeof(struct udphdr) -
> -		   max(sizeof(struct ipv6hdr), sizeof(struct iphdr));
> +	dev->mtu = ETH_DATA_LEN - overhead;
> +	dev->max_mtu = round_down(INT_MAX, MESSAGE_PADDING_MULTIPLE) - overhead;
>  
>  	SET_NETDEV_DEVTYPE(dev, &device_type);
>  
> diff --git a/drivers/net/wireguard/send.c b/drivers/net/wireguard/send.c
> index c13260563446..2a9990ab66cd 100644
> --- a/drivers/net/wireguard/send.c
> +++ b/drivers/net/wireguard/send.c
> @@ -143,16 +143,22 @@ static void keep_key_fresh(struct wg_peer *peer)
>  
>  static unsigned int calculate_skb_padding(struct sk_buff *skb)
>  {
> +	unsigned int padded_size, last_unit = skb->len;
> +
> +	if (unlikely(!PACKET_CB(skb)->mtu))
> +		return -last_unit % MESSAGE_PADDING_MULTIPLE;

My brain hurts.

> +
>  	/* We do this modulo business with the MTU, just in case the networking
>  	 * layer gives us a packet that's bigger than the MTU. In that case, we
>  	 * wouldn't want the final subtraction to overflow in the case of the
> -	 * padded_size being clamped.
> +	 * padded_size being clamped. Fortunately, that's very rarely the case,
> +	 * so we optimize for that not happening.
>  	 */
> -	unsigned int last_unit = skb->len % PACKET_CB(skb)->mtu;
> -	unsigned int padded_size = ALIGN(last_unit, MESSAGE_PADDING_MULTIPLE);
> +	if (unlikely(last_unit > PACKET_CB(skb)->mtu))
> +		last_unit %= PACKET_CB(skb)->mtu;
>  
> -	if (padded_size > PACKET_CB(skb)->mtu)
> -		padded_size = PACKET_CB(skb)->mtu;
> +	padded_size = min(PACKET_CB(skb)->mtu,
> +			  ALIGN(last_unit, MESSAGE_PADDING_MULTIPLE));
>  	return padded_size - last_unit;
>  }
>  


Oh dear, can you describe what do you expect of a wireguard device with mtu == 0 or mtu == 1

Why simply not allowing silly configurations, instead of convoluted tests in fast path ?

We are speaking of tunnels adding quite a lot of headers, so we better not try to make them
work on networks with tiny mtu. Just say no to syzbot.
