Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6EE36A6DB
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 13:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhDYLNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 07:13:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229707AbhDYLM7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Apr 2021 07:12:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B5E16120C;
        Sun, 25 Apr 2021 11:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619349140;
        bh=5lGEsDFA3d/Fb4AUtFXHzwkNjEGaSwEjqnnuzHp0H8o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZsGQ2P/MD9LN1jzVG/y0h5BNz6xHNOMEFhoI6QnMDSnzbxMXfihUpMl1cEWmJeWap
         +yhTveH8dqxyl59ZVjp3MFo8axqnDl9/1hbHWxsowu613kfM7vLaZkbYdGT7ARdM2p
         fxMnChbXdN0WIldvMIHbf3iuUkbmtIL9jvB62zq6QJkP+HSjsPCVPBPSrdhkNVkwy7
         6EPF++xlePG6dzZ/AqHbCZTajl27NNwmBwclPF4V11+Fhsm0Rl8J+guCaVR5D6Yu6u
         WrVSaRztHMLPFglO+zgcWYNUUCsTPyLmYjpippyrGVByPZNsIAjb1xLWbp1Nxgg+7C
         uB6lCTgb6g0sQ==
Date:   Sun, 25 Apr 2021 14:12:16 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jethro Beekman <kernel@jbeekman.nl>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next] macvlan: Add nodst option to macvlan type
 source
Message-ID: <YIVOkHgZXiShCH2M@unreal>
References: <2afc4d46-aa9b-a7db-d872-d02163b1f29c@jbeekman.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2afc4d46-aa9b-a7db-d872-d02163b1f29c@jbeekman.nl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 25, 2021 at 11:22:03AM +0200, Jethro Beekman wrote:
> The default behavior for source MACVLAN is to duplicate packets to
> appropriate type source devices, and then do the normal destination MACVLAN
> flow. This patch adds an option to skip destination MACVLAN processing if
> any matching source MACVLAN device has the option set.
> 
> This allows setting up a "catch all" device for source MACVLAN: create one
> or more devices with type source nodst, and one device with e.g. type vepa,
> and incoming traffic will be received on exactly one device.
> 
> v2: netdev wants non-standard line length

Can you please put the changelog after "---"? So it won't be part of
commit message in the git log.

Thanks

> 
> Signed-off-by: Jethro Beekman <kernel@jbeekman.nl>
> ---
>  drivers/net/macvlan.c        | 19 ++++++++++++++-----
>  include/uapi/linux/if_link.h |  1 +
>  2 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
> index 9a9a5cf36a4b..7427b989607e 100644
> --- a/drivers/net/macvlan.c
> +++ b/drivers/net/macvlan.c
> @@ -423,18 +423,24 @@ static void macvlan_forward_source_one(struct sk_buff *skb,
>  	macvlan_count_rx(vlan, len, ret == NET_RX_SUCCESS, false);
>  }
>  
> -static void macvlan_forward_source(struct sk_buff *skb,
> +static bool macvlan_forward_source(struct sk_buff *skb,
>  				   struct macvlan_port *port,
>  				   const unsigned char *addr)
>  {
>  	struct macvlan_source_entry *entry;
>  	u32 idx = macvlan_eth_hash(addr);
>  	struct hlist_head *h = &port->vlan_source_hash[idx];
> +	bool consume = false;
>  
>  	hlist_for_each_entry_rcu(entry, h, hlist) {
> -		if (ether_addr_equal_64bits(entry->addr, addr))
> +		if (ether_addr_equal_64bits(entry->addr, addr)) {
> +			if (entry->vlan->flags & MACVLAN_FLAG_NODST)
> +				consume = true;
>  			macvlan_forward_source_one(skb, entry->vlan);
> +		}
>  	}
> +
> +	return consume;
>  }
>  
>  /* called under rcu_read_lock() from netif_receive_skb */
> @@ -463,7 +469,8 @@ static rx_handler_result_t macvlan_handle_frame(struct sk_buff **pskb)
>  			return RX_HANDLER_CONSUMED;
>  		*pskb = skb;
>  		eth = eth_hdr(skb);
> -		macvlan_forward_source(skb, port, eth->h_source);
> +		if (macvlan_forward_source(skb, port, eth->h_source))
> +			return RX_HANDLER_CONSUMED;
>  		src = macvlan_hash_lookup(port, eth->h_source);
>  		if (src && src->mode != MACVLAN_MODE_VEPA &&
>  		    src->mode != MACVLAN_MODE_BRIDGE) {
> @@ -482,7 +489,8 @@ static rx_handler_result_t macvlan_handle_frame(struct sk_buff **pskb)
>  		return RX_HANDLER_PASS;
>  	}
>  
> -	macvlan_forward_source(skb, port, eth->h_source);
> +	if (macvlan_forward_source(skb, port, eth->h_source))
> +		return RX_HANDLER_CONSUMED;
>  	if (macvlan_passthru(port))
>  		vlan = list_first_or_null_rcu(&port->vlans,
>  					      struct macvlan_dev, list);
> @@ -1286,7 +1294,8 @@ static int macvlan_validate(struct nlattr *tb[], struct nlattr *data[],
>  		return 0;
>  
>  	if (data[IFLA_MACVLAN_FLAGS] &&
> -	    nla_get_u16(data[IFLA_MACVLAN_FLAGS]) & ~MACVLAN_FLAG_NOPROMISC)
> +	    nla_get_u16(data[IFLA_MACVLAN_FLAGS]) & ~(MACVLAN_FLAG_NOPROMISC |
> +						      MACVLAN_FLAG_NODST))
>  		return -EINVAL;
>  
>  	if (data[IFLA_MACVLAN_MODE]) {
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index 91c8dda6d95d..cd5b382a4138 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -614,6 +614,7 @@ enum macvlan_macaddr_mode {
>  };
>  
>  #define MACVLAN_FLAG_NOPROMISC	1
> +#define MACVLAN_FLAG_NODST	2 /* skip dst macvlan if matching src macvlan */
>  
>  /* VRF section */
>  enum {
> -- 
> 2.31.1
> 
