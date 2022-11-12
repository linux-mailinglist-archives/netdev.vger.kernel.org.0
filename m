Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C88D16266D4
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 05:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbiKLEFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 23:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbiKLEE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 23:04:59 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696DABE2D
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 20:04:58 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id y6-20020a25b9c6000000b006c1c6161716so5985116ybj.8
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 20:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=s3sgmVlNCJPhymcazOWxttEdW083uKMqd63z0b1pzWw=;
        b=YWx26bIQpAnqqXnlRJ9bDLkeneEJfnzvCyvS6fyoFatJSsejPUfmU8e9QabCQQ2kMF
         heRK7H0ZUgYrekpr+f9xMZ2DbATYsyfwX++XaM+EZzpdT0QXHzYHo7juO+OO6fuhzvEo
         Tndb0wiaEdFajeyKCszx9Pun004j0gyxfpKDB3TET5YB3tynY/qNx3wSZvDita3RnNsV
         LHGyG21DytY6Vcfpkx3y3+h/76zRTwo6yjplsSVfHGavoNnLOW522BZ2z2jkn6yLyxi9
         TxoAjRb1fjC4UF9GxZznB4jZX9+D1Y1VlH78KVQG+O4sEMaRzuh7kYNuwcUILJQQpLNn
         KkKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s3sgmVlNCJPhymcazOWxttEdW083uKMqd63z0b1pzWw=;
        b=6g4blOKUMjGGCarvT7aKJ1MfjBX+BopVLfaKGBMzGEUlGEcFmNQn4lsSC3IdDBN4Iz
         dWSTLYEylQlr7MBJlhTB7F0cruTB7Lrum7qMN49Mx2rHL5ostDe1PgjQsJl16+J2Wo3K
         GQ9GhsYZ1stKSYwWwtn8DZN1H4mfCXhI06Asje4UusnQXZ1SlsvWp7FPnF7QJj0moJCL
         B/TfbWqOxdZlArPppF2mBlo0kb9+X0hBLVgu3m0hROBnW7IN4tytl3M7WGFXGFrIz4MU
         Onh8UPUwIT75Xvv5qTk+XTg7DmyTWTxm/YX0YS9XxwTMCRmqIuVphKN7EqjgOR1VgdA6
         Mojw==
X-Gm-Message-State: ACrzQf3ggj43H5Ytcztu1Vo2rCCL7PSKecuYZyex2uobL6P9HporEYae
        K0h+QsBS0X11itNde5m7M36UN/hMNgha3g==
X-Google-Smtp-Source: AMsMyM5aW413wYUCK8QITgjM6Wv7c9MESFWak+wN0jT6UWWSBrvlI9bmSEF/OFOs3/KzbWZFwufBS/mRP2hw8Q==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:5d7:0:b0:367:300a:b24a with SMTP id
 206-20020a8105d7000000b00367300ab24amr65639715ywf.128.1668225897151; Fri, 11
 Nov 2022 20:04:57 -0800 (PST)
Date:   Sat, 12 Nov 2022 04:04:52 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112040452.644234-1-edumazet@google.com>
Subject: [PATCH -next] iommu/dma: avoid expensive indirect calls for sync operations
From:   Eric Dumazet <edumazet@google.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, iommu@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quite often, NIC devices do not need dma_sync operations
on x86_64 at least.

Indeed, when dev_is_dma_coherent(dev) is true and
dev_use_swiotlb(dev) is false, iommu_dma_sync_single_for_cpu()
and friends do nothing.

However, indirectly calling them when CONFIG_RETPOLINE=y
consumes about 10% of cycles on a cpu receiving packets
from softirq at ~100Gbit rate, as shown in [1]

Even if/when CONFIG_RETPOLINE is not set, there
is a cost of about 3%.

This patch adds a copy of iommu_dma_ops structure,
where sync_single_for_cpu, sync_single_for_device,
sync_sg_for_cpu and sync_sg_for_device are unset.

perf profile before the patch:

    18.53%  [kernel]       [k] gq_rx_skb
    14.77%  [kernel]       [k] napi_reuse_skb
     8.95%  [kernel]       [k] skb_release_data
     5.42%  [kernel]       [k] dev_gro_receive
     5.37%  [kernel]       [k] memcpy
