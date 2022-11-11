Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467C562539C
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 07:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbiKKGWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 01:22:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiKKGWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 01:22:34 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11022025.outbound.protection.outlook.com [52.101.53.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917E9725C4;
        Thu, 10 Nov 2022 22:22:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LUnsIXiYZLhwz9aFOQ8tRJim8iVuyIb6xTkFIXp5WxA9YwjFO12M9NPuRkvD5/SSkEGf3/3S8ChGzbSxfHUFUtJ2vBzm0NIACVBmLqFo2FCyiKusQsBaj5suJ3DNlWLqIOoOtXpera/XEWAr4ZvljT6ARPXteqH8ztiCLDVfnzzMeTTHPhBymcYa6YeEIfxQ+hdcGEBqfQdAdZTa8DWi8gwD8ReknLjsU1DmhFLKzwkBEm1JDMErHdpM1fEPDIgGwPkKrqPindYPjrba0fUpYoga/rYFAlf+dA9iPlLHdk5OIMcTe/rZOyU6vcSI4yseJgUZDRPbVVWJVMpCJHINLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rS+XEDLCYXK3kG0pGvcV2b4OXTcv8/63SxxK34hw9ig=;
 b=aqsCHCl/sNXv7XM6LZQm6xn7ffGXXVs8e8vIXPQqHGcAK0Gs4v2srCwnReCd1pB9IXDT6ha6AVU2Rgq87UvnV5Ll2qcgCnp6pQfWyvXtN9Q1jcz9jFDMHbGPb3VsqA5NAXzDtA8IDqseJ+vTl11Rzjphjv0ItuhnIuiKi0ta2oItFhWZ0AhN2JDryzo/RnnQgAlTyUwnSlpgIqT+3UsrF0Wnfn2JuWLSoN4TLGb47GVkWCtrGPDmqLiVO5LSYFNyCoiU5sWI4cB7OKcnHYMGSgdynKsbh54ATpOjYGbyG+dGm62zZ2x0qCjm9FNf1K5w3RbmgYUUE2ZZTtgjLgbn7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rS+XEDLCYXK3kG0pGvcV2b4OXTcv8/63SxxK34hw9ig=;
 b=dkfcZQMZ/ZE/ZQYihrlVDOpnaJvMOpmEWpKIWTlXNx22l5UwiajeCdsSkFYLgYVZ9vkK2xOFKY+5T8UEEhtczI2uplebaU1sIOv8oxj6DGXD1m5I6VUZUpHMULxJNMx0Yh7KYjZQFjXVmGBNCXKLGnvUYAakXz4DZW4DODLmvnw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.2; Fri, 11 Nov
 2022 06:22:23 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%7]) with mapi id 15.20.5834.002; Fri, 11 Nov 2022
 06:22:23 +0000
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
Subject: [PATCH v2 06/12] swiotlb: Remove bounce buffer remapping for Hyper-V
Date:   Thu, 10 Nov 2022 22:21:35 -0800
Message-Id: <1668147701-4583-7-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
References: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0329.namprd04.prod.outlook.com
 (2603:10b6:303:82::34) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|MW4PR21MB1857:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e331c76-0886-4c76-7d95-08dac3ad1827
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W4TmHbEIKU4oZVirCCHWFzDxYYsKPURdYKHmNiBvnLcQdDF2jlFaIHsNIe48ZKgof8KzPK9WEoUJN4tLepWy4QEt21qjyWkIFPHQlQxMRDi7wxOa0tfQnubdHaz3JT6scVxmHZ27awBllP+A2eu3h8IJZ6vhHjVNYHVsmdu58bltSUAu+5u04q8bQgnhqZy6+e5GV+NKFH+OekfrDcTEDTcaRa3eqsWtUVBmK7Ljoh19+K/0pwjAy0fpVhSXtwg/QkZRfx4L2CJ2TZhzZT7uZwtheYd6ke7SnWmfUhip6BfiG6F2QCBbgTyZJm7GkzpZ20uRuFuy6pzEKUuykXEulUg64KJvA1F9r829wgWtfi5WDCNIfysfSz2vyuDm4z+5FoOdW/OJRmLrk5DB89k0oSJTkaKf8+Z2zqxmGCo1ivmoX/Wvtrd/8Y4qww94l4chBy9H86laDPbE9hZIbnoMNLd9douePTxFg25wtNZrUbdHq0JlX8kNRgEBmLSU7sWO1t2dRi6Zkebro36riTXnTfrza2PDn1GzRSrlAvsxJoyYRTzNUj/q/Zi1yuNXYbRZqr9jrzZzKmXs+wqirFwUd9b3E61E6mzVvPRqdbNNVM1LXKoGkS1IZNR9CwvXXdVQF4nOQnyL8VEoEjsEo7W9Ve2sg3YlR+p9fFIbTz2b5DFESSiZVa4lvrfjnMM2LtTdOj4lOXJZhLk0uoaBfArn85A8CCOXXSEw91VnX50fK6n2GiFiGfx1SdS0syzsTiiZDZhtvPjqo8uakipUMJz2ACiHCXO3QUwCNdSSOb2osu58+NpqtSgx69rHhuLsTbU/DZSjs4m5NQaGKtiznXjyxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(451199015)(83380400001)(52116002)(26005)(6666004)(6512007)(186003)(38100700002)(107886003)(2616005)(7406005)(2906002)(316002)(7416002)(6506007)(10290500003)(6486002)(66946007)(66476007)(5660300002)(8936002)(41300700001)(8676002)(4326008)(66556008)(478600001)(38350700002)(36756003)(86362001)(921005)(82960400001)(82950400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PqeMroTCtrxVCX0NySwSDl7NdrpiMg0/7annXQ30e0qJiob7dMjVGkX7Q/rd?=
 =?us-ascii?Q?dm39VObLKCRpzx0AxPJCUOzvRK++EsEW6/G+EdeZXZkQeBwzrHDAf7bSw3x+?=
 =?us-ascii?Q?rFzhGPxshkQty5yNPGFa8JV2oRbJCjGm8YKTcew9QqjxTS1PBUBfyw2E841T?=
 =?us-ascii?Q?vq2SWKBVvUB2FGCYnfhBkfmCoryGjMY1D/ffUbzdL+XCOL6y7zk3V7/JUr1S?=
 =?us-ascii?Q?BCCNgi1sQaeNmxVEXXAihuQ5ob7LdmhJOtTzMyM7uMoku/yBEnUHGQgjcAsE?=
 =?us-ascii?Q?TqCa6wl7ENVrx/DlPAcpTvy5HFJtaOiPFD8TLGKfioXBqkGHHH7pRQN9qLhj?=
 =?us-ascii?Q?5gt/pisOCxFI0CpCNHhNQ/YRKzJZJbEgJHVBOn8qAWWbrK2u+smaPqh/YgDx?=
 =?us-ascii?Q?l1YNXFSlK+tJIayNA98tBHM7fUQ4p8hX53GOqpZkwpfer1hEYSwtCGlcqTvw?=
 =?us-ascii?Q?Y4Y+jsXHLVpXpbEgpQVlrw31SvNtCi+I4tlCOc9EvfZfpBGqGmGgcb9V7eN7?=
 =?us-ascii?Q?kSf4fqpDr/VHAiz9nnUM2WKo72wnV7UGa5GDD0gz7zui13X9qkk+OOmdJ9pX?=
 =?us-ascii?Q?LqSp15/zaPcfSEeaUO9XvTBtKXGsMErrEf0UIBmbQhLxbWecE3uXbet587cg?=
 =?us-ascii?Q?0ZYvN1kAHeKCq/d5GQ0+30bEHIsc48S20o+S+1sY+5MpI+rKJ2AsB8eAted7?=
 =?us-ascii?Q?nwHKpbFUv8PlUQdxo8eem5/wFWcLAZmc2yQZdq7S6FBqlTok3DoGfsGMr0Ld?=
 =?us-ascii?Q?aEH5td4p1FBqYq8fpkAX2ZA7mdI/FDWfzI2+MU5I3GThxV5eX2lrHUh6age6?=
 =?us-ascii?Q?Bg9/O+OSfPz6dIFA458n49xkWA239X265BXxaerRqWxLVZxoBnjxuScHpspV?=
 =?us-ascii?Q?34EFl8q70F4nu4u9RPe+AAKdIVaugGPocV96y/yJRg0oHTiXHL6sn//RrGsq?=
 =?us-ascii?Q?rnNtnw19ELxoBGnQF9JBh+8XiLb9/5Wytk3a2JRqZ9//gcZdm8VKgr1iV6fK?=
 =?us-ascii?Q?/Bn4xgUkKwZHH+FBShly0L9RjZebfV/H/d4AcE150bfFKEaBUgRuVmdtnRm4?=
 =?us-ascii?Q?nx0Moui1M0QkM8a7xwDjEn1AgYwxAT/544VVpGXzk4BZA4W+JuxmMOEErUxm?=
 =?us-ascii?Q?KlmiO2C0G0dg9cHJM46UcB7nO+EmbFeXgHtVQ314P5BrundG4eOGR4JqGYKi?=
 =?us-ascii?Q?UDFxH+s18eNVo1vBmPtgNCTUCV/+Nvi6M71DYodO08hiWDhqe4F7SN+iuedj?=
 =?us-ascii?Q?kjvHvL34WMbBM+CiG9jgnts9/YHdMMCJdg9RRIOUu7uI7lTqbvLFyYXYBpje?=
 =?us-ascii?Q?zqtJJ61QNA+GJSLDclbupgt+uFwpmMbCHPjsZ31XtXb0QXzdh5B1PZ4AxtCx?=
 =?us-ascii?Q?B0w5iM+dzn7Cmy4kpI5BPg0R+HrGyIP63PQmfzIK08hnMJIUAzBPfDUowmhs?=
 =?us-ascii?Q?sp8tn0+krbgz5sR9yYYL6JwqPbXQN2zEkAi04NMvBNAeh8PmopnYdkz8xlpS?=
 =?us-ascii?Q?APE+mGy+vT/yrT4eFwxpxA+GwhU9ZZYvlVntNyIbCPmibGGnMcCP/oQru9H/?=
 =?us-ascii?Q?BjMFYcSpzWHIjcQn5X2Z7nBI5kMoUb2FLim32crFwUeiCKw/9ukj9qrDrXQL?=
 =?us-ascii?Q?Lw=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e331c76-0886-4c76-7d95-08dac3ad1827
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 06:22:23.0389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1x0Haz/BZbKe+uUPNRDlkzGZYIOPhxG92e1ur4og4bvBdLUmtoe+YBVuFgUVJYuBHdNAo+0cgQurOgM9rxHzeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1857
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

