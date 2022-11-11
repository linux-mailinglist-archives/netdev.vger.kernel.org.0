Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2DA96253C0
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 07:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbiKKG0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 01:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233037AbiKKGZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 01:25:48 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11022025.outbound.protection.outlook.com [52.101.53.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6BA72980;
        Thu, 10 Nov 2022 22:23:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sjh3I7olrqLnIg1yZuKP3kMp2lmHS2S+PxCPx8DUv3/uBDuizxkJqBtDE2kjjBVdg5hI/YDBa33CCWNPO3wtuocThY/1SJAOy+BWNHH38QGXtxfhPuRFfu26zjjECwgZL65klEgUsK/WHhEXkyBwTs/ODMF1RBMWJjoRLQU41kq4AzpOZ4sUTay1/+i4xEdwZkBagjIqEutdjxl6ipq67CBrb3/mzntjJXf8V66tWCzakyPHnMYjuOkYQ2kIKMoeHMUpvopMy043U1x8Reudjx+0VfpsqsZXsQ0L915m+ZwpdYklrMMfZTngGJxU32IxdKZyCfbyxyyRZuunm25KSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uDBf1JoaWPUpyxNyOQTOg3bA8mI88YgxN+97JsIj6Qw=;
 b=oOtdhNZxYROBUf1jaoeuYOKW4IQOEnQEIGJDFfPlsLXlvyI+Yz6f2D5IflwZXWlLAgKMXZLt1KonceM6TBssp5FR9V8n8SqsKo6f56ZpdEOZHd5mdheqQo9Vwe6aP8wp7rR5Wr/t2eLDNyn5CA1CYygaSH7tkv70DuT/ls7PAJ/qMLZ6ZP0vKczzapxfMlL2PfnqiC+Dvy5sP+cL5o+zgz553p2KH3hUKH0vRyWblox3um3DtmxCqbEd88iiQr7GJJxf94HDQPtVkoWK3BqnD0gt8/ftLntcvPrrBoilVpiQjTdt/BG8iDUW3+0N0phDtq1Ol+3nfltgKxHF9SiT2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uDBf1JoaWPUpyxNyOQTOg3bA8mI88YgxN+97JsIj6Qw=;
 b=V3Z9m4+/0q+0NU3BFkvQYq6svuO8j/ukKtStAxEGI5fj4G2mVEg/9ShIjYOUi8/z8p5eggt4OvW+B0viHpmTyC9KAOa7nL7t59aSfPvVRCPCglcL3rD0AONc2m2PmJUCqtWqKNrxg90l6cGVa8YFfbQlFSBEKxDy7oHRtjNxVKw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.2; Fri, 11 Nov
 2022 06:22:34 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%7]) with mapi id 15.20.5834.002; Fri, 11 Nov 2022
 06:22:34 +0000
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
Subject: [PATCH v2 11/12] PCI: hv: Add hypercalls to read/write MMIO space
Date:   Thu, 10 Nov 2022 22:21:40 -0800
Message-Id: <1668147701-4583-12-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 62979783-ee3a-4db5-1fdf-08dac3ad1ee4
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8AT/J8DjlHLroXeo6QKUQVt2G/trJqJsXOWunt78DrWF1ZgBnOviWksSVoTvpKDv6bcYKViy22opFqkdviz37+dQ84mysJLitb8R7HtZ54yzG48Ir2Q86pqwVLr3eis423uqqNisKpGDtoEudFFr4BAN6SQ5Sve8508Z6m3kqqd+s4jCiRMzihh89hNJwWYh8WlfsPDzSri6FBSgljgiU7sKelbywlY6nV+894seBEDX0Y8eIXMC8qqLl4RXPy4E7d4Q/CHTPl761Br29/oOx8f/CXhQ3nqN0Bw+mKjABNpZb67wCKRS/8H6s9P1ecsx1HHTxE8r88SBwRuNwCiax0YcGr25urAQPV9Vryh92CaNdFN6jAa0liSD/z68xBwx/vQKGwNSGyahdHJz9WFra9KZX7NkONi9fhhzI0g6I/UZUh4urJqgc0rIcNgo0U8J9OQkHWiD2gNMV27C3ntbbp39nNh5lX1MXc5L46et6Hr/hw/edABKbCKUQWsvA1YSvCCVNB+hZp/RQA4+ZxJn+wv73f8KW32YOzeT2TeZpRWlDfT+WMRYwbpXA/5efzlCTVCvBBHEnVHXFMxrgLwbj4IRYULLFwRygWVeE9gX8ePnkBYsAQJfndZSamWADGYpEAAVMLd4CzLQae0IGr1/DSUzh+0JzsscssbwJ54p3gQGoAEzVEW57bmisBtrsvmnFONwdi+wQB8vcYPUIJHTGUXNlizx7Tj1/hqblvQ8C2qGIwiDCfmO2wFMBYsSkjB2xLOLRIUO+3Zc3bj27vxsDCU5gVYBrKlO2jDM1XmrU1lfJ19JkW/TS2NQAnnE/pUDMplGGgT97ogsEijy7vrjFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(451199015)(83380400001)(52116002)(26005)(6666004)(6512007)(186003)(38100700002)(107886003)(2616005)(7406005)(2906002)(316002)(7416002)(6506007)(10290500003)(6486002)(66946007)(66476007)(5660300002)(8936002)(41300700001)(8676002)(4326008)(66556008)(478600001)(38350700002)(36756003)(86362001)(921005)(82960400001)(82950400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hPSEiGptKFFD62XptuTfVW87yX7flEzAI2X5WPIyVN1w2hHgE5ma9U+Lq+vm?=
 =?us-ascii?Q?M427LxnQYQMw802HD+dbo57YJMcn5iqjAh0Gwts/8djFPJw+UrDxpPq7AtDY?=
 =?us-ascii?Q?JJljMXBa8/c65StZfd/GYterG54QQ/lmmWjvzi8joAXUDSQaEDW0o3jatbcc?=
 =?us-ascii?Q?LvhLCzTvH9/qXbivUlbhjwUvaimRoVXHlGOdBGaxHPecctl1xP7EYJlKYt2z?=
 =?us-ascii?Q?6gz0AvsV7gszIb0dYFnIchiK+X4YATJQcTxrlqVE5tXR3mdJaXd8XqwwWOF7?=
 =?us-ascii?Q?zy4tvst1Oa+9DNsLFuctWJkinABBjP4MM1DywUCYsfClUuP36mEbdinfVp7e?=
 =?us-ascii?Q?kcBgp/QVLGi6wdpSmqeiL9fNJTwmGYS0hLxzhZdARdnDrI8AgfzjVB+tVDwF?=
 =?us-ascii?Q?tJnjA7cQAPlKg4PVgUw/IRfuZOUEvkq1RndfZBClbfVLxu3zH3g/3jY14K5/?=
 =?us-ascii?Q?9HsWe9wTYDKrdFWJLfHAwa1A4HgWUyi2rRZQYbuXfTWMhigs29gZaspcgkwi?=
 =?us-ascii?Q?3rZLVn6veK2oLeAZSou5C4lHNKcSOmni90fonfZGpaJiPtKqqHN93kXyUsJk?=
 =?us-ascii?Q?j6glKmiu0TIdmT7mzK8o1/EzlkQE3oC6x8HdfTlYFDK91Sk6wXqGhdvljrxy?=
 =?us-ascii?Q?A6jyuZFIMMfKb7vF5fsngYhqmcX+YhxvOCghD0bqCD/Zedmjl09RQ/S5gJ9y?=
 =?us-ascii?Q?BhnLWqTKkdfJYG89t076+yDoqM7IoWGvOca+KBM4rZRSTVq6PeB7Eh+dG556?=
 =?us-ascii?Q?QYrIPoOK4DkeOkGPiTxG9bEKjK2oh0Fv/JvcTT5njsWJ2Ay5UfvQjZ1vbFcK?=
 =?us-ascii?Q?k/fQmNr53sao7usRDRxZMf9tzKyjXDoVgzws58c8c9Jw0bIBiUlE53sxe2ss?=
 =?us-ascii?Q?blrvJoam/i/Jk58J3qI46jFKfIbFoxo4uNbpVGpaSAENwugbGiEP26l7FRVY?=
 =?us-ascii?Q?QyaubfZi4KG83w5A//zolSFTOlqmiXGSqUcmnkxhgi3W33kl7vFVc26ngXsH?=
 =?us-ascii?Q?dF8ZW5GsbaIB/SDrBlIgNEeC7+8WFijr28g/sCtFkvbw9xVIj/YHB09ZrOdq?=
 =?us-ascii?Q?7R6W0EywxPj7jH3utcD2aPLE4lR2ndIS3vTOUX6z0BgU1SmTlmgsfuQeQ6kv?=
 =?us-ascii?Q?nOWiEjkJTySKzF8/keURKKVR6whfEpYZ32BZl26WVoYyc6rog0fc9NNNvIkW?=
 =?us-ascii?Q?aZP6WHZkR5Tc6JosgLdVmCBgwOiYJnqyndZ+rWikxShi/gQqFDfmCP+D0/EF?=
 =?us-ascii?Q?qBonP9tIWoa4D/1UD1rzp+NIgx1GiX/+l/HCq7zjNOoSL4TYREF0pbt6Q1o4?=
 =?us-ascii?Q?vSmm8OAcDRYTlJNNo+bzhbttnsEtIzO7sPbVt749lE50sFpHsYbUBXK/i3SK?=
 =?us-ascii?Q?78xzrJ4Hjuk7CuY366Sjxjmtc9rhW7LmX+H6p1AsHJot03k/HeosQvWcig76?=
 =?us-ascii?Q?JMCSn2vhTR+g61bmT8nhBf8PCEwRCRd8Pmkf7tthfia+WldEn1dBGpcwFzap?=
 =?us-ascii?Q?4Mu8T+19ucjOrxKBUlB3ljAgMqh4Mcpw+DPJChQ5Pj75J57PoZZipjiSBkOo?=
 =?us-ascii?Q?/z4XeIMbLlnyK5ohHwXhyVv7Mzs+RbqKbD2E76lbx1xgD2UxbDWT+DbVsq5G?=
 =?us-ascii?Q?Lw=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62979783-ee3a-4db5-1fdf-08dac3ad1ee4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 06:22:34.3403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h6n9FMVUVy6erjv8+a3PHIP/JPwwuMjuOH3Bqteaay+QoG1OIqxhWKn5TRqwiiotQ5J9tAchMBwCxdrQ+8xovQ==
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

To support PCI pass-thru devices in Confidential VMs, Hyper-V
has added hypercalls to read and write MMIO space. Add the
appropriate definitions to hyperv-tlfs.h and implement
functions to make the hypercalls. These functions are used
in a subsequent patch.

Co-developed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 arch/x86/include/asm/hyperv-tlfs.h  |  3 ++
 drivers/pci/controller/pci-hyperv.c | 64 +++++++++++++++++++++++++++++++++++++
 include/asm-generic/hyperv-tlfs.h   | 22 +++++++++++++
 3 files changed, 89 insertions(+)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 3089ec3..f769b9d 100644
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
index ba64284..09b40a1 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1054,6 +1054,70 @@ static int wslot_to_devfn(u32 wslot)
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

