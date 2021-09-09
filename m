Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E5C404A78
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbhIILqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:46:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237351AbhIILor (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:44:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B1A4611C4;
        Thu,  9 Sep 2021 11:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187758;
        bh=uKKv48X/rwTXchpUk/HynlKWdL8cvr6NSDQypKRjBG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l8Fx9/ISC20RcCQ6YmFcXEBwzkMImN1kiazUktac10oxV6oCSLWiRmtDvcAszZgcG
         lEjQlb8Prld13WlLKCqaFfxcXTfuM79wWF8IQ84k6YbdVmMn1sGynHhY+4ij1HvS0S
         z0OfXgEVSFcllJlsnEfIQqNYjjD9OCjldUTeeP8dI3EBfQR8W33MsEkFwDIX5rDbFz
         ISHwUc7e50DdwX2vpp7sJgHfYP9wsd68oOTnrCU50IgX7FoTZTkWU7Ey6psPsbIjcP
         HZuoy0Sb8dqry6a++4tFppeJPHIGMTQpB1YaXQocEpJQyeuNYlukcvt1kB2a+qrbJL
         F9n2qGp933b6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Elder <elder@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 071/252] net: ipa: fix ipa_cmd_table_valid()
Date:   Thu,  9 Sep 2021 07:38:05 -0400
Message-Id: <20210909114106.141462-71-sashal@kernel.org>
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

[ Upstream commit f2c1dac0abcfa93e8b20065b8d6b4b2b6f9990aa ]

Stop supporting different sizes for hashed and non-hashed filter or
route tables.  Add BUILD_BUG_ON() calls to verify the sizes of the
fields in the filter/route table initialization immediate command
are the same.

Add a check to ipa_cmd_table_valid() to ensure the size of the
memory region being checked fits within the immediate command field
that must hold it.

Remove two Boolean parameters used only for error reporting.  This
actually fixes a bug that would only show up if IPA_VALIDATE were
defined.  Define ipa_cmd_table_valid() unconditionally (no longer
dependent on IPA_VALIDATE).

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_cmd.c   | 38 ++++++++++++++++++++++++-------------
 drivers/net/ipa/ipa_cmd.h   | 15 +++------------
 drivers/net/ipa/ipa_table.c |  2 +-
 3 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index af44ca41189e..bda8677eae88 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -159,35 +159,45 @@ static void ipa_cmd_validate_build(void)
 	BUILD_BUG_ON(TABLE_SIZE > field_max(IP_FLTRT_FLAGS_NHASH_SIZE_FMASK));
 #undef TABLE_COUNT_MAX
 #undef TABLE_SIZE
-}
 
-#ifdef IPA_VALIDATE
+	/* Hashed and non-hashed fields are assumed to be the same size */
+	BUILD_BUG_ON(field_max(IP_FLTRT_FLAGS_HASH_SIZE_FMASK) !=
+		     field_max(IP_FLTRT_FLAGS_NHASH_SIZE_FMASK));
+	BUILD_BUG_ON(field_max(IP_FLTRT_FLAGS_HASH_ADDR_FMASK) !=
+		     field_max(IP_FLTRT_FLAGS_NHASH_ADDR_FMASK));
+}
 
 /* Validate a memory region holding a table */
