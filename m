Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38339342E0F
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 16:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhCTP5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 11:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbhCTP5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 11:57:14 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DACC061762
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 08:57:13 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id u10so10843130ilb.0
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 08:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kBso4vxCR9mE3vQ4KCSh4OicS8VHOel88RWScgRFJBk=;
        b=p3IHz9Qsmbudl0NHuK6sEhXFfXS1UvgVoK9+bESwJl61X68IK5EDajXiM+Gl1x4mhG
         sM4927kHNmgdLAmdOJcUaooq4Fls6kazNQt4w1MMRaHtqGbpWwJn9u7kgLWCURzqMRTf
         2cPGOxYYmUEjbdKsfi42fsLb7w/tQlDUVK7shAd7uz9nJRH2dBDas+GZgA6LlAv1HMNa
         MmCgfS06B5Kw8QYIhymNNNEGSC8ncN3Nv9Gp5J5QBPjinvUBz6IcumbDcBEmkboMJe3R
         MBc0C3lN8cFUaAL7CPJ0f4GV/46SHHbtVHBA27DmqE8TdDIEAT3+39zofoumhHWODwzd
         TUEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kBso4vxCR9mE3vQ4KCSh4OicS8VHOel88RWScgRFJBk=;
        b=flfsQL0wZ/A6+Goi6LPE+gH22FWSasb1ovAdkBsfwOpnf0le9iqOjJU4hPdHqSiX/i
         LvB802/G2uWiz9U2z81rlzCZVLV/MqJPSt/Wsyyvc4pPhEzryNZJ2gGnxBSChP2DwtxP
         Ec1svqPijLGj8lo+uKTj/p28VohPC9tdiqxm+HMf8dUOXzMYbb5GkELHDXSlK/0jBXlQ
         sav/YaVkrK36lfoyDRrBS/bu3cCbSxaLRPla7rsokTH+e/TWEhFmCd3HNKhx1sE3UfgO
         OOADPKOWGy9XICj4iafrnj7firzFAt9/XZ9Undckai9d7lWLrhZDWPpfQgd7mI/eFWrw
         Bi+A==
X-Gm-Message-State: AOAM530TdBRBdd7VcrP+6PstGG/PXXlhWbUEb0NHLqb+Tt7oJHXiiWdf
        xYsyKGvp+6DfHKNC+kANG9/vxA==
X-Google-Smtp-Source: ABdhPJzT5Lxrn1lE6LsYsNffjnJfSmro/RYoAcykIgoXTteKKgssuuc9jkVKqIbv9z4/eKjG4gLrXQ==
X-Received: by 2002:a92:2c04:: with SMTP id t4mr6438047ile.99.1616255833193;
        Sat, 20 Mar 2021 08:57:13 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id n16sm4501698ilq.71.2021.03.20.08.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 08:57:12 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/5] net: ipa: split sequencer type in two
Date:   Sat, 20 Mar 2021 10:57:05 -0500
Message-Id: <20210320155707.2009962-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210320155707.2009962-1-elder@linaro.org>
References: <20210320155707.2009962-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An IPA endpoint has a sequencer that must be configured based on how
the endpoint is to be used.  Currently the IPA code programs the
sequencer type by splitting a value into four 4-bit nibbles.  Doing
that doesn't really add much value, and regardless, a better way of
splitting the sequencer type is into two halves--the lower byte
describing how normal packet processing is handled, and the next
byte describing information about processing replicas.

So split the sequencer type into two sub-parts:  the sequencer type
and the replication sequencer type.  Define the values supported for
the "main" sequencer type, and define the values supported for the
replication part separately.

In addition, the sequencer type names are quite verbose, encoding
what the type includes, but also what it *excludes*.  Rename the
sequencer types in a way that mainly describes the number of passes
that a packet takes through the IPA processing pipeline, and how
many of those passes end by supplying the processed packet to the
microprocessor.

The result expands the supported types beyond what is required for
now, but simplifies the way these are defined.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-sc7180.c |  8 ++++--
 drivers/net/ipa/ipa_data-sdm845.c |  7 +++--
 drivers/net/ipa/ipa_data.h        |  6 ++--
 drivers/net/ipa/ipa_endpoint.c    | 13 ++++-----
 drivers/net/ipa/ipa_endpoint.h    |  1 +
 drivers/net/ipa/ipa_reg.h         | 48 ++++++++++++++++++++-----------
 6 files changed, 51 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-sc7180.c b/drivers/net/ipa/ipa_data-sc7180.c
