Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A621F6E3C
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 21:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgFKTsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 15:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbgFKTsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 15:48:40 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1F1C08C5C2
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 12:48:39 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id o5so7715480iow.8
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 12:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0JFIYUeiF3f9Q06oYwTOYTjAxGcUzRAhuHFXBJE1Izs=;
        b=GBXXgrM7BIxq5fEPiAAvDhVqsPzhe5VS8GoGfW1LXOwFycEPaleat0NqeQNJy3GN6l
         dtz1LTkc2oL0ILGOQkjxZ1VOE84qV3BgrLX+PXyhG328eWtGWjh9BsJVv/a+W3qTl/lf
         /iskJo7XwzME+e71Df46I999FI/UYnAF8fus1XNvqGwinAiutkviMnwkH9io4lTvM2P2
         7cshsBT6nCUlxELJfqOKZ4HaOImfx5RcQiFKKtXl+tJAPz64yyxODYUu0I65kARcKcVS
         DuT1xvHyorG/AFx7PmXsNGLF8NWzwArLo2HduIHs8+v/gRsaLAcIN0gzZJPD+SllXiLn
         rhaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0JFIYUeiF3f9Q06oYwTOYTjAxGcUzRAhuHFXBJE1Izs=;
        b=aLFWAH9ouWD2DbrZJ2ENyW+LTo1CBpA9/6qWDvG17I80KV1B/72l1M+fSK01A+Va7Q
         C0dn/i+GGdJwoZM7R4N5FC0Xhh7zFN6dbv5iPNiQHb2U7Ef+O9VqMVyJeTAfSW1kzHcO
         6teXufESlSv5cN5trqvLDLZTANMn2Oj6aN1iSPqxSigBB/R4j1UuH8vwXQveYKHA9PQx
         LdUDdmcTPv1pg6FKZHWYm0fRqrNiXMxHGIAMVHPBI92qIFuzXpwQ7HKo/BVJz2LMX+7i
         HtbPEd0V0tjpZnZ4QBp/JJZuC2/W3+NfUizvvk3mc5As03Yx7Mz4cGj7XDNzuziEmZj+
         s+IA==
X-Gm-Message-State: AOAM533UlZ9IGTdse/k1CmSEDAGeiV5k2mj2KUyJqKcSLFuU7AHZrXz3
        Vrscg/+7bSTfy9rgNW2askxJ+Q==
X-Google-Smtp-Source: ABdhPJzmtm/KDRd9aDf2H8DXYjNjaL2B6uJuiSLZuWtNtC7md2mAa8McZMCzENVDHoPNIIjKe8jB6g==
X-Received: by 2002:a02:3406:: with SMTP id x6mr4788564jae.24.1591904919088;
        Thu, 11 Jun 2020 12:48:39 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id d13sm1981397ilo.40.2020.06.11.12.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 12:48:38 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 1/4] net: ipa: program metadata mask differently
Date:   Thu, 11 Jun 2020 14:48:30 -0500
Message-Id: <20200611194833.2640177-2-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200611194833.2640177-1-elder@linaro.org>
References: <20200611194833.2640177-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The way the mask value is programmed for QMAP RX endpoints was based
on some wrong assumptions about the way metadata containing the QMAP
mux_id value is formatted.  The metadata value supplied by the
modem is *not* in QMAP format, and in fact contains the mux_id we
want in its (big endian) low-order byte.  That byte must be written
by the IPA into offset 1 of the QMAP header it inserts before the
received packet.

QMAP TX endpoints *do* use a QMAP header as the metadata sent with
each packet.  The modem assumes this, and based on that assumes the
mux_id is in the second byte.  To match those assumptions we must
program the modem TX (QMAP) endpoint HDR register to indicate the
metadata will be found at offset 0 in the message header.

The previous configuration managed to work, but it was not working
correctly.  This patch fixes a bug whose symptom was receipt of
messages containing the wrong QMAP mux_id.

In fixing this, get rid of ipa_rmnet_mux_id_metadata_mask(), which
was more or less defined so there was a separate place to explain
what was happening as we generated the mask value.  Instead, put a
longer description of how this works above ipa_endpoint_init_hdr(),
and define the metadata mask to use as a simple constant.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2:  Added back the static specifier to ipa_endpoint_init_hdr(),
     as suggested by the kernel test robot <lkp@intel.com>.

 drivers/net/ipa/ipa_endpoint.c | 72 ++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 66649a806dd1..2825dca23ec4 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -32,6 +32,9 @@
 /* The amount of RX buffer space consumed by standard skb overhead */
 #define IPA_RX_BUFFER_OVERHEAD	(PAGE_SIZE - SKB_MAX_ORDER(NET_SKB_PAD, 0))
 
+/* Where to find the QMAP mux_id for a packet within modem-supplied metadata */
+#define IPA_ENDPOINT_QMAP_METADATA_MASK		0x000000ff /* host byte order */
+
 #define IPA_ENDPOINT_RESET_AGGR_RETRY_MAX	3
 #define IPA_AGGR_TIME_LIMIT_DEFAULT		1000	/* microseconds */
 
@@ -433,6 +436,24 @@ static void ipa_endpoint_init_cfg(struct ipa_endpoint *endpoint)
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
 
