Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6C63D65E6
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 19:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbhGZQ7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbhGZQ7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 12:59:47 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE89C061765
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 10:40:15 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id l11so9751218iln.4
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 10:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7lEqg3TOKz14G7O++U3GKk3SokkJPyKbuqy0/ExBt4k=;
        b=LCAMM+Az3vCW4kU8XKuOsy1mQJVeGS58zmXuWZtImcD6yxBwsdn2gV6yfPPVO6pVSn
         rxPZLs+CnTGMMkEnMTpsvmOr8Tmkx7vejD3LcxntRfDzDmfvL/liQVH6Dyc0cEWLw8F3
         6Qv3+NXscFltuJX/oCVx4dR/a2XITK/rhBk52Ft43nqVa6tlq+GYpywLa+LKDlXNQ2Jt
         YIURNAP07sU5YRbQCQQrWw0UXAILYKp9Vf0FV1WThYSvzZIdfKjqi+CY+ClTbtb8Nacz
         jKBbkCzg5xgZYMLaCwSwgHuRqhudQKDvEuBZdJQYG82wN3DYqqhS7lHwnZ6dSl06pJqh
         h0PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7lEqg3TOKz14G7O++U3GKk3SokkJPyKbuqy0/ExBt4k=;
        b=GLw7h0BjkfNGfmcEY9KAjmT9dhxxBFSDa1kSZ909tvtT4OG6pR2hyT8rIERDeIBWiU
         e33iMCc8BLpy/0+rXI8FlxY3Rhx4Odrg56xJjoungvZfSem2ACjZu8CiET5hnHpDorB8
         e5K1CTSQhJfLucqcm6R+gKvFVFitk+gmeWgx6MCpQmUufAf/rPV0oVD/aj/cV/gVKTLS
         RIJQs8ygnjUP0omNfq0T41AeVX9CTRdj9mRrwK4kAYh/RnoEPlyzAgKpwn0xGdkvHlMJ
         4XQFt2fqt+JHtNSZwlG4PZ9CF1ir7cbNZWopgRg0G5tFI0UogzLUG/pC2/1U55y6pVrB
         y82Q==
X-Gm-Message-State: AOAM532/patSe0jg1aY+OlGjGYQMFblkfQ51fjMhVyEFAhetqczsYIeF
        TyElshS1bg+64Mo/QPw/2eQk8w==
X-Google-Smtp-Source: ABdhPJwInLk84GK5wqBKjPr9ug/NL9/BrC/x9MobHR+LlWEJC/wd1SKjvj6KDMUyVK+8DxnTCgd1ug==
X-Received: by 2002:a05:6e02:12ab:: with SMTP id f11mr14040422ilr.200.1627321214611;
        Mon, 26 Jul 2021 10:40:14 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id l4sm202721ilh.41.2021.07.26.10.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 10:40:14 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     leon@kernel.org, bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/4] net: ipa: fix ipa_cmd_table_valid()
Date:   Mon, 26 Jul 2021 12:40:07 -0500
Message-Id: <20210726174010.396765-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210726174010.396765-1-elder@linaro.org>
References: <20210726174010.396765-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/ipa/ipa_cmd.c   | 38 ++++++++++++++++++++++++-------------
 drivers/net/ipa/ipa_cmd.h   | 15 +++------------
 drivers/net/ipa/ipa_table.c |  2 +-
 3 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index af44ca41189e3..bda8677eae88d 100644
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
index b99262281f41c..ea723419c826b 100644
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
index c617a9156f26d..4f5b6749f6aae 100644
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
2.27.0

