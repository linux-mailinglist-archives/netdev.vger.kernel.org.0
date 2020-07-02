Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4216212231
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 13:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgGBLZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 07:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728742AbgGBLZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 07:25:47 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC7DC08C5DC
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 04:25:46 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id x9so23902476ila.3
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 04:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YkfiTq5tt8RJ4gOurpcHW32dq+36I8L6RxM8zDS/4AA=;
        b=UzH8YakneCqJqH1tFEOb2nj8+dJfVaj/zytEeJIHQQDXQbYDW3bCHjw2PAtD4h3L9M
         LXUGkchUf/yeia6QdS1K6Mw7QQYf2JsjLsZDKBklfHly5URrJqv6kyo5729z9gdsW5H2
         rmEzs2Ya3x239k5lsrHh6JbNsP97MgxaJeuQan0teDhJRh7yCQulMwB/k4nvaP3GT7/d
         ffsBVP4QZPA/okRwXBJCaRAXsDSzp35vPWKzHFFFPs9omWP1jFVw1fyIvJ+D+LY/VHTA
         rG1CtSd2M4cU/DlMv5z4KDLHPifKY7onXgD8eebB3O4lMJ7TRalXNVgyXqqbG0ktZYo0
         RDVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YkfiTq5tt8RJ4gOurpcHW32dq+36I8L6RxM8zDS/4AA=;
        b=uYl6Bypz9fniilfsinGQ5pMaqnEmEVRVu+pZaQ6gvqoxKxboDck6knnz8DsZ7ErZEX
         voCKX/M4urCfcBS/Y0pY+vVDWu0oWM3/Nba487Crer4F2Qm0iNb3qyJ8505DwiABH7yi
         pZw7vO2xtgRcOBeu/xKwDNpzhYONkJy3kpOpL1PT84fGuJ0uZhFP0n2n+s6yQgSjm/Ll
         tS0mq/XBmWDbm9BLflOs05qzqS1oB8zNVChORFM7iN55tA1f0WSypsGU9Au9OxsGX6t3
         KZJEj2sRBD8f5nN5voWcuWMM+2tk8yBDcKmwacUwxovnl/KOk5jMmPzmVdic5jwbyqLF
         I7uw==
X-Gm-Message-State: AOAM532f03xngE1I15Bd/ch5mw1zq9q/3W1zHzKBSgHw6ATzY6CIbfOJ
        k6ol1E+VY+J81ql8FTnXzsYT8w==
X-Google-Smtp-Source: ABdhPJzXraDXXUyCKq2Os7WRGHytUfZRnMfhNCNmRH0/tHh21HJ+6+K/qXeGDUE5mo1OBjjV54QkqQ==
X-Received: by 2002:a05:6e02:6cf:: with SMTP id p15mr12241242ils.206.1593689146157;
        Thu, 02 Jul 2020 04:25:46 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id c3sm4692842ilj.31.2020.07.02.04.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 04:25:45 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/4] net: ipa: simplify ipa_endpoint_program()
Date:   Thu,  2 Jul 2020 06:25:37 -0500
Message-Id: <20200702112537.347994-5-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702112537.347994-1-elder@linaro.org>
References: <20200702112537.347994-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Have functions that write endpoint configuration registers return
immediately if they are not valid for the direction of transfer for
the endpoint.  This allows most of the calls in ipa_endpoint_program()
to be made unconditionally.  Reorder the register writes to match
the order of their definition (based on offset).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index df4202794e69..99115a2a29ae 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -588,6 +588,9 @@ static void ipa_endpoint_init_hdr_metadata_mask(struct ipa_endpoint *endpoint)
 	u32 val = 0;
 	u32 offset;
 
+	if (endpoint->toward_ipa)
+		return;		/* Register not valid for TX endpoints */
+
 	offset = IPA_REG_ENDP_INIT_HDR_METADATA_MASK_N_OFFSET(endpoint_id);
 
 	/* Note that HDR_ENDIANNESS indicates big endian header fields */
@@ -602,6 +605,9 @@ static void ipa_endpoint_init_mode(struct ipa_endpoint *endpoint)
 	u32 offset = IPA_REG_ENDP_INIT_MODE_N_OFFSET(endpoint->endpoint_id);
 	u32 val;
 
+	if (!endpoint->toward_ipa)
+		return;		/* Register not valid for RX endpoints */
+
 	if (endpoint->data->dma_mode) {
 		enum ipa_endpoint_name name = endpoint->data->dma_endpoint;
 		u32 dma_endpoint_id;
@@ -760,6 +766,9 @@ static void ipa_endpoint_init_deaggr(struct ipa_endpoint *endpoint)
 	u32 offset = IPA_REG_ENDP_INIT_DEAGGR_N_OFFSET(endpoint->endpoint_id);
 	u32 val = 0;
 
+	if (!endpoint->toward_ipa)
+		return;		/* Register not valid for RX endpoints */
+
 	/* DEAGGR_HDR_LEN is 0 */
 	/* PACKET_OFFSET_VALID is 0 */
 	/* PACKET_OFFSET_LOCATION is ignored (not valid) */
@@ -774,6 +783,9 @@ static void ipa_endpoint_init_seq(struct ipa_endpoint *endpoint)
 	u32 seq_type = endpoint->seq_type;
 	u32 val = 0;
 
+	if (!endpoint->toward_ipa)
+		return;		/* Register not valid for RX endpoints */
+
 	/* Sequencer type is made up of four nibbles */
 	val |= u32_encode_bits(seq_type & 0xf, HPS_SEQ_TYPE_FMASK);
 	val |= u32_encode_bits((seq_type >> 4) & 0xf, DPS_SEQ_TYPE_FMASK);
@@ -1330,21 +1342,18 @@ static void ipa_endpoint_reset(struct ipa_endpoint *endpoint)
 
 static void ipa_endpoint_program(struct ipa_endpoint *endpoint)
 {
-	if (endpoint->toward_ipa) {
+	if (endpoint->toward_ipa)
 		ipa_endpoint_program_delay(endpoint, false);
-		ipa_endpoint_init_hdr_ext(endpoint);
-		ipa_endpoint_init_aggr(endpoint);
-		ipa_endpoint_init_deaggr(endpoint);
-		ipa_endpoint_init_seq(endpoint);
-		ipa_endpoint_init_mode(endpoint);
-	} else {
+	else
 		(void)ipa_endpoint_program_suspend(endpoint, false);
-		ipa_endpoint_init_hdr_ext(endpoint);
-		ipa_endpoint_init_aggr(endpoint);
-		ipa_endpoint_init_hdr_metadata_mask(endpoint);
-	}
 	ipa_endpoint_init_cfg(endpoint);
 	ipa_endpoint_init_hdr(endpoint);
+	ipa_endpoint_init_hdr_ext(endpoint);
+	ipa_endpoint_init_hdr_metadata_mask(endpoint);
+	ipa_endpoint_init_mode(endpoint);
+	ipa_endpoint_init_aggr(endpoint);
+	ipa_endpoint_init_deaggr(endpoint);
+	ipa_endpoint_init_seq(endpoint);
 	ipa_endpoint_status(endpoint);
 }
 
-- 
2.25.1

