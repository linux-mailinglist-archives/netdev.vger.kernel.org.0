Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E415F8FD6
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 13:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfKLMoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 07:44:46 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38996 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfKLMoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 07:44:44 -0500
Received: by mail-wm1-f67.google.com with SMTP id t26so2792604wmi.4
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 04:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9fHMVJXm+IMo52QzmYiMZQ5YlxrCP0NtgzGoISsSFFU=;
        b=cV6QNw/K2dsMWRf2gdnxXYOxXVitxEcEgKmv8IiVlJ/BfPMmQ5TySRTlTvSRkxLdS6
         DJxb5/vhGCjtwc7fLxk1Q19yIo41nkVh+Ig92QWPPBwve4VaZpOHBLzgxOie+xMYlJRY
         FeESvSs4dA+YXMjTmpXWVbTQA7N4L5ayX54s8tBvXuwe3+mVsvj/KQ+5zJf/ZhJPFkjx
         x3wb9K0mhGGpy+aMGccPF/3n/m1hnD7aYhXdSoAdG56/Uzw+YpoaX1UvODxNBnZO8gFp
         9VcbkdGoaBr+o2IqnEqEgJQgREMgKG6ETLVC/Xoa9idYnQWFGWj+2PZ8dGBoQyWxNxLv
         ibKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9fHMVJXm+IMo52QzmYiMZQ5YlxrCP0NtgzGoISsSFFU=;
        b=cWEXiRzVDvAjIGKNnE4YJzDbswvS0NCl+8fQr8FbcYtWhg6I/y94EYocLRSVVPeJd3
         f3JYx5WFzz8OL4m7w9qcoL+IPCBdaCPXUgvXz6lEsQk4iZoDQK1EHxMu5tcvA6OeLRsM
         J4V8UZM6gxkG6VqM/NIaPcbVILkT7y+Ftk9Uce7rspYcAYN+3PiNCPyZ/GttKUw3qxb8
         MmX6EPvkoAOZl9gnqY5qF3TWGgUibiYoUKrd5axUv2nlb7KilYaJWxPd6ChD1KJpPZxA
         myBqJF5o1iTrC6Zf5ExZJAGR5fQTyUDcyLSni353M/IAE9HC4voz5JxUm5yNHx2wIlW5
         99+A==
X-Gm-Message-State: APjAAAVOPrfTuGBYqgCWOm+Ybupens605o6Z3E2bEbk1VvkGCqP6i9D0
        HOex38yHMkDZF0XjwxMAV2g=
X-Google-Smtp-Source: APXvYqzk0uPceZ93xEGOEdBGfR+XSq5tUT9vzQEESllxZmQtWKGwq47wdq3czmfqD0K5Menn2t9A7g==
X-Received: by 2002:a05:600c:20e:: with SMTP id 14mr3609595wmi.107.1573562682134;
        Tue, 12 Nov 2019 04:44:42 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id g184sm4197688wma.8.2019.11.12.04.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 04:44:41 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 02/12] net: mscc: ocelot: filter out ocelot SoC specific PCS config from common path
Date:   Tue, 12 Nov 2019 14:44:10 +0200
Message-Id: <20191112124420.6225-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191112124420.6225-1-olteanv@gmail.com>
References: <20191112124420.6225-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

