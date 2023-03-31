Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70EE46D2A45
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 23:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbjCaVsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 17:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233262AbjCaVs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 17:48:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B4C2440E
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 14:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680299205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n7TbvwXB973vDm+5yx/gHPKSp5fy9U40uxACz9VreuI=;
        b=fnTIMM9QAGVuEKMJ0jNp4oUcfnR2yVBq43kyL9RPzyV5XQpDtD4BBXNht1u/qs7CjfPDlh
        gvKIG/5sEGib3uh9Z0RBLVLfYSiwN+SO1yXUl+ROsOI99h+DdrodG3t2dYgdS9XVGhBLws
        uHMDbumSYAUWjr/V2csysWH+mtAcAWw=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-X6e3cZXcPG-UaaOQH4T7AA-1; Fri, 31 Mar 2023 17:46:44 -0400
X-MC-Unique: X6e3cZXcPG-UaaOQH4T7AA-1
Received: by mail-ot1-f69.google.com with SMTP id e7-20020a05683013c700b0069f924eb636so8677295otq.8
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 14:46:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680299203;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n7TbvwXB973vDm+5yx/gHPKSp5fy9U40uxACz9VreuI=;
        b=RHC5UW7s1gfz3YPOuCNgY0neOr8lnXZpbr6Jl7x4wGM/jZDfUaj2mAKdpTyX6humgH
         84UH21zXUdCu5mWA7SbBV2rBLuwRzpiRpFJ5bKccMN5Ia1nK+3f3/9t3pi/3JhANL5MK
         Pk75Rf/dKxYQFX2IM4EznZ0NtdqJ3xe2c4j5WHpWyE5aY4IWtS7w7utM0nP3YuIVBUXK
         tM0aavbxycggMryb8iYLoM9GT1U2kb2YUPiY8dXmg6b607s4h5UemPdJapy86x+FE7rn
         ObO2A73IpXtlnQeb0ukWTg0a6CJyW/kbpmDG5DLVDdjatsImb2/Nttfz4phNjQSaxP8I
         Eldw==
X-Gm-Message-State: AO0yUKUYedcTFdHOhIHloRHy7dMOhreuSDYbJ4vP38Rbv8VCOUhv7as8
        2puOwUU6x6uOZwDES2BMslDRUzXhFLW+Esw9kFX6J9Ppli1ED0iv56siJHVbHBtA0BSodDhI4pZ
        aM6sL2As5P5Qh9eNP
X-Received: by 2002:a4a:5512:0:b0:525:5cf6:917d with SMTP id e18-20020a4a5512000000b005255cf6917dmr15260545oob.5.1680299203019;
        Fri, 31 Mar 2023 14:46:43 -0700 (PDT)
X-Google-Smtp-Source: AK7set9Cx4yfcG51fsAIFj0R3GJSDq/7eTFL19+12kEqmzUfWXWikCiP3goe/cm/GnKnBFSpPqeRaA==
X-Received: by 2002:a4a:5512:0:b0:525:5cf6:917d with SMTP id e18-20020a4a5512000000b005255cf6917dmr15260521oob.5.1680299202649;
        Fri, 31 Mar 2023 14:46:42 -0700 (PDT)
Received: from halaney-x13s.attlocal.net (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id x80-20020a4a4153000000b0053d9be4be68sm1328531ooa.19.2023.03.31.14.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 14:46:42 -0700 (PDT)
From:   Andrew Halaney <ahalaney@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, wens@csie.org, jernej.skrabec@gmail.com,
        samuel@sholland.org, mturquette@baylibre.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com,
        Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH net-next v3 09/12] net: stmmac: dwmac4: Allow platforms to specify some DMA/MTL offsets
Date:   Fri, 31 Mar 2023 16:45:46 -0500
Message-Id: <20230331214549.756660-10-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230331214549.756660-1-ahalaney@redhat.com>
References: <20230331214549.756660-1-ahalaney@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some platforms have dwmac4 implementations that have a different
address space layout than the default, resulting in the need to define
their own DMA/MTL offsets.

Extend the functions to allow a platform driver to indicate what its
addresses are, overriding the defaults.

Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---

This patch (and the prior patch) are replacements for
https://lore.kernel.org/netdev/20230320204153.21736840@kernel.org/
as was requested. Hopefully I was understanding the intent correctly :)

I'm pretty sure further refinement will be requested for this one, but
it is the best I could come up with myself! Specifically some of the
naming, dealing with spacing in some older spots of dwmac4,
where the addresses should live in the structure hierarchy, etc are
things I would not be surprised to have to rework if this is still
preferred over the wrapper approach.

Changes since v2:
    * New, replacing old wrapper approach

 drivers/net/ethernet/stmicro/stmmac/dwmac4.h  |  91 ++++++++--
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c |  36 ++--
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  | 157 ++++++++++--------
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.h  |  51 +++---
 .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  |  67 +++++---
 include/linux/stmmac.h                        |  19 +++
 6 files changed, 279 insertions(+), 142 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index ccd49346d3b3..a0c0ee1dc13f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -336,14 +336,23 @@ enum power_event {
 
 #define MTL_CHAN_BASE_ADDR		0x00000d00
 #define MTL_CHAN_BASE_OFFSET		0x40
-#define MTL_CHANX_BASE_ADDR(x)		(MTL_CHAN_BASE_ADDR + \
-					(x * MTL_CHAN_BASE_OFFSET))
-
-#define MTL_CHAN_TX_OP_MODE(x)		MTL_CHANX_BASE_ADDR(x)
-#define MTL_CHAN_TX_DEBUG(x)		(MTL_CHANX_BASE_ADDR(x) + 0x8)
-#define MTL_CHAN_INT_CTRL(x)		(MTL_CHANX_BASE_ADDR(x) + 0x2c)
-#define MTL_CHAN_RX_OP_MODE(x)		(MTL_CHANX_BASE_ADDR(x) + 0x30)
-#define MTL_CHAN_RX_DEBUG(x)		(MTL_CHANX_BASE_ADDR(x) + 0x38)
+#define MTL_CHANX_BASE_ADDR(addrs, x)  \
+({ \
+	const struct dwmac4_addrs *__addrs = addrs; \
+	const u32 __x = x; \
+	u32 __addr; \
+	if (__addrs) \
+		__addr = __addrs->mtl_chan + (__x * __addrs->mtl_chan_offset); \
+	else \
+		__addr = MTL_CHAN_BASE_ADDR + (__x * MTL_CHAN_BASE_OFFSET); \
+	__addr; \
+})
+
+#define MTL_CHAN_TX_OP_MODE(addrs, x)	MTL_CHANX_BASE_ADDR(addrs, x)
+#define MTL_CHAN_TX_DEBUG(addrs, x)	(MTL_CHANX_BASE_ADDR(addrs, x) + 0x8)
+#define MTL_CHAN_INT_CTRL(addrs, x)	(MTL_CHANX_BASE_ADDR(addrs, x) + 0x2c)
+#define MTL_CHAN_RX_OP_MODE(addrs, x)	(MTL_CHANX_BASE_ADDR(addrs, x) + 0x30)
+#define MTL_CHAN_RX_DEBUG(addrs, x)	(MTL_CHANX_BASE_ADDR(addrs, x) + 0x38)
 
 #define MTL_OP_MODE_RSF			BIT(5)
 #define MTL_OP_MODE_TXQEN_MASK		GENMASK(3, 2)
