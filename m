Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21FD7698506
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 20:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjBOTyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 14:54:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjBOTyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 14:54:12 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2BF3D0A3
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:54:00 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id w24so7559238iow.13
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z41w9zgeV1hPmCHYiN0Xjrl8mEx3IoB2lXLVQazEZzw=;
        b=wJXhb3vwYAk/utEnPkhErcNpPxV2P7JapbdleAsX7Ae0p130AtJoe8LMn3ap8RUCxq
         mmo7ethjQcjb/FiZalxAcLGeqZrYB3esXOwcwBx/0F9m9e7O0VYnheyYBDYMHRkg6cgr
         C60owQ6vVGn1ZRONLddKky/bXjgGvuMuRKzdNLB/V/bna9ky1i+txRhlNSPmGa1RrqwJ
         dAZAjLD0I/kZcBEX3GjvLofeprHhVFRk+yGdbSgBI/TiwGSUPlBgJ9z/3odN5PcUZhDF
         SgHJFpQMXkG8Our8Ew8ccUY0iE46dKZuNgzYnwl8wmA98u4ecdNfRvEXbbQwtZ3YMZKg
         yw+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z41w9zgeV1hPmCHYiN0Xjrl8mEx3IoB2lXLVQazEZzw=;
        b=OBELhLZoB7ALi0CTMUJQImAgwIOWOXv/0DUWujMl+gzky0iSO0B8dU7RHjXvIBSN7A
         ob6/dr4RQsy3smSbc65Q42PmALK0yCDCXBIz8A5mWpoapQsZGcLR5oUpIK0lsNlF0RMx
         Pc00pWHM3qc1LdtZ0IN78pZanIJKYeeCHPSJRT8DucJ1Vo506bddNbk8oV1C4iNyaZ/n
         EdBCg4WYXt0px2y+gXzjC4AX52kdiQcQcWLQ67CqIe2Gg0smkVIfIgxaTJJKRRbxd161
         b7zvez+5l7tyTfueF0QUOo5vmmYhHFuxPhcj58+gyNzxlOvLljdGbV06n3FptUWbKfM3
         cxog==
X-Gm-Message-State: AO0yUKUpuPxpAQLS0A82gqjrBW+66W3yyXboWr038IFbZxnlrqgbgG0R
        WAfFleVN07cd5K6CMjBbyHldqA==
X-Google-Smtp-Source: AK7set+/Hhh1YCobS6WZtERYzX2V8BniWs5/EORnl5WqcM23LfUTNkl5r8gs3M1byo1VOE/btXezvw==
X-Received: by 2002:a5e:c009:0:b0:6de:3e2c:d791 with SMTP id u9-20020a5ec009000000b006de3e2cd791mr3067795iol.1.1676490839868;
        Wed, 15 Feb 2023 11:53:59 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id n10-20020a5ed90a000000b0073a312aaae5sm6291847iop.36.2023.02.15.11.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 11:53:59 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/6] net: ipa: kill ev_ch_e_cntxt_1_length_encode()
Date:   Wed, 15 Feb 2023 13:53:49 -0600
Message-Id: <20230215195352.755744-4-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230215195352.755744-1-elder@linaro.org>
References: <20230215195352.755744-1-elder@linaro.org>
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

Now that we explicitly define each register field width there is no
need to have a special encoding function for the event ring length.
Add a field for this to the EV_CH_E_CNTXT_1 GSI register, and use it
in place of ev_ch_e_cntxt_1_length_encode() (which can be removed).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c                | 15 +--------------
 drivers/net/ipa/gsi_reg.h            |  6 ++++++
 drivers/net/ipa/reg/gsi_reg-v3.1.c   |  8 ++++++--
 drivers/net/ipa/reg/gsi_reg-v3.5.1.c |  8 ++++++--
 drivers/net/ipa/reg/gsi_reg-v4.0.c   |  8 ++++++--
 drivers/net/ipa/reg/gsi_reg-v4.11.c  |  8 ++++++--
 drivers/net/ipa/reg/gsi_reg-v4.5.c   |  8 ++++++--
 drivers/net/ipa/reg/gsi_reg-v4.9.c   |  8 ++++++--
 8 files changed, 43 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 2ef5509e3c836..0e6f679f71a8c 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -193,17 +193,6 @@ static u32 ch_c_cntxt_0_type_encode(enum ipa_version version,
 	return val | reg_encode(reg, CHTYPE_PROTOCOL_MSB, type);
 }
 
