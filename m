Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B61446BB9C
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 13:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236622AbhLGMvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 07:51:09 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33758 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235911AbhLGMvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 07:51:08 -0500
Received: from [IPv6:2a00:23c6:c31a:b300:ef00:525b:f7cd:f7f8] (unknown [IPv6:2a00:23c6:c31a:b300:ef00:525b:f7cd:f7f8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: martyn)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 827671F44641;
        Tue,  7 Dec 2021 12:47:37 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=collabora.com; s=mail;
        t=1638881257; bh=WN8BIluR9aXH8Myp/vPHZ7HC8q+LpslFVWlf/wBHyfk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FDnKQqC3jsRIxEcXuTYalIVsI6iSKw+bckT/oTMewVdCRy0ooN854dkAEg0EARITI
         TWdOu8Y6y2hih4ozAtDl/ipniC8VTplD+uEMn73GNdiGPUS6Dm+mJ+YWGwb2a4eSWD
         or7j3IhLfZYFL2uStkEh+bmCn05lpzdZsE3320n7DzeeesWyPqsWWxdLZNiCHkRYDM
         reMDsLAQmZteYDlGPfH6qcJyCYQptrxDiVhrw9cjyHk047Q4yuoqdkCJDDNwrayGbw
         f15e+8UKaSeM3mNz2ofYvbI8Ro09CR1jvuZknKU8AsXDc7kJSbl7nCmvf1wYP17yym
         Nb2v6obm+tOQw==
Message-ID: <aa5e48e4b03eb9fd8eb6dacb439ef8e600245774.camel@collabora.com>
Subject: Re: [PATCH RFC net] net: dsa: mv88e6xxx: allow use of PHYs on CPU
 and DSA ports
From:   Martyn Welch <martyn.welch@collabora.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Date:   Tue, 07 Dec 2021 12:47:35 +0000
In-Reply-To: <E1muYBr-00EwOF-9C@rmk-PC.armlinux.org.uk>
References: <E1muYBr-00EwOF-9C@rmk-PC.armlinux.org.uk>
Organization: Collabora Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry Russell, but unfortunately this patch doesn't seem to be
resolving the issue for me.

I've dumped in a bit of debug around this change to see if I could
determine what was going on here, it seems that in my case the function
is being exited before this at:

/* FIXME: is this the correct test? If we're in fixed mode on an
 * internal port, why should we process this any different from
 * PHY mode? On the other hand, the port may be automedia between
 * an internal PHY and the serdes...
 */
if ((mode == MLO_AN_PHY) && mv88e6xxx_phy_is_internal(ds, port))
        return;

Martyn


On Tue, 2021-12-07 at 10:59 +0000, Russell King (Oracle) wrote:
> Martyn Welch reports that his CPU port is unable to link where it has
> been necessary to use one of the switch ports with an internal PHY for
> the CPU port. The reason behind this is the port control register is
> left forcing the link down, preventing traffic flow.
> 
> This occurs because during initialisation, phylink expects the link to
> be down, and DSA forces the link down by synthesising a call to the
> DSA drivers phylink_mac_link_down() method, but we don't touch the
> forced-link state when we later reconfigure the port.
> 
> Resolve this by also unforcing the link state when we are operating in
> PHY mode and the PPU is set to poll the PHY to retrieve link status
> information.
> 
> Reported-by: Martyn Welch <martyn.welch@collabora.com>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
> This patch requires:
> https://lore.kernel.org/r/E1muXm7-00EwJB-7n@rmk-PC.armlinux.org.uk
> 
> If we convert Marvell DSA filly to split PCS (we have 6185 and 6352
> complete, 6390 and 6393 remain), the "legacy_march2020" patches, and
> the phylink get_caps patches, we can then make Marvell DSA a non-
> legacy phylink driver. This gives much cleaner semantics concerning
> when the phylink_mac_config() method is called. Specifically, being
> non-legacy means phylink_mac_config() will no longer be called just
> before every phylink_mac_link_up() method call, and will not be called
> for in-band advertisement changes.
> 
> This means that phylink_mac_config() will only be called when the port
> needs to be reconfigured, which allows drivers to force the link down
> for safe reconfiguration without potentially causing an infinite loop
> of link-down link-up events that can occur with the legacy behaviour.
> 
> Thus, being non-legacy and allowing the forcing removes the need for
> DSA to synthesise a call to phylink_mac_link_down() at initialisation
> time for this driver... but we need all DSA drivers to be non-legacy
> before we can safely remove that.
> 
>  drivers/net/dsa/mv88e6xxx/chip.c | 56 +++++++++++++++++++-------------
>  1 file changed, 34 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c
> b/drivers/net/dsa/mv88e6xxx/chip.c
> index 9f675464efc3..b033e653d3f4 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -698,7 +698,7 @@ static void mv88e6xxx_mac_config(struct dsa_switch
> *ds, int port,
>  {
>         struct mv88e6xxx_chip *chip = ds->priv;
>         struct mv88e6xxx_port *p;
> -       int err;
> +       int err = 0;
>  
>         p = &chip->ports[port];
>  
> @@ -711,31 +711,43 @@ static void mv88e6xxx_mac_config(struct
> dsa_switch *ds, int port,
>                 return;
>  
>         mv88e6xxx_reg_lock(chip);
> -       /* In inband mode, the link may come up at any time while the
> link
> -        * is not forced down. Force the link down while we reconfigure
> the
> -        * interface mode.
> -        */
> -       if (mode == MLO_AN_INBAND && p->interface != state->interface
> &&
> -           chip->info->ops->port_set_link)
> -               chip->info->ops->port_set_link(chip, port,
> LINK_FORCED_DOWN);
>  
> -       err = mv88e6xxx_port_config_interface(chip, port, state-
> >interface);
> -       if (err && err != -EOPNOTSUPP)
> -               goto err_unlock;
> -
> -       err = mv88e6xxx_serdes_pcs_config(chip, port, mode, state-
> >interface,
> -                                         state->advertising);
> -       /* FIXME: we should restart negotiation if something changed -
> which
> -        * is something we get if we convert to using phylinks PCS
> operations.
> -        */
> -       if (err > 0)
> -               err = 0;
> +       if (mode != MLO_AN_PHY || !mv88e6xxx_phy_is_internal(ds, port))
> {
> +               /* In inband mode, the link may come up at any time
> while the
> +                * link is not forced down. Force the link down while
> we
> +                * reconfigure the interface mode.
> +                */
> +               if (mode == MLO_AN_INBAND &&
> +                   p->interface != state->interface &&
> +                   chip->info->ops->port_set_link)
> +                       chip->info->ops->port_set_link(chip, port,
> +                                                     
> LINK_FORCED_DOWN);
> +
> +               err = mv88e6xxx_port_config_interface(chip, port,
> +                                                     state-
> >interface);
> +               if (err && err != -EOPNOTSUPP)
> +                       goto err_unlock;
> +
> +               err = mv88e6xxx_serdes_pcs_config(chip, port, mode,
> +                                                 state->interface,
> +                                                 state->advertising);
> +               /* FIXME: we should restart negotiation if something
> changed -
> +                * which is something we get if we convert to using
> phylinks
> +                * PCS operations.
> +                */
> +               if (err > 0)
> +                       err = 0;
> +       }
>  
>         /* Undo the forced down state above after completing
> configuration
> -        * irrespective of its state on entry, which allows the link to
> come up.
> +        * irrespective of its state on entry, which allows the link to
> come
> +        * up in the in-band case where there is no separate SERDES.
> Also
> +        * ensure that the link can come up if the PPU is in use and we
> are
> +        * in PHY mode (we treat the PPU as an effective in-band
> mechanism.)
>          */
> -       if (mode == MLO_AN_INBAND && p->interface != state->interface
> &&
> -           chip->info->ops->port_set_link)
> +       if (chip->info->ops->port_set_link &&
> +           ((mode == MLO_AN_INBAND && p->interface != state-
> >interface) ||
> +            (mode == MLO_AN_PHY && mv88e6xxx_port_ppu_updates(chip,
> port))))
>                 chip->info->ops->port_set_link(chip, port,
> LINK_UNFORCED);
>  
>         p->interface = state->interface;

