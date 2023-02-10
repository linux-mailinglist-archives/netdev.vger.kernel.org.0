Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E3A692693
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233397AbjBJThn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbjBJThW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:37:22 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C6D635B6
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:37:06 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id f10so2634483ilc.7
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:37:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yrjpOQ5PyUgBoNq9yeh1Ov+P8hCPcq4uINfISBVVx+U=;
        b=vHssYi2aL2G2sjfXDq7SFZxvDtxI5bBkLrStXqUuvF5dphOZLxYFC34a/Qe2lLV2Ds
         +V8qU+gV/lKwG9mPCATCD74UtqPkPVX8fh6u+yOnoJkIeMh7snlh+WF1xWvzUZ0TRO5d
         PkJ1EOsuZTzOsaWI/6hOuaglGczBcwyTMwUtFT9j8nq/DCK/yGzjiEi+kbTLQlE2/9v2
         vcLEGSoc4Ia1bAE6AtPlPrydLRWmHwEsn1etQ3/PaKd4RIM/B6I+xSqaIqP7PQHqEWFX
         q5W3is51GcTA1LUCtXatd0OYkT6AaZT+3BGX++sB14XSBitxLh7numP3V595/nOI2oeL
         fTew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yrjpOQ5PyUgBoNq9yeh1Ov+P8hCPcq4uINfISBVVx+U=;
        b=SJZhR8eaGqVuMFn+DLB12rukRV8ePoAN9Q/WID6o6++8rj0hSs1Oxd4t3AD3kInt16
         //2xanL/+ym2UiZklPG76RBDvmuZV1OlhPqdVIPYS8BTRTUnK1wlTCu6aS04hiLeWoOu
         IFivtviRdInzM5jkqfUE5m1o8HExQt8dmXpNUMyHDf6p0Vb4OUtp7Y1FrFsgJB1ZF4/Y
         eRiMGFFXN5QB6qyJkg/9G2jjgP5V92U9O7W1+KOnvEeyJAQ9HY2ymkuga7azmFs8fmsN
         BeUryAPZ/0f63tAgAEiztWlSWQ21cQSjzA3dfgf/n7t9ijm9bA5j9NrNUIGdxeR+3i/r
         aJ5w==
X-Gm-Message-State: AO0yUKXw2W9Rhcm2VjucP8MlhTPeneIRYODw3Us+cs3cg9CFL8b2NFKv
        RBJ6mD/eEsBArn5blzAXwOTA4A==
X-Google-Smtp-Source: AK7set/KFT81zzZvCjIB68GW0JK83cEA9KBrrm/p1qS9E85yoWFFndXd5XdW5XIrpO6XzWLmoXYPrg==
X-Received: by 2002:a05:6e02:1e09:b0:314:20d5:c775 with SMTP id g9-20020a056e021e0900b0031420d5c775mr2142428ila.4.1676057826018;
        Fri, 10 Feb 2023 11:37:06 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id 14-20020a056e020cae00b00304ae88ebebsm1530692ilg.88.2023.02.10.11.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 11:37:05 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/8] net: ipa: add more GSI register definitions
