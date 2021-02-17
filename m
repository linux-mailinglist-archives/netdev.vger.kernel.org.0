Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BF631D43D
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 04:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhBQDaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 22:30:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45226 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229683AbhBQDaB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 22:30:01 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lCDWe-006o31-Kh; Wed, 17 Feb 2021 04:29:16 +0100
Date:   Wed, 17 Feb 2021 04:29:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH] net: dsa: tag_rtl4_a: Support also egress tags
Message-ID: <YCyNjB5PpYomt4Re@lunn.ch>
References: <20210216235542.2718128-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210216235542.2718128-1-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 12:55:42AM +0100, Linus Walleij wrote:
> Support also transmitting frames using the custom "8899 A"
> 4 byte tag.
> 
> Qingfang came up with the solution: we need to pad the
> ethernet frame to 60 bytes using eth_skb_pad(), then the
> switch will happily accept frames with custom tags.
> 
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Reported-by: DENG Qingfang <dqfext@gmail.com>
> Fixes: efd7fe68f0c6 ("net: dsa: tag_rtl4_a: Implement Realtek 4 byte A tag")
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  net/dsa/tag_rtl4_a.c | 43 +++++++++++++++++++++++++++++--------------
>  1 file changed, 29 insertions(+), 14 deletions(-)
> 
> diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
> index 2646abe5a69e..c17d39b4a1a0 100644
> --- a/net/dsa/tag_rtl4_a.c
> +++ b/net/dsa/tag_rtl4_a.c
> @@ -12,9 +12,7 @@
>   *
>   * The 2 bytes tag form a 16 bit big endian word. The exact
>   * meaning has been guessed from packet dumps from ingress
> - * frames, as no working egress traffic has been available
> - * we do not know the format of the egress tags or if they
> - * are even supported.
> + * frames.
>   */
>  
>  #include <linux/etherdevice.h>
> @@ -36,17 +34,34 @@
>  static struct sk_buff *rtl4a_tag_xmit(struct sk_buff *skb,
>  				      struct net_device *dev)
>  {
> -	/*
> -	 * Just let it pass thru, we don't know if it is possible
> -	 * to tag a frame with the 0x8899 ethertype and direct it
> -	 * to a specific port, all attempts at reverse-engineering have
> -	 * ended up with the frames getting dropped.
> -	 *
> -	 * The VLAN set-up needs to restrict the frames to the right port.
> -	 *
> -	 * If you have documentation on the tagging format for RTL8366RB
> -	 * (tag type A) then please contribute.
> -	 */
> +	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	u8 *tag;
> +	u16 *p;
> +	u16 out;

Reverse Christmass tree.

> +
> +	/* Pad out to at least 60 bytes */
> +	if (unlikely(eth_skb_pad(skb)))
> +		return NULL;

The core will do the padding for you. Turn on .tail_tag in
dsa_device_ops.

> +	if (skb_cow_head(skb, RTL4_A_HDR_LEN) < 0)
> +		return NULL;
> +
> +	netdev_dbg(dev, "add realtek tag to package to port %d\n",
> +		   dp->index);

You can remove this, now that it works. 

> +	skb_push(skb, RTL4_A_HDR_LEN);
> +
> +	memmove(skb->data, skb->data + RTL4_A_HDR_LEN, 2 * ETH_ALEN);
> +	tag = skb->data + 2 * ETH_ALEN;
> +
> +	/* Set Ethertype */
> +	p = (u16 *)tag;
> +	*p = htons(RTL4_A_ETHERTYPE);
> +
> +	out = (RTL4_A_PROTOCOL_RTL8366RB << 12) | (2 << 8);

Do we know what bit 9 means?
   
   Andrew