+/**
+ * We program QMAP endpoints so each packet received is preceded by a QMAP
+ * header structure.  The QMAP header contains a 1-byte mux_id and 2-byte
+ * packet size field, and we have the IPA hardware populate both for each
+ * received packet.  The header is configured (in the HDR_EXT register)
+ * to use big endian format.
+ *
+ * The packet size is written into the QMAP header's pkt_len field.  That
+ * location is defined here using the HDR_OFST_PKT_SIZE field.
+ *
+ * The mux_id comes from a 4-byte metadata value supplied with each packet
+ * by the modem.  It is *not* a QMAP header, but it does contain the mux_id
+ * value that we want, in its low-order byte.  A bitmask defined in the
+ * endpoint's METADATA_MASK register defines which byte within the modem
+ * metadata contains the mux_id.  And the OFST_METADATA field programmed
+ * here indicates where the extracted byte should be placed within the QMAP
+ * header.
+ */
 static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
 {
 	u32 offset = IPA_REG_ENDP_INIT_HDR_N_OFFSET(endpoint->endpoint_id);
@@ -441,25 +462,31 @@ static void ipa_endpoint_init_hdr(struct ipa_endpoint *endpoint)
 	if (endpoint->data->qmap) {
 		size_t header_size = sizeof(struct rmnet_map_header);
 
+		/* We might supply a checksum header after the QMAP header */
 		if (endpoint->toward_ipa && endpoint->data->checksum)
 			header_size += sizeof(struct rmnet_map_ul_csum_header);
-
 		val |= u32_encode_bits(header_size, HDR_LEN_FMASK);
-		/* metadata is the 4 byte rmnet_map header itself */
-		val |= HDR_OFST_METADATA_VALID_FMASK;
-		val |= u32_encode_bits(0, HDR_OFST_METADATA_FMASK);
-		/* HDR_ADDITIONAL_CONST_LEN is 0; (IPA->AP only) */
+
+		/* Define how to fill mux_id in a received QMAP header */
 		if (!endpoint->toward_ipa) {
-			u32 size_offset = offsetof(struct rmnet_map_header,
-						   pkt_len);
+			u32 off;	/* Field offset within header */
 
+			/* Where IPA will write the metadata value */
+			off = offsetof(struct rmnet_map_header, mux_id);
+			val |= u32_encode_bits(off, HDR_OFST_METADATA_FMASK);
+
+			/* Where IPA will write the length */
+			off = offsetof(struct rmnet_map_header, pkt_len);
 			val |= HDR_OFST_PKT_SIZE_VALID_FMASK;
-			val |= u32_encode_bits(size_offset,
-					       HDR_OFST_PKT_SIZE_FMASK);
+			val |= u32_encode_bits(off, HDR_OFST_PKT_SIZE_FMASK);
 		}
+		/* For QMAP TX, metadata offset is 0 (modem assumes this) */
+		val |= HDR_OFST_METADATA_VALID_FMASK;
+
+		/* HDR_ADDITIONAL_CONST_LEN is 0; (RX only) */
 		/* HDR_A5_MUX is 0 */
 		/* HDR_LEN_INC_DEAGG_HDR is 0 */
-		/* HDR_METADATA_REG_VALID is 0; (AP->IPA only) */
+		/* HDR_METADATA_REG_VALID is 0 (TX only) */
 	}
 
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
@@ -482,28 +509,6 @@ static void ipa_endpoint_init_hdr_ext(struct ipa_endpoint *endpoint)
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
 
-/**
- * Generate a metadata mask value that will select only the mux_id
- * field in an rmnet_map header structure.  The mux_id is at offset
- * 1 byte from the beginning of the structure, but the metadata
- * value is treated as a 4-byte unit.  So this mask must be computed
- * with endianness in mind.  Note that ipa_endpoint_init_hdr_metadata_mask()
- * will convert this value to the proper byte order.
- *
- * Marked __always_inline because this is really computing a
- * constant value.
- */
-static __always_inline __be32 ipa_rmnet_mux_id_metadata_mask(void)
-{
-	size_t mux_id_offset = offsetof(struct rmnet_map_header, mux_id);
-	u32 mux_id_mask = 0;
-	u8 *bytes;
-
-	bytes = (u8 *)&mux_id_mask;
-	bytes[mux_id_offset] = 0xff;	/* mux_id is 1 byte */
-
-	return cpu_to_be32(mux_id_mask);
-}
 
 static void ipa_endpoint_init_hdr_metadata_mask(struct ipa_endpoint *endpoint)
 {
@@ -513,8 +518,9 @@ static void ipa_endpoint_init_hdr_metadata_mask(struct ipa_endpoint *endpoint)
 
 	offset = IPA_REG_ENDP_INIT_HDR_METADATA_MASK_N_OFFSET(endpoint_id);
 
+	/* Note that HDR_ENDIANNESS indicates big endian header fields */
 	if (!endpoint->toward_ipa && endpoint->data->qmap)
-		val = ipa_rmnet_mux_id_metadata_mask();
+		val = cpu_to_be32(IPA_ENDPOINT_QMAP_METADATA_MASK);
 
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
-- 
2.25.1

