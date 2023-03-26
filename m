Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9716C94A7
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 15:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbjCZNxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 09:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbjCZNxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 09:53:14 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021021.outbound.protection.outlook.com [52.101.62.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F9E7A88;
        Sun, 26 Mar 2023 06:53:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YnzCljJoHt1xlZZDJxpu0yXhCN7kG3fNlFS1bJO8QOyYQS6eNWR7I1vF5Rzko7I0GVrI2i8fMrXtjGC6pMeeAFa8qotU+iGrcMC7Mlm3MzKhKcrIBxEiB7guNWZht1ukqJR+AVVRZCP5+uXR1tewvY13KYfaIXdJBaJeqqWLaPL9GM370fzU+wK9vjca6EwvPCORN1Ss9oN2OpbVDzm0SVvHT7FiFOyXaKlnGUPXsBN+xrt8/SzKr0q1pbq35PJdt55YdgasI8R/zrGtaFURne1XbluHbNl/LsFiyF27NYeVPyqkWvBGicwayUgl8o45D0YCoLYRrOvKhmX9LQenUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BJSsjkE6n4QET9p3yMwrUTThHUQbkoJIj/zzWReCAO8=;
 b=VY3NwVtYWLNJO5WgugZSW8u1sKvWeiZ0//UqiMyTg/hmIws9atr9oap79TFWVjUpJyDStQb81w1Zcd6n1esC6Bgp5uAw2+cP77V/Ltk4apmVxN3i9LhkGCrN5zZcdhw82tZO6jGf3VVXqqkp7xNWhYRRf+AGwA2jAXHjdddDMOOuTZmXO2c3lDAvbMOWrLJGypEn2nrbliTqVgsHIwdELk26tt03bNg5xhe9L1sg+Rs4JvQWO3bTy0oTcnDKmCPYeSI4DjzC7NsIOPnQ4vnotxlcKXyV3iRK9JCbOJGPUbm2NHzClIaKUZqJewWbI5r0b3LAi0dLXMwCnrZPZbSKqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJSsjkE6n4QET9p3yMwrUTThHUQbkoJIj/zzWReCAO8=;
 b=AVEB38bHAZHZXDRDGf2bG17ZBOw/YuCsCVt3UDwrsrG/kWlbY6btWqaz+nhz5eel+IoIAAB3bxrjH+T/vtRJUdFQuKgza444qXANBSyY/wim4iOwRmaWmmcXG2+MdqxidTO8wtwFO6rfiZrZsPpOKzP7YYDMawz9E5by1fwbouY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by PH7PR21MB3044.namprd21.prod.outlook.com (2603:10b6:510:1e0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.16; Sun, 26 Mar
 2023 13:53:09 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f%3]) with mapi id 15.20.6254.009; Sun, 26 Mar 2023
 13:53:09 +0000
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
Subject: [PATCH v7 01/12] x86/ioremap: Add hypervisor callback for private MMIO mapping in coco VM
Date:   Sun, 26 Mar 2023 06:51:56 -0700
Message-Id: <1679838727-87310-2-git-send-email-mikelley@microsoft.com>
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
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|PH7PR21MB3044:EE_
X-MS-Office365-Filtering-Correlation-Id: 5579215a-a483-4f49-fdb9-08db2e016ee4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IfhiuqAQvdU5tiJjcO1TUJtO7DtW3tGRYebzBnSgUnxnPkoV7nv24PLkYJxa2FpftOsn5glEnXZF9mdrsQT9Fu5hMN+VSGvS2mTCU7YLKyeVkZzZwB1iSu9m15UeIgycAgjgN8yrd3787nkSNWZQEb8zL/b7iqjmGqRm4jKlNnvCsrHcI0vy2hbFDVGRI0n4QBWUhm97QVEMYPeMGcZCEicb1k0eYjBBvzO39USreUukNrS+V1zEzePDKQeOr4T2KnLov/sGLavib393Dl/9wfoUEJs1yjHCLX5sv/aSHY8XAty+HbHFQTx1ZYtu6Y7AWtgZgUNXfuWU0l25R82Tf2wbiRdJ1dyVWzfJTCFBLb9BXXJ+O79MyvZg+mv9js+MB5ZcfLR3xv3KY5lxKh3r2O44nFPwlLmyuAuI6RkkfI6VqoHX6BxD0iXDOI9rDnjpb5V9Vb4sJv55KIT6Ms+bSZHe6txC0gdow9qY5tvSM1ataYkBtfxzaIzYFy4sVn38OeGF93ktvTy1HOJKsnudRuSa0fRRPBN0D7JOHnUuwSpEsouibH2I93HgT3OxINTTOK0DuQlgrSR6cxqa/D4CClC5qupYioJ87gy03cxp8XIkfnXGgtHawEBl9637jrMDMkiH5fmauGwGr7vE6YHjz0xDazDzmFPtUlobD8IX9aj+/P3l+YUgcbBJJvrkrHP2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199021)(38100700002)(38350700002)(82950400001)(82960400001)(36756003)(86362001)(921005)(2906002)(6666004)(107886003)(10290500003)(186003)(26005)(478600001)(6506007)(6512007)(5660300002)(7416002)(7406005)(8936002)(52116002)(6486002)(41300700001)(316002)(66556008)(66476007)(66946007)(4326008)(2616005)(8676002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cmlbZdLeHC3jsV7G/H7Zr7MVlQRp9lMFhFuzagJWSkDlktICsjQVuP9RTCXT?=
 =?us-ascii?Q?O9kJv0SHnB6Y9/GHJgBCVqrsgbPjNwZxiTb7bz32MEPL86TH/5/iCjSp/o1O?=
 =?us-ascii?Q?/cHixRdldMx8dvCrfYhwvSxiINyKVU3eC23Mn1u/Mgkow+dlBZ/wJD1Ntv5U?=
 =?us-ascii?Q?Za4stToBn4WNLhpWtkJQhVVSy8WW94b6ogJq/wzsQ6YkZuoOi8AIkZsRuU4O?=
 =?us-ascii?Q?nOvqHmxVJA3jiRflI355qdiECS0bVtR+66GIcRP0ZcOnGE3DnNMWcs4j2IKy?=
 =?us-ascii?Q?QUAD1drdMs4K5hKHipn6gkmUYnUdjO15KUI4sDOJI8DtjuOHWByVMDxut+SM?=
 =?us-ascii?Q?ju2WzhMlq84cTECT43iWHyvWpAwtUSYcJw7On8iyW466uOHJnopk5f1an+p2?=
 =?us-ascii?Q?N4w1Xm5o+6liSH5aXTrWOIDkb0ZkLEJ5g7KI9oc1Pr7fKopdksenDGA6oozc?=
 =?us-ascii?Q?zaOZAK2qmMpEgljukvfsXEHEP3nd04Kl0Ick3ypZXPz+cHci780LLJikFHPV?=
 =?us-ascii?Q?aZauoj+QYn4uSq4Yfx43zVqPAY7HV1uAvfFZGYnwGVFaiocCHO4OZT+cX/46?=
 =?us-ascii?Q?zreK0wdf44UokutY89dDbVH6FW6GqVqFOupKYH/UuW1q0K36ciGShT+aGRt+?=
 =?us-ascii?Q?nY5QfhYR8SrGwT72xiSKgPP7phxk5mbXdUYKLeI9gL8A5UADtZyOwHFsuwBM?=
 =?us-ascii?Q?qcV+B8her/FwmPtDcB4iil8gSp4+xW0huteP9k+4ipWtl6c39fYVsNcRSPJS?=
 =?us-ascii?Q?W7B9alJoaL7X1D4N0DkV0G5XNWO8aP62c49FPgjB5XUAqlZxknx1qGSYBslW?=
 =?us-ascii?Q?DoEsZ5x5GAOyoz870DMafW1pafkNAegGU66jlB00QJLMuXRyRY2ft05TxA6s?=
 =?us-ascii?Q?s3LANgudFHq7TXpayLlEpt6Ui6oS9H5Dd+W5bLk4SJmILCJT58UZTQsoEBJo?=
 =?us-ascii?Q?L84tK5fXpuuxcXQV3/rpCARaTpJvnqyS8b+sgBDZ9DiCo81Zd+Z8fBdtu0wj?=
 =?us-ascii?Q?JYemPEEYAsSLhahg1aLqhVY1Zsi34GXIXZmxQqPy/fYNmc+CTBvyDWKqf2ie?=
 =?us-ascii?Q?jwBLXYfbxTVNUE6726R95ops0dX4IFUrDBSsxV6NG4stl2UpsI5is17g64nS?=
 =?us-ascii?Q?oi2LDz8QbmWJ4F9e2pASni2wwArwzriLL5oBnw05kDkYrynjqAAAs6Em+DLV?=
 =?us-ascii?Q?hZ4zEHcjkq1UGJHdwu1hCSxwLD+Q7vnzgpvCCSXbBOl2KsYbGfKrDaZar/fq?=
 =?us-ascii?Q?bANsKXmXCUkhqlpXNkffnwaVdWYdqR6e488XBxr7ANgmXkcRyv+2rjHIsaya?=
 =?us-ascii?Q?3/TaXX4j6PxPDOL03wVO3rGKTGUfqmPHbdjVorS/gHguF0RurrSS9h1I1akn?=
 =?us-ascii?Q?h50M1M+/YoKh5O98mds/NfI1ho7/Frl/eqwVxWXj7rbiWuPYLuX/emcG+yqR?=
 =?us-ascii?Q?g6XZUiYNzz+34vUxfSa0Ph9Vyo7yAys3ffwMDddRNzdXmRdrsmdGxluloNYb?=
 =?us-ascii?Q?dY4MUiTtxRNzVn3XyEI683ZhEhX6MenI7v18kmxxdtpDxmfs90aP4aePpIhf?=
 =?us-ascii?Q?nFd08LA0EvqrYFkjGocAh7B5ml8sVWerV4bkZL593cTqDVZ7mbEpM7+T4b7m?=
 =?us-ascii?Q?iQ=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5579215a-a483-4f49-fdb9-08db2e016ee4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 13:53:09.4828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q0x5wPi0k+aeuQxNmhlkJhcS+Q56V5FCCy/OC++rADWFz4VqE+qK8D3GVhXaMHzeDAeG+eQ3Nbrv5a6Philf2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3044
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current code always maps MMIO devices as shared (decrypted) in a
confidential computing VM. But Hyper-V guest VMs on AMD SEV-SNP with vTOM
use a paravisor running in VMPL0 to emulate some devices, such as the
IO-APIC and TPM. In such a case, the device must be accessed as private
(encrypted) because the paravisor emulates the device at an address below
vTOM, where all accesses are encrypted.

Add a new hypervisor callback to determine if an MMIO address should
be mapped private. The callback allows hypervisor-specific code to handle
any quirks, the use of a paravisor, etc. in determining whether a mapping
must be private. If the callback is not used by a hypervisor, default
to returning "false", which is consistent with normal coco VM behavior.

Use this callback as another special case to check for when doing ioremap.
Just checking the starting address is sufficient as an ioremap range must
be all private or all shared.

Also make the callback in early boot IO-APIC mapping code that uses the
fixmap.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 arch/x86/include/asm/x86_init.h |  4 ++++
 arch/x86/kernel/apic/io_apic.c  | 16 +++++++++++-----
 arch/x86/kernel/x86_init.c      |  2 ++
 arch/x86/mm/ioremap.c           |  5 +++++
 4 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index c1c8c58..6f873c6 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -259,11 +259,15 @@ struct x86_legacy_features {
  *				VMMCALL under SEV-ES.  Needs to return 'false'
  *				if the checks fail.  Called from the #VC
  *				exception handler.
+ * @is_private_mmio:		For Coco VM, must map MMIO address as private.
+ *				Used when device is emulated by a paravisor
+ *				layer in the VM context.
  */
 struct x86_hyper_runtime {
 	void (*pin_vcpu)(int cpu);
 	void (*sev_es_hcall_prepare)(struct ghcb *ghcb, struct pt_regs *regs);
 	bool (*sev_es_hcall_finish)(struct ghcb *ghcb, struct pt_regs *regs);
+	bool (*is_private_mmio)(u64 addr);
 };
 
 /**
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1f83b05..88cb8a6 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -66,6 +66,7 @@
 #include <asm/hw_irq.h>
 #include <asm/apic.h>
 #include <asm/pgtable.h>
+#include <asm/x86_init.h>
 
 #define	for_each_ioapic(idx)		\
 	for ((idx) = 0; (idx) < nr_ioapics; (idx)++)
@@ -2679,11 +2680,16 @@ static void io_apic_set_fixmap(enum fixed_addresses idx, phys_addr_t phys)
 {
 	pgprot_t flags = FIXMAP_PAGE_NOCACHE;
 
-	/*
-	 * Ensure fixmaps for IOAPIC MMIO respect memory encryption pgprot
-	 * bits, just like normal ioremap():
-	 */
-	flags = pgprot_decrypted(flags);
+	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
+		/*
+		 * Ensure fixmaps for IOAPIC MMIO respect memory encryption
+		 * pgprot bits, just like normal ioremap():
+		 */
+		if (x86_platform.hyper.is_private_mmio(phys))
+			flags = pgprot_encrypted(flags);
+		else
+			flags = pgprot_decrypted(flags);
+	}
 
 	__set_fixmap(idx, phys, flags);
 }
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index ef80d36..95be383 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -134,6 +134,7 @@ static void enc_status_change_prepare_noop(unsigned long vaddr, int npages, bool
 static bool enc_status_change_finish_noop(unsigned long vaddr, int npages, bool enc) { return false; }
 static bool enc_tlb_flush_required_noop(bool enc) { return false; }
 static bool enc_cache_flush_required_noop(void) { return false; }
+static bool is_private_mmio_noop(u64 addr) {return false; }
 
 struct x86_platform_ops x86_platform __ro_after_init = {
 	.calibrate_cpu			= native_calibrate_cpu_early,
@@ -149,6 +150,7 @@ struct x86_platform_ops x86_platform __ro_after_init = {
 	.realmode_reserve		= reserve_real_mode,
 	.realmode_init			= init_real_mode,
 	.hyper.pin_vcpu			= x86_op_int_noop,
+	.hyper.is_private_mmio		= is_private_mmio_noop,
 
 	.guest = {
 		.enc_status_change_prepare = enc_status_change_prepare_noop,
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 6453fba..aa7d279 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -116,6 +116,11 @@ static void __ioremap_check_other(resource_size_t addr, struct ioremap_desc *des
 	if (!cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
 		return;
 
+	if (x86_platform.hyper.is_private_mmio(addr)) {
+		desc->flags |= IORES_MAP_ENCRYPTED;
+		return;
+	}
+
 	if (!IS_ENABLED(CONFIG_EFI))
 		return;
 
-- 
1.8.3.1

