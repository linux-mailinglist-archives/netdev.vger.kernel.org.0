Return-Path: <netdev+bounces-3277-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F041570656F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:39:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC2F6280C8F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 889B0156C7;
	Wed, 17 May 2023 10:38:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4A4171B3
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 10:38:20 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DBB3AB0
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 03:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=WyZ0uE7JZfuxi7PVChqP3Z/tccP+j42m05GwvraIMCc=; b=0JKmqHNamJih2kEXg+y/qthMlC
	LAZu/E2jktNPPa7vnEDUWWpKpNEX+449pgLxFipNMhsQEqmvZJSjO50JGuf0io8/3iHA2BSops7QK
	xd04Xx7F4tdZWFMn1GylHrs9lz5oKobUGNjVmBCxDYzrcMzypxogYKrRdOWv/5JTrMC+N/smvQMpk
	yCXDJpYN7+UCbPIMsKeak+bdUogCBO1zVv8tKT5RU4dGmbcUUG0QnqYdNTWVOlBCC+DqIxePWcV57
	Fs+/MeCoONXpNnI1DXoVp5OHkjV2VLqFwWeqtdsVcAlHjz11+7xaOjA1s7L/qDEbItnKw7fKiQxIB
	yCWFYGDg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:35138 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pzEXt-0007ZC-Fk; Wed, 17 May 2023 11:38:13 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pzEXs-005jUo-SO; Wed, 17 May 2023 11:38:12 +0100
In-Reply-To: <ZGSuTY8GqjM+sqta@shell.armlinux.org.uk>
References: <ZGSuTY8GqjM+sqta@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH net-next 6/7] net: sfp: add support for setting signalling
 rate
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pzEXs-005jUo-SO@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 17 May 2023 11:38:12 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add support to the SFP layer to allow phylink to set the signalling
rate for a SFP module. The rate given will be in units of kilo-baud
(1000 baud).

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 24 ++++++++++++++++++++++++
 drivers/net/phy/sfp-bus.c | 20 ++++++++++++++++++++
 drivers/net/phy/sfp.c     |  5 +++++
 drivers/net/phy/sfp.h     |  1 +
 include/linux/sfp.h       |  6 ++++++
 5 files changed, 56 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index cf53096047e6..7db67ff2812c 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -156,6 +156,23 @@ static const char *phylink_an_mode_str(unsigned int mode)
 	return mode < ARRAY_SIZE(modestr) ? modestr[mode] : "unknown";
 }
 
+static unsigned int phylink_interface_signal_rate(phy_interface_t interface)
+{
+	switch (interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX: /* 1.25Mbd */
+		return 1250;
+	case PHY_INTERFACE_MODE_2500BASEX: /* 3.125Mbd */
+		return 3125;
+	case PHY_INTERFACE_MODE_5GBASER: /* 5.15625Mbd */
+		return 5156;
+	case PHY_INTERFACE_MODE_10GBASER: /* 10.3125Mbd */
+		return 10313;
+	default:
+		return 0;
+	}
+}
+
 /**
  * phylink_interface_max_speed() - get the maximum speed of a phy interface
  * @interface: phy interface mode defined by &typedef phy_interface_t
@@ -1025,6 +1042,7 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 {
 	struct phylink_pcs *pcs = NULL;
 	bool pcs_changed = false;
+	unsigned int rate_kbd;
 	int err;
 
 	phylink_dbg(pl, "major config %s\n", phy_modes(state->interface));
@@ -1084,6 +1102,12 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 				    ERR_PTR(err));
 	}
 
+	if (pl->sfp_bus) {
+		rate_kbd = phylink_interface_signal_rate(state->interface);
+		if (rate_kbd)
+			sfp_upstream_set_signal_rate(pl->sfp_bus, rate_kbd);
+	}
+
 	phylink_pcs_poll_start(pl);
 }
 
diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 9372e5a4cadc..e8dd47bffe43 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -575,6 +575,26 @@ static void sfp_upstream_clear(struct sfp_bus *bus)
 	bus->upstream = NULL;
 }
 
+/**
+ * sfp_upstream_set_signal_rate() - set data signalling rate
+ * @bus: a pointer to the &struct sfp_bus structure for the sfp module
+ * @rate_kbd: signalling rate in units of 1000 baud
+ *
+ * Configure the rate select settings on the SFP module for the signalling
+ * rate (not the same as the data rate).
+ *
+ * Locks that may be held:
+ *  Phylink's state_mutex
+ *  rtnl lock
+ *  SFP's sm_mutex
+ */
+void sfp_upstream_set_signal_rate(struct sfp_bus *bus, unsigned int rate_kbd)
+{
+	if (bus->registered)
+		bus->socket_ops->set_signal_rate(bus->sfp, rate_kbd);
+}
+EXPORT_SYMBOL_GPL(sfp_upstream_set_signal_rate);
+
 /**
  * sfp_bus_find_fwnode() - parse and locate the SFP bus from fwnode
  * @fwnode: firmware node for the parent device (MAC or PHY)
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index bf7dac9977e1..34bf724c00c7 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2527,6 +2527,10 @@ static void sfp_stop(struct sfp *sfp)
 	sfp_sm_event(sfp, SFP_E_DEV_DOWN);
 }
 
+static void sfp_set_signal_rate(struct sfp *sfp, unsigned int rate_kbd)
+{
+}
+
 static int sfp_module_info(struct sfp *sfp, struct ethtool_modinfo *modinfo)
 {
 	/* locking... and check module is present */
