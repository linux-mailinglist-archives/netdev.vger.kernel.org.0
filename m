Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEAD0F8FD9
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 13:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfKLMow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 07:44:52 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46899 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727226AbfKLMou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 07:44:50 -0500
Received: by mail-wr1-f65.google.com with SMTP id b3so18319962wrs.13
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 04:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j4eHebJRrdj4v49yL/Lh57wNmU9p2Vbn9bVa1XBHkyo=;
        b=XKp4H51a0c58qahm3AuJLDPPzVUAPExWlgkUwJv9hRaenLoTGCeRb8DJvL9n7XFioM
         KtW4f1m86nbsvi8dUFvgN16HmbLgPFrtrKV7rWlZcmojB1alsALb/5aHgFZ0clCrug67
         PywcVaXkB8PiO57lfeZM6z45CD9k1YRoq2uhekNjLWMj19aqo5ju3o3kOMjuOaxZF5Ws
         GOlVMI/dr7pJWqPu54c67FX60rh3ZRask6i3OS7NYv+8VIsliDg//12b+dO4lXVyswtl
         x1ojPkL9Gi+c9550KrfB6KPOvjaD99nIj4sEgkVYvJgXGrFD9NakDMdZfG0sKNjCmcW8
         fThg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=j4eHebJRrdj4v49yL/Lh57wNmU9p2Vbn9bVa1XBHkyo=;
        b=jCNDAapGoULDKzYwdiqOgQDUqzmoNKbQaSaEcDvDJ0kKXBnOXuQgJUBsKqiTYAS61j
         ra/j5Nd56fHiZPTGzoJIqFliH1KW+YL/3M3n7GZU1U0f7RW/nvHX6DuovYLQ37i349uU
         MpnwNm66/8+krNK9W6urkWwnlcq4nWyBiWZ0wbysYPfmDUSCxkLCNSwKG4bXpjfuCvaf
         Lvu/xiC9y72FoUUMGhSwMJ4JFW4MrDAVG54pwqJvohSjqMHsspemSdyi6sDu8T02ByJO
         KpR0ZnFkizKCOGmI8u0MpzTOoHM8VgfLM+uxNXiV+zJDeNATGjCO6fESrJayL3Q/VErC
         W+hQ==
X-Gm-Message-State: APjAAAWy6QemWcWHf9O5G1i8yFcGpi2mYlk9TX+9DM7CZkHhD127NYco
        We6/lOgv4y+LHHNKpH7pc7g=
X-Google-Smtp-Source: APXvYqx3lOh9aX4LAaJOL+Itc68flEJlZjpnQ57eEzx2yBoY7vVpRwYYRNsy0nXFjvm9WPtbreYrNw==
X-Received: by 2002:adf:e8ca:: with SMTP id k10mr23634462wrn.377.1573562688302;
        Tue, 12 Nov 2019 04:44:48 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id g184sm4197688wma.8.2019.11.12.04.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 04:44:47 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 07/12] net: mscc: ocelot: separate the implementation of switch reset
Date:   Tue, 12 Nov 2019 14:44:15 +0200
Message-Id: <20191112124420.6225-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191112124420.6225-1-olteanv@gmail.com>
References: <20191112124420.6225-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The Felix switch has a different reset procedure, so a function pointer
needs to be created and added to the ocelot_ops structure.

The reset procedure has been moved into ocelot_init.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c       |  3 ++
 drivers/net/ethernet/mscc/ocelot.h       |  1 +
 drivers/net/ethernet/mscc/ocelot_board.c | 37 +++++++++++++++---------
 3 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 42da193a8240..0fe928026e61 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2294,6 +2294,9 @@ int ocelot_init(struct ocelot *ocelot)
 	ocelot_vlan_init(ocelot);
 	ocelot_ace_init(ocelot);
 
+	if (ocelot->ops->reset)
+		ocelot->ops->reset(ocelot);
+
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
 		/* Clear all counters (5 groups) */
 		ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port) |
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index bdc9b1d34b81..199ca2d6ea32 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -446,6 +446,7 @@ struct ocelot_stat_layout {
 
 struct ocelot_ops {
 	void (*pcs_init)(struct ocelot *ocelot, int port);
+	int (*reset)(struct ocelot *ocelot);
 };
 
 struct ocelot {
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 32aafd951483..5581b3b0165c 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -277,8 +277,32 @@ static void ocelot_port_pcs_init(struct ocelot *ocelot, int port)
 	ocelot_port_writel(ocelot_port, 0, PCS1G_LB_CFG);
 }
 
+static int ocelot_reset(struct ocelot *ocelot)
+{
+	int retries = 100;
+	u32 val;
+
+	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
+	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
+
+	do {
+		msleep(1);
+		regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT],
+				  &val);
+	} while (val && --retries);
+
+	if (!retries)
+		return -ETIMEDOUT;
+
+	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
+	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
+
+	return 0;
+}
+
 static const struct ocelot_ops ocelot_ops = {
 	.pcs_init		= ocelot_port_pcs_init,
+	.reset			= ocelot_reset,
 };
 
 static int mscc_ocelot_probe(struct platform_device *pdev)
@@ -289,7 +313,6 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	struct ocelot *ocelot;
 	struct regmap *hsio;
 	unsigned int i;
-	u32 val;
 
 	struct {
 		enum ocelot_target id;
@@ -369,18 +392,6 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		ocelot->ptp = 1;
 	}
 
-	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_INIT], 1);
-	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
-
-	do {
-		msleep(1);
-		regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT],
-				  &val);
-	} while (val);
-
-	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
-	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
-
 	ocelot->num_cpu_ports = 1; /* 1 port on the switch, two groups */
 
 	ports = of_get_child_by_name(np, "ethernet-ports");
-- 
2.17.1

