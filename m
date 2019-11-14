Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7B04FC976
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 16:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfKNPEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 10:04:24 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34109 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbfKNPEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 10:04:22 -0500
Received: by mail-wr1-f65.google.com with SMTP id e6so6880562wrw.1
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YtTqrtVR1oY9ijEDqKSRXx6n9cafOvnc0cFdZYtsoGk=;
        b=Q/ulsKlDfCkq4MTnut9kXORZfGTobrDCT2rxlQ7xF3OucrQYkdGtcppeA/Y6jaEetC
         dZxpyC2IfzzVX4FvneaVjM2cxAa7+9QNNzASESgAEyjzZDVawj1iBtdNnyjlZzHAaKCC
         Az6vpTu+r2sjRIQ8aDmAot4xX/NBZ/p9+vTSgr1DO6ZbqpQ/XmVDkhDwagz7IJStCe19
         La5n1RT30u+5/VeyYbzpISV9JTsrv23R/Nzpl++wmC5rUNYhfvT3Eorx8V2Xk8xfCCND
         AZiiIJHyaArTT4olXGAnqvwYiaAvJ7J+cfB3ZVIaOBAyw5A0R75SefgHOPOUdaDFX8TZ
         xT6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YtTqrtVR1oY9ijEDqKSRXx6n9cafOvnc0cFdZYtsoGk=;
        b=dORj9XBsCsuz360kPXkISAHRlScp4VIMHADLnRfSHW301Ssj80WGSEQRoiaF9u0bN7
         R5uMoPhk17mlSBQnBIFpve18IIYmAUUL26ToH2Gg803f8mpNZNc/VItmvGVxtwZuGH+q
         r/UCCc84rVe+c0H7rpXqV3T8N1pOqtFBwpBEhnpH7Am9br4S43uL6YuwLb/8L1NfXc6s
         08BD6r6q+NpplLMPEGmmCWqxcXcUXWgO1cU7V5flQsPOh9I2UhtwtXO4Th0U5wLZtdMi
         8BZGOFm7Ij+DACX04ud1fa4XkwEb1560o9Lva2uLW/nyw3NIVWVkMsxDpImaOZSUN6hv
         I/EA==
X-Gm-Message-State: APjAAAXWkE/zzZGWHSEzppPJb/07gOb9KKh2n6BoUTmioTqwYHvCJvxj
        +DkVD5XjkJCeV/D2TUJPkxU=
X-Google-Smtp-Source: APXvYqwv7lbHIY88JOJhB689j8oIN+z7Y13+JHJrOhJwgXIowhcNWaCzRrO+QTYNTD1q3yK25Sl8fA==
X-Received: by 2002:adf:cf10:: with SMTP id o16mr9080052wrj.334.1573743861091;
        Thu, 14 Nov 2019 07:04:21 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id v128sm7600094wmb.14.2019.11.14.07.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 07:04:20 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 07/11] net: mscc: ocelot: separate the implementation of switch reset
Date:   Thu, 14 Nov 2019 17:03:26 +0200
Message-Id: <20191114150330.25856-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114150330.25856-1-olteanv@gmail.com>
References: <20191114150330.25856-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The Felix switch has a different reset procedure, so a function pointer
needs to be created and added to the ocelot_ops structure.

The reset procedure has been moved into ocelot_init.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v2:
- Added error checking for ocelot->ops->reset(ocelot).
- Moved the call at the beginning of ocelot_init, to not overwrite the
  action of calls to ocelot_mact_init, ocelot_vlan_init and
  ocelot_ace_init.

 drivers/net/ethernet/mscc/ocelot.c       |  8 +++++
 drivers/net/ethernet/mscc/ocelot.h       |  1 +
 drivers/net/ethernet/mscc/ocelot_board.c | 37 +++++++++++++++---------
 3 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 42da193a8240..961f9a7c01e3 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2269,6 +2269,14 @@ int ocelot_init(struct ocelot *ocelot)
 	int i, ret;
 	u32 port;
 
+	if (ocelot->ops->reset) {
+		ret = ocelot->ops->reset(ocelot);
+		if (ret) {
+			dev_err(ocelot->dev, "Switch reset failed\n");
+			return ret;
+		}
+	}
+
 	ocelot->lags = devm_kcalloc(ocelot->dev, ocelot->num_phys_ports,
 				    sizeof(u32), GFP_KERNEL);
 	if (!ocelot->lags)
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

