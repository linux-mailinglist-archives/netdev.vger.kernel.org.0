Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E391E54F34E
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 10:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381186AbiFQIoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 04:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381080AbiFQIoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 04:44:01 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F57F69486;
        Fri, 17 Jun 2022 01:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655455440; x=1686991440;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h54adaho3w9htH6H0fFi2D+isVZqw6iE7Ocsw+W+eO0=;
  b=Z5F4hGDby5gus9cYeF0nxaznHPcIGDPytnOYOOyjOogPk/p2fiOAD90i
   mKb5Ab7fBYu6cvIE0C8sJfMWReZJa7QTsavqk37gcdK6R1vlQaZGUgW5E
   ggTL/l9XTwzJotImTavbeBwhc/EHap8Nx7DSr5mbyQUhoCKuvtd3gL/lV
   FMuyyyqDFebrS1GvYnwiMJtQ3+0ZHVKnl0NXitL0fx0JCCcQjpaIgv6/b
   XcaXY/f3ydISGgteq5Neh4wlWEpH/XNsFud45fPwQAhzi3ohjIAWw5J5R
   /8R96vmIZXnsd6h4BaRd7snIToU7LWEILpgLjkBwbHxoH74rhKgcpTfn0
   g==;
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="100484853"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jun 2022 01:43:59 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 17 Jun 2022 01:43:59 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 17 Jun 2022 01:43:54 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King" <linux@armlinux.org.uk>
Subject: [Patch net-next 03/11] net: dsa: microchip: move tag_protocol to ksz_common
Date:   Fri, 17 Jun 2022 14:12:47 +0530
Message-ID: <20220617084255.19376-4-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220617084255.19376-1-arun.ramadoss@microchip.com>
References: <20220617084255.19376-1-arun.ramadoss@microchip.com>
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

This patch move the dsa hook get_tag_protocol to ksz_common file. And
the tag_protocol is returned based on the dev->chip_id.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 13 +------------
 drivers/net/dsa/microchip/ksz9477.c    | 14 +-------------
 drivers/net/dsa/microchip/ksz_common.c | 24 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h |  2 ++
 4 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 3cc51ee5fb6c..041956e3c7b1 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -898,17 +898,6 @@ static void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 	}
 }
 
-static enum dsa_tag_protocol ksz8_get_tag_protocol(struct dsa_switch *ds,
-						   int port,
-						   enum dsa_tag_protocol mp)
-{
-	struct ksz_device *dev = ds->priv;
-
-	/* ksz88x3 uses the same tag schema as KSZ9893 */
-	return ksz_is_ksz88x3(dev) ?
-		DSA_TAG_PROTO_KSZ9893 : DSA_TAG_PROTO_KSZ8795;
-}
-
 static u32 ksz8_sw_get_phy_flags(struct dsa_switch *ds, int port)
 {
 	/* Silicon Errata Sheet (DS80000830A):
@@ -1394,7 +1383,7 @@ static void ksz8_get_caps(struct dsa_switch *ds, int port,
 }
 
 static const struct dsa_switch_ops ksz8_switch_ops = {
-	.get_tag_protocol	= ksz8_get_tag_protocol,
+	.get_tag_protocol	= ksz_get_tag_protocol,
 	.get_phy_flags		= ksz8_sw_get_phy_flags,
 	.setup			= ksz8_setup,
 	.phy_read		= ksz_phy_read16,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 7d3c8f6908b6..ab3fbb8e15a1 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -276,18 +276,6 @@ static void ksz9477_port_init_cnt(struct ksz_device *dev, int port)
 	mutex_unlock(&mib->cnt_mutex);
 }
 
-static enum dsa_tag_protocol ksz9477_get_tag_protocol(struct dsa_switch *ds,
-						      int port,
-						      enum dsa_tag_protocol mp)
-{
-	enum dsa_tag_protocol proto = DSA_TAG_PROTO_KSZ9477;
-	struct ksz_device *dev = ds->priv;
-
-	if (dev->features & IS_9893)
-		proto = DSA_TAG_PROTO_KSZ9893;
-	return proto;
-}
-
 static int ksz9477_phy_read16(struct dsa_switch *ds, int addr, int reg)
 {
 	struct ksz_device *dev = ds->priv;
@@ -1326,7 +1314,7 @@ static int ksz9477_setup(struct dsa_switch *ds)
 }
 
 static const struct dsa_switch_ops ksz9477_switch_ops = {
-	.get_tag_protocol	= ksz9477_get_tag_protocol,
+	.get_tag_protocol	= ksz_get_tag_protocol,
 	.setup			= ksz9477_setup,
 	.phy_read		= ksz9477_phy_read16,
 	.phy_write		= ksz9477_phy_write16,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index bb710e5daff6..25272647199c 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -930,6 +930,30 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL_GPL(ksz_port_stp_state_set);
 
+enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
+					   int port, enum dsa_tag_protocol mp)
+{
+	struct ksz_device *dev = ds->priv;
+	enum dsa_tag_protocol proto = DSA_TAG_PROTO_NONE;
+
+	if (dev->chip_id == KSZ8795_CHIP_ID ||
+	    dev->chip_id == KSZ8794_CHIP_ID ||
+	    dev->chip_id == KSZ8765_CHIP_ID)
+		proto = DSA_TAG_PROTO_KSZ8795;
+
+	if (dev->chip_id == KSZ8830_CHIP_ID ||
+	    dev->chip_id == KSZ9893_CHIP_ID)
+		proto = DSA_TAG_PROTO_KSZ9893;
+
+	if (dev->chip_id == KSZ9477_CHIP_ID ||
+	    dev->chip_id == KSZ9897_CHIP_ID ||
+	    dev->chip_id == KSZ9567_CHIP_ID)
+		proto = DSA_TAG_PROTO_KSZ9477;
+
+	return proto;
+}
+EXPORT_SYMBOL_GPL(ksz_get_tag_protocol);
+
 static int ksz_switch_detect(struct ksz_device *dev)
 {
 	u8 id1, id2;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index e6bc5fb2b130..21db6f79035f 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -231,6 +231,8 @@ int ksz_port_mdb_del(struct dsa_switch *ds, int port,
 int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy);
 void ksz_get_strings(struct dsa_switch *ds, int port,
 		     u32 stringset, uint8_t *buf);
+enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
+					   int port, enum dsa_tag_protocol mp);
 
 /* Common register access functions */
 
-- 
2.36.1

