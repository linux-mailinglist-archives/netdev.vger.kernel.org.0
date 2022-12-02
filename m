Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA0A63FF0F
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 04:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiLBDeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 22:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbiLBDdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 22:33:19 -0500
Received: from DM4PR02CU001-vft-obe.outbound.protection.outlook.com (mail-centralusazon11022022.outbound.protection.outlook.com [52.101.63.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F0019C29;
        Thu,  1 Dec 2022 19:32:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPPLKjRbNWTTcO1AmAofKuzGuYgCsdBWFqsdpFH2EoFlJNWMykxIaG91gXeohrfeGPYjSWEcODYmX0X4t00QHVfmG/cy6u0fuIfFbQZDppEUCsjtW3PlEOvCepHKjDjSha1z25ilPSZNogjDv2vDIvSUyvDj0OsGI3PsZNhK3sovUxoPqTifWVvDbPWv9D7W5plnO4nXrpT1iOM/04zKL1NCyomg/8iBk7EF06OhSEf0mbLOUHxG/A0xA17i6l9tTrCDXCxBHviH4VI3cUZV9plMmRWCU8PCIyweWi4Fka8K5ypXTgQKEBGx4v7Z5Wh1LBtYNhdMJmVPD9KBu+D1PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fao+CpNeHFJc4G6Mr1e63n4rwyy3SRB0nquX09ZWVsw=;
 b=ADlKeqrgTy/lWHI3A7MwaBdU5TR+6lM6GP5B+D1C0XwQwXsZ7KEJr1MqW56tTbw2bL8uWS7HwzjuTK0LrTifshilpQ15ZFqV9JS4p80A58jhUGRLjo2Doy7IsJw7WNQgvPC1Vv+Kbt9Sh9eJM4ZVrDRI5N3hgURdDg7WapB/BhLsAQ/eBmJKliP7Rr6XkZ7xTGBsMbIXCa9fbQ4D/hn4JMokem8bSwoL6j0HcJysdtvfLdZ1XVSMM5sLlOzJ7pstpe5ZISVDDNIVn1bbbN80LpfyGe7W/pOsYmuI3C5Ux7PFhcaQ6Rh9gaitW/7nO1hqNMQ/DiXd+ffQYgfP0xmI4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fao+CpNeHFJc4G6Mr1e63n4rwyy3SRB0nquX09ZWVsw=;
 b=jbzL4LbSjCyUajX1/r7JoUuH0oR/5rQqjX5KGrxPLxTYREBf3g3Cjk6Co6p1bK9RCe9OTYlkZYX27uZe2BPozbWHUvPNpuZzmpHpGEI+ZidexHx7dSDMlm8RRwtJNyM7Ga2hPUBPvl+f0x4Yjl63hGr7Pv/bUdSMlp9/HOY5yYc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.4; Fri, 2 Dec
 2022 03:32:29 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5901.008; Fri, 2 Dec 2022
 03:32:29 +0000
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
Subject: [Patch v4 12/13] PCI: hv: Add hypercalls to read/write MMIO space
Date:   Thu,  1 Dec 2022 19:30:30 -0800
Message-Id: <1669951831-4180-13-git-send-email-mikelley@microsoft.com>
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
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|DM6PR21MB1340:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d9b17aa-f78d-4f1f-8d02-08dad415d6b1
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kdzk4RHK8iKrC7YdoSTARdQ5T76p38djC0WRxKfFVvarMDJwtGTPHepxGeSGWhhu97hXjRRrr2dYKu5D8Evr1FecSgMlUAonRcWy39NRcZIQV26o8JgS4dFma3YoV6qF+jsibt6HtKrFN6R8DcYj2uXFFrY9O3Vvww5LkuyNb/V/PzYTW7epptHL2uH2OOs37aOw6swY+32yPiUlgkjgG2pGZ9uXs/5/pa83gkaHF/MzgUUNX3QRWKNKuPaa1MMK3JEF1Y+YJDxN1Ozkg1oDleuugBA9Uuc18hY0jvkOHTn8LipR00712Cy3YKBVzTPN+Fw8niLxjZQ4eIuf2sfCIrVRF3F/7LR3gPDxg5IJ2ud9F3y7P4NarqtHrxrPChsMT3mQQTHfewhTtbaoO8h9jbuRjSYtcytyolWLvgaDspCgiYKixhYlZb2hjKdC7xl7+MPjHiugsgQwU+hR3nonmXC4saqJaZtCcha7V0do1UoNpygILQhQ/HmHp4kIXJISK2RwhBj/DO9dRdnR6Kf4Z76R0hbTXPCAqc8iE//lwjni5eiKGIVXoJ2625LA+4JjaGJrY5j1+dplQcrpXbmbl76sSOoGsYKsI8xlh3jMhKkzcBFo+U1/i3/qwxufPFlx0/tMOsStx7CC4QmWeNj64kq6bR5R32bzjeItCS/haXupA7GWjTfM+F4iDJIXu0rH+sU1wHV95FK/qc6t5vC8R/mC/eH75gHbsPdHFoG65AIbXWA+tHGy0qLu1hJBh9QV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199015)(186003)(8936002)(8676002)(10290500003)(2616005)(107886003)(86362001)(2906002)(36756003)(7416002)(41300700001)(82950400001)(7406005)(82960400001)(66476007)(66556008)(83380400001)(66946007)(316002)(4326008)(921005)(5660300002)(52116002)(478600001)(6486002)(6506007)(6666004)(38350700002)(6512007)(38100700002)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1LOXEKhGdHpK6ln5RcaKi10eb0QrMdOOBBMy/VsireyC5X4DvAGtaUfK9pgv?=
 =?us-ascii?Q?BWW1YhR43YxaA154DSOUvKUtFJZLWmWWLYZS4hc1wRWJoc1ZaBAWLm33E8Yi?=
 =?us-ascii?Q?6dcF3jKE/jTCsjz5j7ms9WK9Z1WNExu3sZZQYbTWHTgZpYaEesCIgWAA5/Rf?=
 =?us-ascii?Q?8jB2S960rZG/EpkA8RUr3x5pZfCCrtbhGcEFktk0EKeCoEUdyyTjsp1b0RSX?=
 =?us-ascii?Q?BnmwuLDdr/pYBsyMujCTAnlogBmubKD8BuIrpMvvt2Z/F4IQsS2qNhV1o8Ho?=
 =?us-ascii?Q?Xk6HhxLvtqrpBwb9SZUQQobs8y//am1VPq/4IOMjIHf2AaAnljF9zrCB1JeZ?=
 =?us-ascii?Q?VGd2KAh0LzkQT7nL7jKcfM99IM7ukeoYvsjZ7Y1n/KnOU7gAzRmTW7VSVmA/?=
 =?us-ascii?Q?Fb+QcMYdcahdbt26qp0jCGSefRlDtgNkl4QQv0k1guLpmA7XRk6W9ostjJ0/?=
 =?us-ascii?Q?DIhKrSy7L7XogQxMpSYLjgA3fDtBAVoqN//GNQ7zwjYUZAHO1w/+0uoOsMKW?=
 =?us-ascii?Q?xXyc9Fffozea8ep7gfq+wWrkYCmjaV6tSVopdbLPvQrddUB/akkRB2V8xsMa?=
 =?us-ascii?Q?4fBKPM3i7d4IuiLDwHfKdI+lxOpx/kkaWTDO7MnS6vKibqcKkWymTRwdbkr2?=
 =?us-ascii?Q?O4a5Cth7iIO0a1XmX+mzz8ArTfU4rZe5NKu3dkV1PQa2Aa0xArdMOQLul026?=
 =?us-ascii?Q?T7a376DniCR9rk0LCbQ70PuhKm15LA5QgDd1InnNa34rNP+m2OjCSYSwW+cn?=
 =?us-ascii?Q?gNwglJ8azhnI83MKqtorMjWmxKFxlLmJdKaivAlZAhf94wScFMQJZbLZbS7D?=
 =?us-ascii?Q?m4r8dg4GxS5UixjUYxCQ/1t/AoG8I7mPHNf+AmoqxZW9NaxwrlIspnjsKaAy?=
 =?us-ascii?Q?BssZn7UO2JJDp2rZt3iBMy1+g6Z1x+TjoFcxl7k6WRrZYO3J25bhhsyMH+lm?=
 =?us-ascii?Q?GRb4Nx6mMjEktK41fhvSypqn4KI9ccGzV8BE7Bq7fDcpqiMnsvR+nuwFUDjG?=
 =?us-ascii?Q?MUujY82GUSaNou3+kiIjpuZTlHTvabbQcQLJ9w2AmqoE3IXf6Nx7K80kDXa/?=
 =?us-ascii?Q?PBpgL09wQbxLCW80x7aTpw1Yb2pHnbhfj716LPKbksZkCbUg0NZAFRfHBqlx?=
 =?us-ascii?Q?/84w9VWp7wZeyl5Rs4MKafMY78bPZ9Qvxw0lfhzfrbhErLenTnNwHpguEoAs?=
 =?us-ascii?Q?2roBjO2DKU3ZgLtdhrTP5IDbdDUCvU1XX8BI7j+g2fKxFY6uwZ52Ltxxx1q0?=
 =?us-ascii?Q?HSVG+DIrxpoInKR82QFPBURCuBu+Juhyeq1wKnfdwJVjXNspC5aovmzmPCM1?=
 =?us-ascii?Q?yeHLujvnkLCIDNgZlx2bs6FVEk24t01SKrrCJQ0P6YrRxZt63KVkhlApLRP9?=
 =?us-ascii?Q?YrQyz0c8Bwlx8TT9zY5pBUyLPkiYcTeV8TLMxRm1Lkuk7czD90b5CDTDHq+8?=
 =?us-ascii?Q?QGfMZFKOwQMmI5caMf3ok7z1s5ZVk789Jtp+ek3kTfENUPdqj2gkLDvSp9EH?=
 =?us-ascii?Q?GjFIXk5OvDqxlhkAQgbIAUazVwXL3VK4neA9G9qaDkij/F/N01FJ4tgb2hJo?=
 =?us-ascii?Q?Qw4y+hXYzo5SniMeoh2OfVENXXr9+3B8gzSmynmt9fMC1U/eL/RstHuQINEG?=
 =?us-ascii?Q?pw=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d9b17aa-f78d-4f1f-8d02-08dad415d6b1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 03:32:29.0208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gkuCLU+DZWqqm4UP4Fhxq5RhS0nsXtYqSBlnNbbjAAJ2J5Q8S9/z9+x5duUybzWfdpU1s40LCWaGRvBAeV5a9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1340
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support PCI pass-thru devices in Confidential VMs, Hyper-V
has added hypercalls to read and write MMIO space. Add the
appropriate definitions to hyperv-tlfs.h and implement
functions to make the hypercalls. These functions are used
in a subsequent patch.

Co-developed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 arch/x86/include/asm/hyperv-tlfs.h  |  3 ++
 drivers/pci/controller/pci-hyperv.c | 64 +++++++++++++++++++++++++++++++++++++
 include/asm-generic/hyperv-tlfs.h   | 22 +++++++++++++
 3 files changed, 89 insertions(+)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 6d9368e..4d67c38 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -117,6 +117,9 @@
 /* Recommend using enlightened VMCS */
 #define HV_X64_ENLIGHTENED_VMCS_RECOMMENDED		BIT(14)
 
+/* Use hypercalls for MMIO config space access */
+#define HV_X64_USE_MMIO_HYPERCALLS			BIT(21)
+
 /*
  * CPU management features identification.
  * These are HYPERV_CPUID_CPU_MANAGEMENT_FEATURES.EAX bits.
diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 084f531..bbe6e36 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1041,6 +1041,70 @@ static int wslot_to_devfn(u32 wslot)
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
diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
index b17c6ee..fcab07b 100644
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
@@ -790,4 +792,24 @@ struct hv_memory_hint {
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

