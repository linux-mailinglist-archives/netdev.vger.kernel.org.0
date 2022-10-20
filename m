Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03AC6067AE
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 20:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiJTSCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 14:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiJTSAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 14:00:42 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022018.outbound.protection.outlook.com [40.93.200.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73991520B4;
        Thu, 20 Oct 2022 10:59:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PFoD2/cY1NV/97pRgORmdN87QfS9z5QFTgWR+UuyBaDOdbn0y8ZzQFkJ5G+4YAuv5ar+0lPrcOzqcC74Y2evHqHXNCdCj+049VWs2a65avWuqzV29vDX0ymK/QeJsa4/waJmDxMXCPpQOwttPLfoYgJ6Iu7p4SWb7BOS+lpKbKidavg4nM+1m2u+DOK8jVpmcRU+JfONiYcyT0l6Srr1Cm8kA8+fc6Owk4PQv0uu+SnYADlCYePaiAhRY/fS4n9nv3G8CJ9nRBoxiSTuv+68jYI5mh4Y2uRha0mhq2LxPfw5Wus+Hup63q6R/iBuOnDU85n958JoYvpJ7nqp0xON8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Plt1PolMVyANi/M5zQYiscshOyKlEv6HGjqlto38Us0=;
 b=eRgrdXVVF5xFamuyFFANjUt6JQo2P3vy2f7ubcaHbCpfSF6TrOpccMEsul+yn8p7/ALbQYSnOuLjicl4ZIl2JJ6AbTnt/xb/+H0Rjy+zxbOaBzg1ivXD0Dn7xDBne1zuknk3J4SHcZJ7lQ85aBmqsuTJRrrCzioGYVDx69v7luO36nSjYA1zFEdxitMoOUY8cWyw2orv/L1Gev7Ai9F06J1mOhNziUIzMbLCcxG6+51DDZTRTxzjVuIOoWpXvY8WH6yKRIM5m6ZQsko371pZSW8RwxGbbiZCIMHmrXjPQ5ieaPxLosrPfSdJ1ZlZ4kx0XoDaYjOx2VMi+sditTHlMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Plt1PolMVyANi/M5zQYiscshOyKlEv6HGjqlto38Us0=;
 b=NJmEmyimqM2Zg/ZoEI/z3sW6kId4A+c1sZCLF+hsyZ/uRxLRkK7OJvxs/ItoO2DYkHfnN8YvXtACCQKz9soyGj9znLlkOIKtIbtq9jytPPFIbHuZwIDxlwSw/eHz3Ll+9w5V/irjImur3s5tbvJ1ehDz8E5ye/2vDpvts7l/5YI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.17; Thu, 20 Oct
 2022 17:58:46 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa%3]) with mapi id 15.20.5723.019; Thu, 20 Oct 2022
 17:58:46 +0000
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
Subject: [PATCH 11/12] PCI: hv: Add hypercalls to read/write MMIO space
Date:   Thu, 20 Oct 2022 10:57:14 -0700
Message-Id: <1666288635-72591-12-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 72ab9e0a-98ea-4f07-a6e0-08dab2c4bbea
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fn12x6xTZG2r53+InloGaWYOtEHWigCkYxugkUsFRw4RLkG3C2IRTArOrxk/GGHCdSI+bTVByrmUivl/q87n/LBweKg9qMMv2/D3xEfWzsIktoHA8ZLd0PBDTrMwLv6zVCEOcKPr4LFNnBDkdASsd6grOG4aOePThw685O3J9DeCV12KFGI/hsA270bk5OnSNsexaiODctnUgIlj7F/xvhu8aX1LQCW7qSPXCimZRvAVWSxDZCG9Tk08j2o+/jk10CqAMlfESYvwCNXzdMFXDVTeYs71+znFwXkqXJ9vr/81mnKnNRCSx+Xc2nVmtBnFIWOaneReAbjagv8TSjvXDCvhZV3IYpgg3sYpOIRD0dfEpkBrCsieA/4RxXIut8Sj43cIkrg+xt/Q9KskjD2TnUmF1WkCOXRq9bxreAIRz+OxtgM7RvNtR8yyKo1kaxalcQ6VldnDXdR12WUFmpDvRHHEZuzk82H3pbchRkHbj7RomafQMVTeTfpjS8iLw6gxR93WyQvgEvLBFyjpMuOqTv6tBkO3d8dW09dNWFu6hRWQXTab9ZeTT+PiUSM4iu8CI9FqXZyZFCnxexnn3ma4z/X37azD7LdiIyLSqxYsajp1rfQeyZrVYZzO3sBeLx0AI8z8PgBFXAoQbhV4FCtohPAFqsDS4Esw019r48Fzgn5pRPdCT8oqwgrwCRWJliFF8U6Vz3hjqWge+hDcqFDAjowRECXOyX5yCDajURZ2vWphA/MxoduogL58G9WC4A5cqkgvbmTe8hgGMDbM0phf0M7neFn/bwqC2I6bzYVi2zyi972JE/PimbT9j3FtEP1KEPoY33iLAmevCuNXKcFCoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199015)(186003)(6512007)(6666004)(107886003)(83380400001)(7416002)(52116002)(26005)(2906002)(5660300002)(6506007)(66556008)(41300700001)(8676002)(478600001)(8936002)(316002)(4326008)(66476007)(66946007)(6486002)(10290500003)(82950400001)(36756003)(86362001)(2616005)(7406005)(82960400001)(38100700002)(38350700002)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dMAztay7/FuwhzRbB/FPmUXaOFrzA0IIC2mp9D8Nljk2kQD7rVmbkvAmRS8Y?=
 =?us-ascii?Q?7AGZXKdRc75xJgrfwnxWjwr8wgkj4Uplma4OS/B+oAYdnOL3tdhXC8RtD1pf?=
 =?us-ascii?Q?uaKwgnoDqto942TWc5tFupF2lL0tJdVTUOmzZEsDMc1wUXrAy61mdM+HYGkK?=
 =?us-ascii?Q?0V5gMT/Xr82mPiyRzwf2tgFamL9rhrTawwjh+spQjzNWiEbvoGdfntwR5etu?=
 =?us-ascii?Q?5aNGH/xkzoBRC31S8Kvw2LFJqB4CcN+7tN8QqJl2+zsBwfsgq26eaB7JQR4u?=
 =?us-ascii?Q?MR5HHCEPrf3n20Et+bFNpVK6Hw5QvUG+xtD/cFHUTdH4gUIbLuODewy7d0t+?=
 =?us-ascii?Q?tYcHeHIUZaO0r08polK19cHaLFeitnCOMDbM/B+vytzzKno+X5v0am/eDbkY?=
 =?us-ascii?Q?0YvXYFj9hXTsDLCsiQw94gJSam4YRQ9YUyWhfyCkQrJaO3D6ZqhzNx4Gb3As?=
 =?us-ascii?Q?0b6/WxKKoijs2AclkLWPaypHt+U6YnZgwwWZkXRlQQnIMn2WG/ay5i+FCKQx?=
 =?us-ascii?Q?U+4qA+IHtqrhJpXxjlJSNwuO7m/3AxDfQakXQQpMqzsngacZBXwUr/jtkv6G?=
 =?us-ascii?Q?qKfySJtPBcv4TTrkn/Mgla4KaIANjajQCz9xwVJablid0++wnQQO/5waMYU/?=
 =?us-ascii?Q?EBMmODlhR1Qxt9l03Z32tN3f9tMBLH5g6qUoxBljQzkYpdji36C+t2UAyA2d?=
 =?us-ascii?Q?OUYH5RKC5WICvDdd5Mt7KKPvZPrASkQvtxDENkjbvCheXQraYBppU46Z8e7f?=
 =?us-ascii?Q?Wk6IrvtjLewe96s+r4lXKw8F7/0uT2iNmcgQcEXK8eVX1aWOtnp71AS3S1n9?=
 =?us-ascii?Q?/OnJTq48rJE98M25h7kOaLwfHzUDHqKI3BZ/3f4S3Gla9O6BHEpqiuEr3mCN?=
 =?us-ascii?Q?cAwrwFozJ7kAKVKpA8ZbmZBImsb/vHb7NN+v/iaNQYwbq29Ht5Bq++fMb2YC?=
 =?us-ascii?Q?wgijCCnlbpZyd8LmsJIdD+Mz9pN1MrbaDg3HmS7ZUBmW8q5zE7YwBAC6fZAd?=
 =?us-ascii?Q?1hfK1BxQrqv9euYU5RJ7hIxbUVkHCITMk7D4AHtFS40uL+dNuRgGF0CC0k/E?=
 =?us-ascii?Q?QaO2AmFDk05bmDA0wdMBfNxlQbEXM5SfRnMFcYfTcvpCqeSWG7ZXW6G7BCm9?=
 =?us-ascii?Q?A/as+0sreXmhT3oFiMrbRpOXPlUI5jMzQX6YP3tMmdxbAtzR3d4b0S4qw6tc?=
 =?us-ascii?Q?w/+Cc4saySFS798lo/nQrsDy7JH0ohCzbynTtfB5PSKj2WJqY1qCYXwp0jW7?=
 =?us-ascii?Q?JkpdFDFJ9O/3LgajyipsAW+nTOYY9dqlfOsLHIs1j//H8kMXEet5DZ4Satfa?=
 =?us-ascii?Q?xVjzGrmPevFcqmydo2i8qF4hfm+FvSL9NfL+ovcxRJouknfnwSSk5K0PimVK?=
 =?us-ascii?Q?4VZC2wdn9a0M+gm5FrYw1eZhSZkXIm3GFIN0vNYxQufgXHB3e+S9hOU6hmNM?=
 =?us-ascii?Q?zlzQoUMQC2AsMCYQLpSP4jnj59rnWzqzojB8z+koa3Sp+42nhE6iOX5MPEN0?=
 =?us-ascii?Q?BCiEtrAaeC16EAi4ceztQv4RSp/gwLWuM1Hx9MjAvc6Tlb4MkkAuCfK7mrAD?=
 =?us-ascii?Q?gGorm8IALsyzFXtAyRHiUd8GSdzuS0X7uIriS9ts?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72ab9e0a-98ea-4f07-a6e0-08dab2c4bbea
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 17:58:46.4429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: shoh/aELAxONZryg3US9rL+/VybLtOJdUvaks0O7gZ41KHCl4k6vVZXxrOdKoKX9yae/6KIOJFuCKGFk1pJxVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1857
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
 drivers/pci/controller/pci-hyperv.c | 62 +++++++++++++++++++++++++++++++++++++
 include/asm-generic/hyperv-tlfs.h   | 22 +++++++++++++
 3 files changed, 87 insertions(+)

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
index e7c6f66..02ebf3e 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1054,6 +1054,68 @@ static int wslot_to_devfn(u32 wslot)
 	return PCI_DEVFN(slot_no.bits.dev, slot_no.bits.func);
 }
 
+static void hv_pci_read_mmio(phys_addr_t gpa, int size, u32 *val)
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
+		pr_err("MMIO read hypercall failed with status %llx\n", ret);
+}
+
+static void hv_pci_write_mmio(phys_addr_t gpa, int size, u32 val)
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
+		pr_err("MMIO write hypercall failed with status %llx\n", ret);
+}
+
 /*
  * PCI Configuration Space for these root PCI buses is implemented as a pair
  * of pages in memory-mapped I/O space.  Writing to the first page chooses
diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
index fdce7a4..383b620 100644
--- a/include/asm-generic/hyperv-tlfs.h
+++ b/include/asm-generic/hyperv-tlfs.h
@@ -159,6 +159,8 @@ struct ms_hyperv_tsc_page {
 #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
 #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
 #define HVCALL_MODIFY_SPARSE_GPA_PAGE_HOST_VISIBILITY 0x00db
+#define HVCALL_MMIO_READ			0x0106
+#define HVCALL_MMIO_WRITE			0x0107
 
 /* Extended hypercalls */
 #define HV_EXT_CALL_QUERY_CAPABILITIES		0x8001
@@ -781,4 +783,24 @@ struct hv_memory_hint {
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

