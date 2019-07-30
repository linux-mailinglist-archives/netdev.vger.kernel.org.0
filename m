Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC6E57B186
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 20:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbfG3SSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 14:18:00 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:46633 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387725AbfG3SQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 14:16:42 -0400
Received: by mail-pg1-f175.google.com with SMTP id k189so11433119pgk.13
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 11:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qiaWzUmjDxFS2qg+F4VVbnxnyjzbgQ24HqRGoQdLv9o=;
        b=MCkUWPxn1qxVa8rsCleQylvPn0qLkPyq9nb+MZBpcZporCsh4dc+O+Ta3nWtATPO6Y
         XxkgbFLRfdF3rliQWEPQCbLo9lUYgx1HDV4VFBVy5PTTgabKwOb29AwjMw/U49MRdIpk
         EdSpK2ahCPRTRpiWN5Dn05KDqQZymSTtY0jIE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qiaWzUmjDxFS2qg+F4VVbnxnyjzbgQ24HqRGoQdLv9o=;
        b=cUPJ7G3Pj6THQheKfjodhrXdm96dDFUbiTThzSfWBqJgbck3SHV8k5/g/LED6Weomi
         FT+ndIuaEcu+v4XNBjdaWLR6Or5gdVbK08yFpAHM44Qh0lCbssw+hRNxTFZmxf0pXz02
         hYgC8cV8ZGc/lwiellmcJ3mF8Q3OvSc4HcG1efBVMTzoICjOGSR9BZBgjnJzd/eelmjP
         3fAWMvMVuEdnhCvJCXKYCH13HGEEOGfGgkUVJmbVRK9GIhRv4QuIPPUhjQjnscJag/aq
         PDp4ngNoqjn5aNtNhYabHWHkj0KTG9hZkeRfKnNPOuvr793Bw75ONykMoUI3RpYBMxbb
         EIjA==
X-Gm-Message-State: APjAAAU7opqGYkoB4EK2YwZvHWjQCiLL+PvQh/G++eR8sHWCwAZrZs60
        JdFPxvoChOaxGje89a4hpoqorQ==
X-Google-Smtp-Source: APXvYqwINq1kRM4Y8byv8QLtmDeaflMPosn5rG0dayPUflqyL7sCX+EcEFJzkF0mi1dJA3HduoZoow==
X-Received: by 2002:a17:90a:ac11:: with SMTP id o17mr119699176pjq.134.1564510601537;
        Tue, 30 Jul 2019 11:16:41 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:1:fa53:7765:582b:82b9])
        by smtp.gmail.com with ESMTPSA id g1sm106744083pgg.27.2019.07.30.11.16.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 11:16:40 -0700 (PDT)
From:   Stephen Boyd <swboyd@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v6 51/57] net: Remove dev_err() usage after platform_get_irq()
Date:   Tue, 30 Jul 2019 11:15:51 -0700
Message-Id: <20190730181557.90391-52-swboyd@chromium.org>
X-Mailer: git-send-email 2.22.0.709.g102302147b-goog
In-Reply-To: <20190730181557.90391-1-swboyd@chromium.org>
References: <20190730181557.90391-1-swboyd@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't need dev_err() messages when platform_get_irq() fails now that
platform_get_irq() prints an error message itself when something goes
wrong. Let's remove these prints with a simple semantic patch.

// <smpl>
@@
expression ret;
struct platform_device *E;
@@

ret =
(
platform_get_irq(E, ...)
|
platform_get_irq_byname(E, ...)
);

if ( \( ret < 0 \| ret <= 0 \) )
{
(
-if (ret != -EPROBE_DEFER)
-{ ...
-dev_err(...);
-... }
|
...
-dev_err(...);
)
...
}
// </smpl>

While we're here, remove braces on if statements that only have one
statement (manually).

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Felix Fietkau <nbd@nbd.name>
Cc: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: netdev@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

