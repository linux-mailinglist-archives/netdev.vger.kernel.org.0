Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1CC2F7A9C
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 13:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388438AbhAOMv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 07:51:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388428AbhAOMv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 07:51:56 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77ACDC0617A1
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:51:01 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id e22so17831832iom.5
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 04:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fe7+Q07XvIDemNYgzpd5hvDoa6Ra86Jcn0hOhBFTqvA=;
        b=XCg7Ra1cxB2rH9xWq7ElCtU+kicBeBEt56zjoDG7uCevi+Zz0lSvBvWbLpJ66bM6z/
         YVXdlv5gCUXBKY8hJcHxiP3owVi+FmlrESHJ86w3NJ4zlDpmVziRiEcyr/10f7geXY9Y
         bHY2DgLvYi2r/Gil2B3GFIMesBTC9hIenNDn9rYp9hQXlP6VE16rIVCdYukZhJjTzbJu
         PslyljiEV/XuFue+Eq0G+VqhvEcQU4aYN0gEYDBfBxQmba0UCt+KGa7DcX098JtPrrbL
         Kk41jd8SeJTZXQBTy3Rd8MWs2OG7rsMN8pEmSbwHKC8ISON/FGsc9zTfSwGuLVc9V+vJ
         p//g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fe7+Q07XvIDemNYgzpd5hvDoa6Ra86Jcn0hOhBFTqvA=;
        b=p4T34ZaOUBdDPDzm3hIwbqE2DRMKJT6RRkcWgiEBN/0xNkZcWfjSjM+Gz5J3lZLQzW
         M1HiewgKJ5gWQoakSjkIfyxcmyc4YwEK6OIgidv0WQWEYCym72SGWeLID5bi14N7jjc7
         iCL3NvS5EnqdncTQEw+gUgsKzKMUyE+86lU4FMMHLjNy3yV2hVzltMzff13lBapqCxK1
         97wZ/uAe3ObMk7nEaBtWmNGGrnglmtRP6ZgQzCK8SaNkjOrSoyfphcSCPoXdgLF0mmsN
         zdkpjVkORuxJbjOOPw5U2/tIMPtLxwKB1CAn4/XdfvjRApGy2wyaw2f4lqHhVfUn7oTg
         EiGg==
X-Gm-Message-State: AOAM533+2AvScAsllbuWDUkpKlx50sipYov4rGPry8Mg+QXhuMZkW1ty
        uiWlY5L7PHUnPQdYAcExiJ+KcA==
X-Google-Smtp-Source: ABdhPJyBhX0KRrhtPbY6/I+ExzPpI5V4MMfab2g4G8lwbUa1ETZDSCFLO2kQ6oWqV+jEMisKreVt2A==
X-Received: by 2002:a05:6e02:973:: with SMTP id q19mr10511266ilt.21.1610715060846;
        Fri, 15 Jan 2021 04:51:00 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f13sm3952450iog.18.2021.01.15.04.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 04:51:00 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/7] net: ipa: allow arbitrary number of interconnects
Date:   Fri, 15 Jan 2021 06:50:50 -0600
Message-Id: <20210115125050.20555-8-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210115125050.20555-1-elder@linaro.org>
References: <20210115125050.20555-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we assume that the IPA hardware has exactly three
interconnects.  But that won't be guaranteed for all platforms,
so allow any number of interconnects to be specified in the
configuration data.

For each platform, define an array of interconnect data entries
(still associated with the IPA clock structure), and record the
number of entries initialized in that array.

Loop over all entries in this array when initializing, enabling,
disabling, or tearing down the set of interconnects.

