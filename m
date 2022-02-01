Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3985F4A6041
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 16:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240469AbiBAPhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 10:37:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240458AbiBAPho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 10:37:44 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72130C061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 07:37:44 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id q204so21654146iod.8
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 07:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=URTrGhQIDwikEMtGkJNktlFmPyROLJfr+eRicnBkscw=;
        b=oSpfhtalV9fkRO+yVFhL6qZlpuENXtOLy/rXU3d4A5ISAHfLcGTOg1TmBI+lMlJp5q
         +c3W5uqazlS0sSaC2sJASXrFq/651iZq1VX8LVDW1NzBPebIvlT8NX2v7CacsyVPNpMe
         /BLrgntdz4eY5d3aXGu+ovvGnZrfBLRd7jIe3hC16iNQvwyFsgPqRcbDSuV2txMB/u63
         JI2NCPbN2YbN3CNbsqyGyUcJ2W5/fOV8E0v+Ttl1tP30Y9EVdgEZDLeWzq7cPUHU8AfM
         EqoLJGcKN/2hKS/yeyB7Zo68zhAwEZMpj3RMuNYqrZXNz1srpewb3k/yChG7NnnfewJb
         Ye/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=URTrGhQIDwikEMtGkJNktlFmPyROLJfr+eRicnBkscw=;
        b=pL/Vb7u/XyV6WkPIV6o3awoeenISg6KwivUnw3P1I4jIrn/pMQ72VGM1XvXI93s52r
         dLOOgw+PK04ZmF4dv2j8sjelaNpWPgBUnkZvS+8YqDe74gINcbZqlm+tXlYUsfbgMjWJ
         a2LLSe9wipX9dsTOE+pb5EfbEqLss9Ep2kYJLY8MRXPSSAX28Imc0GMW0u8HmbU9lUaQ
         UL1SB7SI/4OUxgmzOoom/GA+ocCb92iYnpS/dMHITNdwgpFIEneFZBbTkI7RYqYMFY55
         akDTBOfnTBMjubf6OEPLhqu9xcKK3ibopspMS7UDtkvcMetaQCgOMjJ73NCdoCluy5ze
         pi5w==
X-Gm-Message-State: AOAM530bmXqu5AAZhnQ7USqt6F4l23ykpH4TwKTYlEiK/3Yh6k85Gtv6
        sxT6jn1nJF7gKDCkPspeCkht7g==
X-Google-Smtp-Source: ABdhPJza6BPAVte0qTAiuBWpU3SmBZC0wxOhGnjDckhdYrIOyB7oxnATK92wCOmkIGQ4Cp+t9SG8IQ==
X-Received: by 2002:a05:6638:358b:: with SMTP id v11mr10722203jal.224.1643729863480;
        Tue, 01 Feb 2022 07:37:43 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id n12sm1234583ili.69.2022.02.01.07.37.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 07:37:42 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, agross@kernel.org, mka@chromium.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] net: ipa: define per-endpoint receive buffer size
Date:   Tue,  1 Feb 2022 09:37:36 -0600
Message-Id: <20220201153737.601149-2-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220201153737.601149-1-elder@linaro.org>
References: <20220201153737.601149-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow RX endpoints to have differing receive buffer sizes.  Define
the receive buffer size in the configuration data, and use that
rather than IPA_RX_BUFFER_SIZE when configuring the endpoint.

Add verification in ipa_endpoint_data_valid_one() that the receive
buffer specified for AP RX endpoints is both big enough to handle at
least one full packet, and not so big in an aggregating endpoint
that its size can't be represented when programming the hardware.
Move aggr_byte_limit_max() up in "ipa_endpoint.c" so it can be used
earlier in the file without a forward-reference.