Please apply directly to subsystem trees

 drivers/net/can/janz-ican3.c                       |  1 -
 drivers/net/can/rcar/rcar_can.c                    |  1 -
 drivers/net/can/rcar/rcar_canfd.c                  |  2 --
 drivers/net/can/sun4i_can.c                        |  1 -
 drivers/net/ethernet/amd/au1000_eth.c              |  1 -
 drivers/net/ethernet/amd/xgbe/xgbe-platform.c      | 14 +++-----------
 drivers/net/ethernet/apm/xgene-v2/main.c           |  4 +---
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c   |  4 +---
 drivers/net/ethernet/aurora/nb8800.c               |  4 +---
 drivers/net/ethernet/broadcom/bgmac-platform.c     |  4 +---
 drivers/net/ethernet/cortina/gemini.c              |  4 +---
 drivers/net/ethernet/davicom/dm9000.c              |  2 --
 drivers/net/ethernet/hisilicon/hisi_femac.c        |  1 -
 drivers/net/ethernet/lantiq_xrx200.c               | 10 ++--------
 drivers/net/ethernet/nuvoton/w90p910_ether.c       |  2 --
 drivers/net/ethernet/qualcomm/emac/emac.c          |  5 +----
 drivers/net/ethernet/socionext/sni_ave.c           |  4 +---
 .../ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c    |  7 +------
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  7 +------
 drivers/net/wireless/mediatek/mt76/mt7603/soc.c    |  4 +---
 20 files changed, 15 insertions(+), 67 deletions(-)

diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index 19d4f52a8f90..a761092e6ac9 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -1936,7 +1936,6 @@ static int ican3_probe(struct platform_device *pdev)
 	/* find our IRQ number */
 	mod->irq = platform_get_irq(pdev, 0);
 	if (mod->irq < 0) {
-		dev_err(dev, "IRQ line not found\n");
 		ret = -ENODEV;
 		goto out_free_ndev;
 	}
diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
index 13e66297b65f..cf218949a8fb 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -759,7 +759,6 @@ static int rcar_can_probe(struct platform_device *pdev)
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
-		dev_err(&pdev->dev, "No IRQ resource\n");
 		err = irq;
 		goto fail;
 	}
diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index 05410008aa6b..51eecc7cdcdd 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -1651,14 +1651,12 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 
 	ch_irq = platform_get_irq(pdev, 0);
 	if (ch_irq < 0) {
-		dev_err(&pdev->dev, "no Channel IRQ resource\n");
 		err = ch_irq;
 		goto fail_dev;
 	}
 
 	g_irq = platform_get_irq(pdev, 1);
 	if (g_irq < 0) {
-		dev_err(&pdev->dev, "no Global IRQ resource\n");
 		err = g_irq;
 		goto fail_dev;
 	}
diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index 093fc9a529f0..f4cd88196404 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -787,7 +787,6 @@ static int sun4ican_probe(struct platform_device *pdev)
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
-		dev_err(&pdev->dev, "could not get a valid irq\n");
 		err = -ENODEV;
 		goto exit;
 	}
diff --git a/drivers/net/ethernet/amd/au1000_eth.c b/drivers/net/ethernet/amd/au1000_eth.c
index 650d1bae5f56..1793950f0582 100644
--- a/drivers/net/ethernet/amd/au1000_eth.c
+++ b/drivers/net/ethernet/amd/au1000_eth.c
@@ -1100,7 +1100,6 @@ static int au1000_probe(struct platform_device *pdev)
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
-		dev_err(&pdev->dev, "failed to retrieve IRQ\n");
 		err = -ENODEV;
 		goto out;
 	}
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-platform.c b/drivers/net/ethernet/amd/xgbe/xgbe-platform.c
index d0f3dfb88202..dce9e59e8881 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-platform.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-platform.c
@@ -467,10 +467,8 @@ static int xgbe_platform_probe(struct platform_device *pdev)
 
 	/* Get the device interrupt */
 	ret = platform_get_irq(pdev, 0);
-	if (ret < 0) {
-		dev_err(dev, "platform_get_irq 0 failed\n");
+	if (ret < 0)
 		goto err_io;
-	}
 	pdata->dev_irq = ret;
 
 	/* Get the per channel DMA interrupts */
@@ -479,12 +477,8 @@ static int xgbe_platform_probe(struct platform_device *pdev)
 
 		for (i = 0; (i < max) && (dma_irqnum < dma_irqend); i++) {
 			ret = platform_get_irq(pdata->platdev, dma_irqnum++);
-			if (ret < 0) {
-				netdev_err(pdata->netdev,
-					   "platform_get_irq %u failed\n",
-					   dma_irqnum - 1);
+			if (ret < 0)
 				goto err_io;
-			}
 
 			pdata->channel_irq[i] = ret;
 		}
@@ -496,10 +490,8 @@ static int xgbe_platform_probe(struct platform_device *pdev)
 
 	/* Get the auto-negotiation interrupt */
 	ret = platform_get_irq(phy_pdev, phy_irqnum++);
