Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54E360678C
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 19:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiJTR7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 13:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiJTR7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 13:59:20 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022019.outbound.protection.outlook.com [40.93.200.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D681D1E8B84;
        Thu, 20 Oct 2022 10:58:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ntD69YMwVlhlHi4MeDxs2qFMlOjQDtrcsAjRUPCfSjzVvuVc+gnkmRiPfdY8pIgTKGRmnAeAxQzwsWLGZ8VeBTOSYfBXyRa5KIwg4eW8HxTAFomcUDUryC2C5VPO5IT5iYVtZ85A9qKXGfbD1k8z929ahQz2tNLk829ag0+qXDuzjNM9tipogt/1F3iyFH+PrbfA9OXpcliEVLoY3A9Eo+D3oMo85f+b+cIzEaHRv9o/FG2F1Ccb68wKZ5rxeXGq3yMZxAEy5OwBOW89QfCHSgw4CXbWY8rtkN3Pi+eTR6urw1K4TYhBY9JIa16Uv0dHXY/JpotV+Amwz+LZz1WFJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ENDox1yNNiJUCaK5Df4regkXvUQPQmoTwmsAWyaE8R4=;
 b=PihloYYYAirtYppbYxfv4wecv7uYMOPBxmAVTLxRuCHJl3/SQodvv9RnzKFxm+rdAAVAryWZSim6a6Jg9J29BwLc0AcrUIsZRA0d7tseXyKMU/tgOUekknEtRdjqH/nZLad6qGHbuXC1MSxCRl88WCL8xrfOrQHv68DlcFX/bElVN+0T+DCAz105cRbzuleDwZx89JdGVRj8wKSmL7DKwHuCF5f9rEYmK9STF7wvj3CxaYuOvlzsmV8/tCn+42CCsSXaaPJkSIWHu+yvkrOcaVRj5zUlPoXat1+ZODdy8/Nzt6FshG5/J0fiy6CKtV+sfBZ8GK42gq6/xc3fALwBPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ENDox1yNNiJUCaK5Df4regkXvUQPQmoTwmsAWyaE8R4=;
 b=NsrschHCTTESvbFDjfHKotLXVAlTyU85Gll5laPetowRtlba/ZcqqzD08irS7YZA6HFQINSLQhH2dNxSXQ5d33zXolRNG0FHhOUGA5je+Isw1QVvwZjNCJj7ib3jrG+93XxKAlkNeILGIHZRqxN9s7AIbWimKljqZKeCno08Y54=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.17; Thu, 20 Oct
 2022 17:58:34 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa%3]) with mapi id 15.20.5723.019; Thu, 20 Oct 2022
 17:58:34 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        luto@kernel.org, peterz@infradead.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lpieralisi@kernel.org, robh@kernel.org, kw@linux.com,
        bhelgaas@google.com, arnd@arndb.de, hch@infradead.org,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
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
Subject: [PATCH 06/12] swiotlb: Remove bounce buffer remapping for Hyper-V
Date:   Thu, 20 Oct 2022 10:57:09 -0700
Message-Id: <1666288635-72591-7-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1666288635-72591-1-git-send-email-mikelley@microsoft.com>
References: <1666288635-72591-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:303:16d::31) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|MW4PR21MB1857:EE_
X-MS-Office365-Filtering-Correlation-Id: b8b55008-6d9a-4899-56d2-08dab2c4b4fe
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fZIsvSuy0KKw6tBT/h2JBUom5D5q3xjx5OI/iBGOwDPoAf2MqsL6xTfGuOVuUjcrX5KqTIqiwxn0bmMslYMVgIlAybwCnl4Fyhih/lyblq1TMr6YCP9G1aWX7/W2JQnU9RtkXJa3P/BlyTZEA1zIIyQfztFxGIYBVnj2m8tD/1xLct5Gth0ltnDBrdqE2PDukpPMeNxr1nUXaFha1GcBX01PdVG3C4SKCcVzdl0nktn8pOi1rOE8f71yIXp1VVulygc2XqIVmDfeywgDBlHX9RVqBu2BNUGvrBniPOCOmJdxlm3uh0FywSwojq6+EiYzLke5MwfJhMHkwSMyTvxFGbopAFBiUd4A6BN84M0gunrCaex9+7u6xqtajkI9ioMi3i0edQPsQL3u0BdtZuhfmogFFlolR5ZA9lMH3MDS3dwOPl5HdI0+tfM3hm/Tk+LICgRNXpy9pl6cNmYA24LTbZDeS4rdxtI53dBXEeXgCOWrcpM0Nv0oQnktixSc/hvM46ERDnJENsXi9sS153WBHP5Q4JacAqnwlWgxNH4m/npgBB+4LBLfy3vFDe0CvoGnFK6Q8XjdAOrHuoLSrlrhk1MdNDBhIAfZhHDp5WRDUq8mT2QIZEuqUocSm4wP1Bn9OB8knJnLUf5s1C+qBIv4j4rRs6DBESwhJg5nvaresfPGhv51oGl26/L5R23wWD+sudXdTXsj+r7aePhfjyNoAZJV7vg1KtAHqs5hmY2cCERTCZxodaDcNxxzQt9Sivd/5+sv7wvzoO367rwjzd7gLbPkiW22eAQ0LlsyPYQA/1iO2rse1TpIGGB5u/b0FfC6Svbjje+9Ma4ve4CMxBV2xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199015)(186003)(6512007)(6666004)(107886003)(83380400001)(7416002)(52116002)(26005)(2906002)(5660300002)(6506007)(66556008)(41300700001)(8676002)(478600001)(8936002)(316002)(4326008)(66476007)(66946007)(6486002)(10290500003)(82950400001)(36756003)(86362001)(2616005)(7406005)(82960400001)(38100700002)(38350700002)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4AjrSsaVTrLb8DAHK7ZKpE+uUcgFc1kVRA/JIbbrT3qZC9tATK2W4BvEhMOV?=
 =?us-ascii?Q?SD/l5pyS4giA5lz6G2Yso+0XuFWf4eIQl+tNT0pOrret8CnMg7tzE7SlItJp?=
 =?us-ascii?Q?pOkFWGlTa5yTosD0CCFCfZv4547fGWLjKC2ZYA3y5ulDdJcyBSDEYmLdlmCT?=
 =?us-ascii?Q?qHve/FkUp1IfP/+LDsh5nNZzx+OJ+5cSwKyFA7aHkQsqKfLA9nHMENSfECNy?=
 =?us-ascii?Q?E/+keSz+Skh6kGDKLZtCrEtrYah/+nyQi3EDV/E6UnOmMSlV00snhtS+8q3J?=
 =?us-ascii?Q?HXmHV7wproDb1YVTK9Jp3E6ImeGUekwor+kGG+ZrD4ZBucmB/dMSAHJWZNfd?=
 =?us-ascii?Q?L/kMXdosBWoIiug6kkJZC7E1PQkTmNm8O8HqfF7HJ18xhTDQESFYRdwVFAwd?=
 =?us-ascii?Q?ovydAcqZKfnWZUBlD0sAxAbGNm+IG+1MC7BtTjc1rwApkqgfnbYOAZt+nkkg?=
 =?us-ascii?Q?zDTWEnyb1spw2HY/MHpMs0WxQ/Kcor48HEM1x2GyIiHpvWXdG4iJ5fHBGbqP?=
 =?us-ascii?Q?KPc4iBupSPGkcivvkN0M3GB01h0+yfFHiGXnSen2eLMCLxBtIv5hI4UUWsPn?=
 =?us-ascii?Q?Ig/ExBeGHcfqYQmkGbUpUJP8vXdvbBaHsz6QRCq2t7UKyJw2r32YFtGCTSC6?=
 =?us-ascii?Q?rxC3b6DofC0SpEBvdZEKAlfx4ZkhttWQWq+rC5OCwrFMHhgQujBJ2M40wkAU?=
 =?us-ascii?Q?lBJHIMaRIwoXuK/neiwvBwUIdXD11HUfKLNCuFtwS8GTnOuD0ghOLmj22ZaC?=
 =?us-ascii?Q?phPljpqESgU2aQVpVvvRuCVH5PP+ylGvTFDqzreRdI+u605afhFab3Odx9e8?=
 =?us-ascii?Q?6pdMdTqGHPqLFgWBJ+SkaKtTrd66nIVztf4xRAv5PGVec8MQ5I2eSaut52mf?=
 =?us-ascii?Q?Z10SsgbsI4RK2e9si5dBVD2Y3GNDaboFg6WYS5jx1OodtPChsGvzBRDdJ72M?=
 =?us-ascii?Q?VtO3/FTMZmyfogTAIF7eJIIwCjawRPs0jDOtWKuFEXXMtruWQXzAJAWZljtm?=
 =?us-ascii?Q?1h3/H66RH/pfBxHByrfsk3k6mxuog/S4XsfPmJCYpPnNCZD2VE9Fw6TyjRaj?=
 =?us-ascii?Q?WOpIwzmu8jyDr0eFADI4TwdE35WGzs0Dumqp85/euNOxo8o9L2unS+vtAAI5?=
 =?us-ascii?Q?tTXBUWdZ4MwWd8dArYg/8c3U3b6a35AVUtV39sSrzYtl+VUUsGt0eKvDmJPx?=
 =?us-ascii?Q?mOlCdkjy1Ds/OSSPQ2fNQXLXbr64gtEMHywgh4Bgu0JkV45YHgjNOTVjtS7k?=
 =?us-ascii?Q?38ofHjXjhjOpLhHpmt5J79tpk3nVLdu2F3COso2eB/jpTLogwXct5qWtGFgN?=
 =?us-ascii?Q?db8S9DNODjKu+/k8sGnl2aUtv6Wrehmim39uBWvK03CYfJKAYuRbpmXddNrH?=
 =?us-ascii?Q?WFFe/kc3+e3tns75hOCdsPchDq+qF4ygJ16YuRYiWzS4sbAE1LK5o2ivyeVy?=
 =?us-ascii?Q?bk/fHk2ItiInwp2WisI0B1p6KnqD0PwlOe7BAzkii+D+e+MJPG9bmWpiA9vD?=
 =?us-ascii?Q?WeaIH6oFcUwPsQr0MH1ebJl9IkTGjKoR/vfr4dO8fhFNTO4x63s6XYktzjMO?=
 =?us-ascii?Q?zCp6/uMGFd6z7eU1t7Dqnom9VY1+HCRXCy/1l62n?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8b55008-6d9a-4899-56d2-08dab2c4b4fe
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 17:58:34.8279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7+k2xcwBEuHYAzVIpdrBUNLBCcRHL0tlQPTLHJTZJlMx+jIv1h9MYHv+pD/UknQsrQQiAPh9W/A7USYenE3A8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1857
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
index 339a990..572abf6 100644
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

