Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CBA454EFE
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 22:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240886AbhKQVJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 16:09:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240728AbhKQVIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 16:08:31 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9ACC061766;
        Wed, 17 Nov 2021 13:05:31 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id g14so16956437edb.8;
        Wed, 17 Nov 2021 13:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=gsCK9T2ovNwicQlA1GjlqOqzDUDeGjBNagUAANlbaoo=;
        b=jWJRqi2ajKfhIFCBsvnHdwJni5PiJTxFP+Z7+e7j/ULo2tg8xaXjANO4KK08DKBgOK
         gIHqcbFqwj974t1/M6hTzcx7AQCnw27/GZm0+u/gQOFdpe8arlwsuQrYwZiZLhLb4DdI
         JZhlc6TIXWVe9N3cAhzGjyxvaHK0NNYvfMSg1YdED74zbZJ00/x+li1J8mvDgqWwXIwv
         dA3xYQAWbQ0TCgdVNIn/Qd7FZFJ0C1fcv+bgNBAEkYypsiFyGEgwiVPAOeySQnPnyioQ
         gZIGtgKEcNaCDL4mmAMXMJvR7IsvVl1lOWUAN8Q+/4CM5lk+/j+HFCLj7vqTRCwesPkD
         Xgtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gsCK9T2ovNwicQlA1GjlqOqzDUDeGjBNagUAANlbaoo=;
        b=QQYed0NeCSMPN5aowLkft6bnH5E+aF/Aho62+q3ouvrNqixYzy+uxXKt1dLMj8faTH
         3GWSvb1ClL4/VLM/VLM1hLsbv0mVZrigLMHwUQ+RGnkwtzHOww5oXkpB0JkimiZf5XUD
         sicrP5p1AKjBUvhF48vztv/ADfyjLrW2gfwTP8WlZCk8IVGgZrf227RP9zDeDMVh0tMy
         BzFRiMbNoYGVxT3gLe6+RLsfq3oNzTVdA0gco80ocaDcQnQlQLWQw2/kX//IceZfYoGl
         ykAHWDCSO50GFUc9M4cIXuCSS32wBmZqxLF1xjA0fyafVHwA3N8Bpog1sAeLgrllibCv
         cYEw==
X-Gm-Message-State: AOAM532vSABf0rMVCOGXypKZT2A51QdIJhw2oj/2FTlJBRD7LYRdUhKI
        HQBonCBCbq6NPb3jU68pM1o=
X-Google-Smtp-Source: ABdhPJxKjvy55eYA0CROezf9hfJ+fuZoU6VA5Ml34SB53aGJskXr29tWFECd0DKjnVFQTsxtMoypxw==
X-Received: by 2002:a17:907:8a24:: with SMTP id sc36mr25175534ejc.530.1637183130075;
        Wed, 17 Nov 2021 13:05:30 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id di4sm467070ejc.11.2021.11.17.13.05.29
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
Subject: [net-next PATCH 12/19] net: dsa: qca8k: add set_ageing_time support
Date:   Wed, 17 Nov 2021 22:04:44 +0100
Message-Id: <20211117210451.26415-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117210451.26415-1-ansuelsmth@gmail.com>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8k support setting ageing time in set of 7s. Add support for it and
return error with value greater than the max value accepted of 7645m.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 18 ++++++++++++++++++
 drivers/net/dsa/qca8k.h |  3 +++
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index a74099131e3d..50f19549b97d 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1833,6 +1833,23 @@ qca8k_port_fast_age(struct dsa_switch *ds, int port)
 	mutex_unlock(&priv->reg_mutex);
 }
 
+static int
+qca8k_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
+{
+	struct qca8k_priv *priv = ds->priv;
+	unsigned int secs = msecs / 1000;
+	u32 val;
+
+	/* AGE_TIME reg is set in 7s step */
+	val = secs / 7;
+
+	if (val > FIELD_MAX(QCA8K_ATU_AGE_TIME_MASK))
+		return -ERANGE;
+
+	return regmap_update_bits(priv->regmap, QCA8K_REG_ATU_CTRL, QCA8K_ATU_AGE_TIME_MASK,
+				  QCA8K_ATU_AGE_TIME(val));
+}
+
 static int
 qca8k_port_enable(struct dsa_switch *ds, int port,
 		  struct phy_device *phy)
@@ -2125,6 +2142,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.get_strings		= qca8k_get_strings,
 	.get_ethtool_stats	= qca8k_get_ethtool_stats,
 	.get_sset_count		= qca8k_get_sset_count,
+	.set_ageing_time	= qca8k_set_ageing_time,
 	.get_mac_eee		= qca8k_get_mac_eee,
 	.set_mac_eee		= qca8k_set_mac_eee,
 	.port_enable		= qca8k_port_enable,
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index d25afdab4dea..e1298179d7cb 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -175,6 +175,9 @@
 #define   QCA8K_VTU_FUNC1_BUSY				BIT(31)
 #define   QCA8K_VTU_FUNC1_VID_MASK			GENMASK(27, 16)
 #define   QCA8K_VTU_FUNC1_FULL				BIT(4)
+#define QCA8K_REG_ATU_CTRL				0x618
+#define   QCA8K_ATU_AGE_TIME_MASK			GENMASK(15, 0)
+#define   QCA8K_ATU_AGE_TIME(x)				FIELD_PREP(QCA8K_ATU_AGE_TIME_MASK, (x))
 #define QCA8K_REG_GLOBAL_FW_CTRL0			0x620
 #define   QCA8K_GLOBAL_FW_CTRL0_CPU_PORT_EN		BIT(10)
 #define   QCA8K_GLOBAL_FW_CTRL0_MIRROR_PORT_NUM		GENMASK(7, 4)
-- 
2.32.0

