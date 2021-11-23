Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EB9459A4E
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 03:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbhKWDCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 22:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbhKWDCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 22:02:38 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652C0C061714;
        Mon, 22 Nov 2021 18:59:30 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id o20so41161674eds.10;
        Mon, 22 Nov 2021 18:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ytr3FTitHHj8bkMq5tPr2hD3IL2vPrBrWE/WVUgNZXI=;
        b=B4+PvL0+1ch+wDJce5rq0nQ7m9sjsULztjapoSH78Wm1iD9R+r0CHi5FoWlkdFe/J+
         6P9mrg8bhfL0WSxavuW4rLYrJIsWWgYHmYV9s1hjKBw1lHPa2LqirDNcUgjaU0mSUpkz
         oPCbozF2jvQ1UO3/uI1wne/aea+6ZRLyx3BW+bRqetknJSXi12o9Hzxwk7QDLQPrXjMK
         UeN2UAh04jjDs1yu7ZKjjS2UFSP7sdr8tq+uQC9+TE0IAK44Kit/f3lN09VHanFNfT5L
         J4PlJa3+J5eJ1Je+z/NACO7dc/LSkfHYBVl+0EXw8fxaXU+67W3WEbgR0lXYif43H+ZM
         B0pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ytr3FTitHHj8bkMq5tPr2hD3IL2vPrBrWE/WVUgNZXI=;
        b=58m3KT1h2yJ9RzUqzcAwWUPhQpyxD2HaPFPIYGTqFHBfcSPAczIhh0VBJhyunl/Op1
         qSRuMWyUvOFTJ1tKrO0p8jcmq3TvEJvgvu4tLxOdDT0Rr5m7X/LjX/ixM2cY0J9NtN4B
         1TnNeEJKugF8IIFsQ29L3h69vhQe3FboNpaDwnMpb274hENzAXOaT8Lnb9o59XxO39JY
         J21G7Liqx6S2n7OTPump4RxTGqM0U1K0RGqIWaUblTo7x4SU1OxK0UGQu8JVopwNKZ9z
         m172vd+ho3eHrQbLMygASCMIFrI1y+PsfJOIRmF4ArrDNrRbH6aRCHc7wJoNUs1X/Ue1
         TxEA==
X-Gm-Message-State: AOAM531BzejcGWYCJlI2AMz6fbUagmAOmF/9fhQg0uMXaDZruUsRR0KZ
        UBcwFdaytJ6FPVwYFIb72A0=
X-Google-Smtp-Source: ABdhPJzCsZi7LC605FjNdClPXt3KzBEylPh7hfQNP86rmkwL7rZ53O6eTyXQJTF9iNX1QPK4fdWw2A==
X-Received: by 2002:a17:907:9802:: with SMTP id ji2mr3157129ejc.418.1637636368851;
        Mon, 22 Nov 2021 18:59:28 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id dy4sm4870718edb.92.2021.11.22.18.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 18:59:28 -0800 (PST)
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
Subject: [net-next PATCH 1/2] net: dsa: qca8k: add support for mirror mode
Date:   Tue, 23 Nov 2021 03:59:10 +0100
Message-Id: <20211123025911.20987-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211123025911.20987-1-ansuelsmth@gmail.com>
References: <20211123025911.20987-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch supports mirror mode. Only one port can set as mirror port and
every other port can set to both ingress and egress mode. The mirror
port is disabled and reverted to normal operation once every port is
removed from sending packet to it.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 95 +++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  4 ++
 2 files changed, 99 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 67742fbd8040..bd9d756f4001 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2022,6 +2022,99 @@ qca8k_port_mdb_del(struct dsa_switch *ds, int port,
 	return qca8k_fdb_search_and_del(priv, BIT(port), addr, vid);
 }
 
