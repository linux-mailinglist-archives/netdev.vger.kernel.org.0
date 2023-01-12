Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC1F66860F
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 22:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjALVuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 16:50:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240995AbjALVsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 16:48:42 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021016.outbound.protection.outlook.com [52.101.62.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE479B8D;
        Thu, 12 Jan 2023 13:43:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIK4HxlCOGyTrnVL/Lx9rAjwSOk1RDNignEbIPHZcCwliBGWRDatvQ4E27lkYp2N+kWxlJQ+n0Y6CU05yiT1FueBWB3Ct8yhkulmMn/m4cRcTZ3wqHzyrjfdNJHupPS3sYP4X7ig4pxNY+QQ9/zal0iSfEbjgM4OSrbs8OagFJBcy1PHrYCK3k4eVOAr9LzVIl09xpS/2e2miYq10VL3/0XhJGoiM2MjIhWKGeXylbradkii1i66g/WFprlMM7tEFekNP0gZEBesg5SjJc8KC9TMZrCeybIn0YGiRwg2YVD3qLeDN3jovLD4Ke0wQUiJPgvXxbkQNSI0xryJqMBmEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6JWQ/92mEMbQRW1OTdJmOHi1aMj5quDHBTi6Pczb/2E=;
 b=WrLI7i4wGw+9HJYq1WTnFJGWwMPndEfH/QSQmVgaRvwuY3W2xswLxttAip99KNTSPyP1rMfoEjVHIWzMvuIFlqrePc91IVwsOT3hi+bbIkyW2DXKZH4QzCDDa1pWOSfFX3+rqMKPZ54PFi7U+BBUGQETa5j5dU810M7I/cdE0voMV8HLf+0BUTZ7eQOdJzxplhxRgDPRxqNZ1OUutPRg/sISZT3uRDWgYLXsDFLauA1dWlKCDoqW3WQv7sx6hRUcXNGl9rq7OyJ6f7dUEFDfLUENEwWXMsf8EWafpZh/a2hjrXfUD3CN/0NGyKCLWeRw2UbyV7ej7e7FRDtMh32Qhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6JWQ/92mEMbQRW1OTdJmOHi1aMj5quDHBTi6Pczb/2E=;
 b=Y+wxEgjQJhSPO0tT6V8Ospf+fj++Yy3gAROl0qXj6xWAthICsjiFbElM4aI/I1gVsxJiXlPzjt/IPjDVWfyEolDfjM0d/zPmMsaMcPFdYfVIndmwdOAsWSzvw+MKyA89TjpmQsRokxvq0vqeiLCQKZIqXakWxCxwosYHREWIY0U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1953.namprd21.prod.outlook.com (2603:10b6:303:74::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.4; Thu, 12 Jan
 2023 21:43:11 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7%8]) with mapi id 15.20.6023.006; Thu, 12 Jan 2023
 21:43:11 +0000
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
Subject: [PATCH v5 07/14] x86/hyperv: Change vTOM handling to use standard coco mechanisms
Date:   Thu, 12 Jan 2023 13:42:26 -0800
Message-Id: <1673559753-94403-8-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2aa3d2f3-5d72-435a-a97c-08daf4e6003f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k3M2P129sYoCPnnCXhXdNt3QAGP9jtaRW1noM+QOKpDjT7YzBGeOAM2Pl9Mq8MTcEiSPupou5zjN48Ca25E5E2gSn4xylMyFuxse57x4XucbuVnjUrgGPzj6NkGleJ9Q4yutm11tLCXsM4SVZMbotfIjk8AAvEwbqEiL4g3fXQR+3CIJ9ufMyyIik4drOHeocNxIvfzJsEP2IkAcnaWyJpLMDH/ue32tG6vuUtB3kNOTYzIEmNbC27nDfomSe7QpH3veNeaU3dTOXX3FbJQDIygcm18/iYcya7PsAzYN9C+P/a6qsQgCa3fQAwVr/mG116aLgSKpUxe28+ONhk1uBLVEhIa5O2O3HvEPFAdMgsFkHJINIvPoN3oibeAvLOdz2LzXE2CC9gIwmrahPICm1zMgAa7uPvLRdZnGG6s4hcNCibqmMlDcO7gBrZ4FOsimADFwc2I2aFABGPChAms/mCnWFaNLfulSpZbIkgrBKeWchPChdjeLxfbc4Ncmx40X/jLblXj8ImNohfi6Yzq3wAKG4mhgxzEH5PmbVM1T1GLBEjVT9F1elT1vBtUSXG6tK0N45n/W5EEmjU8Bvjb3a5jGSUiJoDNm+8n3w9FMXR3exCbPBvR8KhnqBixFCIXLzOuzy8QfyAjVnakfW0Bsxlz8PX4ptTbqmkTkUWD0KHo2ZyaAWyFT2zaY5J2mkFDJXr6T7c4NJn8fmOJT8K4QQtkkXUjvtPHwxxrjILUFwbf1HarmFejN9NaGeeGZftCypEfX+xzkRkFKmk8ZRwgOqXQgz5rJz3ohTRAFjPtMVkVUt+dV7MzYmCL/rOc6prod4PHmjFXtuddbentK8B/tCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199015)(186003)(26005)(6512007)(82960400001)(82950400001)(6486002)(86362001)(52116002)(966005)(478600001)(2906002)(5660300002)(4326008)(8676002)(38350700002)(66556008)(66476007)(30864003)(316002)(7406005)(38100700002)(10290500003)(41300700001)(921005)(36756003)(66946007)(7416002)(2616005)(8936002)(6506007)(6666004)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nw/PUzBYicY+lEZhi2V3B3adlv2XEPb6nJUDS4VEzglJDsr0zL+T0qj5ZQqE?=
 =?us-ascii?Q?/fvRXNW2vQezPukuAtCTi6ksOAtTncmKB/RT+m98f6YfBDBvVEb5IWQ4Zvay?=
 =?us-ascii?Q?AVm4UYffAPMnVpo8O96g4o8lG+y2YBui9maFb9Wo1bS6PAByYzdPihcA4o77?=
 =?us-ascii?Q?HpdFpcGmIp4QYCOS/MndXIkpPh4cPeajePYdCF2mr8jtnKD11JIJpL/l3ACt?=
 =?us-ascii?Q?sh1O0t5x378T6j5ZTHKO24yzVdfLwgzJ1DbdDHj/z3xfsjDAj+MS0+TWkz6+?=
 =?us-ascii?Q?cqV9ZyZ5BoKJxOXaKRxiMQqrvir4Cd+RiYZW15cu3qNwqcpz0hqxcoEvBy/T?=
 =?us-ascii?Q?Ww+pU/2beeI78dvwkakHFAVPLRNYUTndGvsc4Auw+6l9Xh2Ru+3tWFM/a8Uj?=
 =?us-ascii?Q?9ytPcrbbrlA2YIbSgOE4U8YQ9UzWci+fHETxudMg6IK/oYy4QR1gFOnAyxEt?=
 =?us-ascii?Q?djtpEytB3G6RMOFAGfQoihGRvtMRGvQ45+NbBN7LfCiDYx78sMDY22oEqXNn?=
 =?us-ascii?Q?kal8HhkG06YrVVLKOA0cFdECQSeE/Jjo0S4sdmJFDLXu+qp+CArzaUiQoJV2?=
 =?us-ascii?Q?6WQkTnLW8rl6VANeZRBw/I9HeQ003pBFaPaWzpfXsQV+v+2HcRr4I4qomyeP?=
 =?us-ascii?Q?0sJLQMvlVd54YfOW/ewA9pSSQ7PFnejzeCtj4iK0bpsBmkSAXi1518YszgXg?=
 =?us-ascii?Q?/zrSqpp9vUDTdDUcm7yOgpjN94tESDxID+tDiYIYmG1c7jGB/7G29YH7yaq3?=
 =?us-ascii?Q?C3ZwSWL9z89TzfeCs3PCubwaErNv+tG6wVjp5EBHtfbD3nGe9ACdZHx0we3X?=
 =?us-ascii?Q?wWRhhIzrbMb7U3jIEZxtTGrr8GcjkdR1vdWEDkOVRT6hREzmcI3RiQFzjuSU?=
 =?us-ascii?Q?E0nl3SNRLmYPFY6aGnFkHozZ8KEzC63kmqQWcFqjs+lgcfcaDOsLV7XXCPpP?=
 =?us-ascii?Q?u0XqMRoB/nqJm6EbkCkOGEHnOXYM3DY4msnZBSyfMznq5w1DwDq9WfgZqd/E?=
 =?us-ascii?Q?gSKR5zJUFUYfpDVGUC+QnUUL5K4bgfiFTYaUqd/kgToTrzvHJ4bC8vIdhh3n?=
 =?us-ascii?Q?EMqxx8T1nEuIoW3w9gQh0HUhlQ4vzZJGgzqo2g385FTHCyT/dngaELhOCZcI?=
 =?us-ascii?Q?OrqjNOKLonpp7/jOhdvxkzw3C82MnTVoCRXG3w27okV5luIVocWp3l1ldCuk?=
 =?us-ascii?Q?Vmg7t1KEJJvDCS1QksDv11wBPWu5hSFLvZj+AFoqgc6uBp5PGwzbg941yV7N?=
 =?us-ascii?Q?yQYPx0CpCNncw++urIGIRuHUUQ2TdPkvfW299tU+xdEZSnNasrQdfmcRb21+?=
 =?us-ascii?Q?3zYEveBZkBycvlxv2wC9GIu+nWRS3AaRAe/ExfAh3Xe0SA/nB4UqKQjLvMSH?=
 =?us-ascii?Q?MlMI+mCcW36ME6e2KgewQPAxFMkTLKaDXnrYbjfM+NGpKKYopTQ3/WlZ/ad2?=
 =?us-ascii?Q?B41dyOOW1TKiIkCf0bDWZCLiDVCQSlaEkOW0x5ge8HHK8XohQw4ncNdKVqNj?=
 =?us-ascii?Q?hbc2ePUWGotC6txS5rjndp4TNyq2VrKZdxw/2wXll3kEIhE0f9ZAHA4EMKmx?=
 =?us-ascii?Q?3esgLRVbeDLK8d6msWaZHSZnbEaP13yVgdIceh2/?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aa3d2f3-5d72-435a-a97c-08daf4e6003f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 21:43:11.1892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AlVKuhxhsEGt0vsUqV5tRM0M7McDnghopgnJPjQH3Bbn0a3Ecsa5CClvI1lhg46FW+MI00Kt2ZT/F/iqsM8nHw==
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

