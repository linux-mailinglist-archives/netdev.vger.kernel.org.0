Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9858D69269E
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbjBJTiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbjBJThf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:37:35 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96361F48F
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:37:11 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id t7so971115ilq.2
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KRszq2iplNCr1xrqhK7IkpicDth/Nx/tTLRGbmTeeR0=;
        b=OSW1v/lUNQx1j+pnXh38NQ2MS8zKPYpHHuphMWLyEbTtrg0LMsMs9zxpnoj+7ARTCb
         2x5lWWaqc8z8O92CE1XxI7VSO40oAyXz13kxEe9634ZDwoOCBWvp/h9HmeLg6ytuUBLU
         jbBBfnuvJc99zLzGQu+9i9K4jgClmVdCP0b/ye5hyHoXyQLp/Xn9zhejnLUhmxKcJV01
         z4WHd0w8bwGPuuleDvvM1iTTWb6dp1Py+NIVfKZtm4r8Nrl1uBSe/MKnGceVhqRIXbnE
         zn942U7AkbvaUwSQwMnaSbstEl/0CXv9lP0gsilqrZJ5IpWzi97b/cJDpJhluiEEpBN+
         51Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KRszq2iplNCr1xrqhK7IkpicDth/Nx/tTLRGbmTeeR0=;
        b=axozpi0FLweobeIRYUp8SaI+30uj8caTopEu7Z8YyMhq/65L9Jt1dDzqUaNN6vR/p6
         0dka99rg7RvwI9TpJ9E535nlngkXc1i2QfgwjbVca+MD4GMK6/vrqYpxfY4/bPQ5MSEv
         ZQ0Mp4QvWHOfYJ4DFMYcVE5x1JVNOCjUQpCzrpwhYl8aSxSsT7PF0FdsXMmtYdW1CVFP
         05v7mppfToYWWAlM8iJhSjR+W25rSfx3yMAhE4NgaTHAHr6x1fXquwZnbygWLozApe2N
         r6hgY21MiljxuC4cWklXJ6RhUbiHR2zsOuoeEtio0x8sYtShQteLMniRYYK9D4V5/q9t
         brqQ==
X-Gm-Message-State: AO0yUKUjiXNSzY8nUtI/6HLlf/teAkI3U6mFfeKwrS1KXZKa5xqs4ABl
        V0J0jBaoj1YT70+60lGoapQHCmX2Fyho3vh+
X-Google-Smtp-Source: AK7set+nlqxL+NeNXASRKSSV2QeHtYAc6cKAtgmJwZw04Adz0+WPW3sSYj5hKoULI19YzgYi3z7A8A==
X-Received: by 2002:a05:6e02:2144:b0:310:ea3e:7fad with SMTP id d4-20020a056e02214400b00310ea3e7fadmr17863562ilv.26.1676057831239;
        Fri, 10 Feb 2023 11:37:11 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id 14-20020a056e020cae00b00304ae88ebebsm1530692ilg.88.2023.02.10.11.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 11:37:10 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 8/8] net: ipa: define IPA remaining GSI register offsets
Date:   Fri, 10 Feb 2023 13:36:55 -0600
Message-Id: <20230210193655.460225-9-elder@linaro.org>
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

Add the remaining GSI register offset definitions.  Use gsi_reg()
rather than the corresponding GSI_*_OFFSET() macros to get the
offsets for these registers, and get rid of the macros.

