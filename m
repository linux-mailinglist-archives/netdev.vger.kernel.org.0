Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4F1459151
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240115AbhKVP2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239927AbhKVP1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:27:40 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332F5C061758;
        Mon, 22 Nov 2021 07:24:33 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id v1so45021897edx.2;
        Mon, 22 Nov 2021 07:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cctnma0hR1wnfCHKWYPLfzkpBVI189/lQy6pB8Ey+kg=;
        b=IH/s1CZPrJG/XdoPZMJzIT9qbD2mLes7g4o+x2LQIanOTIE+fd93FdGe+hYLl8eIYE
         2FLwQ7taoV9s7cEFXvyu8znwP5AVpGmxBZDA0kY5gYRHXN0nDtUCXE7Gk+lqlqMHOmx7
         y+45No7rzXmmpdbI5BiEWJ01AeDFxietZq/GE1CrQSqj850RL3E0lrnSiCPwLIG8w83r
         hTKsMtRhUNwFPmhXObR2x9rMMA57dycSHky9IWUXQOdLAiozVx8EQ+zXocw2ZjPFpmZ4
         cDabEitPYknNznyyHZqDymhQouYbc7JYhCfpQAnrqHLNRrGL28RsmPjtkNRi0/c8Prnc
         yhnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cctnma0hR1wnfCHKWYPLfzkpBVI189/lQy6pB8Ey+kg=;
        b=dKGs/tVmCiuJCYxGkjbBpLk8j+bmD5+98kW+CVkUVnVxhqVnMATTyrOnUYjP1Aacgt
         OnQmKnKU1Sdi1L3hmr/0sg4QQVW12zwIO/jrnZk75xDIVKFCXgPA9BUJMAyKxe9Hp6eN
         UKLkRsQ9e32w8AxsCNOBvBGgamaiNjS0BEOx5sK+qaedtQiRoEDJVfjb0IiKkdNQx6EA
         LY4BT37GZ/TBnHMmdYPxwntE68mbo2GSuMIldidQ4ANiyQCfiPbLQ+8+yhZOCf3oJb0Z
         H5/X7K/5XPxEpKCY58eO0IJit0PSot/0qcHEzVxe0fH4OR2g3zVW+Ig1LHmxrD51izRY
         v89w==
X-Gm-Message-State: AOAM531uBtXl3dd6g78lTWnsNW+UNacervW9ME8iekoTsWFnOx71LoGX
        rwZYCjr+e3wpRMO5N/3KRCY=
X-Google-Smtp-Source: ABdhPJzV2zOoXbbC6VRLc5YVo5bEoSSKyihqwSoLwaTYt/lnk5b6Jj2E/APwC05s7ZSvOVHnZ3umaQ==
X-Received: by 2002:a50:8dcb:: with SMTP id s11mr53347100edh.125.1637594664040;
        Mon, 22 Nov 2021 07:24:24 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id sb19sm3995307ejc.120.2021.11.22.07.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 07:24:23 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v3 8/9] net: dsa: qca8k: add set_ageing_time support
Date:   Mon, 22 Nov 2021 16:23:47 +0100
Message-Id: <20211122152348.6634-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211122152348.6634-1-ansuelsmth@gmail.com>
References: <20211122152348.6634-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qca8k support setting ageing time in step of 7s. Add support for it and
set the max value accepted of 7645m.
Documentation talks about support for 10000m but that values doesn't
make sense as the value doesn't match the max value in the reg.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca8k.c | 25 +++++++++++++++++++++++++
 drivers/net/dsa/qca8k.h |  3 +++
 2 files changed, 28 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index d988df913ae0..45e769b9166b 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1257,6 +1257,10 @@ qca8k_setup(struct dsa_switch *ds)
 	/* We don't have interrupts for link changes, so we need to poll */
 	ds->pcs_poll = true;
 
+	/* Set min a max ageing value supported */
+	ds->ageing_time_min = 7000;
+	ds->ageing_time_max = 458745000;
+
 	return 0;
 }
 
@@ -1796,6 +1800,26 @@ qca8k_port_fast_age(struct dsa_switch *ds, int port)
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
+	/* Handle case with 0 as val to NOT disable
+	 * learning
+	 */
+	if (!val)
+		val = 1;
+
+	return regmap_update_bits(priv->regmap, QCA8K_REG_ATU_CTRL, QCA8K_ATU_AGE_TIME_MASK,
+				  QCA8K_ATU_AGE_TIME(val));
+}
+
 static int
 qca8k_port_enable(struct dsa_switch *ds, int port,
 		  struct phy_device *phy)
@@ -1995,6 +2019,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.get_strings		= qca8k_get_strings,
 	.get_ethtool_stats	= qca8k_get_ethtool_stats,
 	.get_sset_count		= qca8k_get_sset_count,
+	.set_ageing_time	= qca8k_set_ageing_time,
 	.get_mac_eee		= qca8k_get_mac_eee,
 	.set_mac_eee		= qca8k_set_mac_eee,
 	.port_enable		= qca8k_port_enable,
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index a533b8cf143b..40ec8012622f 100644
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
 #define QCA8K_REG_GLOBAL_FW_CTRL1			0x624
-- 
2.32.0

