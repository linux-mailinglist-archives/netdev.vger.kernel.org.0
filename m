Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D45B4251FB
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 13:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241008AbhJGLbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 07:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhJGLa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 07:30:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7155FC061746;
        Thu,  7 Oct 2021 04:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DXOPqnve8HpVJx1NvrYymtmwOdCv2JOGyKc2Ft8aGtw=; b=uOyJjhDEXEAau3KlLiPsnSAPmF
        3gL+fv8vEiwm1eZk8l/BQ87h7+Z4v0cK6MVaeSrAFDNsiIxsDVkdtn0hyJXkKEpCHm/jA9QZODRWJ
        x2ng77GYUH9FepNWrQuhuMotSXAgvuZavpLgXgT0gG8P/p4BNLG8YxGhmDIQAywPpo2BHHcAuU8YD
        5TOIJzLafgRKSH+VuBKW3yTkbOtbLhj6roXaklLmYcMa/btgBOpc3F/eAmZQY4UuMHf2+D2Xrkskr
        KRhOeBYwYFTcdNz0JvG8GIG+gk00a5SQhua0WJW6DVhHtaxpFBTJnz0dz40sxSLwOVyX+Q1F42sbp
        dJdKUTLw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54996)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mYRaA-0002O0-Oi; Thu, 07 Oct 2021 12:29:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mYRa8-0001r4-Sw; Thu, 07 Oct 2021 12:29:00 +0100
Date:   Thu, 7 Oct 2021 12:29:00 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: Re: [RFC net-next PATCH 10/16] net: macb: Move PCS settings to PCS
 callbacks
Message-ID: <YV7Z/MF7geOp+JM2@shell.armlinux.org.uk>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-11-sean.anderson@seco.com>
 <YVwjjghGcXaEYgY+@shell.armlinux.org.uk>
 <7c92218c-baec-a991-9d6b-af42dfabbad3@seco.com>
 <YVyfEOu+emsX/ERr@shell.armlinux.org.uk>
 <ddb81bf5-af74-1619-b083-0dba189a5061@seco.com>
 <YVzPgTAS0grKl6CN@shell.armlinux.org.uk>
 <YV7NHZRFZ9U3Xj8v@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV7NHZRFZ9U3Xj8v@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 11:34:06AM +0100, Russell King (Oracle) wrote:
> On Tue, Oct 05, 2021 at 11:19:45PM +0100, Russell King (Oracle) wrote:
> > On Tue, Oct 05, 2021 at 05:44:11PM -0400, Sean Anderson wrote:
> > > At the very least, it should be clearer what things are allowed to fail
> > > for what reasons. Several callbacks are void when things can fail under
> > > the hood (e.g. link_up or an_restart). And the API seems to have been
> > > primarily designed around PCSs which are tightly-coupled to their MACs.
> 
> I think what I'd like to see is rather than a validate() callback for
> the PCS, a bitmap of phy_interface_t modes that the PCS supports,
> which is the direction I was wanting to take phylink and SFP support.
> 
> We can then use that information to inform the interface selection in
> phylink and avoid interface modes that the PCS doesn't support.
> 
> However, things get tricky when we have several PCS that we can switch
> between, and the switching is done in mac_prepare(). The current PCS
> (if there is even a PCS attached) may not represent the abilities
> that are actually available.
> 
> It sounds easy - just throw in an extra validation step when calling
> phylink_validate(), but it isn't that simple. To avoid breaking
> existing setups, phylink would need to know of every PCS that _could_
> be attached, and the decisions that the MAC makes to select which PCS
> is going to be used for any configuration.
> 
> We could possibly introduce a .mac_select_pcs(interface) method
> which the MAC could return the PCS it wishes to use for the interface
> mode with the guarantee that the PCS it returns is suitable - and if
> it returns NULL that means the interface mode is unsupported. That,
> along with the bitmask would probably work.

Here's a patch which illustrates roughly what I'm thinking at the
moment - only build tested.

mac_select_pcs() should not ever fail in phylink_major_config() - that
would be a bug. I've hooked mac_select_pcs() also into the validate
function so we can catch problems there, but we will need to involve
the PCS in the interface selection for SFPs etc.

Note that mac_select_pcs() must be inconsequential - it's asking the
MAC which PCS it wishes to use for the interface mode.

I am still very much undecided whether we wish phylink to parse the
pcs-handle property and if present, override the MAC - I feel that
logic depends in the MAC driver, since a single PCS can be very
restrictive in terms of what interface modes are supportable. If the
MAC wishes pcs-handle to override its internal ones, then it can
always do:

	if (port->external_pcs)
		return port->external_pcs;

in its mac_select_pcs() implementation. This gives us a bit of future
flexibility.

If we parse pcs-handle in phylink, then if we end up with multiple PCS
to choose from, we then need to work out how to either allow the MAC
driver to tell phylink not to parse pcs-handle, or we need some way for
phylink to ask the MAC "these are the PCS I have, which one should I
use" which is yet another interface.

