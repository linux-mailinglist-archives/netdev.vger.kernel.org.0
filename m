Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB686C94C2
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 15:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbjCZNym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 09:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbjCZNyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 09:54:23 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021025.outbound.protection.outlook.com [52.101.62.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0627F8A54;
        Sun, 26 Mar 2023 06:53:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A6EMMFk25FYYeeS5ZHkgC2sLAW+60xfcvmR4yTgL9GvIOQmCoKXPoAolPUufAIgwshKTPvYogcmZJyR97xphjiV1kuHzMnccfKP07NDIIR0e4X2GQd1F8xDUDDCj8jqIUFZbqY9r1B8mTN+2TUT8N7NRQpQA7B3IiB/I0+9qypGWWIw0LxfdjCvsj9ptT73LMrGeg3EbPGr13F87k1b6XH6Ddf4T6116aoPCsE41wFORATFEl1IUmW1ddhSYvOUCds4hH63G6d8Z7vJH+OTtko1HXBD9z1P5aSqlmCzpCldn0R5bRnvBzwIvIEyMPekNcCi8DVeOTOpVITnaU/hpXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t5Hd77qDCpkB4ebpkTWX8l1Ig8pl9p45jfWTzt96pKQ=;
 b=hG8wvt9/UCDRTfAxkrI3y2Rz4iEoFeZwHKW8UK3cXSDgK6XgCv/RorshxAHT4+AzvtuisTCXlHKbmxQt79puA42WJcO332ttBdFmL0xV4cKGyMLka9Ert591Za7kpSInlfD/GRaFAGUCfrSmtdgn6TSjrz2TUlakQwsPda74RHuqGuhUNgWdv8V6Vd/LhhWaWBuUVnRm23SkEnTSAm1FLMI1BZxB/RBIeJfBRt9FKXhUBO4ipTjWzIJwgWwNZ5KAlTCLeFPzjftNnEWsOSuBeM4DTANgZ1Yt1YXAsaoQ3U8H3uhRR9FFm+W4+i3N9Tzf+TKnbYPVgCPPR2yrFEsnlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5Hd77qDCpkB4ebpkTWX8l1Ig8pl9p45jfWTzt96pKQ=;
 b=eIunlEh2IYEoCdlmn+QPUHW2RRQzMO5kBKoM2HR5whdZL2lMcUds5qMuSD1RbcLoCKXEoEBCQpebkB0zzT2aUKFzlMU9vpIi7SA4KtQkFiFVWR4QDphf3TWksEWmnCO3cdBDBHquOh3yrOsQmT1XipRvYnYzlJsI5LNfEZtm3jM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB2001.namprd21.prod.outlook.com (2603:10b6:303:68::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.15; Sun, 26 Mar
 2023 13:53:22 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f%3]) with mapi id 15.20.6254.009; Sun, 26 Mar 2023
 13:53:21 +0000
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
Subject: [PATCH v7 07/12] swiotlb: Remove bounce buffer remapping for Hyper-V
Date:   Sun, 26 Mar 2023 06:52:02 -0700
Message-Id: <1679838727-87310-8-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1679838727-87310-1-git-send-email-mikelley@microsoft.com>
References: <1679838727-87310-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0168.namprd03.prod.outlook.com
 (2603:10b6:303:8d::23) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|MW4PR21MB2001:EE_
