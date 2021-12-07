Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F53A46B4D6
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 08:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbhLGH7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 02:59:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbhLGH7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 02:59:36 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3948C061746;
        Mon,  6 Dec 2021 23:56:06 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so1284553pju.3;
        Mon, 06 Dec 2021 23:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wues2SqUPRv0oUKBbTR72tAwqhwqv49+w2re/gGhWqk=;
        b=VzFoel0/LWV3DyB2U5cKuuZq56n4dtPVhA17gu/s9cirmMiPeNbbKOHmB8lybRsSAu
         lTVYf9+JMis4a6vEtmkR/tGT0Ljpa7plWV8c72tQlJ7NB2EePk3FMBj80o0VcopGdXiI
         yPsKdQqdLSLvf+F3uOaRnCR8bvl/0fvb7Gd3lQ+mqnP8lsouy9XxAInoOEWVk/3YicfF
         ReTPT0RlOAjPdbS0sSz8fsunpv63jm0aeUdPlJKgcMdMDoY9ELQ3VT+bfqEwuKAHcpym
         l4UqUHQAeJ307gS28KWcLcrpsldNxHyTcWTLfggDoqEzP8TOPo777l5Ot1HuG6gKdb5v
         rzRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wues2SqUPRv0oUKBbTR72tAwqhwqv49+w2re/gGhWqk=;
        b=U+mkbdGC87fz2rKpq0pDw5UJ7u3+RzA3vb98AaB5ZjomxKoKuxkNHS/bII5YTTpB/M
         d1GISzjiQDjshTxP631+/Nijs2YBp/g4tzRFaTSCeKues9/xy01Jqvqt9VbnGsONa1fz
         WKolQcoiwN0KVpkgzFxrIFZ2ydFVSsaEENZ1/DrnZOG5yzghGdVHM5hdtuQHbvJLAlJq
         fbZSP1g6aFNRB+o8S/ZeCWj/m2jcRLtmvVBp5AvfNIBbZJQWs3r11DhdAKEY9TMEtd9F
         w/pH+15FhDcH6U8Byxt1g4HPIknK+SUXAvEBZ4nx/PXWySsDRF4ehC+Nm+fh0GRD+u8X
         MqkA==
X-Gm-Message-State: AOAM530a208A8yb0a82vd6Nk6IHQmBVG935vVdZanlMlWG/CkAJh3sL/
        +uQCDgPCEQcM5tqmls6UYNw=
X-Google-Smtp-Source: ABdhPJzN6ZI9xL6N2pZS3EvOqzvOjO+/bRn3T6NyagLoQlAO68ny0t6GkgOC7NfimzQqthS3/5yAew==
X-Received: by 2002:a17:90a:e613:: with SMTP id j19mr4812156pjy.182.1638863766484;
        Mon, 06 Dec 2021 23:56:06 -0800 (PST)
Received: from ubuntu-Virtual-Machine.corp.microsoft.com ([2001:4898:80e8:0:a463:d753:723:c3a9])
        by smtp.gmail.com with ESMTPSA id n15sm1794353pgs.59.2021.12.06.23.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 23:56:06 -0800 (PST)
From:   Tianyu Lan <ltykernel@gmail.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        arnd@arndb.de, hch@infradead.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: [PATCH V6 1/5] swiotlb: Add swiotlb bounce buffer remap function for HV IVM
Date:   Tue,  7 Dec 2021 02:55:57 -0500
Message-Id: <20211207075602.2452-2-ltykernel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211207075602.2452-1-ltykernel@gmail.com>
References: <20211207075602.2452-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

In Isolation VM with AMD SEV, bounce buffer needs to be accessed via
extra address space which is above shared_gpa_boundary (E.G 39 bit
address line) reported by Hyper-V CPUID ISOLATION_CONFIG. The access
physical address will be original physical address + shared_gpa_boundary.
The shared_gpa_boundary in the AMD SEV SNP spec is called virtual top of
memory(vTOM). Memory addresses below vTOM are automatically treated as
private while memory above vTOM is treated as shared.

Expose swiotlb_unencrypted_base for platforms to set unencrypted
memory base offset and platform calls swiotlb_update_mem_attributes()
to remap swiotlb mem to unencrypted address space. memremap() can
not be called in the early stage and so put remapping code into
swiotlb_update_mem_attributes(). Store remap address and use it to copy
data from/to swiotlb bounce buffer.

Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
Change since v3:
	* Fix boot up failure on the host with mem_encrypt=on.
	  Move calloing of set_memory_decrypted() back from
	  swiotlb_init_io_tlb_mem to swiotlb_late_init_with_tbl()
	  and rmem_swiotlb_device_init().

Change since v2:
	* Leave mem->vaddr with phys_to_virt(mem->start) when fail
	  to remap swiotlb memory.

Change since v1:
	* Rework comment in the swiotlb_init_io_tlb_mem()
	* Make swiotlb_init_io_tlb_mem() back to return void.