-	if (ret < 0) {
-		dev_err(dev, "platform_get_irq phy 0 failed\n");
+	if (ret < 0)
 		goto err_io;
-	}
 	pdata->an_irq = ret;
 
 	/* Configure the netdev resource */
diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ethernet/apm/xgene-v2/main.c
index 79048cc46703..02b4f3af02b5 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.c
+++ b/drivers/net/ethernet/apm/xgene-v2/main.c
@@ -54,10 +54,8 @@ static int xge_get_resources(struct xge_pdata *pdata)
 	}
 
 	ret = platform_get_irq(pdev, 0);
-	if (ret < 0) {
-		dev_err(dev, "Unable to get irq\n");
+	if (ret < 0)
 		return ret;
-	}
 	pdata->resources.irq = ret;
 
 	return 0;
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 10b1c053e70a..a63baca97f53 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -1636,9 +1636,7 @@ static int xgene_enet_get_irqs(struct xgene_enet_pdata *pdata)
 				pdata->cq_cnt = max_irqs / 2;
 				break;
 			}
-			dev_err(dev, "Unable to get ENET IRQ\n");
-			ret = ret ? : -ENXIO;
-			return ret;
+			return ret ? : -ENXIO;
 		}
 		pdata->irqs[i] = ret;
 	}
diff --git a/drivers/net/ethernet/aurora/nb8800.c b/drivers/net/ethernet/aurora/nb8800.c
index 3b3370a94a9c..37752d9514e7 100644
--- a/drivers/net/ethernet/aurora/nb8800.c
+++ b/drivers/net/ethernet/aurora/nb8800.c
@@ -1351,10 +1351,8 @@ static int nb8800_probe(struct platform_device *pdev)
 		ops = match->data;
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0) {
-		dev_err(&pdev->dev, "No IRQ\n");
+	if (irq <= 0)
 		return -EINVAL;
-	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	base = devm_ioremap_resource(&pdev->dev, res);
diff --git a/drivers/net/ethernet/broadcom/bgmac-platform.c b/drivers/net/ethernet/broadcom/bgmac-platform.c
index 6dc0dd91ad11..c46c1b1416f7 100644
--- a/drivers/net/ethernet/broadcom/bgmac-platform.c
+++ b/drivers/net/ethernet/broadcom/bgmac-platform.c
@@ -199,10 +199,8 @@ static int bgmac_probe(struct platform_device *pdev)
 		dev_warn(&pdev->dev, "MAC address not present in device tree\n");
 
 	bgmac->irq = platform_get_irq(pdev, 0);
-	if (bgmac->irq < 0) {
-		dev_err(&pdev->dev, "Unable to obtain IRQ\n");
+	if (bgmac->irq < 0)
 		return bgmac->irq;
-	}
 
 	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "amac_base");
 	if (!regs) {
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 9003eb6716cd..5a8d7b44faf9 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2423,10 +2423,8 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 
 	/* Interrupt */
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0) {
-		dev_err(dev, "no IRQ\n");
+	if (irq <= 0)
 		return irq ? irq : -ENODEV;
-	}
 	port->irq = irq;
 
 	/* Clock the port */
diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 386bdc1378d1..cce90b5925d9 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1500,8 +1500,6 @@ dm9000_probe(struct platform_device *pdev)
 
 	ndev->irq = platform_get_irq(pdev, 0);
 	if (ndev->irq < 0) {
-		dev_err(db->dev, "interrupt resource unavailable: %d\n",
-			ndev->irq);
 		ret = ndev->irq;
 		goto out;
 	}
diff --git a/drivers/net/ethernet/hisilicon/hisi_femac.c b/drivers/net/ethernet/hisilicon/hisi_femac.c
index 689f18e3100f..90ab7ade44c4 100644
--- a/drivers/net/ethernet/hisilicon/hisi_femac.c
+++ b/drivers/net/ethernet/hisilicon/hisi_femac.c
@@ -877,7 +877,6 @@ static int hisi_femac_drv_probe(struct platform_device *pdev)
 
 	ndev->irq = platform_get_irq(pdev, 0);
 	if (ndev->irq <= 0) {
-		dev_err(dev, "No irq resource\n");
 		ret = -ENODEV;
 		goto out_disconnect_phy;
 	}
diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index cda641ef89af..900affbdcc0e 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -458,17 +458,11 @@ static int xrx200_probe(struct platform_device *pdev)
 	}
 
 	priv->chan_rx.dma.irq = platform_get_irq_byname(pdev, "rx");