-bool ipa_cmd_table_valid(struct ipa *ipa, const struct ipa_mem *mem,
-			 bool route, bool ipv6, bool hashed)
+bool ipa_cmd_table_valid(struct ipa *ipa, const struct ipa_mem *mem, bool route)
 {
+	u32 offset_max = field_max(IP_FLTRT_FLAGS_NHASH_ADDR_FMASK);
+	u32 size_max = field_max(IP_FLTRT_FLAGS_NHASH_SIZE_FMASK);
+	const char *table = route ? "route" : "filter";
 	struct device *dev = &ipa->pdev->dev;
-	u32 offset_max;
 
-	offset_max = hashed ? field_max(IP_FLTRT_FLAGS_HASH_ADDR_FMASK)
-			    : field_max(IP_FLTRT_FLAGS_NHASH_ADDR_FMASK);
+	/* Size must fit in the immediate command field that holds it */
+	if (mem->size > size_max) {
+		dev_err(dev, "%s table region size too large\n", table);
+		dev_err(dev, "    (0x%04x > 0x%04x)\n",
+			mem->size, size_max);
+
+		return false;
+	}
+
+	/* Offset must fit in the immediate command field that holds it */
 	if (mem->offset > offset_max ||
 	    ipa->mem_offset > offset_max - mem->offset) {
-		dev_err(dev, "IPv%c %s%s table region offset too large\n",
-			ipv6 ? '6' : '4', hashed ? "hashed " : "",
-			route ? "route" : "filter");
+		dev_err(dev, "%s table region offset too large\n", table);
 		dev_err(dev, "    (0x%04x + 0x%04x > 0x%04x)\n",
 			ipa->mem_offset, mem->offset, offset_max);
 
 		return false;
 	}
 
+	/* Entire memory range must fit within IPA-local memory */
 	if (mem->offset > ipa->mem_size ||
 	    mem->size > ipa->mem_size - mem->offset) {
-		dev_err(dev, "IPv%c %s%s table region out of range\n",
-			ipv6 ? '6' : '4', hashed ? "hashed " : "",
-			route ? "route" : "filter");
+		dev_err(dev, "%s table region out of range\n", table);
 		dev_err(dev, "    (0x%04x + 0x%04x > 0x%04x)\n",
 			mem->offset, mem->size, ipa->mem_size);
 
@@ -197,6 +207,8 @@ bool ipa_cmd_table_valid(struct ipa *ipa, const struct ipa_mem *mem,
 	return true;
 }
 
+#ifdef IPA_VALIDATE
+
 /* Validate the memory region that holds headers */
 static bool ipa_cmd_header_valid(struct ipa *ipa)
 {
diff --git a/drivers/net/ipa/ipa_cmd.h b/drivers/net/ipa/ipa_cmd.h
index b99262281f41..ea723419c826 100644
--- a/drivers/net/ipa/ipa_cmd.h
+++ b/drivers/net/ipa/ipa_cmd.h
@@ -57,20 +57,18 @@ struct ipa_cmd_info {
 	enum dma_data_direction direction;
 };
 
-#ifdef IPA_VALIDATE
-
 /**
  * ipa_cmd_table_valid() - Validate a memory region holding a table
  * @ipa:	- IPA pointer
  * @mem:	- IPA memory region descriptor
  * @route:	- Whether the region holds a route or filter table
- * @ipv6:	- Whether the table is for IPv6 or IPv4
- * @hashed:	- Whether the table is hashed or non-hashed
  *
  * Return:	true if region is valid, false otherwise
  */
 bool ipa_cmd_table_valid(struct ipa *ipa, const struct ipa_mem *mem,
-			    bool route, bool ipv6, bool hashed);
+			    bool route);
+
+#ifdef IPA_VALIDATE
 
 /**
  * ipa_cmd_data_valid() - Validate command-realted configuration is valid
@@ -82,13 +80,6 @@ bool ipa_cmd_data_valid(struct ipa *ipa);
 
 #else /* !IPA_VALIDATE */
 
-static inline bool ipa_cmd_table_valid(struct ipa *ipa,
-				       const struct ipa_mem *mem, bool route,
-				       bool ipv6, bool hashed)
-{
-	return true;
-}
-
 static inline bool ipa_cmd_data_valid(struct ipa *ipa)
 {
 	return true;
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index c617a9156f26..4f5b6749f6aa 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -161,7 +161,7 @@ ipa_table_valid_one(struct ipa *ipa, enum ipa_mem_id mem_id, bool route)
 	else
 		size = (1 + IPA_FILTER_COUNT_MAX) * sizeof(__le64);
 
-	if (!ipa_cmd_table_valid(ipa, mem, route, ipv6, hashed))
+	if (!ipa_cmd_table_valid(ipa, mem, route))
 		return false;
 
 	/* mem->size >= size is sufficient, but we'll demand more */
-- 
2.30.2

