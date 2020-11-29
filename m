Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D916F2C7B92
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 23:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387441AbgK2WBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 17:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgK2WBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 17:01:10 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B581C0613D2;
        Sun, 29 Nov 2020 14:00:24 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id 64so12853831wra.11;
        Sun, 29 Nov 2020 14:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r1yObcQmDY+rcui/F/ddL0tVwxck2QNldFYHUzPVNPg=;
        b=Agh+1b1kpWlXn82GtB429YNKonao80rkD35sq5FECX0joaWoTcm8PwB0IJRD5CMLHU
         fVnCe8tyLLLRG8A0YtC+b6oouFzVBSfwOFoeJymPiHJ0GDb1YzxRmZbX2ZjxS3eUueeD
         NaJC9m72soNnK8xcD2c/ytejiWGmoISz0nntT+2NAYgwc1J86TsfScmXdgsOD5cvl9cj
         leGKbsr715HpPvs9UVbqV9kr2dWHQKToLPOTGWLEIV6sfz5K6FVFyVkgWF2sdmKSgyCS
         4euwVnBUQ1wn9l0K4x8R3r1LsVjyn26biamELKY3alW18lxLp6za27dug6Jo2Yp3c8P9
         +luw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r1yObcQmDY+rcui/F/ddL0tVwxck2QNldFYHUzPVNPg=;
        b=oZY5wr+8WZrRQVg44zLF7DXuAPtfI1iuQqbx9qDcshUdTXpeQKcdyjtUW/oBOjSK3V
         Gy8jE1XFSRg0VFtqYrkj1H74cowGF68lii54XAvpgoouARQWQhkKyRn1D/7ZQgfgzGlt
         9r8sbIljqN4hEOsZhL8Ib8ShPKWS0NpMmTNutdQaTbsHYmhRQzAeoYM3fVGrosUmeqqW
         TTl1f7tQW5QPvy5mHApDwOejVjq51ujMeGF+WNk7BR2QX/Av96fLSt26nF9c21SIovGS
         CHIRkRza0R5YJEmbLTJYUYRf5A/AzAL+JW8AP3dNjk1Q4R9R/UpM30h00p5nQSzKR3Xm
         WLSA==
X-Gm-Message-State: AOAM531/lzrGKP7N/lpKM1HQjoadorl8Q4wdi+ItDFdhO7SaqhuMBKdp
        FbwFprE5h/8Xnpsx81vHs2E=
X-Google-Smtp-Source: ABdhPJx1yz+2AVnxHq02yqnus3m5+/ueIjFeQKydwgj6mpUoPjmn2fd+ouFHsO1BruNo6G5S3mo12g==
X-Received: by 2002:adf:e84e:: with SMTP id d14mr23526282wrn.190.1606687222828;
        Sun, 29 Nov 2020 14:00:22 -0800 (PST)
Received: from adgra-XPS-15-9570.home (lfbn-idf1-1-1007-144.w86-238.abo.wanadoo.fr. [86.238.83.144])
        by smtp.gmail.com with ESMTPSA id b4sm4938080wrr.30.2020.11.29.14.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 14:00:22 -0800 (PST)
From:   Adrien Grassein <adrien.grassein@gmail.com>
Cc:     fugang.duan@nxp.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrien Grassein <adrien.grassein@gmail.com>
Subject: [PATCH v2 2/3] net: fsl: fec: add mdc/mdio bitbang option
Date:   Sun, 29 Nov 2020 22:59:59 +0100
Message-Id: <20201129220000.16550-2-adrien.grassein@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201129220000.16550-1-adrien.grassein@gmail.com>
References: <20201128225425.19300-1-adrien.grassein@gmail.com>
 <20201129220000.16550-1-adrien.grassein@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the ability for the fec to use the
mdc/mdio bitbang protocol to communicate with its phy.

It adds two new optional parameters in the
devicetree definition for the two needed GPIO (mdc and mdio).

It uses the mdio-bitbang generic implementation.

Signed-off-by: Adrien Grassein <adrien.grassein@gmail.com>
---
 drivers/net/ethernet/freescale/fec.h      |   5 ++
 drivers/net/ethernet/freescale/fec_main.c | 101 +++++++++++++++++++---
 2 files changed, 95 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index c527f4ee1d3a..84bf9be4c6f5 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -15,6 +15,7 @@
 /****************************************************************************/
 
 #include <linux/clocksource.h>
+#include <linux/mdio-bitbang.h>
 #include <linux/net_tstamp.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/timecounter.h>
@@ -590,6 +591,10 @@ struct fec_enet_private {
 	int pps_enable;
 	unsigned int next_counter;
 
+	struct mdiobb_ctrl fec_main_bb_ctrl;
+	struct gpio_desc *gd_mdc;
+	struct gpio_desc *gd_mdio;
+
 	u64 ethtool_stats[];
 };
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 04f24c66cf36..4f22c8e3fe7e 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2050,6 +2050,48 @@ static int fec_enet_mii_probe(struct net_device *ndev)
 	return 0;
 }
 
