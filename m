Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44AE2B2AC5
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 03:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgKNCI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 21:08:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54808 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbgKNCI7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 21:08:59 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kdkzj-006y1f-5u; Sat, 14 Nov 2020 03:08:51 +0100
Date:   Sat, 14 Nov 2020 03:08:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/2] net: dsa: tag_dsa: Unify regular and
 ethertype DSA taggers
Message-ID: <20201114020851.GW1480543@lunn.ch>
References: <20201111131153.3816-1-tobias@waldekranz.com>
 <20201111131153.3816-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201111131153.3816-2-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias

> +/**
> + * enum dsa_cmd - DSA Command
> + * @DSA_CMD_TO_CPU: Set on packets that were trapped or mirrored to
> + *     the CPU port. This is needed to implement control protocols,
> + *     e.g. STP and LLDP, that must not allow those control packets to
> + *     be switched according to the normal rules.

Maybe we want to mention that this only makes sense for packets
egressing the switch?

> + * @DSA_CMD_FROM_CPU: Used by the CPU to send a packet to a specific
> + *     port, ignoring all the barriers that the switch normally
> + *     enforces (VLANs, STP port states etc.). "sudo send packet"

This only make sense for packets ingressing the switch. The
TO_CPU/FROM_CPU kind of make that clear but..

> + * @DSA_CMD_TO_SNIFFER: Set on packets that where mirrored to the CPU
> + *     as a result of matching some user configured ingress or egress
> + *     monitor criteria.
> + * @DSA_CMD_FORWARD: Everything else, i.e. the bulk data traffic.

I assume this can be used in both direction?

> + *
> + * A 3-bit code is used to relay why a particular frame was sent to
> + * the CPU. We only use this to determine if the packet was mirrored
> + * or trapped, i.e. whether the packet has been forwarded by hardware
> + * or not.

Maybe add that, not all generations support all codes. 

> +static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
> +				  u8 extra)
>  {
> +	int source_device, source_port;
> +	enum dsa_code code;
> +	enum dsa_cmd cmd;
>  	u8 *dsa_header;
> -	int source_device;
> -	int source_port;
> -
> -	if (unlikely(!pskb_may_pull(skb, DSA_HLEN)))
> -		return NULL;
>  
>  	/*
>  	 * The ethertype field is part of the DSA header.
>  	 */
>  	dsa_header = skb->data - 2;
>  
> -	/*
> -	 * Check that frame type is either TO_CPU or FORWARD.
> -	 */
> -	if ((dsa_header[0] & 0xc0) != 0x00 && (dsa_header[0] & 0xc0) != 0xc0)
> +	cmd = dsa_header[0] >> 6;
> +	switch (cmd) {
> +	case DSA_CMD_FORWARD:
> +		skb->offload_fwd_mark = 1;
> +		break;
> +
> +	case DSA_CMD_TO_CPU:
> +		code = (dsa_header[1] & 0x6) | ((dsa_header[2] >> 4) & 1);
> +
> +		switch (code) {
> +		case DSA_CODE_FRAME2REG:
> +			/* Remote management frames originate from the
> +			 * switch itself, there is no DSA port for us
> +			 * to ingress it on (the port field is always
> +			 * 0 in these tags).

If/when we get around to implementing this, i doubt we will ingress it
like a frame. It will get picked up here and probably added to some
queue and a thread woken up. So maybe just say, not implemented yet,
so drop it.

> +			 */
> +			return NULL;
> +		case DSA_CODE_ARP_MIRROR:
> +		case DSA_CODE_POLICY_MIRROR:
> +			/* Mark mirrored packets to notify any upper
> +			 * device (like a bridge) that forwarding has
> +			 * already been done by hardware.
> +			 */
> +			skb->offload_fwd_mark = 1;
> +			break;
> +		case DSA_CODE_MGMT_TRAP:
> +		case DSA_CODE_IGMP_MLD_TRAP:
> +		case DSA_CODE_POLICY_TRAP:
> +			/* Traps have, by definition, not been
> +			 * forwarded by hardware, so don't mark them.
> +			 */

Humm, yes, they have not been forwarded by hardware. But is the
software bridge going to do the right thing and not flood them? Up
until now, i think we did mark them. So this is a clear change in
behaviour. I wonder if we want to break this out into a separate
patch? If something breaks, we can then bisect was it the combining
which broke it, or the change of this mark.

I will try to test this on my hardware, but it is probably same as
your 6390X and 6352.

     Andrew