Date:   Fri, 10 Feb 2023 13:36:51 -0600
Message-Id: <20230210193655.460225-5-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230210193655.460225-1-elder@linaro.org>
References: <20230210193655.460225-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Continue populating with GSI register definitions, adding remaining
registers whose offset depends on a channel ID.  Use gsi_reg() and
reg_n_offset() to determine offsets for those registers, and get rid
of the corresponding GSI_CH_C_*_OFFSET() macros.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c              | 41 +++++++++++++++++++++---------
 drivers/net/ipa/gsi_reg.h          | 27 +-------------------
 drivers/net/ipa/reg/gsi_reg-v3.1.c | 32 +++++++++++++++++++++++
 3 files changed, 62 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index f07b7554d21fd..a41e8418b62ae 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -500,11 +500,14 @@ static void gsi_evt_ring_de_alloc_command(struct gsi *gsi, u32 evt_ring_id)
 /* Fetch the current state of a channel from hardware */
 static enum gsi_channel_state gsi_channel_state(struct gsi_channel *channel)
 {
+	const struct reg *reg = gsi_reg(channel->gsi, CH_C_CNTXT_0);
 	u32 channel_id = gsi_channel_id(channel);
-	void __iomem *virt = channel->gsi->virt;
+	struct gsi *gsi = channel->gsi;
+	void __iomem *virt = gsi->virt;
 	u32 val;
 
-	val = ioread32(virt + GSI_CH_C_CNTXT_0_OFFSET(channel_id));
+	reg = gsi_reg(gsi, CH_C_CNTXT_0);
+	val = ioread32(virt + reg_n_offset(reg, channel_id));
 
 	return u32_get_bits(val, CHSTATE_FMASK);
 }
@@ -799,27 +802,34 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 	struct gsi *gsi = channel->gsi;
 	const struct reg *reg;
 	u32 wrr_weight = 0;
+	u32 offset;
 	u32 val;
 
+	reg = gsi_reg(gsi, CH_C_CNTXT_0);
+
 	/* We program all channels as GPI type/protocol */
 	val = ch_c_cntxt_0_type_encode(gsi->version, GSI_CHANNEL_TYPE_GPI);
 	if (channel->toward_ipa)
 		val |= CHTYPE_DIR_FMASK;
 	val |= u32_encode_bits(channel->evt_ring_id, ERINDEX_FMASK);
 	val |= u32_encode_bits(GSI_RING_ELEMENT_SIZE, ELEMENT_SIZE_FMASK);
-	iowrite32(val, gsi->virt + GSI_CH_C_CNTXT_0_OFFSET(channel_id));
+	iowrite32(val, gsi->virt + reg_n_offset(reg, channel_id));
 
+	reg = gsi_reg(gsi, CH_C_CNTXT_1);
 	val = ch_c_cntxt_1_length_encode(gsi->version, size);
-	iowrite32(val, gsi->virt + GSI_CH_C_CNTXT_1_OFFSET(channel_id));
+	iowrite32(val, gsi->virt + reg_n_offset(reg, channel_id));
 
 	/* The context 2 and 3 registers store the low-order and
 	 * high-order 32 bits of the address of the channel ring,
 	 * respectively.
 	 */
+	reg = gsi_reg(gsi, CH_C_CNTXT_2);
 	val = lower_32_bits(channel->tre_ring.addr);
-	iowrite32(val, gsi->virt + GSI_CH_C_CNTXT_2_OFFSET(channel_id));
+	iowrite32(val, gsi->virt + reg_n_offset(reg, channel_id));
+
+	reg = gsi_reg(gsi, CH_C_CNTXT_3);
 	val = upper_32_bits(channel->tre_ring.addr);
-	iowrite32(val, gsi->virt + GSI_CH_C_CNTXT_3_OFFSET(channel_id));
+	iowrite32(val, gsi->virt + reg_n_offset(reg, channel_id));
 
 	reg = gsi_reg(gsi, CH_C_QOS);
 
@@ -857,22 +867,27 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 					GSI_RING_ELEMENT_SIZE;
 	gpi->outstanding_threshold = 2 * GSI_RING_ELEMENT_SIZE;
 
+	reg = gsi_reg(gsi, CH_C_SCRATCH_0);
 	val = scr.data.word1;
-	iowrite32(val, gsi->virt + GSI_CH_C_SCRATCH_0_OFFSET(channel_id));
+	iowrite32(val, gsi->virt + reg_n_offset(reg, channel_id));
 
+	reg = gsi_reg(gsi, CH_C_SCRATCH_1);
 	val = scr.data.word2;
-	iowrite32(val, gsi->virt + GSI_CH_C_SCRATCH_1_OFFSET(channel_id));
+	iowrite32(val, gsi->virt + reg_n_offset(reg, channel_id));
 
