Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112AE3A33F4
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 21:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhFJT0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 15:26:20 -0400
Received: from mail-io1-f52.google.com ([209.85.166.52]:35683 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbhFJT0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 15:26:17 -0400
Received: by mail-io1-f52.google.com with SMTP id d9so28273242ioo.2
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 12:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TgCXcwikD7YOZc4EH2kp/99Pj/MYR+EhW4Nm3Stgz2A=;
        b=PMLFIfuP55Qo2ENFeYxAlLv5stNrgAnVD7EwtddQLlrGL0Y+pURXgyzq72UEEDiH97
         H4Q3dn5xLRAdRKTWze4blcgN/INaLiEhQ7MUdxg0QqaGvdqYupw60fnlKYuU2gu+6tTw
         TmKDix6C0U1DSiIwSjRKL2aPbNLoixW35LNKd/Ws7SZk4QdcUP5EcsL72KNCJ6lZybs7
         BZ9VFqEUPwQqG4neRyFftWBuWQjLV/BIA3yrvbip4kCS/DPAyiWEfXgScO2q1PLw23ks
         CN6+SM/ILr/3hLkx7/aVAAZx5tJDarOKH3zazS0kwnEYHEgWDAwF8rHNsj274ruZ1KgX
         h7Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TgCXcwikD7YOZc4EH2kp/99Pj/MYR+EhW4Nm3Stgz2A=;
        b=sR7OkjOiwHXDIstptMRAHMA1K3xDoIwadIIvinOVKZnmczVctn6yF1/CiLgAIDZ+Zk
         1D9qDuOoUsSJNBAMWZMgIJOQDxFAd0deR6l0mE9auEE84Rdi4xLpRfJ6v/YHJ9zQVUbw
         1G8gxNQFpDjAESSVks5o7amqEhMVm+0r2hey4JtAeaQ2WlDXirIGP/BOurZgqYE3bJbx
         BeBuZhkXKRB8Catw1nWkTNrjEI0fbBjUkvw4nhzrSo6XUcPRcmpLvZ1zrF/ptyKJkfuA
         Xs0lz/1RfHdck+PrQE3Ac/falhujkwITfR+lYG7LVxl295++u6kOab45PmuIQfVpXXW4
         bjcg==
X-Gm-Message-State: AOAM5303pep7ZmLNauSt0YH0zizq9ifAsmJkU2ELeh/LEvFKI6RVFjGN
        k7rvmpknMrpu1CVurRHFYHwhkw==
X-Google-Smtp-Source: ABdhPJwmF/mO7zo69kffbBOt/qwwhbYZnwNMahKDUqUyZUOIH0o3sPKBS0b7Y0TSVZFZjUMCE2MECQ==
X-Received: by 2002:a6b:cd08:: with SMTP id d8mr114858iog.86.1623352993715;
        Thu, 10 Jun 2021 12:23:13 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w21sm2028684iol.52.2021.06.10.12.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 12:23:13 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/8] net: ipa: don't assume mem array indexed by ID
Date:   Thu, 10 Jun 2021 14:23:01 -0500
Message-Id: <20210610192308.2739540-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210610192308.2739540-1-elder@linaro.org>
References: <20210610192308.2739540-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change ipa_mem_valid() to iterate over the entries using a u32 index
variable rather than using a memory region ID.  Use the ID found
inside the memory descriptor rather than the loop index.

Change ipa_mem_size_valid() to iterate over the entries but without
assuming the array index is the memory region ID.  "Empty" entries
will have zero size; and we'll temporarily assume such entries have
zero offset as well (they all do, currently).

Similarly, don't assume the mem[] array is indexed by ID in
ipa_mem_config().  There, "empty" entries will have a zero canary
count, so no special assumptions are needed to handle them correctly.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_mem.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index ef9fdd3b88750..9e504ec278179 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -220,6 +220,7 @@ static bool ipa_mem_valid(struct ipa *ipa, const struct ipa_mem_data *mem_data)
 	DECLARE_BITMAP(regions, IPA_MEM_COUNT) = { };
 	struct device *dev = &ipa->pdev->dev;
 	enum ipa_mem_id mem_id;
+	u32 i;
 
 	if (mem_data->local_count > IPA_MEM_COUNT) {
 		dev_err(dev, "too many memory regions (%u > %u)\n",
@@ -227,10 +228,10 @@ static bool ipa_mem_valid(struct ipa *ipa, const struct ipa_mem_data *mem_data)
 		return false;
 	}
 
-	for (mem_id = 0; mem_id < mem_data->local_count; mem_id++) {
-		const struct ipa_mem *mem = &mem_data->local[mem_id];
+	for (i = 0; i < mem_data->local_count; i++) {
+		const struct ipa_mem *mem = &mem_data->local[i];
 
-		if (mem_id == IPA_MEM_UNDEFINED)
+		if (mem->id == IPA_MEM_UNDEFINED)
 			continue;
 
 		if (__test_and_set_bit(mem->id, regions)) {
@@ -248,7 +249,7 @@ static bool ipa_mem_valid(struct ipa *ipa, const struct ipa_mem_data *mem_data)
 		/* It's harmless, but warn if an offset is provided */
 		if (mem->offset)
 			dev_warn(dev, "empty region %u has non-zero offset\n",
-				 mem_id);
+				 mem->id);
 	}
 
 	/* Now see if any required regions are not defined */
@@ -268,16 +269,16 @@ static bool ipa_mem_size_valid(struct ipa *ipa)
 {
 	struct device *dev = &ipa->pdev->dev;
 	u32 limit = ipa->mem_size;
-	enum ipa_mem_id mem_id;
+	u32 i;
 
-	for (mem_id = 0; mem_id < ipa->mem_count; mem_id++) {
-		const struct ipa_mem *mem = &ipa->mem[mem_id];
+	for (i = 0; i < ipa->mem_count; i++) {
+		const struct ipa_mem *mem = &ipa->mem[i];
 
 		if (mem->offset + mem->size <= limit)
 			continue;
 
 		dev_err(dev, "region %u ends beyond memory limit (0x%08x)\n",
-			mem_id, limit);
+			mem->id, limit);
 
 		return false;
 	}
@@ -294,11 +295,11 @@ static bool ipa_mem_size_valid(struct ipa *ipa)
 int ipa_mem_config(struct ipa *ipa)
 {
 	struct device *dev = &ipa->pdev->dev;
-	enum ipa_mem_id mem_id;
 	dma_addr_t addr;
 	u32 mem_size;
 	void *virt;
 	u32 val;
+	u32 i;
 
 	/* Check the advertised location and size of the shared memory area */
 	val = ioread32(ipa->reg_virt + IPA_REG_SHARED_MEM_SIZE_OFFSET);
@@ -330,11 +331,11 @@ int ipa_mem_config(struct ipa *ipa)
 	ipa->zero_virt = virt;
 	ipa->zero_size = IPA_MEM_MAX;
 
-	/* For each region, write "canary" values in the space prior to
-	 * the region's base address if indicated.
+	/* For each defined region, write "canary" values in the
+	 * space prior to the region's base address if indicated.
 	 */
-	for (mem_id = 0; mem_id < ipa->mem_count; mem_id++) {
-		const struct ipa_mem *mem = &ipa->mem[mem_id];
+	for (i = 0; i < ipa->mem_count; i++) {
+		const struct ipa_mem *mem = &ipa->mem[i];
 		u16 canary_count;
 		__le32 *canary;
 
-- 
2.27.0

