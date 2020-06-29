Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9FD20E6B1
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404418AbgF2Vtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404378AbgF2Vt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 17:49:26 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A6DC03E97A
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:49:26 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id c16so18833324ioi.9
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 14:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z6Es3pTicfd51NnmXVOTn4bo+Yv9sluHPfJcIe1Ma9M=;
        b=Eqm3Ws9n6dNnTj+CvwZCE1N6WSOlh2Uq/8yZUOhb743tdn2HgzOK8LffMjdaAgFprl
         2ZJ0pBIixzjLSSbsaca041j7ijEAE7sAApKKz5hqIJruMGibCRB+GgD4gnydcTuulug+
         6SRM+KU+ipQO1kzIdJdGVckJ4sj4H70e+dE/E+gnbaSaPC24rPLGlHU/U8nlcLlzWTtV
         IsiZhStwyC4QOdkT4eYAP0OsiC78ohuXyokass1krWLkwLZeDe/C3R64bJvE5OSmRMlI
         1UiiGESQTCUxfHT2huMP0S2VKQJ2vGxNyRNDW7hil4KayHgUWt87A3N5EmKAiLojmqqA
         As7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z6Es3pTicfd51NnmXVOTn4bo+Yv9sluHPfJcIe1Ma9M=;
        b=iOnT4P3d75xuxtCt9nXBrdDh0Nmv3Pr6BXB87nT1Qib+FxRxN3rgKzXNAWNzqzfKIW
         hmQodosXYLh90/E1qj/0AW2LY6CuBlD1T+fISlq9+Bs4UO++QetQRWLKyvO+Qef26cpM
         dcKOY9skwaeGYwaJyif9eal5pygsMbuYkLKoMJjgLEKkZMqkpZSjV2OsGyVeLzoN6lno
         4pNDFvQKXmq73tUHE2e7ibe6bKm9qzTmJZr6VSgHe8DMCOEOXGvbBHval9WehdJxk4x0
         2bF92lcPJGHQGMgKOGopCE4f+YADVHAfjq8rE3lR2CB0edd7Lc6cOhO7vxvpb6hQ99tg
         QjbQ==
X-Gm-Message-State: AOAM530YPtmRHzKG8k5pik1co9LPQJerAoUZyDJ82rEkor6+jeW8uAXo
        +IjSLlJHOewnxjOojF+qOivKxYKqjzY=
X-Google-Smtp-Source: ABdhPJyVG6c+WeuLVJGtggJ9p3UEMQzjs9DFqGSO8FJ59ADo455POFzscfEslxqAAXgnusPBLYXooQ==
X-Received: by 2002:a02:844d:: with SMTP id l13mr20005309jah.105.1593467366214;
        Mon, 29 Jun 2020 14:49:26 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id u10sm555500iow.38.2020.06.29.14.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 14:49:25 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/5] net: ipa: mode register is TX only
Date:   Mon, 29 Jun 2020 16:49:17 -0500
Message-Id: <20200629214919.1196017-4-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629214919.1196017-1-elder@linaro.org>
References: <20200629214919.1196017-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The INIT_MODE endpoint configuration register is only valid for TX
endpoints.  Rather than writing a zero to that register for RX
endpoints, avoid writing the register at all.

Add assertion comments communicating that TX endpoints are assumed
for the DEAGGR and SEQ endpoint configuration registers to be
consistent.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 0c2bec166066..ee8fc22c3abc 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -543,7 +543,9 @@ static void ipa_endpoint_init_mode(struct ipa_endpoint *endpoint)
 	u32 offset = IPA_REG_ENDP_INIT_MODE_N_OFFSET(endpoint->endpoint_id);
 	u32 val;
 
-	if (endpoint->toward_ipa && endpoint->data->dma_mode) {
+	/* assert(endpoint->toward_ipa); */
+
+	if (endpoint->data->dma_mode) {
 		enum ipa_endpoint_name name = endpoint->data->dma_endpoint;
 		u32 dma_endpoint_id;
 
@@ -554,7 +556,7 @@ static void ipa_endpoint_init_mode(struct ipa_endpoint *endpoint)
 	} else {
 		val = u32_encode_bits(IPA_BASIC, MODE_FMASK);
 	}
-	/* Other bitfields unspecified (and 0) */
+	/* All other bits unspecified (and 0) */
 
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
@@ -702,6 +704,8 @@ static void ipa_endpoint_init_deaggr(struct ipa_endpoint *endpoint)
 	u32 offset = IPA_REG_ENDP_INIT_DEAGGR_N_OFFSET(endpoint->endpoint_id);
 	u32 val = 0;
 
+	/* assert(endpoint->toward_ipa); */
+
 	/* DEAGGR_HDR_LEN is 0 */
 	/* PACKET_OFFSET_VALID is 0 */
 	/* PACKET_OFFSET_LOCATION is ignored (not valid) */
@@ -716,6 +720,8 @@ static void ipa_endpoint_init_seq(struct ipa_endpoint *endpoint)
 	u32 seq_type = endpoint->seq_type;
 	u32 val = 0;
 
+	/* assert(endpoint->toward_ipa); */
+
 	/* Sequencer type is made up of four nibbles */
 	val |= u32_encode_bits(seq_type & 0xf, HPS_SEQ_TYPE_FMASK);
 	val |= u32_encode_bits((seq_type >> 4) & 0xf, DPS_SEQ_TYPE_FMASK);
@@ -1303,6 +1309,7 @@ static void ipa_endpoint_program(struct ipa_endpoint *endpoint)
 		ipa_endpoint_init_aggr(endpoint);
 		ipa_endpoint_init_deaggr(endpoint);
 		ipa_endpoint_init_seq(endpoint);
+		ipa_endpoint_init_mode(endpoint);
 	} else {
 		if (endpoint->ipa->version == IPA_VERSION_3_5_1)
 			(void)ipa_endpoint_program_suspend(endpoint, false);
@@ -1312,7 +1319,6 @@ static void ipa_endpoint_program(struct ipa_endpoint *endpoint)
 	}
 	ipa_endpoint_init_cfg(endpoint);
 	ipa_endpoint_init_hdr(endpoint);
-	ipa_endpoint_init_mode(endpoint);
 	ipa_endpoint_status(endpoint);
 }
 
-- 
2.25.1