index 8fa10d0d9a4e7..fd2265d032cc8 100644
--- a/drivers/net/ipa/ipa_data-sc7180.c
+++ b/drivers/net/ipa/ipa_data-sc7180.c
@@ -31,7 +31,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 			.tlv_count	= 20,
 		},
 		.endpoint = {
-			.seq_type	= IPA_SEQ_DMA_ONLY,
+			.seq_type	= IPA_SEQ_DMA,
 			.config = {
 				.resource_group	= 0,
 				.dma_mode	= true,
@@ -51,6 +51,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		},
 		.endpoint = {
 			.seq_type	= IPA_SEQ_INVALID,
+			.seq_rep_type	= IPA_SEQ_REP_INVALID,
 			.config = {
 				.resource_group	= 0,
 				.aggregation	= true,
@@ -73,8 +74,8 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		},
 		.endpoint = {
 			.filter_support	= true,
-			.seq_type	=
-				IPA_SEQ_PKT_PROCESS_NO_DEC_NO_UCP_DMAP,
+			.seq_type	= IPA_SEQ_1_PASS_SKIP_LAST_UC,
+			.seq_rep_type	= IPA_SEQ_REP_DMA_PARSER,
 			.config = {
 				.resource_group	= 0,
 				.checksum	= true,
@@ -99,6 +100,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		},
 		.endpoint = {
 			.seq_type	= IPA_SEQ_INVALID,
+			.seq_rep_type	= IPA_SEQ_REP_INVALID,
 			.config = {
 				.resource_group	= 0,
 				.checksum	= true,
diff --git a/drivers/net/ipa/ipa_data-sdm845.c b/drivers/net/ipa/ipa_data-sdm845.c
index d9659fd22322a..7f7625cd96b0d 100644
--- a/drivers/net/ipa/ipa_data-sdm845.c
+++ b/drivers/net/ipa/ipa_data-sdm845.c
@@ -36,7 +36,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 			.tlv_count	= 20,
 		},
 		.endpoint = {
-			.seq_type	= IPA_SEQ_DMA_ONLY,
+			.seq_type	= IPA_SEQ_DMA,
 			.config = {
 				.resource_group	= 1,
 				.dma_mode	= true,
@@ -56,6 +56,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		},
 		.endpoint = {
 			.seq_type	= IPA_SEQ_INVALID,
+			.seq_rep_type	= IPA_SEQ_REP_INVALID,
 			.config = {
 				.resource_group	= 1,
 				.aggregation	= true,
@@ -78,8 +79,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		},
 		.endpoint = {
 			.filter_support	= true,
-			.seq_type	=
-				IPA_SEQ_2ND_PKT_PROCESS_PASS_NO_DEC_UCP,
+			.seq_type	= IPA_SEQ_2_PASS_SKIP_LAST_UC,
 			.config = {
 				.resource_group	= 1,
 				.checksum	= true,
@@ -104,6 +104,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		},
 		.endpoint = {
 			.seq_type	= IPA_SEQ_INVALID,
+			.seq_rep_type	= IPA_SEQ_REP_INVALID,
 			.config = {
 				.resource_group	= 1,
 				.checksum	= true,
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index 4162c4722c00c..8808941f44afa 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -154,7 +154,8 @@ struct ipa_endpoint_config_data {
 /**
  * struct ipa_endpoint_data - IPA endpoint configuration data
  * @filter_support:	whether endpoint supports filtering
- * @seq_type:		hardware sequencer type used for endpoint
+ * @seq_type:		primary packet processing sequencer type
+ * @seq_rep_type:	sequencer type for replication processing
  * @config:		hardware configuration (see above)
  *
  * Not all endpoints support the IPA filtering capability.  A filter table
@@ -170,8 +171,9 @@ struct ipa_endpoint_config_data {
  */
 struct ipa_endpoint_data {
 	bool filter_support;
-	/* The next two are specified only for AP endpoints */
+	/* The next three are specified only for AP endpoints */
 	enum ipa_seq_type seq_type;
+	enum ipa_seq_rep_type seq_rep_type;
 	struct ipa_endpoint_config_data config;
 };
 
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 7209ee3c31244..aab66bc4f2563 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -884,18 +884,16 @@ static void ipa_endpoint_init_rsrc_grp(struct ipa_endpoint *endpoint)
 static void ipa_endpoint_init_seq(struct ipa_endpoint *endpoint)
 {
 	u32 offset = IPA_REG_ENDP_INIT_SEQ_N_OFFSET(endpoint->endpoint_id);
-	u32 seq_type = endpoint->seq_type;
 	u32 val = 0;
 
 	if (!endpoint->toward_ipa)
 		return;		/* Register not valid for RX endpoints */
 
-	/* Sequencer type is made up of four nibbles */
-	val |= u32_encode_bits(seq_type & 0xf, HPS_SEQ_TYPE_FMASK);
-	val |= u32_encode_bits((seq_type >> 4) & 0xf, DPS_SEQ_TYPE_FMASK);
-	/* The second two apply to replicated packets */
-	val |= u32_encode_bits((seq_type >> 8) & 0xf, HPS_REP_SEQ_TYPE_FMASK);
-	val |= u32_encode_bits((seq_type >> 12) & 0xf, DPS_REP_SEQ_TYPE_FMASK);
+	/* Low-order byte configures primary packet processing */
+	val |= u32_encode_bits(endpoint->seq_type, SEQ_TYPE_FMASK);
+
+	/* Second byte configures replicated packet processing */
+	val |= u32_encode_bits(endpoint->seq_rep_type, SEQ_REP_TYPE_FMASK);
 
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
@@ -1767,6 +1765,7 @@ static void ipa_endpoint_init_one(struct ipa *ipa, enum ipa_endpoint_name name,
 	endpoint->ipa = ipa;
 	endpoint->ee_id = data->ee_id;
 	endpoint->seq_type = data->endpoint.seq_type;
+	endpoint->seq_rep_type = data->endpoint.seq_rep_type;
 	endpoint->channel_id = data->channel_id;
 	endpoint->endpoint_id = data->endpoint_id;
 	endpoint->toward_ipa = data->toward_ipa;
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index 881ecc27bd6e3..c48f5324f83cc 100644
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -47,6 +47,7 @@ enum ipa_endpoint_name {
 struct ipa_endpoint {
 	struct ipa *ipa;
 	enum ipa_seq_type seq_type;
+	enum ipa_seq_rep_type seq_rep_type;
 	enum gsi_ee_id ee_id;
 	u32 channel_id;
 	u32 endpoint_id;
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 732e691e9aa62..a7ea11a5d2259 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -580,28 +580,42 @@ static inline u32 rsrc_grp_encoded(enum ipa_version version, u32 rsrc_grp)
 /* Valid only for TX (IPA consumer) endpoints */
 #define IPA_REG_ENDP_INIT_SEQ_N_OFFSET(txep) \
 					(0x0000083c + 0x0070 * (txep))
-#define HPS_SEQ_TYPE_FMASK			GENMASK(3, 0)
-#define DPS_SEQ_TYPE_FMASK			GENMASK(7, 4)
-#define HPS_REP_SEQ_TYPE_FMASK			GENMASK(11, 8)
-#define DPS_REP_SEQ_TYPE_FMASK			GENMASK(15, 12)
+#define SEQ_TYPE_FMASK				GENMASK(7, 0)
+#define SEQ_REP_TYPE_FMASK			GENMASK(15, 8)
 
 /**
- * enum ipa_seq_type - HPS and DPS sequencer type fields in ENDP_INIT_SEQ_N
- * @IPA_SEQ_DMA_ONLY:		only DMA is performed
- * @IPA_SEQ_2ND_PKT_PROCESS_PASS_NO_DEC_UCP:
- *	second packet processing pass + no decipher + microcontroller
- * @IPA_SEQ_PKT_PROCESS_NO_DEC_NO_UCP_DMAP:
- *	packet processing + no decipher + no uCP + HPS REP DMA parser
- * @IPA_SEQ_INVALID:		invalid sequencer type
+ * enum ipa_seq_type - HPS and DPS sequencer type
  *
- * The values defined here are broken into 4-bit nibbles that are written
- * into fields of the ENDP_INIT_SEQ registers.
+ * The low-order byte of the sequencer type register defines the number of
+ * passes a packet takes through the IPA pipeline.  The last pass through can
+ * optionally skip the microprocessor.  Deciphering is optional for all types;
+ * if enabled, an additional mask (two bits) is added to the type value.
+ *
+ * Note: not all combinations of ipa_seq_type and ipa_seq_rep_type are
+ * supported (or meaningful).
  */
+#define IPA_SEQ_DECIPHER			0x11
 enum ipa_seq_type {
-	IPA_SEQ_DMA_ONLY			= 0x0000,
-	IPA_SEQ_2ND_PKT_PROCESS_PASS_NO_DEC_UCP	= 0x0004,
-	IPA_SEQ_PKT_PROCESS_NO_DEC_NO_UCP_DMAP	= 0x0806,
-	IPA_SEQ_INVALID				= 0xffff,
+	IPA_SEQ_DMA				= 0x00,
+	IPA_SEQ_1_PASS				= 0x02,
+	IPA_SEQ_2_PASS_SKIP_LAST_UC		= 0x04,
+	IPA_SEQ_1_PASS_SKIP_LAST_UC		= 0x06,
+	IPA_SEQ_2_PASS				= 0x0a,
+	IPA_SEQ_3_PASS_SKIP_LAST_UC		= 0x0c,
+	IPA_SEQ_INVALID				= 0x0c,
+};
+
+/**
+ * enum ipa_seq_rep_type - replicated packet sequencer type
+ *
+ * This goes in the second byte of the endpoint sequencer type register.
+ *
+ * Note: not all combinations of ipa_seq_type and ipa_seq_rep_type are
+ * supported (or meaningful).
+ */
+enum ipa_seq_rep_type {
+	IPA_SEQ_REP_DMA_PARSER			= 0x08,
+	IPA_SEQ_REP_INVALID			= 0x0c,
 };
 
 #define IPA_REG_ENDP_STATUS_N_OFFSET(ep) \
-- 
2.27.0

