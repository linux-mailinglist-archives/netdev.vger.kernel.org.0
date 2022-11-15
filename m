Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F304262A14D
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 19:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbiKOS25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 13:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiKOS2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 13:28:45 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F95D11F
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 10:28:44 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id fz10-20020a05622a5a8a00b003a4f466998cso10908081qtb.16
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 10:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SoUmPkHlkDH+7nhAOWIZ0SCq+4Ebj+CALgmJJRMTdeg=;
        b=eANR3/+r4/MRfVqHI/utl+NkZlPzevU1TGEEysolV5xO3wHm28FQqXZ3yK+tishuev
         FEdyAzazOUwFaX/ieAkinArTmqoCzRPkfskS+jTQLD1MSouu/OMU9BXEUA/pPut5/7Rb
         8fn99JhkQp5ZK/xXjV8842yEKstiUq2qleGkkoi+kBxNAuyXfOsquk6c5zVgEI4fEAjS
         r9IEjLOtF7ByxDK7FTHiPiPVlT5Bn+FBXA5Vt40vGwdOeNFIQOVIcJN/BhQnjV17zKvA
         cio68NUuIMMwMyvC7DbTShTMKa17vFn4vCPsfivXCRG8D7S3llUgVfR+CFMQNZnAf48h
         F08Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SoUmPkHlkDH+7nhAOWIZ0SCq+4Ebj+CALgmJJRMTdeg=;
        b=SlQua6zzz3cO7AjTMFBGE9vqzPopHqvUhqZhyzL9XQwMy+rsEHlNZFYyynYTD/IOHs
         KyEUTwLfcc6s25hR4AHBx67crYH2nZOdpCKC9vLr3z8zxBcx/9x/nrnVA9dcy91sOwvo
         bhSQKVDQPyHJpwPt+D+C62+xaUbgzzqr+5fFU7Y/u0aIfVC5bHpXhgFrQJS0uGJZvYkV
         XyLaxMTSvrtiBpsUWc0OiLlE0DOVCEDlkHIRqGoD1t+m0ANvXtTcj/PsZS8/JpSKHAvY
         XgUWhYhBqkE3Oeti+yNkMOQlPfLSaTeLjww5Nz3LAZJhyfm42fMB5zYplXh87O2Jt7Od
         /UNQ==
X-Gm-Message-State: ANoB5pkfdtyqsBswaSDypOEoMZhboh1nAeyJZ2sKZCHsZxdiC8Jb1qN2
        HUVNdrPEUolSuwhr+083pPq+y6NTrzZJHw==
X-Google-Smtp-Source: AA0mqf5m9Y9Hm6Nw/W5UoBKliGXP3uUoOBJcWlloA4j+N/XrgbIVcd0oc03Z6IzUgCXGvi39AAJLJagsngRr5A==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:ac8:7502:0:b0:3a5:7e65:ddeb with SMTP id
 u2-20020ac87502000000b003a57e65ddebmr17287503qtq.424.1668536923808; Tue, 15
 Nov 2022 10:28:43 -0800 (PST)
Date:   Tue, 15 Nov 2022 18:28:41 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115182841.2640176-1-edumazet@google.com>
Subject: [PATCH v2 -next] iommu/dma: avoid expensive indirect calls for sync operations
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

This patch adds dev->skip_dma_sync boolean that can be opted-in.

For instance iommu_setup_dma_ops() can set this boolean to true
if CONFIG_DMA_API_DEBUG is not set, and dev_is_dma_coherent(dev).

Then later, if/when swiotlb is used for the first time, the flag
is turned off, from swiotlb_tbl_map_single()

We might in the future inline again these helpers, like:

static void inline
dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr,
			size_t size, enum dma_data_direction dir)
{
	if (!dev_skip_dma_sync(dev))
		__dma_sync_single_for_cpu(dev, addr, size, dir);
}

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

Many thanks to Robin Murphy for his feedback and ideas to make this patch
much better !

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev
---
 drivers/iommu/dma-iommu.c   |  2 ++
 include/linux/device.h      |  1 +
 include/linux/dma-map-ops.h |  5 +++++
 kernel/dma/mapping.c        | 20 ++++++++++++++++----
 kernel/dma/swiotlb.c        |  3 +++
 5 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 9297b741f5e80e2408e864fc3f779410d6b04d49..bd3f4d3d646cc57c7588f22d49ea32ac693e38ff 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1587,6 +1587,8 @@ void iommu_setup_dma_ops(struct device *dev, u64 dma_base, u64 dma_limit)
 		if (iommu_dma_init_domain(domain, dma_base, dma_limit, dev))
 			goto out_err;
 		dev->dma_ops = &iommu_dma_ops;
