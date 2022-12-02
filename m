Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEA163FEF3
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 04:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbiLBDde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 22:33:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbiLBDdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 22:33:15 -0500
Received: from CY4PR02CU007-vft-obe.outbound.protection.outlook.com (mail-westcentralusazon11021024.outbound.protection.outlook.com [40.93.199.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CE9DC4C1;
        Thu,  1 Dec 2022 19:32:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PvCLb0uBlLJ7YyaaqiPf6HE1y5UiDj4gXkqTwUpv6fYHgK/joUEjtQ4e5PJpAhErtuQyW1rKV3CkTo+Y7/txiO3sXbkmTHvOpaYUMeqwRkcQdsUc0T66qc68A4fS0/Fbb11gHxfqrUedrkwk2ZqRcIdDfR0KFTvJrr2MOZaonpG32fu9mDcv4tVaWw2UO4NUPGwznn9+vsW7xb8H2RkEg4LOb5yBU7rnEUKEZxlCMZ3rrMop/4bmWQEBu4z2jpToQtFhC1ZlFSheKDKHxB8NkCr24Du3nbytu63b33/grxv/7SSOKZVE4/aOnqaFgHkzlKDsxYYD6QzIHs6QhgbG0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E7OkiJ1Fod6y/3kxg51h0zwlEPqSz5o+PfX4g5FI6PU=;
 b=XOZsLw6qMvQKHLRd0AvjNxzI4U9yZSRwZh2B9c5wpZ5WFtoN+FM+7BPhUo+KPpI5QqwRXZnCP3wYB/Bq4JNRBPose0ylKZaGWPuTQHLK7QR6GMeDpe2auJxCYC/80Zcz6H6g8d7DpJ0TagCpkxEBlt5vbZ6745BjMib5IC59RfbCJ79eB+61DVB5GBYkNlKRbPkHNwBaCqS+3YeO+r6FG1PTa4Q+xw17FyMpN69CMEOeIfro/xW3fQYChJg1CYNNsxR90wnlBf/s7pJwJbYx390VTmpU1RpzPOPmbXrCL1hIp7fmyB2qJzRca2keXBMF7GZEXgKFXKfPUUBtih0UkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E7OkiJ1Fod6y/3kxg51h0zwlEPqSz5o+PfX4g5FI6PU=;
 b=LaEwiI2f7jDjIJNvH/WgGsucolY8NWUairvDDR95HQ7eJyDrPrARQ+Zj7lbiqnwk4bruItb6qpJ+r2ga40awCMAFQYbx4TezgtX9UUFIn+Hww6KHz1dRvhbs1WxS8bFwUTT+Sv7XsNCEfEA+8Pzfo4F18ofmziZY+a0l9S71HV8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1316.namprd21.prod.outlook.com (2603:10b6:208:92::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.8; Fri, 2 Dec
 2022 03:32:16 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5901.008; Fri, 2 Dec 2022
 03:32:16 +0000
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
Subject: [Patch v4 06/13] x86/hyperv: Change vTOM handling to use standard coco mechanisms
Date:   Thu,  1 Dec 2022 19:30:24 -0800
Message-Id: <1669951831-4180-7-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2dba546e-6a69-4214-db7c-08dad415cee5
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e0VBMIzt0lFG/EceTFiQUYUnFhfignci0Zfyb9MTBx1qkH/37Ajn2TFv36cXSOkgIxGhhUxqcCTpY0RgIUF3Xt/Wtmm6BGLdikAoySh7DYvdOblEut3sZRC+UC0KfldxX2f7sJRJhfyhMM4azgn5DuE/By3O/LddyO/HU2/B3JxtvEbRoLD2yy/asthbh2pfxnKhg6oWYOn3p+f7fZwjEr/HBtczclpBdELzk+73D2m7bR2DQ7MfRlTZLX1AtXc/mJpga3IpkUo5ilB5y5HNjrjJIsc2nZ/TWQDVLIYdlRV+H5ShdiwjVjqO6heirkhLre043EkFTJMRuPCCIge+lPYwaw5OwN3XCphGEyg4yOKJcA3xzghPagzBSgwkrJsYLJztUIGQwAP9r7qiF+Om9tAulaKjqcB2duztZ2bxwUmouTImVt6oDmsC49DK9vq9Hc39kIf9V1t9MeURnXsYRwArRuzS6yBj3tME7V1fPpvkvcRT0avXJwPTea1r0P/6V98GvjDNtP1IomUaObT/N9GTpl8OMYchuh9k+ZM+aPotKC1JJ0nAmqETBTM3rQD6hizwY692vBtw9DnWJNtHwUEMxWw+bMUKov88uxP3grrQUTcFfxJS4j73mVJ7SrP2dlFkNhWjjQLQsNSbHx6R5yTVKqrMsYhFh5SD113rPJSPYEQIzkY7Qc4RwyfO84LnNUKhU0G/OaB/pl8RVJX+LUTgRPsyEY8RsIEMqaEfABTnTUP6GlOWShk33pI23P9hg9KcUArbO5Fomoa7+DiEHh4w7pIz/HVy11XcAWKt4ong6kZlx9wv9UK0RP185TGEjW0s7cjfsSC1lnkr+fNa3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199015)(86362001)(921005)(41300700001)(36756003)(2616005)(186003)(8936002)(5660300002)(30864003)(66476007)(66556008)(52116002)(66946007)(82960400001)(7406005)(8676002)(7416002)(6506007)(6666004)(107886003)(6486002)(966005)(316002)(478600001)(10290500003)(4326008)(6512007)(26005)(82950400001)(38100700002)(38350700002)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8t++c45qXRlkjvgdh6xaDsoC5phrogepB2tcosjx0BDb/5ItLA+kW+1olToh?=
 =?us-ascii?Q?0W6o9zZ1fxyblvuski+2RDa/UnwEbU+2HbJV0T04mppjvh4GNTKty3vLNDxj?=
 =?us-ascii?Q?sUQ8X89dK+b2KYIfE/XB6pIF2D60IcmDhE8vruI74JEtELtN3Wihm9hmhExC?=
 =?us-ascii?Q?pXGRco5fzKm05D0SEZeluNQ7SayL/z2P3gGGyLTdRofxIwN7HS1MaUu71O38?=
 =?us-ascii?Q?9DE6puPQWR1iW7HKFFd6jz6zI3fPdkbbY+qWgeC9JyNmuBvlrL676K8bI0/r?=
 =?us-ascii?Q?Q3I8PgF7WyEVkHAQ4ayFQcoHTZuQpr5ACk3unZj//jEpLCcvwvgbo7sPCUPY?=
 =?us-ascii?Q?PSCIEYp8uXWSHPz5rBkeCJ+7n0Dhm4sV+G60LJE46r19AQKCHatPEyu/Uatf?=
 =?us-ascii?Q?tLYRbyIIk8ssRA96Ldr+lF2SLuNOE3kEeKR8AMZSpDfaie/PZY8axBLvQAN/?=
 =?us-ascii?Q?bdiTI8QU7xoHEPxmu3xQNN1khW8HyavfAMMk/FbPENTqnQpDcGgpWuD8nsDK?=
 =?us-ascii?Q?0hIw165W0NmDueoVlxkSwXlWAmpI3+M//mEkwAxDob79YdN3Np+wxszQC51t?=
 =?us-ascii?Q?FZkvyTuylViHSlvQS0v6enMKUYpM5g2CMzGR231/zuzFAlDxPf2IlsAxqY1H?=
 =?us-ascii?Q?JjmDqPxFykmR0EusrrQo5TXALtOdiuvOARTsfL8dbmBaO+w/K+srfOLUxtaU?=
 =?us-ascii?Q?NE04bvM5gAZRP2SGmc/mk34ja324h4rXMbe5rQhjIdIkwt23mRCPSoRvJVyS?=
 =?us-ascii?Q?tRdf/LuaFuk/S/g9ArbW2yvwDYMFjx0TDbUNtU+RiYinOhR332bFdcK6y0Eg?=
 =?us-ascii?Q?cejthF/ZBnPaTeg+WjKuvKRDlrYS5CScqr1wGnIZa2rJfDlbL7Jr05acv0St?=
 =?us-ascii?Q?6ChuYMqMtT/WXAHtYpDN/ZNzA21FD/BqJq2CoNiJIfefNOzEpZn8hTYganFS?=
 =?us-ascii?Q?fcMSBRS1+x2es040KS4b4edla+/WqY27SUcp3Up5DsHVgT8+S/8IjOp/kADk?=
 =?us-ascii?Q?frle0K060NfTGDwepJS8F5+f3vn+v9LJIL2NsrplsDwWPgQPJfpBA0rs52KV?=
 =?us-ascii?Q?JrDORNJeXD2cFZYczNTJjPcSaoYzosy8whfUo0aRJConGFTaUYThg3oa9Asw?=
 =?us-ascii?Q?6Y0von13+FSgLvG4y4dDxANk3oj3+w6N7pjQ80fRs1dmdsOKn3s/78LNbeJe?=
 =?us-ascii?Q?2sFJIxQ/5+3t0pfaV/4tXl6A8i+DJxvB0dfGQftFg/oIi458qjyGHd285UAQ?=
 =?us-ascii?Q?tjxKrGhO6/hFFoBXuMzADQvPdfOTA7qwFUlbT0RtkExyQsqQUkvZ/nc6JD2I?=
 =?us-ascii?Q?W2jszUKg5wBqads00sHLSX3uuGlzKPp8NXEO6QkjRLW5z9zD3kRy/5CklPUX?=
 =?us-ascii?Q?zpk/5kMtwJtjwzfPn2QFm30MPUn67jnxTKAVC5dsywGdJ7hqF24580bgV/V4?=
 =?us-ascii?Q?CXpYZ1y8FXEsMB/lrlUWOZwAK7KnniJHTR9eNprJ+vfhcCir0mF8Un+wE6S7?=
 =?us-ascii?Q?HhhRszEPD6SRJncI1nEAUAc/lSHFeXE7KmHXaKXALRNh2baeu7zb0+adMpfN?=
 =?us-ascii?Q?mjkxINnFs9XnwTS3O17R/ddnXCADvBsjLyBkYtSqZR4iZWL+afECui18uV8L?=
 =?us-ascii?Q?0Q=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dba546e-6a69-4214-db7c-08dad415cee5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 03:32:15.9262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: umsDaGMVAcFn1BTPi4EjRDy/l+sMW27N4f/OQYXRhKKS0ThcpP32Xj4LHWPOhe30Ic0LZfrd9IrlknspWD5grQ==
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

To accomplish the switch in approach, the following must be done in
this single patch:

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
 arch/x86/coco/core.c             | 37 ++++++++++++++++++++--------
 arch/x86/hyperv/hv_init.c        | 11 ---------
 arch/x86/hyperv/ivm.c            | 52 +++++++++++++++++++++++++++++++---------
 arch/x86/include/asm/coco.h      |  1 -
 arch/x86/include/asm/mshyperv.h  |  8 ++-----
 arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/kernel/cpu/mshyperv.c   | 15 ++++++------
 arch/x86/mm/pat/set_memory.c     |  3 ---
 8 files changed, 78 insertions(+), 50 deletions(-)

diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index 49b44f8..c361c52 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -44,6 +44,24 @@ static bool intel_cc_platform_has(enum cc_attr attr)
 static bool amd_cc_platform_has(enum cc_attr attr)
 {
 #ifdef CONFIG_AMD_MEM_ENCRYPT
+
+	/*
+	 * Handle the SEV-SNP vTOM case where sme_me_mask must be zero,
+	 * and the other levels of SME/SEV functionality, including C-bit
+	 * based SEV-SNP, must not be enabled.
+	 */
+	if (sev_status & MSR_AMD64_SNP_VTOM_ENABLED) {
+		switch (attr) {
+		case CC_ATTR_GUEST_MEM_ENCRYPT:
+		case CC_ATTR_MEM_ENCRYPT:
+		case CC_ATTR_ACCESS_IOAPIC_ENCRYPTED:
+			return true;
+		default:
+			return false;
+		}
+	}
+
+	/* Handle the C-bit case */
 	switch (attr) {
 	case CC_ATTR_MEM_ENCRYPT:
 		return sme_me_mask;
@@ -76,11 +94,6 @@ static bool amd_cc_platform_has(enum cc_attr attr)
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
@@ -88,8 +101,6 @@ bool cc_platform_has(enum cc_attr attr)
 		return amd_cc_platform_has(attr);
 	case CC_VENDOR_INTEL:
 		return intel_cc_platform_has(attr);
-	case CC_VENDOR_HYPERV:
-		return hyperv_cc_platform_has(attr);
 	default:
 		return false;
 	}
@@ -103,11 +114,14 @@ u64 cc_mkenc(u64 val)
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
@@ -120,7 +134,10 @@ u64 cc_mkdec(u64 val)
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
index a823fde..6dbfb26 100644
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
index e8be4c2..8e2717d 100644
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
@@ -315,17 +314,48 @@ int hv_set_mem_host_visibility(unsigned long kbuffer, int pagecount, bool visibl
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
 
-- 
1.8.3.1

