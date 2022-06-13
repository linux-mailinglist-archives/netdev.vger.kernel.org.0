Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F94547E37
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 05:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbiFMDpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 23:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiFMDpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 23:45:34 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3C612626
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 20:45:33 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id z14so331729pgh.0
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 20:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8e2+YdysEt3cn+fJPAORULNwZ8xIMjVsBm+5OObBefE=;
        b=bmBOhXaySGZJ5lfdkQdmsgDmh/d1TQBw/v3iO5tVkffiuxC8Q9GZBHGIyCpgHAhtlw
         ljgdT+uQs19OqDfby2/haMNKUMYDuzBHkL/MKBTGQ6nQN5XguIuTfA2L6Vd8H6gryb6d
         IaYIOcMZs4aVdiKukALd/81CElJmbmVyQB2kWjSsfH7fytaTcxV3WVGwOQe6lLC2BFya
         A1k7FKuUGk0sdOxhG0cWkHJQdRJ1F8ngB9iHB1Dp5Gg0rcldN2EqkTH1P2/5L+rvDi/8
         dHENDGoL1863UKuntOH0YMsuJsrVSR99FTvsXzSiUMphJl+mVfQpDY34r3Ey+6//GO60
         dPjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8e2+YdysEt3cn+fJPAORULNwZ8xIMjVsBm+5OObBefE=;
        b=W9pIJMf8tcxO/KPVA8jkIOndK4XwKQmd3jTzvF03TP6J3Y2PMuSGoU/TrMN1nAuaKX
         QBsNoYIyXkYH8eLCv9N6eTkyGiO3FQHiDRXYKeZMIOUDYBq6qLEb8L5Sa+8Q532B0vpz
         X5yx1irM5HsuJStNcZmNuOoMfWiQbKOzG3bmrm3JaJQE9wsmJ2JafdGDw4jnLPQo7Yh8
         iv/dpfjlDJQCOqDDF9SUz+Ye4ptb6n4PfqtbVG3huwvSlJIHSkRQ9IOjpAkcN6nl2CWZ
         lU+mgFL+Xx98Gpc6+CRb1iZPCWs/lS+q6TqH9jDzwwj0cqdGnakuelnvfltdngNvD7pl
         B5mA==
X-Gm-Message-State: AOAM532FVBhnA6DenUaUgh1l/3t3dC6ckRTG2qI8vOHdYUecwRiJVj+j
        GL4zNedWUjn/1u6SpwwfjNvZBg==
X-Google-Smtp-Source: ABdhPJyrFR307Y+dPHCP4+uz/MnF3mq88+n/o0ixCRCgEvTuOqXscRdkf4Kd0jb7G+Kqn7RD/3br9A==
X-Received: by 2002:a05:6a00:14cb:b0:51c:3f31:b60e with SMTP id w11-20020a056a0014cb00b0051c3f31b60emr31241313pfu.27.1655091933165;
        Sun, 12 Jun 2022 20:45:33 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id u13-20020a170902714d00b0015e8d4eb1dfsm3810769plm.41.2022.06.12.20.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jun 2022 20:45:32 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michal.simek@xilinx.com, netdev@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Andy Chiu <andy.chiu@sifive.com>, Max Hsu <max.hsu@sifive.com>
Subject: [PATCH net-next 1/2] net: axienet: make the 64b addresable DMA depends on 64b archectures
Date:   Mon, 13 Jun 2022 11:42:01 +0800
Message-Id: <20220613034202.3777248-2-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220613034202.3777248-1-andy.chiu@sifive.com>
References: <20220613034202.3777248-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently it is not safe to config the IP as 64-bit addressable on 32-bit
archectures, which cannot perform a double-word store on its descriptor
pointers. The pointer is 64-bit wide if the IP is configured as 64-bit,
and the device would process the partially updated pointer on some
states if the pointer was updated via two store-words. To prevent such
condition, we force a probe fail if we discover that the IP has 64-bit
capability but it is not running on a 64-Bit kernel.

This is a series of patch (1/2). The next patch must be applied in order
to make 64b DMA safe on 64b archectures.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reported-by: Max Hsu <max.hsu@sifive.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  | 36 +++++++++++++++++++
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 28 +++------------
 2 files changed, 40 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 4225efbeda3d..6c95676ba172 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -547,6 +547,42 @@ static inline void axienet_iow(struct axienet_local *lp, off_t offset,
 	iowrite32(value, lp->regs + offset);
 }
 
+/**
+ * axienet_dma_out32 - Memory mapped Axi DMA register write.
+ * @lp:		Pointer to axienet local structure
+ * @reg:	Address offset from the base address of the Axi DMA core
+ * @value:	Value to be written into the Axi DMA register
+ *
+ * This function writes the desired value into the corresponding Axi DMA
+ * register.
+ */
+
+static inline void axienet_dma_out32(struct axienet_local *lp,
+				     off_t reg, u32 value)
+{
+	iowrite32(value, lp->dma_regs + reg);
+}
+
+#ifdef CONFIG_64BIT
+static void axienet_dma_out_addr(struct axienet_local *lp, off_t reg,
+				 dma_addr_t addr)
+{
+	axienet_dma_out32(lp, reg, lower_32_bits(addr));
+
+	if (lp->features & XAE_FEATURE_DMA_64BIT)
+		axienet_dma_out32(lp, reg + 4, upper_32_bits(addr));
+}
+
+#else /* CONFIG_64BIT */
+
+static void axienet_dma_out_addr(struct axienet_local *lp, off_t reg,
+				 dma_addr_t addr)
+{
+	axienet_dma_out32(lp, reg, lower_32_bits(addr));
+}
+
+#endif /* CONFIG_64BIT */
+
 /* Function prototypes visible in xilinx_axienet_mdio.c for other files */
 int axienet_mdio_enable(struct axienet_local *lp);
 void axienet_mdio_disable(struct axienet_local *lp);
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 93c9f305bba4..fa7bcd2c1892 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -133,30 +133,6 @@ static inline u32 axienet_dma_in32(struct axienet_local *lp, off_t reg)
 	return ioread32(lp->dma_regs + reg);
 }
 
-/**
- * axienet_dma_out32 - Memory mapped Axi DMA register write.
- * @lp:		Pointer to axienet local structure
- * @reg:	Address offset from the base address of the Axi DMA core
- * @value:	Value to be written into the Axi DMA register
- *
- * This function writes the desired value into the corresponding Axi DMA
- * register.
- */
-static inline void axienet_dma_out32(struct axienet_local *lp,
-				     off_t reg, u32 value)
-{
-	iowrite32(value, lp->dma_regs + reg);
-}
-
-static void axienet_dma_out_addr(struct axienet_local *lp, off_t reg,
-				 dma_addr_t addr)
-{
-	axienet_dma_out32(lp, reg, lower_32_bits(addr));
-
-	if (lp->features & XAE_FEATURE_DMA_64BIT)
-		axienet_dma_out32(lp, reg + 4, upper_32_bits(addr));
-}
-
 static void desc_set_phys_addr(struct axienet_local *lp, dma_addr_t addr,
 			       struct axidma_bd *desc)
 {
@@ -2061,6 +2037,10 @@ static int axienet_probe(struct platform_device *pdev)
 			iowrite32(0x0, desc);
 		}
 	}
+	if (!IS_ENABLED(CONFIG_64BIT) && lp->features & XAE_FEATURE_DMA_64BIT) {
+		dev_err(&pdev->dev, "64-bit addressable DMA is not compatible with 32-bit archecture\n");
+		goto cleanup_clk;
+	}
 
 	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(addr_width));
 	if (ret) {
-- 
2.36.0

