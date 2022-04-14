Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9B5500D30
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243278AbiDNM2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243279AbiDNM1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:27:47 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1442ED50;
        Thu, 14 Apr 2022 05:24:56 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 962B340002;
        Thu, 14 Apr 2022 12:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649939095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h9gVl1WIs8Z8UsupszQpWZh1q9U2WdRb4t2hl3wiUik=;
        b=gKjrfFgN+jnimsR+rmxwFBH3T6yZjzEo8ElLzhryGLKSWNDc5As2AaD4XGvLzPtSDcuf8b
        /cjbl50pyr5ZAk+7GF5Y+a2TrPtChcpxXi6WiIPOEK7EkIQuNPHKQ0ffRG0zOtBtTlCgSr
        324RC4kSe3kvQii9KuNLVaZekO21q/Se3m8A+/uRU9xPWV2mQ2qtw8bdLOhQns6DLVGYAX
        jvsr7mUMzuJ6s7aSLwtFgrYNjq0y9IvC0wSTVBCYSATOC7xlwVjA/7Ij/QFb235D0r8UdL
        8S3tHOdJItw1dq6CQTC/LmYDx/KkDE3KeUK4txOJftxGnDWDCp3wnhOdOUFk2A==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 08/12] net: dsa: rzn1-a5psw: add FDB support
Date:   Thu, 14 Apr 2022 14:22:46 +0200
Message-Id: <20220414122250.158113-9-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220414122250.158113-1-clement.leger@bootlin.com>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commits add forwarding database support to the driver. It
implements fdb_add(), fdb_del() and fdb_dump().

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/dsa/rzn1_a5psw.c | 163 +++++++++++++++++++++++++++++++++++
 drivers/net/dsa/rzn1_a5psw.h |  16 ++++
 2 files changed, 179 insertions(+)

diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
index 7ab7d9054427..8c763c2a1a1f 100644
--- a/drivers/net/dsa/rzn1_a5psw.c
+++ b/drivers/net/dsa/rzn1_a5psw.c
@@ -369,6 +369,166 @@ static void a5psw_port_fast_age(struct dsa_switch *ds, int port)
 	a5psw_port_fdb_flush(a5psw, port);
 }
 
