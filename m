Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7BBD3CD848
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 17:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242956AbhGSOVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 10:21:32 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.83]:12383 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239395AbhGSOUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 10:20:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1626706850;
    s=strato-dkim-0002; d=gerhold.net;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=pubmbmHlyqpaiVv+WMB17cjKMc+dY8K5IuYGYoXn/CE=;
    b=hIqeiU24ArSSuEFFlyD5sVQuDKtyhYyiED1Ctvq6hfv9LxPAGN1CWm5wpK3kQLwmqE
    uxfr6IQK5a6w5SsMFLvBxh48ZaZSZ+RUPcYuevwQ/EvCaJhsOoVgxCRQDQdpvy6VgrGf
    +CKQq25taYdLIiIxv2a8M+JxmUUdF/dk7U93z0/beiISGqesVcbGKM9Y7aJ1EQEw5et4
    6A+SFCmiX8S08GQPtMPaCYXOY19b6ZP9w+wYr1lDK66RJoy249mdEEvZKCbOFkBnOBAH
    tCf+3iHrbKxE4UrsHXSkJqwDq6A2npHZf9jFkhU/YBL+xdqojKDwk+QM/J2dzCAYIMiV
    ciNg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVORvLd4SsytBXS7IYBkLahKxB4m6O43/v"
X-RZG-CLASS-ID: mo00
Received: from droid..
    by smtp.strato.de (RZmta 47.28.1 DYNA|AUTH)
    with ESMTPSA id g02a44x6JF0k432
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 19 Jul 2021 17:00:46 +0200 (CEST)
From:   Stephan Gerhold <stephan@gerhold.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, phone-devel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Stephan Gerhold <stephan@gerhold.net>
Subject: [RFC PATCH net-next 2/4] dmaengine: qcom: bam_dma: Add remote power collapse mode
Date:   Mon, 19 Jul 2021 16:53:15 +0200
Message-Id: <20210719145317.79692-3-stephan@gerhold.net>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719145317.79692-1-stephan@gerhold.net>
References: <20210719145317.79692-1-stephan@gerhold.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some configurations, the BAM DMA controller is set up by a remote
processor and the local processor can simply start making use of it
without setting up the BAM. This is already supported using the
"qcom,controlled-remotely" property.

However, for some reason another possible configuration is that the
remote processor is responsible for powering up the BAM, but we are
still responsible for initializing it (e.g. resetting it etc).

This configuration is quite challenging to handle properly because
the power control is handled through separate channels
(e.g. device-specific SMSM interrupts / smem-states). Great care
must be taken to ensure the BAM registers are not accessed while
the BAM is power-collapsed since this results in a bus stall.

Attempt to support this configuration with minimal device-specific
code in the bam_dma driver by tracking the number of requested
channels. Consumers of DMA channels are responsible to only request
DMA channels when the BAM was powered on by the remote processor,
and to release them before the BAM is power-collapsed.

When the first channel is requested the BAM is initialized (reset)
and it is also put into reset when the last channel was released.

Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
---
NOTE: This is *not* a compile-time requirement for the BAM-DMUX driver
      so this could also go through the dmaengine tree.

I tried to come up with other solutions for this situation, but this
is the cleanest I came up with so far. The main advantage is that
it keeps the bam_dma driver generic and fairly simple. The main
disadvantage might be that there is some overhead when the DMA channels
are repeatedly requested and released (the BAM-DMUX driver uses
PM runtime to autosuspend after 1 second of inactivity).

