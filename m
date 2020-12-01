Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01082C9429
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 01:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389143AbgLAAnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 19:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389120AbgLAAnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 19:43:07 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DA6C0617A6
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:41:49 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id j23so13815601iog.6
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=64NrqBqXJ2U8gjPFWplVOOWWmBFWayfw8m+D3SjQpcI=;
        b=QBputtHQCn3AuhyfFv2KupMjDulR1nDuAV/0EYtYARr1AeMmUdqEPB3DSTum/mC19d
         dBlGvIlmCknREObP07ORMcLhw6b6RPcDV+Qss9J7xQHRCBq12Y+/Visjv93UedJl/f+3
         d+zGfRsnO3Ef45utKJZtQ7hP0eLRMgzkCE48kDX+qdpT5/WQgF9rO0sP5avsqX6zEDUK
         NRGT01SfhM7PpoBzbDRgHJlLuTu14WPVN4BCCghxsYbsBnm42Is2/wiSlt00tGXt/Fjt
         GRbxS4Zamt2cKpiI4XYjwaHIn/CQrzhtxintCIbn97PSRT4PBxhhT5ClQzyKE3+a5SRZ
         I21A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=64NrqBqXJ2U8gjPFWplVOOWWmBFWayfw8m+D3SjQpcI=;
        b=oEjB/l0NJEZDuRJ30S/Hj5BcnsSM2m6tBzms5JiW3hOzLpktdArmX3QS3WlN/Da2bx
         SJghhAc+RE3t3BkVZ7sunvscthCJdm+rhIfhRxFTvV7DryFk6oJyLTcIzJB/Z2ySAcI2
         B76QH6V3i1W0m1zmbMnV3ynZ4/mggre8P7MS5d1QpoWyw0IY+K4NQOEfNDzfJUQvVajC
         YBkHLX4q5DBMY/1/+2J4wpbn3KQscs7fTsIVYo3O9FtCEiJ26dIxFpEdcUbqf+h06KSA
         lvrv586D71dd3oiN2mb3/p7eE3a+8cT3WHEIoCHBk9OCAl0+FyWqKEotyWrn4JW7mbGx
         2PZQ==
X-Gm-Message-State: AOAM531wY2XEFD8A5CvSsdsBGvnBl6wMRzE4czc7EkCbxBwQsYh0kS5h
        IDo1hMIarfTJBZtoxQohwyE7Tg==
X-Google-Smtp-Source: ABdhPJxvDJI7TOvLzmsll4O8E919huKYHI7L9Whx0FelhoxnqjBWxqwYA0khrXEYMyK45dxgFpFBGQ==
X-Received: by 2002:a5d:8ad6:: with SMTP id e22mr375853iot.154.1606783308850;
        Mon, 30 Nov 2020 16:41:48 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id p7sm138561iln.11.2020.11.30.16.41.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 16:41:48 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, cpratapa@codeaurora.org,
        bjorn.andersson@linaro.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] net: ipa: add support for inline checksum offload
Date:   Mon, 30 Nov 2020 18:41:43 -0600
Message-Id: <20201201004143.27569-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201201004143.27569-1-elder@linaro.org>
References: <20201201004143.27569-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Starting with IPA v4.5, IP payload checksum offload is implemented
differently.

Prior to v4.5, the IPA hardware appends an rmnet_map_dl_csum_trailer
structure to each packet if checksum offload is enabled in the
download direction (modem->AP).  In the upload direction (AP->modem)
a rmnet_map_ul_csum_header structure is prepended before each sent
packet.

Starting with IPA v4.5, checksum offload is implemented using a
single new rmnet_map_v5_csum_header structure which sits between
the QMAP header and the packet data.  The same header structure
is used in both directions.

The new header contains a header type (CSUM_OFFLOAD); a checksum
flag; and a flag indicating whether any other headers follow this
one.  The checksum flag indicates whether the hardware should
compute (and insert) the checksum on a sent packet.  On a received
packet the checksum flag indicates whether the hardware confirms the
checksum value in the payload is correct.