+	reg = gsi_reg(gsi, CH_C_SCRATCH_2);
 	val = scr.data.word3;
-	iowrite32(val, gsi->virt + GSI_CH_C_SCRATCH_2_OFFSET(channel_id));
+	iowrite32(val, gsi->virt + reg_n_offset(reg, channel_id));
 
 	/* We must preserve the upper 16 bits of the last scratch register.
 	 * The next sequence assumes those bits remain unchanged between the
 	 * read and the write.
 	 */
-	val = ioread32(gsi->virt + GSI_CH_C_SCRATCH_3_OFFSET(channel_id));
+	reg = gsi_reg(gsi, CH_C_SCRATCH_3);
+	offset = reg_n_offset(reg, channel_id);
+	val = ioread32(gsi->virt + offset);
 	val = (scr.data.word4 & GENMASK(31, 16)) | (val & GENMASK(15, 0));
-	iowrite32(val, gsi->virt + GSI_CH_C_SCRATCH_3_OFFSET(channel_id));
+	iowrite32(val, gsi->virt + offset);
 
 	/* All done! */
 }
@@ -1506,11 +1521,13 @@ void gsi_channel_doorbell(struct gsi_channel *channel)
 	struct gsi_ring *tre_ring = &channel->tre_ring;
 	u32 channel_id = gsi_channel_id(channel);
 	struct gsi *gsi = channel->gsi;
+	const struct reg *reg;
 	u32 val;
 
+	reg = gsi_reg(gsi, CH_C_DOORBELL_0);
 	/* Note: index *must* be used modulo the ring count here */
 	val = gsi_ring_addr(tre_ring, tre_ring->index % tre_ring->count);