@@ -388,8 +397,17 @@ enum power_event {
 /* MTL ETS Control register */
 #define MTL_ETS_CTRL_BASE_ADDR		0x00000d10
 #define MTL_ETS_CTRL_BASE_OFFSET	0x40
-#define MTL_ETSX_CTRL_BASE_ADDR(x)	(MTL_ETS_CTRL_BASE_ADDR + \
-					((x) * MTL_ETS_CTRL_BASE_OFFSET))
+#define MTL_ETSX_CTRL_BASE_ADDR(addrs, x)  \
+({ \
+	const struct dwmac4_addrs *__addrs = addrs; \
+	const u32 __x = x; \
+	u32 __addr; \
+	if (__addrs) \
+		__addr = __addrs->mtl_ets_ctrl + (__x * __addrs->mtl_ets_ctrl_offset); \
+	else \
+		__addr = MTL_ETS_CTRL_BASE_ADDR + (__x * MTL_ETS_CTRL_BASE_OFFSET); \
+	__addr; \
+})
 
 #define MTL_ETS_CTRL_CC			BIT(3)
 #define MTL_ETS_CTRL_AVALG		BIT(2)
@@ -397,31 +415,68 @@ enum power_event {
 /* MTL Queue Quantum Weight */
 #define MTL_TXQ_WEIGHT_BASE_ADDR	0x00000d18
 #define MTL_TXQ_WEIGHT_BASE_OFFSET	0x40
-#define MTL_TXQX_WEIGHT_BASE_ADDR(x)	(MTL_TXQ_WEIGHT_BASE_ADDR + \
-					((x) * MTL_TXQ_WEIGHT_BASE_OFFSET))
+#define MTL_TXQX_WEIGHT_BASE_ADDR(addrs, x)  \
+({ \
+	const struct dwmac4_addrs *__addrs = addrs; \
+	const u32 __x = x; \
+	u32 __addr; \
+	if (__addrs) \
+		__addr = __addrs->mtl_txq_weight + (__x * __addrs->mtl_txq_weight_offset); \
+	else \
+		__addr = MTL_TXQ_WEIGHT_BASE_ADDR + (__x * MTL_TXQ_WEIGHT_BASE_OFFSET); \
+	__addr; \
+})
+
 #define MTL_TXQ_WEIGHT_ISCQW_MASK	GENMASK(20, 0)
 
 /* MTL sendSlopeCredit register */
 #define MTL_SEND_SLP_CRED_BASE_ADDR	0x00000d1c
 #define MTL_SEND_SLP_CRED_OFFSET	0x40
-#define MTL_SEND_SLP_CREDX_BASE_ADDR(x)	(MTL_SEND_SLP_CRED_BASE_ADDR + \
-					((x) * MTL_SEND_SLP_CRED_OFFSET))
+#define MTL_SEND_SLP_CREDX_BASE_ADDR(addrs, x)  \
+({ \
+	const struct dwmac4_addrs *__addrs = addrs; \
+	const u32 __x = x; \
+	u32 __addr; \
+	if (__addrs) \
+		__addr = __addrs->mtl_send_slp_cred + (__x * __addrs->mtl_send_slp_cred_offset); \
+	else \
+		__addr = MTL_SEND_SLP_CRED_BASE_ADDR + (__x * MTL_SEND_SLP_CRED_OFFSET); \
+	__addr; \
+})
 
 #define MTL_SEND_SLP_CRED_SSC_MASK	GENMASK(13, 0)
 
 /* MTL hiCredit register */
 #define MTL_HIGH_CRED_BASE_ADDR		0x00000d20
 #define MTL_HIGH_CRED_OFFSET		0x40
-#define MTL_HIGH_CREDX_BASE_ADDR(x)	(MTL_HIGH_CRED_BASE_ADDR + \
-					((x) * MTL_HIGH_CRED_OFFSET))
+#define MTL_HIGH_CREDX_BASE_ADDR(addrs, x)  \
+({ \
+	const struct dwmac4_addrs *__addrs = addrs; \
+	const u32 __x = x; \
+	u32 __addr; \
+	if (__addrs) \
+		__addr = __addrs->mtl_high_cred + (__x * __addrs->mtl_high_cred_offset); \
+	else \
+		__addr = MTL_HIGH_CRED_BASE_ADDR + (__x * MTL_HIGH_CRED_OFFSET); \
+	__addr; \
+})
 
 #define MTL_HIGH_CRED_HC_MASK		GENMASK(28, 0)
 
 /* MTL loCredit register */
 #define MTL_LOW_CRED_BASE_ADDR		0x00000d24
 #define MTL_LOW_CRED_OFFSET		0x40
-#define MTL_LOW_CREDX_BASE_ADDR(x)	(MTL_LOW_CRED_BASE_ADDR + \
-					((x) * MTL_LOW_CRED_OFFSET))
+#define MTL_LOW_CREDX_BASE_ADDR(addrs, x)  \
+({ \
+	const struct dwmac4_addrs *__addrs = addrs; \
+	const u32 __x = x; \
+	u32 __addr; \
+	if (__addrs) \
+		__addr = __addrs->mtl_low_cred + (__x * __addrs->mtl_low_cred_offset); \
+	else \
+		__addr = MTL_LOW_CRED_BASE_ADDR + (__x * MTL_LOW_CRED_OFFSET); \
+	__addr; \
+})
 
 #define MTL_HIGH_CRED_LC_MASK		GENMASK(28, 0)
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index f44180519638..4b5b302515c4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -202,12 +202,14 @@ static void dwmac4_set_mtl_tx_queue_weight(struct stmmac_priv *priv,
 					   struct mac_device_info *hw,
 					   u32 weight, u32 queue)
 {
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
 	void __iomem *ioaddr = hw->pcsr;
-	u32 value = readl(ioaddr + MTL_TXQX_WEIGHT_BASE_ADDR(queue));
+	u32 value = readl(ioaddr + MTL_TXQX_WEIGHT_BASE_ADDR(dwmac4_addrs,
+							     queue));
 
 	value &= ~MTL_TXQ_WEIGHT_ISCQW_MASK;
 	value |= weight & MTL_TXQ_WEIGHT_ISCQW_MASK;
-	writel(value, ioaddr + MTL_TXQX_WEIGHT_BASE_ADDR(queue));
+	writel(value, ioaddr + MTL_TXQX_WEIGHT_BASE_ADDR(dwmac4_addrs, queue));
 }
 
 static void dwmac4_map_mtl_dma(struct mac_device_info *hw, u32 queue, u32 chan)
