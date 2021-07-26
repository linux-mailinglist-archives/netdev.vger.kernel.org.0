Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F833D65E7
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 19:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbhGZQ7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbhGZQ7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 12:59:47 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0081CC061764
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 10:40:15 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id m13so12860448iol.7
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 10:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RhapsKA6J25kD25lmyi6/Yv9x0InAtnL2pbV2Xb9qwU=;
        b=EgeRPtba7JmXRFpCb8FHFkqy26AmvA+X5gH4ja6s47tmBi07ies/bKg+QIpedEfGnt
         mVWdIky5xLde1ZvHr6eg6JlgIUDcmAJ0upfIAo6kaz42joyY8cRNU5xzx9ZSzr/yq5ef
         AK4muCJVTIpkbnpDark9BNW398xyLVilfvTETNoiJmfbEWtgYvI6gWf0cu8dPYO4uGfx
         mZPgq8UVbTcEK65nrbN/+AECMrmvC3MczDPGy/tnUqFM2ROaf57QpJtJ70uuxYncRxh2
         3OSiENmJjmcxu7i9J4GcMk52Wn+Bk3Ib310OzcH/ZbamQtRd8n5wFE8sDPl/+rRryRQu
         VxlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RhapsKA6J25kD25lmyi6/Yv9x0InAtnL2pbV2Xb9qwU=;
        b=ndYb21oQ2hVR8c7rQ1d4/7VgOgR3wRZfJW0lv2zpoGyKdT+SrlhaBjdLd07GWsMpo2
         q378iEiR8spG3NG2mCdv7TGS0c7HkZOt9FOlF/9DEOjX6k8DtiSCyF89bP2/zT2bHPVs
         RY8rAfbufmvH7gPkRa4aeX2b5Zwl6OaQRmVSoco/xv+vCPuYzukd9OxVMhb8JCw5lymn
         U6Q+WpBpULztE9fA8aGnjBRna49d+uhG5s+z0Al3tkikquiX11CeA7HJjt6a8JE2tkiQ
         R2Db91d+cg4+YwKffZgDBrchrR91Ad7j0IRGrwEVa4bkhRf+67K3twoahh7JnOPmzHTs
         sNaA==
X-Gm-Message-State: AOAM532UmxWQAoJws6JsEupPa7tRRc0p6K6patGHMVqAxlcm/8eE+daC
        Yr176XTLJRr3Nn4fXn7tKf1hDQ==
X-Google-Smtp-Source: ABdhPJzNTzH8TAa3FXHtMoMQSHtJ4Bt6ACJgbxs9EQoSZIU5vvzPeoIvhruLSjPLb345LwHR/MQuKg==
X-Received: by 2002:a02:93a7:: with SMTP id z36mr17237528jah.112.1627321215463;
        Mon, 26 Jul 2021 10:40:15 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id l4sm202721ilh.41.2021.07.26.10.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 10:40:15 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     leon@kernel.org, bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/4] net: ipa: always validate filter and route tables
Date:   Mon, 26 Jul 2021 12:40:08 -0500
Message-Id: <20210726174010.396765-3-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210726174010.396765-1-elder@linaro.org>
References: <20210726174010.396765-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All checks in ipa_table_validate_build() are computed at build time,
so build that unconditionally.

In ipa_table_valid() calls to ipa_table_valid_one() are missing the
IPA pointer parameter is missing in (a bug that shows up only when
IPA_VALIDATE is defined).  Don't bother checking whether hashed
table memory regions are valid if hashed tables are not supported.

With those things fixed, have these table validation functions built
unconditionally (not dependent on IPA_VALIDATE).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_table.c | 36 +++++++++++++++++-------------------
 drivers/net/ipa/ipa_table.h | 16 ----------------
 2 files changed, 17 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 4f5b6749f6aae..c607ebec74567 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -120,8 +120,6 @@
  */
 #define IPA_ZERO_RULE_SIZE		(2 * sizeof(__le32))
 
