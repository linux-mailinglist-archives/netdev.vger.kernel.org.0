Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D8E526002
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 12:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379424AbiEMKXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 06:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379423AbiEMKXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 06:23:38 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFD9179082;
        Fri, 13 May 2022 03:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652437400; x=1683973400;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1j3mQDFzHkRtao/qz9fQguS4i6C5ShtEta7nphXQdnc=;
  b=R0Ln0GrKzG3V28azowEzuagtCsgsAYEqelXkn2GaITY1EGd3UsBi7gOw
   VZi8AdQiN+Xal9TYxPPL359AvGzZhJVj0khVAnvBL9Vj2v/7B20sWslAk
   dU81uGcJCKNi/AkSLM2Xm5nIMZUFqS30CDK3iKyAa0tHFKpn9rmjGyKZ5
   9LY/YQNW8uACd2gTbZipJy/YYHUO09Ud6KPD5h3ZfG4PQsXcUbO4G0Y4J
   BlST3rkJh5M5MR7GcVbUftpj8HaaZm6kNGOLdIZKq5jUo3Z2UqXK0jkyw
   lZmDslR3DizBkwB68iIh1gpMQx7ZdvtoEu+tH46w6+LJB2WAAN0usceJq
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="158946903"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 May 2022 03:23:18 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 13 May 2022 03:23:18 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 13 May 2022 03:23:13 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: [RFC Patch net-next v2 6/9] net: dsa: microchip: move get_strings to ksz_common
Date:   Fri, 13 May 2022 15:52:16 +0530
Message-ID: <20220513102219.30399-7-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220513102219.30399-1-arun.ramadoss@microchip.com>
References: <20220513102219.30399-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ksz8795 and ksz9477 uses the same algorithm for copying the ethtool
strings. Hence moved to ksz_common to remove the redundant code.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 14 +-------------
 drivers/net/dsa/microchip/ksz9477.c    | 17 +----------------
 drivers/net/dsa/microchip/ksz_common.c | 16 ++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h |  2 ++
 4 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 3490b6072641..251048ffd3d4 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -923,18 +923,6 @@ static u32 ksz8_sw_get_phy_flags(struct dsa_switch *ds, int port)
 	return 0;
 }
 
-static void ksz8_get_strings(struct dsa_switch *ds, int port,
-			     u32 stringset, uint8_t *buf)
-{
-	struct ksz_device *dev = ds->priv;
-	int i;
-
-	for (i = 0; i < dev->info->mib_cnt; i++) {
-		memcpy(buf + i * ETH_GSTRING_LEN,
-		       dev->info->mib_names[i].string, ETH_GSTRING_LEN);
-	}
-}
-
 static void ksz8_cfg_port_member(struct ksz_device *dev, int port, u8 member)
 {
 	u8 data;
@@ -1424,7 +1412,7 @@ static const struct dsa_switch_ops ksz8_switch_ops = {
 	.phylink_get_caps	= ksz8_get_caps,
 	.phylink_mac_link_down	= ksz_mac_link_down,
 	.port_enable		= ksz_enable_port,
-	.get_strings		= ksz8_get_strings,
+	.get_strings		= ksz_get_strings,
 	.get_ethtool_stats	= ksz_get_ethtool_stats,
 	.get_sset_count		= ksz_sset_count,
 	.port_bridge_join	= ksz_port_bridge_join,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index d4729f0dd831..7cffc3388106 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -358,21 +358,6 @@ static int ksz9477_phy_write16(struct dsa_switch *ds, int addr, int reg,
 	return 0;
 }
 
-static void ksz9477_get_strings(struct dsa_switch *ds, int port,
-				u32 stringset, uint8_t *buf)
-{
-	struct ksz_device *dev = ds->priv;
-	int i;
-
-	if (stringset != ETH_SS_STATS)
-		return;
-
-	for (i = 0; i < dev->info->mib_cnt; i++) {
-		memcpy(buf + i * ETH_GSTRING_LEN,
-		       dev->info->mib_names[i].string, ETH_GSTRING_LEN);
-	}
-}
-
 static void ksz9477_cfg_port_member(struct ksz_device *dev, int port,
 				    u8 member)
 {
@@ -1341,7 +1326,7 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.phy_write		= ksz9477_phy_write16,
 	.phylink_mac_link_down	= ksz_mac_link_down,
 	.port_enable		= ksz_enable_port,
-	.get_strings		= ksz9477_get_strings,
+	.get_strings		= ksz_get_strings,
 	.get_ethtool_stats	= ksz_get_ethtool_stats,
 	.get_sset_count		= ksz_sset_count,
 	.port_bridge_join	= ksz_port_bridge_join,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index bca9f3823cdf..18160543090c 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -418,6 +418,22 @@ void ksz_get_stats64(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL_GPL(ksz_get_stats64);
 
+void ksz_get_strings(struct dsa_switch *ds, int port,
+		     u32 stringset, uint8_t *buf)
+{
+	struct ksz_device *dev = ds->priv;
+	int i;
+
+	if (stringset != ETH_SS_STATS)
+		return;
+
+	for (i = 0; i < dev->info->mib_cnt; i++) {
+		memcpy(buf + i * ETH_GSTRING_LEN,
+		       dev->info->mib_names[i].string, ETH_GSTRING_LEN);
+	}
+}
+EXPORT_SYMBOL_GPL(ksz_get_strings);
+
 void ksz_update_port_member(struct ksz_device *dev, int port)
 {
 	struct ksz_port *p = &dev->ports[port];
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 6b968369bf49..0c1dc87c8176 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -209,6 +209,8 @@ int ksz_port_mdb_del(struct dsa_switch *ds, int port,
 		     const struct switchdev_obj_port_mdb *mdb,
 		     struct dsa_db db);
 int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy);
+void ksz_get_strings(struct dsa_switch *ds, int port,
+		     u32 stringset, uint8_t *buf);
 
 /* Common register access functions */
 
-- 
2.33.0