@@ -233,6 +235,7 @@ static void dwmac4_config_cbs(struct stmmac_priv *priv,
 			      u32 send_slope, u32 idle_slope,
 			      u32 high_credit, u32 low_credit, u32 queue)
 {
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
 	void __iomem *ioaddr = hw->pcsr;
 	u32 value;
 
@@ -243,31 +246,33 @@ static void dwmac4_config_cbs(struct stmmac_priv *priv,
 	pr_debug("\tlow_credit: 0x%08x\n", low_credit);
 
 	/* enable AV algorithm */
-	value = readl(ioaddr + MTL_ETSX_CTRL_BASE_ADDR(queue));
+	value = readl(ioaddr + MTL_ETSX_CTRL_BASE_ADDR(dwmac4_addrs, queue));
 	value |= MTL_ETS_CTRL_AVALG;
 	value |= MTL_ETS_CTRL_CC;
-	writel(value, ioaddr + MTL_ETSX_CTRL_BASE_ADDR(queue));
+	writel(value, ioaddr + MTL_ETSX_CTRL_BASE_ADDR(dwmac4_addrs, queue));
 
 	/* configure send slope */
-	value = readl(ioaddr + MTL_SEND_SLP_CREDX_BASE_ADDR(queue));
+	value = readl(ioaddr + MTL_SEND_SLP_CREDX_BASE_ADDR(dwmac4_addrs,
+							    queue));
 	value &= ~MTL_SEND_SLP_CRED_SSC_MASK;
 	value |= send_slope & MTL_SEND_SLP_CRED_SSC_MASK;
-	writel(value, ioaddr + MTL_SEND_SLP_CREDX_BASE_ADDR(queue));
+	writel(value, ioaddr + MTL_SEND_SLP_CREDX_BASE_ADDR(dwmac4_addrs,
+							    queue));
 
 	/* configure idle slope (same register as tx weight) */
 	dwmac4_set_mtl_tx_queue_weight(priv, hw, idle_slope, queue);
 
 	/* configure high credit */
-	value = readl(ioaddr + MTL_HIGH_CREDX_BASE_ADDR(queue));
+	value = readl(ioaddr + MTL_HIGH_CREDX_BASE_ADDR(dwmac4_addrs, queue));
 	value &= ~MTL_HIGH_CRED_HC_MASK;
 	value |= high_credit & MTL_HIGH_CRED_HC_MASK;
-	writel(value, ioaddr + MTL_HIGH_CREDX_BASE_ADDR(queue));
+	writel(value, ioaddr + MTL_HIGH_CREDX_BASE_ADDR(dwmac4_addrs, queue));
 
 	/* configure high credit */
-	value = readl(ioaddr + MTL_LOW_CREDX_BASE_ADDR(queue));
+	value = readl(ioaddr + MTL_LOW_CREDX_BASE_ADDR(dwmac4_addrs, queue));
 	value &= ~MTL_HIGH_CRED_LC_MASK;
 	value |= low_credit & MTL_HIGH_CRED_LC_MASK;
-	writel(value, ioaddr + MTL_LOW_CREDX_BASE_ADDR(queue));
+	writel(value, ioaddr + MTL_LOW_CREDX_BASE_ADDR(dwmac4_addrs, queue));
 }
 
 static void dwmac4_dump_regs(struct mac_device_info *hw, u32 *reg_space)
@@ -764,6 +769,7 @@ static void dwmac4_phystatus(void __iomem *ioaddr, struct stmmac_extra_stats *x)
 static int dwmac4_irq_mtl_status(struct stmmac_priv *priv,
 				 struct mac_device_info *hw, u32 chan)
 {
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
 	void __iomem *ioaddr = hw->pcsr;
 	u32 mtl_int_qx_status;
 	int ret = 0;
@@ -773,12 +779,13 @@ static int dwmac4_irq_mtl_status(struct stmmac_priv *priv,
 	/* Check MTL Interrupt */
 	if (mtl_int_qx_status & MTL_INT_QX(chan)) {
 		/* read Queue x Interrupt status */
-		u32 status = readl(ioaddr + MTL_CHAN_INT_CTRL(chan));
+		u32 status = readl(ioaddr + MTL_CHAN_INT_CTRL(dwmac4_addrs,
+							      chan));
 
 		if (status & MTL_RX_OVERFLOW_INT) {
 			/*  clear Interrupt */
 			writel(status | MTL_RX_OVERFLOW_INT,
-			       ioaddr + MTL_CHAN_INT_CTRL(chan));
+			       ioaddr + MTL_CHAN_INT_CTRL(dwmac4_addrs, chan));
 			ret = CORE_IRQ_MTL_RX_OVERFLOW;
 		}
 	}
@@ -840,11 +847,12 @@ static void dwmac4_debug(struct stmmac_priv *priv, void __iomem *ioaddr,
 			 struct stmmac_extra_stats *x,
 			 u32 rx_queues, u32 tx_queues)
 {
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
 	u32 value;
 	u32 queue;
 
 	for (queue = 0; queue < tx_queues; queue++) {
-		value = readl(ioaddr + MTL_CHAN_TX_DEBUG(queue));
+		value = readl(ioaddr + MTL_CHAN_TX_DEBUG(dwmac4_addrs, queue));
 
 		if (value & MTL_DEBUG_TXSTSFSTS)
 			x->mtl_tx_status_fifo_full++;
@@ -869,7 +877,7 @@ static void dwmac4_debug(struct stmmac_priv *priv, void __iomem *ioaddr,
 	}
 
 	for (queue = 0; queue < rx_queues; queue++) {
-		value = readl(ioaddr + MTL_CHAN_RX_DEBUG(queue));
+		value = readl(ioaddr + MTL_CHAN_RX_DEBUG(dwmac4_addrs, queue));
 
 		if (value & MTL_DEBUG_RXFSTS_MASK) {
 			u32 rxfsts = (value & MTL_DEBUG_RXFSTS_MASK)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index 6f255d12f60f..84d3a8551b03 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -13,6 +13,7 @@
 #include <linux/io.h>
 #include "dwmac4.h"
 #include "dwmac4_dma.h"
+#include "stmmac.h"
 
 static void dwmac4_dma_axi(void __iomem *ioaddr, struct stmmac_axi *axi)
 {
@@ -73,18 +74,20 @@ static void dwmac4_dma_init_rx_chan(struct stmmac_priv *priv,
 				    struct stmmac_dma_cfg *dma_cfg,
 				    dma_addr_t dma_rx_phy, u32 chan)
 {
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
 	u32 value;
 	u32 rxpbl = dma_cfg->rxpbl ?: dma_cfg->pbl;
 
-	value = readl(ioaddr + DMA_CHAN_RX_CONTROL(chan));
+	value = readl(ioaddr + DMA_CHAN_RX_CONTROL(dwmac4_addrs, chan));
 	value = value | (rxpbl << DMA_BUS_MODE_RPBL_SHIFT);
-	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(chan));
+	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(dwmac4_addrs, chan));
 
 	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT) && likely(dma_cfg->eame))
 		writel(upper_32_bits(dma_rx_phy),
-		       ioaddr + DMA_CHAN_RX_BASE_ADDR_HI(chan));
+		       ioaddr + DMA_CHAN_RX_BASE_ADDR_HI(dwmac4_addrs, chan));
 
-	writel(lower_32_bits(dma_rx_phy), ioaddr + DMA_CHAN_RX_BASE_ADDR(chan));
+	writel(lower_32_bits(dma_rx_phy),
+	       ioaddr + DMA_CHAN_RX_BASE_ADDR(dwmac4_addrs, chan));
 }
 
 static void dwmac4_dma_init_tx_chan(struct stmmac_priv *priv,
@@ -92,57 +95,61 @@ static void dwmac4_dma_init_tx_chan(struct stmmac_priv *priv,
 				    struct stmmac_dma_cfg *dma_cfg,
 				    dma_addr_t dma_tx_phy, u32 chan)
 {
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
 	u32 value;
 	u32 txpbl = dma_cfg->txpbl ?: dma_cfg->pbl;
 
-	value = readl(ioaddr + DMA_CHAN_TX_CONTROL(chan));
+	value = readl(ioaddr + DMA_CHAN_TX_CONTROL(dwmac4_addrs, chan));
 	value = value | (txpbl << DMA_BUS_MODE_PBL_SHIFT);
 
 	/* Enable OSP to get best performance */
 	value |= DMA_CONTROL_OSP;
 
-	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(chan));
+	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(dwmac4_addrs, chan));
 
 	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT) && likely(dma_cfg->eame))
 		writel(upper_32_bits(dma_tx_phy),
-		       ioaddr + DMA_CHAN_TX_BASE_ADDR_HI(chan));
+		       ioaddr + DMA_CHAN_TX_BASE_ADDR_HI(dwmac4_addrs, chan));
 
