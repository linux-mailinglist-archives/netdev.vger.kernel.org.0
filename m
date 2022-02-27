Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495034C5FEE
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 00:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbiB0Xst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 18:48:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiB0Xss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 18:48:48 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A721EC7D;
        Sun, 27 Feb 2022 15:48:10 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id s1so12782248wrg.10;
        Sun, 27 Feb 2022 15:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J0B6HB9QM62PF8HIp7c/E6jstm+OyW2wTv6DrSjW094=;
        b=HxLcHbiAsX/5XArv+dfKhSqtLELuJX/UKi/F1s0BJpPyxqFXmOZwPlN9MxqIstwMfM
         quvcAxcOjuq24TmlltkOBsskHhinVOuDPT7VUTvAFaetT6krwyYY+/uIpjyVDFFBQGBd
         +BwObpd7AAq/sRXqlV2707U2n9ApTSlPjEPR9kzvW+widkjn4fujz0GDWmRikLRmZDii
         f+0gjjZDLG/QubMek2wh1VJA7S2s7zaVv2K/qs/ETN+e+C0+vlEs3L0c6H/DBw7ox2yb
         +/Jl+O9wNcC7ZdyuP+jkKW8tiBgL0G8OnAvj7qmmBpurq+NiKK2i/GnuL1sUxI7BhnIb
         S+Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J0B6HB9QM62PF8HIp7c/E6jstm+OyW2wTv6DrSjW094=;
        b=crmd4gEyMgavrX/32KSIfkXwFfM8W9awQD7WcExqTysk/lWpnQLK8JAXLswnUbSKXY
         7mreIuoG23JgJ4MOmqYKkB4JpOHrCpt7EepycIyZIVyR4SkM26s3wUto1eaBFQJHwA+R
         dNgtyChsoJucVX/IrCvROVr4PjuJX/FKl78eqncrtKTrzxP+sXnUn77UQCvelx756wzU
         Rdk6k2you4u5weIJTJQO10AMYGVbk7tOBIE+zqQzqw9SxjGlrlKPE8qi3EyIVk087KWV
         209jFfy7ATydX1ojQ0aqIRTvf5OuKAVKSvTCz896cn98r9AU5A8z1eygXiytVN9H3AJi
         RdKg==
X-Gm-Message-State: AOAM531Dy6Ybl2ckBy4aDEeYjN0O343lpTHCJXZAHkRum0Z73WMXcHFf
        zszvfDIYQq8vXEFZpZkEe8si0AP2POQ=
X-Google-Smtp-Source: ABdhPJySZuwWyo63oMcZ4JJN0ZZRfWDUlkm3Yjj9Mb0R0FID3yUFK6O5IkW/xyuWvFVLzaP8zE+Kmg==
X-Received: by 2002:a5d:42cc:0:b0:1ef:7c17:cd59 with SMTP id t12-20020a5d42cc000000b001ef7c17cd59mr7955014wrr.418.1646005689018;
        Sun, 27 Feb 2022 15:48:09 -0800 (PST)
Received: from Ansuel-xps.localdomain (host-79-27-250-74.retail.telecomitalia.it. [79.27.250.74])
        by smtp.googlemail.com with ESMTPSA id x7-20020a5d6507000000b001edb03e8065sm12647661wru.72.2022.02.27.15.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Feb 2022 15:48:08 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH] net: dsa: qca8k: pack driver struct and improve cache use