+static void fec_main_bb_ctrl_set_mdc(struct mdiobb_ctrl *ctrl, int level)
+{
+	struct fec_enet_private *fep = container_of(ctrl,
+							struct fec_enet_private, fec_main_bb_ctrl);
+	if (level)
+		gpiod_direction_input(fep->gd_mdc);
+	else
+		gpiod_direction_output(fep->gd_mdc, 0);
+}
+
+static void fec_main_bb_ctrl_set_mdio_dir(struct mdiobb_ctrl *ctrl, int output)
+{
+	struct fec_enet_private *fep = container_of(ctrl,
+							struct fec_enet_private, fec_main_bb_ctrl);
+	if (output)
+		gpiod_direction_output(fep->gd_mdio, 0);
+	else
+		gpiod_direction_input(fep->gd_mdio);
+}
+
+static void fec_main_bb_ctrl_set_mdio_data(struct mdiobb_ctrl *ctrl, int value)
+{
+	struct fec_enet_private *fep = container_of(ctrl,
+							struct fec_enet_private, fec_main_bb_ctrl);
+	gpiod_direction_output(fep->gd_mdio, value);
+}
+
+static int fec_main_bb_ctrl_get_mdio_data(struct mdiobb_ctrl *ctrl)
+{
+	struct fec_enet_private *fep = container_of(ctrl,
+							struct fec_enet_private, fec_main_bb_ctrl);
+	return gpiod_get_value(fep->gd_mdio);
+}
+
+static const struct mdiobb_ops fec_main_bb_ops = {
+	.owner = THIS_MODULE,
+	.set_mdc = fec_main_bb_ctrl_set_mdc,
+	.set_mdio_dir = fec_main_bb_ctrl_set_mdio_dir,
+	.set_mdio_data = fec_main_bb_ctrl_set_mdio_data,
+	.get_mdio_data = fec_main_bb_ctrl_get_mdio_data,
+};
+
 static int fec_enet_mii_init(struct platform_device *pdev)
 {
 	static struct mii_bus *fec0_mii_bus;
@@ -2150,18 +2192,27 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	/* Clear any pending transaction complete indication */
 	writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
 
-	fep->mii_bus = mdiobus_alloc();
-	if (fep->mii_bus == NULL) {
-		err = -ENOMEM;
-		goto err_out;
-	}
+	if (fep->gd_mdc && fep->gd_mdio) {
+		fep->fec_main_bb_ctrl.ops = &fec_main_bb_ops;
+		fep->mii_bus = alloc_mdio_bitbang(&fep->fec_main_bb_ctrl);
+		if (!fep->mii_bus) {
+			err = -ENOMEM;
+			goto err_out;
+		}
+	} else {
+		fep->mii_bus = mdiobus_alloc();
+		if (!fep->mii_bus) {
+			err = -ENOMEM;
+			goto err_out;
+		}
+		fep->mii_bus->read = fec_enet_mdio_read;
+		fep->mii_bus->write = fec_enet_mdio_write;
 
-	fep->mii_bus->name = "fec_enet_mii_bus";
-	fep->mii_bus->read = fec_enet_mdio_read;
-	fep->mii_bus->write = fec_enet_mdio_write;
+		fep->mii_bus->priv = fep;
+	}
 	snprintf(fep->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
 		pdev->name, fep->dev_id + 1);
-	fep->mii_bus->priv = fep;
+	fep->mii_bus->name = "fec_enet_mii_bus";
 	fep->mii_bus->parent = &pdev->dev;
 
 	err = of_mdiobus_register(fep->mii_bus, node);
@@ -2178,7 +2229,10 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	return 0;
 
 err_out_free_mdiobus:
-	mdiobus_free(fep->mii_bus);
+	if (fep->gd_mdc && fep->gd_mdio)
+		free_mdio_bitbang(fep->mii_bus);
+	else
+		mdiobus_free(fep->mii_bus);
 err_out:
 	return err;
 }
@@ -2187,7 +2241,10 @@ static void fec_enet_mii_remove(struct fec_enet_private *fep)
 {
 	if (--mii_cnt == 0) {
 		mdiobus_unregister(fep->mii_bus);
-		mdiobus_free(fep->mii_bus);
+		if (fep->gd_mdc && fep->gd_mdio)
+			free_mdio_bitbang(fep->mii_bus);
+		else
+			mdiobus_free(fep->mii_bus);
 	}
 }
 
@@ -3525,6 +3582,8 @@ fec_probe(struct platform_device *pdev)
 	char irq_name[8];
 	int irq_cnt;
 	struct fec_devinfo *dev_info;
+	struct gpio_desc *gd;
+
 
 	fec_enet_get_queue_num(pdev, &num_tx_qs, &num_rx_qs);
 
@@ -3575,6 +3634,26 @@ fec_probe(struct platform_device *pdev)
 	    !of_property_read_bool(np, "fsl,err006687-workaround-present"))
 		fep->quirks |= FEC_QUIRK_ERR006687;
 
+	gd = devm_gpiod_get_optional(&pdev->dev, "mdc", GPIOD_IN);
+	if (IS_ERR(gd)) {
+		if (PTR_ERR(gd) != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "Failed to get mdc gpio: %ld\n",
+				PTR_ERR(gd));
+		ret = PTR_ERR(gd);
+		goto failed_ioremap;
+	}
+	fep->gd_mdc = gd;
+
+	gd = devm_gpiod_get_optional(&pdev->dev, "mdio", GPIOD_IN);
+	if (IS_ERR(gd)) {
+		if (PTR_ERR(gd) != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "Failed to get mdio gpio: %ld\n",
+				PTR_ERR(gd));
+		ret = PTR_ERR(gd);
+		goto failed_ioremap;
+	}
+	fep->gd_mdio = gd;
+
 	if (of_get_property(np, "fsl,magic-packet", NULL))
 		fep->wol_flag |= FEC_WOL_HAS_MAGIC_PACKET;
 
-- 
2.20.1