To function, the rmnet driver must also add support for this new
"inline" checksum offload.  The changes implementing this will be
submitted soon.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 50 ++++++++++++++++++++++++++--------
 drivers/net/ipa/ipa_reg.h      |  1 +
 2 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 27f543b6780b1..1a4749f7f03e6 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -434,33 +434,63 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
 static void ipa_endpoint_init_cfg(struct ipa_endpoint *endpoint)
 {
 	u32 offset = IPA_REG_ENDP_INIT_CFG_N_OFFSET(endpoint->endpoint_id);
+	enum ipa_cs_offload_en enabled;
 	u32 val = 0;
 
 	/* FRAG_OFFLOAD_EN is 0 */
 	if (endpoint->data->checksum) {
+		enum ipa_version version = endpoint->ipa->version;
+
 		if (endpoint->toward_ipa) {
 			u32 checksum_offset;
 
-			val |= u32_encode_bits(IPA_CS_OFFLOAD_UL,
-					       CS_OFFLOAD_EN_FMASK);
 			/* Checksum header offset is in 4-byte units */
 			checksum_offset = sizeof(struct rmnet_map_header);
 			checksum_offset /= sizeof(u32);
 			val |= u32_encode_bits(checksum_offset,
 					       CS_METADATA_HDR_OFFSET_FMASK);
+
+			enabled = version < IPA_VERSION_4_5
+					? IPA_CS_OFFLOAD_UL
+					: IPA_CS_OFFLOAD_INLINE;
 		} else {
-			val |= u32_encode_bits(IPA_CS_OFFLOAD_DL,
-					       CS_OFFLOAD_EN_FMASK);
+			enabled = version < IPA_VERSION_4_5
+					? IPA_CS_OFFLOAD_DL
+					: IPA_CS_OFFLOAD_INLINE;
 		}
 	} else {
-		val |= u32_encode_bits(IPA_CS_OFFLOAD_NONE,
-				       CS_OFFLOAD_EN_FMASK);
+		enabled = IPA_CS_OFFLOAD_NONE;
 	}
+	val |= u32_encode_bits(enabled, CS_OFFLOAD_EN_FMASK);
 	/* CS_GEN_QMB_MASTER_SEL is 0 */
 
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
 
+static u32
+ipa_qmap_header_size(enum ipa_version version, struct ipa_endpoint *endpoint)
+{
+	u32 header_size = sizeof(struct rmnet_map_header);
+
+	/* ipa_assert(endpoint->data->qmap); */
+
+	/* We might supply a checksum header after the QMAP header */
+	if (endpoint->data->checksum) {
+		if (version < IPA_VERSION_4_5) {
+			size_t size = sizeof(struct rmnet_map_ul_csum_header);
+
+			/* Checksum header inserted for AP TX endpoints */
+			if (endpoint->toward_ipa)
+				header_size += size;
+		} else {
+			/* Checksum header is used in both directions */
+			header_size += sizeof(struct rmnet_map_v5_csum_header);
+		}
+	}
+
+	return header_size;
+}
+
 /**
  * ipa_endpoint_init_hdr() - Initialize HDR endpoint configuration register
  * @endpoint:	Endpoint pointer
@@ -489,13 +519,11 @@ static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
 	u32 val = 0;
 
 	if (endpoint->data->qmap) {
-		size_t header_size = sizeof(struct rmnet_map_header);
 		enum ipa_version version = ipa->version;
+		size_t header_size;
 
-		/* We might supply a checksum header after the QMAP header */
-		if (endpoint->toward_ipa && endpoint->data->checksum)
-			header_size += sizeof(struct rmnet_map_ul_csum_header);
-		val |= ipa_header_size_encoded(version, header_size);
+		header_size = ipa_qmap_header_size(version, endpoint);
+		val = ipa_header_size_encoded(version, header_size);
 
 		/* Define how to fill fields in a received QMAP header */
 		if (!endpoint->toward_ipa) {
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 3fabafd7e32c6..6738cafe979ce 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -356,6 +356,7 @@ enum ipa_cs_offload_en {
 	IPA_CS_OFFLOAD_NONE		= 0x0,
 	IPA_CS_OFFLOAD_UL		= 0x1,
 	IPA_CS_OFFLOAD_DL		= 0x2,
+	IPA_CS_OFFLOAD_INLINE		= 0x1,	/* IPA v4.5 */
 };
 
 #define IPA_REG_ENDP_INIT_HDR_N_OFFSET(ep) \
-- 
2.20.1

