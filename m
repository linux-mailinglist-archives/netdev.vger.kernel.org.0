Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA106C94D2
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 15:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbjCZN4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 09:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbjCZN4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 09:56:03 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-cusazlp170110003.outbound.protection.outlook.com [IPv6:2a01:111:f403:c111::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00128A51;
        Sun, 26 Mar 2023 06:55:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jzghvx0apsEnEU0F/Wsp19UI6HMLAzDp31sUM8WjZ0Otf5TVDI/Qk4SPmHIIL5PNhFkVrfvLx0BwwaQbtf3SAgT+jjF/cvh6OwIUNRFFeBIkrIXKIa+VUCvcq8qIYakAsjuAnPQjZlLnguEl7l9MZAuw87F8dixi5KHewk3G7aatwNCzwYmsClIe9ukA3p3dFYmGkEXoEK3AaPrtjAfE+RbzyqVQcOTebumc4ZaFsoCiqINuubjjueMeDUdKWEC5J7Zi6V/oHqKCVebPwKNMtT7hmXTwhiiVy4BZW0gXIbhBbyrrk+bQWK+efUEGtfVeeeMJ/O2T8ARZFdIp8FjNFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gbY44/+BdsQQ12XPkkNa0EECdNIeOvA1nOIn1gHaafs=;
 b=PMHZ7qpEc0/iKT/hvxhvB19soOHkTkIjEsB3uvWJWWQ+Qx7DQlRe1kYpyYOO7yfK/QJGIpuUpLA+bZEBd6qg8VQmxoS/85D3SU+wD9/Fbg+1SlN9JWSoSTDSzLiK4M1+w01vG7X3fC6hjW4fZOu+puubLduIOGhBodBB1RJ03tGZlj003kUpusrQ0MigIDG6YFMg0S0grdbw1+rrLkHmGhJ6Id8NDaaOS0hwKG/tbJaXP9jF2xq12AmjbAzXjHgRp0AIBBEu5QYdgpY4dH7pUolfAJasnJMlSeF9WYb6ILEqepQoYjni8hux1ThsUfvMYybk9Afpz03wG8Pm/fVnQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbY44/+BdsQQ12XPkkNa0EECdNIeOvA1nOIn1gHaafs=;
 b=AGxeYTCQhe6TM4lrLIyIFcgLSSZHCtoAD7b7xn8JGbhoyA6XAn4xcO9f6HPj6a47H34DoKUPLON9bWoaRplzRYgzPjsvMJgLZcVIUbEWd+ZYGVnHRWXiovlhTVy87e8kG0V2QkNLAFl9Bko1Tr6ia/Z/l4oR0w8jcxpXqzzf+zg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB2001.namprd21.prod.outlook.com (2603:10b6:303:68::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.15; Sun, 26 Mar
 2023 13:53:32 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f%3]) with mapi id 15.20.6254.009; Sun, 26 Mar 2023
 13:53:32 +0000
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
Subject: [PATCH v7 12/12] PCI: hv: Enable PCI pass-thru devices in Confidential VMs
Date:   Sun, 26 Mar 2023 06:52:07 -0700
Message-Id: <1679838727-87310-13-git-send-email-mikelley@microsoft.com>
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
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|MW4PR21MB2001:EE_
X-MS-Office365-Filtering-Correlation-Id: 19e2419c-0cc0-4e6d-4b9e-08db2e017c75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8cyK4rqkQ7uhgT/63MQFyIlEpF/sBDl9XhM5DG3uqogonqRkxWJi6ZSOkmhcgtO4NMBvheUXmWxTS4wU1f85x8bCI8IgvrTpKJ/cdpO6y/kzqRtg/mQs1BhGEiyn4dnFM+OnD2RBuzNPC+yjGLhAGywuNpq53WeGVfY8JFzQ4UbiVf+Q/pw7YGU1wK1c8escrCyMBza/WEsA/tVytJXzCK+9Wd2+dMC16qlDEe8SW0i7TRJCDAqXLOotLnJi8l8DX7MHorxyT+dkZFMCCVM8/BfSwC1NStKbfN9YjLKQ8eunpiQcpW3goaQUE9Mejtv/SfvvPQJECH/M1UxoXN0dqTXoj9+Qi0igCXTp9zaL2hJTPzGaJmwYMAQFZg1Yb2QIhuxuZwIgRr9Pk2p8Cooh/unKKYa0raYoavtrDgxIKDyV9LEpsVJvtfAz39yI4CT/dYcNejApJmHS64rck/Hqv0m/DYCz1fm9/XpouVYOy8pCIrGwNn575Q3Sdq/2R6u1n+N25r63i5WSInCWOuVBZ1h6Mn9KhzKqP7AdKIpKok/i0+HeFANkylmPk7sqCjQ1xUgZY9Wa1Eofnq7/Z45HvqTCJoQEXYQYG7JkuL7nxrUQB299aj50/fp+2MLPTm6kvu+agXkNz9oTyJNpbD1pSaGSZjcDcvF2YYLUogEW66E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199021)(38100700002)(38350700002)(82950400001)(82960400001)(36756003)(86362001)(921005)(2906002)(6666004)(107886003)(10290500003)(186003)(26005)(478600001)(6506007)(6512007)(5660300002)(7416002)(7406005)(8936002)(52116002)(966005)(6486002)(41300700001)(30864003)(316002)(66556008)(66476007)(66946007)(4326008)(2616005)(8676002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Rdf/dciESQRn2tdCrxJeAG4Bs1/cjuqNkODQ1RsZssDn7fxDxZqa9rTEFjt4?=
 =?us-ascii?Q?o9HIsZnmKltAGoy3a9NMF0GqX4uOzYBM2lTGOWpmA7e+qhh48HGUct4qe3IE?=
 =?us-ascii?Q?wG8q4tN7RlV1RaCPBhfgAU8SPhY9QBP620wyj5CBadl3me5xgRhHdY8/4Boy?=
 =?us-ascii?Q?KE8u+ltuYH+P0zbIMooGwWBj1TP5TWK2Wa44sU5L06JcRAZX/Mp00u8u1yyc?=
 =?us-ascii?Q?KT6+8o/wiF9Zp825u/aQVnsHGoKuUqNENY9p1uQ8SNdy8VKGXQ5W/2AGrFft?=
 =?us-ascii?Q?CL+/K1lfqydtBCmV0uIuq7HGmV+zIsxR/Zo++huSQOO9uHe350LMksm3NhZ3?=
 =?us-ascii?Q?RJGFeDdG+Asm7Q/ApflRIo9IMUmbtyWeNxBoswcN3FMrDUjIQr7yIbw+V2fT?=
 =?us-ascii?Q?OdVsNRJMFuHlybAD0KFDQqOgyAkuwf0nH6bqma6CXg9UsHD9kiAlNCjq6PNL?=
 =?us-ascii?Q?yZTWg9+9Ke9s9nHdYNP8FB28oac73eLkGXriiwmSFyeq+29J1ofH3wt9H60P?=
 =?us-ascii?Q?LlqHf9Wd1CUMAx9dpq4+XGp9+ocWzg/xy6aNmnt8pL8obdP8f7fJhgSdSVSd?=
 =?us-ascii?Q?OuNCWPtEkj/1wh8y8R42eq09dXO9bcXSGdX/qhp1zlnlrEEd0kbOZXJ0cWCc?=
 =?us-ascii?Q?1rYEWhQT2rkp/zFEe5jKASTBGOicfWx503psZleBaDxkH+wVtRV+M3nkXtrq?=
 =?us-ascii?Q?U+a32I8IDnI+3BCxSqbFfSMNR38OVFx/Cp0TLwLWUh+v2VgldXhINyp8bIF7?=
 =?us-ascii?Q?nWzfdxuwMBazWIycUT67KFoEoP/h5WMbvLPuA0UpTmSFda6s0M3ufL8VA1Y1?=
 =?us-ascii?Q?NsX9HBMycu/7O9wUO3cYqCdpjcQJOtgUNFF/SOCmycHcCFx/ELAuA6MUCUjq?=
 =?us-ascii?Q?9ylB9ex7OS+yqbNJDci6u0vswJuDDczixxIUPGSFSxk2+gTagQFBZPXhBx7V?=
 =?us-ascii?Q?JV9/6jueyzG3H0Z7s7x4OAcqBsgcNgDwy7OIORcq835SOJZQiNzb5vdNDwiz?=
 =?us-ascii?Q?6zdbWnRh2tX0EIVyK0bZSYZfV68nPsE7ec4b5skJ2XIrrg+uBwBG1cCsHK+a?=
 =?us-ascii?Q?0UL0HV0ObxX4yc3B97G93MGPcin8D23y7E1foX1QPcc+uq//Fp+fLSKCm47Z?=
 =?us-ascii?Q?ob3tMZD8ajtmd2tJA+71hnMrvHTuZhS7enj3D2AtAo4ZDFAwkDqYYg5FDWxx?=
 =?us-ascii?Q?q951oak5Yjq5Iv+g3DwRLkOp/sHT8XLwJOLmhDBl5xfboKc7re7Wd/IDetbd?=
 =?us-ascii?Q?Fjg0pIS1H+Y4TjMQq+UZyEYPF2+iFlGsKDu8JW6yf/WPAEvaEG+lr104U5AW?=
 =?us-ascii?Q?JlTBioa4d8UnQIAjpb0J5AZyJvuFPKbAT90nEP9GrplfaMaIsvidjywm7TIS?=
 =?us-ascii?Q?UG3IrGsFxbMsnCIB4wr0+Z8yDbKIx20RG+Qikp/pI+/j8X4LLvVX0H3Dm2nB?=
 =?us-ascii?Q?64I/jNnCVN49e1ZY60p58Aei9aiFqLBeAxLlNMBE838ER4dCPx4Km2lnzgI/?=
 =?us-ascii?Q?7AXZ7o9uKoTrOn4u6JYce3s6XRKRJayzqScAwA9ZStTMS9JwGR3usgJeIcFT?=
 =?us-ascii?Q?NLSKA4BEWE98dHkXkQxoE6w7KdPK06UDOw7/JLBcvK8YfEzq8IA97nNw32ai?=
 =?us-ascii?Q?uw=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19e2419c-0cc0-4e6d-4b9e-08db2e017c75
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 13:53:32.2313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jjUfcKcLxgOt7KKL9pVc0mCABKvaHo1z1/VkPIiGQzr4PykDE0d03UN9bHjOGpO91tKqbzWFOw4Pt6SBDbdWrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB2001
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For PCI pass-thru devices in a Confidential VM, Hyper-V requires
that PCI config space be accessed via hypercalls.  In normal VMs,
config space accesses are trapped to the Hyper-V host and emulated.
But in a confidential VM, the host can't access guest memory to
decode the instruction for emulation, so an explicit hypercall must
be used.

Add functions to make the new MMIO read and MMIO write hypercalls.
Update the PCI config space access functions to use the hypercalls
when such use is indicated by Hyper-V flags.  Also, set the flag to
allow the Hyper-V PCI driver to be loaded and used in a Confidential
VM (a.k.a., "Isolation VM").  The driver has previously been hardened
against a malicious Hyper-V host[1].

[1] https://lore.kernel.org/all/20220511223207.3386-2-parri.andrea@gmail.com/

Co-developed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 arch/x86/include/asm/hyperv-tlfs.h  |   3 +
 drivers/hv/channel_mgmt.c           |   2 +-
 drivers/pci/controller/pci-hyperv.c | 232 ++++++++++++++++++++++++++----------
 include/asm-generic/hyperv-tlfs.h   |  22 ++++
 4 files changed, 194 insertions(+), 65 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 0b73a80..b4fb75b 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -122,6 +122,9 @@
 /* Recommend using enlightened VMCS */
 #define HV_X64_ENLIGHTENED_VMCS_RECOMMENDED		BIT(14)
 
+/* Use hypercalls for MMIO config space access */
+#define HV_X64_USE_MMIO_HYPERCALLS			BIT(21)
+
 /*
  * CPU management features identification.
  * These are HYPERV_CPUID_CPU_MANAGEMENT_FEATURES.EAX bits.
diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index cc23b90..007f26d 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -67,7 +67,7 @@
 	{ .dev_type = HV_PCIE,
 	  HV_PCIE_GUID,
 	  .perf_device = false,
-	  .allowed_in_isolated = false,
+	  .allowed_in_isolated = true,
 	},
 
 	/* Synthetic Frame Buffer */
diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index f33370b..337f3b4 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -514,6 +514,7 @@ struct hv_pcibus_device {
 
 	/* Highest slot of child device with resources allocated */
 	int wslot_res_allocated;
+	bool use_calls; /* Use hypercalls to access mmio cfg space */
 
 	/* hypercall arg, must not cross page boundary */
 	struct hv_retarget_device_interrupt retarget_msi_interrupt_params;
@@ -1041,6 +1042,70 @@ static int wslot_to_devfn(u32 wslot)
 	return PCI_DEVFN(slot_no.bits.dev, slot_no.bits.func);
 }
 
+static void hv_pci_read_mmio(struct device *dev, phys_addr_t gpa, int size, u32 *val)
+{
+	struct hv_mmio_read_input *in;
+	struct hv_mmio_read_output *out;
+	u64 ret;
+
+	/*
+	 * Must be called with interrupts disabled so it is safe
+	 * to use the per-cpu input argument page.  Use it for
+	 * both input and output.
+	 */
+	in = *this_cpu_ptr(hyperv_pcpu_input_arg);
+	out = *this_cpu_ptr(hyperv_pcpu_input_arg) + sizeof(*in);
+	in->gpa = gpa;
+	in->size = size;
+
+	ret = hv_do_hypercall(HVCALL_MMIO_READ, in, out);
+	if (hv_result_success(ret)) {
+		switch (size) {
+		case 1:
+			*val = *(u8 *)(out->data);
+			break;
+		case 2:
+			*val = *(u16 *)(out->data);
+			break;
+		default:
+			*val = *(u32 *)(out->data);
+			break;
+		}
+	} else
+		dev_err(dev, "MMIO read hypercall error %llx addr %llx size %d\n",
+				ret, gpa, size);
+}
+
+static void hv_pci_write_mmio(struct device *dev, phys_addr_t gpa, int size, u32 val)
+{
+	struct hv_mmio_write_input *in;
+	u64 ret;
+
+	/*
+	 * Must be called with interrupts disabled so it is safe
+	 * to use the per-cpu input argument memory.
+	 */
+	in = *this_cpu_ptr(hyperv_pcpu_input_arg);
+	in->gpa = gpa;
+	in->size = size;
+	switch (size) {
+	case 1:
+		*(u8 *)(in->data) = val;
+		break;
+	case 2:
+		*(u16 *)(in->data) = val;
+		break;
+	default:
+		*(u32 *)(in->data) = val;
+		break;
+	}
+
+	ret = hv_do_hypercall(HVCALL_MMIO_WRITE, in, NULL);
+	if (!hv_result_success(ret))
+		dev_err(dev, "MMIO write hypercall error %llx addr %llx size %d\n",
+				ret, gpa, size);
+}
+
 /*
  * PCI Configuration Space for these root PCI buses is implemented as a pair
  * of pages in memory-mapped I/O space.  Writing to the first page chooses
@@ -1059,8 +1124,10 @@ static int wslot_to_devfn(u32 wslot)
 static void _hv_pcifront_read_config(struct hv_pci_dev *hpdev, int where,
 				     int size, u32 *val)
 {
+	struct hv_pcibus_device *hbus = hpdev->hbus;
+	struct device *dev = &hbus->hdev->device;
+	int offset = where + CFG_PAGE_OFFSET;
 	unsigned long flags;
-	void __iomem *addr = hpdev->hbus->cfg_addr + CFG_PAGE_OFFSET + where;
 
 	/*
 	 * If the attempt is to read the IDs or the ROM BAR, simulate that.
@@ -1088,56 +1155,79 @@ static void _hv_pcifront_read_config(struct hv_pci_dev *hpdev, int where,
 		 */
 		*val = 0;
 	} else if (where + size <= CFG_PAGE_SIZE) {
-		spin_lock_irqsave(&hpdev->hbus->config_lock, flags);
-		/* Choose the function to be read. (See comment above) */
-		writel(hpdev->desc.win_slot.slot, hpdev->hbus->cfg_addr);
-		/* Make sure the function was chosen before we start reading. */
-		mb();
-		/* Read from that function's config space. */
-		switch (size) {
-		case 1:
-			*val = readb(addr);
-			break;
-		case 2:
-			*val = readw(addr);
-			break;
-		default:
-			*val = readl(addr);
-			break;
+
+		spin_lock_irqsave(&hbus->config_lock, flags);
+		if (hbus->use_calls) {
+			phys_addr_t addr = hbus->mem_config->start + offset;
+
+			hv_pci_write_mmio(dev, hbus->mem_config->start, 4,
+						hpdev->desc.win_slot.slot);
+			hv_pci_read_mmio(dev, addr, size, val);
+		} else {
+			void __iomem *addr = hbus->cfg_addr + offset;
+
+			/* Choose the function to be read. (See comment above) */
+			writel(hpdev->desc.win_slot.slot, hbus->cfg_addr);
+			/* Make sure the function was chosen before reading. */
+			mb();
+			/* Read from that function's config space. */
+			switch (size) {
+			case 1:
+				*val = readb(addr);
+				break;
+			case 2:
+				*val = readw(addr);
+				break;
+			default:
+				*val = readl(addr);
+				break;
+			}
+			/*
+			 * Make sure the read was done before we release the
+			 * spinlock allowing consecutive reads/writes.
+			 */
+			mb();
 		}
-		/*
-		 * Make sure the read was done before we release the spinlock
-		 * allowing consecutive reads/writes.
-		 */
-		mb();
-		spin_unlock_irqrestore(&hpdev->hbus->config_lock, flags);
+		spin_unlock_irqrestore(&hbus->config_lock, flags);
 	} else {
-		dev_err(&hpdev->hbus->hdev->device,
-			"Attempt to read beyond a function's config space.\n");
+		dev_err(dev, "Attempt to read beyond a function's config space.\n");
 	}
 }
 
 static u16 hv_pcifront_get_vendor_id(struct hv_pci_dev *hpdev)
 {
+	struct hv_pcibus_device *hbus = hpdev->hbus;
+	struct device *dev = &hbus->hdev->device;
+	u32 val;
 	u16 ret;
 	unsigned long flags;
-	void __iomem *addr = hpdev->hbus->cfg_addr + CFG_PAGE_OFFSET +
-			     PCI_VENDOR_ID;
 
-	spin_lock_irqsave(&hpdev->hbus->config_lock, flags);
+	spin_lock_irqsave(&hbus->config_lock, flags);
 
-	/* Choose the function to be read. (See comment above) */
-	writel(hpdev->desc.win_slot.slot, hpdev->hbus->cfg_addr);
-	/* Make sure the function was chosen before we start reading. */
-	mb();
-	/* Read from that function's config space. */
-	ret = readw(addr);
-	/*
-	 * mb() is not required here, because the spin_unlock_irqrestore()
-	 * is a barrier.
-	 */
+	if (hbus->use_calls) {
+		phys_addr_t addr = hbus->mem_config->start +
+					 CFG_PAGE_OFFSET + PCI_VENDOR_ID;
+
+		hv_pci_write_mmio(dev, hbus->mem_config->start, 4,
+					hpdev->desc.win_slot.slot);
+		hv_pci_read_mmio(dev, addr, 2, &val);
+		ret = val;  /* Truncates to 16 bits */
+	} else {
+		void __iomem *addr = hbus->cfg_addr + CFG_PAGE_OFFSET +
+					     PCI_VENDOR_ID;
+		/* Choose the function to be read. (See comment above) */
+		writel(hpdev->desc.win_slot.slot, hbus->cfg_addr);
+		/* Make sure the function was chosen before we start reading. */
+		mb();
+		/* Read from that function's config space. */
+		ret = readw(addr);
+		/*
+		 * mb() is not required here, because the
+		 * spin_unlock_irqrestore() is a barrier.
+		 */
+	}
 
-	spin_unlock_irqrestore(&hpdev->hbus->config_lock, flags);
+	spin_unlock_irqrestore(&hbus->config_lock, flags);
 
 	return ret;
 }
