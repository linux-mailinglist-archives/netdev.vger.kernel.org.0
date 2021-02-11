Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759AA3191D0
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 19:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbhBKSFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 13:05:09 -0500
Received: from m-r1.th.seeweb.it ([5.144.164.170]:37289 "EHLO
        m-r1.th.seeweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbhBKSBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 13:01:46 -0500
Received: from IcarusMOD.eternityproject.eu (unknown [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by m-r1.th.seeweb.it (Postfix) with ESMTPSA id 9E3621F8CC;
        Thu, 11 Feb 2021 18:50:18 +0100 (CET)
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>
To:     elder@kernel.org
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, konrad.dybcio@somainline.org,
        marijn.suijten@somainline.org, phone-devel@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>
Subject: [PATCH v1 4/7] net: ipa: gsi: Use right masks for GSI v1.0 channels hw param
Date:   Thu, 11 Feb 2021 18:50:12 +0100
Message-Id: <20210211175015.200772-5-angelogioacchino.delregno@somainline.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210211175015.200772-1-angelogioacchino.delregno@somainline.org>
References: <20210211175015.200772-1-angelogioacchino.delregno@somainline.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In GSI v1.0 the register GSI_HW_PARAM_2_OFFSET has different layout
so the number of channels and events per EE are, of course, laid out
in 8 bits each (0-7, 8-15 respectively).

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
---
 drivers/net/ipa/gsi.c     | 16 +++++++++++++---
 drivers/net/ipa/gsi_reg.h |  5 +++++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index b5460cbb085c..3311ffe514c9 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1790,7 +1790,7 @@ static void gsi_channel_teardown(struct gsi *gsi)
 int gsi_setup(struct gsi *gsi)
 {
 	struct device *dev = gsi->dev;
-	u32 val;
+	u32 val, mask;
 	int ret;
 
 	/* Here is where we first touch the GSI hardware */
@@ -1804,7 +1804,12 @@ int gsi_setup(struct gsi *gsi)
 
 	val = ioread32(gsi->virt + GSI_GSI_HW_PARAM_2_OFFSET);
 
-	gsi->channel_count = u32_get_bits(val, NUM_CH_PER_EE_FMASK);
+	if (gsi->version == IPA_VERSION_3_1)
+		mask = GSIV1_NUM_CH_PER_EE_FMASK;
+	else
+		mask = NUM_CH_PER_EE_FMASK;
+
+	gsi->channel_count = u32_get_bits(val, mask);
 	if (!gsi->channel_count) {
 		dev_err(dev, "GSI reports zero channels supported\n");
 		return -EINVAL;
@@ -1816,7 +1821,12 @@ int gsi_setup(struct gsi *gsi)
 		gsi->channel_count = GSI_CHANNEL_COUNT_MAX;
 	}
 
-	gsi->evt_ring_count = u32_get_bits(val, NUM_EV_PER_EE_FMASK);
+	if (gsi->version == IPA_VERSION_3_1)
+		mask = GSIV1_NUM_EV_PER_EE_FMASK;
+	else
+		mask = NUM_EV_PER_EE_FMASK;
+
+	gsi->evt_ring_count = u32_get_bits(val, mask);
 	if (!gsi->evt_ring_count) {
 		dev_err(dev, "GSI reports zero event rings supported\n");
 		return -EINVAL;
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 0e138bbd8205..4ba579fa21c2 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -287,6 +287,11 @@ enum gsi_generic_cmd_opcode {
 			GSI_EE_N_GSI_HW_PARAM_2_OFFSET(GSI_EE_AP)
 #define GSI_EE_N_GSI_HW_PARAM_2_OFFSET(ee) \
 			(0x0001f040 + 0x4000 * (ee))
+
+/* Fields below are present for IPA v3.1 with GSI version 1 */
+#define GSIV1_NUM_EV_PER_EE_FMASK	GENMASK(8, 0)
+#define GSIV1_NUM_CH_PER_EE_FMASK	GENMASK(15, 8)
+/* Fields below are present for IPA v3.5.1 and above */
 #define IRAM_SIZE_FMASK			GENMASK(2, 0)
 #define NUM_CH_PER_EE_FMASK		GENMASK(7, 3)
 #define NUM_EV_PER_EE_FMASK		GENMASK(12, 8)
-- 
2.30.0