<*>  5.26%  [kernel]       [k] iommu_dma_sync_sg_for_cpu
     4.78%  [kernel]       [k] tcp_gro_receive
<*>  4.42%  [kernel]       [k] iommu_dma_sync_sg_for_device
     4.12%  [kernel]       [k] ipv6_gro_receive
     3.65%  [kernel]       [k] gq_pool_get
     3.25%  [kernel]       [k] skb_gro_receive
     2.07%  [kernel]       [k] napi_gro_frags
     1.98%  [kernel]       [k] tcp6_gro_receive
     1.27%  [kernel]       [k] gq_rx_prep_buffers
     1.18%  [kernel]       [k] gq_rx_napi_handler
     0.99%  [kernel]       [k] csum_partial
     0.74%  [kernel]       [k] csum_ipv6_magic
     0.72%  [kernel]       [k] free_pcp_prepare
     0.60%  [kernel]       [k] __napi_poll
     0.58%  [kernel]       [k] net_rx_action
     0.56%  [kernel]       [k] read_tsc
<*>  0.50%  [kernel]       [k] __x86_indirect_thunk_r11
     0.45%  [kernel]       [k] memset

After patch, lines with <*> no longer show up, and overall
cpu usage looks much better (~60% instead of ~72%)

    25.56%  [kernel]       [k] gq_rx_skb
     9.90%  [kernel]       [k] napi_reuse_skb
     7.39%  [kernel]       [k] dev_gro_receive
     6.78%  [kernel]       [k] memcpy
     6.53%  [kernel]       [k] skb_release_data
     6.39%  [kernel]       [k] tcp_gro_receive
     5.71%  [kernel]       [k] ipv6_gro_receive
     4.35%  [kernel]       [k] napi_gro_frags
     4.34%  [kernel]       [k] skb_gro_receive
     3.50%  [kernel]       [k] gq_pool_get
     3.08%  [kernel]       [k] gq_rx_napi_handler
     2.35%  [kernel]       [k] tcp6_gro_receive
     2.06%  [kernel]       [k] gq_rx_prep_buffers
     1.32%  [kernel]       [k] csum_partial
     0.93%  [kernel]       [k] csum_ipv6_magic
     0.65%  [kernel]       [k] net_rx_action

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev
---
 drivers/iommu/dma-iommu.c | 67 +++++++++++++++++++++++++++------------
 1 file changed, 47 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 9297b741f5e80e2408e864fc3f779410d6b04d49..976ba20a55eab5fd94e9bec2d38a2a60e0690444 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -522,6 +522,11 @@ static bool dev_use_swiotlb(struct device *dev)
 	return IS_ENABLED(CONFIG_SWIOTLB) && dev_is_untrusted(dev);
 }
 