-/* Encode the length of the event channel ring buffer for the
- * EV_CH_E_CNTXT_1 register.
- */
-static u32 ev_ch_e_cntxt_1_length_encode(enum ipa_version version, u32 length)
-{
-	if (version < IPA_VERSION_4_9)
-		return u32_encode_bits(length, GENMASK(15, 0));
-
-	return u32_encode_bits(length, GENMASK(19, 0));
-}
-
 /* Update the GSI IRQ type register with the cached value */
 static void gsi_irq_type_update(struct gsi *gsi, u32 val)
 {
@@ -731,7 +720,6 @@ static void gsi_evt_ring_program(struct gsi *gsi, u32 evt_ring_id)
 	struct gsi_evt_ring *evt_ring = &gsi->evt_ring[evt_ring_id];
 	struct gsi_ring *ring = &evt_ring->ring;
 	const struct reg *reg;
-	size_t size;
 	u32 val;
 
 	reg = gsi_reg(gsi, EV_CH_E_CNTXT_0);
@@ -743,8 +731,7 @@ static void gsi_evt_ring_program(struct gsi *gsi, u32 evt_ring_id)
 	iowrite32(val, gsi->virt + reg_n_offset(reg, evt_ring_id));
 
 	reg = gsi_reg(gsi, EV_CH_E_CNTXT_1);
-	size = ring->count * GSI_RING_ELEMENT_SIZE;
-	val = ev_ch_e_cntxt_1_length_encode(gsi->version, size);
+	val = reg_encode(reg, R_LENGTH, ring->count * GSI_RING_ELEMENT_SIZE);
 	iowrite32(val, gsi->virt + reg_n_offset(reg, evt_ring_id));
 
 	/* The context 2 and 3 registers store the low-order and
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index e85765002aa41..a0b7ff0dcdfda 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -135,6 +135,7 @@ enum gsi_reg_ch_c_qos_field_id {
 	PREFETCH_MODE,					/* IPA v4.5+ */
 	EMPTY_LVL_THRSHOLD,				/* IPA v4.5+ */
 	DB_IN_BYTES,					/* IPA v4.9+ */
+	LOW_LATENCY_EN,					/* IPA v5.0+ */
 };
 
 /** enum gsi_prefetch_mode - PREFETCH_MODE field in CH_C_QOS */
@@ -155,6 +156,11 @@ enum gsi_reg_ch_c_ev_ch_e_cntxt_0_field_id {
 	EV_ELEMENT_SIZE,
 };
 