+		if (!IS_ENABLED(CONFIG_DMA_API_DEBUG) && dev_is_dma_coherent(dev))
+			dev->skip_dma_sync = true;
 	}
 
 	return;
diff --git a/include/linux/device.h b/include/linux/device.h
index 424b55df02727b5742070f72374fd65f5dd68151..2fbb2cc18e44e21eba5f43557ee16d0dc92ef2ef 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -647,6 +647,7 @@ struct device {
     defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL)
 	bool			dma_coherent:1;
 #endif
+	bool			skip_dma_sync:1;
 #ifdef CONFIG_DMA_OPS_BYPASS
 	bool			dma_ops_bypass : 1;
 #endif
diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index d678afeb8a13a3a54380a959d14f79bca9c23d8e..4691081f71c51da5468cf6703570ebc7a64d40c5 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -275,6 +275,11 @@ static inline bool dev_is_dma_coherent(struct device *dev)
 }
 #endif /* CONFIG_ARCH_HAS_DMA_COHERENCE_H */
 
+static inline bool dev_skip_dma_sync(struct device *dev)
+{
+	return dev->skip_dma_sync;
+}
+
 void *arch_dma_alloc(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		gfp_t gfp, unsigned long attrs);
 void arch_dma_free(struct device *dev, size_t size, void *cpu_addr,
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 33437d6206445812b6d4d5b33c77235d18074dec..5d5d286ffae7fa6b7ff1aef46bdc59e7e31a8038 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -328,9 +328,12 @@ EXPORT_SYMBOL(dma_unmap_resource);
 void dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr, size_t size,
 		enum dma_data_direction dir)
 {
-	const struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops;
 
 	BUG_ON(!valid_dma_direction(dir));
+	if (dev_skip_dma_sync(dev))
+		return;
+	ops = get_dma_ops(dev);;
 	if (dma_map_direct(dev, ops))
 		dma_direct_sync_single_for_cpu(dev, addr, size, dir);
 	else if (ops->sync_single_for_cpu)
@@ -342,9 +345,12 @@ EXPORT_SYMBOL(dma_sync_single_for_cpu);
 void dma_sync_single_for_device(struct device *dev, dma_addr_t addr,
 		size_t size, enum dma_data_direction dir)
 {
-	const struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops;
 
 	BUG_ON(!valid_dma_direction(dir));
+	if (dev_skip_dma_sync(dev))
+		return;
+	ops = get_dma_ops(dev);;
 	if (dma_map_direct(dev, ops))
 		dma_direct_sync_single_for_device(dev, addr, size, dir);
 	else if (ops->sync_single_for_device)
@@ -356,9 +362,12 @@ EXPORT_SYMBOL(dma_sync_single_for_device);
 void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 		    int nelems, enum dma_data_direction dir)
 {
-	const struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops;
 
 	BUG_ON(!valid_dma_direction(dir));
+	if (dev_skip_dma_sync(dev))
+		return;
+	ops = get_dma_ops(dev);;
 	if (dma_map_direct(dev, ops))
 		dma_direct_sync_sg_for_cpu(dev, sg, nelems, dir);
 	else if (ops->sync_sg_for_cpu)
@@ -370,9 +379,12 @@ EXPORT_SYMBOL(dma_sync_sg_for_cpu);
 void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 		       int nelems, enum dma_data_direction dir)
 {
-	const struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops;
 
 	BUG_ON(!valid_dma_direction(dir));
+	if (dev_skip_dma_sync(dev))
+		return;
+	ops = get_dma_ops(dev);;
 	if (dma_map_direct(dev, ops))
 		dma_direct_sync_sg_for_device(dev, sg, nelems, dir);
 	else if (ops->sync_sg_for_device)
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 339a990554e7fed98dd337efe4fb759a98161cdb..03ebd9803db1a457600f1fac8a18fb3dde724a6f 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -734,6 +734,9 @@ phys_addr_t swiotlb_tbl_map_single(struct device *dev, phys_addr_t orig_addr,
 	int index;
 	phys_addr_t tlb_addr;
 
+	if (unlikely(dev->skip_dma_sync))
+		dev->skip_dma_sync = false;
+
 	if (!mem || !mem->nslabs) {
 		dev_warn_ratelimited(dev,
 			"Can not allocate SWIOTLB buffer earlier and can't now provide you with the DMA bounce buffer");
-- 
2.38.1.431.g37b22c650d-goog