Some alternative ideas (but I'm not sure how they would work exactly):

  - Have some dmaengine_*() operation to make the bam_dma driver aware
    that the BAM is power-collapsed (instead of requesting/releasing
    the channels every time).

  - Give the BAM-DMUX power control IRQ to bam_dma so it knows when
    the BAM is power-collapsed or not.

    - Perhaps even give the smem-state to bam_dma so it could request
      powering on the BAM itself. This would be quite strange though,
      since bam_dma already uses runtime PM but differently (only active
      during register writes, not necessarily active during transfers).

    Note however that the power control of BAM-DMUX also involves
    queuing RX buffers so there would be much more coordination
    needed between bam_dma and bam-dmux.

All in all, I think the solution in this patch is still the cleanest
approach so far.
---
 drivers/dma/qcom/bam_dma.c | 88 ++++++++++++++++++++++++--------------
 1 file changed, 56 insertions(+), 32 deletions(-)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index c8a77b428b52..8bf6c50bda73 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -388,6 +388,8 @@ struct bam_device {
 	/* execution environment ID, from DT */
 	u32 ee;
 	bool controlled_remotely;
+	bool remote_power_collapse;
+	u32 active_channels;
 
 	const struct reg_offset_data *layout;
 
@@ -415,6 +417,44 @@ static inline void __iomem *bam_addr(struct bam_device *bdev, u32 pipe,
 		r.ee_mult * bdev->ee;
 }
 
+/**
+ * bam_reset - reset and initialize BAM registers
+ * @bdev: bam device
+ */
+static void bam_reset(struct bam_device *bdev)
+{
+	u32 val;
+
+	/* s/w reset bam */
+	/* after reset all pipes are disabled and idle */
+	val = readl_relaxed(bam_addr(bdev, 0, BAM_CTRL));
+	val |= BAM_SW_RST;
+	writel_relaxed(val, bam_addr(bdev, 0, BAM_CTRL));
+	val &= ~BAM_SW_RST;
+	writel_relaxed(val, bam_addr(bdev, 0, BAM_CTRL));
+
+	/* make sure previous stores are visible before enabling BAM */
+	wmb();
+
+	/* enable bam */
+	val |= BAM_EN;
+	writel_relaxed(val, bam_addr(bdev, 0, BAM_CTRL));
+
+	/* set descriptor threshhold, start with 4 bytes */
+	writel_relaxed(DEFAULT_CNT_THRSHLD,
+			bam_addr(bdev, 0, BAM_DESC_CNT_TRSHLD));
+
+	/* Enable default set of h/w workarounds, ie all except BAM_FULL_PIPE */
+	writel_relaxed(BAM_CNFG_BITS_DEFAULT, bam_addr(bdev, 0, BAM_CNFG_BITS));
+
+	/* enable irqs for errors */
+	writel_relaxed(BAM_ERROR_EN | BAM_HRESP_ERR_EN,
+			bam_addr(bdev, 0, BAM_IRQ_EN));
+
+	/* unmask global bam interrupt */
+	writel_relaxed(BAM_IRQ_MSK, bam_addr(bdev, 0, BAM_IRQ_SRCS_MSK_EE));
+}
+
 /**
  * bam_reset_channel - Reset individual BAM DMA channel
  * @bchan: bam channel
@@ -512,6 +552,9 @@ static int bam_alloc_chan(struct dma_chan *chan)
 		return -ENOMEM;
 	}
 
+	if (bdev->active_channels++ == 0 && bdev->remote_power_collapse)
+		bam_reset(bdev);
+
 	return 0;
 }
 
@@ -565,6 +608,13 @@ static void bam_free_chan(struct dma_chan *chan)
 	/* disable irq */
 	writel_relaxed(0, bam_addr(bdev, bchan->id, BAM_P_IRQ_EN));
 
+	if (--bdev->active_channels == 0 && bdev->remote_power_collapse) {
+		/* s/w reset bam */
+		val = readl_relaxed(bam_addr(bdev, 0, BAM_CTRL));
+		val |= BAM_SW_RST;
+		writel_relaxed(val, bam_addr(bdev, 0, BAM_CTRL));
+	}
+
 err:
 	pm_runtime_mark_last_busy(bdev->dev);
 	pm_runtime_put_autosuspend(bdev->dev);
@@ -1164,38 +1214,10 @@ static int bam_init(struct bam_device *bdev)
 		bdev->num_channels = val & BAM_NUM_PIPES_MASK;
 	}
 
-	if (bdev->controlled_remotely)
+	if (bdev->controlled_remotely || bdev->remote_power_collapse)
 		return 0;
 
-	/* s/w reset bam */
-	/* after reset all pipes are disabled and idle */
-	val = readl_relaxed(bam_addr(bdev, 0, BAM_CTRL));
-	val |= BAM_SW_RST;
-	writel_relaxed(val, bam_addr(bdev, 0, BAM_CTRL));
-	val &= ~BAM_SW_RST;
-	writel_relaxed(val, bam_addr(bdev, 0, BAM_CTRL));
-
-	/* make sure previous stores are visible before enabling BAM */
-	wmb();
-
-	/* enable bam */
-	val |= BAM_EN;
-	writel_relaxed(val, bam_addr(bdev, 0, BAM_CTRL));
-
-	/* set descriptor threshhold, start with 4 bytes */
-	writel_relaxed(DEFAULT_CNT_THRSHLD,
-			bam_addr(bdev, 0, BAM_DESC_CNT_TRSHLD));
-
-	/* Enable default set of h/w workarounds, ie all except BAM_FULL_PIPE */
-	writel_relaxed(BAM_CNFG_BITS_DEFAULT, bam_addr(bdev, 0, BAM_CNFG_BITS));
-
-	/* enable irqs for errors */
-	writel_relaxed(BAM_ERROR_EN | BAM_HRESP_ERR_EN,
-			bam_addr(bdev, 0, BAM_IRQ_EN));
-
-	/* unmask global bam interrupt */
-	writel_relaxed(BAM_IRQ_MSK, bam_addr(bdev, 0, BAM_IRQ_SRCS_MSK_EE));
-
+	bam_reset(bdev);
 	return 0;
 }
 
@@ -1257,8 +1279,10 @@ static int bam_dma_probe(struct platform_device *pdev)
 
 	bdev->controlled_remotely = of_property_read_bool(pdev->dev.of_node,
 						"qcom,controlled-remotely");
+	bdev->remote_power_collapse = of_property_read_bool(pdev->dev.of_node,
+						"qcom,remote-power-collapse");
 
-	if (bdev->controlled_remotely) {
+	if (bdev->controlled_remotely || bdev->remote_power_collapse) {
 		ret = of_property_read_u32(pdev->dev.of_node, "num-channels",
 					   &bdev->num_channels);
 		if (ret)
@@ -1270,7 +1294,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 			dev_err(bdev->dev, "num-ees unspecified in dt\n");
 	}
 
-	if (bdev->controlled_remotely)
+	if (bdev->controlled_remotely || bdev->remote_power_collapse)
 		bdev->bamclk = devm_clk_get_optional(bdev->dev, "bam_clk");
 	else
 		bdev->bamclk = devm_clk_get(bdev->dev, "bam_clk");
-- 
2.32.0

