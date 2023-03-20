Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F55F6C24A6
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 23:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjCTWTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 18:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjCTWSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 18:18:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F655227A7
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 15:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679350634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zXHGaC/fnF0XPtoD7LwrCFO+J1UwzR1criyrXGcqJ9I=;
        b=iRZLNHh58tyr63bIATLf9dy7n0LopRUBcW+TqFxm85qPVW2/oXSIwiIc4i6ErUdco6Xklx
        hsvbuMrdh6KCBPYgYhcLVy6IDQgoJQeOf7dEapdvu4nGeen5cokA21kDILEuBPoox/QfSe
        Foe+CIPwP5LMDgmwT1lNJj/IY9aS5xM=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-3VoWc-zjNFOUp9UjI7y4CA-1; Mon, 20 Mar 2023 18:17:10 -0400
X-MC-Unique: 3VoWc-zjNFOUp9UjI7y4CA-1
Received: by mail-oi1-f200.google.com with SMTP id bg21-20020a056808179500b003869b702d75so5713436oib.17
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 15:17:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679350630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zXHGaC/fnF0XPtoD7LwrCFO+J1UwzR1criyrXGcqJ9I=;
        b=tEV1v5jKh2RvKcC35JGxTfBSGcKM83vJdAIQC32Z4T5eHM8OvmBw1GfuvPV3eWajSq
         E1L0TnXo7//HhWlkO0xtu+mY50odjoTgyJ5mSJHCct2YthKsEbkMRmbpNmCldJLGRDoI
         VLPTtqNGncITN2/E6rpxjATJn4hqr0S84cVH+i+jMyLhK/7xkZqSJITeXVfwLcR0mN0+
         evTpJsj1WiopAlQ6ovRJKZ/zwVZVKhuEP7O0pJ9nNhDVjeLz2H3fE7ODkhOLbuPpbxWg
         XShQPfb8tmO+UGBtY9fSC2SsnNfVXD9qY5vCjmn67CATZkQnr08LXgBi460e5VN6pYhd
         wEpA==
X-Gm-Message-State: AO0yUKU6iECs6pShtheIX2ufZldAdZ0C3Ft4JUgX/sNaq1sAV0VID/tf
        kO3U4Oh6km1XldYyAa7ZHaHqytcLAc2kzZfOP9k1wOd4dWgGMzStfiVcgM24k9LkIdwny+N01oB
        e/E69kBSsgvy71LZF
X-Received: by 2002:a4a:55cc:0:b0:520:331d:9514 with SMTP id e195-20020a4a55cc000000b00520331d9514mr741028oob.1.1679350629304;
        Mon, 20 Mar 2023 15:17:09 -0700 (PDT)
X-Google-Smtp-Source: AK7set+vAeV4TMZX28YS/QSy2Bwh49fwLySaPACq+7f7NeJnWdUmAZWJpVm6VzBGpy8EC9CswMyuXg==
X-Received: by 2002:a4a:55cc:0:b0:520:331d:9514 with SMTP id e195-20020a4a55cc000000b00520331d9514mr741014oob.1.1679350628719;
        Mon, 20 Mar 2023 15:17:08 -0700 (PDT)
Received: from halaney-x13s.redhat.com (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id q204-20020a4a33d5000000b0053853156b5csm4092465ooq.8.2023.03.20.15.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 15:17:08 -0700 (PDT)
From:   Andrew Halaney <ahalaney@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, mturquette@baylibre.com,
        sboyd@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com,
        linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com,
        Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH net-next v2 09/12] net: stmmac: Add EMAC3 variant of dwmac4
Date:   Mon, 20 Mar 2023 17:16:14 -0500
Message-Id: <20230320221617.236323-10-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320221617.236323-1-ahalaney@redhat.com>
References: <20230320221617.236323-1-ahalaney@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brian Masney <bmasney@redhat.com>

EMAC3 is a Qualcomm variant of dwmac4 that functions the same, but has a
different address space layout for MTL and DMA registers. This makes the
patch a bit more complicated than we would like so let's explain why the
current approach was used.

The different address ranges between the two variants can be represented
with 7 different sets of #ifdefs like the following:

    #if IS_ENABLED(CONFIG_DWMAC_QCOM_VER3)
    # define MTL_CHAN_BASE_ADDR             0x00008000
    # define MTL_CHAN_BASE_OFFSET           0x1000
    #else
    # define MTL_CHAN_BASE_ADDR             0x00000d00
    # define MTL_CHAN_BASE_OFFSET           0x40
    #endif

This won't be acceptable for upstream inclusion since it would be nice
to enable both variants simultaneously without recompiling.

The next approach that was checked was to have a function pointer
embedded inside a structure that does the appropriate conversion based
on the variant that's in use. However, some of the function definitions
are like the following:

    void emac3_set_rx_ring_len(void __iomem *ioaddr, u32 len, u32 chan)

We can't do a container_of() with an __iomem address. Changing these
functions to pass in an extra regular structure had a cascading effect
across the different variants, and the change was quickly becoming
large. It would also be hard to test and review.

So the approach that was decided to go with here is to take the existing
dwmac4_XXX callbacks, rename it to do_XXX, and do the following:

    static void do_XXX(..., int addr_offset)
    {
       // Code from existing dwmac4 implementation.
    }

    static inline void emac3_XXX(...)
    {
        do_XXX(..., EMAC3_ADDR_OFFSET(...));
    }

    static inline void dwmac4_XXX(...)
    {
        do_XXX(..., DWMAC4_ADDR_OFFSET(...));
    }

Prior to the introduction of this patch, dwmac4_dma_init_channel() and
dwmac410_dma_init_channel() already had the problem of copy and paste
with trivial changes made.

While changes are being made here, this patch also fixes a bad comment
that was in dwmac4_config_cbs (s/high/low).

Signed-off-by: Brian Masney <bmasney@redhat.com>
Co-developed-by: Andrew Halaney <ahalaney@redhat.com>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---

Changes since v1:
	* Clean up if statement bracket in its own (prior) patch (Andrew Lunn)
	* Remove unnecessary static inlines (Jakub)
	* Don't exceed 6 function arguments (use a struct instead) (Jakub)

I think despite Russell's comments Jakub's insights on readability with
respect to function arguments / structure usage / poor man's **kwargs
are still valid for this particular context. Hopefully this is a bit more
appealing looking. There was only one function that needed this,
do_config_cbs, otherwise they were all at <= 6 function args.

 drivers/net/ethernet/stmicro/stmmac/dwmac4.h  |  32 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c | 235 ++++++++++--
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  | 334 ++++++++++++++----
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.h  |  38 ++
 .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  | 144 ++++++--
 drivers/net/ethernet/stmicro/stmmac/hwif.c    |  29 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |   2 +
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |   6 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  17 +-
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |   8 +-
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  |   4 +-
 include/linux/stmmac.h                        |   1 +
 12 files changed, 707 insertions(+), 143 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index ccd49346d3b3..56355d65fa4b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -333,7 +333,16 @@ enum power_event {
 #define MTL_RXQ_DMA_MAP1		0x00000c34 /* queue 4 to 7 */
 #define MTL_RXQ_DMA_QXMDMACH_MASK(x)	(0xf << 8 * (x))
 #define MTL_RXQ_DMA_QXMDMACH(chan, q)	((chan) << (8 * (q)))
-
+#define EMAC3_MTL_CHAN_BASE_ADDR		0x00008000
+#define EMAC3_MTL_CHAN_BASE_OFFSET		0x1000
+#define EMAC3_MTL_CHANX_BASE_ADDR(x)		(EMAC3_MTL_CHAN_BASE_ADDR + \
+					((x) * EMAC3_MTL_CHAN_BASE_OFFSET))
+
+#define EMAC3_MTL_CHAN_TX_OP_MODE(x)		EMAC3_MTL_CHANX_BASE_ADDR(x)
+#define EMAC3_MTL_CHAN_TX_DEBUG(x)		(EMAC3_MTL_CHANX_BASE_ADDR(x) + 0x8)
+#define EMAC3_MTL_CHAN_INT_CTRL(x)		(EMAC3_MTL_CHANX_BASE_ADDR(x) + 0x2c)
+#define EMAC3_MTL_CHAN_RX_OP_MODE(x)		(EMAC3_MTL_CHANX_BASE_ADDR(x) + 0x30)
+#define EMAC3_MTL_CHAN_RX_DEBUG(x)		(EMAC3_MTL_CHANX_BASE_ADDR(x) + 0x38)
 #define MTL_CHAN_BASE_ADDR		0x00000d00
 #define MTL_CHAN_BASE_OFFSET		0x40
 #define MTL_CHANX_BASE_ADDR(x)		(MTL_CHAN_BASE_ADDR + \
@@ -386,6 +395,10 @@ enum power_event {
 #define MTL_OP_MODE_RTC_128		(3 << MTL_OP_MODE_RTC_SHIFT)
 
 /* MTL ETS Control register */
+#define EMAC3_MTL_ETS_CTRL_BASE_ADDR		0x00008010
+#define EMAC3_MTL_ETS_CTRL_BASE_OFFSET	0x1000
+#define EMAC3_MTL_ETSX_CTRL_BASE_ADDR(x)	(EMAC3_MTL_ETS_CTRL_BASE_ADDR + \
+					((x) * EMAC3_MTL_ETS_CTRL_BASE_OFFSET))
 #define MTL_ETS_CTRL_BASE_ADDR		0x00000d10
 #define MTL_ETS_CTRL_BASE_OFFSET	0x40
 #define MTL_ETSX_CTRL_BASE_ADDR(x)	(MTL_ETS_CTRL_BASE_ADDR + \
@@ -395,6 +408,10 @@ enum power_event {
 #define MTL_ETS_CTRL_AVALG		BIT(2)
 
 /* MTL Queue Quantum Weight */
+#define EMAC3_MTL_TXQ_WEIGHT_BASE_ADDR	0x00008018
+#define EMAC3_MTL_TXQ_WEIGHT_BASE_OFFSET	0x1000
+#define EMAC3_MTL_TXQX_WEIGHT_BASE_ADDR(x)	(EMAC3_MTL_TXQ_WEIGHT_BASE_ADDR + \
+					((x) * EMAC3_MTL_TXQ_WEIGHT_BASE_OFFSET))
 #define MTL_TXQ_WEIGHT_BASE_ADDR	0x00000d18
 #define MTL_TXQ_WEIGHT_BASE_OFFSET	0x40
 #define MTL_TXQX_WEIGHT_BASE_ADDR(x)	(MTL_TXQ_WEIGHT_BASE_ADDR + \
