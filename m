Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD19562C80F
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239340AbiKPSpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239347AbiKPSob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:44:31 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022016.outbound.protection.outlook.com [40.93.200.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9370B657C5;
        Wed, 16 Nov 2022 10:43:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PpuFv7ng6Teu26kXqC6xCE73ohKRXkAZ4JU3sbAfkbk7UTrfMx5wjIkj7Zt50s6lpXjgojQyK6PGp805wX8lfUK0eIIF5nHU/iM88xXRl6qkec/o6AZvG9lWeIzxSS9L3R52IIAdEpuxxLSUC7rucCVxE0Sn2XORXLU+fzbChZ9MGdkjTQT+Jjkr5MPNhnZYMjVDwKHjG2PoQX1Z3JLgNqkhGmnslks+c60Zt2+avRRTkw8W+SNIiO3/p2QKEFIsmFBybENtZ00qAmujD/vmC+WDYdJoHx9ACvdC1e07lY2JQnzKm1WPHIIQsnl6x228RB99vO1kkJvbuUVd9tFuSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uDBf1JoaWPUpyxNyOQTOg3bA8mI88YgxN+97JsIj6Qw=;
 b=SQ6VXQgZWP2gjdPNjnOh68Euh4Gmk5ny+Bl7/uHrCf0O+rXlFKtznLOIeXKyvn9NurrmuNkeLnXNRJe2F9iYE/OhqRnTEZM/n4NGsfohYXg9tvKtNmUeTdg8efZq8S5FRXCLgpBJ6yKRbByv0ie/wLIGjSxfkFMRrRXkKW0qrheXsSN/9x4BI6yDEjDpqTwNcTeO/2WdA3deGZEMtmLQfF/U60IyCjCo+FpwuXhjkXo2q2LSMOGJmQ5UOyyJer9HGhGtkyeIb8IAqbKjZ1e1X6MIUJ9ofUXn0xjOgI1Ynai3E8Ks3Jtyj1T0wkyUcmZfiUeQr1ideSAncXjqBpp2UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uDBf1JoaWPUpyxNyOQTOg3bA8mI88YgxN+97JsIj6Qw=;
 b=Ua47THS3wvYalbW4DOnMeJQyayfOsDVkxHaFnqnvUBh89sQh1a/MGg3eO1TPkar10HwE/wRErK/XcJeyPusGtktz2N44Fb/YQKlGkRlWIhYfLVVWu03E1NXEnXJcbJMTZuT9gmgy/BhLnryTY2uThlSW+zVgRDRz03mcXcPtiaY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by DM4PR21MB3130.namprd21.prod.outlook.com (2603:10b6:8:63::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.5; Wed, 16 Nov
 2022 18:42:51 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5857.005; Wed, 16 Nov 2022
 18:42:51 +0000
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
Subject: [Patch v3 13/14] PCI: hv: Add hypercalls to read/write MMIO space
Date:   Wed, 16 Nov 2022 10:41:36 -0800
Message-Id: <1668624097-14884-14-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 95ee6c52-5480-4257-77c5-08dac8025d7d
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h3HhoMxBDIe3wdCu85oBIdcM6JSqWRxnfNj2m7W6Xo6zWQCiU5GJCf9ogJ37tWZdXV+BGVWuRQs1LZ/q6rFxsnxXAvXFCB9cSxKK9vzOnKGFWJroqZriNEkaA6svQBRzPMl1JGAo2E3zCz0gXMLd2yA8Bjf3Due1OemDYkkDcyvad2V8iFofC1Hf5ltg38T5mjCmLEWJ/fybWOYKCZlynEWmT2Pq4gIdZyZbyTd5JqBXzZhwKIkWDRXNIk6TA3kfBF2TowE7epf/JIJNjFY3fQIzVkb4W5gtJVtZUfxWabTUh7y13J1L5dwW1YOW0/Ib6heRhUCosvhWV3eqchUbxwVwN26MBv8Az5IEq9tpfSLyCORbWLn9CYsnOSOSiMx33eRoiPjpIcPfW+KI57SgmogqeBA5rT9xy4fOiVPjqndgHdmmQroupGKsoduHfDiir3o/nr90tvA3PkwEJT1djBWrrdu6FbSlZHlLzvbTkZ26z9Gjki7u/mW/nmlcXc2qEeIjd2+ZB0cRoPzh/lBUeFrERYNTk5sanIJ9Ty0QIByGj4SuN5S6C1l4QW4xbFDTAtQChjkUVdCPxBWGru0AO7nuyAWF+kYxaqlSfmHcl/EPE0IQbLXF5s89tts+2IzS2ZdxUp1obdiz26x5o3MExlfYCKmBuWFU8jBMBo+Ts1cJNgambKtlYPAischaJ+N9U+IKtOSRlEw86ECCCxJNt0VsMJXvYF86WxuioOLAbX9LFAe5y1OSqPOouiKVUrungUDLENw9j4rYVNFkrYb7mBseprFSGi2p0Rm0UI3b4WSQdUDZWtApcW9tYP/XlqNacoWe3459/45D6Q1pciC9rQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199015)(4326008)(5660300002)(8676002)(8936002)(7406005)(7416002)(2906002)(66556008)(66946007)(66476007)(41300700001)(107886003)(82950400001)(52116002)(2616005)(6666004)(82960400001)(6512007)(26005)(36756003)(10290500003)(186003)(83380400001)(316002)(6486002)(478600001)(38100700002)(38350700002)(6506007)(86362001)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/KXQHGKP/qhgRTUu8SAuok9/b5FML7suLovXaUy6V5pT3vGKxNfvJhTr803t?=
 =?us-ascii?Q?fIaqpVPVZDPwBTfy+ZiTBRK+Yyv8BWOcXaaoOqJ0AKi1AFK0vIQJBqi04EWL?=
 =?us-ascii?Q?ZA7IqQ9/XeRYreveb0ClhPVstEpZQ8HN15mNk/qQc+OuuysbOggXGU79U5kk?=
 =?us-ascii?Q?g8GSvCywWa7I3rKVb9tPBEJq+NChkzv15wDr/w+Qx96fafGVMM6tO9KgNQTC?=
 =?us-ascii?Q?NkK1zGlUfIwz9/CWcSeVKEHwmMgTU0XlzcClZ9Yc8iScohGhVQqn9WmqfnBR?=
 =?us-ascii?Q?drGiJoNTiyU2sD1EzBfjE+Tgi2ulzOit3M1HoYJCeNO6ukLH1XKcH3Dopm6m?=
 =?us-ascii?Q?Emg07Isb7urhYJrKSsUiGiJKuZeq3UFI1FSgZ+Gsd/IRSc/Ri3uCOttBd2+x?=
 =?us-ascii?Q?vT6Snbj2iO3R3C6vLfWPIhDJaxn7LA1i/Yf0TLJKVrzjCpdr47IqIHGU0rXw?=
 =?us-ascii?Q?9EIgWpu5NKFusngx1nenHalrVySKSAfJqNLnWyL63vZZ+8lV9pUhtxNXyUeL?=
 =?us-ascii?Q?j6uf4hD52SjA1Ix16L0gwFXcBpteFFdXOurUybypWOfBt1Wfmp0bp6rceHUW?=
 =?us-ascii?Q?7bxgIBWjPB81jQotHFZevaeTMM+pwOi/k31aRJ+vSS2oqb8wmccVcpyqwSSC?=
 =?us-ascii?Q?Dl4yLXzEHgdm8wMuRDF5sel2w4sD7IbxcP3Jzzez9mnDy0nC3HlbNi/JWwdI?=
 =?us-ascii?Q?EA4giY1j+gAENV/6FVybPzLeBzTPyBbV58e/GSNrmjVHNRjCFIRkGaflETz2?=
 =?us-ascii?Q?+RT9bYu4gT7pccLFgVHwLzLfSZHK/drj8bqUaoYQfPbaBEI8GyCV8lSzuQnP?=
 =?us-ascii?Q?4P74LSuuodxlLk9LAf1ASwYllD8iL7AfwLztqTc+eTnKvNjnnnG6/fvMPEgl?=
 =?us-ascii?Q?Hf4Q+/2NC39hrVihiXLCtNtAg6lLJ7ClAuMV9Kf/pIdmLN9rn/NEFEVBOFQ0?=
 =?us-ascii?Q?gGYA4IgejWAvffxTals6fOnlgO6vKQt9rC+uLZH9HCoS0n9AGPK8/McIGwCH?=
 =?us-ascii?Q?OuEuEVFgt4e3MCcbN5xvlSiRpvjSWwrvA95r6AkjJtBda5/djViCUy9YQwxJ?=
 =?us-ascii?Q?4nNV2APZNSc/cPHP8YVcGQ43Z2GGG1Kn96ZIFZBo2hpdQfC8IRUOM3QqPE3D?=
 =?us-ascii?Q?x7+462Yf9ZlISfLgUQ2w3/ouxGSMokQg3nJGgzDYQ9IC22s7hzyoM6H7mQpM?=
 =?us-ascii?Q?cRhHFuQhOlpgE3eiHucHQdXf2vz42ZfA8SYZWje1qsy7lB2NoFSJtzvXUWqZ?=
 =?us-ascii?Q?zoS4wCOs56Fv2PnPF2dy45YFexWXG/K5bp8Nt6J/JEvdKf87VCcCI0HiMiD+?=
 =?us-ascii?Q?fMxjHIdfZbeisOZfH1yFKO6ED3ghl3z0pshHEPwiCFFFcuIsDzNlnrP6AQU+?=
 =?us-ascii?Q?+voRK1QKzoremvAuWQvHmjHmow+RQY4A0t8D88cfhA6Z4vgVSFDT4+vC1YN3?=
 =?us-ascii?Q?PPRRV4gQkHXikaQrfUaBjUKsfuCox82EFWTL997quuiMwUaaR9g1GBa6oNOc?=
 =?us-ascii?Q?Vn5Cfj/PDwEKadRfITqVQA+p1rreeAB3Pa+uKfz+KeoPOIUMNfR/QaM3b6n3?=
 =?us-ascii?Q?sp/0zNEfARZEuVfTIHJl4HW88xI6rlRYgVUB32Zk?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95ee6c52-5480-4257-77c5-08dac8025d7d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 18:42:51.2371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VyT7Qx0H3uiNuVTMrtM9Z7SbUmYDdkh0DD03Zj9oZ0CKYWnUzpeGlrIiidttDow2DZvDYu6iHFcAz9hCOSBcMQ==
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