Initially we'll just keep the 8KB receive buffer size already in use
for all AP RX endpoints..

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-v3.1.c   |   2 +
 drivers/net/ipa/ipa_data-v3.5.1.c |   2 +
 drivers/net/ipa/ipa_data-v4.11.c  |   2 +
 drivers/net/ipa/ipa_data-v4.2.c   |   2 +
 drivers/net/ipa/ipa_data-v4.5.c   |   2 +
 drivers/net/ipa/ipa_data-v4.9.c   |   2 +
 drivers/net/ipa/ipa_data.h        |   2 +
 drivers/net/ipa/ipa_endpoint.c    | 107 ++++++++++++++++++------------
 8 files changed, 79 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-v3.1.c b/drivers/net/ipa/ipa_data-v3.1.c
index 06ddb85f39b27..8ff351aefd23f 100644
--- a/drivers/net/ipa/ipa_data-v3.1.c
+++ b/drivers/net/ipa/ipa_data-v3.1.c
@@ -101,6 +101,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.aggregation	= true,
 				.status_enable	= true,
 				.rx = {
+					.buffer_size	= 8192,
 					.pad_align	= ilog2(sizeof(u32)),
 				},
 			},
@@ -148,6 +149,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.qmap		= true,
 				.aggregation	= true,
 				.rx = {
+					.buffer_size	= 8192,
 					.aggr_close_eof	= true,
 				},
 			},
diff --git a/drivers/net/ipa/ipa_data-v3.5.1.c b/drivers/net/ipa/ipa_data-v3.5.1.c
index 760c22bbdf70f..d1c466abddb22 100644
--- a/drivers/net/ipa/ipa_data-v3.5.1.c
+++ b/drivers/net/ipa/ipa_data-v3.5.1.c
@@ -92,6 +92,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.aggregation	= true,
 				.status_enable	= true,
 				.rx = {
+					.buffer_size	= 8192,
 					.pad_align	= ilog2(sizeof(u32)),
 				},
 			},
@@ -140,6 +141,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.qmap		= true,
 				.aggregation	= true,
 				.rx = {
+					.buffer_size	= 8192,
 					.aggr_close_eof	= true,
 				},
 			},
diff --git a/drivers/net/ipa/ipa_data-v4.11.c b/drivers/net/ipa/ipa_data-v4.11.c
index fea91451a0c34..8f67c44e19529 100644
--- a/drivers/net/ipa/ipa_data-v4.11.c
+++ b/drivers/net/ipa/ipa_data-v4.11.c
@@ -86,6 +86,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.aggregation	= true,
 				.status_enable	= true,
 				.rx = {
+					.buffer_size	= 8192,
 					.pad_align	= ilog2(sizeof(u32)),
 				},
 			},
@@ -133,6 +134,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.qmap		= true,
 				.aggregation	= true,
 				.rx = {
+					.buffer_size	= 8192,
 					.aggr_close_eof	= true,
 				},
 			},
diff --git a/drivers/net/ipa/ipa_data-v4.2.c b/drivers/net/ipa/ipa_data-v4.2.c
index 2a231e79d5e11..1190a43e8743c 100644
--- a/drivers/net/ipa/ipa_data-v4.2.c
+++ b/drivers/net/ipa/ipa_data-v4.2.c
@@ -82,6 +82,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.aggregation	= true,
 				.status_enable	= true,
 				.rx = {
+					.buffer_size	= 8192,
 					.pad_align	= ilog2(sizeof(u32)),
 				},
 			},
@@ -130,6 +131,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.qmap		= true,
 				.aggregation	= true,
 				.rx = {
+					.buffer_size	= 8192,
 					.aggr_close_eof	= true,
 				},
 			},
diff --git a/drivers/net/ipa/ipa_data-v4.5.c b/drivers/net/ipa/ipa_data-v4.5.c
index 2da2c4194f2e6..944f72b0f285e 100644
--- a/drivers/net/ipa/ipa_data-v4.5.c
+++ b/drivers/net/ipa/ipa_data-v4.5.c
@@ -95,6 +95,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.aggregation	= true,
 				.status_enable	= true,
 				.rx = {
+					.buffer_size	= 8192,
 					.pad_align	= ilog2(sizeof(u32)),
 				},
 			},
