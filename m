Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952D84C6950
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 12:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbiB1LEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 06:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234784AbiB1LEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 06:04:51 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858BE23BC0;
        Mon, 28 Feb 2022 03:04:12 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id cm8so17040487edb.3;
        Mon, 28 Feb 2022 03:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b0aZE0156bljPu6CR2jZhpTCqmqx7vhyQv/VoU1qoXQ=;
        b=VdeMUeUSENuZ/a/3KEJahYq7AYaF7kiv7LS28vCPAcs3Jypnd1uF7NHeRSj0HjvnUF
         VN5pe5bvVwvz7mv59QUlBOZrblOcuKepcL1n0qVexXM4zEeGF5L9moDUvuLs6ymMludf
         NOpaZtW4E3ufTTIY5Z0IpPhl7O2sNl0QTEosT7UXBDX0R15f8RXHsK7onnWx5opEg9GJ
         2IBTWtpMAykwFVrxsqsNfVrFXuVijHczc+h9Drg3IAZAUlPLixThryHAoT6lt0O8GOoy
         ZPZZOFVCjs7IRmry01F9efls4Twf/9EqeVW58ivMppkkmpxT6Z+tk4Qyu/xqy6PfHBE7
         XksQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b0aZE0156bljPu6CR2jZhpTCqmqx7vhyQv/VoU1qoXQ=;
        b=3a+ZBCWH6kFs+E+HPtjUP72nSbS4zW/kObcr8MS7PpWiEDHv4qQLElIJ4MuMERfQQB
         +xcHVLUiNJCoF77z1sC4fZWWjcwNrk2uA1yRQN4wE6IiCTd0Qf6esZz0K0tLAZiiUivs
         y9ih89qnNKXNfLDkCQ6yOmy/fI/0XIqhbvOfb8nUAnpWOeD12zGGSOpG5r7N/xsNDVDr
         zqzZFWIkPv7Da2zsALRnrAn/pCHeFgyydDWNDz0mDTYbVTZwJRQmY5rBA9ZXrmPiWLmK
         5OPXuGUc6/Id2sYS9zH6/aHpTb19Z+ABVGdVE0LlMkSMaSEgTU2D1yYDdfMK4xjgnqfk
         C1ug==
X-Gm-Message-State: AOAM532LJ+R2CeB2Vw1eQwtLJizneoucn/hTNkm3/JJ/ONoUiHLIIGtO
        s+u2UrlWkopjAqgXCQEWbBE=
X-Google-Smtp-Source: ABdhPJyGEVevkhgXu42nHIKL0pcHCEajMZCcVLVLKSY+t6rlmtKFAEzcRi/ExAF5XGNHvy25f/Yi9Q==
X-Received: by 2002:a05:6402:528f:b0:410:e24f:91fd with SMTP id en15-20020a056402528f00b00410e24f91fdmr19314121edb.99.1646046250836;
        Mon, 28 Feb 2022 03:04:10 -0800 (PST)
Received: from Ansuel-xps.localdomain (host-79-27-250-74.retail.telecomitalia.it. [79.27.250.74])
        by smtp.googlemail.com with ESMTPSA id iy8-20020a170907818800b006d1c553ed1esm4237655ejc.102.2022.02.28.03.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 03:04:10 -0800 (PST)
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
Subject: [net-next PATCH v2] net: dsa: qca8k: pack driver struct and improve cache use
Date:   Mon, 28 Feb 2022 12:04:08 +0100
Message-Id: <20220228110408.4903-1-ansuelsmth@gmail.com>
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
index ee0dbf324268..8d059da5f0ca 100644
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
+	qca8k_setup_pcs(priv, &priv->ports_config.qpcs[QCA8K_CPU_PORT6], 6);
 
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