@@ -402,6 +419,11 @@ enum power_event {
 #define MTL_TXQ_WEIGHT_ISCQW_MASK	GENMASK(20, 0)
 
 /* MTL sendSlopeCredit register */
+
+#define EMAC3_MTL_SEND_SLP_CRED_BASE_ADDR	0x0000801c
+#define EMAC3_MTL_SEND_SLP_CRED_OFFSET	0x1000
+#define EMAC3_MTL_SEND_SLP_CREDX_BASE_ADDR(x)	(EMAC3_MTL_SEND_SLP_CRED_BASE_ADDR + \
+					((x) * EMAC3_MTL_SEND_SLP_CRED_OFFSET))
 #define MTL_SEND_SLP_CRED_BASE_ADDR	0x00000d1c
 #define MTL_SEND_SLP_CRED_OFFSET	0x40
 #define MTL_SEND_SLP_CREDX_BASE_ADDR(x)	(MTL_SEND_SLP_CRED_BASE_ADDR + \
@@ -410,6 +432,10 @@ enum power_event {
 #define MTL_SEND_SLP_CRED_SSC_MASK	GENMASK(13, 0)
 
 /* MTL hiCredit register */
+#define EMAC3_MTL_HIGH_CRED_BASE_ADDR		0x00008020
+#define EMAC3_MTL_HIGH_CRED_OFFSET		0x1000
+#define EMAC3_MTL_HIGH_CREDX_BASE_ADDR(x)	(EMAC3_MTL_HIGH_CRED_BASE_ADDR + \
+					((x) * EMAC3_MTL_HIGH_CRED_OFFSET))
 #define MTL_HIGH_CRED_BASE_ADDR		0x00000d20
 #define MTL_HIGH_CRED_OFFSET		0x40
 #define MTL_HIGH_CREDX_BASE_ADDR(x)	(MTL_HIGH_CRED_BASE_ADDR + \
@@ -418,6 +444,10 @@ enum power_event {
 #define MTL_HIGH_CRED_HC_MASK		GENMASK(28, 0)
 
 /* MTL loCredit register */
+#define EMAC3_MTL_LOW_CRED_BASE_ADDR		0x00008024
+#define EMAC3_MTL_LOW_CRED_OFFSET		0x1000
+#define EMAC3_MTL_LOW_CREDX_BASE_ADDR(x)	(EMAC3_MTL_LOW_CRED_BASE_ADDR + \
+					((x) * EMAC3_MTL_LOW_CRED_OFFSET))
 #define MTL_LOW_CRED_BASE_ADDR		0x00000d24
 #define MTL_LOW_CRED_OFFSET		0x40
 #define MTL_LOW_CREDX_BASE_ADDR(x)	(MTL_LOW_CRED_BASE_ADDR + \
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 8c7a0b7c9952..83240f51506b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -198,15 +198,28 @@ static void dwmac4_prog_mtl_tx_algorithms(struct mac_device_info *hw,
 	writel(value, ioaddr + MTL_OPERATION_MODE);
 }
 
-static void dwmac4_set_mtl_tx_queue_weight(struct mac_device_info *hw,
-					   u32 weight, u32 queue)
+static void do_set_mtl_tx_queue_weight(struct mac_device_info *hw,
+				       u32 addr_offset, u32 weight)
 {
 	void __iomem *ioaddr = hw->pcsr;
-	u32 value = readl(ioaddr + MTL_TXQX_WEIGHT_BASE_ADDR(queue));
+	u32 value = readl(ioaddr + addr_offset);
 
 	value &= ~MTL_TXQ_WEIGHT_ISCQW_MASK;
 	value |= weight & MTL_TXQ_WEIGHT_ISCQW_MASK;
-	writel(value, ioaddr + MTL_TXQX_WEIGHT_BASE_ADDR(queue));
+	writel(value, ioaddr + addr_offset);
+}
+
+static void emac3_set_mtl_tx_queue_weight(struct mac_device_info *hw,
+					  u32 weight, u32 queue)
+{
+	do_set_mtl_tx_queue_weight(hw, EMAC3_MTL_TXQX_WEIGHT_BASE_ADDR(queue),
+				   weight);
+}
+
+static void dwmac4_set_mtl_tx_queue_weight(struct mac_device_info *hw,
+					   u32 weight, u32 queue)
+{
+	do_set_mtl_tx_queue_weight(hw, MTL_TXQX_WEIGHT_BASE_ADDR(queue), weight);
 }
 
 static void dwmac4_map_mtl_dma(struct mac_device_info *hw, u32 queue, u32 chan)
@@ -227,45 +240,100 @@ static void dwmac4_map_mtl_dma(struct mac_device_info *hw, u32 queue, u32 chan)
 	}
 }
 
-static void dwmac4_config_cbs(struct mac_device_info *hw,
-			      u32 send_slope, u32 idle_slope,
-			      u32 high_credit, u32 low_credit, u32 queue)
+struct cbs_args {
+	struct mac_device_info *hw;
+	u32 send_slope;
+	u32 idle_slope;
+	u32 high_credit;
+	u32 low_credit;
+	u32 queue;
+	u32 etsx_ctrl_base_addr;
+	u32 send_slp_credx_base_addr;
+	u32 high_credx_base_addr;
+	u32 low_credx_base_addr;
+	void (*set_mtl_tx_queue_weight)(struct mac_device_info *hw,
+					u32 weight, u32 queue);
+};
+
+static void do_config_cbs(struct cbs_args args)
 {
-	void __iomem *ioaddr = hw->pcsr;
+	void __iomem *ioaddr = args.hw->pcsr;
 	u32 value;
 
-	pr_debug("Queue %d configured as AVB. Parameters:\n", queue);
-	pr_debug("\tsend_slope: 0x%08x\n", send_slope);
-	pr_debug("\tidle_slope: 0x%08x\n", idle_slope);
-	pr_debug("\thigh_credit: 0x%08x\n", high_credit);
-	pr_debug("\tlow_credit: 0x%08x\n", low_credit);
+	pr_debug("Queue %d configured as AVB. Parameters:\n", args.queue);
+	pr_debug("\tsend_slope: 0x%08x\n", args.send_slope);
+	pr_debug("\tidle_slope: 0x%08x\n", args.idle_slope);
+	pr_debug("\thigh_credit: 0x%08x\n", args.high_credit);
+	pr_debug("\tlow_credit: 0x%08x\n", args.low_credit);
 
 	/* enable AV algorithm */
-	value = readl(ioaddr + MTL_ETSX_CTRL_BASE_ADDR(queue));
+	value = readl(ioaddr + args.etsx_ctrl_base_addr);
 	value |= MTL_ETS_CTRL_AVALG;
 	value |= MTL_ETS_CTRL_CC;
-	writel(value, ioaddr + MTL_ETSX_CTRL_BASE_ADDR(queue));
+	writel(value, ioaddr + args.etsx_ctrl_base_addr);
 
 	/* configure send slope */
-	value = readl(ioaddr + MTL_SEND_SLP_CREDX_BASE_ADDR(queue));
+	value = readl(ioaddr + args.send_slp_credx_base_addr);
 	value &= ~MTL_SEND_SLP_CRED_SSC_MASK;
-	value |= send_slope & MTL_SEND_SLP_CRED_SSC_MASK;
-	writel(value, ioaddr + MTL_SEND_SLP_CREDX_BASE_ADDR(queue));
+	value |= args.send_slope & MTL_SEND_SLP_CRED_SSC_MASK;
+	writel(value, ioaddr + args.send_slp_credx_base_addr);
 
 	/* configure idle slope (same register as tx weight) */
-	dwmac4_set_mtl_tx_queue_weight(hw, idle_slope, queue);
+	args.set_mtl_tx_queue_weight(args.hw, args.idle_slope, args.queue);
 
 	/* configure high credit */
-	value = readl(ioaddr + MTL_HIGH_CREDX_BASE_ADDR(queue));
+	value = readl(ioaddr + args.high_credx_base_addr);
 	value &= ~MTL_HIGH_CRED_HC_MASK;
-	value |= high_credit & MTL_HIGH_CRED_HC_MASK;
-	writel(value, ioaddr + MTL_HIGH_CREDX_BASE_ADDR(queue));
+	value |= args.high_credit & MTL_HIGH_CRED_HC_MASK;
+	writel(value, ioaddr + args.high_credx_base_addr);
 
-	/* configure high credit */
-	value = readl(ioaddr + MTL_LOW_CREDX_BASE_ADDR(queue));
+	/* configure low credit */
+	value = readl(ioaddr + args.low_credx_base_addr);
 	value &= ~MTL_HIGH_CRED_LC_MASK;
-	value |= low_credit & MTL_HIGH_CRED_LC_MASK;
-	writel(value, ioaddr + MTL_LOW_CREDX_BASE_ADDR(queue));
+	value |= args.low_credit & MTL_HIGH_CRED_LC_MASK;
+	writel(value, ioaddr + args.low_credx_base_addr);
+}
+
+static void emac3_config_cbs(struct mac_device_info *hw, u32 send_slope,
+			     u32 idle_slope, u32 high_credit,
+			     u32 low_credit, u32 queue)
+{
+	struct cbs_args args = {
+		.hw = hw,
+		.send_slope = send_slope,
+		.idle_slope = idle_slope,
+		.high_credit = high_credit,
+		.low_credit = low_credit,
+		.queue = queue,
+		.etsx_ctrl_base_addr =  EMAC3_MTL_ETSX_CTRL_BASE_ADDR(queue),
+		.send_slp_credx_base_addr = EMAC3_MTL_SEND_SLP_CREDX_BASE_ADDR(queue),
+		.high_credx_base_addr = EMAC3_MTL_HIGH_CREDX_BASE_ADDR(queue),
+		.low_credx_base_addr = EMAC3_MTL_LOW_CREDX_BASE_ADDR(queue),
+		.set_mtl_tx_queue_weight = emac3_set_mtl_tx_queue_weight,
+	};
+
+	do_config_cbs(args);
+}
+
+static void dwmac4_config_cbs(struct mac_device_info *hw, u32 send_slope,
+			      u32 idle_slope, u32 high_credit,
+			      u32 low_credit, u32 queue)
+{
+	struct cbs_args args = {
+		.hw = hw,
+		.send_slope = send_slope,
+		.idle_slope = idle_slope,
+		.high_credit = high_credit,
+		.low_credit = low_credit,
+		.queue = queue,
+		.etsx_ctrl_base_addr =  MTL_ETSX_CTRL_BASE_ADDR(queue),
+		.send_slp_credx_base_addr = MTL_SEND_SLP_CREDX_BASE_ADDR(queue),
+		.high_credx_base_addr = MTL_HIGH_CREDX_BASE_ADDR(queue),
+		.low_credx_base_addr = MTL_LOW_CREDX_BASE_ADDR(queue),
+		.set_mtl_tx_queue_weight = dwmac4_set_mtl_tx_queue_weight,
+	};
+
+	do_config_cbs(args);
 }
 
 static void dwmac4_dump_regs(struct mac_device_info *hw, u32 *reg_space)
@@ -814,7 +882,8 @@ static void dwmac4_phystatus(void __iomem *ioaddr, struct stmmac_extra_stats *x)
 	}
 }
 
