Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08472668609
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 22:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240429AbjALVuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 16:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240996AbjALVsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 16:48:42 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021016.outbound.protection.outlook.com [52.101.62.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF288C4C;
        Thu, 12 Jan 2023 13:43:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4gYbiFTX6RLfrFMDXTZrUcFFvmx7I1BjLzBJMIo3qFGShKFmu3nuKXzf1Syfc2zXX3omfjyBPJD8a3ELOzhavA7Ps41XqgsNFJMObg4NGbywTu/Ff39mnXGfuF5HumphCPfdFjlWCrMXFrHQdJvymx0vGq3xp2zkT11FsULzZLA7wE48tv3OHwHPqp8Q4S0o5JONJOiW1fXa4bt/FfUk2PRiJgN+WCIVAcMT44aeEria6GF1fzKvc5jMlr/5icUPUeeAf9pKyhaQMth8/NZySWZDcoFg7+jMXUWrqegPzHzsSUIwRk7UvjGe45CSPPpqHiKi4IvRP7NiYY22umQtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PZo8RPkaGayr/k4KHlRYdQdBejrww9Cz7KYQw5kOUGs=;
 b=Xxlvvnaf7PzMwrzy1uDXUgHup2QmFfXv128G5nGixrilrLNKmh7CfvSUUdq1ZWLvF7DY8h4dQ2jXidnPHEewxTBQ3zGZoOVT2aijTsweraYW+lqB4CwGZiWEOypbCpZlCHa4Gjnd3hWTeTaspIrx9YgTisr0g0E1LSZBFLcSilmAkt2C18I05+1ALylJ0ZWZISRvmYg+6HeVhtsOxJG19245KPbdBymyFEJSIrVt2OCFN+R2wdidbC4aj36IEuT0t0cTlXni9eGpMdOC/ObhJl/WiGP/i2tWRnlBsDC7C9oYj5k0Fw6kUX7OTnPsr3LwSjJ6EMvExtjCjOaqn8lViQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PZo8RPkaGayr/k4KHlRYdQdBejrww9Cz7KYQw5kOUGs=;
 b=g745XJTN3ZM5pEiHzuPWlLSeI4MwkLWm3nl8Y49viMx2xuzTrgTzz+Ev9pSLg5gYsQ7HkteeHud1C+gr8kvtjVeiL66iIP72SGXpWqwFNux1Iukq1TIjXI8ctu05DJQhziZm1krwuFPHq2MktEkOV1RAq7RL7tDGuTgEXpqn7O4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1953.namprd21.prod.outlook.com (2603:10b6:303:74::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.4; Thu, 12 Jan
 2023 21:43:13 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7%8]) with mapi id 15.20.6023.006; Thu, 12 Jan 2023
 21:43:13 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lpieralisi@kernel.org,
        robh@kernel.org, kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
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
Subject: [PATCH v5 08/14] swiotlb: Remove bounce buffer remapping for Hyper-V
Date:   Thu, 12 Jan 2023 13:42:27 -0800
Message-Id: <1673559753-94403-9-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1673559753-94403-1-git-send-email-mikelley@microsoft.com>
References: <1673559753-94403-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0057.namprd04.prod.outlook.com
 (2603:10b6:303:6a::32) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|MW4PR21MB1953:EE_
