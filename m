Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A20F2F04BB
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 02:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbhAJBpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 20:45:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:57048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbhAJBpV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 20:45:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 359762085B;
        Sun, 10 Jan 2021 01:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610243080;
        bh=GBKwZqUpCq4d2J2k/dKL0TlvhBPzhT3UH84IlcXRREw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NNMjtCLpxutWdrR3F48JlduhBKvYxjegup8ByZpv619DQP1jodQ8o5u3VGMYpXFIS
         CIQ3UumKGy9MpQ2Ef3s9pd+2ZxsTwQ0U2iEVEZ+8PKDu+1d8oOO0Q7H2Tip2LbD3er
         pErxolnxTHh7clLQ0ITs2ETHONHgm732Etz9E0H8weMiVcVOZ1CWcfe45VSsHfWFcW
         uncuNnynHbkRhH34tysTEXBrF6BQR1/C12fDT6LDM6QGqc6bbLyO5UsDP3fQVhIhjH
         I9mIFbQlZU0IKl3zxZDBPe/5hWbMT8Ccom539fvPlYIDf8n/joRP6T/3rD7hCZ7Wtu
         tRiev5Ly0XE4w==
Date:   Sat, 9 Jan 2021 17:44:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next 08/10] net: mscc: ocelot: register devlink
 ports
Message-ID: <20210109174439.404713f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210108175950.484854-9-olteanv@gmail.com>
References: <20210108175950.484854-1-olteanv@gmail.com>
        <20210108175950.484854-9-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 Jan 2021 19:59:48 +0200 Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Add devlink integration into the mscc_ocelot switchdev driver. Only the
> probed interfaces are registered with devlink, because for convenience,
> struct devlink_port was included into struct ocelot_port_private, which
> is only initialized for the ports that are used.
> 
> Since we use devlink_port_type_eth_set to link the devlink port to the
> net_device, we can as well remove the .ndo_get_phys_port_name and
> .ndo_get_port_parent_id implementations, since devlink takes care of
> retrieving the port name and number automatically, once
> .ndo_get_devlink_port is implemented.
> 
> Note that the felix DSA driver is already integrated with devlink by
> default, since that is a thing that the DSA core takes care of. This is
> the reason why these devlink stubs were put in ocelot_net.c and not in
> the common library.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> index 2bd2840d88bd..d0d98c6adea8 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -8,6 +8,116 @@
>  #include "ocelot.h"
>  #include "ocelot_vcap.h"
>  
> +struct ocelot_devlink_private {
> +	struct ocelot *ocelot;
> +};

Why not make struct ocelot part of devlink_priv?

> +static const struct devlink_ops ocelot_devlink_ops = {
> +};
> +
> +static int ocelot_port_devlink_init(struct ocelot *ocelot, int port)
> +{
> +	struct ocelot_port *ocelot_port = ocelot->ports[port];
> +	int id_len = sizeof(ocelot->base_mac);
> +	struct devlink *dl = ocelot->devlink;
> +	struct devlink_port_attrs attrs = {};
> +	struct ocelot_port_private *priv;
> +	struct devlink_port *dlp;
> +	int err;
> +
> +	if (!ocelot_port)
> +		return 0;
> +
> +	priv = container_of(ocelot_port, struct ocelot_port_private, port);
> +	dlp = &priv->devlink_port;
> +
> +	memcpy(attrs.switch_id.id, &ocelot->base_mac, id_len);
> +	attrs.switch_id.id_len = id_len;
> +	attrs.phys.port_number = port;
> +
> +	if (priv->dev)
> +		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
> +	else
> +		attrs.flavour = DEVLINK_PORT_FLAVOUR_UNUSED;
> +
> +	devlink_port_attrs_set(dlp, &attrs);
> +
> +	err = devlink_port_register(dl, dlp, port);
> +	if (err)
> +		return err;
> +
> +	if (priv->dev)
> +		devlink_port_type_eth_set(dlp, priv->dev);

devlink_port_attrs_set() should be called before netdev is registered,
and devlink_port_type_eth_set() after. So this sequence makes me a tad
suspicious.

In particular IIRC devlink's .ndo_get_phys_port_name depends on it,
because udev event needs to carry the right info for interface renaming
to work reliably. No?

> +	return 0;
> +}
> +
> +static void ocelot_port_devlink_teardown(struct ocelot *ocelot, int port)
> +{
> +	struct ocelot_port *ocelot_port = ocelot->ports[port];
> +	struct ocelot_port_private *priv;
> +	struct devlink_port *dlp;
> +
> +	if (!ocelot_port)
> +		return;
> +
> +	priv = container_of(ocelot_port, struct ocelot_port_private, port);
> +	dlp = &priv->devlink_port;
> +
> +	devlink_port_unregister(dlp);
> +}
> +
> +int ocelot_devlink_init(struct ocelot *ocelot)
> +{
> +	struct ocelot_devlink_private *dl_priv;
> +	int port, err;
> +
> +	ocelot->devlink = devlink_alloc(&ocelot_devlink_ops, sizeof(*dl_priv));
> +	if (!ocelot->devlink)
> +		return -ENOMEM;
> +	dl_priv = devlink_priv(ocelot->devlink);
> +	dl_priv->ocelot = ocelot;
> +
> +	err = devlink_register(ocelot->devlink, ocelot->dev);
> +	if (err)
> +		goto free_devlink;
> +
> +	for (port = 0; port < ocelot->num_phys_ports; port++) {
> +		err = ocelot_port_devlink_init(ocelot, port);
> +		if (err) {
> +			while (port-- > 0)
> +				ocelot_port_devlink_teardown(ocelot, port);
> +			goto unregister_devlink;

nit: should this also be on the error path below?

> +		}
> +	}
> +
> +	return 0;
> +
> +unregister_devlink:
> +	devlink_unregister(ocelot->devlink);
> +free_devlink:
> +	devlink_free(ocelot->devlink);
> +	return err;
> +}

> --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> @@ -1293,6 +1293,12 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> +	err = ocelot_devlink_init(ocelot);
> +	if (err) {
> +		mscc_ocelot_release_ports(ocelot);
> +		goto out_ocelot_deinit;

No need to add ocelot_deinit_timestamp(ocelot); to the error path?

> +	}
> +
>  	register_netdevice_notifier(&ocelot_netdevice_nb);
>  	register_switchdev_notifier(&ocelot_switchdev_nb);
>  	register_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);

