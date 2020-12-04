Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE092CF3B6
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbgLDSOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:14:12 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39897 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728703AbgLDSOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 13:14:12 -0500
X-Originating-IP: 86.194.74.19
Received: from localhost (lfbn-lyo-1-997-19.w86-194.abo.wanadoo.fr [86.194.74.19])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id AA04C60003;
        Fri,  4 Dec 2020 18:13:29 +0000 (UTC)
Date:   Fri, 4 Dec 2020 19:13:29 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: Re: [PATCH net] net: mscc: ocelot: fix dropping of unknown IPv4
 multicast on Seville
Message-ID: <20201204181329.GM74177@piout.net>
References: <20201204175416.1445937-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204175416.1445937-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/12/2020 19:54:16+0200, Vladimir Oltean wrote:
> The current assumption is that the felix DSA driver has flooding knobs
> per traffic class, while ocelot switchdev has a single flooding knob.
> This was correct for felix VSC9959 and ocelot VSC7514, but with the
> introduction of seville VSC9953, we see a switch driven by felix.c which
> has a single flooding knob.
> 
> So it is clear that we must do what should have been done from the
> beginning, which is not to overwrite the configuration done by ocelot.c
> in felix, but instead to teach the common ocelot library about the
> differences in our switches, and set up the flooding PGIDs centrally.
> 
> The effect that the bogus iteration through FELIX_NUM_TC has upon
> seville is quite dramatic. ANA_FLOODING is located at 0x00b548, and
> ANA_FLOODING_IPMC is located at 0x00b54c. So the bogus iteration will
> actually overwrite ANA_FLOODING_IPMC when attempting to write
> ANA_FLOODING[1]. There is no ANA_FLOODING[1] in sevile, just ANA_FLOODING.
> 
> And when ANA_FLOODING_IPMC is overwritten with a bogus value, the effect
> is that ANA_FLOODING_IPMC gets the value of 0x0003CF7D:
> 	MC6_DATA = 61,
> 	MC6_CTRL = 61,
> 	MC4_DATA = 60,
> 	MC4_CTRL = 0.
> Because MC4_CTRL is zero, this means that IPv4 multicast control packets
> are not flooded, but dropped. An invalid configuration, and this is how
> the issue was actually spotted.
> 
> Reported-by: Eldar Gasanov <eldargasanov2@gmail.com>
> Reported-by: Maxim Kochetkov <fido_max@inbox.ru>
> Tested-by: Eldar Gasanov <eldargasanov2@gmail.com>
> Fixes: 84705fc16552 ("net: dsa: felix: introduce support for Seville VSC9953 switch")
> Fixes: 3c7b51bd39b2 ("net: dsa: felix: allow flooding for all traffic classes")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

> ---
>  drivers/net/dsa/ocelot/felix.c             | 7 -------
>  drivers/net/dsa/ocelot/felix_vsc9959.c     | 1 +
>  drivers/net/dsa/ocelot/seville_vsc9953.c   | 1 +
>  drivers/net/ethernet/mscc/ocelot.c         | 9 +++++----
>  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 1 +
>  include/soc/mscc/ocelot.h                  | 3 +++
>  6 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index ada75fa15861..7dc230677b78 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -588,7 +588,6 @@ static int felix_setup(struct dsa_switch *ds)
>  	struct ocelot *ocelot = ds->priv;
>  	struct felix *felix = ocelot_to_felix(ocelot);
>  	int port, err;
> -	int tc;
>  
>  	err = felix_init_structs(felix, ds->num_ports);
>  	if (err)
> @@ -627,12 +626,6 @@ static int felix_setup(struct dsa_switch *ds)
>  	ocelot_write_rix(ocelot,
>  			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
>  			 ANA_PGID_PGID, PGID_UC);
> -	/* Setup the per-traffic class flooding PGIDs */
> -	for (tc = 0; tc < FELIX_NUM_TC; tc++)
> -		ocelot_write_rix(ocelot, ANA_FLOODING_FLD_MULTICAST(PGID_MC) |
> -				 ANA_FLOODING_FLD_BROADCAST(PGID_MC) |
> -				 ANA_FLOODING_FLD_UNICAST(PGID_UC),
> -				 ANA_FLOODING, tc);
>  
>  	ds->mtu_enforcement_ingress = true;
>  	ds->configure_vlan_while_not_filtering = true;
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index 3e925b8d5306..2e5bbdca5ea4 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -1429,6 +1429,7 @@ static int felix_pci_probe(struct pci_dev *pdev,
>  	pci_set_drvdata(pdev, felix);
>  	ocelot = &felix->ocelot;
>  	ocelot->dev = &pdev->dev;
> +	ocelot->num_flooding_pgids = FELIX_NUM_TC;
>  	felix->info = &felix_info_vsc9959;
>  	felix->switch_base = pci_resource_start(pdev,
>  						felix->info->switch_pci_bar);
> diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
> index 1d420c4a2f0f..ebbaf6817ec8 100644
> --- a/drivers/net/dsa/ocelot/seville_vsc9953.c
> +++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
> @@ -1210,6 +1210,7 @@ static int seville_probe(struct platform_device *pdev)
>  
>  	ocelot = &felix->ocelot;
>  	ocelot->dev = &pdev->dev;
> +	ocelot->num_flooding_pgids = 1;
>  	felix->info = &seville_info_vsc9953;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 2632fe2d2448..abea8dd2b0cb 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -1551,10 +1551,11 @@ int ocelot_init(struct ocelot *ocelot)
>  		     SYS_FRM_AGING_MAX_AGE(307692), SYS_FRM_AGING);
>  
>  	/* Setup flooding PGIDs */
> -	ocelot_write_rix(ocelot, ANA_FLOODING_FLD_MULTICAST(PGID_MC) |
> -			 ANA_FLOODING_FLD_BROADCAST(PGID_MC) |
> -			 ANA_FLOODING_FLD_UNICAST(PGID_UC),
> -			 ANA_FLOODING, 0);
> +	for (i = 0; i < ocelot->num_flooding_pgids; i++)
> +		ocelot_write_rix(ocelot, ANA_FLOODING_FLD_MULTICAST(PGID_MC) |
> +				 ANA_FLOODING_FLD_BROADCAST(PGID_MC) |
> +				 ANA_FLOODING_FLD_UNICAST(PGID_UC),
> +				 ANA_FLOODING, i);
>  	ocelot_write(ocelot, ANA_FLOODING_IPMC_FLD_MC6_DATA(PGID_MCIPV6) |
>  		     ANA_FLOODING_IPMC_FLD_MC6_CTRL(PGID_MC) |
>  		     ANA_FLOODING_IPMC_FLD_MC4_DATA(PGID_MCIPV4) |
> diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> index dc00772950e5..1e7729421a82 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> @@ -1254,6 +1254,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
>  	}
>  
>  	ocelot->num_phys_ports = of_get_child_count(ports);
> +	ocelot->num_flooding_pgids = 1;
>  
>  	ocelot->vcap = vsc7514_vcap_props;
>  	ocelot->inj_prefix = OCELOT_TAG_PREFIX_NONE;
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index ea1de185f2e4..731116611390 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -621,6 +621,9 @@ struct ocelot {
>  	/* Keep track of the vlan port masks */
>  	u32				vlan_mask[VLAN_N_VID];
>  
> +	/* Switches like VSC9959 have flooding per traffic class */
> +	int				num_flooding_pgids;
> +
>  	/* In tables like ANA:PORT and the ANA:PGID:PGID mask,
>  	 * the CPU is located after the physical ports (at the
>  	 * num_phys_ports index).
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
