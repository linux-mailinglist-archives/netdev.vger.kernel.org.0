Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF60668622
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 22:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240756AbjALVuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 16:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241041AbjALVsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 16:48:46 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021023.outbound.protection.outlook.com [52.101.62.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1EC102D;
        Thu, 12 Jan 2023 13:43:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=amw8+DpPXEvy6z6I0/XOnb9x7n12+ln8eR32NTa9qGxOOvgp+L6W/5mpYFkiBSQUELUpQRc0LzMab1Uxu67LLAZoosQ8SdtPIbKTasX8QFLh3cQjFNxUrq025RAY9KbCe5YM3t61Pvpybh+m7uQHrVgxoIsZxyiWUniMHT4iaWLyZ8UE0Doo5X7OR7oSE/bdUx74GcECMuQUEWWrI8QRsfJVQg6mFqGo7pGtTpStOc8ZdnqJXlhXtuK0iuarVE4/ZdJAnJOkvcZXbA24lMsxI4fYj3EJ2YmBe1a77toctsQXJhlE+lpC6p5k9ldzL5kMA+GTbetllWkCB5lP2JCaLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jD9pfgsXC/ndFVpJuhAnkZy+5QE47BR86CO0Zblfv3U=;
 b=PlcFQRnpG8mCDZyEQImRyyvT+j8ZRwR/atyxHLJ+cwv7K8Y7fOqTupt1G+2MxdlgVv/RP6yhwbkcdwLG8aa96fS08zSq86fgZxduP/IxgB7g/1NnRSmz91BMMKc/lvCkdZf3JdfLKWODYopfFr9RlsihiEuGjAUQ56h2FBLU2MybM12PNMsngOFjmP8A2Rl9Okv7nH3H+sIKfo79ZgfWdm1F/wNE2NZbUNGSW/2ZUOJ0aLr+c619aVN44N9olniTN6fxxOJM/UPPxKIyhJMi/ZMbGXJYNq0iC2KgSkf5Gyyp7YZ918buufSCqqavLd9FYVwZk9pSnvslu/ly7pCVgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jD9pfgsXC/ndFVpJuhAnkZy+5QE47BR86CO0Zblfv3U=;
 b=i6PNi8i+EayUf/Djf9/HssQhdavIq3EJnD8Q+yuXLUVtIlrrLuYyS3A0pOtvD0aC9fDVlmNZ39o/SNRGL5PjwYpyQdc3Z1Q/iNcedpVP6JJWmuIugmu50qYFcqjmBYatfrO6ITJGrJPxgRsqwyxIraJz6uZuP2lXtc7J1vJJTH0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1953.namprd21.prod.outlook.com (2603:10b6:303:74::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.4; Thu, 12 Jan
 2023 21:43:24 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7%8]) with mapi id 15.20.6023.006; Thu, 12 Jan 2023
 21:43:24 +0000
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
Subject: [PATCH v5 13/14] PCI: hv: Add hypercalls to read/write MMIO space
Date:   Thu, 12 Jan 2023 13:42:32 -0800
Message-Id: <1673559753-94403-14-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: f5d15fab-a550-469a-56f3-08daf4e60811
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ms0DEdWZk3IJlpHAG5zftJBaPLGyn2r1Pd0OLD2e92cmksIKrtrM5iauBV3gphJfY915miSw3g9rgnvQWFJpOsl5cBnapws9XFMFqRRKt33SLxiVNDapWQDZ7Uz42+S2wZTIYcNpRY2DST8bojlflDt0KoWZcexy/6fvckTIKltr6oTSuJ+ZvQtJWtg4njR7YaWntWi/+0/wsvIIRFKR6xd47wOiedNeU0qHHaVF0NmhX+FN8r7h8bx7n1AdVY7WDzZUzvqOqwmuGm3i5nP7ZpquRTIx3grNaDzRoociKMMZmBfFenhg+nwK5Btr0Tn38Chf79Obg6CXFSvCA2qXtJYcVMqS0RR/joMksifaCsH8Vk0AbqReBpmE64mBGj3n3GXb4wbSyOM2dMrEHg0t1bknROBl1bSi4NOTZzIqFOGBP4VqPG0a8NNdUXNx+nUmTydiqcku/JdDZ8zM4jkRzh79TUEiOXVnngTMu8E9F/jBRy6/L5khpqMbngAnxfwBDIul0VtlaqAxgQ4zdXXU/xu3aiAmGPOpA6o93Zm7k3TKQkHZ4EX+FWZ8E0dAu7/QX07oY7WwjmxtEoSIUCLMOUpTJg3p6eBiaW1AbRM9He+NpI18wGqbMdGrxLLfmS50wjeKuEfUJbpQLQP1CtX64NZY3yBT7whQvHMoYYIXsz/y+PEGBBsFg4f2xei8XN9rw1Brp9TK+kSIwCpwe11OtLRvZhnFtOg0Rdc6WdgAhcBQN152igG0pjSuQbxuzitPmbcSxF9D3isVjF9L9BzXfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199015)(186003)(26005)(6512007)(82960400001)(82950400001)(6486002)(86362001)(52116002)(478600001)(2906002)(5660300002)(4326008)(8676002)(38350700002)(66556008)(66476007)(316002)(7406005)(38100700002)(10290500003)(41300700001)(921005)(36756003)(66946007)(7416002)(2616005)(8936002)(6506007)(6666004)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k8n2d9qv1zc7wV4B9EFb2PPFNsg3gX9mkQQ7IQpzcxgNxfo11fIdG22c7hp+?=
 =?us-ascii?Q?BkTczidtdN0ghwD9Uxe3p9tfT8p5/IA7B+4A5QRi+r1R6Il2rTaDLLRL3dzD?=
 =?us-ascii?Q?MHwNh63fEt4NpVIm7XR6yQOvZJDvCZDJsoOq7lg466cy+xLeJkt/VR7KYsV6?=
 =?us-ascii?Q?RrmhIX2e2Z0TKt0h2k30xpAsgj9KMBRhqCxEY7Cr22DkdOMCNEbIq332NwKx?=
 =?us-ascii?Q?k3F3U3Tl/UPEp14aDkOfcwwzfC6Cn6ynJtP9c9lZa2v8Ce5lDvxp3S02Zk7S?=
 =?us-ascii?Q?MsQzIu7XqqjhGdNd4Cb6MI+CasdyGoxGl7BSAqfaWOujdh47GYgfWH0fONWT?=
 =?us-ascii?Q?E91aeJq8HhUmUbJZqdU3kyEmUYJjjP0IRerycanKbTTRHsP/8/W1ZzjHCnIJ?=
 =?us-ascii?Q?Yaq8yLOJY/jwrSqaMOVveRjRdINm2skVO3uiEDW7o2nRDh3TG/NLcEK2Hqk4?=
 =?us-ascii?Q?zybxCvtZMZvLfs4JPBBpA724DwCWVoVVxhBZuGNEjw5RMR3dC+/vW1zg0kxu?=
 =?us-ascii?Q?e5XvgrHd+0YWQ4VNw7R0yPy33pe3PO7nZGpxzgMbpjNHwwCBRAddFEhdB8xa?=
 =?us-ascii?Q?38PkbuKkKHsq4vxPiEgXx73DkHREK9CyOuoSVVtyPd8VrI3sc1LuN4EDoeEt?=
 =?us-ascii?Q?SR3EEsv4DS5bGQdWrbW0SktrguGgIsPnKUCtBK/oWSBAFuGVNyvArA9OgnCz?=
 =?us-ascii?Q?u8gtLw6CHP13amCpn3k/Ocj8Wx70YRVjLVnKHmlsJg0wlFkVGAY9f1wUu2ia?=
 =?us-ascii?Q?+cPV5xsSwVL4uQU5yUXHTNMI9rSXiVxEN9nXZA39tzbTXWw2o4NQ0GXR/7Dn?=
 =?us-ascii?Q?8KWqia+aF5F2ep2zwgYohqEK+h93B3L1ZUdQngVwv+m3xUKAIFMrBEjkVtb8?=
 =?us-ascii?Q?qjlnZY9ivu8wCa+OrGDmvVHFg3T64Fsk6HuXacWbhxmkt/uScd5/TlI/VIrg?=
 =?us-ascii?Q?gUHhTfT+W4e0uTdzZX7SpNKw5rqKgCuenyhSG0dLIqrjFv2jniVI88CW1GOe?=
 =?us-ascii?Q?+a0Vjzx7jZPx5dYnCaYnTrmIsjWPv+/c8Zb1iusDFOPx0550kezkMJKKF2b6?=
 =?us-ascii?Q?VTvwKaztia6oc1955QfDUkxxgfT5Kh7vNvSX6lJ9oDqS4kGXXruZ1cZCfW9a?=
 =?us-ascii?Q?DxVjdY1WalwjVo4f5AdnslG57rcK2ds7b1GfrwhNYTL1hpoFNEh3z3BeDG2V?=
 =?us-ascii?Q?v5XxC8z8uf1rQTWWBWVfF8FY0zntSys1g9iqh/klrB38zLR/sgAtbUQUUFgt?=
 =?us-ascii?Q?eYwAQmbCtGTDkOCcsCyNiW3SJcvLuOOVum/IaMdG15Cx1HOhbQlwRbMGrbzY?=
 =?us-ascii?Q?+KTrLDOTFVC8Vf7n2ldGwlONpqm7Xf1eudmEPVUuWvjO5HTtC4G7zCkhTXPS?=
 =?us-ascii?Q?r3/YS0k4A9k8TZ3MMYvilhNz29UTsflRw6fESuBxugbtMEiko8Za/W0fBJDB?=
 =?us-ascii?Q?xJyQhQ0ZImQG/uQTtYzsP6tJWVpNBsF9bYVX4JLgO1Z27HmQBeJsUKatbgjR?=
 =?us-ascii?Q?0XsM9lrHm9E8e1OYNKcjrqmOzTP52p4vzUp983Ixko1UpKup6++djkJrDOD7?=
 =?us-ascii?Q?xgXpjSfuZ5qLQLZ/GI105/BwvcIALOXsxp2syjHF?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5d15fab-a550-469a-56f3-08daf4e60811
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 21:43:24.2762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t0X4CXtOj74GlmNd2UCH97j+hSaZc1zYWY47YIrLXaL0V7/S8mECFf81SFg0fvwwHcAWEyG8nUS39R4bW9P0PA==
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

To support PCI pass-thru devices in Confidential VMs, Hyper-V
has added hypercalls to read and write MMIO space. Add the
appropriate definitions to hyperv-tlfs.h and implement
functions to make the hypercalls.

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
index 08e822b..db2202d9 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -119,6 +119,9 @@
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
index e29ccab..c1cc3ec 100644
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
@@ -795,4 +797,24 @@ struct hv_memory_hint {
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

