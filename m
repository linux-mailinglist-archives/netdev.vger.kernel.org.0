Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26023989DE
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbhFBMoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:44:32 -0400
Received: from mail-il1-f182.google.com ([209.85.166.182]:38783 "EHLO
        mail-il1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbhFBMo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 08:44:28 -0400
Received: by mail-il1-f182.google.com with SMTP id j30so1985897ila.5
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 05:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X1l7jGyVWidF6uLQ2hGdIjNWnuokOqt3x1cj/hzGKNs=;
        b=sf7E38MEGXMM+gyDmrNCm9O5Xnth6X9bGVa5y3jYUtGs57a5nrCX5jo/aPzLTyWN2R
         9fxKNOPGk1W8AhmhL8aprqgoEWYU/ym51GfNYblTFHCwWLL06SqdMg+yXhLmtjjz+IzC
         NxFVaV5IGxiOjXtVP97YCiD+kpHueRb3k22/jTOdXvvzwlKQJMA9g397Ku2I8Bb8KiQT
         SKzZ8JsOO767LsOO9CTv1wUqVtVVOjzqzY8tcEJ2Xw/zMPOyh/MX0lsQGnO1wl9ffRpB
         K6tlzDc71ENo+sO4LwdUlFgb7lfeycWCdtK2VT61oiUp0T2UQ7bqYx2Bk10OoHkHMcB3
         TkQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X1l7jGyVWidF6uLQ2hGdIjNWnuokOqt3x1cj/hzGKNs=;
        b=plMfNvklpmNdAtPSdV8bMkNFsjX074SS5cQiW7hv1LbNWj9bMYK9QKEWLEfcFutSah
         fLxo30t7HKaMGUpVeHPS28Vo9hp63Hb/gS14FPRAcQNy3HBRnL2xFFfBDEuIXlHf6rYe
         yppZlQj9Cej9elORtFGern2j4kk004A7coS+mo5Ck7MULWA15QfpZG2Cs2N7CzB70QGC
         HvCnlh/zudFJRFYRr4QezpfllPDprcSfAqNTR3SGQjQIh2UIqWpTGlCI3GWTotb7ykCH
         ODsNOU5bLBd6jnUgPsf89tcRKbmf/YqRsSupD6kYHNB7wXBYjh8+qQaImpz7LwsTJaHd
         fFZA==
X-Gm-Message-State: AOAM532ek7Bc4vkgp0PQOGt07xEPitMKjfl2E3SdN0krVIjQ2mN9/i/o
        96aZwmZESksQwU546gds06Sz+A==
X-Google-Smtp-Source: ABdhPJx0CIK5wwRA6r+XcwIIkDN8UjyW6DYCtu8eYzyxHSLPINbWl+/kdR4/GPuwq9UrkIDqEMrH2w==
X-Received: by 2002:a05:6e02:12af:: with SMTP id f15mr23514489ilr.77.1622637696584;
        Wed, 02 Jun 2021 05:41:36 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id v18sm11087054iob.3.2021.06.02.05.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 05:41:36 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        sharathv@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] net: ipa: add support for inline checksum offload
Date:   Wed,  2 Jun 2021 07:41:30 -0500
Message-Id: <20210602124131.298325-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210602124131.298325-1-elder@linaro.org>
References: <20210602124131.298325-1-elder@linaro.org>
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

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 47 ++++++++++++++++++++++++++--------
 drivers/net/ipa/ipa_reg.h      |  1 +
 2 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index ccc99ad983eb5..03719fb6a15a4 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -457,28 +457,34 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
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
@@ -498,6 +504,27 @@ static void ipa_endpoint_init_nat(struct ipa_endpoint *endpoint)
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
 
+static u32
+ipa_qmap_header_size(enum ipa_version version, struct ipa_endpoint *endpoint)
+{
+	u32 header_size = sizeof(struct rmnet_map_header);
+
+	/* Without checksum offload, we just have the MAP header */
+	if (!endpoint->data->checksum)
+		return header_size;
+
+	if (version < IPA_VERSION_4_5) {
+		/* Checksum header inserted for AP TX endpoints only */
+		if (endpoint->toward_ipa)
+			header_size += sizeof(struct rmnet_map_ul_csum_header);
+	} else {
+		/* Checksum header is used in both directions */
+		header_size += sizeof(struct rmnet_map_v5_csum_header);
+	}
+
+	return header_size;
+}
+
 /**
  * ipa_endpoint_init_hdr() - Initialize HDR endpoint configuration register
  * @endpoint:	Endpoint pointer
@@ -526,13 +553,11 @@ static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
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
index 286ea9634c49d..b89dec5865a5b 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -368,6 +368,7 @@ enum ipa_cs_offload_en {
 	IPA_CS_OFFLOAD_NONE		= 0x0,
 	IPA_CS_OFFLOAD_UL		= 0x1,	/* Before IPA v4.5 (TX) */
 	IPA_CS_OFFLOAD_DL		= 0x2,	/* Before IPA v4.5 (RX) */
+	IPA_CS_OFFLOAD_INLINE		= 0x1,	/* IPA v4.5 (TX and RX) */
 };
 
 /* Valid only for TX (IPA consumer) endpoints */
-- 
2.27.0