-#ifdef IPA_VALIDATE
-
 /* Check things that can be validated at build time. */
 static void ipa_table_validate_build(void)
 {
@@ -169,7 +167,7 @@ ipa_table_valid_one(struct ipa *ipa, enum ipa_mem_id mem_id, bool route)
 		return true;
 
 	/* Hashed table regions can be zero size if hashing is not supported */
-	if (hashed && !mem->size)
+	if (ipa_table_hash_support(ipa) && !mem->size)
 		return true;
 
 	dev_err(dev, "%s table region %u size 0x%02x, expected 0x%02x\n",
@@ -183,14 +181,22 @@ bool ipa_table_valid(struct ipa *ipa)
 {
 	bool valid;
 
-	valid = ipa_table_valid_one(IPA_MEM_V4_FILTER, false);
-	valid = valid && ipa_table_valid_one(IPA_MEM_V4_FILTER_HASHED, false);
-	valid = valid && ipa_table_valid_one(IPA_MEM_V6_FILTER, false);
-	valid = valid && ipa_table_valid_one(IPA_MEM_V6_FILTER_HASHED, false);
-	valid = valid && ipa_table_valid_one(IPA_MEM_V4_ROUTE, true);
-	valid = valid && ipa_table_valid_one(IPA_MEM_V4_ROUTE_HASHED, true);
-	valid = valid && ipa_table_valid_one(IPA_MEM_V6_ROUTE, true);
-	valid = valid && ipa_table_valid_one(IPA_MEM_V6_ROUTE_HASHED, true);
+	valid = ipa_table_valid_one(ipa, IPA_MEM_V4_FILTER, false);
+	valid = valid && ipa_table_valid_one(ipa, IPA_MEM_V6_FILTER, false);
+	valid = valid && ipa_table_valid_one(ipa, IPA_MEM_V4_ROUTE, true);
+	valid = valid && ipa_table_valid_one(ipa, IPA_MEM_V6_ROUTE, true);
+
+	if (!ipa_table_hash_support(ipa))
+		return valid;
+
+	valid = valid && ipa_table_valid_one(ipa, IPA_MEM_V4_FILTER_HASHED,
+					     false);
+	valid = valid && ipa_table_valid_one(ipa, IPA_MEM_V6_FILTER_HASHED,
+					     false);
+	valid = valid && ipa_table_valid_one(ipa, IPA_MEM_V4_ROUTE_HASHED,
+					     true);
+	valid = valid && ipa_table_valid_one(ipa, IPA_MEM_V6_ROUTE_HASHED,
+					     true);
 
 	return valid;
 }
@@ -217,14 +223,6 @@ bool ipa_filter_map_valid(struct ipa *ipa, u32 filter_map)
 	return true;
 }
 
-#else /* !IPA_VALIDATE */
-static void ipa_table_validate_build(void)
-
-{
-}
-
-#endif /* !IPA_VALIDATE */
-
 /* Zero entry count means no table, so just return a 0 address */
 static dma_addr_t ipa_table_addr(struct ipa *ipa, bool filter_mask, u16 count)
 {
diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
index 1e2be9fce2f81..b6a9a0d79d68e 100644
--- a/drivers/net/ipa/ipa_table.h
+++ b/drivers/net/ipa/ipa_table.h
@@ -16,8 +16,6 @@ struct ipa;
 /* The maximum number of route table entries (IPv4, IPv6; hashed or not) */
 #define IPA_ROUTE_COUNT_MAX	15
 
-#ifdef IPA_VALIDATE
-
 /**
  * ipa_table_valid() - Validate route and filter table memory regions
  * @ipa:	IPA pointer
@@ -35,20 +33,6 @@ bool ipa_table_valid(struct ipa *ipa);
  */
 bool ipa_filter_map_valid(struct ipa *ipa, u32 filter_mask);
 
-#else /* !IPA_VALIDATE */
-
-static inline bool ipa_table_valid(struct ipa *ipa)
-{
-	return true;
-}
-
-static inline bool ipa_filter_map_valid(struct ipa *ipa, u32 filter_mask)
-{
-	return true;
-}
-
-#endif /* !IPA_VALIDATE */
-
 /**
  * ipa_table_hash_support() - Return true if hashed tables are supported
  * @ipa:	IPA pointer
-- 
2.27.0