Hyper-V guests on AMD SEV-SNP hardware have the option of using the
"virtual Top Of Memory" (vTOM) feature specified by the SEV-SNP
architecture. With vTOM, shared vs. private memory accesses are
controlled by splitting the guest physical address space into two
halves.  vTOM is the dividing line where the uppermost bit of the
physical address space is set; e.g., with 47 bits of guest physical
address space, vTOM is 0x400000000000 (bit 46 is set).  Guest physical
memory is accessible at two parallel physical addresses -- one below
vTOM and one above vTOM.  Accesses below vTOM are private (encrypted)
while accesses above vTOM are shared (decrypted). In this sense, vTOM
is like the GPA.SHARED bit in Intel TDX.

Support for Hyper-V guests using vTOM was added to the Linux kernel in
two patch sets[1][2]. This support treats the vTOM bit as part of
the physical address. For accessing shared (decrypted) memory, these
patch sets create a second kernel virtual mapping that maps to physical
addresses above vTOM.

A better approach is to treat the vTOM bit as a protection flag, not
as part of the physical address. This new approach is like the approach
for the GPA.SHARED bit in Intel TDX. Rather than creating a second kernel
virtual mapping, the existing mapping is updated using recently added
coco mechanisms.  When memory is changed between private and shared using
set_memory_decrypted() and set_memory_encrypted(), the PTEs for the
existing kernel mapping are changed to add or remove the vTOM bit
in the guest physical address, just as with TDX. The hypercalls to
change the memory status on the host side are made using the existing
callback mechanism. Everything just works, with a minor tweak to map
the IO-APIC to use private accesses.