-static int dwmac4_irq_mtl_status(struct mac_device_info *hw, u32 chan)
+static int do_irq_mtl_status(struct mac_device_info *hw, u32 chan,
+			     u32 addr_offset)
 {
 	void __iomem *ioaddr = hw->pcsr;
 	u32 mtl_int_qx_status;
@@ -825,12 +894,12 @@ static int dwmac4_irq_mtl_status(struct mac_device_info *hw, u32 chan)
 	/* Check MTL Interrupt */
 	if (mtl_int_qx_status & MTL_INT_QX(chan)) {
 		/* read Queue x Interrupt status */
-		u32 status = readl(ioaddr + MTL_CHAN_INT_CTRL(chan));
+		u32 status = readl(ioaddr + addr_offset);
 
 		if (status & MTL_RX_OVERFLOW_INT) {
 			/*  clear Interrupt */
 			writel(status | MTL_RX_OVERFLOW_INT,
-			       ioaddr + MTL_CHAN_INT_CTRL(chan));
+			       ioaddr + addr_offset);
 			ret = CORE_IRQ_MTL_RX_OVERFLOW;
 		}
 	}
@@ -838,6 +907,16 @@ static int dwmac4_irq_mtl_status(struct mac_device_info *hw, u32 chan)
 	return ret;
 }
 
+static int emac3_irq_mtl_status(struct mac_device_info *hw, u32 chan)
+{
+	return do_irq_mtl_status(hw, chan, EMAC3_MTL_CHAN_INT_CTRL(chan));
+}
+
+static int dwmac4_irq_mtl_status(struct mac_device_info *hw, u32 chan)
+{
+	return do_irq_mtl_status(hw, chan, MTL_CHAN_INT_CTRL(chan));
+}
+
 static int dwmac4_irq_status(struct mac_device_info *hw,
 			     struct stmmac_extra_stats *x)
 {
@@ -888,14 +967,16 @@ static int dwmac4_irq_status(struct mac_device_info *hw,
 	return ret;
 }
 
-static void dwmac4_debug(void __iomem *ioaddr, struct stmmac_extra_stats *x,
-			 u32 rx_queues, u32 tx_queues)
+static void do_debug(void __iomem *ioaddr, struct stmmac_extra_stats *x,
+		     u32 rx_queues, u32 tx_queues,
+		     u32 (*rx_addr_offset)(u32 queue),
+		     u32 (*tx_addr_offset)(u32 queue))
 {
 	u32 value;
 	u32 queue;
 
 	for (queue = 0; queue < tx_queues; queue++) {
-		value = readl(ioaddr + MTL_CHAN_TX_DEBUG(queue));
+		value = readl(ioaddr + tx_addr_offset(queue));
 
 		if (value & MTL_DEBUG_TXSTSFSTS)
 			x->mtl_tx_status_fifo_full++;
@@ -920,7 +1001,7 @@ static void dwmac4_debug(void __iomem *ioaddr, struct stmmac_extra_stats *x,
 	}
 
 	for (queue = 0; queue < rx_queues; queue++) {
-		value = readl(ioaddr + MTL_CHAN_RX_DEBUG(queue));
+		value = readl(ioaddr + rx_addr_offset(queue));
 
 		if (value & MTL_DEBUG_RXFSTS_MASK) {
 			u32 rxfsts = (value & MTL_DEBUG_RXFSTS_MASK)
@@ -977,6 +1058,42 @@ static void dwmac4_debug(void __iomem *ioaddr, struct stmmac_extra_stats *x,
 		x->mac_gmii_rx_proto_engine++;
 }
 
+static u32 emac3_debug_rx_addr_offset(u32 queue)
+{
+	return EMAC3_MTL_CHAN_RX_DEBUG(queue);
+}
+
+static u32 emac3_debug_tx_addr_offset(u32 queue)
+{
+	return EMAC3_MTL_CHAN_TX_DEBUG(queue);
+}
+
+static void emac3_debug(void __iomem *ioaddr,
+			struct stmmac_extra_stats *x, u32 rx_queues,
+			u32 tx_queues)
+{
+	do_debug(ioaddr, x, rx_queues, tx_queues, emac3_debug_rx_addr_offset,
+		 emac3_debug_tx_addr_offset);
+}
+
+static u32 dwmac4_debug_rx_addr_offset(u32 queue)
+{
+	return MTL_CHAN_RX_DEBUG(queue);
+}
+
+static u32 dwmac4_debug_tx_addr_offset(u32 queue)
+{
+	return MTL_CHAN_TX_DEBUG(queue);
+}
+
+static void dwmac4_debug(void __iomem *ioaddr,
+			 struct stmmac_extra_stats *x, u32 rx_queues,
+			 u32 tx_queues)
+{
+	do_debug(ioaddr, x, rx_queues, tx_queues, dwmac4_debug_rx_addr_offset,
+		 dwmac4_debug_tx_addr_offset);
+}
+
 static void dwmac4_set_mac_loopback(void __iomem *ioaddr, bool enable)
 {
 	u32 value = readl(ioaddr + GMAC_CONFIG);
@@ -1309,6 +1426,58 @@ const struct stmmac_ops dwmac510_ops = {
 	.restore_hw_vlan_rx_fltr = dwmac4_restore_hw_vlan_rx_fltr,
 };
 
+const struct stmmac_ops emac3_ops = {
+	.core_init = dwmac4_core_init,
+	.set_mac = stmmac_dwmac4_set_mac,
+	.rx_ipc = dwmac4_rx_ipc_enable,
+	.rx_queue_enable = dwmac4_rx_queue_enable,
+	.rx_queue_prio = dwmac4_rx_queue_priority,
+	.tx_queue_prio = dwmac4_tx_queue_priority,
+	.rx_queue_routing = dwmac4_rx_queue_routing,
+	.prog_mtl_rx_algorithms = dwmac4_prog_mtl_rx_algorithms,
+	.prog_mtl_tx_algorithms = dwmac4_prog_mtl_tx_algorithms,
+	.set_mtl_tx_queue_weight = emac3_set_mtl_tx_queue_weight,
+	.map_mtl_to_dma = dwmac4_map_mtl_dma,
+	.config_cbs = emac3_config_cbs,
+	.dump_regs = dwmac4_dump_regs,
+	.host_irq_status = dwmac4_irq_status,
+	.host_mtl_irq_status = emac3_irq_mtl_status,
+	.flow_ctrl = dwmac4_flow_ctrl,
+	.pmt = dwmac4_pmt,
+	.set_umac_addr = dwmac4_set_umac_addr,
+	.get_umac_addr = dwmac4_get_umac_addr,
+	.set_eee_mode = dwmac4_set_eee_mode,
+	.reset_eee_mode = dwmac4_reset_eee_mode,
+	.set_eee_lpi_entry_timer = dwmac4_set_eee_lpi_entry_timer,
+	.set_eee_timer = dwmac4_set_eee_timer,
+	.set_eee_pls = dwmac4_set_eee_pls,
+	.pcs_ctrl_ane = dwmac4_ctrl_ane,
+	.pcs_rane = dwmac4_rane,
+	.pcs_get_adv_lp = dwmac4_get_adv_lp,
+	.debug = emac3_debug,
+	.set_filter = dwmac4_set_filter,
+	.safety_feat_config = dwmac5_safety_feat_config,
+	.safety_feat_irq_status = dwmac5_safety_feat_irq_status,
+	.safety_feat_dump = dwmac5_safety_feat_dump,
+	.rxp_config = dwmac5_rxp_config,
+	.flex_pps_config = dwmac5_flex_pps_config,
+	.set_mac_loopback = dwmac4_set_mac_loopback,
+	.update_vlan_hash = dwmac4_update_vlan_hash,
+	.sarc_configure = dwmac4_sarc_configure,
+	.enable_vlan = dwmac4_enable_vlan,
+	.set_arp_offload = dwmac4_set_arp_offload,
+	.config_l3_filter = dwmac4_config_l3_filter,
+	.config_l4_filter = dwmac4_config_l4_filter,
+	.est_configure = dwmac5_est_configure,
+	.est_irq_status = dwmac5_est_irq_status,
+	.fpe_configure = dwmac5_fpe_configure,
+	.fpe_send_mpacket = dwmac5_fpe_send_mpacket,
+	.fpe_irq_status = dwmac5_fpe_irq_status,
+	.add_hw_vlan_rx_fltr = dwmac4_add_hw_vlan_rx_fltr,
+	.del_hw_vlan_rx_fltr = dwmac4_del_hw_vlan_rx_fltr,
+	.restore_hw_vlan_rx_fltr = dwmac4_restore_hw_vlan_rx_fltr,
+};
+
 static u32 dwmac4_get_num_vlan(void __iomem *ioaddr)
 {
 	u32 val, num_vlan;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index d99fa028c646..7d243c69c20e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -68,77 +68,127 @@ static void dwmac4_dma_axi(void __iomem *ioaddr, struct stmmac_axi *axi)
 	writel(value, ioaddr + DMA_SYS_BUS_MODE);
 }
 
-static void dwmac4_dma_init_rx_chan(void __iomem *ioaddr,
-				    struct stmmac_dma_cfg *dma_cfg,
-				    dma_addr_t dma_rx_phy, u32 chan)
+static void do_dma_init_rx_chan(void __iomem *ioaddr, u32 rx_ctl_offset,
+				u32 rx_high_offset, u32 rx_base_offset,
+				struct stmmac_dma_cfg *dma_cfg,
+				dma_addr_t dma_rx_phy)
 {
 	u32 value;
 	u32 rxpbl = dma_cfg->rxpbl ?: dma_cfg->pbl;
 
-	value = readl(ioaddr + DMA_CHAN_RX_CONTROL(chan));
+	value = readl(ioaddr + rx_ctl_offset);
 	value = value | (rxpbl << DMA_BUS_MODE_RPBL_SHIFT);
-	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(chan));
+	writel(value, ioaddr + rx_ctl_offset);
 
 	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT) && likely(dma_cfg->eame))
-		writel(upper_32_bits(dma_rx_phy),
-		       ioaddr + DMA_CHAN_RX_BASE_ADDR_HI(chan));
+		writel(upper_32_bits(dma_rx_phy), ioaddr + rx_high_offset);
 
-	writel(lower_32_bits(dma_rx_phy), ioaddr + DMA_CHAN_RX_BASE_ADDR(chan));
+	writel(lower_32_bits(dma_rx_phy), ioaddr + rx_base_offset);
 }
 
-static void dwmac4_dma_init_tx_chan(void __iomem *ioaddr,
+static void emac3_dma_init_rx_chan(void __iomem *ioaddr,
+				   struct stmmac_dma_cfg *dma_cfg,
+				   dma_addr_t dma_rx_phy, u32 chan)
+{
+	do_dma_init_rx_chan(ioaddr, EMAC3_DMA_CHAN_RX_CONTROL(chan),
+			    EMAC3_DMA_CHAN_RX_BASE_ADDR_HI(chan),
+			    EMAC3_DMA_CHAN_RX_BASE_ADDR(chan),
+			    dma_cfg, dma_rx_phy);
+}
+
+static void dwmac4_dma_init_rx_chan(void __iomem *ioaddr,
 				    struct stmmac_dma_cfg *dma_cfg,
-				    dma_addr_t dma_tx_phy, u32 chan)
+				    dma_addr_t dma_rx_phy, u32 chan)
+{
+	do_dma_init_rx_chan(ioaddr, DMA_CHAN_RX_CONTROL(chan),
+			    DMA_CHAN_RX_BASE_ADDR_HI(chan),
+			    DMA_CHAN_RX_BASE_ADDR(chan),
+			    dma_cfg, dma_rx_phy);
+}
+
+static void do_dma_init_tx_chan(void __iomem *ioaddr, u32 tx_ctl_offset,
+				u32 tx_high_offset, u32 tx_base_offset,
+				struct stmmac_dma_cfg *dma_cfg,
+				dma_addr_t dma_tx_phy)
 {
 	u32 value;
 	u32 txpbl = dma_cfg->txpbl ?: dma_cfg->pbl;
 
-	value = readl(ioaddr + DMA_CHAN_TX_CONTROL(chan));
+	value = readl(ioaddr + tx_ctl_offset);
 	value = value | (txpbl << DMA_BUS_MODE_PBL_SHIFT);
 
 	/* Enable OSP to get best performance */
 	value |= DMA_CONTROL_OSP;
 
-	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(chan));
+	writel(value, ioaddr + tx_ctl_offset);
 
 	if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT) && likely(dma_cfg->eame))
-		writel(upper_32_bits(dma_tx_phy),
-		       ioaddr + DMA_CHAN_TX_BASE_ADDR_HI(chan));
+		writel(upper_32_bits(dma_tx_phy), ioaddr + tx_high_offset);
 
-	writel(lower_32_bits(dma_tx_phy), ioaddr + DMA_CHAN_TX_BASE_ADDR(chan));
+	writel(lower_32_bits(dma_tx_phy), ioaddr + tx_base_offset);
 }
 