@@ -1152,39 +1242,51 @@ static u16 hv_pcifront_get_vendor_id(struct hv_pci_dev *hpdev)
 static void _hv_pcifront_write_config(struct hv_pci_dev *hpdev, int where,
 				      int size, u32 val)
 {
+	struct hv_pcibus_device *hbus = hpdev->hbus;
+	struct device *dev = &hbus->hdev->device;
+	int offset = where + CFG_PAGE_OFFSET;
 	unsigned long flags;
-	void __iomem *addr = hpdev->hbus->cfg_addr + CFG_PAGE_OFFSET + where;
 
 	if (where >= PCI_SUBSYSTEM_VENDOR_ID &&
 	    where + size <= PCI_CAPABILITY_LIST) {
 		/* SSIDs and ROM BARs are read-only */
 	} else if (where >= PCI_COMMAND && where + size <= CFG_PAGE_SIZE) {
-		spin_lock_irqsave(&hpdev->hbus->config_lock, flags);
-		/* Choose the function to be written. (See comment above) */
-		writel(hpdev->desc.win_slot.slot, hpdev->hbus->cfg_addr);
-		/* Make sure the function was chosen before we start writing. */
-		wmb();
-		/* Write to that function's config space. */
-		switch (size) {
-		case 1:
-			writeb(val, addr);
-			break;
-		case 2:
-			writew(val, addr);
-			break;
-		default:
-			writel(val, addr);
-			break;
+		spin_lock_irqsave(&hbus->config_lock, flags);
+
+		if (hbus->use_calls) {
+			phys_addr_t addr = hbus->mem_config->start + offset;
+
+			hv_pci_write_mmio(dev, hbus->mem_config->start, 4,
+						hpdev->desc.win_slot.slot);
+			hv_pci_write_mmio(dev, addr, size, val);
+		} else {
+			void __iomem *addr = hbus->cfg_addr + offset;
+
+			/* Choose the function to write. (See comment above) */
+			writel(hpdev->desc.win_slot.slot, hbus->cfg_addr);
+			/* Make sure the function was chosen before writing. */
+			wmb();
+			/* Write to that function's config space. */
+			switch (size) {
+			case 1:
+				writeb(val, addr);
+				break;
+			case 2:
+				writew(val, addr);
+				break;
+			default:
+				writel(val, addr);
+				break;
+			}
+			/*
+			 * Make sure the write was done before we release the
+			 * spinlock allowing consecutive reads/writes.
+			 */
+			mb();
 		}
-		/*
-		 * Make sure the write was done before we release the spinlock
-		 * allowing consecutive reads/writes.
-		 */
-		mb();
-		spin_unlock_irqrestore(&hpdev->hbus->config_lock, flags);
+		spin_unlock_irqrestore(&hbus->config_lock, flags);
 	} else {
-		dev_err(&hpdev->hbus->hdev->device,
-			"Attempt to write beyond a function's config space.\n");
+		dev_err(dev, "Attempt to write beyond a function's config space.\n");
 	}
 }
 
@@ -3563,6 +3665,7 @@ static int hv_pci_probe(struct hv_device *hdev,
 	hbus->bridge->domain_nr = dom;
 #ifdef CONFIG_X86
 	hbus->sysdata.domain = dom;
+	hbus->use_calls = !!(ms_hyperv.hints & HV_X64_USE_MMIO_HYPERCALLS);
 #elif defined(CONFIG_ARM64)
 	/*
 	 * Set the PCI bus parent to be the corresponding VMbus
@@ -3572,6 +3675,7 @@ static int hv_pci_probe(struct hv_device *hdev,
 	 * information to devices created on the bus.
 	 */
 	hbus->sysdata.parent = hdev->device.parent;
+	hbus->use_calls = false;
 #endif
 
 	hbus->hdev = hdev;
diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
index b870983..ea406e9 100644
--- a/include/asm-generic/hyperv-tlfs.h
+++ b/include/asm-generic/hyperv-tlfs.h
@@ -168,6 +168,8 @@ struct ms_hyperv_tsc_page {
 #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
 #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
 #define HVCALL_MODIFY_SPARSE_GPA_PAGE_HOST_VISIBILITY 0x00db
+#define HVCALL_MMIO_READ			0x0106
+#define HVCALL_MMIO_WRITE			0x0107
 
 /* Extended hypercalls */
 #define HV_EXT_CALL_QUERY_CAPABILITIES		0x8001
@@ -796,4 +798,24 @@ struct hv_memory_hint {
 	union hv_gpa_page_range ranges[];
 } __packed;
 
+/* Data structures for HVCALL_MMIO_READ and HVCALL_MMIO_WRITE */
+#define HV_HYPERCALL_MMIO_MAX_DATA_LENGTH 64
+
+struct hv_mmio_read_input {
+	u64 gpa;
+	u32 size;
+	u32 reserved;
+} __packed;
+
+struct hv_mmio_read_output {
+	u8 data[HV_HYPERCALL_MMIO_MAX_DATA_LENGTH];
+} __packed;
+
+struct hv_mmio_write_input {
+	u64 gpa;
+	u32 size;
+	u32 reserved;
+	u8 data[HV_HYPERCALL_MMIO_MAX_DATA_LENGTH];
+} __packed;
+
 #endif
-- 
1.8.3.1