X-MS-Office365-Filtering-Correlation-Id: 21b73a23-40d8-4d3e-e041-08daf4e60187
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YnVAXb6lqOzo+4e2BXjBUueEDkDWvBTRn86whEeadES067wa0pwVcA42UbBzJdm8+3MUfVAzmZF49QEtm9lMa3C17BbXoNL/ugwMk04apaYJ9THA3Sd2bJ6DIgVt5SqLmARBCcGwUHo2VYPGDlW8dbYizjJirKEBLJg0PWUuKaFcrky/bNwc7XWBlG4TTO+3/ON7O9rf5rBn0J2NdjSs6o9sw+SBSp3xISeivJalXYOecvqXlYifzLo8wp1OANYqfIS1iSZAwOTxqV38IsMTd8jExUBcsTO8sXEBNgczWn9l7O+BkbXSkRO7QT9DkKLsshevNkpXulsKSd5yhr5PNzzuAflUK4sMnwwFFCX3ixouI/5Ky57iPd3r0m1xehdGmXRmzglCG8CB1QRWUCuLC0bVsTdStufVg2i2oUQkT0nP2fqd7Fkbt8Tso9g+0S5+/8OhZhWO79R/FWJHatyAzgWDey1p1CzMYOlgK38wb9H2RHHWOq2pW2jefUf4i/WckwlVoc17qTwt5CoZZaG4xDPciwGN6fIikcthj7xpQndMRNUNcHBO7z1fZaXqFRlyAyaSqTI1sM/ZN2QbskBalCv/PkSWKVSnkB2FRJRqLaeLvEoCjifyTeAqX6wdxwwJ0nnKnqjQkxXuE3FrJs/KaPq2jEprCNw97/gggOzdYk2gS5aBOYxVLmJUrle597cTGFSIAmaHSKfiVqKSs65WdIuXoEX9MjROiUejHeOqf/lhyKXUEKMhl2ewQ9Av4zCfgYZHVoFCt0hS23LC+VQ/AQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199015)(186003)(26005)(6512007)(82960400001)(82950400001)(6486002)(86362001)(52116002)(478600001)(2906002)(5660300002)(4326008)(8676002)(38350700002)(66556008)(66476007)(316002)(7406005)(38100700002)(10290500003)(41300700001)(921005)(36756003)(66946007)(7416002)(2616005)(8936002)(6506007)(6666004)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yBuoV5oS4Sc8SjBreTz324KzjuOUOETdKT6ezap1aNfZG+Fu/aRUccYMpekK?=
 =?us-ascii?Q?EvftZ6mjJnFNsItbDEIpOExFKuBIsYNqvFhKLFDf64kS3PaeBsreVdMlVns9?=
 =?us-ascii?Q?jUbaX+qTOpKaHEOwqLtF6k6spBlNKMjz6iTrey9EFgt36Zlkf3PD+hBCuM0/?=
 =?us-ascii?Q?U8AvdAArO26c6KYvb6yl/MvSTkM8z9dd4FSCyFaoNx2QIVDh9aEg67sUE+2C?=
 =?us-ascii?Q?zOBVmMt7K8nLb48AAmoGWtMJLst2DsKxkFNE7qCLR+wGd2Q6IXpzntMwO/8u?=
 =?us-ascii?Q?uudIGZlzkpA6H1TeT6O20d0ZdLGHymZkOO/60WwTqebA8L2+KvQfOb3AFgcV?=
 =?us-ascii?Q?Y5T6y6epf7I+tE82kVTuvjPYFqE9wdjvZvVoKNDVIqW7V5KQc38mPGt0/0mm?=
 =?us-ascii?Q?GGKwNQ8lWiP5Nm0vYIT3IjB7ByyJId3znCKxAn9ATvVRVXKD3dZK275fIlZ2?=
 =?us-ascii?Q?Cy7pWeyDJuEw463x4AvqA+xzZPZDkCtJRSfuw3PkrpwbSVl/s485iVRYln1c?=
 =?us-ascii?Q?y4EF8RLKboL4M6cJh/7p0zTDCT4XKtUEWui9VJMNUQSlnZLwlMRS77HBleyj?=
 =?us-ascii?Q?AgFv4jhDISSUBZElwEC553c1GJ2ZihgmKJShxSQfWsOPloFcEdhmI0RP/OT0?=
 =?us-ascii?Q?7cRfrtY+xKfsTaEm6BYfqg1ZzOMd/yn6jXYKcDdtT1EAQeFZy5eggymtf/9Z?=
 =?us-ascii?Q?PkeRtq6NG3yZihNnKtwxOmGGm7tuUGtWDzvTwyDiTBumSasQN9cKBK+aKa3b?=
 =?us-ascii?Q?RCT9aKZ9ZgxwJi4U5b/LIxybHntonxR7fDBqsaOwGdoRWR4h8mp4vvZYYFNB?=
 =?us-ascii?Q?IRv7rdIGdqM3Lsu3K/i07KLbn+U5lL5oYbAgbCZ2eT70tdAVA2Ahl2CPH7if?=
 =?us-ascii?Q?crY5bbsHCzFIVvpZWkhmMxhcBohszHH9RSdxfFeJkrCBSEUYpCmMhF3V4ZWc?=
 =?us-ascii?Q?lSIzB4fmFIZ8GRNfkIZjiPftpCOEx1KFiw8rlpg81HH/wzSGMx/C6acWM7gH?=
 =?us-ascii?Q?Yzxga4xIsTNlmIFpEz4AZZhMCKT7k0CKiLnc/G9fj8m6sXt4U2XGRaNRo/O7?=
 =?us-ascii?Q?JTYFVkx0nHP4yvbvMAv8oKc7qHg9QDJ0qucUg5kEhPuconnRJGc9xXrmuH5R?=
 =?us-ascii?Q?bsabgLyhmuUb+nxCiabPVMJzTCv3lMNT2wxXsZfx1t6ls1MaRFy8v3x3qdny?=
 =?us-ascii?Q?cbQt6KjNJg8N0iMaZNOZ5mpbMRReT3thxst0xgb58E/gO+W99JtAV+XuVym0?=
 =?us-ascii?Q?1rhJdCe6yQO4jE8mLAoiYX8lfqkc6+eaGicdD2yHf9btECpFhRfGudwHx2Yf?=
 =?us-ascii?Q?StRVyF4KIymV3i/in7cSsXk7MKz0TlbMrG8kf6XOZxXcMiYNQFiDkyRNKAOZ?=
 =?us-ascii?Q?ftHm0xzFnlwYu/84Wyhy8njYa4EUaHI25u7YHwdkbKPzrC+5grFMJM89Rn4k?=
 =?us-ascii?Q?SDi7ekvjv7ZnpaDv8J2cPh2GunG3i1icedMmOMqPPLIXwsp6esJLCWGzxzaM?=
 =?us-ascii?Q?iVGx73+OIU3y7OjI5nKZE0Z0RLx5luI4V7QvPSW7fUjvMfBFgzoFAxqH6f5R?=
 =?us-ascii?Q?PXoaeGsWDcbnPdqdWPP0zt3F5zQKznd0onp1BKMF?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21b73a23-40d8-4d3e-e041-08daf4e60187
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 21:43:13.2956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0B/kXwvX0njFt8DzqsObU0cih0AlJRN1tV7b2RQAxqkBcOabAaSE/GP3jQfVHC0ChfmiOueOgxpPTMrpjtsHVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1953
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
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 arch/x86/kernel/cpu/mshyperv.c |  7 +------
 include/linux/swiotlb.h        |  2 --
 kernel/dma/swiotlb.c           | 45 +-----------------------------------------
 3 files changed, 2 insertions(+), 52 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index cd7f480..8f83cee 100644
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