What I don't like about the patch is the need to query the PCS based on
interface - when we have a SFP plugged in, it may support multiple
interfaces. I think we still need the MAC to restrict what it returns
in its validate() method according to the group of PCS that it has
available for the SFP interface selection to work properly. Things in
this regard should become easier _if_ I can switch phylink over to
selecting interface based on phy_interface_t bitmaps rather than the
current bodge using ethtool link modes, but that needs changes to phylib
and all MAC drivers, otherwise we have to support two entirely separate
ways to select the interface mode.

My argument against that is... I'll end up converting the network
interfaces that I use to the new implementation, and the old version
will start to rot. I've already stopped testing phylink without a PCS
attached for this very reason. The more legacy code we keep, the worse
this problem becomes.

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index cf8acabb90ac..ad73a488fc5f 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -1239,7 +1239,8 @@ struct mvpp2_port {
 	phy_interface_t phy_interface;
 	struct phylink *phylink;
 	struct phylink_config phylink_config;
-	struct phylink_pcs phylink_pcs;
+	struct phylink_pcs pcs_gmac;
+	struct phylink_pcs pcs_xlg;
 	struct phy *comphy;
 
 	struct mvpp2_bm_pool *pool_long;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 3197526455d9..509ff0e68e2a 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6105,15 +6105,20 @@ static struct mvpp2_port *mvpp2_phylink_to_port(struct phylink_config *config)
 	return container_of(config, struct mvpp2_port, phylink_config);
 }
 