-static void dwmac4_dma_init_channel(void __iomem *ioaddr,
-				    struct stmmac_dma_cfg *dma_cfg, u32 chan)
+static void emac3_dma_init_tx_chan(void __iomem *ioaddr,
+				   struct stmmac_dma_cfg *dma_cfg,
+				   dma_addr_t dma_tx_phy, u32 chan)
+{
+	do_dma_init_tx_chan(ioaddr, EMAC3_DMA_CHAN_TX_CONTROL(chan),
+			    EMAC3_DMA_CHAN_TX_BASE_ADDR_HI(chan),
+			    EMAC3_DMA_CHAN_TX_BASE_ADDR(chan),
+			    dma_cfg, dma_tx_phy);
+}
+
+static void dwmac4_dma_init_tx_chan(void __iomem *ioaddr,
+				    struct stmmac_dma_cfg *dma_cfg,
+				    dma_addr_t dma_tx_phy, u32 chan)
+{
+	do_dma_init_tx_chan(ioaddr, DMA_CHAN_TX_CONTROL(chan),
+			    DMA_CHAN_TX_BASE_ADDR_HI(chan),
+			    DMA_CHAN_TX_BASE_ADDR(chan),
+			    dma_cfg, dma_tx_phy);
+}
+
+static void do_dma_init_channel(void __iomem *ioaddr,
+				struct stmmac_dma_cfg *dma_cfg,
+				u32 addr_offset, u32 intr_addr_offset,
+				u32 intr_addr_mask)
 {
 	u32 value;
 
 	/* common channel control register config */
-	value = readl(ioaddr + DMA_CHAN_CONTROL(chan));
+	value = readl(ioaddr + addr_offset);
 	if (dma_cfg->pblx8)
 		value = value | DMA_BUS_MODE_PBL;
-	writel(value, ioaddr + DMA_CHAN_CONTROL(chan));
+	writel(value, ioaddr + addr_offset);
 
 	/* Mask interrupts by writing to CSR7 */
-	writel(DMA_CHAN_INTR_DEFAULT_MASK,
-	       ioaddr + DMA_CHAN_INTR_ENA(chan));
+	writel(intr_addr_mask, ioaddr + intr_addr_offset);
 }
 
-static void dwmac410_dma_init_channel(void __iomem *ioaddr,
-				      struct stmmac_dma_cfg *dma_cfg, u32 chan)
+static void emac3_dma_init_channel(void __iomem *ioaddr,
+				   struct stmmac_dma_cfg *dma_cfg,
+				   u32 chan)
 {
-	u32 value;
-
-	/* common channel control register config */
-	value = readl(ioaddr + DMA_CHAN_CONTROL(chan));
-	if (dma_cfg->pblx8)
-		value = value | DMA_BUS_MODE_PBL;
+	do_dma_init_channel(ioaddr, dma_cfg, EMAC3_DMA_CHAN_CONTROL(chan),
+			    EMAC3_DMA_CHAN_INTR_ENA(chan),
+			    DMA_CHAN_INTR_DEFAULT_MASK_4_10);
+}
 
-	writel(value, ioaddr + DMA_CHAN_CONTROL(chan));
+static void dwmac4_dma_init_channel(void __iomem *ioaddr,
+				    struct stmmac_dma_cfg *dma_cfg,
+				    u32 chan)
+{
+	do_dma_init_channel(ioaddr, dma_cfg, DMA_CHAN_CONTROL(chan),
+			    DMA_CHAN_INTR_ENA(chan),
+			    DMA_CHAN_INTR_DEFAULT_MASK);
+}
 
