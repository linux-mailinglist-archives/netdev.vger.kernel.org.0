Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B97D45CDF3
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 21:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhKXU2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 15:28:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbhKXU22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 15:28:28 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD15C061757
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:25:18 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id e144so4807773iof.3
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=plwYDiYcXYV2zvdNN9Jp81+zqt/Mzq3cyFwkMtLfyOk=;
        b=VrFMiG+5GlldG4MT4Wu/F8/bGPXiEyWvGO++EFoPw91HXTIIyb1athM2B2LUMm+haB
         zxqGGHvyrvXvu4f/f89Dh6Myt4IZ6ZR+E8JA+vLT254SrWXGkOY12ypBVg194nmdEItR
         5jSwlnXvM/EX/TWcFuDecVW1AMxtd8f+VKDsiJUwmpb91HOJTbGM/fbYAnG5edH+pDKd
         Z1y5ZtWAg13iUJ7S5jLPYqPcDH7u8ErBx9t7ABqLD/+up8rkrcuts+2+CWBi0QYoxD4k
         d1JUy92XzZHP1o+m9nN17btWAF/z+tBf/XK1wf5Js1MFtEi38h2kG7tuej3w5nRac2tg
         MRTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=plwYDiYcXYV2zvdNN9Jp81+zqt/Mzq3cyFwkMtLfyOk=;
        b=DbI1SUG7V+NJnqdk/q5iZmkI0SGGmtQqmB60BAVaUVLS2BpCE6i0x9bi2UV1AuQPpY
         hLY4N1pNYnF7M5VvpY53CtZQub0T/bu3Q0cHSnTK81v8YsqVA/5ym/nUTg9W3HGWo2uV
         l5IcaN+BPg/VAHyBxVQ4oacxKn+gTme+99hM/SVMnpF/CrRAjisYY1G1j0jmYkxZRna5
         njuQkpwud7TiJXqAW60XYvwMHZjpyHfvbg4Lb90snI5T06OXpUhYLCUu+3S7wU0bSUco
         lLQtu4VTMQ3pEpyaioUqmug433TPhb3IpTu5u8qj0GrkuFLfgS5dLtMZs95Ute7LkZOW
         gj+g==
X-Gm-Message-State: AOAM532v+lKGpwoPZffSKnn2fK4PJanI7Kb/lFuKSDnD3d3msCWGjcMb
        MR9Pcht6t5kZ1Q28rySi7sBA0g==
X-Google-Smtp-Source: ABdhPJwUcR65Y5eltxPo9e5VNWxWwujODAbOnG2ac9H3yII0Nar6lQvW6YExtaHExuNUbba0BEy7ww==
X-Received: by 2002:a05:6638:250a:: with SMTP id v10mr20586107jat.119.1637785518026;
        Wed, 24 Nov 2021 12:25:18 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x2sm312795ile.29.2021.11.24.12.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 12:25:17 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     pkurapat@codeaurora.org, avuyyuru@codeaurora.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, evgreen@chromium.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/7] net: ipa: zero unused portions of filter table memory
Date:   Wed, 24 Nov 2021 14:25:06 -0600
Message-Id: <20211124202511.862588-3-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124202511.862588-1-elder@linaro.org>
References: <20211124202511.862588-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not all filter table entries are used.  Only certain endpoints
support filtering, and the table begins with a bitmap indicating
which endpoints use the "slots" that follow for filter rules.

Currently, unused filter table entries are not initialized.
Instead, zero-fill the entire unused portion of the filter table
memory regions, to make it more obvious that memory is unused (and
not subsequently modified).

This is not strictly necessary, but the result is reassuring when
looking at filter table memory.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_table.c | 48 +++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 1da334f54944a..2f5a58bfc529a 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -419,21 +419,26 @@ static void ipa_table_init_add(struct gsi_trans *trans, bool filter,
 	const struct ipa_mem *mem = ipa_mem_find(ipa, mem_id);
 	dma_addr_t hash_addr;
 	dma_addr_t addr;
+	u32 zero_offset;
 	u16 hash_count;
+	u32 zero_size;
 	u16 hash_size;
 	u16 count;
 	u16 size;
 
-	/* The number of filtering endpoints determines number of entries
-	 * in the filter table.  The hashed and non-hashed filter table
-	 * will have the same number of entries.  The size of the route
-	 * table region determines the number of entries it has.
-	 */
+	/* Compute the number of table entries to initialize */
 	if (filter) {
-		/* Include one extra "slot" to hold the filter map itself */
+		/* The number of filtering endpoints determines number of
+		 * entries in the filter table; we also add one more "slot"
+		 * to hold the bitmap itself.  The size of the hashed filter
+		 * table is either the same as the non-hashed one, or zero.
+		 */
 		count = 1 + hweight32(ipa->filter_map);
 		hash_count = hash_mem->size ? count : 0;
 	} else {
+		/* The size of a route table region determines the number
+		 * of entries it has.
+		 */
 		count = mem->size / sizeof(__le64);
 		hash_count = hash_mem->size / sizeof(__le64);
 	}
@@ -445,13 +450,42 @@ static void ipa_table_init_add(struct gsi_trans *trans, bool filter,
 
 	ipa_cmd_table_init_add(trans, opcode, size, mem->offset, addr,
 			       hash_size, hash_mem->offset, hash_addr);
+	if (!filter)
+		return;
+
+	/* Zero the unused space in the filter table */
+	zero_offset = mem->offset + size;
+	zero_size = mem->size - size;
+	ipa_cmd_dma_shared_mem_add(trans, zero_offset, zero_size,
+				   ipa->zero_addr, true);
+	if (!hash_size)
+		return;
+
+	/* Zero the unused space in the hashed filter table */
+	zero_offset = hash_mem->offset + hash_size;
+	zero_size = hash_mem->size - hash_size;
+	ipa_cmd_dma_shared_mem_add(trans, zero_offset, zero_size,
+				   ipa->zero_addr, true);
 }
 
 int ipa_table_setup(struct ipa *ipa)
 {
 	struct gsi_trans *trans;
 
-	trans = ipa_cmd_trans_alloc(ipa, 4);
+	/* We will need at most 8 TREs:
+	 * - IPv4:
+	 *     - One for route table initialization (non-hashed and hashed)
+	 *     - One for filter table initialization (non-hashed and hashed)
+	 *     - One to zero unused entries in the non-hashed filter table
+	 *     - One to zero unused entries in the hashed filter table
+	 * - IPv6:
+	 *     - One for route table initialization (non-hashed and hashed)
+	 *     - One for filter table initialization (non-hashed and hashed)
+	 *     - One to zero unused entries in the non-hashed filter table
+	 *     - One to zero unused entries in the hashed filter table
+	 * All platforms support at least 8 TREs in a transaction.
+	 */
+	trans = ipa_cmd_trans_alloc(ipa, 8);
 	if (!trans) {
 		dev_err(&ipa->pdev->dev, "no transaction for table setup\n");
 		return -EBUSY;
-- 
2.32.0

