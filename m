Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A81559C24
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 16:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbiFXOni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 10:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233220AbiFXOl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 10:41:56 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5966668011;
        Fri, 24 Jun 2022 07:41:51 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 88091E0009;
        Fri, 24 Jun 2022 14:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656081710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PhOAZz1s7LfrxZ+mUE1n6uqNNSytu8e0MQtGWCado9Q=;
        b=UpeGMP02FbL49yhyYZ6WbkimbwiBVUgy9oTvpjzAi2YModQQVquvHb7honRg3b/QyRoyc1
        v8JaY+I9yBQJMD8HHQ/Tc+NKEPEr+6zYfaf/8uK1zlbs3SFXDT3PbB72SlRu0HhbmIjnxy
        FFvcJbVegRCWv8xKSkyi75vg0iGnk49m0kSnAa4NnPPGCjXOUDkSigdPlTr6/fIGrqlkum
        CMTQolkEDfkfkOxFQ1hL5UvREKPQGVTAbtboWGUFteWmQ1H4dkxTUiIb2uT05ykyhKWteY
        ZM6ciSbWVzsnVtJs0L99FW5q3C4plUn7NSYaLTtEHUJksUpYebY4JvoLQFUbKQ==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v9 09/16] net: dsa: rzn1-a5psw: add FDB support
Date:   Fri, 24 Jun 2022 16:39:54 +0200
Message-Id: <20220624144001.95518-10-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220624144001.95518-1-clement.leger@bootlin.com>
References: <20220624144001.95518-1-clement.leger@bootlin.com>
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
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/rzn1_a5psw.c | 168 +++++++++++++++++++++++++++++++++++
 drivers/net/dsa/rzn1_a5psw.h |  17 ++++
 2 files changed, 185 insertions(+)

diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
index 4c2401fbaf9a..3e910da98ae2 100644
--- a/drivers/net/dsa/rzn1_a5psw.c
+++ b/drivers/net/dsa/rzn1_a5psw.c
@@ -375,6 +375,171 @@ static void a5psw_port_fast_age(struct dsa_switch *ds, int port)
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
+	mutex_lock(&a5psw->lk_lock);
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
+	mutex_unlock(&a5psw->lk_lock);
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
+	u16 entry;
+	u32 reg;
+	int ret;
+
+	ether_addr_copy(lk_data.entry.mac, addr);
+
+	mutex_lock(&a5psw->lk_lock);
+
+	ret = a5psw_lk_execute_lookup(a5psw, &lk_data, &entry);
+	if (ret)
+		goto lk_unlock;
+
+	lk_data.hi = a5psw_reg_readl(a5psw, A5PSW_LK_DATA_HI);
+
+	/* Our hardware does not associate any VID to the FDB entries so this
+	 * means that if two entries were added for the same mac but for
+	 * different VID, then, on the deletion of the first one, we would also
+	 * delete the second one. Since there is unfortunately nothing we can do
+	 * about that, do not return an error...
+	 */
+	if (!lk_data.entry.valid)
+		goto lk_unlock;
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
+	mutex_unlock(&a5psw->lk_lock);
+
+	return ret;
+}
+
+static int a5psw_port_fdb_dump(struct dsa_switch *ds, int port,
+			       dsa_fdb_dump_cb_t *cb, void *data)
+{
+	struct a5psw *a5psw = ds->priv;
+	union lk_data lk_data;
+	int i = 0, ret = 0;
+	u32 reg;
+
+	mutex_lock(&a5psw->lk_lock);
+
+	for (i = 0; i < A5PSW_TABLE_ENTRIES; i++) {
+		reg = A5PSW_LK_ADDR_CTRL_READ | A5PSW_LK_ADDR_CTRL_WAIT | i;
+
+		ret = a5psw_lk_execute_ctrl(a5psw, &reg);
+		if (ret)
+			goto out_unlock;
+
+		lk_data.hi = a5psw_reg_readl(a5psw, A5PSW_LK_DATA_HI);
+		/* If entry is not valid or does not contain the port, skip */
+		if (!lk_data.entry.valid ||
+		    !(lk_data.entry.port_mask & BIT(port)))
+			continue;
+
+		lk_data.lo = a5psw_reg_readl(a5psw, A5PSW_LK_DATA_LO);
+
+		ret = cb(lk_data.entry.mac, 0, lk_data.entry.is_static, data);
+		if (ret)
+			goto out_unlock;
+	}
+
+out_unlock:
+	mutex_unlock(&a5psw->lk_lock);
+
+	return ret;
+}
+
 static u64 a5psw_read_stat(struct a5psw *a5psw, u32 offset, int port)
 {
 	u32 reg_lo, reg_hi;
@@ -591,6 +756,9 @@ static const struct dsa_switch_ops a5psw_switch_ops = {
 	.port_bridge_leave = a5psw_port_bridge_leave,
 	.port_stp_state_set = a5psw_port_stp_state_set,
 	.port_fast_age = a5psw_port_fast_age,
+	.port_fdb_add = a5psw_port_fdb_add,
+	.port_fdb_del = a5psw_port_fdb_del,
+	.port_fdb_dump = a5psw_port_fdb_dump,
 };
 
 static int a5psw_mdio_wait_busy(struct a5psw *a5psw)
diff --git a/drivers/net/dsa/rzn1_a5psw.h b/drivers/net/dsa/rzn1_a5psw.h
index 6b0ce2b15eca..c67abd49c013 100644
--- a/drivers/net/dsa/rzn1_a5psw.h
+++ b/drivers/net/dsa/rzn1_a5psw.h
@@ -211,6 +211,23 @@
 #define A5PSW_CTRL_TIMEOUT		1000
 #define A5PSW_TABLE_ENTRIES		8192
 
+struct fdb_entry {
+	u8 mac[ETH_ALEN];
+	u16 valid:1;
+	u16 is_static:1;
+	u16 prio:3;
+	u16 port_mask:5;
+	u16 reserved:6;
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
2.36.1