-	/* Mask interrupts by writing to CSR7 */
-	writel(DMA_CHAN_INTR_DEFAULT_MASK_4_10,
-	       ioaddr + DMA_CHAN_INTR_ENA(chan));
+static void dwmac410_dma_init_channel(void __iomem *ioaddr,
+				      struct stmmac_dma_cfg *dma_cfg, u32 chan)
+{
+	do_dma_init_channel(ioaddr, dma_cfg, DMA_CHAN_CONTROL(chan),
+			    DMA_CHAN_INTR_ENA(chan),
+			    DMA_CHAN_INTR_DEFAULT_MASK_4_10);
 }
 
 static void dwmac4_dma_init(void __iomem *ioaddr,
@@ -176,6 +226,46 @@ static void dwmac4_dma_init(void __iomem *ioaddr,
 
 }
 
+static void _emac3_dump_dma_regs(void __iomem *ioaddr, u32 channel,
+				 u32 *reg_space)
+{
+	/* Use dwmac4's reg_space offsets to reuse common stmmac_ethtool code */
+	reg_space[DMA_CHAN_CONTROL(channel) / 4] =
+		readl(ioaddr + EMAC3_DMA_CHAN_CONTROL(channel));
+	reg_space[DMA_CHAN_TX_CONTROL(channel) / 4] =
+		readl(ioaddr + EMAC3_DMA_CHAN_TX_CONTROL(channel));
+	reg_space[DMA_CHAN_RX_CONTROL(channel) / 4] =
+		readl(ioaddr + EMAC3_DMA_CHAN_RX_CONTROL(channel));
+	reg_space[DMA_CHAN_TX_BASE_ADDR(channel) / 4] =
+		readl(ioaddr + EMAC3_DMA_CHAN_TX_BASE_ADDR(channel));
+	reg_space[DMA_CHAN_RX_BASE_ADDR(channel) / 4] =
+		readl(ioaddr + EMAC3_DMA_CHAN_RX_BASE_ADDR(channel));
+	reg_space[DMA_CHAN_TX_END_ADDR(channel) / 4] =
+		readl(ioaddr + EMAC3_DMA_CHAN_TX_END_ADDR(channel));
+	reg_space[DMA_CHAN_RX_END_ADDR(channel) / 4] =
+		readl(ioaddr + EMAC3_DMA_CHAN_RX_END_ADDR(channel));
+	reg_space[DMA_CHAN_TX_RING_LEN(channel) / 4] =
+		readl(ioaddr + EMAC3_DMA_CHAN_TX_RING_LEN(channel));
+	reg_space[DMA_CHAN_RX_RING_LEN(channel) / 4] =
+		readl(ioaddr + EMAC3_DMA_CHAN_RX_RING_LEN(channel));
+	reg_space[DMA_CHAN_INTR_ENA(channel) / 4] =
+		readl(ioaddr + EMAC3_DMA_CHAN_INTR_ENA(channel));
+	reg_space[DMA_CHAN_RX_WATCHDOG(channel) / 4] =
+		readl(ioaddr + EMAC3_DMA_CHAN_RX_WATCHDOG(channel));
+	reg_space[DMA_CHAN_SLOT_CTRL_STATUS(channel) / 4] =
+		readl(ioaddr + EMAC3_DMA_CHAN_SLOT_CTRL_STATUS(channel));
+	reg_space[DMA_CHAN_CUR_TX_DESC(channel) / 4] =
+		readl(ioaddr + EMAC3_DMA_CHAN_CUR_TX_DESC(channel));
+	reg_space[DMA_CHAN_CUR_RX_DESC(channel) / 4] =
+		readl(ioaddr + EMAC3_DMA_CHAN_CUR_RX_DESC(channel));
+	reg_space[DMA_CHAN_CUR_TX_BUF_ADDR(channel) / 4] =
+		readl(ioaddr + EMAC3_DMA_CHAN_CUR_TX_BUF_ADDR(channel));
+	reg_space[DMA_CHAN_CUR_RX_BUF_ADDR(channel) / 4] =
+		readl(ioaddr + EMAC3_DMA_CHAN_CUR_RX_BUF_ADDR(channel));
+	reg_space[DMA_CHAN_STATUS(channel) / 4] =
+		readl(ioaddr + EMAC3_DMA_CHAN_STATUS(channel));
+}
+
 static void _dwmac4_dump_dma_regs(void __iomem *ioaddr, u32 channel,
 				  u32 *reg_space)
 {
@@ -215,6 +305,12 @@ static void _dwmac4_dump_dma_regs(void __iomem *ioaddr, u32 channel,
 		readl(ioaddr + DMA_CHAN_STATUS(channel));
 }
 
+static void emac3_dump_dma_regs(void __iomem *ioaddr, u32 *reg_space)
+{
+	for (int i = 0; i < DMA_CHANNEL_NB_MAX; i++)
+		_emac3_dump_dma_regs(ioaddr, i, reg_space);
+}
+
 static void dwmac4_dump_dma_regs(void __iomem *ioaddr, u32 *reg_space)
 {
 	int i;
@@ -223,18 +319,23 @@ static void dwmac4_dump_dma_regs(void __iomem *ioaddr, u32 *reg_space)
 		_dwmac4_dump_dma_regs(ioaddr, i, reg_space);
 }
 
+static void emac3_rx_watchdog(void __iomem *ioaddr, u32 riwt, u32 queue)
+{
+	writel(riwt, ioaddr + EMAC3_DMA_CHAN_RX_WATCHDOG(queue));
+}
+
 static void dwmac4_rx_watchdog(void __iomem *ioaddr, u32 riwt, u32 queue)
 {
 	writel(riwt, ioaddr + DMA_CHAN_RX_WATCHDOG(queue));
 }
 
-static void dwmac4_dma_rx_chan_op_mode(void __iomem *ioaddr, int mode,
-				       u32 channel, int fifosz, u8 qmode)
+static void do_dma_rx_chan_op_mode(void __iomem *ioaddr, int mode, int fifosz,
+				   u8 qmode, u32 addr_offset)
 {
 	unsigned int rqs = fifosz / 256 - 1;
 	u32 mtl_rx_op;
 
-	mtl_rx_op = readl(ioaddr + MTL_CHAN_RX_OP_MODE(channel));
+	mtl_rx_op = readl(ioaddr + addr_offset);
 
 	if (mode == SF_DMA_MODE) {
 		pr_debug("GMAC: enable RX store and forward mode\n");
@@ -292,13 +393,27 @@ static void dwmac4_dma_rx_chan_op_mode(void __iomem *ioaddr, int mode,
 		mtl_rx_op |= rfa << MTL_OP_MODE_RFA_SHIFT;
 	}
 
-	writel(mtl_rx_op, ioaddr + MTL_CHAN_RX_OP_MODE(channel));
+	writel(mtl_rx_op, ioaddr + addr_offset);
 }
 
-static void dwmac4_dma_tx_chan_op_mode(void __iomem *ioaddr, int mode,
+static void emac3_dma_rx_chan_op_mode(void __iomem *ioaddr, int mode,
+				      u32 channel, int fifosz, u8 qmode)
+{
+	do_dma_rx_chan_op_mode(ioaddr, mode, fifosz, qmode,
+			       EMAC3_MTL_CHAN_RX_OP_MODE(channel));
+}
+
+static void dwmac4_dma_rx_chan_op_mode(void __iomem *ioaddr, int mode,
 				       u32 channel, int fifosz, u8 qmode)
 {
-	u32 mtl_tx_op = readl(ioaddr + MTL_CHAN_TX_OP_MODE(channel));
+	do_dma_rx_chan_op_mode(ioaddr, mode, fifosz, qmode,
+			       MTL_CHAN_RX_OP_MODE(channel));
+}
+
+static void do_dma_tx_chan_op_mode(void __iomem *ioaddr, int mode, int fifosz,
+				   u8 qmode, u32 addr_offset)
+{
+	u32 mtl_tx_op = readl(ioaddr + addr_offset);
 	unsigned int tqs = fifosz / 256 - 1;
 
 	if (mode == SF_DMA_MODE) {
@@ -344,7 +459,21 @@ static void dwmac4_dma_tx_chan_op_mode(void __iomem *ioaddr, int mode,
 	mtl_tx_op &= ~MTL_OP_MODE_TQS_MASK;
 	mtl_tx_op |= tqs << MTL_OP_MODE_TQS_SHIFT;
 
-	writel(mtl_tx_op, ioaddr +  MTL_CHAN_TX_OP_MODE(channel));
+	writel(mtl_tx_op, ioaddr + addr_offset);
+}
+
+static void emac3_dma_tx_chan_op_mode(void __iomem *ioaddr, int mode,
+				      u32 channel, int fifosz, u8 qmode)
+{
+	do_dma_tx_chan_op_mode(ioaddr, mode, fifosz, qmode,
+			       EMAC3_MTL_CHAN_TX_OP_MODE(channel));
+}
+
+static void dwmac4_dma_tx_chan_op_mode(void __iomem *ioaddr, int mode,
+				       u32 channel, int fifosz, u8 qmode)
+{
+	do_dma_tx_chan_op_mode(ioaddr, mode, fifosz, qmode,
+			       MTL_CHAN_TX_OP_MODE(channel));
 }
 
 static int dwmac4_get_hw_feature(void __iomem *ioaddr,
@@ -442,26 +571,29 @@ static int dwmac4_get_hw_feature(void __iomem *ioaddr,
 }
 
 /* Enable/disable TSO feature and set MSS */
-static void dwmac4_enable_tso(void __iomem *ioaddr, bool en, u32 chan)
+static void do_enable_tso(void __iomem *ioaddr, bool en, u32 addr_offset)
 {
-	u32 value;
+	u32 value = readl(ioaddr + addr_offset);
 
-	if (en) {
-		/* enable TSO */
-		value = readl(ioaddr + DMA_CHAN_TX_CONTROL(chan));
-		writel(value | DMA_CONTROL_TSE,
-		       ioaddr + DMA_CHAN_TX_CONTROL(chan));
-	} else {
-		/* enable TSO */
-		value = readl(ioaddr + DMA_CHAN_TX_CONTROL(chan));
-		writel(value & ~DMA_CONTROL_TSE,
-		       ioaddr + DMA_CHAN_TX_CONTROL(chan));
-	}
+	if (en)
+		writel(value | DMA_CONTROL_TSE, ioaddr + addr_offset);
+	else
+		writel(value & ~DMA_CONTROL_TSE, ioaddr + addr_offset);
 }
 
-static void dwmac4_qmode(void __iomem *ioaddr, u32 channel, u8 qmode)
+static void emac3_enable_tso(void __iomem *ioaddr, bool en, u32 chan)
 {
-	u32 mtl_tx_op = readl(ioaddr + MTL_CHAN_TX_OP_MODE(channel));
+	do_enable_tso(ioaddr, en, EMAC3_DMA_CHAN_TX_CONTROL(chan));
+}
+
+static void dwmac4_enable_tso(void __iomem *ioaddr, bool en, u32 chan)
+{
+	do_enable_tso(ioaddr, en, DMA_CHAN_TX_CONTROL(chan));
+}
+
+static void do_qmode(void __iomem *ioaddr, u8 qmode, u32 addr_offset)
+{
+	u32 mtl_tx_op = readl(ioaddr + addr_offset);
 
 	mtl_tx_op &= ~MTL_OP_MODE_TXQEN_MASK;
 	if (qmode != MTL_QUEUE_AVB)
@@ -469,20 +601,40 @@ static void dwmac4_qmode(void __iomem *ioaddr, u32 channel, u8 qmode)
 	else
 		mtl_tx_op |= MTL_OP_MODE_TXQEN_AV;
 
-	writel(mtl_tx_op, ioaddr +  MTL_CHAN_TX_OP_MODE(channel));
+	writel(mtl_tx_op, ioaddr + addr_offset);
 }
 
-static void dwmac4_set_bfsize(void __iomem *ioaddr, int bfsize, u32 chan)
+static void emac3_qmode(void __iomem *ioaddr, u32 channel, u8 qmode)
 {
-	u32 value = readl(ioaddr + DMA_CHAN_RX_CONTROL(chan));
+	do_qmode(ioaddr, qmode, EMAC3_MTL_CHAN_TX_OP_MODE(channel));
+}
+
+static void dwmac4_qmode(void __iomem *ioaddr, u32 channel, u8 qmode)
+{
+	do_qmode(ioaddr, qmode, MTL_CHAN_TX_OP_MODE(channel));
+}
+
+static void do_set_bfsize(void __iomem *ioaddr, int bfsize, u32 addr_offset)
+{
+	u32 value = readl(ioaddr + addr_offset);
 
 	value &= ~DMA_RBSZ_MASK;
 	value |= (bfsize << DMA_RBSZ_SHIFT) & DMA_RBSZ_MASK;
 
-	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(chan));
+	writel(value, ioaddr + addr_offset);
 }
 
-static void dwmac4_enable_sph(void __iomem *ioaddr, bool en, u32 chan)
+static void emac3_set_bfsize(void __iomem *ioaddr, int bfsize, u32 chan)
+{
+	do_set_bfsize(ioaddr, bfsize, EMAC3_DMA_CHAN_RX_CONTROL(chan));
+}
+
+static void dwmac4_set_bfsize(void __iomem *ioaddr, int bfsize, u32 chan)
+{
+	do_set_bfsize(ioaddr, bfsize, DMA_CHAN_RX_CONTROL(chan));
+}
+
+static void do_enable_sph(void __iomem *ioaddr, bool en, u32 addr_offset)
 {
 	u32 value = readl(ioaddr + GMAC_EXT_CONFIG);
 
@@ -490,26 +642,36 @@ static void dwmac4_enable_sph(void __iomem *ioaddr, bool en, u32 chan)
 	value |= GMAC_CONFIG_HDSMS_256; /* Segment max 256 bytes */
 	writel(value, ioaddr + GMAC_EXT_CONFIG);
 
-	value = readl(ioaddr + DMA_CHAN_CONTROL(chan));
+	value = readl(ioaddr + addr_offset);
 	if (en)
 		value |= DMA_CONTROL_SPH;
 	else
 		value &= ~DMA_CONTROL_SPH;
-	writel(value, ioaddr + DMA_CHAN_CONTROL(chan));
+	writel(value, ioaddr + addr_offset);
 }
 
-static int dwmac4_enable_tbs(void __iomem *ioaddr, bool en, u32 chan)
+static void emac3_enable_sph(void __iomem *ioaddr, bool en, u32 chan)
 {
-	u32 value = readl(ioaddr + DMA_CHAN_TX_CONTROL(chan));
+	do_enable_sph(ioaddr, en, EMAC3_DMA_CHAN_CONTROL(chan));
+}
+
+static void dwmac4_enable_sph(void __iomem *ioaddr, bool en, u32 chan)
+{
+	do_enable_sph(ioaddr, en, DMA_CHAN_CONTROL(chan));
+}
+
+static int do_enable_tbs(void __iomem *ioaddr, bool en, u32 addr_offset)
+{
+	u32 value = readl(ioaddr + addr_offset);
 
 	if (en)
 		value |= DMA_CONTROL_EDSE;
 	else
 		value &= ~DMA_CONTROL_EDSE;
 
-	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(chan));
+	writel(value, ioaddr + addr_offset);
 
-	value = readl(ioaddr + DMA_CHAN_TX_CONTROL(chan)) & DMA_CONTROL_EDSE;
+	value = readl(ioaddr + addr_offset) & DMA_CONTROL_EDSE;
 	if (en && !value)
 		return -EIO;
 
@@ -517,6 +679,16 @@ static int dwmac4_enable_tbs(void __iomem *ioaddr, bool en, u32 chan)
 	return 0;
 }
 
+static int emac3_enable_tbs(void __iomem *ioaddr, bool en, u32 chan)
+{
+	return do_enable_tbs(ioaddr, en, EMAC3_DMA_CHAN_TX_CONTROL(chan));
+}
+
+static int dwmac4_enable_tbs(void __iomem *ioaddr, bool en, u32 chan)
+{
+	return do_enable_tbs(ioaddr, en, DMA_CHAN_TX_CONTROL(chan));
+}
+
 const struct stmmac_dma_ops dwmac4_dma_ops = {
 	.reset = dwmac4_dma_reset,
 	.init = dwmac4_dma_init,
@@ -575,3 +747,33 @@ const struct stmmac_dma_ops dwmac410_dma_ops = {
 	.enable_sph = dwmac4_enable_sph,
 	.enable_tbs = dwmac4_enable_tbs,
 };
+
+const struct stmmac_dma_ops emac3_dma_ops = {
+	.reset = dwmac4_dma_reset,
+	.init = dwmac4_dma_init,
+	.init_chan = emac3_dma_init_channel,
+	.init_rx_chan = emac3_dma_init_rx_chan,
+	.init_tx_chan = emac3_dma_init_tx_chan,
+	.axi = dwmac4_dma_axi,
+	.dump_regs = emac3_dump_dma_regs,
+	.dma_rx_mode = emac3_dma_rx_chan_op_mode,
+	.dma_tx_mode = emac3_dma_tx_chan_op_mode,
+	.enable_dma_irq = emac3_enable_dma_irq,
+	.disable_dma_irq = emac3_disable_dma_irq,
+	.start_tx = emac3_dma_start_tx,
+	.stop_tx = emac3_dma_stop_tx,
+	.start_rx = emac3_dma_start_rx,
+	.stop_rx = emac3_dma_stop_rx,
+	.dma_interrupt = emac3_dma_interrupt,
+	.get_hw_feature = dwmac4_get_hw_feature,
+	.rx_watchdog = emac3_rx_watchdog,
+	.set_rx_ring_len = emac3_set_rx_ring_len,
+	.set_tx_ring_len = emac3_set_tx_ring_len,
+	.set_rx_tail_ptr = emac3_set_rx_tail_ptr,
+	.set_tx_tail_ptr = emac3_set_tx_tail_ptr,
+	.enable_tso = emac3_enable_tso,
+	.qmode = emac3_qmode,
+	.set_bfsize = emac3_set_bfsize,
+	.enable_sph = emac3_enable_sph,
+	.enable_tbs = emac3_enable_tbs,
+};
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
index 9321879b599c..c9899eefba6c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h
@@ -93,8 +93,11 @@
 #define DMA_TBS_DEF_FTOS		(DMA_TBS_FTOS | DMA_TBS_FTOV)
 
 /* Following DMA defines are chanels oriented */
+#define EMAC3_DMA_CHAN_BASE_ADDR		0x00008100
+#define EMAC3_DMA_CHAN_BASE_OFFSET		0x1000
 #define DMA_CHAN_BASE_ADDR		0x00001100
 #define DMA_CHAN_BASE_OFFSET		0x80
+
 #define DMA_CHANX_BASE_ADDR(x)		(DMA_CHAN_BASE_ADDR + \
 					(x * DMA_CHAN_BASE_OFFSET))
 #define DMA_CHAN_REG_NUMBER		17
@@ -119,6 +122,29 @@
 #define DMA_CHAN_CUR_RX_BUF_ADDR(x)	(DMA_CHANX_BASE_ADDR(x) + 0x5c)
 #define DMA_CHAN_STATUS(x)		(DMA_CHANX_BASE_ADDR(x) + 0x60)
 
+#define EMAC3_DMA_CHANX_BASE_ADDR(x)		(EMAC3_DMA_CHAN_BASE_ADDR + \
+					((x) * EMAC3_DMA_CHAN_BASE_OFFSET))
+
+#define EMAC3_DMA_CHAN_CONTROL(x)		EMAC3_DMA_CHANX_BASE_ADDR(x)
+#define EMAC3_DMA_CHAN_TX_CONTROL(x)		(EMAC3_DMA_CHANX_BASE_ADDR(x) + 0x4)
+#define EMAC3_DMA_CHAN_RX_CONTROL(x)		(EMAC3_DMA_CHANX_BASE_ADDR(x) + 0x8)
+#define EMAC3_DMA_CHAN_TX_BASE_ADDR_HI(x)	(EMAC3_DMA_CHANX_BASE_ADDR(x) + 0x10)
+#define EMAC3_DMA_CHAN_TX_BASE_ADDR(x)	(EMAC3_DMA_CHANX_BASE_ADDR(x) + 0x14)
+#define EMAC3_DMA_CHAN_RX_BASE_ADDR_HI(x)	(EMAC3_DMA_CHANX_BASE_ADDR(x) + 0x18)
+#define EMAC3_DMA_CHAN_RX_BASE_ADDR(x)	(EMAC3_DMA_CHANX_BASE_ADDR(x) + 0x1c)
+#define EMAC3_DMA_CHAN_TX_END_ADDR(x)		(EMAC3_DMA_CHANX_BASE_ADDR(x) + 0x20)
+#define EMAC3_DMA_CHAN_RX_END_ADDR(x)		(EMAC3_DMA_CHANX_BASE_ADDR(x) + 0x28)
+#define EMAC3_DMA_CHAN_TX_RING_LEN(x)		(EMAC3_DMA_CHANX_BASE_ADDR(x) + 0x2c)
+#define EMAC3_DMA_CHAN_RX_RING_LEN(x)		(EMAC3_DMA_CHANX_BASE_ADDR(x) + 0x30)
+#define EMAC3_DMA_CHAN_INTR_ENA(x)		(EMAC3_DMA_CHANX_BASE_ADDR(x) + 0x34)
+#define EMAC3_DMA_CHAN_RX_WATCHDOG(x)		(EMAC3_DMA_CHANX_BASE_ADDR(x) + 0x38)
+#define EMAC3_DMA_CHAN_SLOT_CTRL_STATUS(x)	(EMAC3_DMA_CHANX_BASE_ADDR(x) + 0x3c)
+#define EMAC3_DMA_CHAN_CUR_TX_DESC(x)		(EMAC3_DMA_CHANX_BASE_ADDR(x) + 0x44)
+#define EMAC3_DMA_CHAN_CUR_RX_DESC(x)		(EMAC3_DMA_CHANX_BASE_ADDR(x) + 0x4c)
+#define EMAC3_DMA_CHAN_CUR_TX_BUF_ADDR(x)	(EMAC3_DMA_CHANX_BASE_ADDR(x) + 0x54)
+#define EMAC3_DMA_CHAN_CUR_RX_BUF_ADDR(x)	(EMAC3_DMA_CHANX_BASE_ADDR(x) + 0x5c)
+#define EMAC3_DMA_CHAN_STATUS(x)		(EMAC3_DMA_CHANX_BASE_ADDR(x) + 0x60)
+
 /* DMA Control X */
 #define DMA_CONTROL_SPH			BIT(24)
 #define DMA_CONTROL_MSS_MASK		GENMASK(13, 0)
@@ -220,19 +246,31 @@
 #define DMA_CHAN0_DBG_STAT_RPS_SHIFT	8
 
 int dwmac4_dma_reset(void __iomem *ioaddr);
+void emac3_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx);
 void dwmac4_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx);
 void dwmac410_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx);
+void emac3_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx);
 void dwmac4_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx);
 void dwmac410_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx);
