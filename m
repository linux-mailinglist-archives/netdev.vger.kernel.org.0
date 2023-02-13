Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68332694C76
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjBMQW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjBMQWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:22:52 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97201CF6B
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 08:22:37 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id n2so5385050ili.11
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 08:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pm8YPn0666/CRAALIYgYx/9aTgr//EKDdKewFBBNdpY=;
        b=n1448g8LbAl4txw/8Nn/m3oUse1+3AI+q0rzwkOyvnuLE2u7zAi1ONrXvODQhaHp2R
         FfslA8qp6D3RaXGQmTCRfO93TIBWNY0KEdY3OcF3Io8rhjcREv8I3+CGuKKjoVcAWETU
         CETe7GzmoRXeRH6/rZsbFo1/p7IPUteKo4HhXYJLIJsK/qBaFD/kd4VLOtx58AetacA6
         7lFnq/Tgqi96fTu03/OTcnZoaWBQMwfIfGdT1UHJS1fIFnYrZbghUbkn4qsffx8uaqFg
         gneWSEiNQFaavXMPYeDXbjLfu/EBesNx0TGQg7JLJ+HJzent/BU2LDC1nCeEbJ8e7/tB
         jDEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pm8YPn0666/CRAALIYgYx/9aTgr//EKDdKewFBBNdpY=;
        b=QGsp/awOuoFAzvMTqDOmbV9p0hiXwquluQCJozu75WGVrQv/PsID5BinkvhAbKlp/o
         +dLQVQq0CajcecV9fQG2vYMI554diiEyUNL6AaiMXZj/JRiDBECY2EMtWpwOiVS9cbB3
         pzTfvUScU1muhDT4kWWtU+lOVqVmfmwoYnqX1AAMXLLwywN0MfgU49ISAJjueQid3pqU
         CeLJ0mqPF37LqlgjAYE51u9cplAiFdinhlLb+eBh1vAnmd+53F4xSSSqRRRDTQXuDkXk
         2Eg5Ei6IlUln8FuIshnlKgc9I+o9DuJrOOTkTpcQ3rt0txv5oReOOGlneS83BMfr6oVM
         pmAA==
X-Gm-Message-State: AO0yUKV42T+MocmmW3m9e5Mz2mOTibFKXRdHo5SsuC/8B6KcyA1s3WQ8
        E0xOQ6lEmDIIgsimcaHB43VrHg==
X-Google-Smtp-Source: AK7set+xxih6i7m7OkJ9eIAoSRhP+RBwnlO5teFgaoMk4p875UyoW+zfXP9fHjmp3emJBlqEVsrnug==
X-Received: by 2002:a92:c56e:0:b0:315:3b90:584 with SMTP id b14-20020a92c56e000000b003153b900584mr5204375ilj.13.1676305357146;
        Mon, 13 Feb 2023 08:22:37 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id x17-20020a92dc51000000b00313cbba0455sm1457831ilq.8.2023.02.13.08.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 08:22:36 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/6] net: ipa: define fields for event-ring related registers
Date:   Mon, 13 Feb 2023 10:22:27 -0600
Message-Id: <20230213162229.604438-5-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230213162229.604438-1-elder@linaro.org>
References: <20230213162229.604438-1-elder@linaro.org>
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

Define field IDs for the EV_CH_E_CNTXT_0 and EV_CH_E_CNTXT_8 GSI
registers, and populate the register definition files accordingly.
Use the reg_*() functions to access field values for those regiters,
and get rid of the previous field definition constants.

The remaining EV_CH_E_CNTXT_* registers are written with full 32-bit
values (and have no fields).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c                | 19 +++++++++----------
 drivers/net/ipa/gsi_reg.h            | 23 +++++++++++++----------
 drivers/net/ipa/reg/gsi_reg-v3.1.c   | 24 ++++++++++++++++++++----
 drivers/net/ipa/reg/gsi_reg-v3.5.1.c | 24 ++++++++++++++++++++----
 drivers/net/ipa/reg/gsi_reg-v4.0.c   | 24 ++++++++++++++++++++----
 drivers/net/ipa/reg/gsi_reg-v4.5.c   | 24 ++++++++++++++++++++----
 drivers/net/ipa/reg/gsi_reg-v4.9.c   | 24 ++++++++++++++++++++----
 7 files changed, 122 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index ff00c833043a9..7c4e458364236 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -163,9 +163,6 @@ static void gsi_validate_build(void)
 	 * ensure the elements themselves meet the requirement.
 	 */
 	BUILD_BUG_ON(!is_power_of_2(GSI_RING_ELEMENT_SIZE));
