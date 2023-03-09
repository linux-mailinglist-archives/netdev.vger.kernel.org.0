Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E33B6B196A
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 03:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjCICnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 21:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjCICmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 21:42:21 -0500
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021020.outbound.protection.outlook.com [52.101.57.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B6BD13D2;
        Wed,  8 Mar 2023 18:41:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0zzP5jXuHtnTR2JT1jzA41owX8L7P4B5r70BbDI8OXyKt7sWIMnBlP8AzvnCneZtpQtW2lZJ6B9HtUUQ5DT/0Ft6lTrMFFVGmSliUJjAuUFEov6Zh8a0o8RKQRXH5h82FwHiklCUqNQ4kQOL0sS4WzsXW2HeLp1Rm6a0dHplwEGrzweDyJeNvqlxJSPfad/rQg/K6v2W9s9075rHo6SKKPBKBE1dj+1y7QgxQpNl8XwWNCKWD+ZIW06AdpesvrA1Zubjghfo+i6YjYLcxSyEG5VKBy9QiVKTqHNiSLJFlXec+gc5Or3wzCnviL3mb2GYx8AzXJCIysvntoQtOKWXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=74/fRsdowhfp4ehzrPV2idoyUtqmbCaOo58WsUVvjjw=;
 b=Xpq+B2hQ56+YBVwXdqiEaSGSuT4u/aAfjJGzrAzkpL8ykHz8RNuFbaDk2yvD/rzsL34rUvz7UTKCKFpQsnUq39Nipj3VCPkQKd1aKb7ADRaDBPdbSGIac/JjrnS8nQGQpunwhDlUUnYq6CgKV5x7OIGIN0021fPLWhDJXPwMk73bGztb9KTr0WaXkDaFmHFY20cU5JMReMh5fYA5jZ2akVaWJeV99oGL+mAQeJhgDC/dxLLVOWkfqV1KK69Mid1a4ZiNBGvk1XOqlGgnBNaLz2Z7sfLyF6tNT96zF3KJkxH8lzjbakKjyOaujaOS6V+EXSoLdIlvdPRKnad5Te70Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=74/fRsdowhfp4ehzrPV2idoyUtqmbCaOo58WsUVvjjw=;
 b=H/15VmmWCI7lPfSJxlPniclisTrZ9PDiHE/mdZxl6eB7Zp/rtRpJm7THbS21Tq/dAy3uquCv8zJEgng2Hv/B4htJmolfEl0xbCmwKTH+juUIEAa/pDeAqOs0jr9RwDAFDW98A00gOdA0Y08WRj35DcipYMMQg87mI1t4VyKO8GQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1313.namprd21.prod.outlook.com (2603:10b6:208:92::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 02:41:47 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17%5]) with mapi id 15.20.6178.016; Thu, 9 Mar 2023
 02:41:47 +0000
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
Subject: [PATCH v6 06/13] x86/hyperv: Change vTOM handling to use standard coco mechanisms
Date:   Wed,  8 Mar 2023 18:40:07 -0800
Message-Id: <1678329614-3482-7-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: dfe9bcc0-9b30-4811-014c-08db2047d39d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qhPWzA36iBA1w2sFzGu0L1/xemfOXZkv1RKge4UUi9o8Q2NIPTjsagXqOSwEcKFl/+Chzc+bcp48ehZK4ftI12A5b3AUn12MJjSsWQNr7JPeYxrIUxDhf2JGPbKP+vmTZNbagpsJ41NycJMn7UqdGXyfVyO801vRTUlREaKnDPLsWp/OonRAu7D+pSiw9PWrl4oz42Q8KZlAlKOq3IOzmJenktLnYTZcj+UmCOQ1guBjJGBrqSlZGMS9CdPfX3wEG8PEfjctfI1eXsKD3JIVIV6kkrstWBVvAw1Ax4P8rnYE49fsIAI92z/mKStnaAYBMOUvO8v2XDbjIjiZ5J/j16fLnY/An1WUyLuOOdnUeWbzNS51/i16/vzdQvOf0lupKYhtr8fIIYIHw4wLWMqP+ZbKH3OBaS+2hOFPVqpvDx4zlbOaTisUUMpAhhHKJXZjQbij2P9nxkDcRqRXMkvHxtBt7LhUsGU4I/skuPNTjTIwxqRgGdjFOpOklzgVWzkKG39hdB50bXX4R87IRO6ME2IzxfYw5INF2NptpMN4mxEnz6a2fABpoL7KrINtSCfdQmWwOyIin/pUmYS1ggPegjchHYMDLCLVVwr81rWF/mNv084K3K5f2C7eXPLopSQOx/Mfvsr4CNe7OKoAV0v0XVG81TyXvHtcS8cFnhSnEfR8JVnk4IkVaBV8oYXiTYMJ9dibZp6yNyUT0itnLibAd213bkDzqF2QJdXynjT2kdGZPwz6qoM6DcaGTJ0Qjd3U7uPE4JSena2llYEznBijZZEEXXQFvthDRgDdXyXf6vc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(451199018)(66899018)(82960400001)(82950400001)(83380400001)(36756003)(10290500003)(478600001)(921005)(316002)(38350700002)(38100700002)(966005)(2616005)(6486002)(6666004)(6506007)(6512007)(107886003)(26005)(186003)(7406005)(5660300002)(7416002)(41300700001)(30864003)(52116002)(66476007)(66556008)(66946007)(2906002)(8936002)(8676002)(86362001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+DFV7cIlVVtGoabSF0yLnNetHP0/4MvXfkVdszf3G4ZZiYOFzq5oOvWQYmUr?=
 =?us-ascii?Q?KkTyQPCPnAxpWT/mPhmtQWW1moImcjKKckPIy0CePtLKU/eW8dDDNKlbG0kw?=
 =?us-ascii?Q?rUVVJwp9Lanijyoxacp997IfdRV0W2cgqJpb8kOmB/xg7qHsISm+F5ggvhtv?=
 =?us-ascii?Q?5yLtNqnspzZTewvhXRUDbNEEYd6MfewaY8pTR7W8p9+73s6obXQT/jnXXeSA?=
 =?us-ascii?Q?MJK1YDwmxuM3yrR6bhWVxFVnw8h9D8rs7hriHph0Qa7rGqcyjylELS365q3J?=
 =?us-ascii?Q?B/UVle8n48soKIkK8QqV44noNmgDfqbcbxa+LSt32V9uyQAqY67z+vsAorex?=
 =?us-ascii?Q?4OI+qJkPFnLQWf8aJurQBzKzfd9TdeUvmiISRTbKhIVr4imP+MA1Kxgo7pEm?=
 =?us-ascii?Q?FRsVSWGBPVtAoK5hno3DLB9CRcZdVpRl/ZFKha8+8wjgZqSPrQpqifuaqKz1?=
 =?us-ascii?Q?VmjMr4DxFnq7MXqLzqE1y7imNcVdsXfO3DEyMHIlNe5aNB/PDFSxo9P6q8Xb?=
 =?us-ascii?Q?ey/iJvghE6B4Kvsi1Qy+65UGLf/nuOxDrADT20Ym0hL9fltOuU/TUuC7mWUB?=
 =?us-ascii?Q?bLvZcqBhkQwfuW7m//YriRqVL82EK6SH66atgV/HctlZiV85lcPbk5HUiJQd?=
 =?us-ascii?Q?cpofv7NUBpgdvwY4HNrhtwk7QIoVtDG7wXN4o7huP/I3SavSjBQrHLT/TQ8y?=
 =?us-ascii?Q?dcD2pNxuurDTSAEP8TgalrlnmBLWJzJxAGtrYL34Q9jsCPqj8rhGq7fO+rQ5?=
 =?us-ascii?Q?ol3np67sOBJJDVcwQw7wfqiOVlPc4PASBSgYLq8W65xsa2cPCuo6T51BVvS+?=
 =?us-ascii?Q?mnny3575SqnO7YInyrUSpplAAAmrFJtyxV6t51trsYjwrD8ryYmJ9ZXfebDz?=
 =?us-ascii?Q?e71pVSqPcDk8kOl5M7ZTRk1+iHku3IT8Nq6aqsdRULKDjYZ8Cm16Hz9cYKFf?=
 =?us-ascii?Q?FohfTOMbmTqFxDhG4183SPxpI5tHJnyQY4pw63uYejRdyp8VDakUHT0wY68s?=
 =?us-ascii?Q?FUblL5njeHSpleyiFRrVDG67/yQKdRRWiRr0bcc42AoGfLHE2ii9K9/qe9MS?=
 =?us-ascii?Q?yG9c0cDNeL5RcpkKxI8LV1idInIw/urA/3grSg9XAww/U0GWIOOaTaycESDG?=
 =?us-ascii?Q?L2vI4rs3GxM2uAshEGujQkXBG80y0x6Wm6yzlrjyTGLwe/qUH+s7gImp9lQk?=
 =?us-ascii?Q?L4rNuI2cV9HhCeVoakRejL5heEmtUppB3ncl0i6NnrBdIwuDi6FD2zTd6RjH?=
 =?us-ascii?Q?bKUKl/le9ph7j9umj80n8IUgC8QQ99tMqIs60lbcYwoIJuSd26En5IMFnYc8?=
 =?us-ascii?Q?iN7CJx6twDbIyxpDCAQAb+6ipuqkbGrL4LtMzUUcpb0cG/2dR2H1FE5MhQb4?=
 =?us-ascii?Q?0+LL18Yn2GcPvtn8YOm7H8AFkp8rxC2SAeFEpfZHYrlH2cP6tnS1kxM2Wbwv?=
 =?us-ascii?Q?BvcNCO8GsZXtibvp82YmAlmLeO41N7inqwPCXtGzieTr/1xRYdCFjx0gDzO1?=
 =?us-ascii?Q?k0rVEr5+hB545Z/fl6WFNQppdTxgcb5FAvGlqxmu7UKqYNnJJXPzrJmms7If?=
 =?us-ascii?Q?nCNx0EaqdDtYPYn6otdpem1JJJcYiaa+1o82PTLWL9LWzn0nnKRbp9593/80?=
 =?us-ascii?Q?Hw=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfe9bcc0-9b30-4811-014c-08db2047d39d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 02:41:46.9980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bt5BEKSFhPzsqzAef1PPg1juksIzg+qqxStWzvtMHPx+SklAPGdimhYZjwT5XKwMuLlsLvX98uht4lXLdD/R8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1313
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

* Add a Hyper-V specific implementation of the is_private_mmio()
  callback that returns true for the IO-APIC and vTPM MMIO addresses

[1] https://lore.kernel.org/all/20211025122116.264793-1-ltykernel@gmail.com/
[2] https://lore.kernel.org/all/20211213071407.314309-1-ltykernel@gmail.com/

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 arch/x86/coco/core.c            | 42 ++++++++++++++++++------
 arch/x86/hyperv/hv_init.c       | 11 -------
 arch/x86/hyperv/ivm.c           | 72 ++++++++++++++++++++++++++++++++++-------
 arch/x86/include/asm/coco.h     |  1 -
 arch/x86/include/asm/mshyperv.h | 16 +++++----
 arch/x86/kernel/cpu/mshyperv.c  | 15 ++++-----
 arch/x86/mm/pat/set_memory.c    |  3 --
 drivers/hv/vmbus_drv.c          |  1 -
 include/asm-generic/mshyperv.h  |  2 ++
 9 files changed, 112 insertions(+), 51 deletions(-)

diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index 49b44f8..d1c3306 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -29,6 +29,18 @@ static bool intel_cc_platform_has(enum cc_attr attr)
 	}
 }
 