Note that we are now defining information for the HW_PARAM_2
register, and that doesn't appear until IPA v3.5.1.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c                | 36 +++++++++++++++++++++-------
 drivers/net/ipa/gsi_reg.c            |  4 +++-
 drivers/net/ipa/gsi_reg.h            | 24 ++++++-------------
 drivers/net/ipa/reg/gsi_reg-v3.1.c   | 18 ++++++++++++++
 drivers/net/ipa/reg/gsi_reg-v3.5.1.c | 21 ++++++++++++++++
 5 files changed, 76 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index ee8ca514eb533..bdc1f8e8e4282 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -437,16 +437,18 @@ static void gsi_evt_ring_command(struct gsi *gsi, u32 evt_ring_id,
 				 enum gsi_evt_cmd_opcode opcode)
 {
 	struct device *dev = gsi->dev;
+	const struct reg *reg;
 	bool timeout;
 	u32 val;
 
 	/* Enable the completion interrupt for the command */
 	gsi_irq_ev_ctrl_enable(gsi, evt_ring_id);
 
+	reg = gsi_reg(gsi, EV_CH_CMD);
 	val = u32_encode_bits(evt_ring_id, EV_CHID_FMASK);
 	val |= u32_encode_bits(opcode, EV_OPCODE_FMASK);
 
-	timeout = !gsi_command(gsi, GSI_EV_CH_CMD_OFFSET, val);
+	timeout = !gsi_command(gsi, reg_offset(reg), val);
 
 	gsi_irq_ev_ctrl_disable(gsi);
 
@@ -552,15 +554,18 @@ gsi_channel_command(struct gsi_channel *channel, enum gsi_ch_cmd_opcode opcode)
 	u32 channel_id = gsi_channel_id(channel);
 	struct gsi *gsi = channel->gsi;
 	struct device *dev = gsi->dev;
+	const struct reg *reg;
 	bool timeout;
 	u32 val;
 
 	/* Enable the completion interrupt for the command */
 	gsi_irq_ch_ctrl_enable(gsi, channel_id);
 
+	reg = gsi_reg(gsi, CH_CMD);
 	val = u32_encode_bits(channel_id, CH_CHID_FMASK);
 	val |= u32_encode_bits(opcode, CH_OPCODE_FMASK);
-	timeout = !gsi_command(gsi, GSI_CH_CMD_OFFSET, val);
+
+	timeout = !gsi_command(gsi, reg_offset(reg), val);
 
 	gsi_irq_ch_ctrl_disable(gsi);
 
@@ -1230,15 +1235,22 @@ static void gsi_isr_glob_err(struct gsi *gsi)
 {
 	enum gsi_err_type type;
 	enum gsi_err_code code;
+	const struct reg *reg;
+	u32 offset;
 	u32 which;
 	u32 val;
 	u32 ee;
 
 	/* Get the logged error, then reinitialize the log */
-	val = ioread32(gsi->virt + GSI_ERROR_LOG_OFFSET);
-	iowrite32(0, gsi->virt + GSI_ERROR_LOG_OFFSET);
-	iowrite32(~0, gsi->virt + GSI_ERROR_LOG_CLR_OFFSET);
+	reg = gsi_reg(gsi, ERROR_LOG);
+	offset = reg_offset(reg);
+	val = ioread32(gsi->virt + offset);
+	iowrite32(0, gsi->virt + offset);
 
+	reg = gsi_reg(gsi, ERROR_LOG_CLR);
+	iowrite32(~0, gsi->virt + reg_offset(reg));
+
+	/* Parse the error value */
 	ee = u32_get_bits(val, ERR_EE_FMASK);
 	type = u32_get_bits(val, ERR_TYPE_FMASK);
 	which = u32_get_bits(val, ERR_VIRT_IDX_FMASK);
@@ -1806,13 +1818,14 @@ static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
 	iowrite32(val, gsi->virt + offset);
 
 	/* Now issue the command */
+	reg = gsi_reg(gsi, GENERIC_CMD);
 	val = u32_encode_bits(opcode, GENERIC_OPCODE_FMASK);
 	val |= u32_encode_bits(channel_id, GENERIC_CHID_FMASK);
 	val |= u32_encode_bits(GSI_EE_MODEM, GENERIC_EE_FMASK);
 	if (gsi->version >= IPA_VERSION_4_11)
 		val |= u32_encode_bits(params, GENERIC_PARAMS_FMASK);
 
-	timeout = !gsi_command(gsi, GSI_GENERIC_CMD_OFFSET, val);
+	timeout = !gsi_command(gsi, reg_offset(reg), val);
 
 	/* Disable the GP_INT1 IRQ type again */
 	reg = gsi_reg(gsi, CNTXT_GLOB_IRQ_EN);
@@ -2025,6 +2038,7 @@ static void gsi_irq_teardown(struct gsi *gsi)
 static int gsi_ring_setup(struct gsi *gsi)
 {
 	struct device *dev = gsi->dev;
+	const struct reg *reg;
 	u32 count;
 	u32 val;
 
@@ -2036,7 +2050,8 @@ static int gsi_ring_setup(struct gsi *gsi)
 		return 0;
 	}
 
-	val = ioread32(gsi->virt + GSI_GSI_HW_PARAM_2_OFFSET);
+	reg = gsi_reg(gsi, HW_PARAM_2);
+	val = ioread32(gsi->virt + reg_offset(reg));
 
 	count = u32_get_bits(val, NUM_CH_PER_EE_FMASK);
 	if (!count) {
@@ -2069,11 +2084,13 @@ static int gsi_ring_setup(struct gsi *gsi)
 /* Setup function for GSI.  GSI firmware must be loaded and initialized */
 int gsi_setup(struct gsi *gsi)
 {
+	const struct reg *reg;
 	u32 val;
 	int ret;
 
 	/* Here is where we first touch the GSI hardware */
-	val = ioread32(gsi->virt + GSI_GSI_STATUS_OFFSET);
+	reg = gsi_reg(gsi, GSI_STATUS);
+	val = ioread32(gsi->virt + reg_offset(reg));
 	if (!(val & ENABLED_FMASK)) {
 		dev_err(gsi->dev, "GSI has not been enabled\n");
 		return -EIO;
@@ -2088,7 +2105,8 @@ int gsi_setup(struct gsi *gsi)
 		goto err_irq_teardown;
 
 	/* Initialize the error log */
-	iowrite32(0, gsi->virt + GSI_ERROR_LOG_OFFSET);
+	reg = gsi_reg(gsi, ERROR_LOG);
+	iowrite32(0, gsi->virt + reg_offset(reg));
 
 	ret = gsi_channel_setup(gsi);
 	if (ret)
diff --git a/drivers/net/ipa/gsi_reg.c b/drivers/net/ipa/gsi_reg.c
index 2334244d40da0..02e3ebcd74b5d 100644
--- a/drivers/net/ipa/gsi_reg.c
+++ b/drivers/net/ipa/gsi_reg.c
@@ -98,13 +98,15 @@ static const struct regs *gsi_regs(struct gsi *gsi)
 {
 	switch (gsi->version) {
 	case IPA_VERSION_3_1:
+		return &gsi_regs_v3_1;
+
 	case IPA_VERSION_3_5_1:
 	case IPA_VERSION_4_2:
 	case IPA_VERSION_4_5:
 	case IPA_VERSION_4_7:
 	case IPA_VERSION_4_9:
 	case IPA_VERSION_4_11:
-		return &gsi_regs_v3_1;
+		return &gsi_regs_v3_5_1;
 
 	default:
 		return NULL;
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 5faa1432c18ff..df594540692e2 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -154,12 +154,10 @@ enum gsi_prefetch_mode {
 #define MODC_FMASK			GENMASK(23, 16)
 #define MOD_CNT_FMASK			GENMASK(31, 24)
 
-#define GSI_GSI_STATUS_OFFSET \
-			(0x0001f000 + 0x4000 * GSI_EE_AP)
+/* GSI_STATUS register */
 #define ENABLED_FMASK			GENMASK(0, 0)
 
-#define GSI_CH_CMD_OFFSET \
-			(0x0001f008 + 0x4000 * GSI_EE_AP)
+/* CH_CMD register */
 #define CH_CHID_FMASK			GENMASK(7, 0)
 #define CH_OPCODE_FMASK			GENMASK(31, 24)
 
@@ -173,8 +171,7 @@ enum gsi_ch_cmd_opcode {
 	GSI_CH_DB_STOP				= 0xb,
 };
 
-#define GSI_EV_CH_CMD_OFFSET \
-			(0x0001f010 + 0x4000 * GSI_EE_AP)
+/* EV_CH_CMD register */
 #define EV_CHID_FMASK			GENMASK(7, 0)
 #define EV_OPCODE_FMASK			GENMASK(31, 24)
 
@@ -185,8 +182,7 @@ enum gsi_evt_cmd_opcode {
 	GSI_EVT_DE_ALLOC			= 0xa,
 };
 
-#define GSI_GENERIC_CMD_OFFSET \
-			(0x0001f018 + 0x4000 * GSI_EE_AP)
+/* GENERIC_CMD register */
 #define GENERIC_OPCODE_FMASK		GENMASK(4, 0)
 #define GENERIC_CHID_FMASK		GENMASK(9, 5)
 #define GENERIC_EE_FMASK		GENMASK(13, 10)
@@ -201,9 +197,7 @@ enum gsi_generic_cmd_opcode {
 	GSI_GENERIC_QUERY_FLOW_CONTROL		= 0x5,	/* IPA v4.11+ */
 };
 
-/* The next register is present for IPA v3.5.1 and above */
-#define GSI_GSI_HW_PARAM_2_OFFSET \
-			(0x0001f040 + 0x4000 * GSI_EE_AP)
+/* HW_PARAM_2 register */				/* IPA v3.5.1+ */
 #define IRAM_SIZE_FMASK			GENMASK(2, 0)
 #define NUM_CH_PER_EE_FMASK		GENMASK(7, 3)
 #define NUM_EV_PER_EE_FMASK		GENMASK(12, 8)
@@ -272,9 +266,7 @@ enum gsi_general_irq_id {
 /* CNTXT_INTSET register */
 #define INTYPE_FMASK			GENMASK(0, 0)
 
-#define GSI_ERROR_LOG_OFFSET \
-			(0x0001f200 + 0x4000 * GSI_EE_AP)
-
+/* ERROR_LOG register */
 #define ERR_ARG3_FMASK			GENMASK(3, 0)
 #define ERR_ARG2_FMASK			GENMASK(7, 4)
 #define ERR_ARG1_FMASK			GENMASK(11, 8)
@@ -302,9 +294,7 @@ enum gsi_err_type {
 	GSI_ERR_TYPE_EVT			= 0x3,
 };
 
-#define GSI_ERROR_LOG_CLR_OFFSET \
-			(0x0001f210 + 0x4000 * GSI_EE_AP)
-
+/* CNTXT_SCRATCH_0 register */
 #define INTER_EE_RESULT_FMASK		GENMASK(2, 0)
 #define GENERIC_EE_RESULT_FMASK		GENMASK(7, 5)
 
diff --git a/drivers/net/ipa/reg/gsi_reg-v3.1.c b/drivers/net/ipa/reg/gsi_reg-v3.1.c
index f7fe2308bdfe0..6bed9d547f9af 100644
--- a/drivers/net/ipa/reg/gsi_reg-v3.1.c
+++ b/drivers/net/ipa/reg/gsi_reg-v3.1.c
@@ -28,6 +28,10 @@ REG_STRIDE(CH_C_CNTXT_3, ch_c_cntxt_3, 0x0001c00c + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
 
+REG(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
+
+REG(ERROR_LOG_CLR, error_log_clr, 0x0001f210 + 0x4000 * GSI_EE_AP);
+
 REG_STRIDE(CH_C_SCRATCH_0, ch_c_scratch_0,
 	   0x0001c060 + 0x4000 * GSI_EE_AP, 0x80);
 
@@ -85,6 +89,14 @@ REG_STRIDE(CH_C_DOORBELL_0, ch_c_doorbell_0,
 REG_STRIDE(EV_CH_E_DOORBELL_0, ev_ch_e_doorbell_0,
 	   0x0001e100 + 0x4000 * GSI_EE_AP, 0x08);
 
+REG(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
+
+REG(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
+
+REG(EV_CH_CMD, ev_ch_cmd, 0x0001f010 + 0x4000 * GSI_EE_AP);
+
+REG(GENERIC_CMD, generic_cmd, 0x0001f018 + 0x4000 * GSI_EE_AP);
+
 REG(CNTXT_TYPE_IRQ, cntxt_type_irq, 0x0001f080 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_TYPE_IRQ_MSK, cntxt_type_irq_msk, 0x0001f088 + 0x4000 * GSI_EE_AP);
@@ -156,6 +168,10 @@ static const struct reg *reg_array[] = {
 	[EV_CH_E_SCRATCH_1]		= &reg_ev_ch_e_scratch_1,
 	[CH_C_DOORBELL_0]		= &reg_ch_c_doorbell_0,
 	[EV_CH_E_DOORBELL_0]		= &reg_ev_ch_e_doorbell_0,
+	[GSI_STATUS]			= &reg_gsi_status,
+	[CH_CMD]			= &reg_ch_cmd,
+	[EV_CH_CMD]			= &reg_ev_ch_cmd,
+	[GENERIC_CMD]			= &reg_generic_cmd,
 	[CNTXT_TYPE_IRQ]		= &reg_cntxt_type_irq,
 	[CNTXT_TYPE_IRQ_MSK]		= &reg_cntxt_type_irq_msk,
 	[CNTXT_SRC_CH_IRQ]		= &reg_cntxt_src_ch_irq,
@@ -174,6 +190,8 @@ static const struct reg *reg_array[] = {
 	[CNTXT_GSI_IRQ_EN]		= &reg_cntxt_gsi_irq_en,
 	[CNTXT_GSI_IRQ_CLR]		= &reg_cntxt_gsi_irq_clr,
 	[CNTXT_INTSET]			= &reg_cntxt_intset,
+	[ERROR_LOG]			= &reg_error_log,
+	[ERROR_LOG_CLR]			= &reg_error_log_clr,
 	[CNTXT_SCRATCH_0]		= &reg_cntxt_scratch_0,
 };
 
diff --git a/drivers/net/ipa/reg/gsi_reg-v3.5.1.c b/drivers/net/ipa/reg/gsi_reg-v3.5.1.c
index 97b37c3e9fec8..a6d7524c36f9f 100644
--- a/drivers/net/ipa/reg/gsi_reg-v3.5.1.c
+++ b/drivers/net/ipa/reg/gsi_reg-v3.5.1.c
@@ -28,6 +28,10 @@ REG_STRIDE(CH_C_CNTXT_3, ch_c_cntxt_3, 0x0001c00c + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(CH_C_QOS, ch_c_qos, 0x0001c05c + 0x4000 * GSI_EE_AP, 0x80);
 
+REG(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
+
+REG(ERROR_LOG_CLR, error_log_clr, 0x0001f210 + 0x4000 * GSI_EE_AP);
+
 REG_STRIDE(CH_C_SCRATCH_0, ch_c_scratch_0,
 	   0x0001c060 + 0x4000 * GSI_EE_AP, 0x80);
 
@@ -85,6 +89,16 @@ REG_STRIDE(CH_C_DOORBELL_0, ch_c_doorbell_0,
 REG_STRIDE(EV_CH_E_DOORBELL_0, ev_ch_e_doorbell_0,
 	   0x0001e100 + 0x4000 * GSI_EE_AP, 0x08);
 
+REG(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
+
+REG(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
+
+REG(EV_CH_CMD, ev_ch_cmd, 0x0001f010 + 0x4000 * GSI_EE_AP);
+
+REG(GENERIC_CMD, generic_cmd, 0x0001f018 + 0x4000 * GSI_EE_AP);
+
+REG(HW_PARAM_2, hw_param_2, 0x0001f040 + 0x4000 * GSI_EE_AP);
+
 REG(CNTXT_TYPE_IRQ, cntxt_type_irq, 0x0001f080 + 0x4000 * GSI_EE_AP);
 
 REG(CNTXT_TYPE_IRQ_MSK, cntxt_type_irq_msk, 0x0001f088 + 0x4000 * GSI_EE_AP);
@@ -156,6 +170,11 @@ static const struct reg *reg_array[] = {
 	[EV_CH_E_SCRATCH_1]		= &reg_ev_ch_e_scratch_1,
 	[CH_C_DOORBELL_0]		= &reg_ch_c_doorbell_0,
 	[EV_CH_E_DOORBELL_0]		= &reg_ev_ch_e_doorbell_0,
+	[GSI_STATUS]			= &reg_gsi_status,
+	[CH_CMD]			= &reg_ch_cmd,
+	[EV_CH_CMD]			= &reg_ev_ch_cmd,
+	[GENERIC_CMD]			= &reg_generic_cmd,
+	[HW_PARAM_2]			= &reg_hw_param_2,
 	[CNTXT_TYPE_IRQ]		= &reg_cntxt_type_irq,
 	[CNTXT_TYPE_IRQ_MSK]		= &reg_cntxt_type_irq_msk,
 	[CNTXT_SRC_CH_IRQ]		= &reg_cntxt_src_ch_irq,
@@ -174,6 +193,8 @@ static const struct reg *reg_array[] = {
 	[CNTXT_GSI_IRQ_EN]		= &reg_cntxt_gsi_irq_en,
 	[CNTXT_GSI_IRQ_CLR]		= &reg_cntxt_gsi_irq_clr,
 	[CNTXT_INTSET]			= &reg_cntxt_intset,
+	[ERROR_LOG]			= &reg_error_log,
+	[ERROR_LOG_CLR]			= &reg_error_log_clr,
 	[CNTXT_SCRATCH_0]		= &reg_cntxt_scratch_0,
 };
 
-- 
2.34.1

