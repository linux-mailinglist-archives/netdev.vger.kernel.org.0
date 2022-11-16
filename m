Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD17362C824
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbiKPSs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbiKPSnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:43:51 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022025.outbound.protection.outlook.com [40.93.200.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFAA26316A;
        Wed, 16 Nov 2022 10:42:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nS7ZDI6CzOQGLl5tiYAmu5Ok2FLCzV0w1btwOwnkP0ApDG8EGLQg5QAsA5WhSYGhv+SL0kD+xuHXrviY02PasIhFthReVZI6HQqZDWvz3oG2Q0qE8zSOOvBLNItu3CESYlb29EAcERrl6rO2Qn807DTcheuSsWVH1y5pOixEkpjN9TmUDaGoGxxTkCf6dYVIaH5IjdXmssk4nnBwMrJ854EfHu4f/CvLUmgZ5t3HtfmimBKV7Zj58nROcbx10yhPzEipbu1GYO0IZ2nlrBXX1gsKcayFyPCIz1++Nlg3OzrE6Z1STCJqjl5BeZdIZNkZ19bdyCMMxhgoWNEosvmd1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qPMtrSESHJaBt1mpSbTfPYvpZPUYx2MEcXASXYtjV3g=;
 b=HBj0871pSOtxULENrnLyzr9VB2pDf8y0TxqUJ3OnATo7LuwvH1GfkL6ACgSXAQ8it9zShv0BvkPwWDfD127e7kvLpMgMCpI6cNZ0a9O3/32YVsO0IXMMe2sbgxVDFZ971Q/QtqlRnuai/h7ELDhFW1evoPi4ccP+wAs7o47abl7vJR0zJrxjjsQmp9d9jBBlnAkVLHeKSg2XxXAJBL1Pum57n3Qp2SknXyBD7+ItnDl9hGDguspCnUPaq3MyeTKXO0+U9nnj4C/4/1QimqOLRc1cmS7nk2ubPGAmCu+CoXCwVNBfM6y+3VuAr98ZKEtbsvOD/nEWgK+aem5GyYsuhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPMtrSESHJaBt1mpSbTfPYvpZPUYx2MEcXASXYtjV3g=;
 b=IffvQ4qH6TlBcF8GCu0fMktrPllVyiZ6viWKscA4augdnUmJ+AYFfvj3R3+Nw0HLaYI31E3h9VpQsn6Sgu0BckR0wDwU9Bpn100OD2Fkd9Y7fKm4/efde/9bF9WwECgtpdWSpVabWxAkXZ8WLRfQB+/NIy8hUCRTNQAAd9Aj3Pg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by DM4PR21MB3130.namprd21.prod.outlook.com (2603:10b6:8:63::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.5; Wed, 16 Nov
 2022 18:42:37 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5857.005; Wed, 16 Nov 2022
 18:42:37 +0000
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
Subject: [Patch v3 07/14] x86/hyperv: Change vTOM handling to use standard coco mechanisms
Date:   Wed, 16 Nov 2022 10:41:30 -0800
Message-Id: <1668624097-14884-8-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0178.namprd03.prod.outlook.com
 (2603:10b6:303:8d::33) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|DM4PR21MB3130:EE_
X-MS-Office365-Filtering-Correlation-Id: df8f2ef8-2a8c-4560-bc93-08dac8025550
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 33JEd2u7gfestaJWif6zpGhoQ/oDCkUOqf7AT/0Qk72LrCTu3UEB062mS0DVymX9Wqw66K5Jcz95+GzSsZSnVnndR9Gq8s4SE+HgeL05yKQNLnzJl5v4jTkCoqdZPVtoX65ds1SBqJdLpaaZJxN0m1/hmbbBfpJjB19QydUntbWbycFatbhPldGZPYPqTyC40AHLFrTdknT7HWKIzYSDM3ijS7kp2hX1pAxsplPPActRjsbfUfn1awsUaworIn/TS0rsqtUnedrj0b3GIPURYOcTpYr83iq2QvAdxZIH0pEG37cMtUqZmFGDiEXGG3dNjbikSZgcRGIHTHYF4fuzY5Ms3ja4Rj9lIE1BKIQ4acYlKsnqwkNqsIU8jLfC9mp4ZPi87zRKmBy7Ys0nLmWvxk8n7MseoOYhiotN5bqaitLrkqL2mmELRwqQHZaLKKHNZcsYmYRzMsF4zi/BTEPB8rMgE8rYeRokg50ir38qAQ8z+yFAVvFNTE0KMLdydoKYbvz4ejlgkGq7h0PuU1wwKS7kOUBaTJw4yjVJr2GpxR7x52038TJp/aOrIMFMY6+2IlkcKH/sFOago15kavBRMc1rn/0ZnD9aDMhPRJU0WpJSEg0UMaiDxvhb2qhT4fuwIIXFafkQIgAkCRRxIMAk93idgTVuF/l0vFiVllh8qZ9Mc4T/sHgeP8PjSr1JnDtXm4nyJfK2qdqoNu9z/Yjb0rndj5d9dNum+QxZr57/NmIlqAdMB04+KA4pc66QSgUYupR4h3PjkRFU/mTDLSgdXc3neltm4AGc30uX1tOAD78oWdxeqT1ZAaGiBFGAD2qz5uMnvCH9AfElkuQe7WBMvZ0YqwdPLxslY9nk4bYvJd5GuTI5O69OL8AaBm0KxZ/mx9RfGkfAYvPlvX8+NafY2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199015)(4326008)(5660300002)(8676002)(8936002)(7406005)(30864003)(7416002)(2906002)(66556008)(66946007)(66476007)(41300700001)(107886003)(82950400001)(52116002)(2616005)(6666004)(82960400001)(966005)(6512007)(26005)(36756003)(10290500003)(186003)(83380400001)(316002)(6486002)(478600001)(38100700002)(38350700002)(6506007)(86362001)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AokvdOpD4ogBK/smO6VWKVIFRcIvVqF/5jVCZI1gftI+gZ294s333SKlbNGb?=
 =?us-ascii?Q?niE5A4jxGGWayC3tObkC/gEVoYm+b5zmYK6JYxugQQtbnGtc229Yc30j+r1N?=
 =?us-ascii?Q?T1EyfPa42ZfLpOidDQwGs/hjzg5Ry4iJUVpouyQmFijPu7FNjv48SHO91/cQ?=
 =?us-ascii?Q?+qSEPykGRUIxMIBzbhPxAx/Zslb/0f5uVaNQYzLJhbjfh+K5TBDprPgxIwUQ?=
 =?us-ascii?Q?ksjUT2S3z6TsNwXPjxgl5k1zuvfiMRUD15T36Sq7WHwcw0rc/oev/oJYhDwx?=
 =?us-ascii?Q?iOdbcnqyzHR80vgOLdHizw+Na+JC9T+Nz8QpATZdL8wOMIIZYeIbn/DCVrGN?=
 =?us-ascii?Q?j1t5B+/ocnWtSFQSXgrSCTcVgwCi8HZZTWWxj+ItDspkbl/iU7+BXuY2LnKd?=
 =?us-ascii?Q?CzdvA30ymhapM0GAOKzWgxOsyo0U6r8RKRrIXgQuONVnLlZswtwUskFo/Swn?=
 =?us-ascii?Q?0szNmXsUmdmBIFk1V8tBanGjSkosPtHf0wn50/FIcrgInahH+dzAKXJtTmzN?=
 =?us-ascii?Q?utlu0XRkqEzybBnTHz9k16VvFHHVMzCHLt9CryQErxdb1R/ySCwx4ByYyiuB?=
 =?us-ascii?Q?wccm2wiDOGp5KPjqGuk4BpyNsDlqvKdUN5j1YRpSwzjg3qOieIRvd1dPIW6W?=
 =?us-ascii?Q?IYMInfI8/BGeoWLiZl1uTJCxGmWZR+TAC9Ubq5sRO2fBbzKSMrFK8CDCs+OK?=
 =?us-ascii?Q?lwcrdWne+wNwg+zXl5Id2BSiUZ4fL79PlPCr+fXPi20q5sr39Xh2pWnMQNYQ?=
 =?us-ascii?Q?MbwDKNF+hEr/8YKqJU/Yk9HQh1lV8UR+I8M+M3yr5uMFIV9u6iTx/fZ+mO3H?=
 =?us-ascii?Q?T+IlZ6vAmf3E+64uBaU30gztcYR0XfqzfIpfDxlnIj140VpID3KvF41AI4Qa?=
 =?us-ascii?Q?A2s1HExvv9qO08Bjt4TQVNwDGXY0ZJljqXKh9NK0peOsM5wxpE4sscSYQqGL?=
 =?us-ascii?Q?NYdw+AU8u3pjWmfjEOkRf7inPxsWp7KPC2PN+1GSWLo7Me8anwRkNlcB493c?=
 =?us-ascii?Q?GGaCKVRDeMadFWIegEmQTSYFiLmAA+JvKkKFCPYlV+P3hNfk+Zy5SpxBiSFB?=
 =?us-ascii?Q?oi5Z8Ne5ZLdJyJb93RznoIseDDfz4pLiD/0JPLFc8k9E5283p/SI0PIggGJf?=
 =?us-ascii?Q?H94ey1ENKramhtKzHKH63j/Jh2XLvRw2Y9WHWBFYVhskfj0mMCCmYfn3+vdr?=
 =?us-ascii?Q?Q0i7DiZf13D9W930X4cB5dvnbOlcN2iWmUIJ/MhyTxw0bjD8lQaP/Vt7Vqvi?=
 =?us-ascii?Q?WTHRDq+qf6fKG+JWBIW9Lv8RKKvR52IjbAonWUnxolw7dPBrjjh6nQUf5nId?=
 =?us-ascii?Q?QhvszCsX4VjzHCVobLgJahLNu8hbSyA0MX7sGOZ7+Y58G4cdAmXvN1IL3XJa?=
 =?us-ascii?Q?VstKJxDVm3cxd+eYPARcrCvkOKWqw5RO7zic/socnzrfVUpoH194MEXZ8hCi?=
 =?us-ascii?Q?9UYg6fPoTEQcAyMxYYmgMWGrXTtEfS9fvWtI734hJ3XD7CJ2Q5ehFxjJL8qF?=
 =?us-ascii?Q?laylTceNKgOg9mk/0OuxEDdWx9iZNj//QPLDtiUDaEIn80uEgsA6pKnKzV8+?=
 =?us-ascii?Q?+DXZ+Ty36mTPv9ulkRSCoRvd+KtE8WLtgQg7ahlz?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df8f2ef8-2a8c-4560-bc93-08dac8025550
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 18:42:37.5065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D8RBwDfc2U51v/WNsu5H3CzbfoakMY2Vy4kq5ufU7/1/9kMDFy7bpM+FMrE3CLT4TP8AXF+7S5uittoD5k5fUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3130
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

* Update Hyper-V initialization to set the cc_mask based on vTOM
  and do other coco initialization.

* Update physical_mask so the vTOM bit is no longer treated as part
  of the physical address

* Update cc_mkenc() and cc_mkdec() to be active for Hyper-V guests.
  This makes the vTOM bit part of the protection flags.

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
 arch/x86/coco/core.c            | 11 +++++++++-
 arch/x86/hyperv/hv_init.c       | 11 ----------
 arch/x86/hyperv/ivm.c           | 45 +++++++++++++++++++++++++++++++----------
 arch/x86/include/asm/mshyperv.h |  8 ++------
 arch/x86/kernel/cpu/mshyperv.c  | 15 +++++++-------
 arch/x86/mm/pat/set_memory.c    |  3 ---
 6 files changed, 53 insertions(+), 40 deletions(-)

diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
index 49b44f8..f5e1f2d 100644
--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -78,7 +78,14 @@ static bool amd_cc_platform_has(enum cc_attr attr)
 
 static bool hyperv_cc_platform_has(enum cc_attr attr)
 {
-	return attr == CC_ATTR_GUEST_MEM_ENCRYPT;
+	switch (attr) {
+	case CC_ATTR_GUEST_MEM_ENCRYPT:
+	case CC_ATTR_MEM_ENCRYPT:
+	case CC_ATTR_EMULATED_IOAPIC:
+		return true;
+	default:
+		return false;
+	}
 }
 
 bool cc_platform_has(enum cc_attr attr)
@@ -108,6 +115,7 @@ u64 cc_mkenc(u64 val)
 	switch (vendor) {
 	case CC_VENDOR_AMD:
 		return val | cc_mask;
+	case CC_VENDOR_HYPERV:
 	case CC_VENDOR_INTEL:
 		return val & ~cc_mask;
 	default:
@@ -121,6 +129,7 @@ u64 cc_mkdec(u64 val)
 	switch (vendor) {
 	case CC_VENDOR_AMD:
 		return val & ~cc_mask;
+	case CC_VENDOR_HYPERV:
 	case CC_VENDOR_INTEL:
 		return val | cc_mask;
 	default:
diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index f49bc3e..89a97d7 100644
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
index 06eb8910..0757cfe 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2126,9 +2126,6 @@ static int __set_memory_enc_pgtable(unsigned long addr, int numpages, bool enc)
 
 static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
 {
-	if (hv_is_isolation_supported())
-		return hv_set_mem_host_visibility(addr, numpages, !enc);
-
 	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT))
 		return __set_memory_enc_pgtable(addr, numpages, enc);
 
-- 
1.8.3.1