+static bool dev_is_dma_sync_needed(struct device *dev)
+{
+	return !dev_is_dma_coherent(dev) || dev_use_swiotlb(dev);
+}
+
 /**
  * iommu_dma_init_domain - Initialise a DMA mapping domain
  * @domain: IOMMU domain previously prepared by iommu_get_dma_cookie()
@@ -914,7 +919,7 @@ static void iommu_dma_sync_single_for_cpu(struct device *dev,
 {
 	phys_addr_t phys;
 
-	if (dev_is_dma_coherent(dev) && !dev_use_swiotlb(dev))
+	if (!dev_is_dma_sync_needed(dev))
 		return;
 
 	phys = iommu_iova_to_phys(iommu_get_dma_domain(dev), dma_handle);
@@ -930,7 +935,7 @@ static void iommu_dma_sync_single_for_device(struct device *dev,
 {
 	phys_addr_t phys;
 
-	if (dev_is_dma_coherent(dev) && !dev_use_swiotlb(dev))
+	if (!dev_is_dma_sync_needed(dev))
 		return;
 
 	phys = iommu_iova_to_phys(iommu_get_dma_domain(dev), dma_handle);
@@ -1544,30 +1549,51 @@ static size_t iommu_dma_opt_mapping_size(void)
 	return iova_rcache_range();
 }
 
+#define iommu_dma_ops_common_fields \
+	.flags			= DMA_F_PCI_P2PDMA_SUPPORTED,		\
+	.alloc			= iommu_dma_alloc,			\
+	.free			= iommu_dma_free,			\
+	.alloc_pages		= dma_common_alloc_pages,		\
+	.free_pages		= dma_common_free_pages,		\
+	.alloc_noncontiguous	= iommu_dma_alloc_noncontiguous,	\
+	.free_noncontiguous	= iommu_dma_free_noncontiguous,		\
+	.mmap			= iommu_dma_mmap,			\
+	.get_sgtable		= iommu_dma_get_sgtable,		\
+	.map_page		= iommu_dma_map_page,			\
+	.unmap_page		= iommu_dma_unmap_page,			\
+	.map_sg			= iommu_dma_map_sg,			\
+	.unmap_sg		= iommu_dma_unmap_sg,			\
+	.map_resource		= iommu_dma_map_resource,		\
+	.unmap_resource		= iommu_dma_unmap_resource,		\
+	.get_merge_boundary	= iommu_dma_get_merge_boundary,		\
+	.opt_mapping_size	= iommu_dma_opt_mapping_size,
+
 static const struct dma_map_ops iommu_dma_ops = {
-	.flags			= DMA_F_PCI_P2PDMA_SUPPORTED,
-	.alloc			= iommu_dma_alloc,
-	.free			= iommu_dma_free,
-	.alloc_pages		= dma_common_alloc_pages,
-	.free_pages		= dma_common_free_pages,
-	.alloc_noncontiguous	= iommu_dma_alloc_noncontiguous,
-	.free_noncontiguous	= iommu_dma_free_noncontiguous,
-	.mmap			= iommu_dma_mmap,
-	.get_sgtable		= iommu_dma_get_sgtable,
-	.map_page		= iommu_dma_map_page,
-	.unmap_page		= iommu_dma_unmap_page,
-	.map_sg			= iommu_dma_map_sg,
-	.unmap_sg		= iommu_dma_unmap_sg,
+	iommu_dma_ops_common_fields
+
 	.sync_single_for_cpu	= iommu_dma_sync_single_for_cpu,
 	.sync_single_for_device	= iommu_dma_sync_single_for_device,
 	.sync_sg_for_cpu	= iommu_dma_sync_sg_for_cpu,
 	.sync_sg_for_device	= iommu_dma_sync_sg_for_device,
-	.map_resource		= iommu_dma_map_resource,
-	.unmap_resource		= iommu_dma_unmap_resource,
-	.get_merge_boundary	= iommu_dma_get_merge_boundary,
-	.opt_mapping_size	= iommu_dma_opt_mapping_size,
 };
 
+/* Special instance of iommu_dma_ops for devices satisfying this condition:
+ *   !dev_is_dma_sync_needed(dev)
+ *
+ * iommu_dma_sync_single_for_cpu(), iommu_dma_sync_single_for_device(),
+ * iommu_dma_sync_sg_for_cpu(), iommu_dma_sync_sg_for_device()
+ * do nothing special and can be avoided, saving indirect calls.
+ */
+static const struct dma_map_ops iommu_nosync_dma_ops = {
+	iommu_dma_ops_common_fields
+
+	.sync_single_for_cpu	= NULL,
+	.sync_single_for_device	= NULL,
+	.sync_sg_for_cpu	= NULL,
+	.sync_sg_for_device	= NULL,
+};
+#undef iommu_dma_ops_common_fields
+
 /*
  * The IOMMU core code allocates the default DMA domain, which the underlying
  * IOMMU driver needs to support via the dma-iommu layer.
@@ -1586,7 +1612,8 @@ void iommu_setup_dma_ops(struct device *dev, u64 dma_base, u64 dma_limit)
 	if (iommu_is_dma_domain(domain)) {
 		if (iommu_dma_init_domain(domain, dma_base, dma_limit, dev))
 			goto out_err;
-		dev->dma_ops = &iommu_dma_ops;
+		dev->dma_ops = dev_is_dma_sync_needed(dev) ?
+				&iommu_dma_ops : &iommu_nosync_dma_ops;
 	}
 
 	return;
-- 
2.38.1.431.g37b22c650d-goog

