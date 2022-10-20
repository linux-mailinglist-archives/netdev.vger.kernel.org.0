Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286C0606787
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 19:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbiJTR7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 13:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbiJTR64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 13:58:56 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022019.outbound.protection.outlook.com [40.93.200.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D08199F70;
        Thu, 20 Oct 2022 10:58:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7NI6mIyKKk77K2merCDg75iZz5gYZGk4utdi957qT39BVrbmBm2vDYY1UaIYtGcPeyXTvlqgl5K8sKEhiaK/lJHSkYIMvpoPmM6IR7gkYRKsD0oFdi92EIr9VA7MLs7mn6EdBhzdXDlqgSxnOZp4fLZtrcxOQd9Qt+/JyjVLq8pblLh+cMIGCngCvFjfwg4yMTjEXGnDQJfDX8VcwOEzYS9cLIW3q68OXtO7xAmR89WJlSZyLz7dt92EvVQ9Z8vPJZypj0pwzF8It0NwuCX4MS9sXq72kwQTm3cjwbeTSq5h5saGqck5TYpG9qisEB0o/WwQqkSyGCCwv6Kk0DIVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FbT+KszCQ0CcPMoOUSbNemIkXPrl/6KRwuTXDQkmQ6Y=;
 b=eovXReeiv/3arMQ8edmsNklhFNGK9hdqOR/f+LjPQqjxKT0KYKaktkbzbOJd63NvqdAiERWWoxIskzfL0uaf9Xrm/1+YGH/ZGf163tjAE/ChNCo3vi9+Y+XuEKAC5C66G8ykWWuKieHTj0xOyQ3+yJfEJgI43LHk4SOQlrRkuN9myNQ4oZiw7VKWnOmYHCyiMpDQv3sYYr4t6NnS5L8X94GSadn77b7+iqyFhuILCyeOs5BVKd9k/yQ7Rds2PqmeZLstFfsm+u3U/5PUHZ8bZX1dFKEACuw09lRMuzQdaIZnFpBjfjpcQ+49oZxVInohvdgQVBe+XfA2L1cSKnWV0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbT+KszCQ0CcPMoOUSbNemIkXPrl/6KRwuTXDQkmQ6Y=;
 b=Cm2bntyraKEec0Y0vps8bODxGesEhblIWBWOw1PP/z96O5nVA52X0wNaLaJiQsY3LuSm8I+F5CBQazZqQ4cDcTww3msW/nAwKKVj2r3IuQzVYZ2KZaY3znMaubLI+H+YpggDR8jASLvHqSoIsplNNoBrI+uRb4e+yTUC1MleqIo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.17; Thu, 20 Oct
 2022 17:58:32 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa%3]) with mapi id 15.20.5723.019; Thu, 20 Oct 2022
 17:58:32 +0000
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
Subject: [PATCH 05/12] x86/hyperv: Change vTOM handling to use standard coco mechanisms
Date:   Thu, 20 Oct 2022 10:57:08 -0700
Message-Id: <1666288635-72591-6-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: bd397977-0fd8-49d0-1535-08dab2c4b3a2
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: crqAbYRf+wde73ONmSS97p023GsYnttDdrIHfyXycWT1N5yru1pUtUceUJZ3bR7iZKP15mTIjZ6OFXYEFGHM0bfVs/VXncAdqq8Btk5JLTSOh45Qj4Koca91Hb0LGiPejh7gWE5l1M/dCA/W2Sw43Vc6fYaefOYOc1F1wpMAqMuEuRen4z9RCmCE65HIOUwbHcP2ZTVEI7h2UGug1hnUgTWISwSb4bv968XKdEikOvNe0c1cpZ9shy5ROjhkKO5uJ7ptu0TgMJhhCLyalTDvvdkXJc6LwBpxdRMF+kdYpsx717rwrHY7JRJKsjw1IzFAsWpP/iCdIj53NIkKF9KI2cHvdOEjZJOBKCIeNu8ba4RH9Rd41QgYGfvUoeLBta8LuzLMiQNunI/bXqWAnfOPHckDas2b2WL4FIZfwBfG6bcE5VepdnvIbI/LZ8r4bdKoft3LVlD7taw4a6BlMRuCA2OnXSqbiCj5AHUBPoz4wihwkVjUc5HtxYX+sTABhCC2t6HUQ3x0FXhYqBTFwI5YMbYVHqqkS+Y+lvh3Ohz2C+WQ/BMJNRxyE3NlY0iDAk1N5ZCsm5Nu/059EnD49/ZnfTV+sBaKPRnSdz6upDGncllgFVKkoEcusXT4/eObQbsh0A/FbcDPed+1Ler5p3WpIjxpwNTt23eAY6TPIhG0pA+BxuY4dKW3Dck8UoCrhYf8qG8mi+IS0KPArSGDdu6T8jWyvXkyg1IFr7f4gcvuGoQvmZmJGaaPG/iuw0ukXjs9xUYkpZ2+tDuMbnECaDNPryBkhL2wyNKt3yQYURd9vgFnh1eZG3KSw/TcPKFa/NyGgKc7obwJ/4jLT+OT4I5mxXhDQIJvz0bmutbxHtcsdhO4hMnoHgz+cQleANjL6czNf9+Itc7AjfBYAOK8ir1yDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199015)(186003)(6512007)(6666004)(107886003)(83380400001)(7416002)(52116002)(26005)(2906002)(30864003)(5660300002)(6506007)(66556008)(41300700001)(8676002)(478600001)(966005)(8936002)(316002)(4326008)(66476007)(66946007)(6486002)(10290500003)(82950400001)(36756003)(86362001)(2616005)(7406005)(82960400001)(38100700002)(38350700002)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cj2irLjg+SAK3vKJRCd9o/g+/v2t6rC8QcWI569dP/ouD9KWSsdTx3YB54Wo?=
 =?us-ascii?Q?VHH4GHAu1uhmJ+ghA9u9WBfuomzTfHzeaHcpi40WUjz3ocgYCngAvewP5fLL?=
 =?us-ascii?Q?45rJeXuuWxn7qp8wOSRH5MWvZczVAAYRLA2JUxBI9/OMKh/fQfdEtk9DanA1?=
 =?us-ascii?Q?h24omWvVdPR9+2cYrBbkwuXHB5oARV7ywGZGZ8LVsst1KThRcnZc1xDJHQbi?=
 =?us-ascii?Q?I84GIe8/0v9kbtOQg/u/I0kn5mm9Hm9e/VZDSvmnbi+d3TuSGZ0fUbXovP0s?=
 =?us-ascii?Q?iI5iLR5U5IJSE1V8p0TYxX7Z8+fcego9PCDYGj4I7mYL+/bGC6a5QhH6EixR?=
 =?us-ascii?Q?buDaajejHEBIj2xhLMYHwm+4ltTFXOmgQKmH+PPR6xvpGAF6Ivk5aRivjbPY?=
 =?us-ascii?Q?mPZhDqzgo8LJ5/0FQnWkXVIlZxkOolBZbb/x1R6KEpbmhJdNwyldhqtJL2NL?=
 =?us-ascii?Q?NghpKcA//nXzLUq4mO+tM7PwpftCmLbzSEdbv3wgVOwnzEYm6yZOIbGrTcFf?=
 =?us-ascii?Q?7vqV3VZGJl6IQLHPkd7LP9pHTK3SqxSRB5vU+4/TXr0AYauL/HmQY39UHrH4?=
 =?us-ascii?Q?gKebYgh2+ezpP6NAdsKlCe+MP2JbH556HQb/fOvW1OR2B75AJIwzjbgh/uV1?=
 =?us-ascii?Q?50DRypKDfqooJ9Cn41Q0KHwifrF924t4A0oB03YSY588S/V5vg7Hpp2bqVlA?=
 =?us-ascii?Q?jChxrFS7s0qLv2dtE2BWNRTHdLFj7RWVAPn0YDtyh+lqZjm0rWu8FuuT8GUE?=
 =?us-ascii?Q?MxJw+cdLfYtn/3eu0N+Yfm/3RzTcwGGy0Qa+l/QJ4HcnHk8NW+xXZaXwSMR6?=
 =?us-ascii?Q?BQEHgKn5TqtQ9vYZMaG/HgymvnlkxIz3Hgq8R6UUtEp2fPfKYQHZoXT5udXR?=
 =?us-ascii?Q?/H8amBwvlolO51/WkQvlOBuIIemBQeqi4AbJXCVUkPz+i0Kpt20cVOsmgaFT?=
 =?us-ascii?Q?Ib1KX2qvr+W93Zg32bRsl2l4oGGa0ZzNm9AHEZIpRligiSwinwTmGjHGjwcD?=
 =?us-ascii?Q?DhAMhgwmO+QsgNUu9KjnznVIfi3AA31oiE2GMtjcezJi/nPodM4sef9EiVLB?=
 =?us-ascii?Q?9/DqjT+YyjBiAxcp8U2Y2Wtf8J6U/BS0XhbyxlEtps6oMzPJSpQ1Town34uu?=
 =?us-ascii?Q?B8SIvJrjQb5GbUrmYUIJncoo7rn/ClwHuao/NinzXYi4AStSMo82oHei6aZe?=
 =?us-ascii?Q?dyC5b64qkoveKu09iRDKGKhbjUQ68F2LCsymKiC6aUjssRNuHO3A6qC2Xm9W?=
 =?us-ascii?Q?v/tqUf3P6qRsgKK2oEATnQ7VaP4+i03AwhKN72t1Z6F/OfyLPu4kplTWG2Al?=
 =?us-ascii?Q?8RNWh7uiNtiCCOLawMf820vfUJWthmfVr40vuyyjjvzqtnniQonXFiyX+lUg?=
 =?us-ascii?Q?0UrbNR5J7kzzXQtKxk9cdlvGplI6IsByuiriAtOrj/BnDzSDLaFZHyUCl/LO?=
 =?us-ascii?Q?W0olJA8iSm/KUqSnMzZEg1P4Bk+7sUT0x3bbTMbaoSLuzEwxvRY9PTG3mo6b?=
 =?us-ascii?Q?Dod918A/nyIBnOIkKZQZZ5DFb7q9BIE1WQWzCmko17ozXPVel0BghBaKqvbb?=
 =?us-ascii?Q?2kzB/c1WNThjyd4z7Y+CXLEElLXYLZey69iq++/+?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd397977-0fd8-49d0-1535-08dab2c4b3a2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 17:58:32.5611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uakCjnpFAOTjvKi5AzpG9Xc9q70wf6us7BQImjlyYb6igYFhG1qZ9R4gl4oFeBe1W55vqhLe1VFCF1vC6FErhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1857
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
index 97342c4..c8612f5 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2116,10 +2116,8 @@ static int __set_memory_enc_pgtable(unsigned long addr, int numpages, bool enc)
 
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

