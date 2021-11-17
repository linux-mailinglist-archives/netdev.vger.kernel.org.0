Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E401D454EFC
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 22:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240882AbhKQVJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 16:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240717AbhKQVIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 16:08:30 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8B4C061206;
        Wed, 17 Nov 2021 13:05:30 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id x6so5310663edr.5;
        Wed, 17 Nov 2021 13:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yo+lOtp/Uy/wF44C6fwYa7t1J8Hm84Is4/Z4Fgruu1U=;
        b=Po+mzU0Q8Vct6JbeN7eeW3FCL7vDYucrQmODzP2ElVbSKE+tyLV3AwTS4n3PCe+IAn
         DMzBRly/n2e0pexZmBFxYe+rCyG+d19b1F2xj/pgHfZnfrM41EjHGRw4nfn7cYQm82Vn
         p87sNot6roZL1sP+RI1GrIno6hDGfc1qtH5eoLKBLLwNEnHNOMwgl3UqDQkRnVjw2faJ
         eEgWMdlGXPnQ8ETWzYM5MYwm3ycAjp2CYbyynPXmzUbzb1LzHyfQjx95pwKvKetqnR4U
         qLBXiKCcaagazl1sR4VYqWw3n6uDehiILsVu7wU7aMh5rqaM8kqbwaGu3HS9JvxIFI06
         F66w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yo+lOtp/Uy/wF44C6fwYa7t1J8Hm84Is4/Z4Fgruu1U=;
        b=utHdzeHOHv239WGbltgtyY8Q/O9z9SHDGZ6tmT8dtMcXWQLfl3qMXd0tiyhr1Op5bX
         r8K0+oJ5plOcXLq188oUOAkUBxsbg5IGzgM3vbbx9OMz1FdLvJuLXQ8SURg8icXSyW/Y
         KU4bf8XwsqNqlDngCTLHz96s8GmoLJuA8hMsOeFRaZxoDA+H7XJaFWHSQAweGNdJz0jJ
         6o520eTMB6hDnop6dIwHkt0J4vzZYC/oleznsD+HQ+zLvzWyvAD2VObzWFPy3JE2295x
         eRbcYNQEK/TvacHYpReIq5GGafE62AZM/u0BT1zzp7ABQoo35+A0H0IvICH3bmun7Mtw
         kxHg==
X-Gm-Message-State: AOAM530wUQXWGxnhjgFKqiHf8BOFwKWqDqJwe6pmzG2NAN2veWCm9D1v
        ADGHYCDn/bklpq1L3O0e/Y8=
X-Google-Smtp-Source: ABdhPJw0IZek7AwZa+zFIBAf5yA29ISgJe1TEf7BwoNk7KQkq+Q5Ip+13FSfkrDdR7Ni6TyqxGQySA==
X-Received: by 2002:a17:906:18b2:: with SMTP id c18mr26269889ejf.403.1637183129247;
        Wed, 17 Nov 2021 13:05:29 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id di4sm467070ejc.11.2021.11.17.13.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 13:05:29 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH 11/19] net: dsa: qca8k: add support for mirror mode
Date:   Wed, 17 Nov 2021 22:04:43 +0100
Message-Id: <20211117210451.26415-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117210451.26415-1-ansuelsmth@gmail.com>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch support mirror mode. Only one port can set as mirror port and
every other port can set to both ingress and egress mode. The mirror
port is disabled and reverted to normal operation once every port is
removed from sending packet to the mirror mode.
Also modify the fdb logit to send packet to both destination and mirror
port by default to support mirror mode.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 95 +++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  5 +++
 2 files changed, 100 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index d73886b36e6a..a74099131e3d 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1938,6 +1938,99 @@ qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
 	return 0;
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
@@ -2045,6 +2138,8 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.port_fdb_add		= qca8k_port_fdb_add,
 	.port_fdb_del		= qca8k_port_fdb_del,
 	.port_fdb_dump		= qca8k_port_fdb_dump,
+	.port_mirror_add	= qca8k_port_mirror_add,
+	.port_mirror_del	= qca8k_port_mirror_del,
 	.port_vlan_filtering	= qca8k_port_vlan_filtering,
 	.port_vlan_add		= qca8k_port_vlan_add,
 	.port_vlan_del		= qca8k_port_vlan_del,
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index c5d83514ad2e..d25afdab4dea 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -177,6 +177,7 @@
 #define   QCA8K_VTU_FUNC1_FULL				BIT(4)
 #define QCA8K_REG_GLOBAL_FW_CTRL0			0x620
 #define   QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN		BIT(10)
+#define   QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM		GENMASK(7, 4)
 #define QCA8K_REG_GLOBAL_FW_CTRL1			0x624
 #define   QCA8K_GLOBAL_FW_CTRL1_IGMP_DP_MASK		GENMASK(30, 24)
 #define   QCA8K_GLOBAL_FW_CTRL1_BC_DP_MASK		GENMASK(22, 16)
@@ -198,6 +199,7 @@
 #define   QCA8K_PORT_LOOKUP_STATE_LEARNING		QCA8K_PORT_LOOKUP_STATE(0x3)
 #define   QCA8K_PORT_LOOKUP_STATE_FORWARD		QCA8K_PORT_LOOKUP_STATE(0x4)
 #define   QCA8K_PORT_LOOKUP_LEARN			BIT(20)
+#define   QCA8K_PORT_LOOKUP_ING_MIRROR_EN		BIT(25)
 
 #define QCA8K_REG_GLOBAL_FC_THRESH			0x800
 #define   QCA8K_GLOBAL_FC_GOL_XON_THRES_MASK		GENMASK(24, 16)
@@ -262,6 +264,7 @@ enum qca8k_fdb_cmd {
 	QCA8K_FDB_FLUSH	= 1,
 	QCA8K_FDB_LOAD = 2,
 	QCA8K_FDB_PURGE = 3,
+	QCA8K_FDB_FLUSH_PORT = 5,
 	QCA8K_FDB_NEXT = 6,
 	QCA8K_FDB_SEARCH = 7,
 };
@@ -302,6 +305,8 @@ struct qca8k_ports_config {
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