@@ -2611,6 +2615,7 @@ static const struct sfp_socket_ops sfp_module_ops = {
 	.detach = sfp_detach,
 	.start = sfp_start,
 	.stop = sfp_stop,
+	.set_signal_rate = sfp_set_signal_rate,
 	.module_info = sfp_module_info,
 	.module_eeprom = sfp_module_eeprom,
 	.module_eeprom_by_page = sfp_module_eeprom_by_page,
diff --git a/drivers/net/phy/sfp.h b/drivers/net/phy/sfp.h
index 6cf1643214d3..c7cb50d10099 100644
--- a/drivers/net/phy/sfp.h
+++ b/drivers/net/phy/sfp.h
@@ -19,6 +19,7 @@ struct sfp_socket_ops {
 	void (*detach)(struct sfp *sfp);
 	void (*start)(struct sfp *sfp);
 	void (*stop)(struct sfp *sfp);
+	void (*set_signal_rate)(struct sfp *sfp, unsigned int rate_kbd);
 	int (*module_info)(struct sfp *sfp, struct ethtool_modinfo *modinfo);
 	int (*module_eeprom)(struct sfp *sfp, struct ethtool_eeprom *ee,
 			     u8 *data);
diff --git a/include/linux/sfp.h b/include/linux/sfp.h
index ef06a195b3c2..2f66e03e9dbd 100644
--- a/include/linux/sfp.h
+++ b/include/linux/sfp.h
@@ -556,6 +556,7 @@ int sfp_get_module_eeprom_by_page(struct sfp_bus *bus,
 				  struct netlink_ext_ack *extack);
 void sfp_upstream_start(struct sfp_bus *bus);
 void sfp_upstream_stop(struct sfp_bus *bus);
+void sfp_upstream_set_signal_rate(struct sfp_bus *bus, unsigned int rate_kbd);
 void sfp_bus_put(struct sfp_bus *bus);
 struct sfp_bus *sfp_bus_find_fwnode(const struct fwnode_handle *fwnode);
 int sfp_bus_add_upstream(struct sfp_bus *bus, void *upstream,
@@ -615,6 +616,11 @@ static inline void sfp_upstream_stop(struct sfp_bus *bus)
 {
 }
 
+static inline void sfp_upstream_set_signal_rate(struct sfp_bus *bus,
+						unsigned int rate_kbd)
+{
+}
+
 static inline void sfp_bus_put(struct sfp_bus *bus)
 {
 }
-- 
2.30.2


