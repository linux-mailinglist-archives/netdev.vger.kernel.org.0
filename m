Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5A6342D3B
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 15:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhCTOR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 10:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbhCTORf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 10:17:35 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD94C061762
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 07:17:35 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id x16so9185166iob.1
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 07:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wEG3HE8n+uaGtfZTOY6Wov76mtWeNNFMYZemO39uW3s=;
        b=QneBCPEd9kmY1GPHoG3q87626gHUXw9k+T2BG62et4zGYepiZ2JLy01LacXNkxOKKc
         up3nqL93yJ4CGGx1hJc57VfPkahyTSrepKj+wUFAzGJsn2L/fQO5NtSUXgNr/AhA1LSZ
         RbIrU8hYzbhb3W6mgDStukm6oFNKlWuy16PibH303o1k3mn9/0pPjA6Un9chlZ+JYbac
         RTkhLR9c7lTDqr4UVPPqei4lblPfjetegDx+LSUb3lsF0gtlAc/bEhdHpwbAgN7H+Uly
         g9QR6MZhnIhOVBwrvjtlVtkl2i44VfSvCU/6G2KnPsZG5i5DeRQRezQLCzLXlQ0jcrLV
         11+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wEG3HE8n+uaGtfZTOY6Wov76mtWeNNFMYZemO39uW3s=;
        b=VhngZyW16TfuaCyyrKNp2/5rDOE26K59K3YlgIAm+aX1a7tQu0VbDkTOLRPIiWrcl5
         nEUkV2GfELaRFQZL0BVw4roVVGZ73FldtWC2vssQ9OKAlKWo6t7iC0JmbaD+AvUUHGnp
         M2wa19TMBkRJDPr+RNdyO3rM+/AckXrFZlanq6C7MG5FmnCU+7gF9bn31YZP9HLgj/Wb
         GDcsQRuGCGIRJvN/lm4Hz9dBbnoiekPtnFriJjnabyYYbpu5f0/sW0IzJ6ilYjELn81h
         FDMiLAvNnOEyW6WOI+bb7Fk7bpwp7EYdKMYh9oyQTtqggdmE2W72fW/5YhZTqt0YMOEq
         xQRw==
X-Gm-Message-State: AOAM5317qz9NZ1xuaEeequNmK60SSbdEgh7jB6FfYSaz/49R4SKCqDH1
        9wLWKeIAfl08ZneieYFWkyUXuA==
X-Google-Smtp-Source: ABdhPJxm08Dw5qERNO7i8eL2n+LUAgLRwvDET59U5dbub+LFjwjlyJTB12J2e7t37UrkXL296JWp7g==
X-Received: by 2002:a02:8545:: with SMTP id g63mr5182703jai.79.1616249854853;
        Sat, 20 Mar 2021 07:17:34 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id s16sm4273221ioe.44.2021.03.20.07.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 07:17:34 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     leon@kernel.org, andrew@lunn.ch, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/2] net: ipa: fix IPA validation
Date:   Sat, 20 Mar 2021 09:17:29 -0500
Message-Id: <20210320141729.1956732-3-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210320141729.1956732-1-elder@linaro.org>
References: <20210320141729.1956732-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are blocks of IPA code that sanity-check various values, at
compile time where possible.  Most of these checks can be done once
during development but skipped for normal operation.  These checks
permit the driver to make certain assumptions, thereby avoiding the
need for runtime error checking.

The checks are defined conditionally, but not consistently.  In
some cases IPA_VALIDATION enables the optional checks, while in
others IPA_VALIDATE is used.

Fix this by using IPA_VALIDATION consistently.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/Makefile       | 2 +-
 drivers/net/ipa/gsi_trans.c    | 8 ++++----
 drivers/net/ipa/ipa_cmd.c      | 4 ++--
 drivers/net/ipa/ipa_cmd.h      | 6 +++---
 drivers/net/ipa/ipa_endpoint.c | 6 +++---
 drivers/net/ipa/ipa_main.c     | 6 +++---
 drivers/net/ipa/ipa_mem.c      | 6 +++---
 drivers/net/ipa/ipa_table.c    | 6 +++---
 drivers/net/ipa/ipa_table.h    | 6 +++---
 9 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
index afe5df1e6eeee..014ae36ac6004 100644
--- a/drivers/net/ipa/Makefile
+++ b/drivers/net/ipa/Makefile
@@ -1,5 +1,5 @@
 # Un-comment the next line if you want to validate configuration data
-#ccflags-y		+=	-DIPA_VALIDATE
+# ccflags-y		+=	-DIPA_VALIDATION
 
 obj-$(CONFIG_QCOM_IPA)	+=	ipa.o
 
diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 6c3ed5b17b80c..284063b39b33c 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -90,14 +90,14 @@ int gsi_trans_pool_init(struct gsi_trans_pool *pool, size_t size, u32 count,
 {
 	void *virt;
 
-#ifdef IPA_VALIDATE
+#ifdef IPA_VALIDATION
 	if (!size || size % 8)
 		return -EINVAL;
 	if (count < max_alloc)
 		return -EINVAL;
 	if (!max_alloc)
 		return -EINVAL;
-#endif /* IPA_VALIDATE */
+#endif /* IPA_VALIDATION */
 
 	/* By allocating a few extra entries in our pool (one less
 	 * than the maximum number that will be requested in a
@@ -140,14 +140,14 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
 	dma_addr_t addr;
 	void *virt;
 
-#ifdef IPA_VALIDATE
+#ifdef IPA_VALIDATION
 	if (!size || size % 8)
 		return -EINVAL;
 	if (count < max_alloc)
 		return -EINVAL;
 	if (!max_alloc)
 		return -EINVAL;
-#endif /* IPA_VALIDATE */
+#endif /* IPA_VALIDATION */
 
 	/* Don't let allocations cross a power-of-two boundary */
 	size = __roundup_pow_of_two(size);
diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index d73b03a80ef89..2a4db902a728b 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -162,7 +162,7 @@ static void ipa_cmd_validate_build(void)
 #undef TABLE_SIZE
 }
 
-#ifdef IPA_VALIDATE
+#ifdef IPA_VALIDATION
 
 /* Validate a memory region holding a table */
 bool ipa_cmd_table_valid(struct ipa *ipa, const struct ipa_mem *mem,
@@ -317,7 +317,7 @@ bool ipa_cmd_data_valid(struct ipa *ipa)
 	return true;
 }
 
-#endif /* IPA_VALIDATE */
+#endif /* IPA_VALIDATION */
 
 int ipa_cmd_pool_init(struct gsi_channel *channel, u32 tre_max)
 {
diff --git a/drivers/net/ipa/ipa_cmd.h b/drivers/net/ipa/ipa_cmd.h
index 6dd3d35cf315d..429245f075122 100644
--- a/drivers/net/ipa/ipa_cmd.h
+++ b/drivers/net/ipa/ipa_cmd.h
@@ -50,7 +50,7 @@ struct ipa_cmd_info {
 	enum dma_data_direction direction;
 };
 
-#ifdef IPA_VALIDATE
+#ifdef IPA_VALIDATION
 
 /**
  * ipa_cmd_table_valid() - Validate a memory region holding a table
@@ -73,7 +73,7 @@ bool ipa_cmd_table_valid(struct ipa *ipa, const struct ipa_mem *mem,
  */
 bool ipa_cmd_data_valid(struct ipa *ipa);
 
-#else /* !IPA_VALIDATE */
+#else /* !IPA_VALIDATION */
 
 static inline bool ipa_cmd_table_valid(struct ipa *ipa,
 				       const struct ipa_mem *mem, bool route,
@@ -87,7 +87,7 @@ static inline bool ipa_cmd_data_valid(struct ipa *ipa)
 	return true;
 }
 
-#endif /* !IPA_VALIDATE */
+#endif /* !IPA_VALIDATION */
 
 /**
  * ipa_cmd_pool_init() - initialize command channel pools
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 7209ee3c31244..1a4de4e9eafcd 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -75,7 +75,7 @@ struct ipa_status {
 #define IPA_STATUS_FLAGS1_RT_RULE_ID_FMASK	GENMASK(31, 22)
 #define IPA_STATUS_FLAGS2_TAG_FMASK		GENMASK_ULL(63, 16)
 
-#ifdef IPA_VALIDATE
+#ifdef IPA_VALIDATION
 
 static bool ipa_endpoint_data_valid_one(struct ipa *ipa, u32 count,
 			    const struct ipa_gsi_endpoint_data *all_data,
@@ -225,7 +225,7 @@ static bool ipa_endpoint_data_valid(struct ipa *ipa, u32 count,
 	return true;
 }
 
-#else /* !IPA_VALIDATE */
+#else /* !IPA_VALIDATION */
 
 static bool ipa_endpoint_data_valid(struct ipa *ipa, u32 count,
 				    const struct ipa_gsi_endpoint_data *data)
@@ -233,7 +233,7 @@ static bool ipa_endpoint_data_valid(struct ipa *ipa, u32 count,
 	return true;
 }
 
-#endif /* !IPA_VALIDATE */
+#endif /* !IPA_VALIDATION */
 
 /* Allocate a transaction to use on a non-command endpoint */
 static struct gsi_trans *ipa_endpoint_trans_alloc(struct ipa_endpoint *endpoint,
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index d354e3e65ec50..d95909a4aef4c 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -734,7 +734,7 @@ MODULE_DEVICE_TABLE(of, ipa_match);
  * */
 static void ipa_validate_build(void)
 {
-#ifdef IPA_VALIDATE
+#ifdef IPA_VALIDATION
 	/* At one time we assumed a 64-bit build, allowing some do_div()
 	 * calls to be replaced by simple division or modulo operations.
 	 * We currently only perform divide and modulo operations on u32,
@@ -768,7 +768,7 @@ static void ipa_validate_build(void)
 	BUILD_BUG_ON(!ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY));
 	BUILD_BUG_ON(ipa_aggr_granularity_val(IPA_AGGR_GRANULARITY) >
 			field_max(AGGR_GRANULARITY_FMASK));
-#endif /* IPA_VALIDATE */
+#endif /* IPA_VALIDATION */
 }
 
 /**
@@ -808,7 +808,7 @@ static int ipa_probe(struct platform_device *pdev)
 	/* Get configuration data early; needed for clock initialization */
 	data = of_device_get_match_data(dev);
 	if (!data) {
-		/* This is really IPA_VALIDATE (should never happen) */
+		/* This is really IPA_VALIDATION (should never happen) */
 		dev_err(dev, "matched hardware not supported\n");
 		return -ENODEV;
 	}
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index f25029b9ec857..6a239d49bb559 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -100,7 +100,7 @@ void ipa_mem_teardown(struct ipa *ipa)
 	/* Nothing to do */
 }
 
-#ifdef IPA_VALIDATE
+#ifdef IPA_VALIDATION
 
 static bool ipa_mem_valid(struct ipa *ipa, enum ipa_mem_id mem_id)
 {
@@ -127,14 +127,14 @@ static bool ipa_mem_valid(struct ipa *ipa, enum ipa_mem_id mem_id)
 	return false;
 }
 
-#else /* !IPA_VALIDATE */
+#else /* !IPA_VALIDATION */
 
 static bool ipa_mem_valid(struct ipa *ipa, enum ipa_mem_id mem_id)
 {
 	return true;
 }
 
-#endif /*! IPA_VALIDATE */
+#endif /*! IPA_VALIDATION */
 
 /**
  * ipa_mem_config() - Configure IPA shared memory
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 988f2c2886b95..aa8b3ce7e21d9 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -113,7 +113,7 @@
  */
 #define IPA_ZERO_RULE_SIZE		(2 * sizeof(__le32))
 
-#ifdef IPA_VALIDATE
+#ifdef IPA_VALIDATION
 
 /* Check things that can be validated at build time. */
 static void ipa_table_validate_build(void)
@@ -225,13 +225,13 @@ bool ipa_filter_map_valid(struct ipa *ipa, u32 filter_map)
 	return true;
 }
 
-#else /* !IPA_VALIDATE */
+#else /* !IPA_VALIDATION */
 static void ipa_table_validate_build(void)
 
 {
 }
 
-#endif /* !IPA_VALIDATE */
+#endif /* !IPA_VALIDATION */
 
 /* Zero entry count means no table, so just return a 0 address */
 static dma_addr_t ipa_table_addr(struct ipa *ipa, bool filter_mask, u16 count)
diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
index 889c2e93b1223..6017d60fb870e 100644
--- a/drivers/net/ipa/ipa_table.h
+++ b/drivers/net/ipa/ipa_table.h
@@ -19,7 +19,7 @@ struct ipa;
 /* The maximum number of route table entries (IPv4, IPv6; hashed or not) */
 #define IPA_ROUTE_COUNT_MAX	15
 
-#ifdef IPA_VALIDATE
+#ifdef IPA_VALIDATION
 
 /**
  * ipa_table_valid() - Validate route and filter table memory regions
@@ -37,7 +37,7 @@ bool ipa_table_valid(struct ipa *ipa);
  */
 bool ipa_filter_map_valid(struct ipa *ipa, u32 filter_mask);
 
-#else /* !IPA_VALIDATE */
+#else /* !IPA_VALIDATION */
 
 static inline bool ipa_table_valid(struct ipa *ipa)
 {
@@ -49,7 +49,7 @@ static inline bool ipa_filter_map_valid(struct ipa *ipa, u32 filter_mask)
 	return true;
 }
 
-#endif /* !IPA_VALIDATE */
+#endif /* !IPA_VALIDATION */
 
 /**
  * ipa_table_hash_support() - Return true if hashed tables are supported
-- 
2.27.0