X-MS-Office365-Filtering-Correlation-Id: 24846201-2b07-4b1d-8d06-08db2e01764a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zv0K8uO8sDvIlqQQRDa8waxFJ578zQZGYPpZKJq46WfzUYxnbIB6NV4S2Vd7DtKxWpKFkRe2p1zv4NZdB2GIUUkzFgEAm/E8xrIatrlMJcBnt6HiGhy/uy8A+IFcRarfJFCZPiSGY2Ayhz0Ht0Qr8xtxS/C3+QV6c4N1ltztlzyl8mb4tKKtx6oGL16R1oTSDq7gnCCa6/x72C5gGG6aFDuzFfAaojbXRknXnTumAJVXwqMojprGxZs8RidHFSXitSBRP6COIMnmoQXg8IUlln9hZuwI3i+ImpUwV1YtSOK3H49Qsxpz7kSBeDzOpaSk/Cl9AzR7EImlPF5hWKTQqzgbAZneoPCXaDmc/vzhvKQiYMLe3BmFTuRuC1s19T52cqbRS4Seqd3g93owc1K6B9wwGldoVTRd36y7bfQkoJTQcmfgnYZQVN4Va3juYxdx2NFDKIJmxm7OAtz9o/xtezwWHixmGCrGxk2eb9YNCkm93PAg5h4L6mNUmvRmM8XkfMTG+pn2Ofr/z903fPSdWwy65kfnTHpSSijIKgaZaIyTkWJDwYQn9ncG+UZdfoTRlgjPm1NsX1QaHpwQyh2VDdNzOpaBZecLMa78eAvh2Is0aXutKoaOTBimKF6XK0rgGaqQpEqdY4W90amJt3lU0v85VI6G4ZXjhyTb2fDt78ZMJgJbEFZf0HPaq6YNGZdQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199021)(38100700002)(38350700002)(82950400001)(82960400001)(36756003)(86362001)(921005)(2906002)(6666004)(107886003)(10290500003)(186003)(26005)(478600001)(6506007)(6512007)(5660300002)(7416002)(7406005)(8936002)(52116002)(6486002)(41300700001)(316002)(66556008)(66476007)(66946007)(4326008)(2616005)(8676002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IDcwCpC492yFDlDR7AbUht91hcbefge1xCCgOOgyFZr5Z1ejLmgkIor/otne?=
 =?us-ascii?Q?VATizR9DttJjBKm4u5SZIIv8tYFbcpNeBQmAogbZo01z98f6w0KqQyayDl6O?=
 =?us-ascii?Q?BALoMhSjhp0vr9LGXqTf4oYH00HjUyUTpx5+Mj1LNypqWZg0wHKTGG2A6u9Q?=
 =?us-ascii?Q?cALcmsp5DDy1mqCMEXuek2eMHh8/qaU/f5dTDWfLmV/DByOLnT0FxQ+4pnVp?=
 =?us-ascii?Q?xUm4Z+DSjvAJmgh/fXZP0PYO2L6gSCcQ2o2tBQE135uctGDAflmprz85cpRY?=
 =?us-ascii?Q?YZOSusd7+Zz5OjEQ8kOGL6aR3L6wfdq0ldCjawvjvAx3mB7mBBm3gB7MNHJO?=
 =?us-ascii?Q?+uonuL34BfuJWAs4BrDoPayxIFlkt7610jWYUSKWDoPDKD4keH/3bUc/K9+R?=
 =?us-ascii?Q?fu1BcqGwKX52ErCN3sTUcOYbuIQXXx2CQH9KARZzD+uWe6KZSTYXcdeS4Url?=
 =?us-ascii?Q?PpFzBUiKGe9+O9jA06vl6j/TyzYoJU4Zubqak7qLX5r+J+vVcO6m2Hlg8a+p?=
 =?us-ascii?Q?pNNv+KQopai6NCUSAqxVprG27sOnXLZV9pfJ0Gm3W977ik49NAS308A005DX?=
 =?us-ascii?Q?lZ5ETo8+8oa/EE18sQrbTLh3Z2YVwYVm9J7rMxW+bJytv78+Bg8/5jq1TCK4?=
 =?us-ascii?Q?QNrnyCAKCtAsjZb2b4WqpcBF1rnlqZNSPfhElB1UdxQIK5ixsUHXB8JEFoKS?=
 =?us-ascii?Q?52nCFD+saztslvrcggpAf4wm6B9tvCMq++M/nyh5CeWZH9af2xUhOtErPezs?=
 =?us-ascii?Q?FePMok2UcV1HDZa5ivFitqYl8xXtRV3sQ+W7u5FoxXWSi0kQxpkzSs7ZvFaF?=
 =?us-ascii?Q?JSzb6sucWpl7nOTV3e0GKS/Vx2laj3NuqvoR5V5GkhgsoO+3vhwDL3UIF0h7?=
 =?us-ascii?Q?eg2MuGj4kRZPWo0u10iysdA/o+iedU6wObOdure/OV4K2VzvJ/m8SGQOOOAE?=
 =?us-ascii?Q?W0efzqJMQXX0GqgXl2U/C2SDC+yAjPkOhcPcLJUTn+o4XyH70+lBrKBuX7EN?=
 =?us-ascii?Q?nZUH2gpFSF3QLKP3JOZAJB+shk7wKlZ91wwsGzBirA1bS/5/0hpLYGRp5ffP?=
 =?us-ascii?Q?+pDt4HuYbmsTl2M5r+CKztnqnym43cWKMpg4CeAw6YEOhVX2RWM4pzNiqPB8?=
 =?us-ascii?Q?qAXsrZzkTYEnvEl2M6ZeRMlOsRkf9UqfHteH68U+2yIZccWkg7g8jB0tool4?=
 =?us-ascii?Q?pEPYvw1VN1/3EJs19NgIVNHPb99npMUwgODUCtnivTRm+Py7Qcu7wtWi+Vih?=
 =?us-ascii?Q?pZ8WGxrBAnRMHqzxC7pm6paW0Pp24pLSyhZHOrNx3NzyR0BMGpGn/NyVAB/2?=
 =?us-ascii?Q?9265Gd9D2p20Xkj2ucUNTDLFNBRgdiPONAKn9vec9/KpLLMo/AH4R4ntj5Hi?=
 =?us-ascii?Q?eyt/Y0xl2XaX0AR5Fz87xTI1fvzNh39myKIkg0YsRG4RgPyayJdwyDD0D6vg?=
 =?us-ascii?Q?vzk/LDSSz02stPG2YA6+67lozjxZc8uCjOFt56rR9ME81cuySj2AAPeSBfTQ?=
 =?us-ascii?Q?nMjoqSWtyfh77gvgRYSk2mlkG63mlyAUW9BMjff8mRSnOTkAzYcHazmTVx4+?=
 =?us-ascii?Q?3jA6VrHpZ++xh0OvPdBFdwdsUZxdC2a7WNR6xLJAV8jsr174gNX+9xe7lM//?=
 =?us-ascii?Q?sg=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24846201-2b07-4b1d-8d06-08db2e01764a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 13:53:21.8801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xxUzz3W4ZBfNop5DZ+lzTX/n9AV2adgv/L4TptS7PIR9hFDVSQScrD0zPk68HGbjKiJMh72fQ0O7ekNNazWXcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB2001
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
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
index 315fc35..ac630ec 100644
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
@@ -408,12 +407,8 @@ static void __init ms_hyperv_init_platform(void)
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
index bcef10e..2ef25e6 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -180,6 +180,4 @@ static inline bool is_swiotlb_for_alloc(struct device *dev)
 }
 #endif /* CONFIG_DMA_RESTRICTED_POOL */
 
-extern phys_addr_t swiotlb_unencrypted_base;
-
 #endif /* __LINUX_SWIOTLB_H */
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 5b919ef..f9f0279 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -73,8 +73,6 @@ struct io_tlb_slot {
 
 struct io_tlb_mem io_tlb_default_mem;
 
-phys_addr_t swiotlb_unencrypted_base;
-
 static unsigned long default_nslabs = IO_TLB_DEFAULT_SIZE >> IO_TLB_SHIFT;
 static unsigned long default_nareas;
 
@@ -202,34 +200,6 @@ static inline unsigned long nr_slots(u64 val)
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
@@ -238,18 +208,12 @@ static void *swiotlb_mem_remap(struct io_tlb_mem *mem, unsigned long bytes)
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
@@ -280,13 +244,6 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
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

