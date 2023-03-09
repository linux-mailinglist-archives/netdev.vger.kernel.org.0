Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C00BF6B196F
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 03:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjCICny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 21:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCICna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 21:43:30 -0500
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021020.outbound.protection.outlook.com [52.101.57.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E0FCCE9D;
        Wed,  8 Mar 2023 18:41:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZKfzsUP+r2SD3OVTWNl/cIgH7gNPK9ZT+2k5/Aun7uU0th6xDBJxPISSlgTVOcM0fvy+ugAPZ3idCS7zKHp9Ugq9iRPcy+x8p1jY+BUcyKLpVsHEj2jycJ2XCKUE4havAb+uIf1tRkC6XJ1SH4NxWLIw78AB2jpid2S9SOEp56Uv/mPd1UG0GD4MBqDDI45eCJhJIVDk23eBmTqIj1v7ip9EoysOeody0+I6dO6Zo8GKMwe75V2OYritC5yYLvkoIH9WUeZy6zIz5CwagfAfavnWpABoKTf/sRA4VAnvbG8MaxLK974j+pCh52ON9fxokVBYnxFvHgXKVjOP846qcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D9VhUgukXBjNtMO35hB4AlJX7wObHzM6Gk/maPqBuzs=;
 b=mq318Plu8QFMUHz2X3NO0QX6y4RrVZmoUjb4iv0WWfh/x/WKuMipURgD7MnV1yxF+96Dxuz4hDDTPdD5lkmyOpes7r61ANjwi6/ysKfyRESonmm9sGqB9/oOI+ukdpbncgqdGYj4uUVLQvFjkkhx/quJUW4KsbENtU3jPZ7izeeBQcaniJQNrCXeDsTkGnhlaT7q1X/szG9PgR2stSQ7OrZ5yKMN7uuQfP8Xvyu3Gp6ut+rVZ5Zk7IGEGYmzFiKy31qaG6dLuYFm4ROliySznRR5PKj9a098mYI1omKgDXDZz6H/cS8hmx4MfBBwHEJn4KD779l/fwHoo02vAU+55Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D9VhUgukXBjNtMO35hB4AlJX7wObHzM6Gk/maPqBuzs=;
 b=At9uY3HkyBI+RBku6EgXuMU+S+1UT8CRJes0mf3mWgtI7J/UXIj9qloZ8hc5OugS2Bojdy2T+zadGjNvCVl7AWj5wS7m8wmf4IeggQeEyngoCVWfJyj0s0eoRiquo52uoALkgNbIRQkLJb2nWWgEppMQRGGb/Ikobf54/WBiaw4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1313.namprd21.prod.outlook.com (2603:10b6:208:92::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 02:41:49 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17%5]) with mapi id 15.20.6178.016; Thu, 9 Mar 2023
 02:41:49 +0000
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
Subject: [PATCH v6 07/13] swiotlb: Remove bounce buffer remapping for Hyper-V
Date:   Wed,  8 Mar 2023 18:40:08 -0800
Message-Id: <1678329614-3482-8-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1678329614-3482-1-git-send-email-mikelley@microsoft.com>
References: <1678329614-3482-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0008.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::13) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|BL0PR2101MB1313:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b7175b4-5491-4153-2e11-08db2047d4f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rhD24eAssfBcNKluahnyF30tPe+ilDgTAQe2KZGwT0cATjvg9264b4iFNDbGeYB8Gw8JYhToyfDUtBUSpPWUUwFv18x8vuHnjaxnCpYD3a4tJwIc7F3kKoQ8KJMsV1WtR9tHUdxNZc4N56aAXJ3h2ie3eSNAJKVDgl68IrwQVUb46pdPtIAmrSxch8XKnmGKskrHC/p0sb6Q5XM0ITTdI6BPTX5FbT7XHKHiqVNvAfDLPwyk0WvUM7SHt+ZLd8S49mGxcl8ODz+zOQDKtnFArox4bOYMjM9xhdGjIn2CmZ+p2HQ9NakYf6wZz3zI/MZkEsYwoOyeixO1TMgibLaJDgWg/kilN24vIAH5Xqs4ERe4uWBxyDnRACEpdDQS9QhUsNKQ1sr+VSuqYbmt+m0os2wTSNTXAYREFSxRu0undRbUNTHEtTZJBCAdSNkfHld1vcQhKPaT6NaPrHo67L3eANFhjNvvbCmRxc5ilXqkh7CE1OeaofeXV9vmW3XXIE5qCPnLtUVelmVk5owisuasSWnvzIVoXCOrQBFTW9b3fVkrLSHfKYtwPepq1gxlQVAxPJsEOYLJF/NWz1GsCkVSGA0A07zn6PXoaa3ReSqmChb9XQ6ZUGu3FuUDSxXXiH3Xk97Ke753F4XCeFq9Rj0KDySgWBwdJ50u4CffgN3MVaCAYYOoPPJWZmtHWCtrn0HRu+Y0MLRh9ZEaOKL+paZDDJCmVEBRqRqVUlWNO4Wm31veeA3wO39/WY3QJneZTjC8kUbQclLLmvz/4PTa0g18Jg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(451199018)(82960400001)(82950400001)(83380400001)(36756003)(10290500003)(478600001)(921005)(316002)(38350700002)(38100700002)(2616005)(6486002)(6666004)(6506007)(6512007)(107886003)(26005)(186003)(7406005)(5660300002)(7416002)(41300700001)(52116002)(66476007)(66556008)(66946007)(2906002)(8936002)(8676002)(86362001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VtKHZXJyVpyaKkVK/AzR5fp5wG2U2Vf4IQvYPFmYPDVNo+N3robmrRLVKEHs?=
 =?us-ascii?Q?ywVR72tDItnQ2arksoijvsfhpKuL4waHsyot99teorduW8lPEQqaU+UoYPhg?=
 =?us-ascii?Q?fYJ2Sdgt1aUZT/P59nMj5H1oFGvzYcu0Tg104G+ujU0P48onVG1T6U9VXyGA?=
 =?us-ascii?Q?riUJz4w8fyVx0YiEw7iacYkTuApbELTXeRkak4vsJmHXbTXFN4a4BqBG23rS?=
 =?us-ascii?Q?hsbs9q9EP3+iz0neN5DyMrnRgEE1unS/VTDK6RSrvn4JzNuJlTmyVn+ENg6z?=
 =?us-ascii?Q?fj8gnYO9pUvtJ61Op5liHHbdBu6SPX/BeR43mb+kZlB2C9C6IS5Vrrl3r09p?=
 =?us-ascii?Q?JbzrTLXOyKtIIal3JqYB5t3+G2puy0A6+q43nYcL/WXIihubnE27SvWgzfIi?=
 =?us-ascii?Q?TWU9+rwEloaREedBjiW/KqS+M/WMFT0SNQInryrsW+MfaqflJYdjoBWOQ/YP?=
 =?us-ascii?Q?cDdP2P79F6lpUdGqTbMcmDv4fhgYzphj/p0pXyUmkFGCuBOHQSwGIcaWr6aK?=
 =?us-ascii?Q?/S6IrGpEES3pZ7IhS0IfA+t6On6RjDgP9GTKIKRtqn6yhfaI419V+WualJhH?=
 =?us-ascii?Q?NCUN4uIlbV2m+jZ5N8KLAaP2YUt8BnoIWei5lhLAQ3tey/bOjGQXwVREJLua?=
 =?us-ascii?Q?a3H5pqopd1ypcU4aurtJ8q8ah1Hspm0TgqutsbJrGvz6oJECCZ436wdpBNNf?=
 =?us-ascii?Q?TUAeJ7VuYn5vDEgcK4kXh/NjllLmziJKih1EvQjUwanms7W9f/dtWV7IA43q?=
 =?us-ascii?Q?2c29UxvrOMX36iXIOCnv3Zy7DtH/WczV8rTGb2KKwdKk7H8CeJtd1T4QbNWj?=
 =?us-ascii?Q?Y9jJwzk0UhNEA4zDcY6R3kSb3/cAbv9L+YLYGjNom3s+zc1vz5PFYnRA5G2k?=
 =?us-ascii?Q?niwfyBfa6nTgl27BUJourAknkgriDPMqYawY4ZDSordVE3zMDQvJEEX3t4fZ?=
 =?us-ascii?Q?WhZBMroxm7TTmgbCIwvtGExTYx5cG7G0M/dnhni1PVGVIpw06o8NKEzE+VU4?=
 =?us-ascii?Q?G43VS5wOS3tDqSbfT/X+wIo0eIACbaL4/ZWXuU8SQcUVNGbkM8VX7bFCRfMS?=
 =?us-ascii?Q?u6hBy3O+xRquCSpnYzlcFsFiMt4qFVwxVJOqocsctl/gOmteTseD87PrjwAU?=
 =?us-ascii?Q?BpNYt8G3gkkHP/Y0VU+QbOKVYJsvzzs26C3tvV+XUv5JyKuX/J+mqNiwwzxt?=
 =?us-ascii?Q?2Qr7Ceq+rI7URS7MrOMx5GAUHB/2abU6Ltg5FPHq8jTJzFe0O3/5igLV2HOl?=
 =?us-ascii?Q?PVDbLxlxPbTE7V627l/nn2ocGc4oc/Gdc7tHSl9B1Kg8W5G4J4nJXPkWAcTf?=
 =?us-ascii?Q?ZFwSlStoLghF2o0UYtTGlzwuTJdiOf/aQOu1y8jryELU+vi13R9MYlX3f09X?=
 =?us-ascii?Q?Al57SIMsYBqMYHA/2u+ONEo8jDwW4WdPcibt/5etn+DZ5emyl+06AwIoL4gm?=
 =?us-ascii?Q?7owGKzI41TBb64P0YyswcVBGvdn7ESijT+oz9y/qAYePn9KCcPsu7CK+cq1O?=
 =?us-ascii?Q?JVm8vTViCjCcAkvs+bShnqgeGjqPJcjzyimJrQJBuDccM+5ja9XLchu6B1RK?=
 =?us-ascii?Q?IU8GwFtzF+O/iExkayTbfo8SFQ0VK20oWl2EomsxgWaNovIyoE9cEypcUpZL?=
 =?us-ascii?Q?qw=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b7175b4-5491-4153-2e11-08db2047d4f4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 02:41:49.2315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UA9hpCiv6G+1j9lK5lxi0qqZ01zp/FCR3ixRtIaVHixsqYf9frsApB/MJQEqt+WVnePM6BMKOutylGE1jfy3Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1313
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index ded7506..ff348eb 100644
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
@@ -404,12 +403,8 @@ static void __init ms_hyperv_init_platform(void)
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
index 03e3251..9f7ba60 100644
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