-
-	/* The event ring element size must fit in this field */
-	BUILD_BUG_ON(GSI_RING_ELEMENT_SIZE > field_max(EV_ELEMENT_SIZE_FMASK));
 }
 
 /* Return the channel id associated with a given channel */
@@ -418,7 +415,7 @@ gsi_evt_ring_state(struct gsi *gsi, u32 evt_ring_id)
 
 	val = ioread32(gsi->virt + reg_n_offset(reg, evt_ring_id));
 
-	return u32_get_bits(val, EV_CHSTATE_FMASK);
+	return reg_decode(reg, EV_CHSTATE, val);
 }
 
 /* Issue an event ring command and wait for it to complete */
@@ -739,9 +736,10 @@ static void gsi_evt_ring_program(struct gsi *gsi, u32 evt_ring_id)
 
 	reg = gsi_reg(gsi, EV_CH_E_CNTXT_0);
 	/* We program all event rings as GPI type/protocol */
-	val = u32_encode_bits(GSI_CHANNEL_TYPE_GPI, EV_CHTYPE_FMASK);
-	val |= EV_INTYPE_FMASK;
-	val |= u32_encode_bits(GSI_RING_ELEMENT_SIZE, EV_ELEMENT_SIZE_FMASK);
+	val = reg_encode(reg, EV_CHTYPE, GSI_CHANNEL_TYPE_GPI);
+	/* EV_EE field is 0 (GSI_EE_AP) */
+	val |= reg_bit(reg, EV_INTYPE);
+	val |= reg_encode(reg, EV_ELEMENT_SIZE, GSI_RING_ELEMENT_SIZE);
 	iowrite32(val, gsi->virt + reg_n_offset(reg, evt_ring_id));
 
 	reg = gsi_reg(gsi, EV_CH_E_CNTXT_1);
@@ -763,11 +761,12 @@ static void gsi_evt_ring_program(struct gsi *gsi, u32 evt_ring_id)
 
 	/* Enable interrupt moderation by setting the moderation delay */
 	reg = gsi_reg(gsi, EV_CH_E_CNTXT_8);
-	val = u32_encode_bits(GSI_EVT_RING_INT_MODT, MODT_FMASK);
-	val |= u32_encode_bits(1, MODC_FMASK);	/* comes from channel */
+	val = reg_encode(reg, EV_MODT, GSI_EVT_RING_INT_MODT);
+	val = reg_encode(reg, EV_MODC, 1);	/* comes from channel */
+	/* EV_MOD_CNT is 0 (no counter-based interrupt coalescing) */
 	iowrite32(val, gsi->virt + reg_n_offset(reg, evt_ring_id));
 
-	/* No MSI write data, and MSI address high and low address is 0 */
+	/* No MSI write data, and MSI high and low address is 0 */
 	reg = gsi_reg(gsi, EV_CH_E_CNTXT_9);
 	iowrite32(0, gsi->virt + reg_n_offset(reg, evt_ring_id));
 
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 3f1a49a4f7c47..acd06a0de93b3 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -146,18 +146,21 @@ enum gsi_prefetch_mode {
 };
 
 /* EV_CH_E_CNTXT_0 register */
-/* enum gsi_channel_type defines EV_CHTYPE field values in EV_CH_E_CNTXT_0 */
-#define EV_CHTYPE_FMASK			GENMASK(3, 0)
-#define EV_EE_FMASK			GENMASK(7, 4)
-#define EV_EVCHID_FMASK			GENMASK(15, 8)
-#define EV_INTYPE_FMASK			GENMASK(16, 16)
-#define EV_CHSTATE_FMASK		GENMASK(23, 20)
-#define EV_ELEMENT_SIZE_FMASK		GENMASK(31, 24)
+enum gsi_reg_ch_c_ev_ch_e_cntxt_0_field_id {
+	EV_CHTYPE,	/* enum gsi_channel_type */
+	EV_EE,		/* enum gsi_ee_id; always GSI_EE_AP for us */
+	EV_EVCHID,
+	EV_INTYPE,
+	EV_CHSTATE,
+	EV_ELEMENT_SIZE,
+};
 
 /* EV_CH_E_CNTXT_8 register */