@@ -142,6 +143,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.qmap		= true,
 				.aggregation	= true,
 				.rx = {
+					.buffer_size	= 8192,
 					.aggr_close_eof	= true,
 				},
 			},
diff --git a/drivers/net/ipa/ipa_data-v4.9.c b/drivers/net/ipa/ipa_data-v4.9.c
index 2421b5abb5d44..16786bff7ef84 100644
--- a/drivers/net/ipa/ipa_data-v4.9.c
+++ b/drivers/net/ipa/ipa_data-v4.9.c
@@ -87,6 +87,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.aggregation	= true,
 				.status_enable	= true,
 				.rx = {
+					.buffer_size	= 8192,
 					.pad_align	= ilog2(sizeof(u32)),
 				},
 			},
@@ -134,6 +135,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 				.qmap		= true,
 				.aggregation	= true,
 				.rx = {
+					.buffer_size	= 8192,
 					.aggr_close_eof	= true,
 				},
 			},
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index 6d329e9ce5d29..dbbeecf6df298 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -112,6 +112,7 @@ struct ipa_endpoint_tx_data {
 
 /**
  * struct ipa_endpoint_rx_data - configuration data for RX endpoints
+ * @buffer_size: requested receive buffer size (bytes)
  * @pad_align:	power-of-2 boundary to which packet payload is aligned
  * @aggr_close_eof: whether aggregation closes on end-of-frame
  *
@@ -125,6 +126,7 @@ struct ipa_endpoint_tx_data {
  * a "frame" consisting of several transfers has ended.
  */
 struct ipa_endpoint_rx_data {
+	u32 buffer_size;
 	u32 pad_align;
 	bool aggr_close_eof;
 };
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 68291a3efd040..fffd0a784ef2c 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -27,9 +27,6 @@
 
 #define IPA_REPLENISH_BATCH	16
 
-/* RX buffer is 1 page (or a power-of-2 contiguous pages) */
-#define IPA_RX_BUFFER_SIZE	8192	/* PAGE_SIZE > 4096 wastes a LOT */
-
 /* The amount of RX buffer space consumed by standard skb overhead */
 #define IPA_RX_BUFFER_OVERHEAD	(PAGE_SIZE - SKB_MAX_ORDER(NET_SKB_PAD, 0))
 
@@ -75,6 +72,14 @@ struct ipa_status {
 #define IPA_STATUS_FLAGS1_RT_RULE_ID_FMASK	GENMASK(31, 22)
 #define IPA_STATUS_FLAGS2_TAG_FMASK		GENMASK_ULL(63, 16)
 
+static u32 aggr_byte_limit_max(enum ipa_version version)
+{
+	if (version < IPA_VERSION_4_5)
+		return field_max(aggr_byte_limit_fmask(true));
+
+	return field_max(aggr_byte_limit_fmask(false));
+}
+
 static bool ipa_endpoint_data_valid_one(struct ipa *ipa, u32 count,
 			    const struct ipa_gsi_endpoint_data *all_data,
 			    const struct ipa_gsi_endpoint_data *data)
@@ -87,6 +92,9 @@ static bool ipa_endpoint_data_valid_one(struct ipa *ipa, u32 count,
 		return true;
 
 	if (!data->toward_ipa) {
+		u32 buffer_size;
+		u32 limit;
+
 		if (data->endpoint.filter_support) {
 			dev_err(dev, "filtering not supported for "
 					"RX endpoint %u\n",
@@ -94,6 +102,41 @@ static bool ipa_endpoint_data_valid_one(struct ipa *ipa, u32 count,
 			return false;
 		}
 
+		/* Nothing more to check for non-AP RX */
+		if (data->ee_id != GSI_EE_AP)
+			return true;
+
+		buffer_size = data->endpoint.config.rx.buffer_size;
+		/* The buffer size must hold an MTU plus overhead */
+		limit = IPA_MTU + IPA_RX_BUFFER_OVERHEAD;
+		if (buffer_size < limit) {
+			dev_err(dev, "RX buffer size too small for RX endpoint %u (%u < %u)\n",
+				data->endpoint_id, buffer_size, limit);
+			return false;
+		}
+
+		/* For an endpoint supporting receive aggregation, the
+		 * aggregation byte limit defines the point at which an
+		 * aggregation window will close.  It is programmed into the
+		 * IPA hardware as a number of KB.  We don't use "hard byte
+		 * limit" aggregation, so we need to supply enough space in
+		 * a receive buffer to hold a complete MTU plus normal skb
+		 * overhead *after* that aggregation byte limit has been
+		 * crossed.
+		 *
+		 * This check just ensures the receive buffer size doesn't
+		 * exceed what's representable in the aggregation limit field.
+		 */
+		if (data->endpoint.config.aggregation) {
+			limit += SZ_1K * aggr_byte_limit_max(ipa->version);
+			if (buffer_size > limit) {
+				dev_err(dev, "RX buffer size too large for aggregated RX endpoint %u (%u > %u)\n",
+					data->endpoint_id, buffer_size, limit);
+
+				return false;
+			}
+		}
+
 		return true;	/* Nothing more to check for RX */
 	}
 
@@ -156,21 +199,12 @@ static bool ipa_endpoint_data_valid_one(struct ipa *ipa, u32 count,
 	return true;
 }
 
-static u32 aggr_byte_limit_max(enum ipa_version version)
-{
-	if (version < IPA_VERSION_4_5)
-		return field_max(aggr_byte_limit_fmask(true));
-
-	return field_max(aggr_byte_limit_fmask(false));
-}
-
 static bool ipa_endpoint_data_valid(struct ipa *ipa, u32 count,
 				    const struct ipa_gsi_endpoint_data *data)
 {
 	const struct ipa_gsi_endpoint_data *dp = data;
 	struct device *dev = &ipa->pdev->dev;
 	enum ipa_endpoint_name name;
-	u32 limit;
 
 	if (count > IPA_ENDPOINT_COUNT) {
 		dev_err(dev, "too many endpoints specified (%u > %u)\n",
@@ -178,26 +212,6 @@ static bool ipa_endpoint_data_valid(struct ipa *ipa, u32 count,
 		return false;
 	}
 
-	/* The aggregation byte limit defines the point at which an
-	 * aggregation window will close.  It is programmed into the
-	 * IPA hardware as a number of KB.  We don't use "hard byte
-	 * limit" aggregation, which means that we need to supply
-	 * enough space in a receive buffer to hold a complete MTU
-	 * plus normal skb overhead *after* that aggregation byte
-	 * limit has been crossed.
-	 *
-	 * This check ensures we don't define a receive buffer size
-	 * that would exceed what we can represent in the field that
-	 * is used to program its size.
-	 */
-	limit = aggr_byte_limit_max(ipa->version) * SZ_1K;
-	limit += IPA_MTU + IPA_RX_BUFFER_OVERHEAD;
-	if (limit < IPA_RX_BUFFER_SIZE) {
-		dev_err(dev, "buffer size too big for aggregation (%u > %u)\n",
-			IPA_RX_BUFFER_SIZE, limit);
-		return false;
-	}
-
 	/* Make sure needed endpoints have defined data */
 	if (ipa_gsi_endpoint_data_empty(&data[IPA_ENDPOINT_AP_COMMAND_TX])) {
 		dev_err(dev, "command TX endpoint not defined\n");
@@ -723,13 +737,15 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 
 	if (endpoint->data->aggregation) {
 		if (!endpoint->toward_ipa) {
+			const struct ipa_endpoint_rx_data *rx_data;
 			bool close_eof;
 			u32 limit;
 
+			rx_data = &endpoint->data->rx;
 			val |= u32_encode_bits(IPA_ENABLE_AGGR, AGGR_EN_FMASK);
 			val |= u32_encode_bits(IPA_GENERIC, AGGR_TYPE_FMASK);
 
-			limit = ipa_aggr_size_kb(IPA_RX_BUFFER_SIZE);
+			limit = ipa_aggr_size_kb(rx_data->buffer_size);
 			val |= aggr_byte_limit_encoded(version, limit);
 
 			limit = IPA_AGGR_TIME_LIMIT;
@@ -737,7 +753,7 @@ static void ipa_endpoint_init_aggr(struct ipa_endpoint *endpoint)
 
 			/* AGGR_PKT_LIMIT is 0 (unlimited) */
 
-			close_eof = endpoint->data->rx.aggr_close_eof;
+			close_eof = rx_data->aggr_close_eof;
 			val |= aggr_sw_eof_active_encoded(version, close_eof);
 
 			/* AGGR_HARD_BYTE_LIMIT_ENABLE is 0 */
@@ -1025,11 +1041,13 @@ static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint)
 	struct gsi_trans *trans;
 	bool doorbell = false;
 	struct page *page;
+	u32 buffer_size;
 	u32 offset;
 	u32 len;
 	int ret;
 
-	page = dev_alloc_pages(get_order(IPA_RX_BUFFER_SIZE));
+	buffer_size = endpoint->data->rx.buffer_size;
+	page = dev_alloc_pages(get_order(buffer_size));
 	if (!page)
 		return -ENOMEM;
 
@@ -1039,7 +1057,7 @@ static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint)
 
 	/* Offset the buffer to make space for skb headroom */
 	offset = NET_SKB_PAD;
-	len = IPA_RX_BUFFER_SIZE - offset;
+	len = buffer_size - offset;
 
 	ret = gsi_trans_page_add(trans, page, len, offset);
 	if (ret)
@@ -1058,7 +1076,7 @@ static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint)
 err_trans_free:
 	gsi_trans_free(trans);
 err_free_pages:
-	__free_pages(page, get_order(IPA_RX_BUFFER_SIZE));
+	__free_pages(page, get_order(buffer_size));
 
 	return -ENOMEM;
 }
@@ -1183,15 +1201,16 @@ static void ipa_endpoint_skb_copy(struct ipa_endpoint *endpoint,
 static bool ipa_endpoint_skb_build(struct ipa_endpoint *endpoint,
 				   struct page *page, u32 len)
 {
+	u32 buffer_size = endpoint->data->rx.buffer_size;
 	struct sk_buff *skb;
 
 	/* Nothing to do if there's no netdev */
 	if (!endpoint->netdev)
 		return false;
 
-	WARN_ON(len > SKB_WITH_OVERHEAD(IPA_RX_BUFFER_SIZE - NET_SKB_PAD));
+	WARN_ON(len > SKB_WITH_OVERHEAD(buffer_size - NET_SKB_PAD));
 
-	skb = build_skb(page_address(page), IPA_RX_BUFFER_SIZE);
+	skb = build_skb(page_address(page), buffer_size);
 	if (skb) {
 		/* Reserve the headroom and account for the data */
 		skb_reserve(skb, NET_SKB_PAD);
@@ -1289,8 +1308,9 @@ static bool ipa_endpoint_status_drop(struct ipa_endpoint *endpoint,
 static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 				      struct page *page, u32 total_len)
 {
+	u32 buffer_size = endpoint->data->rx.buffer_size;
 	void *data = page_address(page) + NET_SKB_PAD;
-	u32 unused = IPA_RX_BUFFER_SIZE - total_len;
+	u32 unused = buffer_size - total_len;
 	u32 resid = total_len;
 
 	while (resid) {
@@ -1398,8 +1418,11 @@ void ipa_endpoint_trans_release(struct ipa_endpoint *endpoint,
 	} else {
 		struct page *page = trans->data;
 
-		if (page)
-			__free_pages(page, get_order(IPA_RX_BUFFER_SIZE));
+		if (page) {
+			u32 buffer_size = endpoint->data->rx.buffer_size;
+
+			__free_pages(page, get_order(buffer_size));
+		}
 	}
 }
 
-- 
2.32.0

