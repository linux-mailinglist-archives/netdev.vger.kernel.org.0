Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5573A33F2
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 21:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhFJT0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 15:26:17 -0400
Received: from mail-io1-f48.google.com ([209.85.166.48]:39656 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbhFJT0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 15:26:16 -0400
Received: by mail-io1-f48.google.com with SMTP id f10so13753376iok.6
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 12:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GibQpwTu7Gu2O4wvPi+ttQ643kWB9j7PW3V83M+EmQU=;
        b=oLctMQxynwtBH2x3am2LvVkTVI9PXH9QMQNzGQbQ8f3If2NsFcpbMD8EkD7sYsluRp
         ft41+2/zW/O9YgxWKpwDmZk+e5Cg2OaRj1Usg1KcIMoMvWDwNlrMbMLusJQbOS272HXl
         42aVECEKtI7/Qn8TnuLgMHxyPKQ7XC6Lmn0M8Rhy79O2emV91vGma6FgOHgm4zlptIaT
         Ca0yJGn1Tf4F0jljgqbfVaRU9YihQuntQevjxkLK9GBklSXZcWW53VjKvoJbm9xQbHOu
         /5lZlYyM208Yl1HgJlPbdoICVwlxGKnmoOL23ZaoTKEl7NpUC+I+KgfGanb1rm+5vtkO
         06gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GibQpwTu7Gu2O4wvPi+ttQ643kWB9j7PW3V83M+EmQU=;
        b=K5y/XWzPz67HqgngoUZxxkfIfJewtXSaJN5mv+tWv9H1LM2YDIJZSs6U9+wfKGcdCS
         B+4fBG9xdguGl7PYD8lJKL6/p2YfTMgx1i8NYjfO6x8Si7i1PJmM72A+qz5ajpKR2zM2
         J5qw5CGE8MOB3KUb8txP1h+jQTkjaiGCgh5bIjuH5jZoo3OEnG8rLbIzAt20nNs4otKk
         E3s3RDtTszdE7KgvXAMNCD/JO+sxTzo9ujN2WXMPKfYm1Dw1iOnFaNgmp13NIwSreI9j
         QpyR+OxHUGmcLp0UlsskwiChVe7zbPjTMwoNLOUX7t6/pL02tJAzDxTmnnxMe/CeogR9
         9eoA==
X-Gm-Message-State: AOAM532D7qODFTIWYoG9sc79AyQ0AR4jqeOd9sa4rPUu/nVD0a1HH9xT
        d3xYFUb6mYn1goKLnXKIyANR6w==
X-Google-Smtp-Source: ABdhPJyrHEIm6xNo2vzzKTgHIwTpY5PwuvARrlLOdSQbH8pR2U3x6uQuoK8s92u46C9rlYVK3iaXbw==
X-Received: by 2002:a05:6638:616:: with SMTP id g22mr200647jar.88.1623352999708;
        Thu, 10 Jun 2021 12:23:19 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w21sm2028684iol.52.2021.06.10.12.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 12:23:19 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/8] net: ipa: introduce ipa_mem_find()
Date:   Thu, 10 Jun 2021 14:23:07 -0500
Message-Id: <20210610192308.2739540-8-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210610192308.2739540-1-elder@linaro.org>
References: <20210610192308.2739540-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new function that abstracts finding information about a
region in IPA-local memory, given its memory region ID.  For now it
simply uses the region ID as an index into the IPA memory array.
If the region is not defined, ipa_mem_find() returns a null pointer.

Update all code that accesses the ipa->mem[] array directly to use
ipa_mem_find() instead.  The return value must be checked for null
when optional memory regions are sought.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_cmd.c   |  8 +++++---
 drivers/net/ipa/ipa_mem.c   | 38 ++++++++++++++++++++++++++-----------
 drivers/net/ipa/ipa_mem.h   |  2 ++
 drivers/net/ipa/ipa_qmi.c   | 32 +++++++++++++++----------------
 drivers/net/ipa/ipa_table.c |  8 ++++----
 drivers/net/ipa/ipa_uc.c    |  3 ++-
 6 files changed, 56 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index 3e5f10d3c131d..af44ca41189e3 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -218,7 +218,7 @@ static bool ipa_cmd_header_valid(struct ipa *ipa)
 	/* The header memory area contains both the modem and AP header
 	 * regions.  The modem portion defines the address of the region.
 	 */
-	mem = &ipa->mem[IPA_MEM_MODEM_HEADER];
+	mem = ipa_mem_find(ipa, IPA_MEM_MODEM_HEADER);
 	offset = mem->offset;
 	size = mem->size;
 
@@ -231,8 +231,10 @@ static bool ipa_cmd_header_valid(struct ipa *ipa)
 		return false;
 	}
 
