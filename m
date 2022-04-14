Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A4D501EEB
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 01:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345606AbiDNXSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 19:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240552AbiDNXSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 19:18:49 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACCDAC907;
        Thu, 14 Apr 2022 16:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=CFuW2Yfm9w5+kjCNJGdTozdGvIwhLZUxIXX3CCrU31k=; b=fw
        lAINokVw/geP2JhxUmI9Ru88RDoIbh3GzNFWpBnjymIOnkJr6Oh+JipuG1hcV6q+Ka9vUgP2iyc59
        M8CeeMzMCbY80OrIk+qSqhPmKATuCzhUMZkQRJoPV7uz1izxLmhKwWe718/5gYSqiBzSOlHRAtOyQ
        Oi4wLHGvsQvDaZw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nf8h9-00Ft3S-Nv; Fri, 15 Apr 2022 01:16:11 +0200
Date:   Fri, 15 Apr 2022 01:16:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?iso-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 07/12] net: dsa: rzn1-a5psw: add statistics
 support
Message-ID: <YlirO7VrfyUH33rV@lunn.ch>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-8-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220414122250.158113-8-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 02:22:45PM +0200, Clément Léger wrote:
> Add per-port statistics. This support requries to add a stat lock since
> statistics are stored in two 32 bits registers, the hi part one being
> global and latched when accessing the lo part.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  drivers/net/dsa/rzn1_a5psw.c | 101 +++++++++++++++++++++++++++++++++++
>  drivers/net/dsa/rzn1_a5psw.h |   2 +
>  2 files changed, 103 insertions(+)
> 
> diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
> index 5bee999f7050..7ab7d9054427 100644
> --- a/drivers/net/dsa/rzn1_a5psw.c
> +++ b/drivers/net/dsa/rzn1_a5psw.c
> @@ -16,6 +16,59 @@
>  
>  #include "rzn1_a5psw.h"
>  
> +struct a5psw_stats {
> +	u16 offset;
> +	const char *name;
> +};
> +
> +#define STAT_DESC(_offset, _name) {.offset = _offset, .name = _name}
> +
> +static const struct a5psw_stats a5psw_stats[] = {
> +	STAT_DESC(0x868, "aFrameTransmitted"),
> +	STAT_DESC(0x86C, "aFrameReceived"),
> +	STAT_DESC(0x8BC, "etherStatsetherStatsOversizePktsDropEvents"),

> +};


> +static void a5psw_get_strings(struct dsa_switch *ds, int port, u32 stringset,
> +			      uint8_t *data)
> +{
> +	unsigned int u;
> +
> +	if (stringset != ETH_SS_STATS)
> +		return;
> +
> +	for (u = 0; u < ARRAY_SIZE(a5psw_stats); u++) {
> +		strncpy(data + u * ETH_GSTRING_LEN, a5psw_stats[u].name,
> +			ETH_GSTRING_LEN);
> +	}

The kernel strncpy() is like the user space one. It does not add a
NULL if the string is longer than ETH_GSTRING_LEN and it needs to
truncate. So there is a danger here.

What you find most drivers do is

struct a5psw_stats {
	u16 offset;
	const char name[ETH_GSTRING_LEN];
};

You should then get a compiler warning/error if you string is ever
longer than allowed. And use memcpy() rather than strcpy(), which is
faster anyway. But you do use up a bit more memory.

> +static void a5psw_get_ethtool_stats(struct dsa_switch *ds, int port,
> +				    uint64_t *data)
> +{
> +	struct a5psw *a5psw = ds->priv;
> +	u32 reg_lo, reg_hi;
> +	unsigned int u;
> +
> +	for (u = 0; u < ARRAY_SIZE(a5psw_stats); u++) {
> +		/* A5PSW_STATS_HIWORD is global and thus, access must be
> +		 * exclusive
> +		 */

Could you explain that a bit more. The RTNL lock will prevent two
parallel calls to this function.

> +		spin_lock(&a5psw->stats_lock);
> +		reg_lo = a5psw_reg_readl(a5psw, a5psw_stats[u].offset +
> +					 A5PSW_PORT_OFFSET(port));
> +		/* A5PSW_STATS_HIWORD is latched on stat read */
> +		reg_hi = a5psw_reg_readl(a5psw, A5PSW_STATS_HIWORD);
> +
> +		data[u] = ((u64)reg_hi << 32) | reg_lo;
> +		spin_unlock(&a5psw->stats_lock);
> +	}
> +}

  Andrew