+/* Helper function for AMD SEV-SNP vTOM case */
+static __maybe_unused bool amd_cc_platform_vtom(enum cc_attr attr)
+{
+	switch (attr) {
+	case CC_ATTR_GUEST_MEM_ENCRYPT:
+	case CC_ATTR_MEM_ENCRYPT:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /*
  * SME and SEV are very similar but they are not the same, so there are
  * times that the kernel will need to distinguish between SME and SEV. The
@@ -41,9 +53,20 @@ static bool intel_cc_platform_has(enum cc_attr attr)
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
+	if (sev_status & MSR_AMD64_SNP_VTOM)
+		return amd_cc_platform_vtom(attr);
+
+	/* Handle the C-bit case */
 	switch (attr) {
 	case CC_ATTR_MEM_ENCRYPT:
 		return sme_me_mask;
@@ -76,11 +99,6 @@ static bool amd_cc_platform_has(enum cc_attr attr)
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
@@ -88,8 +106,6 @@ bool cc_platform_has(enum cc_attr attr)
 		return amd_cc_platform_has(attr);
 	case CC_VENDOR_INTEL:
 		return intel_cc_platform_has(attr);
-	case CC_VENDOR_HYPERV:
-		return hyperv_cc_platform_has(attr);
 	default:
 		return false;
 	}
@@ -103,11 +119,14 @@ u64 cc_mkenc(u64 val)
 	 * encryption status of the page.
 	 *
 	 * - for AMD, bit *set* means the page is encrypted
-	 * - for Intel *clear* means encrypted.
+	 * - for AMD with vTOM and for Intel, *clear* means encrypted
 	 */
 	switch (vendor) {
 	case CC_VENDOR_AMD:
-		return val | cc_mask;
+		if (sev_status & MSR_AMD64_SNP_VTOM)
+			return val & ~cc_mask;
+		else
+			return val | cc_mask;
 	case CC_VENDOR_INTEL:
 		return val & ~cc_mask;
 	default:
@@ -120,7 +139,10 @@ u64 cc_mkdec(u64 val)
 	/* See comment in cc_mkenc() */
 	switch (vendor) {
 	case CC_VENDOR_AMD:
-		return val & ~cc_mask;
+		if (sev_status & MSR_AMD64_SNP_VTOM)
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
index 5648efb..f6a020c 100644
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
@@ -315,17 +314,68 @@ int hv_set_mem_host_visibility(unsigned long kbuffer, int pagecount, bool visibl
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
 }
 
+static bool hv_vtom_tlb_flush_required(bool private)
+{
+	return true;
+}
+
+static bool hv_vtom_cache_flush_required(void)
+{
+	return false;
+}
+
+static bool hv_is_private_mmio(u64 addr)
+{
+	/*
+	 * Hyper-V always provides a single IO-APIC in a guest VM.
+	 * When a paravisor is used, it is emulated by the paravisor
+	 * in the guest context and must be mapped private.
+	 */
+	if (addr >= HV_IOAPIC_BASE_ADDRESS &&
+	    addr < (HV_IOAPIC_BASE_ADDRESS + PAGE_SIZE))
+		return true;
+
+	/* Same with a vTPM */
+	if (addr >= VTPM_BASE_ADDRESS &&
+	    addr < (VTPM_BASE_ADDRESS + PAGE_SIZE))
+		return true;
+
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
+	sev_status = MSR_AMD64_SNP_VTOM;
+	cc_set_vendor(CC_VENDOR_AMD);
+	cc_set_mask(ms_hyperv.shared_gpa_boundary);
+	physical_mask &= ms_hyperv.shared_gpa_boundary - 1;
+
+	x86_platform.hyper.is_private_mmio = hv_is_private_mmio;
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
index 4c4c0ec..e3cef98 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -11,6 +11,14 @@
 #include <asm/paravirt.h>
 #include <asm/mshyperv.h>
 
+/*
+ * Hyper-V always provides a single IO-APIC at this MMIO address.
+ * Ideally, the value should be looked up in ACPI tables, but it
+ * is needed for mapping the IO-APIC early in boot on Confidential
+ * VMs, before ACPI functions can be used.
+ */
+#define HV_IOAPIC_BASE_ADDRESS 0xfec00000
+
 union hv_ghcb;
 
 DECLARE_STATIC_KEY_FALSE(isolation_type_snp);
@@ -206,18 +214,19 @@ static inline void hv_apic_init(void) {}
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
@@ -259,11 +268,6 @@ static inline void hv_set_register(unsigned int reg, u64 value) { }
 static inline u64 hv_get_register(unsigned int reg) { return 0; }
 static inline void hv_set_non_nested_register(unsigned int reg, u64 value) { }
 static inline u64 hv_get_non_nested_register(unsigned int reg) { return 0; }
-static inline int hv_set_mem_host_visibility(unsigned long addr, int numpages,
-					     bool visible)
-{
-	return -1;
-}
 #endif /* CONFIG_HYPERV */
 
 
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index f36dc2f..ded7506 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -33,7 +33,6 @@
 #include <asm/nmi.h>
 #include <clocksource/hyperv_timer.h>
 #include <asm/numa.h>
-#include <asm/coco.h>
 
 /* Is Linux running as the root partition? */
 bool hv_root_partition;
@@ -397,8 +396,10 @@ static void __init ms_hyperv_init_platform(void)
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
@@ -409,11 +410,6 @@ static void __init ms_hyperv_init_platform(void)
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
@@ -482,6 +478,9 @@ static void __init ms_hyperv_init_platform(void)
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
index d24dd65..e9e1c41 100644
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
index 8845a2e..90d7f68 100644
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