-#define MODT_FMASK			GENMASK(15, 0)
-#define MODC_FMASK			GENMASK(23, 16)
-#define MOD_CNT_FMASK			GENMASK(31, 24)
+enum gsi_reg_ch_c_ev_ch_e_cntxt_8_field_id {
+	EV_MODT,
+	EV_MODC,
+	EV_MOD_CNT,
+};
 
 /* GSI_STATUS register */
 #define ENABLED_FMASK			GENMASK(0, 0)
diff --git a/drivers/net/ipa/reg/gsi_reg-v3.1.c b/drivers/net/ipa/reg/gsi_reg-v3.1.c
index 4aa7a1c52cb35..36595b21dff7b 100644
--- a/drivers/net/ipa/reg/gsi_reg-v3.1.c
+++ b/drivers/net/ipa/reg/gsi_reg-v3.1.c
@@ -71,8 +71,18 @@ REG_STRIDE(CH_C_SCRATCH_2, ch_c_scratch_2,
 REG_STRIDE(CH_C_SCRATCH_3, ch_c_scratch_3,
 	   0x0001c06c + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(EV_CH_E_CNTXT_0, ev_ch_e_cntxt_0,
-	   0x0001d000 + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ev_ch_e_cntxt_0_fmask[] = {
+	[EV_CHTYPE]					= GENMASK(3, 0),
+	[EV_EE]						= GENMASK(7, 4),
+	[EV_EVCHID]					= GENMASK(15, 8),
+	[EV_INTYPE]					= BIT(16),
+						/* Bits 17-19 reserved */
+	[EV_CHSTATE]					= GENMASK(23, 20),
+	[EV_ELEMENT_SIZE]				= GENMASK(31, 24),
+};
+
+REG_STRIDE_FIELDS(EV_CH_E_CNTXT_0, ev_ch_e_cntxt_0,
+		  0x0001d000 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_1, ev_ch_e_cntxt_1,
 	   0x0001d004 + 0x4000 * GSI_EE_AP, 0x80);
@@ -86,8 +96,14 @@ REG_STRIDE(EV_CH_E_CNTXT_3, ev_ch_e_cntxt_3,
 REG_STRIDE(EV_CH_E_CNTXT_4, ev_ch_e_cntxt_4,
 	   0x0001d010 + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(EV_CH_E_CNTXT_8, ev_ch_e_cntxt_8,
-	   0x0001d020 + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ev_ch_e_cntxt_8_fmask[] = {
+	[EV_MODT]					= GENMASK(15, 0),
+	[EV_MODC]					= GENMASK(23, 16),
+	[EV_MOD_CNT]					= GENMASK(31, 24),
+};
+
+REG_STRIDE_FIELDS(EV_CH_E_CNTXT_8, ev_ch_e_cntxt_8,
+		  0x0001d020 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_9, ev_ch_e_cntxt_9,
 	   0x0001d024 + 0x4000 * GSI_EE_AP, 0x80);
diff --git a/drivers/net/ipa/reg/gsi_reg-v3.5.1.c b/drivers/net/ipa/reg/gsi_reg-v3.5.1.c
index 045061a870032..a30bfbfa6c1fd 100644
--- a/drivers/net/ipa/reg/gsi_reg-v3.5.1.c
+++ b/drivers/net/ipa/reg/gsi_reg-v3.5.1.c
@@ -71,8 +71,18 @@ REG_STRIDE(CH_C_SCRATCH_2, ch_c_scratch_2,
 REG_STRIDE(CH_C_SCRATCH_3, ch_c_scratch_3,
 	   0x0001c06c + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(EV_CH_E_CNTXT_0, ev_ch_e_cntxt_0,
-	   0x0001d000 + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ev_ch_e_cntxt_0_fmask[] = {
+	[EV_CHTYPE]					= GENMASK(3, 0),
+	[EV_EE]						= GENMASK(7, 4),
+	[EV_EVCHID]					= GENMASK(15, 8),
+	[EV_INTYPE]					= BIT(16),
+						/* Bits 17-19 reserved */
+	[EV_CHSTATE]					= GENMASK(23, 20),
+	[EV_ELEMENT_SIZE]				= GENMASK(31, 24),
+};
+
+REG_STRIDE_FIELDS(EV_CH_E_CNTXT_0, ev_ch_e_cntxt_0,
+		  0x0001d000 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_1, ev_ch_e_cntxt_1,
 	   0x0001d004 + 0x4000 * GSI_EE_AP, 0x80);
@@ -86,8 +96,14 @@ REG_STRIDE(EV_CH_E_CNTXT_3, ev_ch_e_cntxt_3,
 REG_STRIDE(EV_CH_E_CNTXT_4, ev_ch_e_cntxt_4,
 	   0x0001d010 + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(EV_CH_E_CNTXT_8, ev_ch_e_cntxt_8,
-	   0x0001d020 + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ev_ch_e_cntxt_8_fmask[] = {
+	[EV_MODT]					= GENMASK(15, 0),
+	[EV_MODC]					= GENMASK(23, 16),
+	[EV_MOD_CNT]					= GENMASK(31, 24),
+};
+
+REG_STRIDE_FIELDS(EV_CH_E_CNTXT_8, ev_ch_e_cntxt_8,
+		  0x0001d020 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_9, ev_ch_e_cntxt_9,
 	   0x0001d024 + 0x4000 * GSI_EE_AP, 0x80);
diff --git a/drivers/net/ipa/reg/gsi_reg-v4.0.c b/drivers/net/ipa/reg/gsi_reg-v4.0.c
index 3374d4e9272d8..c0042fb9e760f 100644
--- a/drivers/net/ipa/reg/gsi_reg-v4.0.c
+++ b/drivers/net/ipa/reg/gsi_reg-v4.0.c
@@ -72,8 +72,18 @@ REG_STRIDE(CH_C_SCRATCH_2, ch_c_scratch_2,
 REG_STRIDE(CH_C_SCRATCH_3, ch_c_scratch_3,
 	   0x0001c06c + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(EV_CH_E_CNTXT_0, ev_ch_e_cntxt_0,
-	   0x0001d000 + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ev_ch_e_cntxt_0_fmask[] = {
+	[EV_CHTYPE]					= GENMASK(3, 0),
+	[EV_EE]						= GENMASK(7, 4),
+	[EV_EVCHID]					= GENMASK(15, 8),
+	[EV_INTYPE]					= BIT(16),
+						/* Bits 17-19 reserved */
+	[EV_CHSTATE]					= GENMASK(23, 20),
+	[EV_ELEMENT_SIZE]				= GENMASK(31, 24),
+};
+
+REG_STRIDE_FIELDS(EV_CH_E_CNTXT_0, ev_ch_e_cntxt_0,
+		  0x0001d000 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_1, ev_ch_e_cntxt_1,
 	   0x0001d004 + 0x4000 * GSI_EE_AP, 0x80);
@@ -87,8 +97,14 @@ REG_STRIDE(EV_CH_E_CNTXT_3, ev_ch_e_cntxt_3,
 REG_STRIDE(EV_CH_E_CNTXT_4, ev_ch_e_cntxt_4,
 	   0x0001d010 + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(EV_CH_E_CNTXT_8, ev_ch_e_cntxt_8,
-	   0x0001d020 + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ev_ch_e_cntxt_8_fmask[] = {
+	[EV_MODT]					= GENMASK(15, 0),
+	[EV_MODC]					= GENMASK(23, 16),
+	[EV_MOD_CNT]					= GENMASK(31, 24),
+};
+
+REG_STRIDE_FIELDS(EV_CH_E_CNTXT_8, ev_ch_e_cntxt_8,
+		  0x0001d020 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_9, ev_ch_e_cntxt_9,
 	   0x0001d024 + 0x4000 * GSI_EE_AP, 0x80);
diff --git a/drivers/net/ipa/reg/gsi_reg-v4.5.c b/drivers/net/ipa/reg/gsi_reg-v4.5.c
index 0502f3e635dab..ace13fb2d5d2b 100644
--- a/drivers/net/ipa/reg/gsi_reg-v4.5.c
+++ b/drivers/net/ipa/reg/gsi_reg-v4.5.c
@@ -74,8 +74,18 @@ REG_STRIDE(CH_C_SCRATCH_2, ch_c_scratch_2,
 REG_STRIDE(CH_C_SCRATCH_3, ch_c_scratch_3,
 	   0x0001c06c + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(EV_CH_E_CNTXT_0, ev_ch_e_cntxt_0,
-	   0x0001d000 + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ev_ch_e_cntxt_0_fmask[] = {
+	[EV_CHTYPE]					= GENMASK(3, 0),
+	[EV_EE]						= GENMASK(7, 4),
+	[EV_EVCHID]					= GENMASK(15, 8),
+	[EV_INTYPE]					= BIT(16),
+						/* Bits 17-19 reserved */
+	[EV_CHSTATE]					= GENMASK(23, 20),
+	[EV_ELEMENT_SIZE]				= GENMASK(31, 24),
+};
+
+REG_STRIDE_FIELDS(EV_CH_E_CNTXT_0, ev_ch_e_cntxt_0,
+		  0x0001d000 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_1, ev_ch_e_cntxt_1,
 	   0x0001d004 + 0x4000 * GSI_EE_AP, 0x80);
@@ -89,8 +99,14 @@ REG_STRIDE(EV_CH_E_CNTXT_3, ev_ch_e_cntxt_3,
 REG_STRIDE(EV_CH_E_CNTXT_4, ev_ch_e_cntxt_4,
 	   0x0001d010 + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(EV_CH_E_CNTXT_8, ev_ch_e_cntxt_8,
-	   0x0001d020 + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ev_ch_e_cntxt_8_fmask[] = {
+	[EV_MODT]					= GENMASK(15, 0),
+	[EV_MODC]					= GENMASK(23, 16),
+	[EV_MOD_CNT]					= GENMASK(31, 24),
+};
+
+REG_STRIDE_FIELDS(EV_CH_E_CNTXT_8, ev_ch_e_cntxt_8,
+		  0x0001d020 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_9, ev_ch_e_cntxt_9,
 	   0x0001d024 + 0x4000 * GSI_EE_AP, 0x80);
diff --git a/drivers/net/ipa/reg/gsi_reg-v4.9.c b/drivers/net/ipa/reg/gsi_reg-v4.9.c
index 2c61633fdb427..5d6670993fa83 100644
--- a/drivers/net/ipa/reg/gsi_reg-v4.9.c
+++ b/drivers/net/ipa/reg/gsi_reg-v4.9.c
@@ -75,8 +75,18 @@ REG_STRIDE(CH_C_SCRATCH_2, ch_c_scratch_2,
 REG_STRIDE(CH_C_SCRATCH_3, ch_c_scratch_3,
 	   0x0001c06c + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(EV_CH_E_CNTXT_0, ev_ch_e_cntxt_0,
-	   0x0001d000 + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ev_ch_e_cntxt_0_fmask[] = {
+	[EV_CHTYPE]					= GENMASK(3, 0),
+	[EV_EE]						= GENMASK(7, 4),
+	[EV_EVCHID]					= GENMASK(15, 8),
+	[EV_INTYPE]					= BIT(16),
+						/* Bits 17-19 reserved */
+	[EV_CHSTATE]					= GENMASK(23, 20),
+	[EV_ELEMENT_SIZE]				= GENMASK(31, 24),
+};
+
+REG_STRIDE_FIELDS(EV_CH_E_CNTXT_0, ev_ch_e_cntxt_0,
+		  0x0001d000 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_1, ev_ch_e_cntxt_1,
 	   0x0001d004 + 0x4000 * GSI_EE_AP, 0x80);
@@ -90,8 +100,14 @@ REG_STRIDE(EV_CH_E_CNTXT_3, ev_ch_e_cntxt_3,
 REG_STRIDE(EV_CH_E_CNTXT_4, ev_ch_e_cntxt_4,
 	   0x0001d010 + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(EV_CH_E_CNTXT_8, ev_ch_e_cntxt_8,
-	   0x0001d020 + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ev_ch_e_cntxt_8_fmask[] = {
+	[EV_MODT]					= GENMASK(15, 0),
+	[EV_MODC]					= GENMASK(23, 16),
+	[EV_MOD_CNT]					= GENMASK(31, 24),
+};
+
+REG_STRIDE_FIELDS(EV_CH_E_CNTXT_8, ev_ch_e_cntxt_8,
+		  0x0001d020 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_9, ev_ch_e_cntxt_9,
 	   0x0001d024 + 0x4000 * GSI_EE_AP, 0x80);
-- 
2.34.1

