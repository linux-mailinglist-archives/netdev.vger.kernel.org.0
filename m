Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC912F1EF4
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390831AbhAKTTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:19:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:47590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729848AbhAKTTv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 14:19:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBDD322CA1;
        Mon, 11 Jan 2021 19:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610392750;
        bh=qyqtYiDmyEJXiOemYdrIt2SHtlQMWZ+2Xd4LmitfmoU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e8OCsIY83PyHbl+NyweSe9Ax6hHeJ6kR+ULuYRocRXhPT2ipZ9QNBfxUgndi06aYE
         M6xDGsVSXtVC/x0UkYzUUUMwm2TIsm9S2QXxZrquq4Vj+PdjnAu0OE5TciblvNXauF
         X7awNGaia4bS3D1VRLSLFe6A3uYUg4kYyxBIFuW47SjqcEpXC26PvtFGx/6X+/5Ok/
         C/JcFZ1UGjdc5oexENpomWfYq4opzrPeSKamoGSdcY152GF8kWQptvrXjzCpBre/Nt
         szjGVoc+cyb6g9Y3sguDZ+bcDPdEB05s6FycWcGbJWGw3qdvFacMPOiesfp4WqPF7r
         PSwu/v4PYPFZA==
Date:   Mon, 11 Jan 2021 11:19:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next 08/10] net: mscc: ocelot: register devlink
 ports
Message-ID: <20210111111909.4cf0174f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210111171344.j6chsp5djr5t5ykk@skbuf>
References: <20210108175950.484854-1-olteanv@gmail.com>
        <20210108175950.484854-9-olteanv@gmail.com>
        <20210109174439.404713f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210111171344.j6chsp5djr5t5ykk@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jan 2021 19:13:44 +0200 Vladimir Oltean wrote:
> On Sat, Jan 09, 2021 at 05:44:39PM -0800, Jakub Kicinski wrote:
> > On Fri,  8 Jan 2021 19:59:48 +0200 Vladimir Oltean wrote:  
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > 
> > > Add devlink integration into the mscc_ocelot switchdev driver. Only the
> > > probed interfaces are registered with devlink, because for convenience,
> > > struct devlink_port was included into struct ocelot_port_private, which
> > > is only initialized for the ports that are used.
> > > 
> > > Since we use devlink_port_type_eth_set to link the devlink port to the
> > > net_device, we can as well remove the .ndo_get_phys_port_name and
> > > .ndo_get_port_parent_id implementations, since devlink takes care of
> > > retrieving the port name and number automatically, once
> > > .ndo_get_devlink_port is implemented.
> > > 
> > > Note that the felix DSA driver is already integrated with devlink by
> > > default, since that is a thing that the DSA core takes care of. This is
> > > the reason why these devlink stubs were put in ocelot_net.c and not in
> > > the common library.
> > > 
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>  
> >   
> > > diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
> > > index 2bd2840d88bd..d0d98c6adea8 100644
> > > --- a/drivers/net/ethernet/mscc/ocelot_net.c
> > > +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> > > @@ -8,6 +8,116 @@
> > >  #include "ocelot.h"
> > >  #include "ocelot_vcap.h"
> > >  
> > > +struct ocelot_devlink_private {
> > > +	struct ocelot *ocelot;
> > > +};  
> > 
> > Why not make struct ocelot part of devlink_priv?  
> 
> I am not sure what you mean.

You put a pointer to struct ocelot inside devlink->priv, why not put
the actual struct ocelot there?

> > > +static const struct devlink_ops ocelot_devlink_ops = {
> > > +};
> > > +
> > > +static int ocelot_port_devlink_init(struct ocelot *ocelot, int port)
> > > +{
> > > +	struct ocelot_port *ocelot_port = ocelot->ports[port];
> > > +	int id_len = sizeof(ocelot->base_mac);
> > > +	struct devlink *dl = ocelot->devlink;
> > > +	struct devlink_port_attrs attrs = {};
> > > +	struct ocelot_port_private *priv;
> > > +	struct devlink_port *dlp;
> > > +	int err;
> > > +
> > > +	if (!ocelot_port)
> > > +		return 0;
> > > +
> > > +	priv = container_of(ocelot_port, struct ocelot_port_private, port);
> > > +	dlp = &priv->devlink_port;
> > > +
> > > +	memcpy(attrs.switch_id.id, &ocelot->base_mac, id_len);
> > > +	attrs.switch_id.id_len = id_len;
> > > +	attrs.phys.port_number = port;
> > > +
> > > +	if (priv->dev)
> > > +		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
> > > +	else
> > > +		attrs.flavour = DEVLINK_PORT_FLAVOUR_UNUSED;
> > > +
> > > +	devlink_port_attrs_set(dlp, &attrs);
> > > +
> > > +	err = devlink_port_register(dl, dlp, port);
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	if (priv->dev)
> > > +		devlink_port_type_eth_set(dlp, priv->dev);  
> > 
> > devlink_port_attrs_set() should be called before netdev is registered,
> > and devlink_port_type_eth_set() after. So this sequence makes me a tad
> > suspicious.
> > 
> > In particular IIRC devlink's .ndo_get_phys_port_name depends on it,
> > because udev event needs to carry the right info for interface renaming
> > to work reliably. No?
> 
> If I change the driver's Kconfig from tristate to bool, all is fine,
> isn't it?

How does Kconfig change the order of registration of objects to
subsystems _within_ the driver?

Can you unbind and bind the driver back and see if phys_port_name
always gets the correct value? (replay/udevadm test is not sufficient)
