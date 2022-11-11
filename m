Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9905962539A
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 07:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbiKKGWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 01:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbiKKGWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 01:22:33 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11022025.outbound.protection.outlook.com [52.101.53.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE34663C0;
        Thu, 10 Nov 2022 22:22:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QusDCotf6EQWFgHIQ6t1Cdc46/aVgN0qrS/ZZ3FHoHIkZCW4Wz6PMbP3Qq+QoiRNgGE7lQmpg4Qosha7N9YRIW63A2+uzzfYcZD5TLWoQETJqh0rUl6pAsj/SF1t8hSEvilAXa7XdnB9OpA7RXhXQ2Rrz0/e5rNp/c1cPLW9zFAM3PCJcqiUW/aybKBVKWYeM4hQB4nOLh3PCv2N5t1IquU3lSGEuUJgY7sIog+PqTfHeNig5orFFT1Shvto8Xvs+TQH9uEZEWenSPBwIgDZxsvFDgF+7RxFN2iW7LLZDvG7Tg2ucQtKO4CZQ1yLIvp/d6coKPoFGFL5p4x2b4YHnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FT6d4qwlnktmpmC/x/vNnKUNdEG3IaM/xrJmCwikmAA=;
 b=FxBA4KyEtS7oYu5cg9xsVwjY+GrznMicxiHWX0sjUGdRZJdFPRDyrXIVCBwxLeP3lNEv87GkMnXfwdjWDLErVRi+s4q5keBMopG+MRlxy+1TDnU8/GAm+dgDW9b9PfVx3ssTfsjbqa938dV4HZ86e6e616mYxoucudvrHwK5umEKmeaIDdiLHs5fRyhx+pW9zgwTH0CtnNm37fViqL10h46N3P4+ylf4rI1jXyY6rLwMBtLeRc7Fh8rTNzVR6vJoj/nFXFBNx038+8lJSGvah8og25IEQP7CdwQ/7Mh9YfNU6dQ9GEds3vifvouiW0+YDCbeTB+2g9Sb1J9XNn7Zkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FT6d4qwlnktmpmC/x/vNnKUNdEG3IaM/xrJmCwikmAA=;
 b=MmT3ryqbA6QwZ0iKbxv+83VCZBXva++3VVNpeJHgB+SXdWyVSD4UhdJPmuhIZbbfnQ1JeySPN3805tTrTfpAdaFkRkb50UC2Ujn5JLGiojQhVRmexUZfdytl6A1GpvhtijbAbCFiHlsr3cUBF0brULTw0f0iKYhI34iE4Upbeew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.2; Fri, 11 Nov
 2022 06:22:21 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%7]) with mapi id 15.20.5834.002; Fri, 11 Nov 2022
 06:22:21 +0000
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
Subject: [PATCH v2 05/12] x86/hyperv: Change vTOM handling to use standard coco mechanisms
Date:   Thu, 10 Nov 2022 22:21:34 -0800
Message-Id: <1668147701-4583-6-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: dedc8f1b-e683-4741-afe9-08dac3ad16e5
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qv7o5k2t43t0QCCkmQzY41r23c9BV3TzhFtF9g6fh+B12NQULinkUsev9ob93ez1YL4hufxAINDXIuAhnetc+L/Hhc1U3/CB5CK13RLarZdYddEOAjkQhW9wGbNvmm0IPGS6jxjOIEHzy8LVMQ9iQ10TCYMRc7m9s+iBVJbmeSwTUUlr7UWRjdd1uuprIgqECreH2QmOoVF7GBBKXKCWEkvEe+Xps2wkGlFoLe0FxNnRAN2gI/Hg+7mdaCCbLWgdYPRdaM3/gMT+1a/Ci13N0IjjjP98gtz9M668rE7TB0EhzSZCWeDgjtorkvYj3S0bvuP2JDKSuzIOwivBlqCQCGq/jfIBSwdGqRj4yxIiD5o0aTDreRxeW9+THN4YoyDZQVy5f8z1nivjQ37qy0aNVclfOGN6z622GCFMUqDhWAX9j/m6SZfPKD2efqPrEG8sHMxRbsqBtwT4+y+V5k2NC8x/L1sZHdrIov8vhLtu9wMITVBuwj7AS6ByGNi6R9jTLcKgVcMj07iuaWOVDNGkfLNPNxyEbtJ+MKBAIzrHWtJOTrCt2sfQztsjMAYn+9qmpNu138djZWzGb8/bXYv+H1qiP2c6ieyCiiAR+r76N7J51ObF3p22YPagvtQZj57eLG763G0OwN+KxDBHAghMOPR7Il7Zf5wQEsd3dGHadEC51XYhsU3Q6lwJtcUURg/XJoQhT50BwO8qlpbEyijt+nTnDzBD47cxPqaX4h3hnXCzezz6lUG3ArVeb67Vy6akQNG+MsdqXkXBqQ34yw8/u/yKX5MY8euExbAKlQVWzhj/7IeZQOedbkTNvcpyF1aoEv+yIAGVe1mvK/3IM2W2LepRmJCVtk3nuebUaAg92wf9LbXsXMEbt/6lkAiw7lVBDJxsY6mwGspm9K/R+lesCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(451199015)(83380400001)(52116002)(26005)(6666004)(6512007)(186003)(38100700002)(107886003)(2616005)(7406005)(2906002)(316002)(7416002)(6506007)(30864003)(10290500003)(6486002)(66946007)(66476007)(5660300002)(966005)(8936002)(41300700001)(8676002)(4326008)(66556008)(478600001)(38350700002)(36756003)(86362001)(921005)(82960400001)(82950400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KdVa7u+jmJOHz7zMcOwviqiQ2kdYPBQBLgmAee4tipldfu+QMPGyVgLqyXvQ?=
 =?us-ascii?Q?TmGy+0fXBUqL4OZiktAUFTLXtgbO25vm/vwkXiah02u9knButPuucOu7WNjC?=
 =?us-ascii?Q?mM8Aa8Pn1zRi/t3OaxB42OichmX5R8r333rqtNtF2scKXoXhUG7taDeyVTT2?=
 =?us-ascii?Q?2Xp7Kdcbd58zPpr9WpMVUmwDrDBJgaH79ySXMpka4P6UtjD23Bj7UJxx0ckw?=
 =?us-ascii?Q?H3zVCc1po9eyY6Vp3saf135guJmZ+Tn0rkiQY6+ZYMyEHv8ajF9c9iOaVPgi?=
 =?us-ascii?Q?+YJmROrRy4HChkeXHjhAn80ItEl29OSAKZYQRnFOSOp9qfi7nfnJWoWsxirw?=
 =?us-ascii?Q?PUw2zSdtkR2xo70KLMJlpEyooEKTWgC9WrFD/PicpQ5AJ6SV/ppIN3tpnInB?=
 =?us-ascii?Q?6ik4eLjkbZtz+eeKFZGtN8UOYJA9wBygOXCBpUza/giYQLFJovzw5FZPIEx3?=
 =?us-ascii?Q?NqDBxpqGPYjnhVjE6SqTKXi2864GME+qAr8QZ7YOSdAuOklG1FSeRYRAUMct?=
 =?us-ascii?Q?g0FAPNuP7LOPcXyR93n99awB9EqH/FFKtLv1hVC7z6M6ly1vIFZZQTYzW/+G?=
 =?us-ascii?Q?4ml4oLdI4a3/rQhwRLqXuLOW55g2DxjI6IPVqZpzkSRcgzcRCCf1v3dqVmQv?=
 =?us-ascii?Q?ou9POvraXjj1DrcpiOGot8QiMRF6zusqdMXvcUqpk4PFSXMiDjopVCQyphsg?=
 =?us-ascii?Q?R60tQnbm05Lh5c+bNCerbc9tHtRrLLk5KEfNJr6DL8yFJ3Q86BAfUVEFMijT?=
 =?us-ascii?Q?WOHRymPOpJx1JjcUr0WCxZRi4S7GnaUPh5Qvpf21gOWAHLjurrD38CdhWmiD?=
 =?us-ascii?Q?5fjLDMJ16vFE6DWnXrX9lVV6EbHk7eSSNYaSqh7qSmKf9HSB/YfJCmS+S8FG?=
 =?us-ascii?Q?gA6IxhA/62e85KLwRcvMAnDABd+XEoRLvtWuinFVcp31TzuafREkpOrAHW5i?=
 =?us-ascii?Q?cmK+DcZUQo/CckVMxI6Rhw8SX0K+ldyUsSaZEboKhGZXYJ4wpQwsApdoWBr3?=
 =?us-ascii?Q?gm20DCioqeTtmxhirbZFLt7c5xOG7uK9O6OH0HaBE2nLlUInUD2mCRKI17u3?=
 =?us-ascii?Q?fKFsqwPcRoVJI0d/AbsRRXqT7OquM/7XNe0wyT8V+iFM5f+rZR95IRTF3Oi+?=
 =?us-ascii?Q?EV0Gq8h1PDbBE/Zfsv0yLKGyFAnacSJQ7tzutQ14F/bBrzL/tVEGzNMj7fGC?=
 =?us-ascii?Q?HfiDqJ2t7wf6nelO3yCXvzOteVwXCCrKlhMx31mJ/oPwYcpSGNJRK3puxH98?=
 =?us-ascii?Q?7S0t+MeeHBJD+QcrwKwySXRKEvi69TTYJ8FPqTrgL+O1nL0C9ZqSuHYx4r11?=
 =?us-ascii?Q?99sLEs+hV81t2pi4+zmFheMgKAWcfXHzyjSEcEA0+bbv4RXnpXWXPbBzso6X?=
 =?us-ascii?Q?ZfJRSd3v9zMmSEGoBpbXPeI8FGo4bKvjug6vxmbpVMB2jGrK3xb7EUuC7RKj?=
 =?us-ascii?Q?MBi6HLd31aBRL+ObivWkQkE1igy06wUBnZQOBo/7cxJZzWy0UjBBTlhMNu47?=
 =?us-ascii?Q?rCdoBD0Iscbh1R358kz529pKstNbNbWZmY2uW6uGWEGK8YXKtHKpHcatfQGV?=
 =?us-ascii?Q?Zhw6/aq9LYb93lYZE7QLhfCD4jt8d2uH8+vMvUNCuE8wMT3QiSakbMMKGEsK?=
 =?us-ascii?Q?kQ=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dedc8f1b-e683-4741-afe9-08dac3ad16e5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 06:22:20.9273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +RK1DAnDnd8OSpf1dzZh9dIdA3P9jCg+1BSAa24eW44cSlYR0AFrxYCCgwIo4bWrVYXbMm2qJUDqUb1BUvdE6A==
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

Hyper-V guests on AMD SEV-SNP hardware have the option of using the
"virtual Top Of Memory" (vTOM) feature specified by the SEV-SNP
architecture. With vTOM, shared vs. private memory accesses are
controlled by splitting the guest physical address space into two
halves.  vTOM is the dividing line where the uppermost bit of the
physical address space is set; e.g., with 47 bits of guest physical
address space, vTOM is 0x40000000000 (bit 46 is set).  Guest phyiscal
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
the I/O APIC to use private accesses.

To accomplish the switch in approach, the following must be done in
in this single patch:

* Update Hyper-V initialization to set the cc _mask based on vTOM
  and do other coco initialization.

* Update physical_mask so the vTOM bit is no longer treated as part
  of the physical address

* Update cc_mkenc() and cc_mkdec() to be active for Hyper-V guests.
  This makes the vTOM bit part of the protection flags.

* Code already exists to make hypercalls to inform Hyper-V about pages
  changing between shared and private.  Update this code to run as a
  callback from __set_memory_enc_pgtable().

* Remove the Hyper-V special case from __set_memory_enc_dec(), and
  make the normal case active for Hyper-V VMs, which have
  CC_ATTR_GUEST_MEM_ENCRYPT, but not CC_ATTR_MEM_ENCRYPT.

[1] https://lore.kernel.org/all/20211025122116.264793-1-ltykernel@gmail.com/
[2] https://lore.kernel.org/all/20211213071407.314309-1-ltykernel@gmail.com/

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/coco/core.c            | 10 ++++++++-
 arch/x86/hyperv/ivm.c           | 45 +++++++++++++++++++++++++++++++----------
 arch/x86/include/asm/mshyperv.h |  8 ++------
 arch/x86/kernel/cpu/mshyperv.c  | 15 +++++++-------
 arch/x86/mm/pat/set_memory.c    |  6 ++----
 5 files changed, 54 insertions(+), 30 deletions(-)

diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index 49b44f8..de4e83e 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -78,7 +78,13 @@ static bool amd_cc_platform_has(enum cc_attr attr)
 
 static bool hyperv_cc_platform_has(enum cc_attr attr)
 {
-	return attr == CC_ATTR_GUEST_MEM_ENCRYPT;
+	switch (attr) {
+	case CC_ATTR_GUEST_MEM_ENCRYPT:
+	case CC_ATTR_HAS_PARAVISOR:
+		return true;
+	default:
+		return false;
+	}
 }
 
 bool cc_platform_has(enum cc_attr attr)
@@ -108,6 +114,7 @@ u64 cc_mkenc(u64 val)
 	switch (vendor) {
 	case CC_VENDOR_AMD:
 		return val | cc_mask;
+	case CC_VENDOR_HYPERV:
 	case CC_VENDOR_INTEL:
 		return val & ~cc_mask;
 	default:
@@ -121,6 +128,7 @@ u64 cc_mkdec(u64 val)
 	switch (vendor) {
 	case CC_VENDOR_AMD:
 		return val & ~cc_mask;
+	case CC_VENDOR_HYPERV:
 	case CC_VENDOR_INTEL:
 		return val | cc_mask;
 	default:
diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index e8be4c2..29ccbe8 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -13,6 +13,7 @@
 #include <asm/svm.h>
 #include <asm/sev.h>
 #include <asm/io.h>
+#include <asm/coco.h>
 #include <asm/mshyperv.h>
 #include <asm/hypervisor.h>
 
@@ -233,7 +234,6 @@ void hv_ghcb_msr_read(u64 msr, u64 *value)
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(hv_ghcb_msr_read);
-#endif
 
 /*
  * hv_mark_gpa_visibility - Set pages visible to host via hvcall.
@@ -286,27 +286,25 @@ static int hv_mark_gpa_visibility(u16 count, const u64 pfn[],
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
@@ -315,17 +313,42 @@ int hv_set_mem_host_visibility(unsigned long kbuffer, int pagecount, bool visibl
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
+	cc_set_vendor(CC_VENDOR_HYPERV);
+	cc_set_mask(ms_hyperv.shared_gpa_boundary);
+	physical_mask &= ms_hyperv.shared_gpa_boundary - 1;
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
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index 61f0c20..59b3310 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -174,18 +174,19 @@ static inline void hv_apic_init(void) {}
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
@@ -241,11 +242,6 @@ static inline int hyperv_flush_guest_mapping_range(u64 as,
 }
 static inline void hv_set_register(unsigned int reg, u64 value) { }
 static inline u64 hv_get_register(unsigned int reg) { return 0; }
-static inline int hv_set_mem_host_visibility(unsigned long addr, int numpages,
-					     bool visible)
-{
-	return -1;
-}
 #endif /* CONFIG_HYPERV */
 
 
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 8316139..b080795 100644
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
index 06eb8910..024fbf4 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2126,10 +2126,8 @@ static int __set_memory_enc_pgtable(unsigned long addr, int numpages, bool enc)
 
 static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
 {
-	if (hv_is_isolation_supported())
-		return hv_set_mem_host_visibility(addr, numpages, !enc);
-
-	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT))
+	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT) ||
+	    cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
 		return __set_memory_enc_pgtable(addr, numpages, enc);
 
 	return 0;
-- 
1.8.3.1

