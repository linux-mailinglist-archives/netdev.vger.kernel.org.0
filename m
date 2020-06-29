Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5BD20D47F
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730880AbgF2TIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730507AbgF2TCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:02:42 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE5DC02A553;
        Mon, 29 Jun 2020 06:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=PsN3qRjrSOLsKgEY3b9oohxHLZWrJFcsvZsnix+thqM=; b=aJrw9aNzBqPIJz75MBYlfnCGSr
        ToiXcesL50+YEb9Ecs4HWaP59LlBbTh8rBnY1rZxyrNZzJl7uQufB9JBBjqGU4iZM1Pez3hKqdgBW
        +UopSMXHKslG7KrOMT9vokf0Q7L4gsUQ14apX0DqwBud4wWRakM9z4vfTtPoBqPcYah1ba9HLCDnh
        85O4HVeR+n+y/ihCRcqxQvqex0BWz/+LxlZ3uJMnA8QZo4lX0UsTuL4NrLOziPv9MWa1wAMY2kQF4
        9ZTsjYCnH5pgJdEw+FUCDMRXANsZufwUUpeEx+foby4/7Cl669c8FJ4DZ+71gaCzwF5MEBbmDxswR
        8JRlJpWQ==;
Received: from [2001:4bb8:184:76e3:c71:f334:376b:cf5f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jptS7-0004XB-2A; Mon, 29 Jun 2020 13:04:03 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] dma-mapping: add a new dma_need_sync API
Date:   Mon, 29 Jun 2020 15:03:56 +0200
Message-Id: <20200629130359.2690853-2-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200629130359.2690853-1-hch@lst.de>
References: <20200629130359.2690853-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new API to check if calls to dma_sync_single_for_{device,cpu} are
required for a given DMA streaming mapping.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/core-api/dma-api.rst |  8 ++++++++
 include/linux/dma-direct.h         |  1 +
 include/linux/dma-mapping.h        |  5 +++++
 kernel/dma/direct.c                |  6 ++++++
 kernel/dma/mapping.c               | 10 ++++++++++
 5 files changed, 30 insertions(+)

diff --git a/Documentation/core-api/dma-api.rst b/Documentation/core-api/dma-api.rst
index 2d8d2fed731720..f41620439ef349 100644
--- a/Documentation/core-api/dma-api.rst
+++ b/Documentation/core-api/dma-api.rst
@@ -204,6 +204,14 @@ Returns the maximum size of a mapping for the device. The size parameter
 of the mapping functions like dma_map_single(), dma_map_page() and
 others should not be larger than the returned value.
 
+::
+
+	bool
+	dma_need_sync(struct device *dev, dma_addr_t dma_addr);
+
+Returns %true if dma_sync_single_for_{device,cpu} calls are required to
+transfer memory ownership.  Returns %false if those calls can be skipped.
+
 ::
 
 	unsigned long
diff --git a/include/linux/dma-direct.h b/include/linux/dma-direct.h
index cdfa400f89b3d3..5184735a0fe8eb 100644
--- a/include/linux/dma-direct.h
+++ b/include/linux/dma-direct.h
@@ -85,4 +85,5 @@ int dma_direct_mmap(struct device *dev, struct vm_area_struct *vma,
 		void *cpu_addr, dma_addr_t dma_addr, size_t size,
 		unsigned long attrs);
 int dma_direct_supported(struct device *dev, u64 mask);
+bool dma_direct_need_sync(struct device *dev, dma_addr_t dma_addr);
 #endif /* _LINUX_DMA_DIRECT_H */
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 78f677cf45ab69..a33ed3954ed465 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -461,6 +461,7 @@ int dma_set_mask(struct device *dev, u64 mask);
 int dma_set_coherent_mask(struct device *dev, u64 mask);
 u64 dma_get_required_mask(struct device *dev);
 size_t dma_max_mapping_size(struct device *dev);
+bool dma_need_sync(struct device *dev, dma_addr_t dma_addr);
 unsigned long dma_get_merge_boundary(struct device *dev);
 #else /* CONFIG_HAS_DMA */
 static inline dma_addr_t dma_map_page_attrs(struct device *dev,
@@ -571,6 +572,10 @@ static inline size_t dma_max_mapping_size(struct device *dev)
 {
 	return 0;
 }
+static inline bool dma_need_sync(struct device *dev, dma_addr_t dma_addr)
+{
+	return false;
+}
 static inline unsigned long dma_get_merge_boundary(struct device *dev)
 {
 	return 0;
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 93f578a8e613ba..95866b64758100 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -539,3 +539,9 @@ size_t dma_direct_max_mapping_size(struct device *dev)
 		return swiotlb_max_mapping_size(dev);
 	return SIZE_MAX;
 }
+
+bool dma_direct_need_sync(struct device *dev, dma_addr_t dma_addr)
+{
+	return !dev_is_dma_coherent(dev) ||
+		is_swiotlb_buffer(dma_to_phys(dev, dma_addr));
+}
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 98e3d873792ea4..a8c18c9a796fdc 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -397,6 +397,16 @@ size_t dma_max_mapping_size(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(dma_max_mapping_size);
 
+bool dma_need_sync(struct device *dev, dma_addr_t dma_addr)
+{
+	const struct dma_map_ops *ops = get_dma_ops(dev);
+
+	if (dma_is_direct(ops))
+		return dma_direct_need_sync(dev, dma_addr);
+	return ops->sync_single_for_cpu || ops->sync_single_for_device;
+}
+EXPORT_SYMBOL_GPL(dma_need_sync);
+
 unsigned long dma_get_merge_boundary(struct device *dev)
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
-- 
2.26.2