-static struct mvpp2_port *mvpp2_pcs_to_port(struct phylink_pcs *pcs)
+static struct mvpp2_port *mvpp2_pcs_xlg_to_port(struct phylink_pcs *pcs)
 {
-	return container_of(pcs, struct mvpp2_port, phylink_pcs);
+	return container_of(pcs, struct mvpp2_port, pcs_xlg);
+}
+
+static struct mvpp2_port *mvpp2_pcs_gmac_to_port(struct phylink_pcs *pcs)
+{
+	return container_of(pcs, struct mvpp2_port, pcs_gmac);
 }
 
 static void mvpp2_xlg_pcs_get_state(struct phylink_pcs *pcs,
 				    struct phylink_link_state *state)
 {
-	struct mvpp2_port *port = mvpp2_pcs_to_port(pcs);
+	struct mvpp2_port *port = mvpp2_pcs_xlg_to_port(pcs);
 	u32 val;
 
 	state->speed = SPEED_10000;
@@ -6148,7 +6153,7 @@ static const struct phylink_pcs_ops mvpp2_phylink_xlg_pcs_ops = {
 static void mvpp2_gmac_pcs_get_state(struct phylink_pcs *pcs,
 				     struct phylink_link_state *state)
 {
-	struct mvpp2_port *port = mvpp2_pcs_to_port(pcs);
+	struct mvpp2_port *port = mvpp2_pcs_gmac_to_port(pcs);
 	u32 val;
 
 	val = readl(port->base + MVPP2_GMAC_STATUS0);
@@ -6185,7 +6190,7 @@ static int mvpp2_gmac_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 				 const unsigned long *advertising,
 				 bool permit_pause_to_mac)
 {
-	struct mvpp2_port *port = mvpp2_pcs_to_port(pcs);
+	struct mvpp2_port *port = mvpp2_pcs_gmac_to_port(pcs);
 	u32 mask, val, an, old_an, changed;
 
 	mask = MVPP2_GMAC_IN_BAND_AUTONEG_BYPASS |
@@ -6239,7 +6244,7 @@ static int mvpp2_gmac_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 
 static void mvpp2_gmac_pcs_an_restart(struct phylink_pcs *pcs)
 {
-	struct mvpp2_port *port = mvpp2_pcs_to_port(pcs);
+	struct mvpp2_port *port = mvpp2_pcs_gmac_to_port(pcs);
 	u32 val = readl(port->base + MVPP2_GMAC_AUTONEG_CONFIG);
 
 	writel(val | MVPP2_GMAC_IN_BAND_RESTART_AN,
@@ -6428,8 +6433,23 @@ static void mvpp2_gmac_config(struct mvpp2_port *port, unsigned int mode,
 		writel(ctrl4, port->base + MVPP22_GMAC_CTRL_4_REG);
 }
 
-static int mvpp2__mac_prepare(struct phylink_config *config, unsigned int mode,
-			      phy_interface_t interface)
+static struct phylink_pcs *mvpp2_select_pcs(struct phylink_config *config,
+					    phy_interface_t interface)
+{
+	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
+
+	/* Select the appropriate PCS operations depending on the
+	 * configured interface mode. We will only switch to a mode
+	 * that the validate() checks have already passed.
+	 */
+	if (mvpp2_is_xlg(interface))
+		return &port->pcs_xlg;
+	else
+		return &port->pcs_gmac;
+}
+
+static int mvpp2_mac_prepare(struct phylink_config *config, unsigned int mode,
+			     phy_interface_t interface)
 {
 	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
 
@@ -6475,31 +6495,9 @@ static int mvpp2__mac_prepare(struct phylink_config *config, unsigned int mode,
 		}
 	}
 
-	/* Select the appropriate PCS operations depending on the
-	 * configured interface mode. We will only switch to a mode
-	 * that the validate() checks have already passed.
-	 */
-	if (mvpp2_is_xlg(interface))
-		port->phylink_pcs.ops = &mvpp2_phylink_xlg_pcs_ops;
-	else
-		port->phylink_pcs.ops = &mvpp2_phylink_gmac_pcs_ops;
-
 	return 0;
 }
 
-static int mvpp2_mac_prepare(struct phylink_config *config, unsigned int mode,
-			     phy_interface_t interface)
-{
-	struct mvpp2_port *port = mvpp2_phylink_to_port(config);
-	int ret;
-
-	ret = mvpp2__mac_prepare(config, mode, interface);
-	if (ret == 0)
-		phylink_set_pcs(port->phylink, &port->phylink_pcs);
-
-	return ret;
-}
-
 static void mvpp2_mac_config(struct phylink_config *config, unsigned int mode,
 			     const struct phylink_link_state *state)
 {
@@ -6691,12 +6689,15 @@ static void mvpp2_acpi_start(struct mvpp2_port *port)
 	struct phylink_link_state state = {
 		.interface = port->phy_interface,
 	};
-	mvpp2__mac_prepare(&port->phylink_config, MLO_AN_INBAND,
-			   port->phy_interface);
+	struct phylink_pcs *pcs;
+
+	pcs = mvpp2_select_pcs(&port->phylink_config, port->phy_interface);
+
+	mvpp2_mac_prepare(&port->phylink_config, MLO_AN_INBAND,
+			  port->phy_interface);
 	mvpp2_mac_config(&port->phylink_config, MLO_AN_INBAND, &state);
-	port->phylink_pcs.ops->pcs_config(&port->phylink_pcs, MLO_AN_INBAND,
-					  port->phy_interface,
-					  state.advertising, false);
+	pcs->ops->pcs_config(pcs, MLO_AN_INBAND, port->phy_interface,
+			     state.advertising, false);
 	mvpp2_mac_finish(&port->phylink_config, MLO_AN_INBAND,
 			 port->phy_interface);
 	mvpp2_mac_link_up(&port->phylink_config, NULL,
@@ -6945,6 +6946,8 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 			goto err_free_port_pcpu;
 		}
 		port->phylink = phylink;
+		port->pcs_gmac.ops = &mvpp2_phylink_gmac_pcs_ops;
+		port->pcs_xlg.ops = &mvpp2_phylink_xlg_pcs_ops;
 	} else {
 		dev_warn(&pdev->dev, "Use link irqs for port#%d. FW update required\n", port->id);
 		port->phylink = NULL;
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index ab651f6197cc..89c7df0595be 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -170,8 +170,16 @@ static const char *phylink_an_mode_str(unsigned int mode)
 static int phylink_validate(struct phylink *pl, unsigned long *supported,
 			    struct phylink_link_state *state)
 {
+	struct phylink_pcs *pcs;
+
 	pl->mac_ops->validate(pl->config, supported, state);
 
+	if (pl->mac_ops->mac_select_pcs) {
+		pcs = pl->mac_ops->mac_select_pcs(pl->config, state->interface);
+		if (!pcs)
+			return -EINVAL;
+	}
+
 	return phylink_is_empty_linkmode(supported) ? -EINVAL : 0;
 }
 
@@ -462,6 +470,7 @@ static void phylink_mac_pcs_an_restart(struct phylink *pl)
 static void phylink_major_config(struct phylink *pl, bool restart,
 				  const struct phylink_link_state *state)
 {
+	struct phylink_pcs *pcs;
 	int err;
 
 	phylink_dbg(pl, "major config %s\n", phy_modes(state->interface));
@@ -476,6 +485,14 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 		}
 	}
 
+	if (pl->mac_ops->mac_select_pcs) {
+		pcs = pl->mac_ops->mac_select_pcs(pl->config, state->interface);
+		if (!pcs)
+			phylink_err(pl, "mac_select_pcs unexpectedly failed\n");
+		else
+			phylink_set_pcs(pl, pcs);
+	}
+
 	phylink_mac_config(pl, state);
 
 	if (pl->pcs_ops) {
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index f7b5ed06a815..a70c28079f4f 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -81,6 +81,7 @@ struct phylink_config {
 /**
  * struct phylink_mac_ops - MAC operations structure.
  * @validate: Validate and update the link configuration.
+ * @mac_select_pcs: Select a PCS for the interface mode.
  * @mac_pcs_get_state: Read the current link state from the hardware.
  * @mac_prepare: prepare for a major reconfiguration of the interface.
  * @mac_config: configure the MAC for the selected mode and state.
@@ -95,6 +96,8 @@ struct phylink_mac_ops {
 	void (*validate)(struct phylink_config *config,
 			 unsigned long *supported,
 			 struct phylink_link_state *state);
+	struct phylink_pcs *(*mac_select_pcs)(struct phylink_config *config,
+					      phy_interface_t iface);
 	void (*mac_pcs_get_state)(struct phylink_config *config,
 				  struct phylink_link_state *state);
 	int (*mac_prepare)(struct phylink_config *config, unsigned int mode,

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
