Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560AF2C4941
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 21:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730479AbgKYUpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 15:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730315AbgKYUpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 15:45:32 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38CBC0617A7
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 12:45:32 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id x15so3380548ilq.1
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 12:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8+aZd2Qej8dFIrlKd7njZp3GwtYw6UgJ0cCCsnA9q5s=;
        b=J1uTYtpglpZu1sHO60gS592G+/VwMfgr0dsYa6v4YwCTxVWnuWL0n9SxC83Ph60XUS
         QASK/y9OWOdjba1ByegdEz1z7W5fxKfuMk0bOo6cg3ddfb7PPKUeusgSSCv1/+Cb5bBP
         o4Jhz0wVgAJc8RWrkKJcsKEuy5mCjI3C55gucRbar3zrpnM3KqpHDonHs90Vt9HYyi0p
         QWc4fx3KI+bf+0pkK8S0KEDOryuqM6oQGozf+CpPvV/9YvJIQUp3axt8BiKH1MFK2Vya
         ae5pIZckkNMB+evC2Wsb/BcpuCPWmbB3a5EgR7LjpvbgId4oZFyTDDFygc+u6qxRY9Xj
         AuBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8+aZd2Qej8dFIrlKd7njZp3GwtYw6UgJ0cCCsnA9q5s=;
        b=uUv2XCNzfdNLLiu6vKG0t2on3cXzHdAdJftAKo4ENXkhNpJVkzmB4Otf/BNLQBM0Ug
         olsu247kh1KDja6W7+ZQnMRCO23M3B6FM430wMHPtjTjAL6BzIDhY4yoe4wT3Zyl+jL0
         eACemgLxuKs0SzC+0bEkVayUX2/dKyICJ+GdKNlzGPmWmptFnBKoPVUR/4VLSsH8RB1P
         xeKB7u83hryFRx7MgpJMDbsbI5vRM2ZeNS0qTLBUAJtliu6iIesctQJQRJArz6zbvm8y
         TEm84Z4G8/iSvyyV68EOLXipi3ajPHQdIYLzUi0nNyLFPvAthz1hPoiIloLmODonkap6
         iQgQ==
X-Gm-Message-State: AOAM533bCROtWkTVJqUUth8YUjczBWo7Heicx6AOPvWSWDHb8wsovWjg
        EHtLGLBjgWIrkRFV6zhi6QOHNg==
X-Google-Smtp-Source: ABdhPJyDO6vOuf8m3r0eS/nZZ2OT6rb3DvPcZDqwIgt/+Ig+1+r94Irp/WHWG1EvolAqS4XCX1bmYA==
X-Received: by 2002:a92:cc92:: with SMTP id x18mr4557726ilo.63.1606337132111;
        Wed, 25 Nov 2020 12:45:32 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id n10sm1462225iom.36.2020.11.25.12.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 12:45:31 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/6] net: ipa: add new most-significant bits to registers
Date:   Wed, 25 Nov 2020 14:45:19 -0600
Message-Id: <20201125204522.5884-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201125204522.5884-1-elder@linaro.org>
References: <20201125204522.5884-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPA v4.5 adds a few fields to the endpoint header and extended
header configuration registers that represent new high-order bits
for certain offsets and sizes.  Add code to incorporate these upper
bits into the registers for IPA v4.5.

