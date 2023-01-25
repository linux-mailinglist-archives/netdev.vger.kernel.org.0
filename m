Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA53A67BD4E
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 21:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236589AbjAYUq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 15:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236551AbjAYUqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 15:46:05 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085A95E51F
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 12:45:58 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id f8so20979ilj.5
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 12:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YJZAdhZu9Kc85spjoXNYXOlKgf8rIiOctQJ+s3Nz2ig=;
        b=i8il3nE9OWdDb6H7w7iJfr8m/h+OjScnmTUlxZmt0IwIdDRytGc51rEEhL19tzZuaq
         kAKlm2K1JGv6uVpx7zqydljUVLqldOScg3OBrd8hdsjOqM7SWf8Y4Wx14FpoG+JvUWK4
         rGhqupA1ApmKs6sQpprsV15cMrw/y6wRnIBJIEOUeFylNMcjpfV3nbUkvyFnNm9u9zJ6
         cDbhi0aV0ES7aHm8xv+hVh0CtJEmuJFzFtsZQuA4AYIrVSAnSfy81/Ueb3lbfvQnTqfT
         gre9ZvDGP3LytsibcxLFtu8kYm2G0gNZBonbhaZT0xdxWBaRkt0EaMdSeW1sIIWmcpbC
         wkkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YJZAdhZu9Kc85spjoXNYXOlKgf8rIiOctQJ+s3Nz2ig=;
        b=YqiLW5rtPRR6phZcruvbi9z83eUKr54cYn/Rtac4qi2VsVf+MxML6Q8efWtomEmSth
         IXhsqYou3bfQq80pkNmHVppenmRCwH5F+MjrDhB7QEFPQx21T0u8QjiL4ESDbaLhM8Os
         MAvvheKfhA/uWoM9LUgktg+ZNvZUA9ttGI+EBOHB+RqFv0BTii9X3Ax3T6Beh0gHaE6R
         W9hIVwEEu7fJ5SCUVSzmCrK06jGAaQ5frTWlRb6NwZvAtnbHa9FQre8AwiB2D5DL3REJ
         N8v5UnfWah6gV9aFZcPvDz8FldcfcW1E5WqRT4mcMQHzEoZsq4qOiBMUls0Wg+oq3XZy
         psFw==
X-Gm-Message-State: AFqh2krsxPcjKrWce7Ueod6jaWIFHx2ITBgEdIlAA62rjbd2Gw2UQqU5
        dcMh5IzZnWO8JD0Y+t1MR6cbSA==
X-Google-Smtp-Source: AMrXdXtkkcBpeGWBz3wEZJm7ZK18N6ZrvtxMBYtkIoUTDsU5u9E+7eq4IHTqEfrZYIcJdwGAP7MsSA==
X-Received: by 2002:a05:6e02:12e8:b0:305:ef92:6480 with SMTP id l8-20020a056e0212e800b00305ef926480mr27927418iln.27.1674679558220;
        Wed, 25 Jan 2023 12:45:58 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id w14-20020a02968e000000b00389c2fe0f9dsm1960696jai.85.2023.01.25.12.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 12:45:57 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 8/8] net: ipa: add IPA v5.0 packet status support
Date:   Wed, 25 Jan 2023 14:45:45 -0600
Message-Id: <20230125204545.3788155-9-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230125204545.3788155-1-elder@linaro.org>
References: <20230125204545.3788155-1-elder@linaro.org>
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

