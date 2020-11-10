Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F7D2AD801
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 14:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbgKJNt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 08:49:26 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45910 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730357AbgKJNt0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 08:49:26 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kcU1P-006Htg-Nb; Tue, 10 Nov 2020 14:49:19 +0100
Date:   Tue, 10 Nov 2020 14:49:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: tag_dsa: Unify regular and ethertype DSA
 taggers
Message-ID: <20201110134919.GA1480543@lunn.ch>
References: <20201110091325.21582-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110091325.21582-1-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -7,8 +7,7 @@ dsa_core-y += dsa.o dsa2.o master.o port.o slave.o switch.o
>  obj-$(CONFIG_NET_DSA_TAG_8021Q) += tag_8021q.o
>  obj-$(CONFIG_NET_DSA_TAG_AR9331) += tag_ar9331.o
>  obj-$(CONFIG_NET_DSA_TAG_BRCM_COMMON) += tag_brcm.o
> -obj-$(CONFIG_NET_DSA_TAG_DSA) += tag_dsa.o
> -obj-$(CONFIG_NET_DSA_TAG_EDSA) += tag_edsa.o
> +obj-$(CONFIG_NET_DSA_TAG_DSA_COMMON) += tag_dsa.o
>  obj-$(CONFIG_NET_DSA_TAG_GSWIP) += tag_gswip.o
>  obj-$(CONFIG_NET_DSA_TAG_HELLCREEK) += tag_hellcreek.o
>  obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o

>  
> -#define DSA_HLEN	4
> +#if IS_ENABLED(CONFIG_NET_DSA_TAG_DSA_COMMON)

I don't think you need this.  The file will not get compiled if
CONFIG_NET_DSA_TAG_DSA_COMMON is not enabled.

> -static struct sk_buff *dsa_xmit(struct sk_buff *skb, struct net_device *dev)
> +#define DSA_HLEN 4
> +
> +/**
> + * enum dsa_cmd - DSA Command
> + * @DSA_CMD_TO_CPU: Set on packets that where trapped or mirrored to
> + *     the CPU port. This is needed to implement control protocols,
> + *     e.g. STP and LLDP, that must not allow those control packets to
> + *     be switched according to the normal rules.
> + * @DSA_CMD_FROM_CPU: Used by the CPU to send a packet to a specific
> + *     port, ignoring all the barriers that the switch normally
> + *     enforces (VLANs, STP port states etc.). "sudo send packet"
> + * @DSA_CMD_TO_SNIFFER: Set on packets that where mirrored to the CPU
> + *     as a result of matching some user configured ingress or egress
> + *     monitor criteria.
> + * @DSA_CMD_FORWARD: Everything else, i.e. the bulk data traffic.
> + */
> +enum dsa_cmd {
> +	DSA_CMD_TO_CPU     = 0,
> +	DSA_CMD_FROM_CPU   = 1,
> +	DSA_CMD_TO_SNIFFER = 2,
> +	DSA_CMD_FORWARD    = 3
> +};
> +
> +/**
> + * enum dsa_code - TO_CPU Code
> + *
> + * A 3-bit code is used to relay why a particular frame was sent to
> + * the CPU. We only use this to determine if the packet was trapped or
> + * mirrored, i.e. whether the packet has been forwarded by hardware or
> + * not.
> + */
> +enum dsa_code {
> +	DSA_CODE_MGMT_TRAP     = 0,
> +	DSA_CODE_FRAME2REG     = 1,
> +	DSA_CODE_IGMP_MLD_TRAP = 2,
> +	DSA_CODE_POLICY_TRAP   = 3,
> +	DSA_CODE_ARP_MIRROR    = 4,
> +	DSA_CODE_POLICY_MIRROR = 5,
> +	DSA_CODE_RESERVED_6    = 6,
> +	DSA_CODE_RESERVED_7    = 7
> +};

Nice kerneldoc. Thanks

I will take a look at the rest later.

  Andrew
