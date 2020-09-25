Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A852789F3
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 15:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbgIYNv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 09:51:26 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:38593 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728199AbgIYNvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 09:51:25 -0400
X-Originating-IP: 90.65.88.165
Received: from localhost (lfbn-lyo-1-1908-165.w90-65.abo.wanadoo.fr [90.65.88.165])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 10871E0002;
        Fri, 25 Sep 2020 13:51:21 +0000 (UTC)
Date:   Fri, 25 Sep 2020 15:51:21 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, horatiu.vultur@microchip.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [RFC PATCH net-next 01/14] net: mscc: ocelot: introduce a new
 ocelot_target_{read,write} API
Message-ID: <20200925135121.GA9675@piout.net>
References: <20200925121855.370863-1-vladimir.oltean@nxp.com>
 <20200925121855.370863-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925121855.370863-2-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/09/2020 15:18:42+0300, Vladimir Oltean wrote:
> There are some targets (register blocks) in the Ocelot switch that are
> instantiated more than once. For example, the VCAP IS1, IS2 and ES0
> blocks all share the same register layout for interacting with the cache
> for the TCAM and the action RAM.
> 
> For the VCAPs, the procedure for servicing them is actually common. We
> just need an API specifying which VCAP we are talking to, and we do that
> via these raw ocelot_target_read and ocelot_target_write accessors.
> 
> In plain ocelot_read, the target is encoded into the register enum
> itself:
> 
> 	u16 target = reg >> TARGET_OFFSET;
> 
> For the VCAPs, the registers are currently defined like this:
> 
> 	enum ocelot_reg {
> 	[...]
> 		S2_CORE_UPDATE_CTRL = S2 << TARGET_OFFSET,
> 		S2_CORE_MV_CFG,
> 		S2_CACHE_ENTRY_DAT,
> 		S2_CACHE_MASK_DAT,
> 		S2_CACHE_ACTION_DAT,
> 		S2_CACHE_CNT_DAT,
> 		S2_CACHE_TG_DAT,
> 	[...]
> 	};
> 
> which is precisely what we want to avoid, because we'd have to duplicate
> the same register map for S1 and for S0, and then figure out how to pass
> VCAP instance-specific registers to the ocelot_read calls (basically
> another lookup table that undoes the effect of shifting with
> TARGET_OFFSET).
> 
> So for some targets, propose a more raw API, similar to what is
> currently done with ocelot_port_readl and ocelot_port_writel. Those
> targets can only be accessed with ocelot_target_{read,write} and not
> with ocelot_{read,write} after the conversion, which is fine.
> 
> The VCAP registers are not actually modified to use this new API as of
> this patch. They will be modified in the next one.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  drivers/net/ethernet/mscc/ocelot_io.c | 17 +++++++++++++++++
>  include/soc/mscc/ocelot.h             | 14 ++++++++++++++
>  2 files changed, 31 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_io.c b/drivers/net/ethernet/mscc/ocelot_io.c
> index d22711282183..0acb45948418 100644
> --- a/drivers/net/ethernet/mscc/ocelot_io.c
> +++ b/drivers/net/ethernet/mscc/ocelot_io.c
> @@ -71,6 +71,23 @@ void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg)
>  }
>  EXPORT_SYMBOL(ocelot_port_writel);
>  
> +u32 __ocelot_target_read_ix(struct ocelot *ocelot, enum ocelot_target target,
> +			    u32 reg, u32 offset)
> +{
> +	u32 val;
> +
> +	regmap_read(ocelot->targets[target],
> +		    ocelot->map[target][reg] + offset, &val);
> +	return val;
> +}
> +
> +void __ocelot_target_write_ix(struct ocelot *ocelot, enum ocelot_target target,
> +			      u32 val, u32 reg, u32 offset)
> +{
> +	regmap_write(ocelot->targets[target],
> +		     ocelot->map[target][reg] + offset, val);
> +}
> +
>  int ocelot_regfields_init(struct ocelot *ocelot,
>  			  const struct reg_field *const regfields)
>  {
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 7e52e6ee09d8..a71ea217da70 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -662,6 +662,16 @@ struct ocelot_policer {
>  #define ocelot_fields_write(ocelot, id, reg, val) regmap_fields_write((ocelot)->regfields[(reg)], (id), (val))
>  #define ocelot_fields_read(ocelot, id, reg, val) regmap_fields_read((ocelot)->regfields[(reg)], (id), (val))
>  
> +#define ocelot_target_read_ix(ocelot, target, reg, gi, ri) __ocelot_target_read_ix(ocelot, target, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
> +#define ocelot_target_read_gix(ocelot, target, reg, gi) __ocelot_target_read_ix(ocelot, target, reg, reg##_GSZ * (gi))
> +#define ocelot_target_read_rix(ocelot, target, reg, ri) __ocelot_target_read_ix(ocelot, target, reg, reg##_RSZ * (ri))
> +#define ocelot_target_read(ocelot, target, reg) __ocelot_target_read_ix(ocelot, target, reg, 0)
> +
> +#define ocelot_target_write_ix(ocelot, target, val, reg, gi, ri) __ocelot_target_write_ix(ocelot, target, val, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
> +#define ocelot_target_write_gix(ocelot, target, val, reg, gi) __ocelot_target_write_ix(ocelot, target, val, reg, reg##_GSZ * (gi))
> +#define ocelot_target_write_rix(ocelot, target, val, reg, ri) __ocelot_target_write_ix(ocelot, target, val, reg, reg##_RSZ * (ri))
> +#define ocelot_target_write(ocelot, target, val, reg) __ocelot_target_write_ix(ocelot, target, val, reg, 0)
> +
>  /* I/O */
>  u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
>  void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
> @@ -669,6 +679,10 @@ u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset);
>  void __ocelot_write_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 offset);
>  void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
>  		     u32 offset);
> +u32 __ocelot_target_read_ix(struct ocelot *ocelot, enum ocelot_target target,
> +			    u32 reg, u32 offset);
> +void __ocelot_target_write_ix(struct ocelot *ocelot, enum ocelot_target target,
> +			      u32 val, u32 reg, u32 offset);
>  
>  /* Hardware initialization */
>  int ocelot_regfields_init(struct ocelot *ocelot,
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