The adjust_link routine should be generic enough to be (re)used by
any SoC that integrates a switch core compatible with the Ocelot
core switch driver.  Currently all configurations are generic except
for the PCS settings that are SoC specific.  Move these out to the
Ocelot SoC/board instance.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c       | 19 ++--------------
 drivers/net/ethernet/mscc/ocelot.h       |  8 ++++++-
 drivers/net/ethernet/mscc/ocelot_board.c | 29 +++++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_regs.c  |  4 ++--
 4 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 3e7a2796c37d..2b6792ab0eda 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -455,23 +455,8 @@ static void ocelot_adjust_link(struct ocelot *ocelot, int port,
 	ocelot_port_writel(ocelot_port, DEV_MAC_HDX_CFG_LATE_COL_POS(67),
 			   DEV_MAC_HDX_CFG);
 
-	/* Disable HDX fast control */
-	ocelot_port_writel(ocelot_port, DEV_PORT_MISC_HDX_FAST_DIS,
-			   DEV_PORT_MISC);
-
-	/* SGMII only for now */
-	ocelot_port_writel(ocelot_port, PCS1G_MODE_CFG_SGMII_MODE_ENA,
-			   PCS1G_MODE_CFG);
-	ocelot_port_writel(ocelot_port, PCS1G_SD_CFG_SD_SEL, PCS1G_SD_CFG);
-
-	/* Enable PCS */
-	ocelot_port_writel(ocelot_port, PCS1G_CFG_PCS_ENA, PCS1G_CFG);
-
-	/* No aneg on SGMII */
-	ocelot_port_writel(ocelot_port, 0, PCS1G_ANEG_CFG);
-
-	/* No loopback */
-	ocelot_port_writel(ocelot_port, 0, PCS1G_LB_CFG);
+	if (ocelot->ops->pcs_init)
+		ocelot->ops->pcs_init(ocelot, port);
 
 	/* Set Max Length and maximum tags allowed */
 	ocelot_port_writel(ocelot_port, VLAN_ETH_FRAME_LEN,
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index b5802cea7cc4..7e28434c22c1 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -435,13 +435,19 @@ enum ocelot_tag_prefix {
 };
 
 struct ocelot_port;
+struct ocelot;
 
 struct ocelot_stat_layout {
 	u32 offset;
 	char name[ETH_GSTRING_LEN];
 };
 
+struct ocelot_ops {
+	void (*pcs_init)(struct ocelot *ocelot, int port);
+};
+
 struct ocelot {
+	const struct ocelot_ops *ops;
 	struct device *dev;
 
 	struct regmap *targets[TARGET_MAX];
@@ -553,7 +559,7 @@ struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource *res);
 
 int ocelot_init(struct ocelot *ocelot);
 void ocelot_deinit(struct ocelot *ocelot);
-int ocelot_chip_init(struct ocelot *ocelot);
+int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops);
 int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 		      void __iomem *regs,
 		      struct phy_device *phy);
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index ddb34f17fa52..de2da6d33d43 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -254,6 +254,33 @@ static const struct of_device_id mscc_ocelot_match[] = {
 };
 MODULE_DEVICE_TABLE(of, mscc_ocelot_match);
 
+static void ocelot_port_pcs_init(struct ocelot *ocelot, int port)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+	/* Disable HDX fast control */
+	ocelot_port_writel(ocelot_port, DEV_PORT_MISC_HDX_FAST_DIS,
+			   DEV_PORT_MISC);
+
+	/* SGMII only for now */
+	ocelot_port_writel(ocelot_port, PCS1G_MODE_CFG_SGMII_MODE_ENA,
+			   PCS1G_MODE_CFG);
+	ocelot_port_writel(ocelot_port, PCS1G_SD_CFG_SD_SEL, PCS1G_SD_CFG);
+
+	/* Enable PCS */
+	ocelot_port_writel(ocelot_port, PCS1G_CFG_PCS_ENA, PCS1G_CFG);
+
+	/* No aneg on SGMII */
+	ocelot_port_writel(ocelot_port, 0, PCS1G_ANEG_CFG);
+
+	/* No loopback */
+	ocelot_port_writel(ocelot_port, 0, PCS1G_LB_CFG);
+}
+
+static const struct ocelot_ops ocelot_ops = {
+	.pcs_init		= ocelot_port_pcs_init,
+};
+
 static int mscc_ocelot_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
@@ -315,7 +342,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 
 	ocelot->targets[HSIO] = hsio;
 
-	err = ocelot_chip_init(ocelot);
+	err = ocelot_chip_init(ocelot, &ocelot_ops);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mscc/ocelot_regs.c b/drivers/net/ethernet/mscc/ocelot_regs.c
index e59977d20400..d715a924108b 100644
--- a/drivers/net/ethernet/mscc/ocelot_regs.c
+++ b/drivers/net/ethernet/mscc/ocelot_regs.c
@@ -423,7 +423,7 @@ static void ocelot_pll5_init(struct ocelot *ocelot)
 		     HSIO_PLL5G_CFG2_AMPC_SEL(0x10));
 }
 
-int ocelot_chip_init(struct ocelot *ocelot)
+int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 {
 	int ret;
 
@@ -431,6 +431,7 @@ int ocelot_chip_init(struct ocelot *ocelot)
 	ocelot->stats_layout = ocelot_stats_layout;
 	ocelot->num_stats = ARRAY_SIZE(ocelot_stats_layout);
 	ocelot->shared_queue_sz = 224 * 1024;
+	ocelot->ops = ops;
 
 	ret = ocelot_regfields_init(ocelot, ocelot_regfields);
 	if (ret)
@@ -443,4 +444,3 @@ int ocelot_chip_init(struct ocelot *ocelot)
 
 	return 0;
 }
-EXPORT_SYMBOL(ocelot_chip_init);
-- 
2.17.1

