Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 883D36B198A
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 03:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjCICqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 21:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjCICpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 21:45:49 -0500
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azlp170110002.outbound.protection.outlook.com [IPv6:2a01:111:f403:c110::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF84A8E8E;
        Wed,  8 Mar 2023 18:44:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1+OtZVFb/z4KgttDICduVs012V9HtdY5R/xeYAbuhe7/611yJYL5HqctQGtW9vIy+CDDpX/r3//mpEQlV04yz08zL2Pc1tqgNYRxrmM37gotRT1B2jEAHE6lnyxeuJYTwBOPNP4q7KSH9YewZUosUtYMWX6Xjzfxue2391A/FMfMKJRKMt7dKuNeKyzey85NHGyfsFeseoRE5r5eQHcgiyE2PGcAFR+23RO6Kxz/Mkwc4NRLtxB0QWAgjlFjrCxab45XBVLGG0IZ5RRDE+TmUyThNAnrP3k09rxNwRJdgK2aqbPTU6JuSAfZHXPIR5xztWero1PpEk/eSe8zC+qvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rm7maILJ76g+7w+GeRIYyRmp8NpbMCEc1zVNqGmRMIU=;
 b=mlF45jDWaRT+QR35W6haBmJCAuYrQGE3Fn6HmmtyQHgAGjleMNB5PRUf7iF/kVSn3Gaf5C4K/Bx5Rf8LAfAv3q3SNO8C2LuHYT/tqVER9c/PuEXGmIW679hvYwuMQVkbMcnXkRtnQy2UJitz0xpzh9Z+P/7shNF6k4TAUZ143xhG4Kkmb++uFz20MHN0djgpdW/Rs16Z+X2+FrJ9okX56PQh+hmFFAGhtc9pUgTGD1ZFci9jvQl4wye7MuMRe4SWVRTcgRahJHQV2NfWeM+tOy632CE17+XEYNwdkSurR36J3F6+5Ko8OxpHjc6sjyiwXImbIYdhKSuZfc1oiykk2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rm7maILJ76g+7w+GeRIYyRmp8NpbMCEc1zVNqGmRMIU=;
 b=frdkB1P9HTtDR8+5nWFc9mJUmK6jW1AiFVZrfvxUVtMXWdRXJHx5fZvXGdDuW6D1HsRpjjS05Aj12q20JHGT+khS3BBdNkRvYmGt85RshZ6JS/u/Z0kL9uXtwehbYOLrdFKCKqodAQMtu5dTudsHBnVp/18jDrXibWGbkXci0uE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1313.namprd21.prod.outlook.com (2603:10b6:208:92::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 02:42:00 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17%5]) with mapi id 15.20.6178.016; Thu, 9 Mar 2023
 02:42:00 +0000
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
Subject: [PATCH v6 12/13] PCI: hv: Add hypercalls to read/write MMIO space
Date:   Wed,  8 Mar 2023 18:40:13 -0800
Message-Id: <1678329614-3482-13-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: ebd2d6eb-7e3b-4d54-65f7-08db2047db8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7jJyZqJzHPZ/WDTUEA0j6UFT5+H0A8C9gaU1Lp0xgtm9dTPiblbNa78OnRNLZYSgsmzXvCLaraefYf9evyE9opUenZTqvGPG3ObSdZOBCX9+soGTH3ODlACTbX21ZdOYtdMz4z34jv0ozaHC0nKTTOfO5zHhasUU4IeT819AHZImUP9m/Xyypob0OGMc4FdwoZ4ML8pLUcQP0aWCt6Ta+ixVYMdczh1NXIziouiE4TAMZLUD6KjxGg0vxXHnV2XdX/7bzvnjuovh8Wr1EVEOOb5E76YqeH+dMu/FOdJsRsxhRY+5826L7W0eo57kVyLwDsJ16EuYfPcjLMF1gJ5Di6SMtQzlDVOVZ76SAenfhFV7olhumswKKRSxGu8ThlJTHZk4KlroSZL7cNgjtO9Tt8xG9cre7WeT+pHRBR3iRdyswW50aXm5E+WvUtPeE5sB19kQtrTCeOf+N8uf/7Y5p52yLmn1h8hZYuyOhcTmZMo/GCjscjV+dhFUDggeqIPqrheswuH9xTfeJbvKX8HNRhPJQO3Cv5PYQodezYyGXMPKKPMYXE1ImXSeBqV6qy/nzKYobkzkUr7oQfuaCTQ7TFM44HFBLgFZvhwG9B7A3pC6e7UcuYa+rmpL6xthK5cDGweKKRZ8beTcmaxEpNYGqtuHLHgLCn1jxinWuahLIe9KmvY/yLc2BTY84LJ5uYy2cKr5D66meuF6j5G1iE03QvYnj68xxSdvvdjSQ9Y8kFlrda3wgQimk+72qFJyd0SnURKzBueXXtsUCIfWAbFBeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(451199018)(82960400001)(82950400001)(83380400001)(36756003)(10290500003)(478600001)(921005)(316002)(38350700002)(38100700002)(2616005)(6486002)(6666004)(6506007)(6512007)(107886003)(26005)(186003)(7406005)(5660300002)(7416002)(41300700001)(52116002)(66476007)(66556008)(66946007)(2906002)(8936002)(8676002)(86362001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5CgOMxHHfB8Hqvdl1LZMKzHo/D+2EPpiyVbhBLtaCWchjqXkc6ZAY9t0YrY6?=
 =?us-ascii?Q?IjBVW37vs6EOSRrGH+pMJqoHy/0ztfIlB9D/uYSCsAVjUCnKrGmVd3A1raAU?=
 =?us-ascii?Q?2VOthZz16j8bTKFg7+BUn/4QR1D2x539wv4zR+47PagKmRiljgDzEJt7BN15?=
 =?us-ascii?Q?DEeeRfU26w4y++Q+BYcof6pVKPAeB68GcJ8GWCDXZSJyXzlZCZKxDvRZ98Ld?=
 =?us-ascii?Q?aroyRqGH3lqYcnVYccGatqNqAU5vqknvL4g0VX/8Jvgr1KZM5JMAgKiqBM+Z?=
 =?us-ascii?Q?UWy3/27Atim5fTsoeRFf06YK7GXIzr/bozJc3xuSqQQJZvzQP6qFGsuv72FW?=
 =?us-ascii?Q?AfHfnN7jF88Z1TRYNgSIu4Pri9JBay7s+05D+dbyhMJGrebPDnxmghcsLqvb?=
 =?us-ascii?Q?PHh/bGIghpQOv7FL1Ob6/A2PYhMd33m4syVbZlqI6RH08MBOuJI0Xnp25196?=
 =?us-ascii?Q?Xk4anQenr1aVHpZtNwjnEg6DZFKGSKHhEDHui0hVhCMB1wjNGiqmuzCzoLkJ?=
 =?us-ascii?Q?jubYAz8l8Qpm43JeRdVSwvcJhC2ldh8qarTI2klZtP5ESZx9Il8GsuLO/AmA?=
 =?us-ascii?Q?ENjmmq8qR26+mCgha2PBqdfadtXcaI95UYFXIP1c5gNLksF0H5IiSrp7/R0r?=
 =?us-ascii?Q?OJkn3pSSd8pELY5NmGGFa+UOVdiD0r6C/mweb62orP+H4WdF6De/MoGOdt5V?=
 =?us-ascii?Q?4/s30YoA+N38Z70PqF8EaqWxd/KGnMeetGXrzQJZGNfayEGiFqB0vH1XyRCx?=
 =?us-ascii?Q?lZC0Q0ssyX0qs1EABK28GoOJT0ND6x+0GgvuLLnExRzVa1LS2xMMwByQuSEM?=
 =?us-ascii?Q?t6VZmUnpwYhaoXfXwbchkqcPTY/WYvCRKqn2S7FWuZHAw177waMZa9SYiPip?=
 =?us-ascii?Q?00/vSy4TvbqQ631elmrpLj8wixDexM89/DH27X3yAAnJzGmzgvT1MTScXKqN?=
 =?us-ascii?Q?+Cgd3OduSqep3DtoeUDGSxNKnAaNFOxad6/4xxLp08UWF/adm59XPRVIF8zJ?=
 =?us-ascii?Q?cqpMjvMr0XWnhUTWvEfPMMqhHGrU/IIIkAIJNkZTF1MBRrtLQaXiODnFXQ6y?=
 =?us-ascii?Q?FGWrrKgYDaoPo9kCg+jg47OQAvzhEGPqvYRqo1zJB5JKl8UePzgajEzBFeer?=
 =?us-ascii?Q?jCC4VLaUNGFHfHfsr7aShwDqYeV59UVLrVcujIJN77B0yVvrAuuh85lu5u0D?=
 =?us-ascii?Q?Cl7aX/imppDnYzcV8GsGCvPZFRklkae7vvgvulCuOB7P3fCkmqqkyHLWpbG+?=
 =?us-ascii?Q?6OQ5QvVgmnKDREPxzkWF527SNAZR7O+zT/bOai9/1waurC92DgpxeY/9N2Hy?=
 =?us-ascii?Q?dpUYZH5MTapGzBPcqgq9tYkaX4YMYL9T2LiWnLume5+q+R3O0+MAU3o0J0uX?=
 =?us-ascii?Q?hw33bpeEzOVdLqamQ7kFfiteuqQdjHfKDP2shz0hPG20j+v2SOGThwO+CHyK?=
 =?us-ascii?Q?k+Zf4TLO3jX+O7EDXSKb44rM8nVDre5iMaXlhgWLkNqSY0CEbB2zQIUfSjSH?=
 =?us-ascii?Q?ySWwUl8x05UiuLbDWZTkzI423QQ20yO03Y03qo1RLo5EfgYGxlY0k9uGmXGM?=
 =?us-ascii?Q?FwkuDy1HDdlRcf48QS7QZIr8MIQ5WmpL1j02G9sF3LrfLtiD9uP8RUMMoodf?=
 =?us-ascii?Q?Ig=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebd2d6eb-7e3b-4d54-65f7-08db2047db8b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 02:42:00.3044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JGSsMjRvTR/yCnpez2HqysysTFuyI3bzz5/NrF2TRvtZivHEvrMsC7KDtAero3USnMtl71RXT96fu61tVBwDVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1313
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index f33370b..d78a419 100644
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