With this change we no longer need the ipa_interconnect_id
enumerated type, so get rid of it.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_clock.c       | 113 +++++++++++++-----------------
 drivers/net/ipa/ipa_data-sc7180.c |  41 ++++++-----
 drivers/net/ipa/ipa_data-sdm845.c |  41 ++++++-----
 drivers/net/ipa/ipa_data.h        |  14 ++--
 4 files changed, 97 insertions(+), 112 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index fbe42106fc2a8..354675a643db5 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -47,13 +47,15 @@ struct ipa_interconnect {
  * @count:		Clocking reference count
  * @mutex:		Protects clock enable/disable
  * @core:		IPA core clock
+ * @interconnect_count:	Number of elements in interconnect[]
  * @interconnect:	Interconnect array
  */
 struct ipa_clock {
 	refcount_t count;
 	struct mutex mutex; /* protects clock enable/disable */
 	struct clk *core;
-	struct ipa_interconnect interconnect[IPA_INTERCONNECT_COUNT];
+	u32 interconnect_count;
+	struct ipa_interconnect *interconnect;
 };
 
 static int ipa_interconnect_init_one(struct device *dev,
@@ -90,31 +92,29 @@ static int ipa_interconnect_init(struct ipa_clock *clock, struct device *dev,
 				 const struct ipa_interconnect_data *data)
 {
 	struct ipa_interconnect *interconnect;
+	u32 count;
 	int ret;
 
-	interconnect = &clock->interconnect[IPA_INTERCONNECT_MEMORY];
-	ret = ipa_interconnect_init_one(dev, interconnect, data++);
-	if (ret)
-		return ret;
+	count = clock->interconnect_count;
+	interconnect = kcalloc(count, sizeof(*interconnect), GFP_KERNEL);
+	if (!interconnect)
+		return -ENOMEM;
+	clock->interconnect = interconnect;
 
-	interconnect = &clock->interconnect[IPA_INTERCONNECT_IMEM];
-	ret = ipa_interconnect_init_one(dev, interconnect, data++);
-	if (ret)
-		goto err_memory_path_put;
-
-	interconnect = &clock->interconnect[IPA_INTERCONNECT_IMEM];
-	ret = ipa_interconnect_init_one(dev, interconnect, data++);
-	if (ret)
-		goto err_imem_path_put;
+	while (count--) {
+		ret = ipa_interconnect_init_one(dev, interconnect, data++);
+		if (ret)
+			goto out_unwind;
+		interconnect++;
+	}
 
 	return 0;
 
-err_imem_path_put:
-	interconnect = &clock->interconnect[IPA_INTERCONNECT_IMEM];
-	ipa_interconnect_exit_one(interconnect);
-err_memory_path_put:
-	interconnect = &clock->interconnect[IPA_INTERCONNECT_MEMORY];
-	ipa_interconnect_exit_one(interconnect);
+out_unwind:
+	while (interconnect-- > clock->interconnect)
+		ipa_interconnect_exit_one(interconnect);
+	kfree(clock->interconnect);
+	clock->interconnect = NULL;
 
 	return ret;
 }
@@ -124,12 +124,11 @@ static void ipa_interconnect_exit(struct ipa_clock *clock)
 {
 	struct ipa_interconnect *interconnect;
 
-	interconnect = &clock->interconnect[IPA_INTERCONNECT_CONFIG];
-	ipa_interconnect_exit_one(interconnect);
-	interconnect = &clock->interconnect[IPA_INTERCONNECT_IMEM];
-	ipa_interconnect_exit_one(interconnect);
-	interconnect = &clock->interconnect[IPA_INTERCONNECT_MEMORY];
-	ipa_interconnect_exit_one(interconnect);
+	interconnect = clock->interconnect + clock->interconnect_count;
+	while (interconnect-- > clock->interconnect)
+		ipa_interconnect_exit_one(interconnect);
+	kfree(clock->interconnect);
+	clock->interconnect = NULL;
 }
 
 /* Currently we only use one bandwidth level, so just "enable" interconnects */
@@ -138,33 +137,23 @@ static int ipa_interconnect_enable(struct ipa *ipa)
 	struct ipa_interconnect *interconnect;
 	struct ipa_clock *clock = ipa->clock;
 	int ret;
+	u32 i;
 
-	interconnect = &clock->interconnect[IPA_INTERCONNECT_MEMORY];
-	ret = icc_set_bw(interconnect->path, interconnect->average_bandwidth,
-			 interconnect->peak_bandwidth);
-	if (ret)
-		return ret;
-
-	interconnect = &clock->interconnect[IPA_INTERCONNECT_IMEM];
-	ret = icc_set_bw(interconnect->path, interconnect->average_bandwidth,
-			 interconnect->peak_bandwidth);
-	if (ret)
-		goto err_memory_path_disable;
-
-	interconnect = &clock->interconnect[IPA_INTERCONNECT_CONFIG];
-	ret = icc_set_bw(interconnect->path, interconnect->average_bandwidth,
-			 interconnect->peak_bandwidth);
-	if (ret)
-		goto err_imem_path_disable;
+	interconnect = clock->interconnect;
+	for (i = 0; i < clock->interconnect_count; i++) {
+		ret = icc_set_bw(interconnect->path,
+				 interconnect->average_bandwidth,
+				 interconnect->peak_bandwidth);
+		if (ret)
+			goto out_unwind;
+		interconnect++;
+	}
 
 	return 0;
 
-err_imem_path_disable:
-	interconnect = &clock->interconnect[IPA_INTERCONNECT_IMEM];
-	(void)icc_set_bw(interconnect->path, 0, 0);
-err_memory_path_disable:
-	interconnect = &clock->interconnect[IPA_INTERCONNECT_MEMORY];
-	(void)icc_set_bw(interconnect->path, 0, 0);
+out_unwind:
+	while (interconnect-- > clock->interconnect)
+		(void)icc_set_bw(interconnect->path, 0, 0);
 
 	return ret;
 }
@@ -175,22 +164,17 @@ static void ipa_interconnect_disable(struct ipa *ipa)
 	struct ipa_interconnect *interconnect;
 	struct ipa_clock *clock = ipa->clock;
 	int result = 0;
+	u32 count;
 	int ret;
 
-	interconnect = &clock->interconnect[IPA_INTERCONNECT_MEMORY];
-	ret = icc_set_bw(interconnect->path, 0, 0);
-	if (ret)
-		result = ret;
-
-	interconnect = &clock->interconnect[IPA_INTERCONNECT_IMEM];
-	ret = icc_set_bw(interconnect->path, 0, 0);
-	if (ret && !result)
-		result = ret;
-
-	interconnect = &clock->interconnect[IPA_INTERCONNECT_IMEM];
-	ret = icc_set_bw(interconnect->path, 0, 0);
-	if (ret && !result)
-		result = ret;
+	count = clock->interconnect_count;
+	interconnect = clock->interconnect + count;
+	while (count--) {
+		interconnect--;
+		ret = icc_set_bw(interconnect->path, 0, 0);
+		if (ret && !result)
+			result = ret;
+	}
 
 	if (result)
 		dev_err(&ipa->pdev->dev,
@@ -314,8 +298,9 @@ ipa_clock_init(struct device *dev, const struct ipa_clock_data *data)
 		goto err_clk_put;
 	}
 	clock->core = clk;
+	clock->interconnect_count = data->interconnect_count;
 
-	ret = ipa_interconnect_init(clock, dev, data->interconnect);
+	ret = ipa_interconnect_init(clock, dev, data->interconnect_data);
 	if (ret)
 		goto err_kfree;
 
diff --git a/drivers/net/ipa/ipa_data-sc7180.c b/drivers/net/ipa/ipa_data-sc7180.c
index 1936ecb4c1104..997b51ceb7d76 100644
--- a/drivers/net/ipa/ipa_data-sc7180.c
+++ b/drivers/net/ipa/ipa_data-sc7180.c
@@ -309,27 +309,30 @@ static struct ipa_mem_data ipa_mem_data = {
 	.smem_size	= 0x00002000,
 };
 
+/* Interconnect bandwidths are in 1000 byte/second units */
+static struct ipa_interconnect_data ipa_interconnect_data[] = {
+	{
+		.name			= "memory",
+		.peak_bandwidth		= 465000,	/* 465 MBps */
+		.average_bandwidth	= 80000,	/* 80 MBps */
+	},
+	/* Average bandwidth is unused for the next two interconnects */
+	{
+		.name			= "imem",
+		.peak_bandwidth		= 68570,	/* 68.570 MBps */
+		.average_bandwidth	= 0,		/* unused */
+	},
+	{
+		.name			= "config",
+		.peak_bandwidth		= 30000,	/* 30 MBps */
+		.average_bandwidth	= 0,		/* unused */
+	},
+};
+
 static struct ipa_clock_data ipa_clock_data = {
 	.core_clock_rate	= 100 * 1000 * 1000,	/* Hz */
-	/* Interconnect bandwidths are in 1000 byte/second units */
-	.interconnect = {
-		[IPA_INTERCONNECT_MEMORY] = {
-			.name			= "memory",
-			.peak_bandwidth		= 465000,	/* 465 MBps */
-			.average_bandwidth	= 80000,	/* 80 MBps */
-		},
-		/* Average bandwidth unused for the next two interconnects */
-		[IPA_INTERCONNECT_IMEM] = {
-			.name			= "imem",
-			.peak_bandwidth		= 68570,	/* 68.57 MBps */
-			.average_bandwidth	= 0,		/* unused */
-		},
-		[IPA_INTERCONNECT_CONFIG] = {
-			.name			= "config",
-			.peak_bandwidth		= 30000,	/* 30 MBps */
-			.average_bandwidth	= 0,		/* unused */
-		},
-	},
+	.interconnect_count	= ARRAY_SIZE(ipa_interconnect_data),
+	.interconnect_data	= ipa_interconnect_data,
 };
 
 /* Configuration data for the SC7180 SoC. */
diff --git a/drivers/net/ipa/ipa_data-sdm845.c b/drivers/net/ipa/ipa_data-sdm845.c
index 3b556b5a63406..88c9c3562ab79 100644
--- a/drivers/net/ipa/ipa_data-sdm845.c
+++ b/drivers/net/ipa/ipa_data-sdm845.c
@@ -329,27 +329,30 @@ static struct ipa_mem_data ipa_mem_data = {
 	.smem_size	= 0x00002000,
 };
 
+/* Interconnect bandwidths are in 1000 byte/second units */
+static struct ipa_interconnect_data ipa_interconnect_data[] = {
+	{
+		.name			= "memory",
+		.peak_bandwidth		= 600000,	/* 600 MBps */
+		.average_bandwidth	= 80000,	/* 80 MBps */
+	},
+	/* Average bandwidth is unused for the next two interconnects */
+	{
+		.name			= "imem",
+		.peak_bandwidth		= 350000,	/* 350 MBps */
+		.average_bandwidth	= 0,		/* unused */
+	},
+	{
+		.name			= "config",
+		.peak_bandwidth		= 40000,	/* 40 MBps */
+		.average_bandwidth	= 0,		/* unused */
+	},
+};
+
 static struct ipa_clock_data ipa_clock_data = {
 	.core_clock_rate	= 75 * 1000 * 1000,	/* Hz */
-	/* Interconnect bandwidths are in 1000 byte/second units */
-	.interconnect = {
-		[IPA_INTERCONNECT_MEMORY] = {
-			.name			= "memory",
-			.peak_bandwidth		= 600000,	/* 600 MBps */
-			.average_bandwidth	= 80000,	/* 80 MBps */
-		},
-		/* Average bandwidth unused for the next two interconnects */
-		[IPA_INTERCONNECT_IMEM] = {
-			.name			= "imem",
-			.peak_bandwidth		= 350000,	/* 350 MBps */
-			.average_bandwidth	= 0,		/* unused */
-		},
-		[IPA_INTERCONNECT_CONFIG] = {
-			.name			= "config",
-			.peak_bandwidth		= 40000,	/* 40 MBps */
-			.average_bandwidth	= 0,		/* unused */
-		},
-	},
+	.interconnect_count	= ARRAY_SIZE(ipa_interconnect_data),
+	.interconnect_data	= ipa_interconnect_data,
 };
 
 /* Configuration data for the SDM845 SoC. */
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index d8ea6266dc6a1..b476fc373f7fe 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -258,14 +258,6 @@ struct ipa_mem_data {
 	u32 smem_size;
 };
 
-/** enum ipa_interconnect_id - IPA interconnect identifier */
-enum ipa_interconnect_id {
-	IPA_INTERCONNECT_MEMORY,
-	IPA_INTERCONNECT_IMEM,
-	IPA_INTERCONNECT_CONFIG,
-	IPA_INTERCONNECT_COUNT,		/* Last; not an interconnect */
-};
-
 /**
  * struct ipa_interconnect_data - description of IPA interconnect bandwidths
  * @name:		Interconnect name (matches interconnect-name in DT)
@@ -281,11 +273,13 @@ struct ipa_interconnect_data {
 /**
  * struct ipa_clock_data - description of IPA clock and interconnect rates
  * @core_clock_rate:	Core clock rate (Hz)
- * @interconnect:	Array of interconnect bandwidth parameters
+ * @interconnect_count:	Number of entries in the interconnect_data array
+ * @interconnect_data:	IPA interconnect configuration data
  */
 struct ipa_clock_data {
 	u32 core_clock_rate;
-	struct ipa_interconnect_data interconnect[IPA_INTERCONNECT_COUNT];
+	u32 interconnect_count;		/* # entries in interconnect_data[] */
+	const struct ipa_interconnect_data *interconnect_data;
 };
 
 /**
-- 
2.20.1