Date:   Mon, 28 Feb 2022 00:48:04 +0100
Message-Id: <20220227234804.8838-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pack qca8k priv and other struct using pahole and set the first priv
struct entry to mgmt_master and mgmt_eth_data to speedup access.
While at it also rework pcs struct and move it qca8k_ports_config
following other configuration set for the cpu ports.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c |  8 ++++----
 drivers/net/dsa/qca8k.h | 33 ++++++++++++++++-----------------
 2 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index ee0dbf324268..83b11bb71a19 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1685,11 +1685,11 @@ qca8k_phylink_mac_select_pcs(struct dsa_switch *ds, int port,
 	case PHY_INTERFACE_MODE_1000BASEX:
 		switch (port) {
 		case 0:
-			pcs = &priv->pcs_port_0.pcs;
+			pcs = &priv->ports_config.qpcs[QCA8K_CPU_PORT0].pcs;
 			break;
 
 		case 6:
-			pcs = &priv->pcs_port_6.pcs;
+			pcs = &priv->ports_config.qpcs[QCA8K_CPU_PORT6].pcs;
 			break;
 		}
 		break;
@@ -2889,8 +2889,8 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
-	qca8k_setup_pcs(priv, &priv->pcs_port_0, 0);
-	qca8k_setup_pcs(priv, &priv->pcs_port_6, 6);
+	qca8k_setup_pcs(priv, &priv->ports_config.qpcs[QCA8K_CPU_PORT0], 0);
+	qca8k_setup_pcs(priv, &priv->ports_config.qpcs[QCA8K_CPU_PORT0], 6);
 
 	/* Make sure MAC06 is disabled */
 	ret = regmap_clear_bits(priv->regmap, QCA8K_REG_PORT0_PAD_CTRL,
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index f375627174c8..611dc2335dbe 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -341,18 +341,24 @@ enum {
 
 struct qca8k_mgmt_eth_data {
 	struct completion rw_done;
-	struct mutex mutex; /* Enforce one mdio read/write at time */
+	u32 data[4];
 	bool ack;
 	u32 seq;
-	u32 data[4];
+	struct mutex mutex; /* Enforce one mdio read/write at time */
 };
 
 struct qca8k_mib_eth_data {
 	struct completion rw_done;
+	u64 *data; /* pointer to ethtool data */
+	u8 req_port;
 	struct mutex mutex; /* Process one command at time */
 	refcount_t port_parsed; /* Counter to track parsed port */
-	u8 req_port;
-	u64 *data; /* pointer to ethtool data */
+};
+
+struct qca8k_pcs {
+	struct phylink_pcs pcs;
+	struct qca8k_priv *priv;
+	int port;
 };
 
 struct qca8k_ports_config {
@@ -361,6 +367,7 @@ struct qca8k_ports_config {
 	bool sgmii_enable_pll;
 	u8 rgmii_rx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
 	u8 rgmii_tx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
+	struct qca8k_pcs qpcs[QCA8K_NUM_CPU_PORTS];
 };
 
 struct qca8k_mdio_cache {
@@ -376,13 +383,10 @@ struct qca8k_mdio_cache {
 	u16 hi;
 };
 
-struct qca8k_pcs {
-	struct phylink_pcs pcs;
-	struct qca8k_priv *priv;
-	int port;
-};
-
 struct qca8k_priv {
+	struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
+	struct qca8k_mgmt_eth_data mgmt_eth_data;
+	struct qca8k_mdio_cache mdio_cache;
 	u8 switch_id;
 	u8 switch_revision;
 	u8 mirror_rx;
@@ -396,15 +400,10 @@ struct qca8k_priv {
 	struct dsa_switch *ds;
 	struct mutex reg_mutex;
 	struct device *dev;
-	struct dsa_switch_ops ops;
 	struct gpio_desc *reset_gpio;
-	unsigned int port_mtu[QCA8K_NUM_PORTS];
-	struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
-	struct qca8k_mgmt_eth_data mgmt_eth_data;
+	struct dsa_switch_ops ops;
 	struct qca8k_mib_eth_data mib_eth_data;
-	struct qca8k_mdio_cache mdio_cache;
-	struct qca8k_pcs pcs_port_0;
-	struct qca8k_pcs pcs_port_6;
+	unsigned int port_mtu[QCA8K_NUM_PORTS];
 };
 
 struct qca8k_mib_desc {
-- 
2.34.1