+static int
+qca8k_port_mirror_add(struct dsa_switch *ds, int port,
+		      struct dsa_mall_mirror_tc_entry *mirror,
+		      bool ingress)
+{
+	struct qca8k_priv *priv = ds->priv;
+	int monitor_port, ret;
+	u32 reg, val;
+
+	/* Check for existent entry */
+	if ((ingress ? priv->mirror_rx : priv->mirror_tx) & BIT(port))
+		return -EEXIST;
+
+	ret = regmap_read(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL0, &val);
+	if (ret)
+		return ret;
+
+	/* QCA83xx can have only one port set to mirror mode.
+	 * Check that the correct port is requested and return error otherwise.
+	 * When no mirror port is set, the values is set to 0xF
+	 */
+	monitor_port = FIELD_GET(QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, val);
+	if (monitor_port != 0xF && monitor_port != mirror->to_local_port)
+		return -EEXIST;
+
+	/* Set the monitor port */
+	val = FIELD_PREP(QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM,
+			 mirror->to_local_port);
+	ret = regmap_update_bits(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL0,
+				 QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, val);
+	if (ret)
+		return ret;
+
+	if (ingress) {
+		reg = QCA8K_PORT_LOOKUP_CTRL(port);
+		val = QCA8K_PORT_LOOKUP_ING_MIRROR_EN;
+	} else {
+		reg = QCA8K_REG_PORT_HOL_CTRL1(port);
+		val = QCA8K_PORT_HOL_CTRL1_EG_MIRROR_EN;
+	}
+
+	ret = regmap_update_bits(priv->regmap, reg, val, val);
+	if (ret)
+		return ret;
+
+	/* Track mirror port for tx and rx to decide when the
+	 * mirror port has to be disabled.
+	 */
+	if (ingress)
+		priv->mirror_rx |= BIT(port);
+	else
+		priv->mirror_tx |= BIT(port);
+
+	return 0;
+}
+
+static void
+qca8k_port_mirror_del(struct dsa_switch *ds, int port,
+		      struct dsa_mall_mirror_tc_entry *mirror)
+{
+	struct qca8k_priv *priv = ds->priv;
+	u32 reg, val;
+	int ret;
+
+	if (mirror->ingress) {
+		reg = QCA8K_PORT_LOOKUP_CTRL(port);
+		val = QCA8K_PORT_LOOKUP_ING_MIRROR_EN;
+	} else {
+		reg = QCA8K_REG_PORT_HOL_CTRL1(port);
+		val = QCA8K_PORT_HOL_CTRL1_EG_MIRROR_EN;
+	}
+
+	ret = regmap_clear_bits(priv->regmap, reg, val);
+	if (ret)
+		goto err;
+
+	if (mirror->ingress)
+		priv->mirror_rx &= ~BIT(port);
+	else
+		priv->mirror_tx &= ~BIT(port);
+
+	/* No port set to send packet to mirror port. Disable mirror port */
+	if (!priv->mirror_rx && !priv->mirror_tx) {
+		val = FIELD_PREP(QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, 0xF);
+		ret = regmap_update_bits(priv->regmap, QCA8K_REG_GLOBAL_FW_CTRL0,
+					 QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM, val);
+		if (ret)
+			goto err;
+	}
+err:
+	dev_err(priv->dev, "Failed to del mirror port from %d", port);
+}
+
 static int
 qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
 			  struct netlink_ext_ack *extack)
@@ -2132,6 +2225,8 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.port_fdb_dump		= qca8k_port_fdb_dump,
 	.port_mdb_add		= qca8k_port_mdb_add,
 	.port_mdb_del		= qca8k_port_mdb_del,
+	.port_mirror_add	= qca8k_port_mirror_add,
+	.port_mirror_del	= qca8k_port_mirror_del,
 	.port_vlan_filtering	= qca8k_port_vlan_filtering,
 	.port_vlan_add		= qca8k_port_vlan_add,
 	.port_vlan_del		= qca8k_port_vlan_del,
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 40ec8012622f..7c87a968c010 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -180,6 +180,7 @@
 #define   QCA8K_ATU_AGE_TIME(x)				FIELD_PREP(QCA8K_ATU_AGE_TIME_MASK, (x))
 #define QCA8K_REG_GLOBAL_FW_CTRL0			0x620
 #define   QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN		BIT(10)
+#define   QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM		GENMASK(7, 4)
 #define QCA8K_REG_GLOBAL_FW_CTRL1			0x624
 #define   QCA8K_GLOBAL_FW_CTRL1_IGMP_DP_MASK		GENMASK(30, 24)
 #define   QCA8K_GLOBAL_FW_CTRL1_BC_DP_MASK		GENMASK(22, 16)
@@ -201,6 +202,7 @@
 #define   QCA8K_PORT_LOOKUP_STATE_LEARNING		QCA8K_PORT_LOOKUP_STATE(0x3)
 #define   QCA8K_PORT_LOOKUP_STATE_FORWARD		QCA8K_PORT_LOOKUP_STATE(0x4)
 #define   QCA8K_PORT_LOOKUP_LEARN			BIT(20)
+#define   QCA8K_PORT_LOOKUP_ING_MIRROR_EN		BIT(25)
 
 #define QCA8K_REG_GLOBAL_FC_THRESH			0x800
 #define   QCA8K_GLOBAL_FC_GOL_XON_THRES_MASK		GENMASK(24, 16)
@@ -305,6 +307,8 @@ struct qca8k_ports_config {
 struct qca8k_priv {
 	u8 switch_id;
 	u8 switch_revision;
+	u8 mirror_rx;
+	u8 mirror_tx;
 	bool legacy_phy_port_mapping;
 	struct qca8k_ports_config ports_config;
 	struct regmap *regmap;
-- 
2.32.0