To accomplish the switch in approach, the following must be done:

* Update Hyper-V initialization to set the cc_mask based on vTOM
  and do other coco initialization.

* Update physical_mask so the vTOM bit is no longer treated as part
  of the physical address

* Remove CC_VENDOR_HYPERV and merge the associated vTOM functionality
  under CC_VENDOR_AMD. Update cc_mkenc() and cc_mkdec() to set/clear
  the vTOM bit as a protection flag.

* Code already exists to make hypercalls to inform Hyper-V about pages
  changing between shared and private.  Update this code to run as a
  callback from __set_memory_enc_pgtable().

* Remove the Hyper-V special case from __set_memory_enc_dec()

* Remove the Hyper-V specific call to swiotlb_update_mem_attributes()
  since mem_encrypt_init() will now do it.

[1] https://lore.kernel.org/all/20211025122116.264793-1-ltykernel@gmail.com/
[2] https://lore.kernel.org/all/20211213071407.314309-1-ltykernel@gmail.com/

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 arch/x86/coco/core.c             | 43 ++++++++++++++++++++++-------
 arch/x86/hyperv/hv_init.c        | 11 --------
 arch/x86/hyperv/ivm.c            | 58 ++++++++++++++++++++++++++++++++--------
 arch/x86/include/asm/coco.h      |  1 -
 arch/x86/include/asm/mshyperv.h  |  8 ++----
 arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/kernel/cpu/mshyperv.c   | 15 +++++------
 arch/x86/mm/pat/set_memory.c     |  3 ---
 drivers/hv/vmbus_drv.c           |  1 -
 include/asm-generic/mshyperv.h   |  2 ++
 10 files changed, 92 insertions(+), 51 deletions(-)

diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index 49b44f8..0670961 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -29,6 +29,19 @@ static bool intel_cc_platform_has(enum cc_attr attr)
 	}
 }
 
+/* Helper function for AMD SEV-SNP vTOM case */
+static __maybe_unused bool amd_cc_platform_vtom(enum cc_attr attr)
+{
+	switch (attr) {
+	case CC_ATTR_GUEST_MEM_ENCRYPT:
+	case CC_ATTR_MEM_ENCRYPT:
+	case CC_ATTR_ACCESS_IOAPIC_ENCRYPTED:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /*
  * SME and SEV are very similar but they are not the same, so there are
  * times that the kernel will need to distinguish between SME and SEV. The
@@ -41,9 +54,20 @@ static bool intel_cc_platform_has(enum cc_attr attr)
  * up under SME the trampoline area cannot be encrypted, whereas under SEV
  * the trampoline area must be encrypted.
  */
+
 static bool amd_cc_platform_has(enum cc_attr attr)
 {
 #ifdef CONFIG_AMD_MEM_ENCRYPT
+
+	/*
+	 * Handle the SEV-SNP vTOM case where sme_me_mask is zero, and
+	 * the other levels of SME/SEV functionality, including C-bit
+	 * based SEV-SNP, are not enabled.
+	 */
+	if (sev_status & MSR_AMD64_SNP_VTOM_ENABLED)
+		return amd_cc_platform_vtom(attr);
+
+	/* Handle the C-bit case */
 	switch (attr) {
 	case CC_ATTR_MEM_ENCRYPT:
 		return sme_me_mask;
@@ -76,11 +100,6 @@ static bool amd_cc_platform_has(enum cc_attr attr)
 #endif
 }
 
-static bool hyperv_cc_platform_has(enum cc_attr attr)
-{
-	return attr == CC_ATTR_GUEST_MEM_ENCRYPT;
-}
-
 bool cc_platform_has(enum cc_attr attr)
 {
 	switch (vendor) {
@@ -88,8 +107,6 @@ bool cc_platform_has(enum cc_attr attr)
 		return amd_cc_platform_has(attr);
 	case CC_VENDOR_INTEL:
 		return intel_cc_platform_has(attr);
-	case CC_VENDOR_HYPERV:
-		return hyperv_cc_platform_has(attr);
 	default:
 		return false;
 	}
@@ -103,11 +120,14 @@ u64 cc_mkenc(u64 val)
 	 * encryption status of the page.
 	 *
 	 * - for AMD, bit *set* means the page is encrypted
-	 * - for Intel *clear* means encrypted.
+	 * - for AMD with vTOM and for Intel, *clear* means encrypted
 	 */
 	switch (vendor) {
 	case CC_VENDOR_AMD:
-		return val | cc_mask;
+		if (sev_status & MSR_AMD64_SNP_VTOM_ENABLED)
+			return val & ~cc_mask;
+		else
+			return val | cc_mask;
 	case CC_VENDOR_INTEL:
 		return val & ~cc_mask;
 	default:
@@ -120,7 +140,10 @@ u64 cc_mkdec(u64 val)
 	/* See comment in cc_mkenc() */
 	switch (vendor) {
 	case CC_VENDOR_AMD:
-		return val & ~cc_mask;
+		if (sev_status & MSR_AMD64_SNP_VTOM_ENABLED)
+			return val | cc_mask;
+		else
+			return val & ~cc_mask;
 	case CC_VENDOR_INTEL:
 		return val | cc_mask;
 	default:
diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 41ef036..edbc67e 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -29,7 +29,6 @@
 #include <linux/syscore_ops.h>
 #include <clocksource/hyperv_timer.h>
 #include <linux/highmem.h>
-#include <linux/swiotlb.h>
 
 int hyperv_init_cpuhp;
 u64 hv_current_partition_id = ~0ull;
@@ -504,16 +503,6 @@ void __init hyperv_init(void)
 	/* Query the VMs extended capability once, so that it can be cached. */
 	hv_query_ext_cap(0);
 
-#ifdef CONFIG_SWIOTLB
-	/*
-	 * Swiotlb bounce buffer needs to be mapped in extra address
-	 * space. Map function doesn't work in the early place and so
-	 * call swiotlb_update_mem_attributes() here.
-	 */
-	if (hv_is_isolation_supported())
-		swiotlb_update_mem_attributes();
-#endif
-
 	return;
 
 clean_guest_os_id:
diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index 5648efb..43bc193 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -13,6 +13,8 @@
 #include <asm/svm.h>
 #include <asm/sev.h>
 #include <asm/io.h>
+#include <asm/coco.h>
+#include <asm/mem_encrypt.h>
 #include <asm/mshyperv.h>
 #include <asm/hypervisor.h>
 
@@ -233,7 +235,6 @@ void hv_ghcb_msr_read(u64 msr, u64 *value)
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(hv_ghcb_msr_read);
-#endif
 
 /*
  * hv_mark_gpa_visibility - Set pages visible to host via hvcall.
@@ -286,27 +287,25 @@ static int hv_mark_gpa_visibility(u16 count, const u64 pfn[],
 }
 
 /*
- * hv_set_mem_host_visibility - Set specified memory visible to host.
+ * hv_vtom_set_host_visibility - Set specified memory visible to host.
  *
  * In Isolation VM, all guest memory is encrypted from host and guest
  * needs to set memory visible to host via hvcall before sharing memory
  * with host. This function works as wrap of hv_mark_gpa_visibility()
  * with memory base and size.
  */
-int hv_set_mem_host_visibility(unsigned long kbuffer, int pagecount, bool visible)
+static bool hv_vtom_set_host_visibility(unsigned long kbuffer, int pagecount, bool enc)
 {
-	enum hv_mem_host_visibility visibility = visible ?
-			VMBUS_PAGE_VISIBLE_READ_WRITE : VMBUS_PAGE_NOT_VISIBLE;
+	enum hv_mem_host_visibility visibility = enc ?
+			VMBUS_PAGE_NOT_VISIBLE : VMBUS_PAGE_VISIBLE_READ_WRITE;
 	u64 *pfn_array;
 	int ret = 0;
+	bool result = true;
 	int i, pfn;
 
-	if (!hv_is_isolation_supported() || !hv_hypercall_pg)
-		return 0;
-
 	pfn_array = kmalloc(HV_HYP_PAGE_SIZE, GFP_KERNEL);
 	if (!pfn_array)
-		return -ENOMEM;
+		return false;
 
 	for (i = 0, pfn = 0; i < pagecount; i++) {
 		pfn_array[pfn] = virt_to_hvpfn((void *)kbuffer + i * HV_HYP_PAGE_SIZE);
@@ -315,17 +314,54 @@ int hv_set_mem_host_visibility(unsigned long kbuffer, int pagecount, bool visibl
 		if (pfn == HV_MAX_MODIFY_GPA_REP_COUNT || i == pagecount - 1) {
 			ret = hv_mark_gpa_visibility(pfn, pfn_array,
 						     visibility);
-			if (ret)
+			if (ret) {
+				result = false;
 				goto err_free_pfn_array;
+			}
 			pfn = 0;
 		}
 	}
 
  err_free_pfn_array:
 	kfree(pfn_array);
-	return ret;
+	return result;
+}
+
+static bool hv_vtom_tlb_flush_required(bool private)
+{
+	return true;
 }
 
+static bool hv_vtom_cache_flush_required(void)
+{
+	return false;
+}
+
+void __init hv_vtom_init(void)
+{
+	/*
+	 * By design, a VM using vTOM doesn't see the SEV setting,
+	 * so SEV initialization is bypassed and sev_status isn't set.
+	 * Set it here to indicate a vTOM VM.
+	 */
+	sev_status = MSR_AMD64_SNP_VTOM_ENABLED;
+	cc_set_vendor(CC_VENDOR_AMD);
+	cc_set_mask(ms_hyperv.shared_gpa_boundary);
+	physical_mask &= ms_hyperv.shared_gpa_boundary - 1;
+
+	/*
+	 * Mark the vTPM address range to be encrypted when it is mapped
+	 * by the vTPM driver since it is provided by the paravisor.
+	 */
+	ioremap_set_encrypted_range(VTPM_BASE_ADDRESS, PAGE_SIZE);
+
+	x86_platform.guest.enc_cache_flush_required = hv_vtom_cache_flush_required;
+	x86_platform.guest.enc_tlb_flush_required = hv_vtom_tlb_flush_required;
+	x86_platform.guest.enc_status_change_finish = hv_vtom_set_host_visibility;
+}
+
+#endif /* CONFIG_AMD_MEM_ENCRYPT */
+
 /*
  * hv_map_memory - map memory to extra space in the AMD SEV-SNP Isolation VM.
  */
diff --git a/arch/x86/include/asm/coco.h b/arch/x86/include/asm/coco.h
index 3d98c3a..d2c6a2e 100644
--- a/arch/x86/include/asm/coco.h
+++ b/arch/x86/include/asm/coco.h
@@ -7,7 +7,6 @@
 enum cc_vendor {
 	CC_VENDOR_NONE,
 	CC_VENDOR_AMD,
-	CC_VENDOR_HYPERV,
 	CC_VENDOR_INTEL,
 };
 
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index 6d502f3..010768d 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -172,18 +172,19 @@ static inline void hv_apic_init(void) {}
 int hv_map_ioapic_interrupt(int ioapic_id, bool level, int vcpu, int vector,
 		struct hv_interrupt_entry *entry);
 int hv_unmap_ioapic_interrupt(int ioapic_id, struct hv_interrupt_entry *entry);
-int hv_set_mem_host_visibility(unsigned long addr, int numpages, bool visible);
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 void hv_ghcb_msr_write(u64 msr, u64 value);
 void hv_ghcb_msr_read(u64 msr, u64 *value);
 bool hv_ghcb_negotiate_protocol(void);
 void hv_ghcb_terminate(unsigned int set, unsigned int reason);
+void hv_vtom_init(void);
 #else
 static inline void hv_ghcb_msr_write(u64 msr, u64 value) {}
 static inline void hv_ghcb_msr_read(u64 msr, u64 *value) {}
 static inline bool hv_ghcb_negotiate_protocol(void) { return false; }
 static inline void hv_ghcb_terminate(unsigned int set, unsigned int reason) {}
+static inline void hv_vtom_init(void) {}
 #endif
 
 extern bool hv_isolation_type_snp(void);
@@ -239,11 +240,6 @@ static inline int hyperv_flush_guest_mapping_range(u64 as,
 }
 static inline void hv_set_register(unsigned int reg, u64 value) { }
 static inline u64 hv_get_register(unsigned int reg) { return 0; }
-static inline int hv_set_mem_host_visibility(unsigned long addr, int numpages,
-					     bool visible)
-{
-	return -1;
-}
 #endif /* CONFIG_HYPERV */
 
 
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 37ff475..6a6e70e 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -565,6 +565,7 @@
 #define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
 #define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
 #define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
+#define MSR_AMD64_SNP_VTOM_ENABLED	BIT_ULL(3)
 
 #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
 
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 46668e2..cd7f480 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -33,7 +33,6 @@
 #include <asm/nmi.h>
 #include <clocksource/hyperv_timer.h>
 #include <asm/numa.h>
-#include <asm/coco.h>
 
 /* Is Linux running as the root partition? */
 bool hv_root_partition;
@@ -325,8 +324,10 @@ static void __init ms_hyperv_init_platform(void)
 	if (ms_hyperv.priv_high & HV_ISOLATION) {
 		ms_hyperv.isolation_config_a = cpuid_eax(HYPERV_CPUID_ISOLATION_CONFIG);
 		ms_hyperv.isolation_config_b = cpuid_ebx(HYPERV_CPUID_ISOLATION_CONFIG);
-		ms_hyperv.shared_gpa_boundary =
-			BIT_ULL(ms_hyperv.shared_gpa_boundary_bits);
+
+		if (ms_hyperv.shared_gpa_boundary_active)
+			ms_hyperv.shared_gpa_boundary =
+				BIT_ULL(ms_hyperv.shared_gpa_boundary_bits);
 
 		pr_info("Hyper-V: Isolation Config: Group A 0x%x, Group B 0x%x\n",
 			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
@@ -337,11 +338,6 @@ static void __init ms_hyperv_init_platform(void)
 			swiotlb_unencrypted_base = ms_hyperv.shared_gpa_boundary;
 #endif
 		}
-		/* Isolation VMs are unenlightened SEV-based VMs, thus this check: */
-		if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT)) {
-			if (hv_get_isolation_type() != HV_ISOLATION_TYPE_NONE)
-				cc_set_vendor(CC_VENDOR_HYPERV);
-		}
 	}
 
 	if (hv_max_functions_eax >= HYPERV_CPUID_NESTED_FEATURES) {
@@ -410,6 +406,9 @@ static void __init ms_hyperv_init_platform(void)
 	i8253_clear_counter_on_shutdown = false;
 
 #if IS_ENABLED(CONFIG_HYPERV)
+	if ((hv_get_isolation_type() == HV_ISOLATION_TYPE_VBS) ||
+	    (hv_get_isolation_type() == HV_ISOLATION_TYPE_SNP))
+		hv_vtom_init();
 	/*
 	 * Setup the hook to get control post apic initialization.
 	 */
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 356758b..b037954 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2175,9 +2175,6 @@ static int __set_memory_enc_pgtable(unsigned long addr, int numpages, bool enc)
 
 static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
 {
-	if (hv_is_isolation_supported())
-		return hv_set_mem_host_visibility(addr, numpages, !enc);
-
 	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT))
 		return __set_memory_enc_pgtable(addr, numpages, enc);
 
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 3146710..08bdbe5 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2156,7 +2156,6 @@ void vmbus_device_unregister(struct hv_device *device_obj)
  * VMBUS is an acpi enumerated device. Get the information we
  * need from DSDT.
  */
-#define VTPM_BASE_ADDRESS 0xfed40000
 static acpi_status vmbus_walk_resources(struct acpi_resource *res, void *ctx)
 {
 	resource_size_t start = 0;
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index d55d283..2bb2234 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -26,6 +26,8 @@
 #include <asm/ptrace.h>
 #include <asm/hyperv-tlfs.h>
 
+#define VTPM_BASE_ADDRESS 0xfed40000
+
 struct ms_hyperv_info {
 	u32 features;
 	u32 priv_high;
-- 
1.8.3.1

