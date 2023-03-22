Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F15B6C49CC
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 13:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbjCVMAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 08:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjCVMAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 08:00:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73850580C0;
        Wed, 22 Mar 2023 05:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LMKWKeCd1jHrdcZOpqY/W1TGL/nIE2xtHM8njertImI=; b=S3ppIpjbNNM3fsLlzkTbFKVTJ/
        mOxEJfbHzu2NlGTffmHYb+9kLkbKFNeExs6k4NDVy3CcEfezUkiXOr8dPHMB+oLYPcGdRPSJkWLKA
        /CyXN3RpZAXV0mFcdtCU3E61PnP4pEG1ptSXibHBCaGTicZ6Z1J0YIyPGZBNrLmzZtmWZ7bvUpuNN
        gyrDjbaQ6U9H4ALBJbYxi5ZerhmB1ZPcBLxyKx4Ue/bhloZr7AQtvV7YaLtp7Pbgkarp6SlUC024B
        FDIab0iUWtxpOoXY7nCLh9W/c+vTMoyY/58J5WJAGh0/5DMYLIv2eRtmgQnJnVsfV7IpqckYrK1qG
        4Za7AMdQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60894 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pex8W-00035z-1a; Wed, 22 Mar 2023 12:00:12 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pex8V-00Dvnx-B2; Wed, 22 Mar 2023 12:00:11 +0000
In-Reply-To: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH RFC net-next 4/7] net: dsa: add ability for switch driver to
 provide a swnode
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pex8V-00Dvnx-B2@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 22 Mar 2023 12:00:11 +0000
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a method to dsa_switch_ops to allow a switch driver to override
the fwnode used to setup phylink for a port. This will be used for
the Marvell 88e6xxx driver to provide its "maximum interface" and
"maximum speed" mode to keep compatibility with existing behaviour
for CPU and DSA ports via a swnode-backed fwnode.

We need to release the swnode after phylink_create() has completed
no matter what the outcome was.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 include/net/dsa.h |  3 +++
 net/dsa/port.c    | 12 ++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index a15f17a38eca..764f3e74448b 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -854,6 +854,9 @@ struct dsa_switch_ops {
 	 */
 	int	(*port_setup)(struct dsa_switch *ds, int port);
 	void	(*port_teardown)(struct dsa_switch *ds, int port);
+	struct fwnode_handle *(*port_get_fwnode)(struct dsa_switch *ds,
+						 int port,
+						 struct fwnode_handle *h);
 
 	u32	(*get_phy_flags)(struct dsa_switch *ds, int port);
 
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 07f9cb374a5d..c30e3a7d2145 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1693,6 +1693,15 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 		ds->ops->phylink_get_caps(ds, dp->index, &dp->pl_config);
 
 	fwnode = of_fwnode_handle(dp->dn);
+	if (ds->ops->port_get_fwnode) {
+		fwnode = ds->ops->port_get_fwnode(ds, dp->index, fwnode);
+		if (IS_ERR(fwnode)) {
+			dev_err(ds->dev,
+				"Failed to get fwnode for port %d: %pe\n",
+				dp->index, fwnode);
+			return PTR_ERR(fwnode);
+		}
+	}
 
 	mode = fwnode_get_phy_mode(fwnode);
 	if (mode < 0)
@@ -1700,6 +1709,9 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 
 	pl = phylink_create(&dp->pl_config, fwnode, mode,
 			    &dsa_port_phylink_mac_ops);
+
+	fwnode_remove_software_node(fwnode);
+
 	if (IS_ERR(pl)) {
 		pr_err("error creating PHYLINK: %ld\n", PTR_ERR(pl));
 		return PTR_ERR(pl);
-- 
2.30.2