-	if (priv->chan_rx.dma.irq < 0) {
-		dev_err(dev, "failed to get RX IRQ, %i\n",
-			priv->chan_rx.dma.irq);
+	if (priv->chan_rx.dma.irq < 0)
 		return -ENOENT;
-	}
 	priv->chan_tx.dma.irq = platform_get_irq_byname(pdev, "tx");
-	if (priv->chan_tx.dma.irq < 0) {
-		dev_err(dev, "failed to get TX IRQ, %i\n",
-			priv->chan_tx.dma.irq);
+	if (priv->chan_tx.dma.irq < 0)
 		return -ENOENT;
-	}
 
 	/* get the clock */
 	priv->clk = devm_clk_get(dev, NULL);
diff --git a/drivers/net/ethernet/nuvoton/w90p910_ether.c b/drivers/net/ethernet/nuvoton/w90p910_ether.c
index 3d73970b3a2e..219b0b863c89 100644
--- a/drivers/net/ethernet/nuvoton/w90p910_ether.c
+++ b/drivers/net/ethernet/nuvoton/w90p910_ether.c
@@ -993,14 +993,12 @@ static int w90p910_ether_probe(struct platform_device *pdev)
 
 	ether->txirq = platform_get_irq(pdev, 0);
 	if (ether->txirq < 0) {
-		dev_err(&pdev->dev, "failed to get ether tx irq\n");
 		error = -ENXIO;
 		goto failed_free_io;
 	}
 
 	ether->rxirq = platform_get_irq(pdev, 1);
 	if (ether->rxirq < 0) {
-		dev_err(&pdev->dev, "failed to get ether rx irq\n");
 		error = -ENXIO;
 		goto failed_free_io;
 	}
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index 59c2349b59df..bfe10464c81f 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -556,11 +556,8 @@ static int emac_probe_resources(struct platform_device *pdev,
 
 	/* Core 0 interrupt */
 	ret = platform_get_irq(pdev, 0);
-	if (ret < 0) {
-		dev_err(&pdev->dev,
-			"error: missing core0 irq resource (error=%i)\n", ret);
+	if (ret < 0)
 		return ret;
-	}
 	adpt->irq.irq = ret;
 
 	/* base register address */
diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index 51a7b48db4bc..87ab0b5da91e 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1573,10 +1573,8 @@ static int ave_probe(struct platform_device *pdev)
 	}
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		dev_err(dev, "IRQ not found\n");
+	if (irq < 0)
 		return irq;
-	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	base = devm_ioremap_resource(dev, res);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
index 3a14cdd01f5f..cac32f7eb6f3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
@@ -428,13 +428,8 @@ static int dwc_eth_dwmac_probe(struct platform_device *pdev)
 	 * resource initialization is done in the glue logic.
 	 */
 	stmmac_res.irq = platform_get_irq(pdev, 0);
-	if (stmmac_res.irq < 0) {
-		if (stmmac_res.irq != -EPROBE_DEFER)
-			dev_err(&pdev->dev,
-				"IRQ configuration information not found\n");
-
+	if (stmmac_res.irq < 0)
 		return stmmac_res.irq;
-	}
 	stmmac_res.wol_irq = stmmac_res.irq;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 73fc2524372e..1ca3d8009b55 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -602,13 +602,8 @@ int stmmac_get_platform_resources(struct platform_device *pdev,
 	 * probe if needed before we went too far with resource allocation.
 	 */
 	stmmac_res->irq = platform_get_irq_byname(pdev, "macirq");
-	if (stmmac_res->irq < 0) {
-		if (stmmac_res->irq != -EPROBE_DEFER) {
-			dev_err(&pdev->dev,
-				"MAC IRQ configuration information not found\n");
-		}
+	if (stmmac_res->irq < 0)
 		return stmmac_res->irq;
-	}
 
 	/* On some platforms e.g. SPEAr the wake up irq differs from the mac irq
 	 * The external wake up irq can be passed through the platform code
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/soc.c b/drivers/net/wireless/mediatek/mt76/mt7603/soc.c
index b920be1f5718..c6c1ce69bcbc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/soc.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/soc.c
@@ -17,10 +17,8 @@ mt76_wmac_probe(struct platform_device *pdev)
 	int ret;
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		dev_err(&pdev->dev, "Failed to get device IRQ\n");
+	if (irq < 0)
 		return irq;
-	}
 
 	mem_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(mem_base)) {
-- 
Sent by a computer through tubes

