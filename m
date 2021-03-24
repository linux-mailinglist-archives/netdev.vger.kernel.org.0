Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD606347954
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 14:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235003AbhCXNQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 09:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234669AbhCXNPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 09:15:33 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE9BC0613DE
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 06:15:32 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id e8so21435734iok.5
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 06:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R188tgNnW6Iy6m81+dkSI8iVQ4LK81VtFqse+ajK9/U=;
        b=n2a5FBqYjczsk3jxGWJOxLd9X6RUdPq2uyPRIBopDhogE/gOuCSeehyE3Tb/Ncf54J
         MMZB9FlfImf5rBFPkhvORz0oxiDZe+QDtE0DUAJ9FPe5GuI0I3jy226rA54HOB3AwcFA
         uc2t6Gg+qpvrdcleCABbiXJg4Cs/wpbuH0YyDzwBMDxVso05XFO6+yEGoWv0BI6d9abh
         Q3SdGIOCM1R3CIUbwDppEnbUhc+0XDltRoByRPBB1T5yOaWEk6otCn0naQrsketQzo79
         +IsX4HAU+D9MPWWXH+09buriGt/TrwI9pEWg65pXjxR+cMlXHKuYk2ba6Esv6mQVurcX
         T68g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R188tgNnW6Iy6m81+dkSI8iVQ4LK81VtFqse+ajK9/U=;
        b=U/y2mhKzoy5jgj/bgkFm3srn8UdLQcFb5Yckx//gr2UA+u8xN3qJnF8ORfvtDSwa1d
         3PW7i7q1P9cme2oPts9BgWenEnHx2N/VhMAyaRFfKga/n3yUmncqHt57i6Z7Rfsc7+1B
         tyynw5IFObgDj4r9Zd8aTbCxjHaNFUQwwkTQKm0YnGv/lQBRKC05R/pPVfu+5eKHfsAv
         vBOCmXqTzwVXMdg5INfwzXl9VCCbIHKbosE6B09r62FMwNzAsfpTTyENNJhzPvwVLM9U
         wHH8K4rK9Sm9XUuel2RkcgQ73mvtEs+9Id0oYyVqCmX/dB3rzgPd6nKf7KV0RW6ebPtd
         Z5dw==
X-Gm-Message-State: AOAM531NykKQKCSwSl6wpGmQ9o2nVT+AmfR60FbQCez222QvXvMBOWPl
        XY6TkPfA4f7aaxLXKpuky9/hhg==
X-Google-Smtp-Source: ABdhPJwJcovIsQf8H+48uabWXSQrwTWAD2UGhUDuFpRD2Zuagke1PyU6kuZw69ME8N2adRB0fl1AuQ==
X-Received: by 2002:a02:a506:: with SMTP id e6mr2779002jam.56.1616591731962;
        Wed, 24 Mar 2021 06:15:31 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id n7sm1160486ile.12.2021.03.24.06.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:15:31 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/6] net: ipa: reduce IPA version assumptions
Date:   Wed, 24 Mar 2021 08:15:23 -0500
Message-Id: <20210324131528.2369348-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210324131528.2369348-1-elder@linaro.org>
References: <20210324131528.2369348-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify conditional tests throughout the IPA code so they do not
assume that IPA v3.5.1 is the oldest version supported.  Also remove
assumptions that IPA v4.5 is the newest version of IPA supported.

Augment versions in comments with "+", to be clearer that the
comment applies to a version and subsequent versions.  (E.g.,
"present for IPA v4.2+" instead of just "present for v4.2".)

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c          |  8 ++++----
 drivers/net/ipa/ipa_cmd.c      | 26 +++++++++++++++-----------
 drivers/net/ipa/ipa_endpoint.c | 25 ++++++++++++++-----------
 drivers/net/ipa/ipa_main.c     |  6 +++---
 drivers/net/ipa/ipa_qmi.c      |  2 +-
 5 files changed, 37 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index b6355827bf900..7f2a8fce5e0db 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -827,14 +827,14 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 
 	/* Max prefetch is 1 segment (do not set MAX_PREFETCH_FMASK) */
 
