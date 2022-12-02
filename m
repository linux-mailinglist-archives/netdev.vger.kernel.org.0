Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0140D63FEF9
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 04:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbiLBDd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 22:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbiLBDdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 22:33:16 -0500
Received: from CY4PR02CU007-vft-obe.outbound.protection.outlook.com (mail-westcentralusazon11021023.outbound.protection.outlook.com [40.93.199.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA06DC4D0;
        Thu,  1 Dec 2022 19:32:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OQCQYTMHdofX6Kl3RwIwSauRwugomKAC7E67IENsRaXY6esYNewI17STcv1Act4t4BWqJ22zc/DC03py7OYPGPuTQkiiO/eC4sHMU0rnrCzqQ8Rbaf/bMeMFI1/QklsgVITi+n+USYo1vAK5HdYxpRsW5bBkmSUclV07UFZTN/Gkz4VsHr6/rC8ejAgWCzVwUSkpoPp83hvx4iLYFqYJp3eQmMoyCBKmiPe3Z+7giR+VVwFJHz6nhcpvOiZ6WhiCgNXJWQmH6k0G53d8Vxsmu3mC+OGdIMDF3s2NDW5f5g8sJ4yyc8lb9akaxbtIShDQdzdXxLQZ61mwpMw61fZX9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rS+XEDLCYXK3kG0pGvcV2b4OXTcv8/63SxxK34hw9ig=;
 b=fVSJMSwNKi6X0wFvmWqTlltgnuzo6wOFy0oZzDVbnvAhrSSRtJYpTkGASc3C64mpBl4O1nctJiFBVTkM6/FI7i1+fVhjwV8l9cYNr9Vk7MTY9ECYK86p3pI/2+z3ifMghoh+YhAI96iipi5Tv2BsgfcZRgDH/c02qcMflhdcuB6C5RSNXLbTm+acBYvRQkgvuO0jT7o7jwWz0qbZaLgeWrTy24ddkM/XDCPuvCIcjqt2hi0AVQf0XZLXNciCmAlP67/Szw7tppG2b+Tdh0YS9ZumXcTxx0gZF5jn7cWR+/wtcfebU+CFjb1bpFlsHpMmguum22pouEOnTuC5Fbrhfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rS+XEDLCYXK3kG0pGvcV2b4OXTcv8/63SxxK34hw9ig=;
 b=O16sotbRg4k3nM11+wkbrkLhgY1EzMRL/4PiclV0C3Sia2+FD+XdnWAYZbNE6oFhjUySiyz3uUej/l7hVwB871ilAIa8R1Mc3xatJjWP/lF+5GIe+vkPLTgyMsQ792WbJ/Bx9fM2lfAcxFPzFl7w81lWX7iGYU0AjFRzansjtsE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1316.namprd21.prod.outlook.com (2603:10b6:208:92::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.8; Fri, 2 Dec
 2022 03:32:18 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5901.008; Fri, 2 Dec 2022
 03:32:18 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lpieralisi@kernel.org,
        robh@kernel.org, kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, seanjc@google.com, tony.luck@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
Cc:     mikelley@microsoft.com
Subject: [Patch v4 07/13] swiotlb: Remove bounce buffer remapping for Hyper-V
Date:   Thu,  1 Dec 2022 19:30:25 -0800
Message-Id: <1669951831-4180-8-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
References: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0234.namprd04.prod.outlook.com
 (2603:10b6:303:87::29) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|BL0PR2101MB1316:EE_
X-MS-Office365-Filtering-Correlation-Id: 7927bf86-f1b6-4679-089d-08dad415d02f
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w9MsoS3wimC9jm/xwiRfi3EHesfJMxTdePz9btR5h7V9ZeLCoJaEhO/rK98J39e6fd1KmRF80KruYQIpy28J+4DhjUDzLmLYyfiuWN9N0DpjybmAWHQMSm1KF5saTlP9fAT9LaDJSYP2yJiDiFGnLZwYuXFvaXYfRvSes+kZlGgu7Jsvdtaz8iA7yMWc5C8gElvXeeQPoOoqOGz9yxTfFoCKNmcMAVtvgjicBqF0qmNfjnQgUyCIzUmuUZT+V3oSCLUz181NpxbP6XjdjV8EtZqSZ4Vrx9STkZfAeU6slHuWBXmWH5S5TvBqpKVP534H/e9F34OLoRtaDOGKE2dwSkozukUwLevLgyTaMqskycLOJLWfg2tVngG+XAmewsih3OxTh4KSNokAyir9Gu3HjRz+lJZ66x8qD1TcEKpjs89Sl8XgavdPlJ9EbeoD3/bV5WRrBWhZ2uaowBrmjLChsoJrafakHErlVe87/c4+GhAWy7ckVwC2Frfp8FOdiCLvqzugYRW9oG43+fyr9eUewn/XflORTYwN/O4p2a9XryGNYUqvWyKze5/jlYOEWmvFN/+CAc0PdaxTftZxzmg/pbe100NO3sAdNusQ+sA2LLQSVN8k4wASUlGGopFyn+zEV1ojXqQj7YnYvbGYBcb3dS5zFCm6Ep1NxSURYr1rghx0aKcPX76BVdT32dg8t8c/1SafBBnWesRyLk9WbhkQ3+chVP9dHdOc+/qEzG1jjasIt1rpIto1xBMaqunfCWi/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199015)(86362001)(921005)(41300700001)(36756003)(2616005)(186003)(8936002)(5660300002)(66476007)(66556008)(52116002)(66946007)(82960400001)(7406005)(8676002)(7416002)(6506007)(6666004)(107886003)(6486002)(316002)(478600001)(10290500003)(4326008)(6512007)(26005)(82950400001)(38100700002)(38350700002)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aU/9xGzKxFIRTeQTSX9UzGFPdxXUrtUIpmbwhYJ5Vib7IcXpWvjYZPcevzvV?=
 =?us-ascii?Q?Inz86qtz+ePuPaZtRZ/lojUTDUBjN6OEWE2cs6/erfL7QxWerhjI7bD4zHoH?=
 =?us-ascii?Q?+5saJzWeOWjCHezIMBvK96EkK79pEVk9ssjmBSG6fDN+K/uPfvGPHE9GSc3m?=
 =?us-ascii?Q?ocgH601a1WvR7B4+8YNxcA+kGFBH2h6U5fW+C4lGRm+aySxx4H+dJFTnRzbH?=
 =?us-ascii?Q?b5ND/FWp6Oo527rzmpq3XGivex5e0DwhMpH+VtBHJGzX9S7geX2/Sgs7nNGK?=
 =?us-ascii?Q?A+4BuxuzLVUdH98UxfY+TjaIRNNWdwF8jDApgMvrkfElkXB0EwUhvJLxldmU?=
 =?us-ascii?Q?AdZn8eVafhOqrqsq/0j/42dpFlj2q5VgLnZ+5hRPYipTvEwGn0+lLkOahO+n?=
 =?us-ascii?Q?90zz2DhCguk46Q7BWfRAykJxmkdcBlamWCvFkijGIdGmX6aUgAV77ueoHq4p?=
 =?us-ascii?Q?v7szKoWPAL1Du/xWFdGm5lPqhr92CV6rWwyBYwmPzCyfSQj/AAUt1aaQihi1?=
 =?us-ascii?Q?vUbrjx/qg3kCVj9PdkDkHQ+40Dz0/dnaY7WUI0BG1kn9jE4T35YF1BdE+8zS?=
 =?us-ascii?Q?UqJJvDktVdUUcPNcRykCVlyvxAw2yzVS8iU/TGAGqOzZSjJ2XZx5+iF7sWYM?=
 =?us-ascii?Q?Wj0xjjy8kRjM7+N/p3+FniAPvBAwuytYQ5B2fXLK/YW99IejE1Ok/VWvbpJH?=
 =?us-ascii?Q?tHw88wTRnx+i9so1oauR7l674ZHZ9mB5cy8pxkn9J0AoT8v1JhY7ROY4mgAf?=
 =?us-ascii?Q?tN7gAuM8oZN9qxi0q8S15Ezssrs1wmZ4Tor3Q1mL38+cw4O90xY9NkpWblZL?=
 =?us-ascii?Q?AXf2I6DUVqltmWX1Y/+rejpXImQrFVbRcfy0RsKHFH1yQXb95828WwRXwmdZ?=
 =?us-ascii?Q?tdu0naJa4BL9xYW0fJ9d/0uLfSTqdMy5tgNTvtV4tqt6RBH7LZ9rh+Qy+cTH?=
 =?us-ascii?Q?FNjmwx+oI4eaaRQImDFx3IXyqz8NBarZNUf6h64SpbF5rg5ipTqqc0QBLYDV?=
 =?us-ascii?Q?g7NG00jTr0jOotv02Pbwx/j84eSlgWO7Vxio9Pcx4RmmoQ8g9+NwyQ4X0x39?=
 =?us-ascii?Q?gIOfs2EnX4w1r/rJJqEgruBVOdYkarP85Ct3Qydzm4T6a/U+PnCnDODEmVtZ?=
 =?us-ascii?Q?H48zmOzVSWx7ZPwbhVUjzFFQKEuL4kebxhKy7kiF2yOGrn/+j2k3d8nWJldH?=
 =?us-ascii?Q?MrMAa2llBl8lqUzkqj3apHdDZjzhFWr1n2+IuL7K/MTAp+761Oa4iTvdm85B?=
 =?us-ascii?Q?LmvUBK/WUrh59UaTxL0H3K4Z/85gu9OxgAy4kkrS7hh5hL/zlV0jEb5XXIIc?=
 =?us-ascii?Q?CgXxxRxEvymwdHd+oG0kpg+4I5dTy214eX7FGgSPclepqTes8d8XVMlgvB6N?=
 =?us-ascii?Q?aEOSbpSESGbWzbrFtzYFawpVVtmVe1NaXzfttVCzhRrULbj4UDLV7HZN9gzY?=
 =?us-ascii?Q?xmggz+vyuaj4ANYkGQfYrqRW80rI/to34V4iVs0iZna00TCMvoyRFLb8xgcR?=
 =?us-ascii?Q?9yt+7YJCQmqXcBuzHtuN0hmFW9DBC+gMQ6ChXxpez24B1VYIKtBUtH+8W8Or?=
 =?us-ascii?Q?0qPQF2RCiBP6TPahJlcm2EcFZarqWNq6jH00AppGbMrR0iyjUdtfET+7cL4W?=
 =?us-ascii?Q?xQ=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7927bf86-f1b6-4679-089d-08dad415d02f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 03:32:18.0991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sXZhNu+Khgxse57w1bnydlxsN1bhfNkbSwTjDTOGQpd0zbY34hZ8vCMrjVFMZBSXKMIhEpv5Ov0Zqi7fYA/vwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1316
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With changes to how Hyper-V guest VMs flip memory between private
(encrypted) and shared (decrypted), creating a second kernel virtual
mapping for shared memory is no longer necessary. Everything needed
for the transition to shared is handled by set_memory_decrypted().

As such, remove swiotlb_unencrypted_base and the associated
code.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Acked-by: Christoph Hellwig <hch@lst.de>
---
 arch/x86/kernel/cpu/mshyperv.c |  7 +------
 include/linux/swiotlb.h        |  2 --
 kernel/dma/swiotlb.c           | 45 +-----------------------------------------
 3 files changed, 2 insertions(+), 52 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index b080795..c87e411 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -18,7 +18,6 @@
 #include <linux/kexec.h>
 #include <linux/i8253.h>
 #include <linux/random.h>
-#include <linux/swiotlb.h>
 #include <asm/processor.h>
 #include <asm/hypervisor.h>
 #include <asm/hyperv-tlfs.h>
@@ -332,12 +331,8 @@ static void __init ms_hyperv_init_platform(void)
 		pr_info("Hyper-V: Isolation Config: Group A 0x%x, Group B 0x%x\n",
 			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
 
-		if (hv_get_isolation_type() == HV_ISOLATION_TYPE_SNP) {
+		if (hv_get_isolation_type() == HV_ISOLATION_TYPE_SNP)
 			static_branch_enable(&isolation_type_snp);
-#ifdef CONFIG_SWIOTLB
-			swiotlb_unencrypted_base = ms_hyperv.shared_gpa_boundary;
-#endif
-		}
 	}
 
 	if (hv_max_functions_eax >= HYPERV_CPUID_NESTED_FEATURES) {
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 35bc4e2..13d7075 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -185,6 +185,4 @@ static inline bool is_swiotlb_for_alloc(struct device *dev)
 }
 #endif /* CONFIG_DMA_RESTRICTED_POOL */
 
-extern phys_addr_t swiotlb_unencrypted_base;
-
 #endif /* __LINUX_SWIOTLB_H */
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index a34c38b..d3d6be0 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -73,8 +73,6 @@ struct io_tlb_slot {
 
 struct io_tlb_mem io_tlb_default_mem;
 
-phys_addr_t swiotlb_unencrypted_base;
-
 static unsigned long default_nslabs = IO_TLB_DEFAULT_SIZE >> IO_TLB_SHIFT;
 static unsigned long default_nareas;
 
@@ -210,34 +208,6 @@ static inline unsigned long nr_slots(u64 val)
 }
 
 /*
- * Remap swioltb memory in the unencrypted physical address space
- * when swiotlb_unencrypted_base is set. (e.g. for Hyper-V AMD SEV-SNP
- * Isolation VMs).
- */
-#ifdef CONFIG_HAS_IOMEM
-static void *swiotlb_mem_remap(struct io_tlb_mem *mem, unsigned long bytes)
-{
-	void *vaddr = NULL;
-
-	if (swiotlb_unencrypted_base) {
-		phys_addr_t paddr = mem->start + swiotlb_unencrypted_base;
-
-		vaddr = memremap(paddr, bytes, MEMREMAP_WB);
-		if (!vaddr)
-			pr_err("Failed to map the unencrypted memory %pa size %lx.\n",
-			       &paddr, bytes);
-	}
-
-	return vaddr;
-}
-#else
-static void *swiotlb_mem_remap(struct io_tlb_mem *mem, unsigned long bytes)
-{
-	return NULL;
-}
-#endif
-
-/*
  * Early SWIOTLB allocation may be too early to allow an architecture to
  * perform the desired operations.  This function allows the architecture to
  * call SWIOTLB when the operations are possible.  It needs to be called
@@ -246,18 +216,12 @@ static void *swiotlb_mem_remap(struct io_tlb_mem *mem, unsigned long bytes)
 void __init swiotlb_update_mem_attributes(void)
 {
 	struct io_tlb_mem *mem = &io_tlb_default_mem;
-	void *vaddr;
 	unsigned long bytes;
 
 	if (!mem->nslabs || mem->late_alloc)
 		return;
-	vaddr = phys_to_virt(mem->start);
 	bytes = PAGE_ALIGN(mem->nslabs << IO_TLB_SHIFT);
-	set_memory_decrypted((unsigned long)vaddr, bytes >> PAGE_SHIFT);
-
-	mem->vaddr = swiotlb_mem_remap(mem, bytes);
-	if (!mem->vaddr)
-		mem->vaddr = vaddr;
+	set_memory_decrypted((unsigned long)mem->vaddr, bytes >> PAGE_SHIFT);
 }
 
 static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
@@ -288,13 +252,6 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
 		mem->slots[i].alloc_size = 0;
 	}
 
-	/*
-	 * If swiotlb_unencrypted_base is set, the bounce buffer memory will
-	 * be remapped and cleared in swiotlb_update_mem_attributes.
-	 */
-	if (swiotlb_unencrypted_base)
-		return;
-
 	memset(vaddr, 0, bytes);
 	mem->vaddr = vaddr;
 	return;
-- 
1.8.3.1