+void emac3_dma_start_tx(void __iomem *ioaddr, u32 chan);
 void dwmac4_dma_start_tx(void __iomem *ioaddr, u32 chan);
+void emac3_dma_stop_tx(void __iomem *ioaddr, u32 chan);
 void dwmac4_dma_stop_tx(void __iomem *ioaddr, u32 chan);
+void emac3_dma_start_rx(void __iomem *ioaddr, u32 chan);
 void dwmac4_dma_start_rx(void __iomem *ioaddr, u32 chan);
+void emac3_dma_stop_rx(void __iomem *ioaddr, u32 chan);
 void dwmac4_dma_stop_rx(void __iomem *ioaddr, u32 chan);
+int emac3_dma_interrupt(void __iomem *ioaddr, struct stmmac_extra_stats *x,
+			u32 chan, u32 dir);
 int dwmac4_dma_interrupt(void __iomem *ioaddr,
 			 struct stmmac_extra_stats *x, u32 chan, u32 dir);
+void emac3_set_rx_ring_len(void __iomem *ioaddr, u32 len, u32 chan);
 void dwmac4_set_rx_ring_len(void __iomem *ioaddr, u32 len, u32 chan);
+void emac3_set_tx_ring_len(void __iomem *ioaddr, u32 len, u32 chan);
 void dwmac4_set_tx_ring_len(void __iomem *ioaddr, u32 len, u32 chan);
+void emac3_set_rx_tail_ptr(void __iomem *ioaddr, u32 tail_ptr, u32 chan);
 void dwmac4_set_rx_tail_ptr(void __iomem *ioaddr, u32 tail_ptr, u32 chan);
+void emac3_set_tx_tail_ptr(void __iomem *ioaddr, u32 tail_ptr, u32 chan);
 void dwmac4_set_tx_tail_ptr(void __iomem *ioaddr, u32 tail_ptr, u32 chan);
 
 #endif /* __DWMAC4_DMA_H__ */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
index d1c605777985..3cbcc595bdfc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c
@@ -25,55 +25,110 @@ int dwmac4_dma_reset(void __iomem *ioaddr)
 				 10000, 1000000);
 }
 
+void emac3_set_rx_tail_ptr(void __iomem *ioaddr, u32 tail_ptr, u32 chan)
+{
+	writel(tail_ptr, ioaddr + EMAC3_DMA_CHAN_RX_END_ADDR(chan));
+}
+
 void dwmac4_set_rx_tail_ptr(void __iomem *ioaddr, u32 tail_ptr, u32 chan)
 {
 	writel(tail_ptr, ioaddr + DMA_CHAN_RX_END_ADDR(chan));
 }
 
+void emac3_set_tx_tail_ptr(void __iomem *ioaddr, u32 tail_ptr, u32 chan)
+{
+	writel(tail_ptr, ioaddr + EMAC3_DMA_CHAN_TX_END_ADDR(chan));
+}
+
 void dwmac4_set_tx_tail_ptr(void __iomem *ioaddr, u32 tail_ptr, u32 chan)
 {
 	writel(tail_ptr, ioaddr + DMA_CHAN_TX_END_ADDR(chan));
 }
 
-void dwmac4_dma_start_tx(void __iomem *ioaddr, u32 chan)
+static void do_dma_start_tx(void __iomem *ioaddr, u32 addr_offset)
 {
-	u32 value = readl(ioaddr + DMA_CHAN_TX_CONTROL(chan));
+	u32 value = readl(ioaddr + addr_offset);
 
 	value |= DMA_CONTROL_ST;
-	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(chan));
+	writel(value, ioaddr + addr_offset);
 
 	value = readl(ioaddr + GMAC_CONFIG);
 	value |= GMAC_CONFIG_TE;
 	writel(value, ioaddr + GMAC_CONFIG);
 }
 
-void dwmac4_dma_stop_tx(void __iomem *ioaddr, u32 chan)
+void emac3_dma_start_tx(void __iomem *ioaddr, u32 chan)
+{
+	do_dma_start_tx(ioaddr, EMAC3_DMA_CHAN_TX_CONTROL(chan));
+}
+
+void dwmac4_dma_start_tx(void __iomem *ioaddr, u32 chan)
 {
-	u32 value = readl(ioaddr + DMA_CHAN_TX_CONTROL(chan));
+	do_dma_start_tx(ioaddr, DMA_CHAN_TX_CONTROL(chan));
+}
+
+static void do_dma_stop_tx(void __iomem *ioaddr, u32 addr_offset)
+{
+	u32 value = readl(ioaddr + addr_offset);
 
 	value &= ~DMA_CONTROL_ST;
-	writel(value, ioaddr + DMA_CHAN_TX_CONTROL(chan));
+	writel(value, ioaddr + addr_offset);
 }
 
