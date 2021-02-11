Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A3C3191D4
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 19:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbhBKSGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 13:06:00 -0500
Received: from relay02.th.seeweb.it ([5.144.164.163]:46479 "EHLO
        relay02.th.seeweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232643AbhBKSBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 13:01:49 -0500
Received: from IcarusMOD.eternityproject.eu (unknown [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by m-r1.th.seeweb.it (Postfix) with ESMTPSA id 9F94C1F67B;
        Thu, 11 Feb 2021 18:50:17 +0100 (CET)
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
Subject: [PATCH v1 1/7] net: ipa: Add support for IPA v3.1 with GSI v1.0
Date:   Thu, 11 Feb 2021 18:50:09 +0100
Message-Id: <20210211175015.200772-2-angelogioacchino.delregno@somainline.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210211175015.200772-1-angelogioacchino.delregno@somainline.org>
References: <20210211175015.200772-1-angelogioacchino.delregno@somainline.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for adding support for the MSM8998 SoC's IPA,
add the necessary bits for IPA version 3.1 featuring GSI 1.0,
found on at least MSM8998.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
---
 drivers/net/ipa/gsi.c          |  8 ++++----
 drivers/net/ipa/ipa_endpoint.c | 17 +++++++++--------
 drivers/net/ipa/ipa_main.c     |  8 ++++++--
 drivers/net/ipa/ipa_reg.h      |  3 +++
 drivers/net/ipa/ipa_version.h  |  1 +
 5 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 14d9a791924b..6315336b3ca8 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -794,14 +794,14 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 
 	/* Max prefetch is 1 segment (do not set MAX_PREFETCH_FMASK) */
 
-	/* We enable the doorbell engine for IPA v3.5.1 */
-	if (gsi->version == IPA_VERSION_3_5_1 && doorbell)
+	/* We enable the doorbell engine for IPA v3.x */
+	if (gsi->version < IPA_VERSION_4_0 && doorbell)
 		val |= USE_DB_ENG_FMASK;
 
 	/* v4.0 introduces an escape buffer for prefetch.  We use it
 	 * on all but the AP command channel.
 	 */
-	if (gsi->version != IPA_VERSION_3_5_1 && !channel->command) {
+	if (gsi->version >= IPA_VERSION_4_0 && !channel->command) {
 		/* If not otherwise set, prefetch buffers are used */
 		if (gsi->version < IPA_VERSION_4_5)
 			val |= USE_ESCAPE_BUF_ONLY_FMASK;
@@ -899,7 +899,7 @@ void gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool doorbell)
 
 	gsi_channel_reset_command(channel);
 	/* Due to a hardware quirk we may need to reset RX channels twice. */
-	if (gsi->version == IPA_VERSION_3_5_1 && !channel->toward_ipa)
+	if (gsi->version <= IPA_VERSION_3_5_1 && !channel->toward_ipa)
 		gsi_channel_reset_command(channel);
 
 	gsi_channel_program(channel, doorbell);
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 9f4be9812a1f..06d8aa34276e 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -347,7 +347,7 @@ ipa_endpoint_program_suspend(struct ipa_endpoint *endpoint, bool enable)
 {
 	bool suspended;
 
-	if (endpoint->ipa->version != IPA_VERSION_3_5_1)
+	if (endpoint->ipa->version >= IPA_VERSION_4_0)
 		return enable;	/* For IPA v4.0+, no change made */
 
 	/* assert(!endpoint->toward_ipa); */
@@ -1422,11 +1422,12 @@ static void ipa_endpoint_reset(struct ipa_endpoint *endpoint)
 	bool special;
 	int ret = 0;
 
-	/* On IPA v3.5.1, if an RX endpoint is reset while aggregation
-	 * is active, we need to handle things specially to recover.
+	/* On IPA v3.5.1 and older, if an RX endpoint is reset while
+	 * aggregation is active, we need to handle things in a special
+	 * way in order to recover.
 	 * All other cases just need to reset the underlying GSI channel.
 	 */
-	special = ipa->version == IPA_VERSION_3_5_1 &&
+	special = ipa->version <= IPA_VERSION_3_5_1 &&
 			!endpoint->toward_ipa &&
 			endpoint->data->aggregation;
 	if (special && ipa_endpoint_aggr_active(endpoint))
@@ -1525,8 +1526,8 @@ void ipa_endpoint_suspend_one(struct ipa_endpoint *endpoint)
 		(void)ipa_endpoint_program_suspend(endpoint, true);
 	}
 
-	/* IPA v3.5.1 doesn't use channel stop for suspend */
-	stop_channel = endpoint->ipa->version != IPA_VERSION_3_5_1;
+	/* IPA v3.x doesn't use channel stop for suspend */
+	stop_channel = endpoint->ipa->version >= IPA_VERSION_4_0;
 	ret = gsi_channel_suspend(gsi, endpoint->channel_id, stop_channel);
 	if (ret)
 		dev_err(dev, "error %d suspending channel %u\n", ret,
@@ -1546,8 +1547,8 @@ void ipa_endpoint_resume_one(struct ipa_endpoint *endpoint)
 	if (!endpoint->toward_ipa)
 		(void)ipa_endpoint_program_suspend(endpoint, false);
 
-	/* IPA v3.5.1 doesn't use channel start for resume */
-	start_channel = endpoint->ipa->version != IPA_VERSION_3_5_1;
+	/* IPA v3.x doesn't use channel start for resume */
+	start_channel = endpoint->ipa->version >= IPA_VERSION_4_0;
 	ret = gsi_channel_resume(gsi, endpoint->channel_id, start_channel);
 	if (ret)
 		dev_err(dev, "error %d resuming channel %u\n", ret,
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 84bb8ae92725..be191993fbec 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -228,8 +228,8 @@ static void ipa_hardware_config_comp(struct ipa *ipa)
 {
 	u32 val;
 
-	/* Nothing to configure for IPA v3.5.1 */
-	if (ipa->version == IPA_VERSION_3_5_1)
+	/* Nothing to configure for IPA v3.5.1 and below */
+	if (ipa->version <= IPA_VERSION_3_5_1)
 		return;
 
 	val = ioread32(ipa->reg_virt + IPA_REG_COMP_CFG_OFFSET);
@@ -276,6 +276,7 @@ static void ipa_hardware_config_qsb(struct ipa *ipa)
 
 	max1 = 12;
 	switch (version) {
+	case IPA_VERSION_3_1:
 	case IPA_VERSION_3_5_1:
 		max0 = 8;
 		break;
@@ -404,6 +405,9 @@ static void ipa_hardware_config(struct ipa *ipa)
 		/* Enable open global clocks (not needed for IPA v4.5) */
 		val = GLOBAL_FMASK;
 		val |= GLOBAL_2X_CLK_FMASK;
+		if (version == IPA_VERSION_3_1)
+			val |= MISC_FMASK;
+
 		iowrite32(val, ipa->reg_virt + IPA_REG_CLKON_CFG_OFFSET);
 
 		/* Disable PA mask to allow HOLB drop */
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index e6b0827a244e..9b9d6e0397bb 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -199,6 +199,9 @@ static inline u32 ipa_reg_state_aggr_active_offset(enum ipa_version version)
 /* Backward compatibility register value to use for each version */
 static inline u32 ipa_reg_bcr_val(enum ipa_version version)
 {
+	if (version == IPA_VERSION_3_1)
+		return BCR_CMDQ_L_LACK_ONE_ENTRY_FMASK;
+
 	if (version == IPA_VERSION_3_5_1)
 		return BCR_CMDQ_L_LACK_ONE_ENTRY_FMASK |
 			BCR_TX_NOT_USING_BRESP_FMASK |
diff --git a/drivers/net/ipa/ipa_version.h b/drivers/net/ipa/ipa_version.h
index 2944e2a89023..47f68975d576 100644
--- a/drivers/net/ipa/ipa_version.h
+++ b/drivers/net/ipa/ipa_version.h
@@ -14,6 +14,7 @@
  * it where it's needed.
  */
 enum ipa_version {
+	IPA_VERSION_3_1,	/* GSI version 1.0 */
 	IPA_VERSION_3_5_1,	/* GSI version 1.3.0 */
 	IPA_VERSION_4_0,	/* GSI version 2.0 */
 	IPA_VERSION_4_1,	/* GSI version 2.1 */
-- 
2.30.0