+static int a5psw_lk_execute_lookup(struct a5psw *a5psw, union lk_data *lk_data,
+				   u16 *entry)
+{
+	u32 ctrl;
+	int ret;
+
+	a5psw_reg_writel(a5psw, A5PSW_LK_DATA_LO, lk_data->lo);
+	a5psw_reg_writel(a5psw, A5PSW_LK_DATA_HI, lk_data->hi);
+
+	ctrl = A5PSW_LK_ADDR_CTRL_LOOKUP;
+	ret = a5psw_lk_execute_ctrl(a5psw, &ctrl);
+	if (ret)
+		return ret;
+
+	*entry = ctrl & A5PSW_LK_ADDR_CTRL_ADDRESS;
+
+	return 0;
+}
+
+static int a5psw_port_fdb_add(struct dsa_switch *ds, int port,
+			      const unsigned char *addr, u16 vid,
+			      struct dsa_db db)
+{
+	struct a5psw *a5psw = ds->priv;
+	union lk_data lk_data = {0};
+	bool inc_learncount = false;
+	int ret = 0;
+	u16 entry;
+	u32 reg;
+
+	ether_addr_copy(lk_data.entry.mac, addr);
+	lk_data.entry.port_mask = BIT(port);
+
+	spin_lock(&a5psw->lk_lock);
+
+	/* Set the value to be written in the lookup table */
+	ret = a5psw_lk_execute_lookup(a5psw, &lk_data, &entry);
+	if (ret)
+		goto lk_unlock;
+
+	lk_data.hi = a5psw_reg_readl(a5psw, A5PSW_LK_DATA_HI);
+	if (!lk_data.entry.valid) {
+		inc_learncount = true;
+		/* port_mask set to 0x1f when entry is not valid, clear it */
+		lk_data.entry.port_mask = 0;
+		lk_data.entry.prio = 0;
+	}
+
+	lk_data.entry.port_mask |= BIT(port);
+	lk_data.entry.is_static = 1;
+	lk_data.entry.valid = 1;
+
+	a5psw_reg_writel(a5psw, A5PSW_LK_DATA_HI, lk_data.hi);
+
+	reg = A5PSW_LK_ADDR_CTRL_WRITE | entry;
+	ret = a5psw_lk_execute_ctrl(a5psw, &reg);
+	if (ret)
+		goto lk_unlock;
+
+	if (inc_learncount) {
+		reg = A5PSW_LK_LEARNCOUNT_MODE_INC;
+		a5psw_reg_writel(a5psw, A5PSW_LK_LEARNCOUNT, reg);
+	}
+
+lk_unlock:
+	spin_unlock(&a5psw->lk_lock);
+
+	return ret;
+}
+
+static int a5psw_port_fdb_del(struct dsa_switch *ds, int port,
+			      const unsigned char *addr, u16 vid,
+			      struct dsa_db db)
+{
+	struct a5psw *a5psw = ds->priv;
+	union lk_data lk_data = {0};
+	bool clear = false;
+	int ret = 0;
+	u16 entry;
+	u32 reg;
+
+	ether_addr_copy(lk_data.entry.mac, addr);
+
+	spin_lock(&a5psw->lk_lock);
+
+	ret = a5psw_lk_execute_lookup(a5psw, &lk_data, &entry);
+	if (ret) {
+		dev_err(a5psw->dev, "Failed to lookup mac address\n");
+		goto lk_unlock;
+	}
+
+	lk_data.hi = a5psw_reg_readl(a5psw, A5PSW_LK_DATA_HI);
+	if (!lk_data.entry.valid) {
+		dev_err(a5psw->dev, "Tried to remove non-existing entry\n");
+		ret = -ENOENT;
+		goto lk_unlock;
+	}
+
+	lk_data.entry.port_mask &= ~BIT(port);
+	/* If there is no more port in the mask, clear the entry */
+	if (lk_data.entry.port_mask == 0)
+		clear = true;
+
+	a5psw_reg_writel(a5psw, A5PSW_LK_DATA_HI, lk_data.hi);
+
+	reg = entry;
+	if (clear)
+		reg |= A5PSW_LK_ADDR_CTRL_CLEAR;
+	else
+		reg |= A5PSW_LK_ADDR_CTRL_WRITE;
+
+	ret = a5psw_lk_execute_ctrl(a5psw, &reg);
+	if (ret)
+		goto lk_unlock;
+
+	/* Decrement LEARNCOUNT */
+	if (clear) {
+		reg = A5PSW_LK_LEARNCOUNT_MODE_DEC;
+		a5psw_reg_writel(a5psw, A5PSW_LK_LEARNCOUNT, reg);
+	}
+
+lk_unlock:
+	spin_unlock(&a5psw->lk_lock);
+
+	return ret;
+}
+
+static int a5psw_port_fdb_dump(struct dsa_switch *ds, int port,
+			       dsa_fdb_dump_cb_t *cb, void *data)
+{
+	struct a5psw *a5psw = ds->priv;
+	union lk_data lk_data;
+	int i = 0, ret;
+	u32 reg;
+
+	for (i = 0; i < A5PSW_TABLE_ENTRIES; i++) {
+		reg = A5PSW_LK_ADDR_CTRL_READ | A5PSW_LK_ADDR_CTRL_WAIT | i;
+		spin_lock(&a5psw->lk_lock);
+
+		ret = a5psw_lk_execute_ctrl(a5psw, &reg);
+		if (ret)
+			return ret;
+
+		lk_data.hi = a5psw_reg_readl(a5psw, A5PSW_LK_DATA_HI);
+		/* If entry is not valid or does not contain the port, skip */
+		if (!lk_data.entry.valid ||
+		    !(lk_data.entry.port_mask & BIT(port))) {
+			spin_unlock(&a5psw->lk_lock);
+			continue;
+		}
+
+		lk_data.lo = a5psw_reg_readl(a5psw, A5PSW_LK_DATA_LO);
+		spin_unlock(&a5psw->lk_lock);
+
+		cb(lk_data.entry.mac, 0, lk_data.entry.is_static, data);
+	}
+
+	return 0;
+}
+
 static void a5psw_get_strings(struct dsa_switch *ds, int port, u32 stringset,
 			      uint8_t *data)
 {
@@ -500,6 +660,9 @@ const struct dsa_switch_ops a5psw_switch_ops = {
 	.port_bridge_leave = a5psw_port_bridge_leave,
 	.port_stp_state_set = a5psw_port_stp_state_set,
 	.port_fast_age = a5psw_port_fast_age,
+	.port_fdb_add = a5psw_port_fdb_add,
+	.port_fdb_del = a5psw_port_fdb_del,
+	.port_fdb_dump = a5psw_port_fdb_dump,
 
 };
 
diff --git a/drivers/net/dsa/rzn1_a5psw.h b/drivers/net/dsa/rzn1_a5psw.h
index b34ea549e936..37aa89383e70 100644
--- a/drivers/net/dsa/rzn1_a5psw.h
+++ b/drivers/net/dsa/rzn1_a5psw.h
@@ -167,6 +167,22 @@
 #define A5PSW_CTRL_TIMEOUT		1000
 #define A5PSW_TABLE_ENTRIES		8192
 
+struct fdb_entry {
+	u8 mac[ETH_ALEN];
+	u8 valid:1;
+	u8 is_static:1;
+	u8 prio:3;
+	u8 port_mask:5;
+} __packed;
+
+union lk_data {
+	struct {
+		u32 lo;
+		u32 hi;
+	};
+	struct fdb_entry entry;
+};
+
 /**
  * struct a5psw - switch struct
  * @base: Base address of the switch
-- 
2.34.1

