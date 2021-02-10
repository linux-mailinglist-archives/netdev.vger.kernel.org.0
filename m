Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05DB2317375
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 23:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbhBJWff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 17:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233646AbhBJWfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 17:35:14 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CAFC061797
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 14:33:28 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id n14so3718418iog.3
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 14:33:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t6ANzS3+2tsE4t3VkmY2+dGn199wA0IEauFrqe8OQ8I=;
        b=rx1gHAS3m7M8qLsT/QutCzEXdVpE33jO3rQxZCXbbv6wdn7fc7u7eIM2zs2wdXztUf
         QlUSR0fIcYZH7M8voIHAyab4WdSe/bS/mgAXT/XVoj5PaMoJlMJnQUvGcXKm/Z3CwZ0Z
         DTTeWz6M5knBMDXf8bxILstsm9NktEbTSi++CB0Ge+1Z10iLRp4r86NXwxuWegT/3mdF
         F/VMh4b6iZiv7flvKueNqpOz36G18IsE8A1JniVPLTU1mtq4ukTMkoEMUqUObts0fVKa
         r+GCSc8o1vkCnJcUgIOB1gREk36BkkKUwhbI3S1AIESJvXUmTCbScnz00FYyY3xV1lKp
         p3tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t6ANzS3+2tsE4t3VkmY2+dGn199wA0IEauFrqe8OQ8I=;
        b=oCa7Wdov2cHYt6hBdhStMz7UfnjJF53nZ/90lXMVWp5MT2p7XyYcuA59BqWqxfhNQA
         PAwZt+AGCKWHmCwpFpEFCQsDRZAvT5ZUEEpo+8jhfQ47pJmG6AFOQCDGHDIlXQUpH5jv
         0wOfychAYTCMjm1WgBsHPaeVeAdG+hXD8R9nyOEn+DzEQwREkz4kb5Of6POhmJOz0eaE
         vT4yRCiQxVY8TFUqiulB7XgyLUHGmtn4bf1PWWUb0VqciYQxTbiY/JsXMQ7sEctARBJz
         w+0dQ0iG/0ZHMy+9PrYM8cyqnNe/KQxzfs1DzbxGj+fVbG+cgzEzrP+7dSfPyef09YSv
         ZlxQ==
X-Gm-Message-State: AOAM5312NUPkj7Z9cpPhr6GS5dDUF174oY28YeJwBw4up/tmZHbPMAWs
        1lGUQz3DIjiWeIcHAuIgprGSkg==
X-Google-Smtp-Source: ABdhPJyCTB0itxNqAqGaLffREvLUicNoOc5hpdY7w62GFgm2dwu53vtVUdQcfc+wrSoELM46UzdbAg==
X-Received: by 2002:a6b:6d18:: with SMTP id a24mr2668255iod.169.1612996407300;
        Wed, 10 Feb 2021 14:33:27 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id e23sm1484525ioc.34.2021.02.10.14.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 14:33:27 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/5] net: ipa: introduce ipa_table_hash_support()
Date:   Wed, 10 Feb 2021 16:33:19 -0600
Message-Id: <20210210223320.11269-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210210223320.11269-1-elder@linaro.org>
References: <20210210223320.11269-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new function to abstract the knowledge of whether hashed
routing and filter tables are supported for a given IPA instance.

IPA v4.2 is the only one that doesn't support hashed tables (now
and for the foreseeable future), but the name of the helper function
is better for explaining what's going on.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_cmd.c   |  2 +-
 drivers/net/ipa/ipa_table.c | 14 ++++++++------
 drivers/net/ipa/ipa_table.h |  6 ++++++
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index 8c832bf2637ab..6a698ac9e6987 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -268,7 +268,7 @@ static bool ipa_cmd_register_write_valid(struct ipa *ipa)
 	/* If hashed tables are supported, ensure the hash flush register
 	 * offset will fit in a register write IPA immediate command.
 	 */
-	if (ipa->version != IPA_VERSION_4_2) {
+	if (ipa_table_hash_support(ipa)) {
 		offset = ipa_reg_filt_rout_hash_flush_offset(ipa->version);
 		name = "filter/route hash flush";
 		if (!ipa_cmd_register_write_offset_valid(ipa, name, offset))
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 32e2d3e052d55..5e069f0f5d706 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -239,6 +239,11 @@ static void ipa_table_validate_build(void)
 
 #endif /* !IPA_VALIDATE */
 
+bool ipa_table_hash_support(struct ipa *ipa)
+{
+	return ipa->version != IPA_VERSION_4_2;
+}
+
 /* Zero entry count means no table, so just return a 0 address */
 static dma_addr_t ipa_table_addr(struct ipa *ipa, bool filter_mask, u16 count)
 {
@@ -412,8 +417,7 @@ int ipa_table_hash_flush(struct ipa *ipa)
 	struct gsi_trans *trans;
 	u32 val;
 
-	/* IPA version 4.2 does not support hashed tables */
-	if (ipa->version == IPA_VERSION_4_2)
+	if (!ipa_table_hash_support(ipa))
 		return 0;
 
 	trans = ipa_cmd_trans_alloc(ipa, 1);
@@ -531,8 +535,7 @@ static void ipa_filter_config(struct ipa *ipa, bool modem)
 	enum gsi_ee_id ee_id = modem ? GSI_EE_MODEM : GSI_EE_AP;
 	u32 ep_mask = ipa->filter_map;
 
-	/* IPA version 4.2 has no hashed route tables */
-	if (ipa->version == IPA_VERSION_4_2)
+	if (!ipa_table_hash_support(ipa))
 		return;
 
 	while (ep_mask) {
@@ -582,8 +585,7 @@ static void ipa_route_config(struct ipa *ipa, bool modem)
 {
 	u32 route_id;
 
-	/* IPA version 4.2 has no hashed route tables */
-	if (ipa->version == IPA_VERSION_4_2)
+	if (!ipa_table_hash_support(ipa))
 		return;
 
 	for (route_id = 0; route_id < IPA_ROUTE_COUNT_MAX; route_id++)
diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
index 78038d14fcea9..c14fbe64d360e 100644
--- a/drivers/net/ipa/ipa_table.h
+++ b/drivers/net/ipa/ipa_table.h
@@ -51,6 +51,12 @@ static inline bool ipa_filter_map_valid(struct ipa *ipa, u32 filter_mask)
 
 #endif /* !IPA_VALIDATE */
 
+/**
+ * ipa_table_hash_support() - Return true if hashed tables are supported
+ * @ipa:	IPA pointer
+ */
+bool ipa_table_hash_support(struct ipa *ipa);
+
 /**
  * ipa_table_reset() - Reset filter and route tables entries to "none"
  * @ipa:	IPA pointer
-- 
2.20.1

