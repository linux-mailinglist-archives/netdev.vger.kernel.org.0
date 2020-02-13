Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D74FC15C663
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 17:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387600AbgBMQAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 11:00:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44414 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728951AbgBMQAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 11:00:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GqcsyLWmGb2dSMERSHn4OXslAy2h8cjMOojWb7vvk/E=; b=X90OdSKxqkWoBe1H/vIEgLOk7O
        ftTJhw8zRJ/SOeIPi8hn4Azv+w4wCcjWfEcCDIJ/IeaTmFAPbFm3GJxV5DhR+txilyaLNdWn5YlF3
        gCZmmJq5xmz2zTnkQGT5c/3r46CMgjMEJF/ryqX0m3GOggY3d+DxdQRTKYKYPdGGXO8M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j2GuK-0003mi-Tt; Thu, 13 Feb 2020 17:00:04 +0100
Date:   Thu, 13 Feb 2020 17:00:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
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
Message-ID: <20200213160004.GC31084@lunn.ch>
References: <20200213133831.GM25745@shell.armlinux.org.uk>
 <20200213144615.GH18808@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213144615.GH18808@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 02:46:16PM +0000, Russell King - ARM Linux admin wrote:
> [Recipient list updated; removed addresses that bounce, added Ioana
> Ciornei for dpaa2 and DSA issue mentioned below.]
> 
> On Thu, Feb 13, 2020 at 01:38:31PM +0000, Russell King - ARM Linux admin wrote:
> > Hi,
> > 
> > During the next round of development changes, I wish to make some
> > changes to phylink which will affect almost every user out there,
> > as it affects the interfaces to the MAC drivers.
> > 
> > The reason behind the change is to allow us to support situations
> > where the MAC is not closely coupled with its associated PCS, such
> > as is found in mvneta and mvpp2.  This is necessary to support
> > already existing hardware properly, such as Marvell DSA and Xilinx
> > AXI ethernet drivers, and there seems to be a growing need for this.
> > 
> > What I'm proposing to do is to move the MAC setup for the negotiated
> > speed, duplex and pause settings to the mac_link_up() method, out of
> > the existing mac_config() method.  I have already converted the
> > axienet, dpaa2-mac, macb, mvneta, mvpp2 and mv88e6xxx (dsa) drivers,
> > but I'm not able to test all those.  Thus far, I've tested dpaa2-mac,
> > mvneta, and mv88e6xxx.  There's a bunch of other drivers that I don't
> > know enough about the hardware to do the conversion myself.
> 
> I should also have pointed out that with mv88e6xxx, the patch
> "net: mv88e6xxx: use resolved link config in mac_link_up()" "fixes" by
> side-effect an issue that Andrew has mentioned, where inter-DSA ports
> get configured down to 10baseHD speed.  This is by no means a true fix
> for that problem - which is way deeper than this series can address.
> The reason it fixes it is because we no longer set the speed/duplex
> in mac_config() but set it in mac_link_up() - but mac_link_up() is
> never called for CPU and DSA ports.
> 
> However, I think there may be another side-effect of that - any fixed
> link declaration in DT may not be respected after this patch.
> 
> I believe the root of this goes back to this commit:
> 
>   commit 0e27921816ad99f78140e0c61ddf2bc515cc7e22
>   Author: Ioana Ciornei <ioana.ciornei@nxp.com>
>   Date:   Tue May 28 20:38:16 2019 +0300
> 
>   net: dsa: Use PHYLINK for the CPU/DSA ports
> 
> and, in the case of no fixed-link declaration, phylink has no idea what
> the link parameters should be (and hence the initial bug, where
> mac_config gets called with speed=0 duplex=0, which gets interpreted as
> 10baseHD.)  Moreover, as far as phylink is concerned, these links never
> come up. Essentially, this commit was not fully tested with inter-DSA
> links, and probably was never tested with phylink debugging enabled.
> 
> There is currently no fix for this, and it is not an easy problem to
> resolve, irrespective of the patches I'm proposing.

Hi Russell

I've been playing around with this a bit. I have a partial fix:

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 9b54e5a76297..dc4da4dc44f5 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -629,9 +629,14 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 int dsa_port_link_register_of(struct dsa_port *dp)
 {
        struct dsa_switch *ds = dp->ds;
+       struct device_node *phy_np;
 
-       if (!ds->ops->adjust_link)
-               return dsa_port_phylink_register(dp);
+       if (!ds->ops->adjust_link) {
+               phy_np = of_parse_phandle(dp->dn, "phy-handle", 0);
+               if (of_phy_is_fixed_link(dp->dn) || phy_np)
+                       return dsa_port_phylink_register(dp);
+               return 0;
+       }
 
        dev_warn(ds->dev,
                 "Using legacy PHYLIB callbacks. Please migrate to PHYLINK!\n");
@@ -646,11 +651,12 @@ void dsa_port_link_unregister_of(struct dsa_port *dp)
 {
        struct dsa_switch *ds = dp->ds;
 
-       if (!ds->ops->adjust_link) {
+       if (!ds->ops->adjust_link && dp->pl) {
                rtnl_lock();
                phylink_disconnect_phy(dp->pl);
                rtnl_unlock();
                phylink_destroy(dp->pl);
+               dp->pl = NULL;
                return;
        }

So basically only instantiate phylink if there is a fixed-link
property, or a phy-handle.

What i think is still broken is if there is a phy-mode property, and
nothing else. e.g. to set RGMII delays. I think that will get ignored.

	Andrew