-void dwmac4_dma_start_rx(void __iomem *ioaddr, u32 chan)
+void emac3_dma_stop_tx(void __iomem *ioaddr, u32 chan)
 {
-	u32 value = readl(ioaddr + DMA_CHAN_RX_CONTROL(chan));
+	do_dma_stop_tx(ioaddr, EMAC3_DMA_CHAN_TX_CONTROL(chan));
+}
+
+void dwmac4_dma_stop_tx(void __iomem *ioaddr, u32 chan)
+{
+	do_dma_stop_tx(ioaddr, DMA_CHAN_TX_CONTROL(chan));
+}
+
+static void do_dma_start_rx(void __iomem *ioaddr, u32 addr_offset)
+{
+	u32 value = readl(ioaddr + addr_offset);
 
 	value |= DMA_CONTROL_SR;
 
-	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(chan));
+	writel(value, ioaddr + addr_offset);
 
 	value = readl(ioaddr + GMAC_CONFIG);
 	value |= GMAC_CONFIG_RE;
 	writel(value, ioaddr + GMAC_CONFIG);
 }
 
-void dwmac4_dma_stop_rx(void __iomem *ioaddr, u32 chan)
+void emac3_dma_start_rx(void __iomem *ioaddr, u32 chan)
 {
-	u32 value = readl(ioaddr + DMA_CHAN_RX_CONTROL(chan));
+	do_dma_start_rx(ioaddr, EMAC3_DMA_CHAN_RX_CONTROL(chan));
+}
+
+void dwmac4_dma_start_rx(void __iomem *ioaddr, u32 chan)
+{
+	do_dma_start_rx(ioaddr, DMA_CHAN_RX_CONTROL(chan));
+}
+
+static void do_dma_stop_rx(void __iomem *ioaddr, u32 addr_offset)
+{
+	u32 value = readl(ioaddr + addr_offset);
 
 	value &= ~DMA_CONTROL_SR;
-	writel(value, ioaddr + DMA_CHAN_RX_CONTROL(chan));
+	writel(value, ioaddr + addr_offset);
+}
+
+void emac3_dma_stop_rx(void __iomem *ioaddr, u32 chan)
+{
+	do_dma_stop_rx(ioaddr, EMAC3_DMA_CHAN_RX_CONTROL(chan));
+}
+
+void dwmac4_dma_stop_rx(void __iomem *ioaddr, u32 chan)
+{
+	do_dma_stop_rx(ioaddr, DMA_CHAN_RX_CONTROL(chan));
+}
+
+void emac3_set_tx_ring_len(void __iomem *ioaddr, u32 len, u32 chan)
+{
+	writel(len, ioaddr + EMAC3_DMA_CHAN_TX_RING_LEN(chan));
 }
 
 void dwmac4_set_tx_ring_len(void __iomem *ioaddr, u32 len, u32 chan)
@@ -81,6 +136,11 @@ void dwmac4_set_tx_ring_len(void __iomem *ioaddr, u32 len, u32 chan)
 	writel(len, ioaddr + DMA_CHAN_TX_RING_LEN(chan));
 }
 
+void emac3_set_rx_ring_len(void __iomem *ioaddr, u32 len, u32 chan)
+{
+	writel(len, ioaddr + EMAC3_DMA_CHAN_RX_RING_LEN(chan));
+}
+
 void dwmac4_set_rx_ring_len(void __iomem *ioaddr, u32 len, u32 chan)
 {
 	writel(len, ioaddr + DMA_CHAN_RX_RING_LEN(chan));
@@ -98,16 +158,27 @@ void dwmac4_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
 	writel(value, ioaddr + DMA_CHAN_INTR_ENA(chan));
 }
 
-void dwmac410_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
+static void do_enable_dma_irq(void __iomem *ioaddr, bool rx, bool tx,
+			      u32 addr_offset)
 {
-	u32 value = readl(ioaddr + DMA_CHAN_INTR_ENA(chan));
+	u32 value = readl(ioaddr + addr_offset);
 
 	if (rx)
 		value |= DMA_CHAN_INTR_DEFAULT_RX_4_10;
 	if (tx)
 		value |= DMA_CHAN_INTR_DEFAULT_TX_4_10;
 
-	writel(value, ioaddr + DMA_CHAN_INTR_ENA(chan));
+	writel(value, ioaddr + addr_offset);
+}
+
+void emac3_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
+{
+	do_enable_dma_irq(ioaddr, rx, tx, EMAC3_DMA_CHAN_INTR_ENA(chan));
+}
+
+void dwmac410_enable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
+{
+	do_enable_dma_irq(ioaddr, rx, tx, DMA_CHAN_INTR_ENA(chan));
 }
 
 void dwmac4_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
@@ -122,23 +193,35 @@ void dwmac4_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
 	writel(value, ioaddr + DMA_CHAN_INTR_ENA(chan));
 }
 
-void dwmac410_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
+static void do_disable_dma_irq(void __iomem *ioaddr, bool rx, bool tx,
+			       u32 addr_offset)
 {
-	u32 value = readl(ioaddr + DMA_CHAN_INTR_ENA(chan));
+	u32 value = readl(ioaddr + addr_offset);
 
 	if (rx)
 		value &= ~DMA_CHAN_INTR_DEFAULT_RX_4_10;
 	if (tx)
 		value &= ~DMA_CHAN_INTR_DEFAULT_TX_4_10;
 
-	writel(value, ioaddr + DMA_CHAN_INTR_ENA(chan));
+	writel(value, ioaddr + addr_offset);
 }
 