-	writel(lower_32_bits(dma_tx_phy), ioaddr + DMA_CHAN_TX_BASE_ADDR(chan));
+	writel(lower_32_bits(dma_tx_phy),
+	       ioaddr + DMA_CHAN_TX_BASE_ADDR(dwmac4_addrs, chan));
 }
 
 static void dwmac4_dma_init_channel(struct stmmac_priv *priv,
 				    void __iomem *ioaddr,
 				    struct stmmac_dma_cfg *dma_cfg, u32 chan)
 {
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
 	u32 value;
 
 	/* common channel control register config */
-	value = readl(ioaddr + DMA_CHAN_CONTROL(chan));
+	value = readl(ioaddr + DMA_CHAN_CONTROL(dwmac4_addrs, chan));
 	if (dma_cfg->pblx8)
 		value = value | DMA_BUS_MODE_PBL;
-	writel(value, ioaddr + DMA_CHAN_CONTROL(chan));
+	writel(value, ioaddr + DMA_CHAN_CONTROL(dwmac4_addrs, chan));
 
 	/* Mask interrupts by writing to CSR7 */
 	writel(DMA_CHAN_INTR_DEFAULT_MASK,
-	       ioaddr + DMA_CHAN_INTR_ENA(chan));
+	       ioaddr + DMA_CHAN_INTR_ENA(dwmac4_addrs, chan));
 }
 
 static void dwmac410_dma_init_channel(struct stmmac_priv *priv,
 				      void __iomem *ioaddr,
 				      struct stmmac_dma_cfg *dma_cfg, u32 chan)
 {
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
 	u32 value;
 
 	/* common channel control register config */
-	value = readl(ioaddr + DMA_CHAN_CONTROL(chan));
+	value = readl(ioaddr + DMA_CHAN_CONTROL(dwmac4_addrs, chan));
 	if (dma_cfg->pblx8)
 		value = value | DMA_BUS_MODE_PBL;
 
-	writel(value, ioaddr + DMA_CHAN_CONTROL(chan));
+	writel(value, ioaddr + DMA_CHAN_CONTROL(dwmac4_addrs, chan));
 
 	/* Mask interrupts by writing to CSR7 */
 	writel(DMA_CHAN_INTR_DEFAULT_MASK_4_10,
-	       ioaddr + DMA_CHAN_INTR_ENA(chan));
+	       ioaddr + DMA_CHAN_INTR_ENA(dwmac4_addrs, chan));
 }
 
 static void dwmac4_dma_init(void __iomem *ioaddr,
@@ -184,40 +191,46 @@ static void _dwmac4_dump_dma_regs(struct stmmac_priv *priv,
 				  void __iomem *ioaddr, u32 channel,
 				  u32 *reg_space)
 {
-	reg_space[DMA_CHAN_CONTROL(channel) / 4] =
-		readl(ioaddr + DMA_CHAN_CONTROL(channel));
-	reg_space[DMA_CHAN_TX_CONTROL(channel) / 4] =
-		readl(ioaddr + DMA_CHAN_TX_CONTROL(channel));
-	reg_space[DMA_CHAN_RX_CONTROL(channel) / 4] =
-		readl(ioaddr + DMA_CHAN_RX_CONTROL(channel));
-	reg_space[DMA_CHAN_TX_BASE_ADDR(channel) / 4] =
-		readl(ioaddr + DMA_CHAN_TX_BASE_ADDR(channel));
-	reg_space[DMA_CHAN_RX_BASE_ADDR(channel) / 4] =
-		readl(ioaddr + DMA_CHAN_RX_BASE_ADDR(channel));
-	reg_space[DMA_CHAN_TX_END_ADDR(channel) / 4] =
-		readl(ioaddr + DMA_CHAN_TX_END_ADDR(channel));
-	reg_space[DMA_CHAN_RX_END_ADDR(channel) / 4] =
-		readl(ioaddr + DMA_CHAN_RX_END_ADDR(channel));
-	reg_space[DMA_CHAN_TX_RING_LEN(channel) / 4] =
-		readl(ioaddr + DMA_CHAN_TX_RING_LEN(channel));
-	reg_space[DMA_CHAN_RX_RING_LEN(channel) / 4] =
-		readl(ioaddr + DMA_CHAN_RX_RING_LEN(channel));
-	reg_space[DMA_CHAN_INTR_ENA(channel) / 4] =
-		readl(ioaddr + DMA_CHAN_INTR_ENA(channel));
-	reg_space[DMA_CHAN_RX_WATCHDOG(channel) / 4] =
-		readl(ioaddr + DMA_CHAN_RX_WATCHDOG(channel));
-	reg_space[DMA_CHAN_SLOT_CTRL_STATUS(channel) / 4] =
-		readl(ioaddr + DMA_CHAN_SLOT_CTRL_STATUS(channel));
-	reg_space[DMA_CHAN_CUR_TX_DESC(channel) / 4] =
-		readl(ioaddr + DMA_CHAN_CUR_TX_DESC(channel));
-	reg_space[DMA_CHAN_CUR_RX_DESC(channel) / 4] =
-		readl(ioaddr + DMA_CHAN_CUR_RX_DESC(channel));
-	reg_space[DMA_CHAN_CUR_TX_BUF_ADDR(channel) / 4] =
-		readl(ioaddr + DMA_CHAN_CUR_TX_BUF_ADDR(channel));
-	reg_space[DMA_CHAN_CUR_RX_BUF_ADDR(channel) / 4] =
-		readl(ioaddr + DMA_CHAN_CUR_RX_BUF_ADDR(channel));
-	reg_space[DMA_CHAN_STATUS(channel) / 4] =
-		readl(ioaddr + DMA_CHAN_STATUS(channel));
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
+	const struct dwmac4_addrs *default_addrs = NULL;
+
+	/* Purposely save the registers in the "normal" layout, regardless of
+	 * platform modifications, to keep reg_space size constant
+	 */
+	reg_space[DMA_CHAN_CONTROL(default_addrs, channel) / 4] =
+		readl(ioaddr + DMA_CHAN_CONTROL(dwmac4_addrs, channel));
+	reg_space[DMA_CHAN_TX_CONTROL(default_addrs, channel) / 4] =
+		readl(ioaddr + DMA_CHAN_TX_CONTROL(dwmac4_addrs, channel));
+	reg_space[DMA_CHAN_RX_CONTROL(default_addrs, channel) / 4] =
+		readl(ioaddr + DMA_CHAN_RX_CONTROL(dwmac4_addrs, channel));
+	reg_space[DMA_CHAN_TX_BASE_ADDR(default_addrs, channel) / 4] =
+		readl(ioaddr + DMA_CHAN_TX_BASE_ADDR(dwmac4_addrs, channel));
+	reg_space[DMA_CHAN_RX_BASE_ADDR(default_addrs, channel) / 4] =
+		readl(ioaddr + DMA_CHAN_RX_BASE_ADDR(dwmac4_addrs, channel));
+	reg_space[DMA_CHAN_TX_END_ADDR(default_addrs, channel) / 4] =
+		readl(ioaddr + DMA_CHAN_TX_END_ADDR(dwmac4_addrs, channel));
+	reg_space[DMA_CHAN_RX_END_ADDR(default_addrs, channel) / 4] =
+		readl(ioaddr + DMA_CHAN_RX_END_ADDR(dwmac4_addrs, channel));
+	reg_space[DMA_CHAN_TX_RING_LEN(default_addrs, channel) / 4] =
+		readl(ioaddr + DMA_CHAN_TX_RING_LEN(dwmac4_addrs, channel));
+	reg_space[DMA_CHAN_RX_RING_LEN(default_addrs, channel) / 4] =
+		readl(ioaddr + DMA_CHAN_RX_RING_LEN(dwmac4_addrs, channel));
+	reg_space[DMA_CHAN_INTR_ENA(default_addrs, channel) / 4] =
+		readl(ioaddr + DMA_CHAN_INTR_ENA(dwmac4_addrs, channel));
+	reg_space[DMA_CHAN_RX_WATCHDOG(default_addrs, channel) / 4] =
+		readl(ioaddr + DMA_CHAN_RX_WATCHDOG(dwmac4_addrs, channel));
+	reg_space[DMA_CHAN_SLOT_CTRL_STATUS(default_addrs, channel) / 4] =
+		readl(ioaddr + DMA_CHAN_SLOT_CTRL_STATUS(dwmac4_addrs, channel));
+	reg_space[DMA_CHAN_CUR_TX_DESC(default_addrs, channel) / 4] =
+		readl(ioaddr + DMA_CHAN_CUR_TX_DESC(dwmac4_addrs, channel));
+	reg_space[DMA_CHAN_CUR_RX_DESC(default_addrs, channel) / 4] =
+		readl(ioaddr + DMA_CHAN_CUR_RX_DESC(dwmac4_addrs, channel));
+	reg_space[DMA_CHAN_CUR_TX_BUF_ADDR(default_addrs, channel) / 4] =
+		readl(ioaddr + DMA_CHAN_CUR_TX_BUF_ADDR(dwmac4_addrs, channel));
+	reg_space[DMA_CHAN_CUR_RX_BUF_ADDR(default_addrs, channel) / 4] =
+		readl(ioaddr + DMA_CHAN_CUR_RX_BUF_ADDR(dwmac4_addrs, channel));
+	reg_space[DMA_CHAN_STATUS(default_addrs, channel) / 4] =
+		readl(ioaddr + DMA_CHAN_STATUS(dwmac4_addrs, channel));
 }
 
 static void dwmac4_dump_dma_regs(struct stmmac_priv *priv, void __iomem *ioaddr,
@@ -232,17 +245,20 @@ static void dwmac4_dump_dma_regs(struct stmmac_priv *priv, void __iomem *ioaddr,
 static void dwmac4_rx_watchdog(struct stmmac_priv *priv, void __iomem *ioaddr,
 			       u32 riwt, u32 queue)
 {
-	writel(riwt, ioaddr + DMA_CHAN_RX_WATCHDOG(queue));
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
+
+	writel(riwt, ioaddr + DMA_CHAN_RX_WATCHDOG(dwmac4_addrs, queue));
 }
 
 static void dwmac4_dma_rx_chan_op_mode(struct stmmac_priv *priv,
 				       void __iomem *ioaddr, int mode,
 				       u32 channel, int fifosz, u8 qmode)
 {
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
 	unsigned int rqs = fifosz / 256 - 1;
 	u32 mtl_rx_op;
 
-	mtl_rx_op = readl(ioaddr + MTL_CHAN_RX_OP_MODE(channel));
+	mtl_rx_op = readl(ioaddr + MTL_CHAN_RX_OP_MODE(dwmac4_addrs, channel));
 
 	if (mode == SF_DMA_MODE) {
 		pr_debug("GMAC: enable RX store and forward mode\n");
@@ -300,14 +316,16 @@ static void dwmac4_dma_rx_chan_op_mode(struct stmmac_priv *priv,
 		mtl_rx_op |= rfa << MTL_OP_MODE_RFA_SHIFT;
 	}
 
-	writel(mtl_rx_op, ioaddr + MTL_CHAN_RX_OP_MODE(channel));
+	writel(mtl_rx_op, ioaddr + MTL_CHAN_RX_OP_MODE(dwmac4_addrs, channel));
 }
 
 static void dwmac4_dma_tx_chan_op_mode(struct stmmac_priv *priv,
 				       void __iomem *ioaddr, int mode,
 				       u32 channel, int fifosz, u8 qmode)
 {
-	u32 mtl_tx_op = readl(ioaddr + MTL_CHAN_TX_OP_MODE(channel));
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
+	u32 mtl_tx_op = readl(ioaddr + MTL_CHAN_TX_OP_MODE(dwmac4_addrs,
+							   channel));
 	unsigned int tqs = fifosz / 256 - 1;
 
 	if (mode == SF_DMA_MODE) {
@@ -353,7 +371,7 @@ static void dwmac4_dma_tx_chan_op_mode(struct stmmac_priv *priv,
 	mtl_tx_op &= ~MTL_OP_MODE_TQS_MASK;
 	mtl_tx_op |= tqs << MTL_OP_MODE_TQS_SHIFT;
 
-	writel(mtl_tx_op, ioaddr +  MTL_CHAN_TX_OP_MODE(channel));
+	writel(mtl_tx_op, ioaddr +  MTL_CHAN_TX_OP_MODE(dwmac4_addrs, channel));
 }
 
 static int dwmac4_get_hw_feature(void __iomem *ioaddr,
@@ -454,25 +472,28 @@ static int dwmac4_get_hw_feature(void __iomem *ioaddr,
 static void dwmac4_enable_tso(struct stmmac_priv *priv, void __iomem *ioaddr,
 			      bool en, u32 chan)
 {
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
 	u32 value;
 
 	if (en) {
 		/* enable TSO */
-		value = readl(ioaddr + DMA_CHAN_TX_CONTROL(chan));
+		value = readl(ioaddr + DMA_CHAN_TX_CONTROL(dwmac4_addrs, chan));
 		writel(value | DMA_CONTROL_TSE,
-		       ioaddr + DMA_CHAN_TX_CONTROL(chan));
+		       ioaddr + DMA_CHAN_TX_CONTROL(dwmac4_addrs, chan));
 	} else {
 		/* enable TSO */
-		value = readl(ioaddr + DMA_CHAN_TX_CONTROL(chan));
+		value = readl(ioaddr + DMA_CHAN_TX_CONTROL(dwmac4_addrs, chan));
 		writel(value & ~DMA_CONTROL_TSE,
-		       ioaddr + DMA_CHAN_TX_CONTROL(chan));
+		       ioaddr + DMA_CHAN_TX_CONTROL(dwmac4_addrs, chan));
 	}
 }
 
 static void dwmac4_qmode(struct stmmac_priv *priv, void __iomem *ioaddr,
 			 u32 channel, u8 qmode)
 {
-	u32 mtl_tx_op = readl(ioaddr + MTL_CHAN_TX_OP_MODE(channel));
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
+	u32 mtl_tx_op = readl(ioaddr + MTL_CHAN_TX_OP_MODE(dwmac4_addrs,
+							   channel));
 
 	mtl_tx_op &= ~MTL_OP_MODE_TXQEN_MASK;
 	if (qmode != MTL_QUEUE_AVB)
@@ -480,50 +501,54 @@ static void dwmac4_qmode(struct stmmac_priv *priv, void __iomem *ioaddr,
 	else
 		mtl_tx_op |= MTL_OP_MODE_TXQEN_AV;
 
-	writel(mtl_tx_op, ioaddr +  MTL_CHAN_TX_OP_MODE(channel));
+	writel(mtl_tx_op, ioaddr +  MTL_CHAN_TX_OP_MODE(dwmac4_addrs, channel));
 }
 
 static void dwmac4_set_bfsize(struct stmmac_priv *priv, void __iomem *ioaddr,
 			      int bfsize, u32 chan)
 {
-	u32 value = readl(ioaddr + DMA_CHAN_RX_CONTROL(chan));
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
+	u32 value = readl(ioaddr + DMA_CHAN_RX_CONTROL(dwmac4_addrs, chan));
 
 	value &= ~DMA_RBSZ_MASK;
 	value |= (bfsize << DMA_RBSZ_SHIFT) & DMA_RBSZ_MASK;
 
-	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(chan));
+	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(dwmac4_addrs, chan));
 }
 
 static void dwmac4_enable_sph(struct stmmac_priv *priv, void __iomem *ioaddr,
 			      bool en, u32 chan)
 {
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
 	u32 value = readl(ioaddr + GMAC_EXT_CONFIG);
 
 	value &= ~GMAC_CONFIG_HDSMS;
 	value |= GMAC_CONFIG_HDSMS_256; /* Segment max 256 bytes */
 	writel(value, ioaddr + GMAC_EXT_CONFIG);
 
-	value = readl(ioaddr + DMA_CHAN_CONTROL(chan));
+	value = readl(ioaddr + DMA_CHAN_CONTROL(dwmac4_addrs, chan));
 	if (en)
 		value |= DMA_CONTROL_SPH;
 	else
 		value &= ~DMA_CONTROL_SPH;
-	writel(value, ioaddr + DMA_CHAN_CONTROL(chan));
+	writel(value, ioaddr + DMA_CHAN_CONTROL(dwmac4_addrs, chan));
 }
 
 static int dwmac4_enable_tbs(struct stmmac_priv *priv, void __iomem *ioaddr,
 			     bool en, u32 chan)
 {
-	u32 value = readl(ioaddr + DMA_CHAN_TX_CONTROL(chan));
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
+	u32 value = readl(ioaddr + DMA_CHAN_TX_CONTROL(dwmac4_addrs, chan));
 
 	if (en)
 		value |= DMA_CONTROL_EDSE;
 	else
 		value &= ~DMA_CONTROL_EDSE;
 
-	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(chan));
+	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(dwmac4_addrs, chan));
 
-	value = readl(ioaddr + DMA_CHAN_TX_CONTROL(chan)) & DMA_CONTROL_EDSE;
+	value = readl(ioaddr + DMA_CHAN_TX_CONTROL(dwmac4_addrs,
+						   chan)) & DMA_CONTROL_EDSE;
 	if (en && !value)
 		return -EIO;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
index 740c3bc8d9a0..85efac83f0ca 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
@@ -95,29 +95,38 @@
 /* Following DMA defines are chanels oriented */
 #define DMA_CHAN_BASE_ADDR		0x00001100
 #define DMA_CHAN_BASE_OFFSET		0x80
-#define DMA_CHANX_BASE_ADDR(x)		(DMA_CHAN_BASE_ADDR + \
-					(x * DMA_CHAN_BASE_OFFSET))
+#define DMA_CHANX_BASE_ADDR(addrs, x)  \
+({ \
+	const struct dwmac4_addrs *__addrs = addrs; \
+	const u32 __x = x; \
+	u32 __addr; \
+	if (__addrs) \
+		__addr = __addrs->dma_chan + (__x * __addrs->dma_chan_offset); \
+	else \
+		__addr = DMA_CHAN_BASE_ADDR + (__x * DMA_CHAN_BASE_OFFSET); \
+	__addr; \
+})
 #define DMA_CHAN_REG_NUMBER		17
 
-#define DMA_CHAN_CONTROL(x)		DMA_CHANX_BASE_ADDR(x)
-#define DMA_CHAN_TX_CONTROL(x)		(DMA_CHANX_BASE_ADDR(x) + 0x4)
-#define DMA_CHAN_RX_CONTROL(x)		(DMA_CHANX_BASE_ADDR(x) + 0x8)
-#define DMA_CHAN_TX_BASE_ADDR_HI(x)	(DMA_CHANX_BASE_ADDR(x) + 0x10)
-#define DMA_CHAN_TX_BASE_ADDR(x)	(DMA_CHANX_BASE_ADDR(x) + 0x14)
-#define DMA_CHAN_RX_BASE_ADDR_HI(x)	(DMA_CHANX_BASE_ADDR(x) + 0x18)
-#define DMA_CHAN_RX_BASE_ADDR(x)	(DMA_CHANX_BASE_ADDR(x) + 0x1c)
-#define DMA_CHAN_TX_END_ADDR(x)		(DMA_CHANX_BASE_ADDR(x) + 0x20)
-#define DMA_CHAN_RX_END_ADDR(x)		(DMA_CHANX_BASE_ADDR(x) + 0x28)
-#define DMA_CHAN_TX_RING_LEN(x)		(DMA_CHANX_BASE_ADDR(x) + 0x2c)
-#define DMA_CHAN_RX_RING_LEN(x)		(DMA_CHANX_BASE_ADDR(x) + 0x30)
-#define DMA_CHAN_INTR_ENA(x)		(DMA_CHANX_BASE_ADDR(x) + 0x34)
-#define DMA_CHAN_RX_WATCHDOG(x)		(DMA_CHANX_BASE_ADDR(x) + 0x38)
-#define DMA_CHAN_SLOT_CTRL_STATUS(x)	(DMA_CHANX_BASE_ADDR(x) + 0x3c)
-#define DMA_CHAN_CUR_TX_DESC(x)		(DMA_CHANX_BASE_ADDR(x) + 0x44)
-#define DMA_CHAN_CUR_RX_DESC(x)		(DMA_CHANX_BASE_ADDR(x) + 0x4c)
-#define DMA_CHAN_CUR_TX_BUF_ADDR(x)	(DMA_CHANX_BASE_ADDR(x) + 0x54)
-#define DMA_CHAN_CUR_RX_BUF_ADDR(x)	(DMA_CHANX_BASE_ADDR(x) + 0x5c)
-#define DMA_CHAN_STATUS(x)		(DMA_CHANX_BASE_ADDR(x) + 0x60)
+#define DMA_CHAN_CONTROL(addrs, x)	DMA_CHANX_BASE_ADDR(addrs, x)
+#define DMA_CHAN_TX_CONTROL(addrs, x)	(DMA_CHANX_BASE_ADDR(addrs, x) + 0x4)
+#define DMA_CHAN_RX_CONTROL(addrs, x)	(DMA_CHANX_BASE_ADDR(addrs, x) + 0x8)
+#define DMA_CHAN_TX_BASE_ADDR_HI(addrs, x)	(DMA_CHANX_BASE_ADDR(addrs, x) + 0x10)
+#define DMA_CHAN_TX_BASE_ADDR(addrs, x)	(DMA_CHANX_BASE_ADDR(addrs, x) + 0x14)
+#define DMA_CHAN_RX_BASE_ADDR_HI(addrs, x)	(DMA_CHANX_BASE_ADDR(addrs, x) + 0x18)
+#define DMA_CHAN_RX_BASE_ADDR(addrs, x)	(DMA_CHANX_BASE_ADDR(addrs, x) + 0x1c)
+#define DMA_CHAN_TX_END_ADDR(addrs, x)	(DMA_CHANX_BASE_ADDR(addrs, x) + 0x20)
+#define DMA_CHAN_RX_END_ADDR(addrs, x)	(DMA_CHANX_BASE_ADDR(addrs, x) + 0x28)
+#define DMA_CHAN_TX_RING_LEN(addrs, x)	(DMA_CHANX_BASE_ADDR(addrs, x) + 0x2c)
+#define DMA_CHAN_RX_RING_LEN(addrs, x)	(DMA_CHANX_BASE_ADDR(addrs, x) + 0x30)
+#define DMA_CHAN_INTR_ENA(addrs, x)	(DMA_CHANX_BASE_ADDR(addrs, x) + 0x34)
+#define DMA_CHAN_RX_WATCHDOG(addrs, x)	(DMA_CHANX_BASE_ADDR(addrs, x) + 0x38)
+#define DMA_CHAN_SLOT_CTRL_STATUS(addrs, x)	(DMA_CHANX_BASE_ADDR(addrs, x) + 0x3c)
+#define DMA_CHAN_CUR_TX_DESC(addrs, x)	(DMA_CHANX_BASE_ADDR(addrs, x) + 0x44)
+#define DMA_CHAN_CUR_RX_DESC(addrs, x)	(DMA_CHANX_BASE_ADDR(addrs, x) + 0x4c)
+#define DMA_CHAN_CUR_TX_BUF_ADDR(addrs, x)	(DMA_CHANX_BASE_ADDR(addrs, x) + 0x54)
+#define DMA_CHAN_CUR_RX_BUF_ADDR(addrs, x)	(DMA_CHANX_BASE_ADDR(addrs, x) + 0x5c)
+#define DMA_CHAN_STATUS(addrs, x)	(DMA_CHANX_BASE_ADDR(addrs, x) + 0x60)
 
 /* DMA Control X */
 #define DMA_CONTROL_SPH			BIT(24)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
index 5e9c495aa03e..df41eac54058 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
@@ -11,6 +11,7 @@
 #include "common.h"
 #include "dwmac4_dma.h"
 #include "dwmac4.h"
+#include "stmmac.h"
 
 int dwmac4_dma_reset(void __iomem *ioaddr)
 {
@@ -28,22 +29,27 @@ int dwmac4_dma_reset(void __iomem *ioaddr)
 void dwmac4_set_rx_tail_ptr(struct stmmac_priv *priv, void __iomem *ioaddr,
 			    u32 tail_ptr, u32 chan)
 {
-	writel(tail_ptr, ioaddr + DMA_CHAN_RX_END_ADDR(chan));
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
+
+	writel(tail_ptr, ioaddr + DMA_CHAN_RX_END_ADDR(dwmac4_addrs, chan));
 }
 
 void dwmac4_set_tx_tail_ptr(struct stmmac_priv *priv, void __iomem *ioaddr,
 			    u32 tail_ptr, u32 chan)
 {
-	writel(tail_ptr, ioaddr + DMA_CHAN_TX_END_ADDR(chan));
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
+
+	writel(tail_ptr, ioaddr + DMA_CHAN_TX_END_ADDR(dwmac4_addrs, chan));
 }
 
 void dwmac4_dma_start_tx(struct stmmac_priv *priv, void __iomem *ioaddr,
 			 u32 chan)
 {
-	u32 value = readl(ioaddr + DMA_CHAN_TX_CONTROL(chan));
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
+	u32 value = readl(ioaddr + DMA_CHAN_TX_CONTROL(dwmac4_addrs, chan));
 
 	value |= DMA_CONTROL_ST;
-	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(chan));
+	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(dwmac4_addrs, chan));
 
 	value = readl(ioaddr + GMAC_CONFIG);
 	value |= GMAC_CONFIG_TE;
@@ -53,20 +59,24 @@ void dwmac4_dma_start_tx(struct stmmac_priv *priv, void __iomem *ioaddr,
 void dwmac4_dma_stop_tx(struct stmmac_priv *priv, void __iomem *ioaddr,
 			u32 chan)
 {
-	u32 value = readl(ioaddr + DMA_CHAN_TX_CONTROL(chan));
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
+
+	u32 value = readl(ioaddr + DMA_CHAN_TX_CONTROL(dwmac4_addrs, chan));
 
 	value &= ~DMA_CONTROL_ST;
-	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(chan));
+	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(dwmac4_addrs, chan));
 }
 
 void dwmac4_dma_start_rx(struct stmmac_priv *priv, void __iomem *ioaddr,
 			 u32 chan)
 {
-	u32 value = readl(ioaddr + DMA_CHAN_RX_CONTROL(chan));
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
+
+	u32 value = readl(ioaddr + DMA_CHAN_RX_CONTROL(dwmac4_addrs, chan));
 
 	value |= DMA_CONTROL_SR;
 
-	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(chan));
+	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(dwmac4_addrs, chan));
 
 	value = readl(ioaddr + GMAC_CONFIG);
 	value |= GMAC_CONFIG_RE;
@@ -76,81 +86,91 @@ void dwmac4_dma_start_rx(struct stmmac_priv *priv, void __iomem *ioaddr,
 void dwmac4_dma_stop_rx(struct stmmac_priv *priv, void __iomem *ioaddr,
 			u32 chan)
 {
-	u32 value = readl(ioaddr + DMA_CHAN_RX_CONTROL(chan));
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
+	u32 value = readl(ioaddr + DMA_CHAN_RX_CONTROL(dwmac4_addrs, chan));
 
 	value &= ~DMA_CONTROL_SR;
-	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(chan));
+	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(dwmac4_addrs, chan));
 }
 
 void dwmac4_set_tx_ring_len(struct stmmac_priv *priv, void __iomem *ioaddr,
 			    u32 len, u32 chan)
 {
-	writel(len, ioaddr + DMA_CHAN_TX_RING_LEN(chan));
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
+
+	writel(len, ioaddr + DMA_CHAN_TX_RING_LEN(dwmac4_addrs, chan));
 }
 
 void dwmac4_set_rx_ring_len(struct stmmac_priv *priv, void __iomem *ioaddr,
 			    u32 len, u32 chan)
 {
-	writel(len, ioaddr + DMA_CHAN_RX_RING_LEN(chan));
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
+
+	writel(len, ioaddr + DMA_CHAN_RX_RING_LEN(dwmac4_addrs, chan));
 }
 
 void dwmac4_enable_dma_irq(struct stmmac_priv *priv, void __iomem *ioaddr,
 			   u32 chan, bool rx, bool tx)
 {
-	u32 value = readl(ioaddr + DMA_CHAN_INTR_ENA(chan));
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
+	u32 value = readl(ioaddr + DMA_CHAN_INTR_ENA(dwmac4_addrs, chan));
 
 	if (rx)
 		value |= DMA_CHAN_INTR_DEFAULT_RX;
 	if (tx)
 		value |= DMA_CHAN_INTR_DEFAULT_TX;
 
-	writel(value, ioaddr + DMA_CHAN_INTR_ENA(chan));
+	writel(value, ioaddr + DMA_CHAN_INTR_ENA(dwmac4_addrs, chan));
 }
 
 void dwmac410_enable_dma_irq(struct stmmac_priv *priv, void __iomem *ioaddr,
 			     u32 chan, bool rx, bool tx)
 {
-	u32 value = readl(ioaddr + DMA_CHAN_INTR_ENA(chan));
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
+	u32 value = readl(ioaddr + DMA_CHAN_INTR_ENA(dwmac4_addrs, chan));
 
 	if (rx)
 		value |= DMA_CHAN_INTR_DEFAULT_RX_4_10;
 	if (tx)
 		value |= DMA_CHAN_INTR_DEFAULT_TX_4_10;
 
-	writel(value, ioaddr + DMA_CHAN_INTR_ENA(chan));
+	writel(value, ioaddr + DMA_CHAN_INTR_ENA(dwmac4_addrs, chan));
 }
 
 void dwmac4_disable_dma_irq(struct stmmac_priv *priv, void __iomem *ioaddr,
 			    u32 chan, bool rx, bool tx)
 {
-	u32 value = readl(ioaddr + DMA_CHAN_INTR_ENA(chan));
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
+	u32 value = readl(ioaddr + DMA_CHAN_INTR_ENA(dwmac4_addrs, chan));
 
 	if (rx)
 		value &= ~DMA_CHAN_INTR_DEFAULT_RX;
 	if (tx)
 		value &= ~DMA_CHAN_INTR_DEFAULT_TX;
 
-	writel(value, ioaddr + DMA_CHAN_INTR_ENA(chan));
+	writel(value, ioaddr + DMA_CHAN_INTR_ENA(dwmac4_addrs, chan));
 }
 
 void dwmac410_disable_dma_irq(struct stmmac_priv *priv, void __iomem *ioaddr,
 			      u32 chan, bool rx, bool tx)
 {
-	u32 value = readl(ioaddr + DMA_CHAN_INTR_ENA(chan));
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
+	u32 value = readl(ioaddr + DMA_CHAN_INTR_ENA(dwmac4_addrs, chan));
 
 	if (rx)
 		value &= ~DMA_CHAN_INTR_DEFAULT_RX_4_10;
 	if (tx)
 		value &= ~DMA_CHAN_INTR_DEFAULT_TX_4_10;
 
-	writel(value, ioaddr + DMA_CHAN_INTR_ENA(chan));
+	writel(value, ioaddr + DMA_CHAN_INTR_ENA(dwmac4_addrs, chan));
 }
 
 int dwmac4_dma_interrupt(struct stmmac_priv *priv, void __iomem *ioaddr,
 			 struct stmmac_extra_stats *x, u32 chan, u32 dir)
 {
-	u32 intr_status = readl(ioaddr + DMA_CHAN_STATUS(chan));
-	u32 intr_en = readl(ioaddr + DMA_CHAN_INTR_ENA(chan));
+	const struct dwmac4_addrs *dwmac4_addrs = priv->plat->dwmac4_addrs;
+	u32 intr_status = readl(ioaddr + DMA_CHAN_STATUS(dwmac4_addrs, chan));
+	u32 intr_en = readl(ioaddr + DMA_CHAN_INTR_ENA(dwmac4_addrs, chan));
 	int ret = 0;
 
 	if (dir == DMA_DIR_RX)
@@ -195,7 +215,8 @@ int dwmac4_dma_interrupt(struct stmmac_priv *priv, void __iomem *ioaddr,
 	if (unlikely(intr_status & DMA_CHAN_STATUS_ERI))
 		x->rx_early_irq++;
 
-	writel(intr_status & intr_en, ioaddr + DMA_CHAN_STATUS(chan));
+	writel(intr_status & intr_en,
+	       ioaddr + DMA_CHAN_STATUS(dwmac4_addrs, chan));
 	return ret;
 }
 
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index a2414c187483..32cfa5d415f9 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -186,6 +186,24 @@ struct stmmac_safety_feature_cfg {
 	u32 tmouten;
 };
 
+/* Addresses that may be customized by a platform */
+struct dwmac4_addrs {
+	u32 dma_chan;
+	u32 dma_chan_offset;
+	u32 mtl_chan;
+	u32 mtl_chan_offset;
+	u32 mtl_ets_ctrl;
+	u32 mtl_ets_ctrl_offset;
+	u32 mtl_txq_weight;
+	u32 mtl_txq_weight_offset;
+	u32 mtl_send_slp_cred;
+	u32 mtl_send_slp_cred_offset;
+	u32 mtl_high_cred;
+	u32 mtl_high_cred_offset;
+	u32 mtl_low_cred;
+	u32 mtl_low_cred_offset;
+};
+
 struct plat_stmmacenet_data {
 	int bus_id;
 	int phy_addr;
@@ -273,5 +291,6 @@ struct plat_stmmacenet_data {
 	bool use_phy_wol;
 	bool sph_disable;
 	bool serdes_up_after_phy_linkup;
+	const struct dwmac4_addrs *dwmac4_addrs;
 };
 #endif
-- 
2.39.2