Update ipa_status_extract() to support IPA v5.0 and beyond.  Because
the format of the IPA packet status depends on the version, pass an
IPA pointer to the function.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 52 +++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 3f6c3e2b6ec95..ce7f2d6e447ed 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -122,8 +122,10 @@ enum ipa_status_field_id {
 #define IPA_STATUS_SIZE			sizeof(__le32[4])
 
 /* IPA status structure decoder; looks up field values for a structure */
-static u32 ipa_status_extract(const void *data, enum ipa_status_field_id field)
+static u32 ipa_status_extract(struct ipa *ipa, const void *data,
+			      enum ipa_status_field_id field)
 {
+	enum ipa_version version = ipa->version;
 	const __le32 *word = data;
 
 	switch (field) {
@@ -136,10 +138,15 @@ static u32 ipa_status_extract(const void *data, enum ipa_status_field_id field)
 	case STATUS_LENGTH:
 		return le32_get_bits(word[1], GENMASK(15, 0));
 	case STATUS_SRC_ENDPOINT:
-		return le32_get_bits(word[1], GENMASK(20, 16));
-	/* Status word 1, bits 21-23 are reserved */
+		if (version < IPA_VERSION_5_0)
+			return le32_get_bits(word[1], GENMASK(20, 16));
+		return le32_get_bits(word[1], GENMASK(23, 16));
+	/* Status word 1, bits 21-23 are reserved (not IPA v5.0+) */
+	/* Status word 1, bits 24-26 are reserved (IPA v5.0+) */
 	case STATUS_DST_ENDPOINT:
-		return le32_get_bits(word[1], GENMASK(28, 24));
+		if (version < IPA_VERSION_5_0)
+			return le32_get_bits(word[1], GENMASK(28, 24));
+		return le32_get_bits(word[7], GENMASK(23, 16));
 	/* Status word 1, bits 29-31 are reserved */
 	case STATUS_METADATA:
 		return le32_to_cpu(word[2]);
@@ -153,14 +160,23 @@ static u32 ipa_status_extract(const void *data, enum ipa_status_field_id field)
 		return le32_get_bits(word[3], GENMASK(3, 3));
 	case STATUS_FILTER_RULE_INDEX:
 		return le32_get_bits(word[3], GENMASK(13, 4));
+	/* ROUTER_TABLE is in word 3, bits 14-21 (IPA v5.0+) */
 	case STATUS_ROUTER_LOCAL:
-		return le32_get_bits(word[3], GENMASK(14, 14));
+		if (version < IPA_VERSION_5_0)
+			return le32_get_bits(word[3], GENMASK(14, 14));
+		return le32_get_bits(word[1], GENMASK(27, 27));
 	case STATUS_ROUTER_HASH:
-		return le32_get_bits(word[3], GENMASK(15, 15));
+		if (version < IPA_VERSION_5_0)
+			return le32_get_bits(word[3], GENMASK(15, 15));
+		return le32_get_bits(word[1], GENMASK(28, 28));
 	case STATUS_UCP:
-		return le32_get_bits(word[3], GENMASK(16, 16));
+		if (version < IPA_VERSION_5_0)
+			return le32_get_bits(word[3], GENMASK(16, 16));
+		return le32_get_bits(word[7], GENMASK(31, 31));
 	case STATUS_ROUTER_TABLE:
-		return le32_get_bits(word[3], GENMASK(21, 17));
+		if (version < IPA_VERSION_5_0)
+			return le32_get_bits(word[3], GENMASK(21, 17));
+		return le32_get_bits(word[3], GENMASK(21, 14));
 	case STATUS_ROUTER_RULE_INDEX:
 		return le32_get_bits(word[3], GENMASK(31, 22));
 	case STATUS_NAT_HIT:
@@ -186,7 +202,8 @@ static u32 ipa_status_extract(const void *data, enum ipa_status_field_id field)
 		return le32_get_bits(word[7], GENMASK(11, 11));
 	case STATUS_FRAG_RULE_INDEX:
 		return le32_get_bits(word[7], GENMASK(15, 12));
-	/* Status word 7, bits 16-31 are reserved */
+	/* Status word 7, bits 16-30 are reserved */
+	/* Status word 7, bit 31 is reserved (not IPA v5.0+) */
 	default:
 		WARN(true, "%s: bad field_id %u\n", __func__, field);
 		return 0;
@@ -1444,14 +1461,15 @@ static bool ipa_status_format_packet(enum ipa_status_opcode opcode)
 static bool
 ipa_endpoint_status_skip(struct ipa_endpoint *endpoint, const void *data)
 {
+	struct ipa *ipa = endpoint->ipa;
 	enum ipa_status_opcode opcode;
 	u32 endpoint_id;
 
-	opcode = ipa_status_extract(data, STATUS_OPCODE);
+	opcode = ipa_status_extract(ipa, data, STATUS_OPCODE);
 	if (!ipa_status_format_packet(opcode))
 		return true;
 
-	endpoint_id = ipa_status_extract(data, STATUS_DST_ENDPOINT);
+	endpoint_id = ipa_status_extract(ipa, data, STATUS_DST_ENDPOINT);
 	if (endpoint_id != endpoint->endpoint_id)
 		return true;
 
@@ -1466,7 +1484,7 @@ ipa_endpoint_status_tag_valid(struct ipa_endpoint *endpoint, const void *data)
 	struct ipa *ipa = endpoint->ipa;
 	u32 endpoint_id;
 
-	status_mask = ipa_status_extract(data, STATUS_MASK);
+	status_mask = ipa_status_extract(ipa, data, STATUS_MASK);
 	if (!status_mask)
 		return false;	/* No valid tag */
 
@@ -1475,7 +1493,7 @@ ipa_endpoint_status_tag_valid(struct ipa_endpoint *endpoint, const void *data)
 	 * If the packet came from the AP->command TX endpoint we know
 	 * this packet was sent as part of the pipeline clear process.
 	 */
-	endpoint_id = ipa_status_extract(data, STATUS_SRC_ENDPOINT);
+	endpoint_id = ipa_status_extract(ipa, data, STATUS_SRC_ENDPOINT);
 	command_endpoint = ipa->name_map[IPA_ENDPOINT_AP_COMMAND_TX];
 	if (endpoint_id == command_endpoint->endpoint_id) {
 		complete(&ipa->completion);
@@ -1493,6 +1511,7 @@ static bool
 ipa_endpoint_status_drop(struct ipa_endpoint *endpoint, const void *data)
 {
 	enum ipa_status_exception exception;
+	struct ipa *ipa = endpoint->ipa;
 	u32 rule;
 
 	/* If the status indicates a tagged transfer, we'll drop the packet */
@@ -1500,12 +1519,12 @@ ipa_endpoint_status_drop(struct ipa_endpoint *endpoint, const void *data)
 		return true;
 
 	/* Deaggregation exceptions we drop; all other types we consume */
-	exception = ipa_status_extract(data, STATUS_EXCEPTION);
+	exception = ipa_status_extract(ipa, data, STATUS_EXCEPTION);
 	if (exception)
 		return exception == IPA_STATUS_EXCEPTION_DEAGGR;
 
 	/* Drop the packet if it fails to match a routing rule; otherwise no */
-	rule = ipa_status_extract(data, STATUS_ROUTER_RULE_INDEX);
+	rule = ipa_status_extract(ipa, data, STATUS_ROUTER_RULE_INDEX);
 
 	return rule == IPA_STATUS_RULE_MISS;
 }
@@ -1516,6 +1535,7 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 	u32 buffer_size = endpoint->config.rx.buffer_size;
 	void *data = page_address(page) + NET_SKB_PAD;
 	u32 unused = buffer_size - total_len;
+	struct ipa *ipa = endpoint->ipa;
 	u32 resid = total_len;
 
 	while (resid) {
@@ -1531,7 +1551,7 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 		}
 
 		/* Skip over status packets that lack packet data */
-		length = ipa_status_extract(data, STATUS_LENGTH);
+		length = ipa_status_extract(ipa, data, STATUS_LENGTH);
 		if (!length || ipa_endpoint_status_skip(endpoint, data)) {
 			data += IPA_STATUS_SIZE;
 			resid -= IPA_STATUS_SIZE;
-- 
2.34.1

