Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3874250BCE
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 00:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgHXWo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 18:44:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47994 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgHXWo6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 18:44:58 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kALCs-00BhUu-An; Tue, 25 Aug 2020 00:44:50 +0200
Date:   Tue, 25 Aug 2020 00:44:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v3 2/8] net: dsa: Add DSA driver for Hirschmann Hellcreek
 switches
Message-ID: <20200824224450.GK2403519@lunn.ch>
References: <20200820081118.10105-1-kurt@linutronix.de>
 <20200820081118.10105-3-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820081118.10105-3-kurt@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 10:11:12AM +0200, Kurt Kanzenbach wrote:
> Add a basic DSA driver for Hirschmann Hellcreek switches. Those switches are
> implementing features needed for Time Sensitive Networking (TSN) such as support
> for the Time Precision Protocol and various shapers like the Time Aware Shaper.
> 
> This driver includes basic support for networking:
> 
>  * VLAN handling
>  * FDB handling
>  * Port statistics
>  * STP
>  * Phylink
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  drivers/net/dsa/Kconfig                |    2 +
>  drivers/net/dsa/Makefile               |    1 +
>  drivers/net/dsa/hirschmann/Kconfig     |    8 +
>  drivers/net/dsa/hirschmann/Makefile    |    2 +
>  drivers/net/dsa/hirschmann/hellcreek.c | 1170 ++++++++++++++++++++++++
>  drivers/net/dsa/hirschmann/hellcreek.h |  244 +++++
>  6 files changed, 1427 insertions(+)
>  create mode 100644 drivers/net/dsa/hirschmann/Kconfig
>  create mode 100644 drivers/net/dsa/hirschmann/Makefile
>  create mode 100644 drivers/net/dsa/hirschmann/hellcreek.c
>  create mode 100644 drivers/net/dsa/hirschmann/hellcreek.h
> 
> diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
> index 468b3c4273c5..297dc27b92bc 100644
> --- a/drivers/net/dsa/Kconfig
> +++ b/drivers/net/dsa/Kconfig
> @@ -58,6 +58,8 @@ source "drivers/net/dsa/qca/Kconfig"
>  
>  source "drivers/net/dsa/sja1105/Kconfig"
>  
> +source "drivers/net/dsa/hirschmann/Kconfig"
> +
>  config NET_DSA_QCA8K
>  	tristate "Qualcomm Atheros QCA8K Ethernet switch family support"
>  	depends on NET_DSA

Hi Kurt

The DSA entries are sorted into alphabetic order based on what you see
in make menuconfig. As such, "Hirschmann Hellcreek TSN Switch support"
fits in between "DSA mock-up Ethernet switch chip support" and "Lantiq / Intel GSWIP"

> diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
> index 4a943ccc2ca4..a707ccc3a940 100644
> --- a/drivers/net/dsa/Makefile
> +++ b/drivers/net/dsa/Makefile
> @@ -23,3 +23,4 @@ obj-y				+= mv88e6xxx/
>  obj-y				+= ocelot/
>  obj-y				+= qca/
>  obj-y				+= sja1105/
> +obj-y				+= hirschmann/

This file is also sorted. 

> +static int hellcreek_detect(struct hellcreek *hellcreek)
> +{
> +	u16 id, rel_low, rel_high, date_low, date_high, tgd_ver;
> +	u8 tgd_maj, tgd_min;
> +	u32 rel, date;
> +
> +	id	  = hellcreek_read(hellcreek, HR_MODID_C);
> +	rel_low	  = hellcreek_read(hellcreek, HR_REL_L_C);
> +	rel_high  = hellcreek_read(hellcreek, HR_REL_H_C);
> +	date_low  = hellcreek_read(hellcreek, HR_BLD_L_C);
> +	date_high = hellcreek_read(hellcreek, HR_BLD_H_C);
> +	tgd_ver   = hellcreek_read(hellcreek, TR_TGDVER);
> +
> +	if (id != HELLCREEK_MODULE_ID)
> +		return -ENODEV;

Are there other Hellcreek devices? I'm just wondering if we should
have a specific compatible for 0x4c30 as well as the more generic 
"hirschmann,hellcreek".

> +static void hellcreek_get_ethtool_stats(struct dsa_switch *ds, int port,
> +					uint64_t *data)
> +{
> +	struct hellcreek *hellcreek = ds->priv;
> +	struct hellcreek_port *hellcreek_port;
> +	unsigned long flags;
> +	int i;
> +
> +	hellcreek_port = &hellcreek->ports[port];
> +
> +	spin_lock_irqsave(&hellcreek->reg_lock, flags);
> +	for (i = 0; i < ARRAY_SIZE(hellcreek_counter); ++i) {
> +		const struct hellcreek_counter *counter = &hellcreek_counter[i];
> +		u8 offset = counter->offset + port * 64;
> +		u16 high, low;
> +		u64 value = 0;
> +
> +		hellcreek_select_counter(hellcreek, offset);
> +
> +		/* The registers are locked internally by selecting the
> +		 * counter. So low and high can be read without reading high
> +		 * again.
> +		 */

Is there any locking/snapshot of all the counters at once? Most
devices have support for that, so you can compare counters against
each other.

> +		high  = hellcreek_read(hellcreek, HR_CRDH);
> +		low   = hellcreek_read(hellcreek, HR_CRDL);
> +		value = (high << 16) | low;
> +
> +		hellcreek_port->counter_values[i] += value;
> +		data[i] = hellcreek_port->counter_values[i];
> +	}
> +	spin_unlock_irqrestore(&hellcreek->reg_lock, flags);
> +}
> +

  Andrew
