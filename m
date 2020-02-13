Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 091D415C943
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 18:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgBMRQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 12:16:13 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:58402 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbgBMRQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 12:16:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CW2tcY1SICyPiBILUelQjRAVuOU6UuW29LgBHYEyRds=; b=BkXW4SBQCgVxU76oevhJpHBbb
        lV+6wIutopcT/b17xe77r/InC8MejeMV9Ka6p0TbqLoqoYy4HS07gPpTXV6NH//r2NglIpBcrVtWl
        Vw+eOkozW6WMEI4bbcXcVf0Pr4pKiLC9BjFBukc6Z002gzez3pNtWBpLTUM5TYQEZHdMeq+07n2JF
        zmWjiHTH++otCtY0ebd3i5ZvPwGTZHMjLsYN+0dfxEi+TmAwhsPn/R4DCGO9IP/rJ6js4DsekT+x5
        dC+iz5+Ce+zfZXOjjE6evvSnqnpKYaOECzlG8gs4JPreXLWkf6ZoCW7DwxlatmVawinQ1JoV3ZNIq
        KpBCjkhLg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:47370)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j2I5u-0001sr-3Y; Thu, 13 Feb 2020 17:16:06 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j2I5q-0002Xd-BU; Thu, 13 Feb 2020 17:16:02 +0000
Date:   Thu, 13 Feb 2020 17:16:02 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: Heads up: phylink changes for next merge window
Message-ID: <20200213171602.GO25745@shell.armlinux.org.uk>
References: <20200213133831.GM25745@shell.armlinux.org.uk>
 <20200213144615.GH18808@shell.armlinux.org.uk>
 <20200213160004.GC31084@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213160004.GC31084@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 05:00:04PM +0100, Andrew Lunn wrote:
> On Thu, Feb 13, 2020 at 02:46:16PM +0000, Russell King - ARM Linux admin wrote:
> > [Recipient list updated; removed addresses that bounce, added Ioana
> > Ciornei for dpaa2 and DSA issue mentioned below.]
> > 
> > On Thu, Feb 13, 2020 at 01:38:31PM +0000, Russell King - ARM Linux admin wrote:
> > > Hi,
> > > 
> > > During the next round of development changes, I wish to make some
> > > changes to phylink which will affect almost every user out there,
> > > as it affects the interfaces to the MAC drivers.
> > > 
> > > The reason behind the change is to allow us to support situations
> > > where the MAC is not closely coupled with its associated PCS, such
> > > as is found in mvneta and mvpp2.  This is necessary to support
> > > already existing hardware properly, such as Marvell DSA and Xilinx
> > > AXI ethernet drivers, and there seems to be a growing need for this.
> > > 
> > > What I'm proposing to do is to move the MAC setup for the negotiated
> > > speed, duplex and pause settings to the mac_link_up() method, out of
> > > the existing mac_config() method.  I have already converted the
> > > axienet, dpaa2-mac, macb, mvneta, mvpp2 and mv88e6xxx (dsa) drivers,
> > > but I'm not able to test all those.  Thus far, I've tested dpaa2-mac,
> > > mvneta, and mv88e6xxx.  There's a bunch of other drivers that I don't
> > > know enough about the hardware to do the conversion myself.
> > 
> > I should also have pointed out that with mv88e6xxx, the patch
> > "net: mv88e6xxx: use resolved link config in mac_link_up()" "fixes" by
> > side-effect an issue that Andrew has mentioned, where inter-DSA ports
> > get configured down to 10baseHD speed.  This is by no means a true fix
> > for that problem - which is way deeper than this series can address.
> > The reason it fixes it is because we no longer set the speed/duplex
> > in mac_config() but set it in mac_link_up() - but mac_link_up() is
> > never called for CPU and DSA ports.
> > 
> > However, I think there may be another side-effect of that - any fixed
> > link declaration in DT may not be respected after this patch.
> > 
> > I believe the root of this goes back to this commit:
> > 
> >   commit 0e27921816ad99f78140e0c61ddf2bc515cc7e22
> >   Author: Ioana Ciornei <ioana.ciornei@nxp.com>
> >   Date:   Tue May 28 20:38:16 2019 +0300
> > 
> >   net: dsa: Use PHYLINK for the CPU/DSA ports
> > 
> > and, in the case of no fixed-link declaration, phylink has no idea what
> > the link parameters should be (and hence the initial bug, where
> > mac_config gets called with speed=0 duplex=0, which gets interpreted as
> > 10baseHD.)  Moreover, as far as phylink is concerned, these links never
> > come up. Essentially, this commit was not fully tested with inter-DSA
> > links, and probably was never tested with phylink debugging enabled.
> > 
> > There is currently no fix for this, and it is not an easy problem to
> > resolve, irrespective of the patches I'm proposing.
> 
> Hi Russell
> 
> I've been playing around with this a bit. I have a partial fix:
> 
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 9b54e5a76297..dc4da4dc44f5 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -629,9 +629,14 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
>  int dsa_port_link_register_of(struct dsa_port *dp)
>  {
>         struct dsa_switch *ds = dp->ds;
> +       struct device_node *phy_np;
>  
> -       if (!ds->ops->adjust_link)
> -               return dsa_port_phylink_register(dp);
> +       if (!ds->ops->adjust_link) {
> +               phy_np = of_parse_phandle(dp->dn, "phy-handle", 0);
> +               if (of_phy_is_fixed_link(dp->dn) || phy_np)
> +                       return dsa_port_phylink_register(dp);
> +               return 0;
> +       }
>  
>         dev_warn(ds->dev,
>                  "Using legacy PHYLIB callbacks. Please migrate to PHYLINK!\n");
> @@ -646,11 +651,12 @@ void dsa_port_link_unregister_of(struct dsa_port *dp)
>  {
>         struct dsa_switch *ds = dp->ds;
>  
> -       if (!ds->ops->adjust_link) {
> +       if (!ds->ops->adjust_link && dp->pl) {
>                 rtnl_lock();
>                 phylink_disconnect_phy(dp->pl);
>                 rtnl_unlock();
>                 phylink_destroy(dp->pl);
> +               dp->pl = NULL;
>                 return;
>         }
> 
> So basically only instantiate phylink if there is a fixed-link
> property, or a phy-handle.
> 
> What i think is still broken is if there is a phy-mode property, and
> nothing else. e.g. to set RGMII delays. I think that will get ignored.

Can you please verify that mac_link_up() gets called for these if
there is a fixed-link property or phy-handle?

Also, there is another way around this, which is for phylink_create()
to callback through the mac_ops to request the default configuration.
That could be plumbed down through the various DSA layers such that
the old "max speed / max link" business could be setup.  However,
that brings with it a new problem: if we default to a fixed-link, then
attempting to connect a phy later will be ignored.  However, deferring
the default create-time configuration setup to phylink_start() would
work around it, but brings with it a bit more complexity.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
