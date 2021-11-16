Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F77453606
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 16:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238418AbhKPPmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 10:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238383AbhKPPmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 10:42:33 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3E9C061764;
        Tue, 16 Nov 2021 07:39:36 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id h63so11062797pgc.12;
        Tue, 16 Nov 2021 07:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QpP/dVmOy5UI+0bbwin5PnSriAWO01VAYDyEmLKe5Fk=;
        b=SXiaG54grF6wqI5IHlO5fiT6D7ch6iSGwaSfj5F99m+GDLZKF1xq7PpdqZEGQJ2hss
         Mb2HUUEo0PbfBMirBDv6g4oprtzEt8f1KyqLwPFPHMe2qW5PRdHVfXPbxYa6dQcdLZ0U
         ih6mD3K1UTLAsmNZoFe2aO5HLz3zUaoC7GZhMz7o/9lEWJCSZfN2h2eZv1+d/CFeR7kG
         VCd4AjKJvzx8+FYzrSsfSrwbytPrb+YrlivIqNsckIs/ARb8aGx366blyrHUFlVj3W6J
         DNqULX9ETBqHxrFFpaBrQrQujnGUK1fF5SlWwlmILpygaE6keMWPQcnYgsnTLFjuQtfA
         3OYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QpP/dVmOy5UI+0bbwin5PnSriAWO01VAYDyEmLKe5Fk=;
        b=wAfRCdU6a7tBqPGsEL2J0TOuoURhWLTZJUwtCAzl/huGVwTpphMZJr83s1UUw1EMy6
         w5rbR/kDfTy/xXhqTgAIKxp7hbYkfrF+fJlqlMatlTQjmK9YKBCFOlBA8iQmbYK63CA7
         dBxGIY2Hgc+UkcCyAZHSLZpuHzu+nV42bB7t7l4kz+cD+sV/aHeq8xZyQBQwhRVM7NUN
         +6pGEDIqNncbqrYh9mCKSNXV4Vh6PJDDCKTUSytRKStVs/+BrSHui5ctu4wZr/MdJOS+
         2+Lhyj51EbLKyyxZtyy93N6tk+o1ziLupgCWya1HPmTuTSHquMKrsESCLnJe/6rSqNJ/
         fUiA==
X-Gm-Message-State: AOAM5301GsndOYThgn74jXywdBdQ7WhancCpqC2DW7Y9ZrJnAASM5Vke
        +fE0J2W32yIubxNlpBGAdCg=
X-Google-Smtp-Source: ABdhPJylKbp6Y35YNN+QuL8Z6jQM03hSsaNsmPApoiu7+PqjtqafYcV6ZofENONej65wNPzRZ+fN4Q==
X-Received: by 2002:a63:1b5e:: with SMTP id b30mr5271860pgm.72.1637077176375;
        Tue, 16 Nov 2021 07:39:36 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:3:57e4:b776:c854:76dd])
        by smtp.gmail.com with ESMTPSA id x64sm1981948pfd.151.2021.11.16.07.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 07:39:35 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, jgross@suse.com, sstabellini@kernel.org,
        boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        konrad.wilk@oracle.com, parri.andrea@gmail.com,
        thomas.lendacky@amd.com, dave.hansen@intel.com
Subject: [PATCH 2/5] dma-mapping: Add vmap/vunmap_noncontiguous() callback in dma ops
Date:   Tue, 16 Nov 2021 10:39:20 -0500
Message-Id: <20211116153923.196763-3-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116153923.196763-1-ltykernel@gmail.com>
References: <20211116153923.196763-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

Hyper-V netvsc driver needs to allocate noncontiguous DMA memory and
remap it into unencrypted address space before sharing with host. Add
vmap/vunmap_noncontiguous() callback and handle the remap in the Hyper-V
dma ops callback.

Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 include/linux/dma-map-ops.h |  3 +++
 kernel/dma/mapping.c        | 18 ++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 0d5b06b3a4a6..f7b9958ca20a 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -27,6 +27,9 @@ struct dma_map_ops {
 			unsigned long attrs);
 	void (*free_noncontiguous)(struct device *dev, size_t size,
 			struct sg_table *sgt, enum dma_data_direction dir);
+	void *(*vmap_noncontiguous)(struct device *dev, size_t size,
+			struct sg_table *sgt);
+	void (*vunmap_noncontiguous)(struct device *dev, void *addr);
 	int (*mmap)(struct device *, struct vm_area_struct *,
 			void *, dma_addr_t, size_t, unsigned long attrs);
 
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 9478eccd1c8e..7fd751d866cc 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -674,8 +674,14 @@ void *dma_vmap_noncontiguous(struct device *dev, size_t size,
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 	unsigned long count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
-	if (ops && ops->alloc_noncontiguous)
-		return vmap(sgt_handle(sgt)->pages, count, VM_MAP, PAGE_KERNEL);
+	if (ops) {
+		if (ops->vmap_noncontiguous)
+			return ops->vmap_noncontiguous(dev, size, sgt);
+		else if (ops->alloc_noncontiguous)
+			return vmap(sgt_handle(sgt)->pages, count, VM_MAP,
+				    PAGE_KERNEL);
+	}
+
 	return page_address(sg_page(sgt->sgl));
 }
 EXPORT_SYMBOL_GPL(dma_vmap_noncontiguous);
@@ -684,8 +690,12 @@ void dma_vunmap_noncontiguous(struct device *dev, void *vaddr)
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 
-	if (ops && ops->alloc_noncontiguous)
-		vunmap(vaddr);
+	if (ops) {
+		if (ops->vunmap_noncontiguous)
+			ops->vunmap_noncontiguous(dev, vaddr);
+		else if (ops->alloc_noncontiguous)
+			vunmap(vaddr);
+	}
 }
 EXPORT_SYMBOL_GPL(dma_vunmap_noncontiguous);
 
-- 
2.25.1