-	/* Add the size of the AP portion to the combined size */
-	size += ipa->mem[IPA_MEM_AP_HEADER].size;
+	/* Add the size of the AP portion (if defined) to the combined size */
+	mem = ipa_mem_find(ipa, IPA_MEM_AP_HEADER);
+	if (mem)
+		size += mem->size;
 
 	/* Make sure the combined size fits in the IPA command */
 	if (size > size_max) {
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 7df5496bdc2e4..633895fc67b66 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -26,12 +26,20 @@
 /* SMEM host id representing the modem. */
 #define QCOM_SMEM_HOST_MODEM	1
 
+const struct ipa_mem *ipa_mem_find(struct ipa *ipa, enum ipa_mem_id mem_id)
+{
+	if (mem_id < IPA_MEM_COUNT)
+		return &ipa->mem[mem_id];
+
+	return NULL;
+}
+
 /* Add an immediate command to a transaction that zeroes a memory region */
 static void
 ipa_mem_zero_region_add(struct gsi_trans *trans, enum ipa_mem_id mem_id)
 {
 	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
-	const struct ipa_mem *mem = &ipa->mem[mem_id];
+	const struct ipa_mem *mem = ipa_mem_find(ipa, mem_id);
 	dma_addr_t addr = ipa->zero_addr;
 
 	if (!mem->size)
@@ -61,6 +69,7 @@ ipa_mem_zero_region_add(struct gsi_trans *trans, enum ipa_mem_id mem_id)
 int ipa_mem_setup(struct ipa *ipa)
 {
 	dma_addr_t addr = ipa->zero_addr;
+	const struct ipa_mem *mem;
 	struct gsi_trans *trans;
 	u32 offset;
 	u16 size;
@@ -75,12 +84,16 @@ int ipa_mem_setup(struct ipa *ipa)
 		return -EBUSY;
 	}
 
-	/* Initialize IPA-local header memory.  The modem and AP header
-	 * regions are contiguous, and initialized together.
+	/* Initialize IPA-local header memory.  The AP header region, if
+	 * present, is contiguous with and follows the modem header region,
+	 * and they are initialized together.
 	 */
-	offset = ipa->mem[IPA_MEM_MODEM_HEADER].offset;
-	size = ipa->mem[IPA_MEM_MODEM_HEADER].size;
-	size += ipa->mem[IPA_MEM_AP_HEADER].size;
+	mem = ipa_mem_find(ipa, IPA_MEM_MODEM_HEADER);
+	offset = mem->offset;
+	size = mem->size;
+	mem = ipa_mem_find(ipa, IPA_MEM_AP_HEADER);
+	if (mem)
+		size += mem->size;
 
 	ipa_cmd_hdr_init_local_add(trans, offset, size, addr);
 
@@ -91,7 +104,8 @@ int ipa_mem_setup(struct ipa *ipa)
 	gsi_trans_commit_wait(trans);
 
 	/* Tell the hardware where the processing context area is located */
-	offset = ipa->mem_offset + ipa->mem[IPA_MEM_MODEM_PROC_CTX].offset;
+	mem = ipa_mem_find(ipa, IPA_MEM_MODEM_PROC_CTX);
+	offset = ipa->mem_offset + mem->offset;
 	val = proc_cntxt_base_addr_encoded(ipa->version, offset);
 	iowrite32(val, ipa->reg_virt + IPA_REG_LOCAL_PKT_PROC_CNTXT_OFFSET);
 
@@ -294,6 +308,7 @@ static bool ipa_mem_size_valid(struct ipa *ipa)
 int ipa_mem_config(struct ipa *ipa)
 {
 	struct device *dev = &ipa->pdev->dev;
+	const struct ipa_mem *mem;
 	dma_addr_t addr;
 	u32 mem_size;
 	void *virt;
@@ -334,11 +349,11 @@ int ipa_mem_config(struct ipa *ipa)
 	 * space prior to the region's base address if indicated.
 	 */
 	for (i = 0; i < ipa->mem_count; i++) {
-		const struct ipa_mem *mem = &ipa->mem[i];
 		u16 canary_count;
 		__le32 *canary;
 
 		/* Skip over undefined regions */
+		mem = &ipa->mem[i];
 		if (!mem->offset && !mem->size)
 			continue;
 
@@ -361,8 +376,9 @@ int ipa_mem_config(struct ipa *ipa)
 	if (!ipa_cmd_data_valid(ipa))
 		goto err_dma_free;
 
-	/* Verify the microcontroller ring alignment (0 is OK too) */
-	if (ipa->mem[IPA_MEM_UC_EVENT_RING].offset % 1024) {
+	/* Verify the microcontroller ring alignment (if defined) */
+	mem = ipa_mem_find(ipa, IPA_MEM_UC_EVENT_RING);
+	if (mem && mem->offset % 1024) {
 		dev_err(dev, "microcontroller ring not 1024-byte aligned\n");
 		goto err_dma_free;
 	}
@@ -527,7 +543,7 @@ static int ipa_smem_init(struct ipa *ipa, u32 item, size_t size)
 	 * (in this case, the modem).  An allocation from SMEM is persistent
 	 * until the AP reboots; there is no way to free an allocated SMEM
 	 * region.  Allocation only reserves the space; to use it you need
-	 * to "get" a pointer it (this implies no reference counting).
+	 * to "get" a pointer it (this does not imply reference counting).
 	 * The item might have already been allocated, in which case we
 	 * use it unless the size isn't what we expect.
 	 */
diff --git a/drivers/net/ipa/ipa_mem.h b/drivers/net/ipa/ipa_mem.h
index effe01f7310a2..712b2881be0c2 100644
--- a/drivers/net/ipa/ipa_mem.h
+++ b/drivers/net/ipa/ipa_mem.h
@@ -90,6 +90,8 @@ struct ipa_mem {
 	u16 canary_count;
 };
 
+const struct ipa_mem *ipa_mem_find(struct ipa *ipa, enum ipa_mem_id mem_id);
+
 int ipa_mem_config(struct ipa *ipa);
 void ipa_mem_deconfig(struct ipa *ipa);
 
diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
index 593665efbcf99..4661105ce7ab2 100644
--- a/drivers/net/ipa/ipa_qmi.c
+++ b/drivers/net/ipa/ipa_qmi.c
@@ -298,32 +298,32 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 	req.platform_type_valid = 1;
 	req.platform_type = IPA_QMI_PLATFORM_TYPE_MSM_ANDROID;
 
-	mem = &ipa->mem[IPA_MEM_MODEM_HEADER];
+	mem = ipa_mem_find(ipa, IPA_MEM_MODEM_HEADER);
 	if (mem->size) {
 		req.hdr_tbl_info_valid = 1;
 		req.hdr_tbl_info.start = ipa->mem_offset + mem->offset;
 		req.hdr_tbl_info.end = req.hdr_tbl_info.start + mem->size - 1;
 	}
 
-	mem = &ipa->mem[IPA_MEM_V4_ROUTE];
+	mem = ipa_mem_find(ipa, IPA_MEM_V4_ROUTE);
 	req.v4_route_tbl_info_valid = 1;
 	req.v4_route_tbl_info.start = ipa->mem_offset + mem->offset;
 	req.v4_route_tbl_info.count = mem->size / sizeof(__le64);
 
-	mem = &ipa->mem[IPA_MEM_V6_ROUTE];
+	mem = ipa_mem_find(ipa, IPA_MEM_V6_ROUTE);
 	req.v6_route_tbl_info_valid = 1;
 	req.v6_route_tbl_info.start = ipa->mem_offset + mem->offset;
 	req.v6_route_tbl_info.count = mem->size / sizeof(__le64);
 
-	mem = &ipa->mem[IPA_MEM_V4_FILTER];
+	mem = ipa_mem_find(ipa, IPA_MEM_V4_FILTER);
 	req.v4_filter_tbl_start_valid = 1;
 	req.v4_filter_tbl_start = ipa->mem_offset + mem->offset;
 
-	mem = &ipa->mem[IPA_MEM_V6_FILTER];
+	mem = ipa_mem_find(ipa, IPA_MEM_V6_FILTER);
 	req.v6_filter_tbl_start_valid = 1;
 	req.v6_filter_tbl_start = ipa->mem_offset + mem->offset;
 
-	mem = &ipa->mem[IPA_MEM_MODEM];
+	mem = ipa_mem_find(ipa, IPA_MEM_MODEM);
 	if (mem->size) {
 		req.modem_mem_info_valid = 1;
 		req.modem_mem_info.start = ipa->mem_offset + mem->offset;
@@ -336,7 +336,7 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 
 	/* skip_uc_load_valid and skip_uc_load are set above */
 
-	mem = &ipa->mem[IPA_MEM_MODEM_PROC_CTX];
+	mem = ipa_mem_find(ipa, IPA_MEM_MODEM_PROC_CTX);
 	if (mem->size) {
 		req.hdr_proc_ctx_tbl_info_valid = 1;
 		req.hdr_proc_ctx_tbl_info.start =
@@ -347,7 +347,7 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 
 	/* Nothing to report for the compression table (zip_tbl_info) */
 
-	mem = &ipa->mem[IPA_MEM_V4_ROUTE_HASHED];
+	mem = ipa_mem_find(ipa, IPA_MEM_V4_ROUTE_HASHED);
 	if (mem->size) {
 		req.v4_hash_route_tbl_info_valid = 1;
 		req.v4_hash_route_tbl_info.start =
@@ -355,7 +355,7 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 		req.v4_hash_route_tbl_info.count = mem->size / sizeof(__le64);
 	}
 
-	mem = &ipa->mem[IPA_MEM_V6_ROUTE_HASHED];
+	mem = ipa_mem_find(ipa, IPA_MEM_V6_ROUTE_HASHED);
 	if (mem->size) {
 		req.v6_hash_route_tbl_info_valid = 1;
 		req.v6_hash_route_tbl_info.start =
@@ -363,22 +363,21 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 		req.v6_hash_route_tbl_info.count = mem->size / sizeof(__le64);
 	}
 
-	mem = &ipa->mem[IPA_MEM_V4_FILTER_HASHED];
+	mem = ipa_mem_find(ipa, IPA_MEM_V4_FILTER_HASHED);
 	if (mem->size) {
 		req.v4_hash_filter_tbl_start_valid = 1;
 		req.v4_hash_filter_tbl_start = ipa->mem_offset + mem->offset;
 	}
 
-	mem = &ipa->mem[IPA_MEM_V6_FILTER_HASHED];
+	mem = ipa_mem_find(ipa, IPA_MEM_V6_FILTER_HASHED);
 	if (mem->size) {
 		req.v6_hash_filter_tbl_start_valid = 1;
 		req.v6_hash_filter_tbl_start = ipa->mem_offset + mem->offset;
 	}
 
-	/* None of the stats fields are valid (IPA v4.0 and above) */
-
+	/* The stats fields are only valid for IPA v4.0+ */
 	if (ipa->version >= IPA_VERSION_4_0) {
-		mem = &ipa->mem[IPA_MEM_STATS_QUOTA_MODEM];
+		mem = ipa_mem_find(ipa, IPA_MEM_STATS_QUOTA_MODEM);
 		if (mem->size) {
 			req.hw_stats_quota_base_addr_valid = 1;
 			req.hw_stats_quota_base_addr =
@@ -387,8 +386,9 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 			req.hw_stats_quota_size = ipa->mem_offset + mem->size;
 		}
 
-		mem = &ipa->mem[IPA_MEM_STATS_DROP];
-		if (mem->size) {
+		/* If the DROP stats region is defined, include it */
+		mem = ipa_mem_find(ipa, IPA_MEM_STATS_DROP);
+		if (mem && mem->size) {
 			req.hw_stats_drop_base_addr_valid = 1;
 			req.hw_stats_drop_base_addr =
 				ipa->mem_offset + mem->offset;
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 679855b1d5495..c617a9156f26d 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -152,7 +152,7 @@ static void ipa_table_validate_build(void)
 static bool
 ipa_table_valid_one(struct ipa *ipa, enum ipa_mem_id mem_id, bool route)
 {
-	const struct ipa_mem *mem = &ipa->mem[mem_id];
+	const struct ipa_mem *mem = ipa_mem_find(ipa, mem_id);
 	struct device *dev = &ipa->pdev->dev;
 	u32 size;
 
@@ -245,7 +245,7 @@ static void ipa_table_reset_add(struct gsi_trans *trans, bool filter,
 				u16 first, u16 count, enum ipa_mem_id mem_id)
 {
 	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
-	const struct ipa_mem *mem = &ipa->mem[mem_id];
+	const struct ipa_mem *mem = ipa_mem_find(ipa, mem_id);
 	dma_addr_t addr;
 	u32 offset;
 	u16 size;
@@ -417,8 +417,8 @@ static void ipa_table_init_add(struct gsi_trans *trans, bool filter,
 			       enum ipa_mem_id hash_mem_id)
 {
 	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
-	const struct ipa_mem *hash_mem = &ipa->mem[hash_mem_id];
-	const struct ipa_mem *mem = &ipa->mem[mem_id];
+	const struct ipa_mem *hash_mem = ipa_mem_find(ipa, hash_mem_id);
+	const struct ipa_mem *mem = ipa_mem_find(ipa, mem_id);
 	dma_addr_t hash_addr;
 	dma_addr_t addr;
 	u16 hash_count;
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index 2756363e69385..fd9219863234c 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -116,7 +116,8 @@ enum ipa_uc_event {
 
 static struct ipa_uc_mem_area *ipa_uc_shared(struct ipa *ipa)
 {
-	u32 offset = ipa->mem_offset + ipa->mem[IPA_MEM_UC_SHARED].offset;
+	const struct ipa_mem *mem = ipa_mem_find(ipa, IPA_MEM_UC_SHARED);
+	u32 offset = ipa->mem_offset + mem->offset;
 
 	return ipa->mem_virt + offset;
 }
-- 
2.27.0