This includes creating ipa_header_size_encoded(), which handles
encoding the metadata offset field for use in the ENDP_INIT_HDR
register in a way appropriate for the hardware version.  This and
ipa_metadata_offset_encoded() ensure the mask argument passed to
u32_encode_bits() is constant.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 39 ++++++++++++++++++++++++++--------
 drivers/net/ipa/ipa_reg.h      | 38 +++++++++++++++++++++++++++++++--
 2 files changed, 66 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 9707300457517..f28ea062aaf1d 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -485,28 +485,34 @@ static void ipa_endpoint_init_cfg(struct ipa_endpoint *endpoint)
 static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
 {
 	u32 offset = IPA_REG_ENDP_INIT_HDR_N_OFFSET(endpoint->endpoint_id);
+	struct ipa *ipa = endpoint->ipa;
 	u32 val = 0;
 
 	if (endpoint->data->qmap) {
 		size_t header_size = sizeof(struct rmnet_map_header);
+		enum ipa_version version = ipa->version;
 
 		/* We might supply a checksum header after the QMAP header */
 		if (endpoint->toward_ipa && endpoint->data->checksum)
 			header_size += sizeof(struct rmnet_map_ul_csum_header);
-		val |= u32_encode_bits(header_size, HDR_LEN_FMASK);
+		val |= ipa_header_size_encoded(version, header_size);
 
 		/* Define how to fill fields in a received QMAP header */
 		if (!endpoint->toward_ipa) {
-			u32 off;	/* Field offset within header */
+			u32 offset;	/* Field offset within header */
 
 			/* Where IPA will write the metadata value */
-			off = offsetof(struct rmnet_map_header, mux_id);
-			val |= u32_encode_bits(off, HDR_OFST_METADATA_FMASK);
+			offset = offsetof(struct rmnet_map_header, mux_id);
+			val |= ipa_metadata_offset_encoded(version, offset);
 
 			/* Where IPA will write the length */
-			off = offsetof(struct rmnet_map_header, pkt_len);
+			offset = offsetof(struct rmnet_map_header, pkt_len);
+			/* Upper bits are stored in HDR_EXT with IPA v4.5 */
+			if (version == IPA_VERSION_4_5)
+				offset &= field_mask(HDR_OFST_PKT_SIZE_FMASK);
+
 			val |= HDR_OFST_PKT_SIZE_VALID_FMASK;
-			val |= u32_encode_bits(off, HDR_OFST_PKT_SIZE_FMASK);
+			val |= u32_encode_bits(offset, HDR_OFST_PKT_SIZE_FMASK);
 		}
 		/* For QMAP TX, metadata offset is 0 (modem assumes this) */
 		val |= HDR_OFST_METADATA_VALID_FMASK;
@@ -517,13 +523,14 @@ static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
 		/* HDR_METADATA_REG_VALID is 0 (TX only) */
 	}
 
-	iowrite32(val, endpoint->ipa->reg_virt + offset);
+	iowrite32(val, ipa->reg_virt + offset);
 }
 
 static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 {
 	u32 offset = IPA_REG_ENDP_INIT_HDR_EXT_N_OFFSET(endpoint->endpoint_id);
 	u32 pad_align = endpoint->data->rx.pad_align;
+	struct ipa *ipa = endpoint->ipa;
 	u32 val = 0;
 
 	val |= HDR_ENDIANNESS_FMASK;		/* big endian */
@@ -545,9 +552,23 @@ static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 	if (!endpoint->toward_ipa)
 		val |= u32_encode_bits(pad_align, HDR_PAD_TO_ALIGNMENT_FMASK);
 
-	iowrite32(val, endpoint->ipa->reg_virt + offset);
-}
+	/* IPA v4.5 adds some most-significant bits to a few fields,
+	 * two of which are defined in the HDR (not HDR_EXT) register.
+	 */
+	if (ipa->version == IPA_VERSION_4_5) {
+		/* HDR_TOTAL_LEN_OR_PAD_OFFSET is 0, so MSB is 0 */
+		if (endpoint->data->qmap && !endpoint->toward_ipa) {
+			u32 offset;
 
+			offset = offsetof(struct rmnet_map_header, pkt_len);
+			offset >>= hweight32(HDR_OFST_PKT_SIZE_FMASK);
+			val |= u32_encode_bits(offset,
+					       HDR_OFST_PKT_SIZE_MSB_FMASK);
+			/* HDR_ADDITIONAL_CONST_LEN is 0 so MSB is 0 */
+		}
+	}
+	iowrite32(val, ipa->reg_virt + offset);
+}
 
 static void ipa_endpoint_init_hdr_metadata_mask(struct ipa_endpoint *endpoint)
 {
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index f6ac9884fd326..7d10fa6dcbec1 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -367,6 +367,40 @@ enum ipa_cs_offload_en {
 #define HDR_LEN_MSB_FMASK			GENMASK(29, 28)
 #define HDR_OFST_METADATA_MSB_FMASK		GENMASK(31, 30)
 
+/* Encoded value for ENDP_INIT_HDR register HDR_LEN* field(s) */
+static inline u32 ipa_header_size_encoded(enum ipa_version version,
+					  u32 header_size)
+{
+	u32 val;
+
+	val = u32_encode_bits(header_size, HDR_LEN_FMASK);
+	if (version < IPA_VERSION_4_5)
+		return val;
+
+	/* IPA v4.5 adds a few more most-significant bits */
+	header_size >>= hweight32(HDR_LEN_FMASK);
+	val |= u32_encode_bits(header_size, HDR_LEN_MSB_FMASK);
+
+	return val;
+}
+
+/* Encoded value for ENDP_INIT_HDR register OFST_METADATA* field(s) */
+static inline u32 ipa_metadata_offset_encoded(enum ipa_version version,
+					      u32 offset)
+{
+	u32 val;
+
+	val = u32_encode_bits(offset, HDR_OFST_METADATA_FMASK);
+	if (version < IPA_VERSION_4_5)
+		return val;
+
+	/* IPA v4.5 adds a few more most-significant bits */
+	offset >>= hweight32(HDR_OFST_METADATA_FMASK);
+	val |= u32_encode_bits(offset, HDR_OFST_METADATA_MSB_FMASK);
+
+	return val;
+}
+
 #define IPA_REG_ENDP_INIT_HDR_EXT_N_OFFSET(ep) \
 					(0x00000814 + 0x0070 * (ep))
 #define HDR_ENDIANNESS_FMASK			GENMASK(0, 0)
@@ -461,7 +495,7 @@ enum ipa_aggr_type {
 
 #define IPA_REG_ENDP_INIT_RSRC_GRP_N_OFFSET(ep) \
 					(0x00000838 + 0x0070 * (ep))
-/* Encoded value for RSRC_GRP endpoint register RSRC_GRP field */
+/* Encoded value for ENDP_INIT_RSRC_GRP register RSRC_GRP field */
 static inline u32 rsrc_grp_encoded(enum ipa_version version, u32 rsrc_grp)
 {
 	switch (version) {
@@ -492,7 +526,7 @@ static inline u32 rsrc_grp_encoded(enum ipa_version version, u32 rsrc_grp)
  * @IPA_SEQ_INVALID:		invalid sequencer type
  *
  * The values defined here are broken into 4-bit nibbles that are written
- * into fields of the INIT_SEQ_N endpoint registers.
+ * into fields of the ENDP_INIT_SEQ registers.
  */
 enum ipa_seq_type {
 	IPA_SEQ_DMA_ONLY			= 0x0000,
-- 
2.20.1