+/* EV_CH_E_CNTXT_1 register */
+enum gsi_reg_ev_ch_c_cntxt_1_field_id {
+	R_LENGTH,
+};
+
 /* EV_CH_E_CNTXT_8 register */
 enum gsi_reg_ch_c_ev_ch_e_cntxt_8_field_id {
 	EV_MODT,
diff --git a/drivers/net/ipa/reg/gsi_reg-v3.1.c b/drivers/net/ipa/reg/gsi_reg-v3.1.c
index 8451d3f8e421e..e036805a78824 100644
--- a/drivers/net/ipa/reg/gsi_reg-v3.1.c
+++ b/drivers/net/ipa/reg/gsi_reg-v3.1.c
@@ -87,8 +87,12 @@ static const u32 reg_ev_ch_e_cntxt_0_fmask[] = {
 REG_STRIDE_FIELDS(EV_CH_E_CNTXT_0, ev_ch_e_cntxt_0,
 		  0x0001d000 + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(EV_CH_E_CNTXT_1, ev_ch_e_cntxt_1,
-	   0x0001d004 + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ev_ch_e_cntxt_1_fmask[] = {
+	[R_LENGTH]					= GENMASK(15, 0),
+};
+
+REG_STRIDE_FIELDS(EV_CH_E_CNTXT_1, ev_ch_e_cntxt_1,
+		  0x0001d004 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_2, ev_ch_e_cntxt_2,
 	   0x0001d008 + 0x4000 * GSI_EE_AP, 0x80);
diff --git a/drivers/net/ipa/reg/gsi_reg-v3.5.1.c b/drivers/net/ipa/reg/gsi_reg-v3.5.1.c
index 87e75cf425135..8c3ab3a5288e6 100644
--- a/drivers/net/ipa/reg/gsi_reg-v3.5.1.c
+++ b/drivers/net/ipa/reg/gsi_reg-v3.5.1.c
@@ -87,8 +87,12 @@ static const u32 reg_ev_ch_e_cntxt_0_fmask[] = {
 REG_STRIDE_FIELDS(EV_CH_E_CNTXT_0, ev_ch_e_cntxt_0,
 		  0x0001d000 + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(EV_CH_E_CNTXT_1, ev_ch_e_cntxt_1,
-	   0x0001d004 + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ev_ch_e_cntxt_1_fmask[] = {
+	[R_LENGTH]					= GENMASK(15, 0),
+};
+
+REG_STRIDE_FIELDS(EV_CH_E_CNTXT_1, ev_ch_e_cntxt_1,
+		  0x0001d004 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_2, ev_ch_e_cntxt_2,
 	   0x0001d008 + 0x4000 * GSI_EE_AP, 0x80);
diff --git a/drivers/net/ipa/reg/gsi_reg-v4.0.c b/drivers/net/ipa/reg/gsi_reg-v4.0.c
index 048832e185091..7cc7a21d07f90 100644
--- a/drivers/net/ipa/reg/gsi_reg-v4.0.c
+++ b/drivers/net/ipa/reg/gsi_reg-v4.0.c
@@ -88,8 +88,12 @@ static const u32 reg_ev_ch_e_cntxt_0_fmask[] = {
 REG_STRIDE_FIELDS(EV_CH_E_CNTXT_0, ev_ch_e_cntxt_0,
 		  0x0001d000 + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(EV_CH_E_CNTXT_1, ev_ch_e_cntxt_1,
-	   0x0001d004 + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ev_ch_e_cntxt_1_fmask[] = {
+	[R_LENGTH]					= GENMASK(15, 0),
+};
+
+REG_STRIDE_FIELDS(EV_CH_E_CNTXT_1, ev_ch_e_cntxt_1,
+		  0x0001d004 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_2, ev_ch_e_cntxt_2,
 	   0x0001d008 + 0x4000 * GSI_EE_AP, 0x80);
diff --git a/drivers/net/ipa/reg/gsi_reg-v4.11.c b/drivers/net/ipa/reg/gsi_reg-v4.11.c
index ced762ca16f91..01696519032fa 100644
--- a/drivers/net/ipa/reg/gsi_reg-v4.11.c
+++ b/drivers/net/ipa/reg/gsi_reg-v4.11.c
@@ -91,8 +91,12 @@ static const u32 reg_ev_ch_e_cntxt_0_fmask[] = {
 REG_STRIDE_FIELDS(EV_CH_E_CNTXT_0, ev_ch_e_cntxt_0,
 		  0x00010000 + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(EV_CH_E_CNTXT_1, ev_ch_e_cntxt_1,
-	   0x00010004 + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ev_ch_e_cntxt_1_fmask[] = {
+	[R_LENGTH]					= GENMASK(19, 0),
+};
+
+REG_STRIDE_FIELDS(EV_CH_E_CNTXT_1, ev_ch_e_cntxt_1,
+		  0x00010004 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_2, ev_ch_e_cntxt_2,
 	   0x00010008 + 0x4000 * GSI_EE_AP, 0x80);
diff --git a/drivers/net/ipa/reg/gsi_reg-v4.5.c b/drivers/net/ipa/reg/gsi_reg-v4.5.c
index 1ede8276824d7..648b51b88d4e8 100644
--- a/drivers/net/ipa/reg/gsi_reg-v4.5.c
+++ b/drivers/net/ipa/reg/gsi_reg-v4.5.c
@@ -90,8 +90,12 @@ static const u32 reg_ev_ch_e_cntxt_0_fmask[] = {
 REG_STRIDE_FIELDS(EV_CH_E_CNTXT_0, ev_ch_e_cntxt_0,
 		  0x00010000 + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(EV_CH_E_CNTXT_1, ev_ch_e_cntxt_1,
-	   0x00010004 + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ev_ch_e_cntxt_1_fmask[] = {
+	[R_LENGTH]					= GENMASK(15, 0),
+};
+
+REG_STRIDE_FIELDS(EV_CH_E_CNTXT_1, ev_ch_e_cntxt_1,
+		  0x00010004 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_2, ev_ch_e_cntxt_2,
 	   0x00010008 + 0x4000 * GSI_EE_AP, 0x80);
diff --git a/drivers/net/ipa/reg/gsi_reg-v4.9.c b/drivers/net/ipa/reg/gsi_reg-v4.9.c
index 9374c89609d9a..4bf45d264d6b9 100644
--- a/drivers/net/ipa/reg/gsi_reg-v4.9.c
+++ b/drivers/net/ipa/reg/gsi_reg-v4.9.c
@@ -91,8 +91,12 @@ static const u32 reg_ev_ch_e_cntxt_0_fmask[] = {
 REG_STRIDE_FIELDS(EV_CH_E_CNTXT_0, ev_ch_e_cntxt_0,
 		  0x0001d000 + 0x4000 * GSI_EE_AP, 0x80);
 
-REG_STRIDE(EV_CH_E_CNTXT_1, ev_ch_e_cntxt_1,
-	   0x0001d004 + 0x4000 * GSI_EE_AP, 0x80);
+static const u32 reg_ev_ch_e_cntxt_1_fmask[] = {
+	[R_LENGTH]					= GENMASK(15, 0),
+};
+
+REG_STRIDE_FIELDS(EV_CH_E_CNTXT_1, ev_ch_e_cntxt_1,
+		  0x0001d004 + 0x4000 * GSI_EE_AP, 0x80);
 
 REG_STRIDE(EV_CH_E_CNTXT_2, ev_ch_e_cntxt_2,
 	   0x0001d008 + 0x4000 * GSI_EE_AP, 0x80);
-- 
2.34.1

