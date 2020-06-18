Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71811FFDA3
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731556AbgFRWBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729551AbgFRWBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:01:09 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54055C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HAYpVhiJYUDDYnvcQboPBzGHC5c6szhMB3cAD+KKAgc=; b=FC2eJycweFp7+ohuHmWM9CKll
        DXVrC7t7E63eDJia394AIdC8jaZQXfvu6QfTR/9s0ZZY9Py5S5Wzwjq97/7ow52DTBVoZawmUw7qk
        53BXPMMbAwkX2x3jZ+EntrT0CVpbIHowtqgxp49Cq1JseICkHh1fz9ggxp/jy0qNCYXMX1UnKNVHG
        HKAFpIE4mc0M+WXIDbqkwdyYy4GNk7J3SVxmlU5PzFslcde3T454VKfKIcAXvMoILQfdq/WfxGdTY
        weWvWozQ3dDjrNjPy0ERttHsfrORS/JkyG9Vu5VQe6LhSO4uh4CRPEPxsHgsKVNij1ge+om1F0i7T
        MYAnSDQVQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58804)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jm2am-0005cE-J8; Thu, 18 Jun 2020 23:01:04 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jm2aj-00052h-7A; Thu, 18 Jun 2020 23:01:01 +0100
Date:   Thu, 18 Jun 2020 23:01:01 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 4/5] net: phy: add Lynx PCS MDIO module
Message-ID: <20200618220101.GJ1551@shell.armlinux.org.uk>
References: <20200618120837.27089-1-ioana.ciornei@nxp.com>
 <20200618120837.27089-5-ioana.ciornei@nxp.com>
 <20200618140623.GC1551@shell.armlinux.org.uk>
 <VI1PR0402MB387191C53CE915E5AC060669E09B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200618165510.GG1551@shell.armlinux.org.uk>
 <VI1PR0402MB38712F94BAAC32DB1C8AB7F8E09B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB38712F94BAAC32DB1C8AB7F8E09B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 05:34:49PM +0000, Ioana Ciornei wrote:
> I am not sure how this would work with Felix and DSA drivers in general
> since the DSA core is hiding the phylink_pcs_ops from the actual switch
> driver.

Here's an idea to work around DSA (untested):

diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 1f8e0023f4f4..f578a5bb8ad0 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -67,6 +67,7 @@ enum phylink_op_type {
 struct phylink_config {
 	struct device *dev;
 	enum phylink_op_type type;
+	void *pcs_private;
 	bool pcs_poll;
 	bool poll_fixed_state;
 	void (*get_fixed_state)(struct phylink_config *config,
diff --git a/include/net/dsa.h b/include/net/dsa.h
index a50d5007fd39..0fbb3a542b6e 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -742,6 +742,9 @@ int dsa_port_get_phy_strings(struct dsa_port *dp, uint8_t *data);
 int dsa_port_get_ethtool_phy_stats(struct dsa_port *dp, uint64_t *data);
 int dsa_port_get_phy_sset_count(struct dsa_port *dp);
 void dsa_port_phylink_mac_change(struct dsa_switch *ds, int port, bool up);
+void dsa_slave_attach_phylink_pcs(struct dsa_switch *ds, int port,
+				  const struct phylink_pcs_ops *ops,
+				  void *priv);
 
 struct dsa_tag_driver {
 	const struct dsa_device_ops *ops;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 2ae17f95cb63..c80f62d88b63 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1619,6 +1619,17 @@ static int dsa_slave_phy_connect(struct net_device *slave_dev, int addr)
 	return phylink_connect_phy(dp->pl, slave_dev->phydev);
 }
 
+void dsa_slave_attach_phylink_pcs(struct dsa_switch *ds, int port,
+				  const struct phylink_pcs_ops *ops,
+				  void *priv)
+{
+	const struct dsa_port *dp = dsa_to_port(ds, port);
+
+	dp->pl_config.pcs_private = priv;
+	phylink_add_pcs(dp->pl, ops);
+}
+EXPORT_SYMBOL_GPL(dsa_slave_attach_phylink_pcs);
+
 static int dsa_slave_phy_setup(struct net_device *slave_dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(slave_dev);


dsa_slave_attach_phylink_pcs() can be passed anything as it's priv
argument - that could be "dp", or it could be a lynx PCS private
data structure, but that's up to the driver code to decide.

At least this gives a way for us to have some standardised PCS
code that can be bolted into either DSA or a MAC driver by the
higher levels without the PCS code having to know which it's
connected to, and without having to have veneers to bridge into
the PCS code.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