-int dwmac4_dma_interrupt(void __iomem *ioaddr,
-			 struct stmmac_extra_stats *x, u32 chan, u32 dir)
+void emac3_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
 {
-	u32 intr_status = readl(ioaddr + DMA_CHAN_STATUS(chan));
-	u32 intr_en = readl(ioaddr + DMA_CHAN_INTR_ENA(chan));
+	do_disable_dma_irq(ioaddr, rx, tx, EMAC3_DMA_CHAN_INTR_ENA(chan));
+}
+
+void dwmac410_disable_dma_irq(void __iomem *ioaddr, u32 chan, bool rx, bool tx)
+{
+	do_disable_dma_irq(ioaddr, rx, tx, DMA_CHAN_INTR_ENA(chan));
+}
+
+static int do_dma_interrupt(void __iomem *ioaddr, struct stmmac_extra_stats *x,
+			    u32 chan, u32 dir, u32 addr_offset,
+			    u32 intr_addr_offset)
+{
+	u32 intr_status = readl(ioaddr + addr_offset);
+	u32 intr_en = readl(ioaddr + intr_addr_offset);
 	int ret = 0;
 
 	if (dir == DMA_DIR_RX)
@@ -183,10 +266,25 @@ int dwmac4_dma_interrupt(void __iomem *ioaddr,
 	if (unlikely(intr_status & DMA_CHAN_STATUS_ERI))
 		x->rx_early_irq++;
 
-	writel(intr_status & intr_en, ioaddr + DMA_CHAN_STATUS(chan));
+	writel(intr_status & intr_en, ioaddr + addr_offset);
 	return ret;
 }
 
+int emac3_dma_interrupt(void __iomem *ioaddr, struct stmmac_extra_stats *x,
+			u32 chan, u32 dir)
+{
+	return do_dma_interrupt(ioaddr, x, chan, dir,
+				EMAC3_DMA_CHAN_STATUS(chan),
+				EMAC3_DMA_CHAN_INTR_ENA(chan));
+}
+
+int dwmac4_dma_interrupt(void __iomem *ioaddr, struct stmmac_extra_stats *x,
+			 u32 chan, u32 dir)
+{
+	return do_dma_interrupt(ioaddr, x, chan, dir, DMA_CHAN_STATUS(chan),
+				DMA_CHAN_INTR_ENA(chan));
+}
+
 void stmmac_dwmac4_set_mac_addr(void __iomem *ioaddr, const u8 addr[6],
 				unsigned int high, unsigned int low)
 {
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.c b/drivers/net/ethernet/stmicro/stmmac/hwif.c
index bb7114f970f8..7d8aa5e316cf 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.c
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.c
@@ -91,6 +91,7 @@ static const struct stmmac_hwif_entry {
 	bool gmac;
 	bool gmac4;
 	bool xgmac;
+	bool emac3;
 	u32 min_id;
 	u32 dev_id;
 	const struct stmmac_regs_off regs;
@@ -251,6 +252,25 @@ static const struct stmmac_hwif_entry {
 		.mmc = &dwxgmac_mmc_ops,
 		.setup = dwxlgmac2_setup,
 		.quirks = stmmac_dwxlgmac_quirks,
+	}, {
+		.gmac = false,
+		.gmac4 = false,
+		.xgmac = false,
+		.emac3 = true,
+		.min_id = DWMAC_CORE_5_10,
+		.regs = {
+			.ptp_off = PTP_GMAC4_OFFSET,
+			.mmc_off = MMC_GMAC4_OFFSET,
+		},
+		.desc = &dwmac4_desc_ops,
+		.dma = &emac3_dma_ops,
+		.mac = &emac3_ops,
+		.hwtimestamp = &stmmac_ptp,
+		.mode = &dwmac4_ring_mode_ops,
+		.tc = &dwmac510_tc_ops,
+		.mmc = &dwmac_mmc_ops,
+		.setup = dwmac4_setup,
+		.quirks = NULL,
 	},
 };
 
@@ -259,6 +279,7 @@ int stmmac_hwif_init(struct stmmac_priv *priv)
 	bool needs_xgmac = priv->plat->has_xgmac;
 	bool needs_gmac4 = priv->plat->has_gmac4;
 	bool needs_gmac = priv->plat->has_gmac;
+	bool needs_emac3 = priv->plat->has_emac3;
 	const struct stmmac_hwif_entry *entry;
 	struct mac_device_info *mac;
 	bool needs_setup = true;
@@ -267,7 +288,7 @@ int stmmac_hwif_init(struct stmmac_priv *priv)
 
 	if (needs_gmac) {
 		id = stmmac_get_id(priv, GMAC_VERSION);
-	} else if (needs_gmac4 || needs_xgmac) {
+	} else if (needs_gmac4 || needs_xgmac || needs_emac3) {
 		id = stmmac_get_id(priv, GMAC4_VERSION);
 		if (needs_xgmac)
 			dev_id = stmmac_get_dev_id(priv, GMAC4_VERSION);
@@ -280,9 +301,9 @@ int stmmac_hwif_init(struct stmmac_priv *priv)
 
 	/* Lets assume some safe values first */
 	priv->ptpaddr = priv->ioaddr +
-		(needs_gmac4 ? PTP_GMAC4_OFFSET : PTP_GMAC3_X_OFFSET);
+		((needs_gmac4 || needs_emac3) ? PTP_GMAC4_OFFSET : PTP_GMAC3_X_OFFSET);
 	priv->mmcaddr = priv->ioaddr +
-		(needs_gmac4 ? MMC_GMAC4_OFFSET : MMC_GMAC3_X_OFFSET);
+		((needs_gmac4 || needs_emac3) ? MMC_GMAC4_OFFSET : MMC_GMAC3_X_OFFSET);
 
 	/* Check for HW specific setup first */
 	if (priv->plat->setup) {
@@ -305,6 +326,8 @@ int stmmac_hwif_init(struct stmmac_priv *priv)
 			continue;
 		if (needs_xgmac ^ entry->xgmac)
 			continue;
+		if (needs_emac3 ^ entry->emac3)
+			continue;
 		/* Use synopsys_id var because some setups can override this */
 		if (priv->synopsys_id < entry->min_id)
 			continue;
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 16a7421715cb..44d77ced27cc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -620,6 +620,8 @@ struct stmmac_regs_off {
 	u32 mmc_off;
 };
 
+extern const struct stmmac_ops emac3_ops;
+extern const struct stmmac_dma_ops emac3_dma_ops;
 extern const struct stmmac_ops dwmac100_ops;
 extern const struct stmmac_dma_ops dwmac100_dma_ops;
 extern const struct stmmac_ops dwmac1000_ops;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 35c8dd92d369..0f62e5f85b60 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -286,7 +286,7 @@ static void stmmac_ethtool_getdrvinfo(struct net_device *dev,
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 
-	if (priv->plat->has_gmac || priv->plat->has_gmac4)
+	if (priv->plat->has_gmac || priv->plat->has_gmac4 || priv->plat->has_emac3)
 		strscpy(info->driver, GMAC_ETHTOOL_NAME, sizeof(info->driver));
 	else if (priv->plat->has_xgmac)
 		strscpy(info->driver, XGMAC_ETHTOOL_NAME, sizeof(info->driver));
@@ -442,7 +442,7 @@ static int stmmac_ethtool_get_regs_len(struct net_device *dev)
 
 	if (priv->plat->has_xgmac)
 		return XGMAC_REGSIZE * 4;
-	else if (priv->plat->has_gmac4)
+	else if (priv->plat->has_gmac4 || priv->plat->has_emac3)
 		return GMAC4_REG_SPACE_SIZE;
 	return REG_SPACE_SIZE;
 }
@@ -457,7 +457,7 @@ static void stmmac_ethtool_gregs(struct net_device *dev,
 	stmmac_dump_dma_regs(priv, priv->ioaddr, reg_space);
 
 	/* Copy DMA registers to where ethtool expects them */
-	if (priv->plat->has_gmac4) {
+	if (priv->plat->has_gmac4 || priv->plat->has_emac3) {
 		/* GMAC4 dumps its DMA registers at its DMA_CHAN_BASE_ADDR */
 		memcpy(&reg_space[ETHTOOL_DMA_OFFSET],
 		       &reg_space[GMAC4_DMA_CHAN_BASE_ADDR / 4],
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8f543c3ab5c5..d086fe811b67 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -509,7 +509,8 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
 					true);
 	}
 
-	if (priv->plat->has_gmac4 && priv->tx_lpi_timer <= STMMAC_ET_MAX) {
+	if ((priv->plat->has_gmac4 || priv->plat->has_emac3) &&
+	    priv->tx_lpi_timer <= STMMAC_ET_MAX) {
 		del_timer_sync(&priv->eee_ctrl_timer);
 		priv->tx_path_in_lpi_mode = false;
 		stmmac_lpi_entry_timer_config(priv, 1);
@@ -585,7 +586,7 @@ static void stmmac_get_rx_hwtstamp(struct stmmac_priv *priv, struct dma_desc *p,
 	if (!priv->hwts_rx_en)
 		return;
 	/* For GMAC4, the valid timestamp is from CTX next desc. */
-	if (priv->plat->has_gmac4 || priv->plat->has_xgmac)
+	if (priv->plat->has_gmac4 || priv->plat->has_emac3 || priv->plat->has_xgmac)
 		desc = np;
 
 	/* Check if timestamp is available */
@@ -833,7 +834,7 @@ static int stmmac_hwtstamp_get(struct net_device *dev, struct ifreq *ifr)
  */
 int stmmac_init_tstamp_counter(struct stmmac_priv *priv, u32 systime_flags)
 {
-	bool xmac = priv->plat->has_gmac4 || priv->plat->has_xgmac;
+	bool xmac = priv->plat->has_gmac4 || priv->plat->has_emac3 || priv->plat->has_xgmac;
 	struct timespec64 now;
 	u32 sec_inc = 0;
 	u64 temp = 0;
@@ -881,7 +882,7 @@ EXPORT_SYMBOL_GPL(stmmac_init_tstamp_counter);
  */
 static int stmmac_init_ptp(struct stmmac_priv *priv)
 {
-	bool xmac = priv->plat->has_gmac4 || priv->plat->has_xgmac;
+	bool xmac = priv->plat->has_gmac4 || priv->plat->has_emac3 || priv->plat->has_xgmac;
 	int ret;
 
 	if (priv->plat->ptp_clk_freq_config)
@@ -1207,7 +1208,7 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 	if (!max_speed || max_speed >= 1000)
 		priv->phylink_config.mac_capabilities |= MAC_1000;
 
-	if (priv->plat->has_gmac4) {
+	if (priv->plat->has_gmac4 || priv->plat->has_emac3) {
 		if (!max_speed || max_speed >= 2500)
 			priv->phylink_config.mac_capabilities |= MAC_2500FD;
 	} else if (priv->plat->has_xgmac) {
@@ -4343,7 +4344,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (skb_is_gso(skb) && priv->tso) {
 		if (gso & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6))
 			return stmmac_tso_xmit(skb, dev);
-		if (priv->plat->has_gmac4 && (gso & SKB_GSO_UDP_L4))
+		if ((priv->plat->has_gmac4 || priv->plat->has_emac3) && (gso & SKB_GSO_UDP_L4))
 			return stmmac_tso_xmit(skb, dev);
 	}
 
@@ -5721,7 +5722,7 @@ static void stmmac_common_interrupt(struct stmmac_priv *priv)
 	u32 queue;
 	bool xmac;
 
-	xmac = priv->plat->has_gmac4 || priv->plat->has_xgmac;
+	xmac = priv->plat->has_gmac4 || priv->plat->has_emac3 || priv->plat->has_xgmac;
 	queues_count = (rx_cnt > tx_cnt) ? rx_cnt : tx_cnt;
 
 	if (priv->irq_wake)
@@ -7165,7 +7166,7 @@ int stmmac_dvr_probe(struct device *device,
 
 	if ((priv->plat->tso_en) && (priv->dma_cap.tsoen)) {
 		ndev->hw_features |= NETIF_F_TSO | NETIF_F_TSO6;
-		if (priv->plat->has_gmac4)
+		if (priv->plat->has_gmac4 || priv->plat->has_emac3)
 			ndev->hw_features |= NETIF_F_GSO_UDP_L4;
 		priv->tso = true;
 		dev_info(priv->device, "TSO feature enabled\n");
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 6807c4c1a0a2..9e3d8e1202bd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -281,7 +281,7 @@ static int stmmac_mdio_read_c22(struct mii_bus *bus, int phyaddr, int phyreg)
 	value |= (phyreg << priv->hw->mii.reg_shift) & priv->hw->mii.reg_mask;
 	value |= (priv->clk_csr << priv->hw->mii.clk_csr_shift)
 		& priv->hw->mii.clk_csr_mask;
-	if (priv->plat->has_gmac4)
+	if (priv->plat->has_gmac4 || priv->plat->has_emac3)
 		value |= MII_GMAC4_READ;
 
 	data = stmmac_mdio_read(priv, data, value);
@@ -381,7 +381,7 @@ static int stmmac_mdio_write_c22(struct mii_bus *bus, int phyaddr, int phyreg,
 
 	value |= (priv->clk_csr << priv->hw->mii.clk_csr_shift)
 		& priv->hw->mii.clk_csr_mask;
-	if (priv->plat->has_gmac4)
+	if (priv->plat->has_gmac4 || priv->plat->has_emac3)
 		value |= MII_GMAC4_WRITE;
 	else
 		value |= MII_WRITE;
@@ -482,7 +482,7 @@ int stmmac_mdio_reset(struct mii_bus *bus)
 	 * on MDC, so perform a dummy mdio read. To be updated for GMAC4
 	 * if needed.
 	 */
-	if (!priv->plat->has_gmac4)
+	if (!priv->plat->has_gmac4 && !priv->plat->has_emac3)
 		writel(0, priv->ioaddr + mii_address);
 #endif
 	return 0;
@@ -568,7 +568,7 @@ int stmmac_mdio_register(struct net_device *ndev)
 	} else {
 		new_bus->read = &stmmac_mdio_read_c22;
 		new_bus->write = &stmmac_mdio_write_c22;
-		if (priv->plat->has_gmac4) {
+		if (priv->plat->has_gmac4 || priv->plat->has_emac3) {
 			new_bus->read_c45 = &stmmac_mdio_read_c45;
 			new_bus->write_c45 = &stmmac_mdio_write_c45;
 		}
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index b4388ca8d211..9a8f9630d6af 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -56,7 +56,7 @@ static int stmmac_adjust_time(struct ptp_clock_info *ptp, s64 delta)
 	bool xmac, est_rst = false;
 	int ret;
 
-	xmac = priv->plat->has_gmac4 || priv->plat->has_xgmac;
+	xmac = priv->plat->has_gmac4 || priv->plat->has_emac3 || priv->plat->has_xgmac;
 
 	if (delta < 0) {
 		neg_adj = 1;
@@ -292,7 +292,7 @@ void stmmac_ptp_register(struct stmmac_priv *priv)
 
 	/* Calculate the clock domain crossing (CDC) error if necessary */
 	priv->plat->cdc_error_adj = 0;
-	if (priv->plat->has_gmac4 && priv->plat->clk_ptp_rate)
+	if ((priv->plat->has_gmac4 || priv->plat->has_emac3) && priv->plat->clk_ptp_rate)
 		priv->plat->cdc_error_adj = (2 * NSEC_PER_SEC) / priv->plat->clk_ptp_rate;
 
 	stmmac_ptp_clock_ops.n_per_out = priv->dma_cap.pps_out_num;
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index a152678b82b7..de2d0a8693c8 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -248,6 +248,7 @@ struct plat_stmmacenet_data {
 	struct stmmac_axi *axi;
 	int has_gmac4;
 	bool has_sun8i;
+	bool has_emac3;
 	bool tso_en;
 	int rss_en;
 	int mac_port_sel_speed;
-- 
2.39.2