-	/* We enable the doorbell engine for IPA v3.5.1 */
-	if (gsi->version == IPA_VERSION_3_5_1 && doorbell)
+	/* No need to use the doorbell engine starting at IPA v4.0 */
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
@@ -973,7 +973,7 @@ void gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool doorbell)
 
 	gsi_channel_reset_command(channel);
 	/* Due to a hardware quirk we may need to reset RX channels twice. */
-	if (gsi->version == IPA_VERSION_3_5_1 && !channel->toward_ipa)
+	if (gsi->version < IPA_VERSION_4_0 && !channel->toward_ipa)
 		gsi_channel_reset_command(channel);
 
 	gsi_channel_program(channel, doorbell);
diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index 35e35852c25c5..a0be25f1f4427 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -71,13 +71,12 @@ struct ipa_cmd_hw_hdr_init_local {
 
 /* IPA_CMD_REGISTER_WRITE */
 
-/* For IPA v4.0+, this opcode gets modified with pipeline clear options */
-
+/* For IPA v4.0+, the pipeline clear options are encoded in the opcode */
 #define REGISTER_WRITE_OPCODE_SKIP_CLEAR_FMASK		GENMASK(8, 8)
 #define REGISTER_WRITE_OPCODE_CLEAR_OPTION_FMASK	GENMASK(10, 9)
 
 struct ipa_cmd_register_write {
-	__le16 flags;		/* Unused/reserved for IPA v3.5.1 */
+	__le16 flags;		/* Unused/reserved prior to IPA v4.0 */
 	__le16 offset;
 	__le32 value;
 	__le32 value_mask;
@@ -85,12 +84,12 @@ struct ipa_cmd_register_write {
 };
 
 /* Field masks for ipa_cmd_register_write structure fields */
-/* The next field is present for IPA v4.0 and above */
+/* The next field is present for IPA v4.0+ */
 #define REGISTER_WRITE_FLAGS_OFFSET_HIGH_FMASK		GENMASK(14, 11)
-/* The next field is present for IPA v3.5.1 only */
+/* The next field is not present for IPA v4.0+ */
 #define REGISTER_WRITE_FLAGS_SKIP_CLEAR_FMASK		GENMASK(15, 15)
 
-/* The next field and its values are present for IPA v3.5.1 only */
+/* The next field and its values are not present for IPA v4.0+ */
 #define REGISTER_WRITE_CLEAR_OPTIONS_FMASK		GENMASK(1, 0)
 
 /* IPA_CMD_IP_PACKET_INIT */
@@ -123,7 +122,7 @@ struct ipa_cmd_hw_dma_mem_mem {
 
 /* Field masks for ipa_cmd_hw_dma_mem_mem structure fields */
 #define DMA_SHARED_MEM_FLAGS_DIRECTION_FMASK		GENMASK(0, 0)
-/* The next two fields are present for IPA v3.5.1 only. */
+/* The next two fields are not present for IPA v4.0+ */
 #define DMA_SHARED_MEM_FLAGS_SKIP_CLEAR_FMASK		GENMASK(1, 1)
 #define DMA_SHARED_MEM_FLAGS_CLEAR_OPTIONS_FMASK	GENMASK(3, 2)
 
@@ -237,11 +236,12 @@ static bool ipa_cmd_register_write_offset_valid(struct ipa *ipa,
 	u32 bit_count;
 
 	/* The maximum offset in a register_write immediate command depends
-	 * on the version of IPA.  IPA v3.5.1 supports a 16 bit offset, but
-	 * newer versions allow some additional high-order bits.
+	 * on the version of IPA.  A 16 bit offset is always supported,
+	 * but starting with IPA v4.0 some additional high-order bits are
+	 * allowed.
 	 */
 	bit_count = BITS_PER_BYTE * sizeof(payload->offset);
-	if (ipa->version != IPA_VERSION_3_5_1)
+	if (ipa->version >= IPA_VERSION_4_0)
 		bit_count += hweight32(REGISTER_WRITE_FLAGS_OFFSET_HIGH_FMASK);
 	BUILD_BUG_ON(bit_count > 32);
 	offset_max = ~0U >> (32 - bit_count);
@@ -440,7 +440,11 @@ void ipa_cmd_register_write_add(struct gsi_trans *trans, u32 offset, u32 value,
 	/* pipeline_clear_src_grp is not used */
 	clear_option = clear_full ? pipeline_clear_full : pipeline_clear_hps;
 
-	if (ipa->version != IPA_VERSION_3_5_1) {
+	/* IPA v4.0+ represents the pipeline clear options in the opcode.  It
+	 * also supports a larger offset by encoding additional high-order
+	 * bits in the payload flags field.
+	 */
+	if (ipa->version >= IPA_VERSION_4_0) {
 		u16 offset_high;
 		u32 val;
 
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 88310d3585574..5f93bd60c7586 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -266,7 +266,7 @@ ipa_endpoint_init_ctrl(struct ipa_endpoint *endpoint, bool suspend_delay)
 	 * if (endpoint->toward_ipa)
 	 * 	assert(ipa->version != IPA_VERSION_4.2);
 	 * else
-	 * 	assert(ipa->version == IPA_VERSION_3_5_1);
+	 *	assert(ipa->version < IPA_VERSION_4_0);
 	 */
 	mask = endpoint->toward_ipa ? ENDP_DELAY_FMASK : ENDP_SUSPEND_FMASK;
 
@@ -347,7 +347,7 @@ ipa_endpoint_program_suspend(struct ipa_endpoint *endpoint, bool enable)
 {
 	bool suspended;
 
-	if (endpoint->ipa->version != IPA_VERSION_3_5_1)
+	if (endpoint->ipa->version >= IPA_VERSION_4_0)
 		return enable;	/* For IPA v4.0+, no change made */
 
 	/* assert(!endpoint->toward_ipa); */
@@ -515,7 +515,7 @@ static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
 			/* Where IPA will write the length */
 			offset = offsetof(struct rmnet_map_header, pkt_len);
 			/* Upper bits are stored in HDR_EXT with IPA v4.5 */
-			if (version == IPA_VERSION_4_5)
+			if (version >= IPA_VERSION_4_5)
 				offset &= field_mask(HDR_OFST_PKT_SIZE_FMASK);
 
 			val |= HDR_OFST_PKT_SIZE_VALID_FMASK;
@@ -562,7 +562,7 @@ static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 	/* IPA v4.5 adds some most-significant bits to a few fields,
 	 * two of which are defined in the HDR (not HDR_EXT) register.
 	 */
-	if (ipa->version == IPA_VERSION_4_5) {
+	if (ipa->version >= IPA_VERSION_4_5) {
 		/* HDR_TOTAL_LEN_OR_PAD_OFFSET is 0, so MSB is 0 */
 		if (endpoint->data->qmap && !endpoint->toward_ipa) {
 			u32 offset;
@@ -776,7 +776,7 @@ static u32 hol_block_timer_val(struct ipa *ipa, u32 microseconds)
 	if (!microseconds)
 		return 0;	/* Nothing to compute if timer period is 0 */
 
-	if (ipa->version == IPA_VERSION_4_5)
+	if (ipa->version >= IPA_VERSION_4_5)
 		return hol_block_timer_qtime_val(ipa, microseconds);
 
 	/* Use 64 bit arithmetic to avoid overflow... */
@@ -1468,8 +1468,7 @@ static void ipa_endpoint_reset(struct ipa_endpoint *endpoint)
 	 * is active, we need to handle things specially to recover.
 	 * All other cases just need to reset the underlying GSI channel.
 	 */
-	special = ipa->version == IPA_VERSION_3_5_1 &&
-			!endpoint->toward_ipa &&
+	special = ipa->version < IPA_VERSION_4_0 && !endpoint->toward_ipa &&
 			endpoint->data->aggregation;
 	if (special && ipa_endpoint_aggr_active(endpoint))
 		ret = ipa_endpoint_reset_rx_aggr(endpoint);
@@ -1567,8 +1566,10 @@ void ipa_endpoint_suspend_one(struct ipa_endpoint *endpoint)
 		(void)ipa_endpoint_program_suspend(endpoint, true);
 	}
 
-	/* IPA v3.5.1 doesn't use channel stop for suspend */
-	stop_channel = endpoint->ipa->version != IPA_VERSION_3_5_1;
+	/* Starting with IPA v4.0, endpoints are suspended by stopping the
+	 * underlying GSI channel rather than using endpoint suspend mode.
+	 */
+	stop_channel = endpoint->ipa->version >= IPA_VERSION_4_0;
 	ret = gsi_channel_suspend(gsi, endpoint->channel_id, stop_channel);
 	if (ret)
 		dev_err(dev, "error %d suspending channel %u\n", ret,
@@ -1588,8 +1589,10 @@ void ipa_endpoint_resume_one(struct ipa_endpoint *endpoint)
 	if (!endpoint->toward_ipa)
 		(void)ipa_endpoint_program_suspend(endpoint, false);
 
-	/* IPA v3.5.1 doesn't use channel start for resume */
-	start_channel = endpoint->ipa->version != IPA_VERSION_3_5_1;
+	/* Starting with IPA v4.0, the underlying GSI channel must be
+	 * restarted for resume.
+	 */
+	start_channel = endpoint->ipa->version >= IPA_VERSION_4_0;
 	ret = gsi_channel_resume(gsi, endpoint->channel_id, start_channel);
 	if (ret)
 		dev_err(dev, "error %d resuming channel %u\n", ret,
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 64b92dfdd3f5c..62d82d48aed69 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -227,8 +227,8 @@ static void ipa_hardware_config_comp(struct ipa *ipa)
 {
 	u32 val;
 
-	/* Nothing to configure for IPA v3.5.1 */
-	if (ipa->version == IPA_VERSION_3_5_1)
+	/* Nothing to configure prior to IPA v4.0 */
+	if (ipa->version < IPA_VERSION_4_0)
 		return;
 
 	val = ioread32(ipa->reg_virt + IPA_REG_COMP_CFG_OFFSET);
@@ -388,7 +388,7 @@ static void ipa_hardware_config(struct ipa *ipa, const struct ipa_data *data)
 	}
 
 	/* Implement some hardware workarounds */
-	if (version != IPA_VERSION_3_5_1 && version < IPA_VERSION_4_5) {
+	if (version >= IPA_VERSION_4_0 && version < IPA_VERSION_4_5) {
 		/* Enable open global clocks (not needed for IPA v4.5) */
 		val = GLOBAL_FMASK;
 		val |= GLOBAL_2X_CLK_FMASK;
diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
index af8666b89b375..7b833e92a0ac7 100644
--- a/drivers/net/ipa/ipa_qmi.c
+++ b/drivers/net/ipa/ipa_qmi.c
@@ -377,7 +377,7 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 
 	/* None of the stats fields are valid (IPA v4.0 and above) */
 
-	if (ipa->version != IPA_VERSION_3_5_1) {
+	if (ipa->version >= IPA_VERSION_4_0) {
 		mem = &ipa->mem[IPA_MEM_STATS_QUOTA_MODEM];
 		if (mem->size) {
 			req.hw_stats_quota_base_addr_valid = 1;
-- 
2.27.0

