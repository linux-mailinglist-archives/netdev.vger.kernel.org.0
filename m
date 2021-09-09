Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A30F404A7F
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235466AbhIILq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:46:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237400AbhIILow (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:44:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 746C1611CA;
        Thu,  9 Sep 2021 11:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187759;
        bh=2JntmivuHJPxvvoKc91C/1ZAcnZue6O8y+RHCQyB10Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSiuOnYrDGOzfyltB9MgNOu1yEVZOKPHybITbLyezhKyqQqu3IMWe4cHZx0WFoDm1
         zPq8m1iS9uxvc3hWNOJqyNIu323pqTcJ2LZ+Jd5SuNqUwVIesmt+Tq2AIp7sjSWH5+
         8a5qtYsw8jwgHNPrbHC15bXkcufFClLQ9VRas5W+cRMaoWgdtZFGwyfgJr6KZfY2jC
         89mB9DHnwbA46iGPRtmCen+g/pgFSqHITsdjsUYDDBgi3vpO2sY6+Syu8Dm7itEPID
         DRLzUYZ/lQ4bK8Rdm3/N9ErxG51oaHSsthHNsvN3Te0KBYpeWw3Agp4/dvQse6HO1N
         g4Q06xaIhWy6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Elder <elder@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 072/252] net: ipa: always validate filter and route tables
Date:   Thu,  9 Sep 2021 07:38:06 -0400
Message-Id: <20210909114106.141462-72-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 546948bf362541857d4f500705efe08a2fe0bb95 ]

All checks in ipa_table_validate_build() are computed at build time,
so build that unconditionally.

In ipa_table_valid() calls to ipa_table_valid_one() are missing the
IPA pointer parameter is missing in (a bug that shows up only when
IPA_VALIDATE is defined).  Don't bother checking whether hashed
table memory regions are valid if hashed tables are not supported.

With those things fixed, have these table validation functions built
unconditionally (not dependent on IPA_VALIDATE).

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_table.c | 36 +++++++++++++++++-------------------
 drivers/net/ipa/ipa_table.h | 16 ----------------
 2 files changed, 17 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 4f5b6749f6aa..c607ebec7456 100644
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
index 1e2be9fce2f8..b6a9a0d79d68 100644
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
2.30.2