-	iowrite32(val, gsi->virt + GSI_CH_C_DOORBELL_0_OFFSET(channel_id));
+	iowrite32(val, gsi->virt + reg_n_offset(reg, channel_id));
 }
 
 /* Consult hardware, move newly completed transactions to completed state */
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 398546fbfd697..9faa0b2fefa55 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -105,8 +105,7 @@ enum gsi_reg_id {
 
 /* All other register offsets are relative to gsi->virt */
 
-#define GSI_CH_C_CNTXT_0_OFFSET(ch) \
-			(0x0001c000 + 0x4000 * GSI_EE_AP + 0x80 * (ch))
+/* CH_C_CNTXT_0 register */
 #define CHTYPE_PROTOCOL_FMASK		GENMASK(2, 0)
 #define CHTYPE_DIR_FMASK		GENMASK(3, 3)
 #define EE_FMASK			GENMASK(7, 4)
@@ -131,15 +130,6 @@ enum gsi_channel_type {
 	GSI_CHANNEL_TYPE_11AD			= 0x9,
 };
 
-#define GSI_CH_C_CNTXT_1_OFFSET(ch) \
-			(0x0001c004 + 0x4000 * GSI_EE_AP + 0x80 * (ch))
-
-#define GSI_CH_C_CNTXT_2_OFFSET(ch) \
-			(0x0001c008 + 0x4000 * GSI_EE_AP + 0x80 * (ch))
-
-#define GSI_CH_C_CNTXT_3_OFFSET(ch) \
-			(0x0001c00c + 0x4000 * GSI_EE_AP + 0x80 * (ch))
-
 /* CH_C_QOS register */
 #define WRR_WEIGHT_FMASK		GENMASK(3, 0)
 #define MAX_PREFETCH_FMASK		GENMASK(8, 8)
@@ -160,18 +150,6 @@ enum gsi_prefetch_mode {
 	GSI_FREE_PREFETCH			= 0x3,
 };
 
-#define GSI_CH_C_SCRATCH_0_OFFSET(ch) \
-			(0x0001c060 + 0x4000 * GSI_EE_AP + 0x80 * (ch))
-
-#define GSI_CH_C_SCRATCH_1_OFFSET(ch) \
-			(0x0001c064 + 0x4000 * GSI_EE_AP + 0x80 * (ch))
-
-#define GSI_CH_C_SCRATCH_2_OFFSET(ch) \
-			(0x0001c068 + 0x4000 * GSI_EE_AP + 0x80 * (ch))
-
-#define GSI_CH_C_SCRATCH_3_OFFSET(ch) \
-			(0x0001c06c + 0x4000 * GSI_EE_AP + 0x80 * (ch))
-
 #define GSI_EV_CH_E_CNTXT_0_OFFSET(ev) \
 			(0x0001d000 + 0x4000 * GSI_EE_AP + 0x80 * (ev))
 /* enum gsi_channel_type defines EV_CHTYPE field values in EV_CH_E_CNTXT_0 */
@@ -221,9 +199,6 @@ enum gsi_prefetch_mode {
 #define GSI_EV_CH_E_SCRATCH_1_OFFSET(ev) \
 			(0x0001d04c + 0x4000 * GSI_EE_AP + 0x80 * (ev))
 
-#define GSI_CH_C_DOORBELL_0_OFFSET(ch) \
-			(0x0001e000 + 0x4000 * GSI_EE_AP + 0x08 * (ch))
-
 #define GSI_EV_CH_E_DOORBELL_0_OFFSET(ev) \
 			(0x0001e100 + 0x4000 * GSI_EE_AP + 0x08 * (ev))
 
diff --git a/drivers/net/ipa/reg/gsi_reg-v3.1.c b/drivers/net/ipa/reg/gsi_reg-v3.1.c
index c4d4beb7738f3..86e4e05341543 100644
--- a/drivers/net/ipa/reg/gsi_reg-v3.1.c
+++ b/drivers/net/ipa/reg/gsi_reg-v3.1.c
@@ -8,10 +8,42 @@
 #include "../reg.h"
 #include "../gsi_reg.h"
 
+REG_STRIDE(CH_C_CNTXT_0, ch_c_cntxt_0, 0x0001c000 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_CNTXT_1, ch_c_cntxt_1, 0x0001c004 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_CNTXT_2, ch_c_cntxt_2, 0x0001c008 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_CNTXT_3, ch_c_cntxt_3, 0x0001c00c + 0x4000 * GSI_EE_AP, 0x80);
+
 REG_STRIDE(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
 
+REG_STRIDE(CH_C_SCRATCH_0, ch_c_scratch_0,
+	   0x0001c060 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_SCRATCH_1, ch_c_scratch_1,
+	   0x0001c064 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_SCRATCH_2, ch_c_scratch_2,
+	   0x0001c068 + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_SCRATCH_3, ch_c_scratch_3,
+	   0x0001c06c + 0x4000 * GSI_EE_AP, 0x80);
+
+REG_STRIDE(CH_C_DOORBELL_0, ch_c_doorbell_0,
+	   0x0001e000 + 0x4000 * GSI_EE_AP, 0x08);
+
 static const struct reg *reg_array[] = {
+	[CH_C_CNTXT_0]			= &reg_ch_c_cntxt_0,
+	[CH_C_CNTXT_1]			= &reg_ch_c_cntxt_1,
+	[CH_C_CNTXT_2]			= &reg_ch_c_cntxt_2,
+	[CH_C_CNTXT_3]			= &reg_ch_c_cntxt_3,
 	[CH_C_QOS]			= &reg_ch_c_qos,
+	[CH_C_SCRATCH_0]		= &reg_ch_c_scratch_0,
+	[CH_C_SCRATCH_1]		= &reg_ch_c_scratch_1,
+	[CH_C_SCRATCH_2]		= &reg_ch_c_scratch_2,
+	[CH_C_SCRATCH_3]		= &reg_ch_c_scratch_3,
+	[CH_C_DOORBELL_0]		= &reg_ch_c_doorbell_0,
 };
 
 const struct regs gsi_regs_v3_1 = {
-- 
2.34.1

