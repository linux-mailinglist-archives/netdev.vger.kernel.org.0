Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E05202616
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 21:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbgFTTFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 15:05:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50412 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728459AbgFTTFg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Jun 2020 15:05:36 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jmio2-001QKx-4s; Sat, 20 Jun 2020 21:05:34 +0200
Date:   Sat, 20 Jun 2020 21:05:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Mack <daniel@zonque.org>
Cc:     netdev@vger.kernel.org, jcobham@questertangent.com
Subject: Re: [PATCH] dsa: Allow forwarding of redirected IGMP traffic
Message-ID: <20200620190534.GA338481@lunn.ch>
References: <20200620181714.3151501-1-daniel@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200620181714.3151501-1-daniel@zonque.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 20, 2020 at 08:17:14PM +0200, Daniel Mack wrote:
> The driver for Marvell switches puts all ports in IGMP snooping mode
> which results in all IGMP/MLD frames that ingress on the ports to be
> forwarded to the CPU only.
> 
> The bridge code in the kernel can then interpret these frames and act
> upon them, for instance by updating the mdb in the switch to reflect
> multicast memberships of stations connected to the ports. However,
> the IGMP/MLD frames must then also be forwarded to other ports of the
> bridge so external IGMP queriers can track membership reports, and
> external multicast clients can receive query reports from foreign IGMP
> queriers.
> 
> Currently, this is impossible as the EDSA tagger sets offload_fwd_mark
> on the skb when it unwraps the tagged frames, and that will make the
> switchdev layer prevent the skb from egressing on any other port of
> the same switch.
> 
> To fix that, look at the To_CPU code in the DSA header and make
> forwarding of the frame possible for trapped IGMP packets.
> 
> This was tested on a Marvell 88E6352 variant.
> 
> Signed-off-by: Daniel Mack <daniel@zonque.org>

A Fixes: tag would be good, probably for when basic IGMP snooping
support was added to the mv88e6xxx driver.

> ---
>  net/dsa/tag_edsa.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/net/dsa/tag_edsa.c b/net/dsa/tag_edsa.c
> index e8eaa804ccb9e..b7cb5dac46c3e 100644
> --- a/net/dsa/tag_edsa.c
> +++ b/net/dsa/tag_edsa.c
> @@ -79,6 +79,7 @@ static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev,
>  	u8 *edsa_header;
>  	int source_device;
>  	int source_port;
> +	int to_cpu_code;
>  
>  	if (unlikely(!pskb_may_pull(skb, EDSA_HLEN)))
>  		return NULL;
> @@ -100,6 +101,11 @@ static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev,
>  	source_device = edsa_header[0] & 0x1f;
>  	source_port = (edsa_header[1] >> 3) & 0x1f;
>  
> +	/*
> +	 * Determine the kind of the frame
> +	 */
> +	to_cpu_code = (edsa_header[1] & 0x6) | ((edsa_header[2] >> 4) & 1);
> +

These bits are only valid on a TO_CPU frame. If it is a Forward frame,
these bits have different meanings. So you need to check the frame
type.

Please add some #defines for these magic numbers. Yes, i know there
are a lot of other magic numbers. We can fix that in a different
patch.

>  	skb->dev = dsa_master_find_slave(dev, source_device, source_port);
>  	if (!skb->dev)
>  		return NULL;
> @@ -156,7 +162,13 @@ static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev,
>  			2 * ETH_ALEN);
>  	}
>  
> -	skb->offload_fwd_mark = 1;
> +	/*
> +	 * Mark the frame to never egress on any port of the same switch
> +	 * unless it's a trapped IGMP/MLD packet, in which case the bridge
> +	 * might want to forward it.
> +	 */
> +	if (to_cpu_code != 0x02)
> +		skb->offload_fwd_mark = 1;

Please add some #defines for the different codes.

Thanks
	Andrew
