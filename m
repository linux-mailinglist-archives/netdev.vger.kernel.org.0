Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0760A37AF7F
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 21:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbhEKTnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 15:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbhEKTnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 15:43:15 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABA0C06174A
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 12:42:09 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id j20so18154312ilo.10
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 12:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OUH0FdBeW1WnRtCtReTmgR1inU25bGMEwO/oVzk72IY=;
        b=RVHTN0z0CTnwSws52IqIFciBCI4uG+vGpfhMwu96/YF+df0LqBgOSSMhSzkxXxiL/a
         MisbEK0ye3GOcwqozujkDgr4LFDPgSfqVPvhgFgRtDM+ZgUNs56dv9gBhPamQZbDkzSt
         3MvlOWbL2P7hvcgMcpQEVK7U+n4bS+YmxpCYJc2eE1zDtsH3NW91cv15ID7sh6h1TME/
         Ouhsdk6i4HcmmAhJAXPT68Hrpu9sq2BhRWZYHsOUL0wugcW+o466Tpz/lJEkFZNegAQ4
         ibt7tmvAfGVmlqt8Nj50GLtdJUraz8W45UTTwNB2sLW/ga3G2eWphMoavkdlNa77udMW
         4bYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OUH0FdBeW1WnRtCtReTmgR1inU25bGMEwO/oVzk72IY=;
        b=YHch+rMVkwuGuLuOW+8i5fLNnk2E40q7cnZFEdXfzNgig5+TlOzT1BhRPO2L6CENQS
         tBF7qjgGtIHFRzUN9dvpEa3QSbFemYm9l3Q2nZNNAlvEPP6cdUg8H3vecIMxUuI0lchH
         n/XYmgkP2tnSjQslEIMluv4dPKZEKPdPyc1YituNAnSHpyQm7rOASnYqIvQ71krZ4tFX
         RCqMfGukKzvC25wU+mEpSnV8+BCdp+Gi2pnINGZpqbi4AZj4kvCjxfbcRmy4POu+pO/m
         LmvvF0M2ZicS0ZGKq8FmO4WM/ixlxu6np8zHFdl7b4dmEMULEdKgw+L9liWrgxLOKnVx
         pwNg==
X-Gm-Message-State: AOAM532m2sy2nDBh0WjkqlWmm/GMrm5Uj5496IkUoBULOpujh33pALER
        YMB31ya8QpOr9kXin1po72Mk9A==
X-Google-Smtp-Source: ABdhPJy7UBz9VZgu9DYKSXdPxSNT0xTU+VRdoVwBpK0Yq6Zbx7gYMMs6U0NAZjPzVpfKfJaQnUALLw==
X-Received: by 2002:a05:6e02:12aa:: with SMTP id f10mr27982600ilr.44.1620762128709;
        Tue, 11 May 2021 12:42:08 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f13sm9973600ila.62.2021.05.11.12.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 12:42:08 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: ipa: memory region array is variable size
Date:   Tue, 11 May 2021 14:42:04 -0500
Message-Id: <20210511194204.863605-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPA configuration data includes an array of memory region
descriptors.  That was a fixed-size array at one time, but
at some point we started defining it such that it was only
as big as required for a given platform.  The actual number
of entries in the array is recorded in the configuration data
along with the array.

A loop in ipa_mem_config() still assumes the array has entries
for all defined memory region IDs.  As a result, this loop can
go past the end of the actual array and attempt to write
"canary" values based on nonsensical data.

Fix this, by stashing the number of entries in the array, and
using that rather than IPA_MEM_COUNT in the initialization loop
found in ipa_mem_config().

The only remaining use of IPA_MEM_COUNT is in a validation check
to ensure configuration data doesn't have too many entries.
That's fine for now.

Fixes: 3128aae8c439a ("net: ipa: redefine struct ipa_mem_data")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa.h     | 2 ++
 drivers/net/ipa/ipa_mem.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index e7ff376cb5b7d..744406832a774 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -58,6 +58,7 @@ enum ipa_flag {
  * @mem_virt:		Virtual address of IPA-local memory space
  * @mem_offset:		Offset from @mem_virt used for access to IPA memory
  * @mem_size:		Total size (bytes) of memory at @mem_virt
+ * @mem_count:		Number of entries in the mem array
  * @mem:		Array of IPA-local memory region descriptors
  * @imem_iova:		I/O virtual address of IPA region in IMEM
  * @imem_size:		Size of IMEM region
@@ -103,6 +104,7 @@ struct ipa {
 	void *mem_virt;
 	u32 mem_offset;
 	u32 mem_size;
+	u32 mem_count;
 	const struct ipa_mem *mem;
 
 	unsigned long imem_iova;
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index c5c3b1b7e67d5..1624125e7459f 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -180,7 +180,7 @@ int ipa_mem_config(struct ipa *ipa)
 	 * for the region, write "canary" values in the space prior to
 	 * the region's base address.
 	 */
-	for (mem_id = 0; mem_id < IPA_MEM_COUNT; mem_id++) {
+	for (mem_id = 0; mem_id < ipa->mem_count; mem_id++) {
 		const struct ipa_mem *mem = &ipa->mem[mem_id];
 		u16 canary_count;
 		__le32 *canary;
@@ -487,6 +487,7 @@ int ipa_mem_init(struct ipa *ipa, const struct ipa_mem_data *mem_data)
 	ipa->mem_size = resource_size(res);
 
 	/* The ipa->mem[] array is indexed by enum ipa_mem_id values */
+	ipa->mem_count = mem_data->local_count;
 	ipa->mem = mem_data->local;
 
 	ret = ipa_imem_init(ipa, mem_data->imem_addr, mem_data->imem_size);
-- 
2.27.0