---
 include/linux/swiotlb.h |  6 ++++++
 kernel/dma/swiotlb.c    | 43 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 569272871375..f6c3638255d5 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -73,6 +73,9 @@ extern enum swiotlb_force swiotlb_force;
  * @end:	The end address of the swiotlb memory pool. Used to do a quick
  *		range check to see if the memory was in fact allocated by this
  *		API.
+ * @vaddr:	The vaddr of the swiotlb memory pool. The swiotlb memory pool
+ *		may be remapped in the memory encrypted case and store virtual
+ *		address for bounce buffer operation.
  * @nslabs:	The number of IO TLB blocks (in groups of 64) between @start and
  *		@end. For default swiotlb, this is command line adjustable via
  *		setup_io_tlb_npages.
@@ -92,6 +95,7 @@ extern enum swiotlb_force swiotlb_force;
 struct io_tlb_mem {
 	phys_addr_t start;
 	phys_addr_t end;
+	void *vaddr;
 	unsigned long nslabs;
 	unsigned long used;
 	unsigned int index;
@@ -186,4 +190,6 @@ static inline bool is_swiotlb_for_alloc(struct device *dev)
 }
 #endif /* CONFIG_DMA_RESTRICTED_POOL */
 
+extern phys_addr_t swiotlb_unencrypted_base;
+
 #endif /* __LINUX_SWIOTLB_H */
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 8e840fbbed7c..34e6ade4f73c 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -50,6 +50,7 @@
 #include <asm/io.h>
 #include <asm/dma.h>
 
+#include <linux/io.h>
 #include <linux/init.h>
 #include <linux/memblock.h>
 #include <linux/iommu-helper.h>
@@ -72,6 +73,8 @@ enum swiotlb_force swiotlb_force;
 
 struct io_tlb_mem io_tlb_default_mem;
 
+phys_addr_t swiotlb_unencrypted_base;
+
 /*
  * Max segment that we can provide which (if pages are contingous) will
  * not be bounced (unless SWIOTLB_FORCE is set).
@@ -155,6 +158,27 @@ static inline unsigned long nr_slots(u64 val)
 	return DIV_ROUND_UP(val, IO_TLB_SIZE);
 }
 
+/*
+ * Remap swioltb memory in the unencrypted physical address space
+ * when swiotlb_unencrypted_base is set. (e.g. for Hyper-V AMD SEV-SNP
+ * Isolation VMs).
+ */
+void *swiotlb_mem_remap(struct io_tlb_mem *mem, unsigned long bytes)
+{
+	void *vaddr = NULL;
+
+	if (swiotlb_unencrypted_base) {
+		phys_addr_t paddr = mem->start + swiotlb_unencrypted_base;
+
+		vaddr = memremap(paddr, bytes, MEMREMAP_WB);
+		if (!vaddr)
+			pr_err("Failed to map the unencrypted memory %llx size %lx.\n",
+			       paddr, bytes);
+	}
+
+	return vaddr;
+}
+
 /*
  * Early SWIOTLB allocation may be too early to allow an architecture to
  * perform the desired operations.  This function allows the architecture to
@@ -172,7 +196,12 @@ void __init swiotlb_update_mem_attributes(void)
 	vaddr = phys_to_virt(mem->start);
 	bytes = PAGE_ALIGN(mem->nslabs << IO_TLB_SHIFT);
 	set_memory_decrypted((unsigned long)vaddr, bytes >> PAGE_SHIFT);
-	memset(vaddr, 0, bytes);
+
+	mem->vaddr = swiotlb_mem_remap(mem, bytes);
+	if (!mem->vaddr)
+		mem->vaddr = vaddr;
+
+	memset(mem->vaddr, 0, bytes);
 }
 
 static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
@@ -196,7 +225,17 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
 		mem->slots[i].orig_addr = INVALID_PHYS_ADDR;
 		mem->slots[i].alloc_size = 0;
 	}
+
+	/*
+	 * If swiotlb_unencrypted_base is set, the bounce buffer memory will
+	 * be remapped and cleared in swiotlb_update_mem_attributes.
+	 */
+	if (swiotlb_unencrypted_base)
+		return;
+
 	memset(vaddr, 0, bytes);
+	mem->vaddr = vaddr;
+	return;
 }
 
 int __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
@@ -371,7 +410,7 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
 	phys_addr_t orig_addr = mem->slots[index].orig_addr;
 	size_t alloc_size = mem->slots[index].alloc_size;
 	unsigned long pfn = PFN_DOWN(orig_addr);
-	unsigned char *vaddr = phys_to_virt(tlb_addr);
+	unsigned char *vaddr = mem->vaddr + tlb_addr - mem->start;
 	unsigned int tlb_offset, orig_addr_offset;
 
 	if (orig_addr == INVALID_PHYS_ADDR)
-- 
2.25.1

