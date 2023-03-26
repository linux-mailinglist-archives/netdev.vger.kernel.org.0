Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 770116C94CC
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 15:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbjCZNzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 09:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbjCZNzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 09:55:05 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021025.outbound.protection.outlook.com [52.101.62.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9693B93D6;
        Sun, 26 Mar 2023 06:54:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LkeczNyTj1/Tm7JU9B6GQITrpGFfKTHnFiGBBb7+OCxKNa0Zx7ab/eytJq5+poSkpIMX2rlb62RglYmFbhMiVArgfC5HdD64yr+Z3AEWzscE0y+WcOzqXADynSnKPWcVrSGhD0AKBXakHFwZ0rK0q91WTIqX0QRTNGnSTo3sfX8c8MagYrhm7gLtDce+XyM7xltPE4AKxcUphWxcTxv31OA+35KZ7NCY4NX/zGcb+IL+cYbCIHeC/fK97SQz38fYb8weUhdI0F5N92gpMEQTs8oRojA5T8sKGGeGqrVK88G0Fp/trO7u1CtOeIJOFhfxFBDIttp6BR5K9LDIzpvt8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ONuUHkX2s2accV/LU91CFqIQ9xmiy1GHEaZGBeyXQoA=;
 b=T8Y/Lw4+Hl+VYT48Xg5u3QR8PFsIese+85TD5WN++j+rNTr1iSlZ7eyubzYqkqP1g4Kn1rjxrytZ2vDl3LhqGxCUKomRgeQr3eeJGLev6SVy+62bivmq9khZKmCNE3pzfg+8FMFCwQYDGKYcmkHOKz7YFE8omstx1jjPjx+0ftnofVnQ9nKKqGwGB9JYhH5BBxZXkvjyc4Pz5Mj6XHPlWwgbbGNnQbVODXMYBmR8FcjdyFW+SfQRujHsPiNVbf3anLGj3nAWTaoZJt1AhNVeXEBeURJTDC327IK/O+Zdbtxq3fXu5iYN5QXyvoo3B2mr2Wun5PZyZVQzPOiyQVm+hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ONuUHkX2s2accV/LU91CFqIQ9xmiy1GHEaZGBeyXQoA=;
 b=ArYfc2a7HZ0UGZ/o2gckeO9HXcQCIZ9r3GAg64M45DIGzENCD3n0ZCyBaQ1JoqaEkOIIKsXXnzCwwxVWQP2/v9FlMfjkPHMFAc8wRHFxY3UCgLqapHU+LTSal4P3Tx5+hWyCZdwviguHHbsG2pLWRTnnAKyFmaSXqOmYrx9+VAQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB2001.namprd21.prod.outlook.com (2603:10b6:303:68::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.15; Sun, 26 Mar
 2023 13:53:30 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f%3]) with mapi id 15.20.6254.009; Sun, 26 Mar 2023
 13:53:30 +0000
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
Subject: [PATCH v7 11/12] Drivers: hv: Don't remap addresses that are above shared_gpa_boundary
Date:   Sun, 26 Mar 2023 06:52:06 -0700
Message-Id: <1679838727-87310-12-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: dcf3a441-03ba-42a3-a887-08db2e017b35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V3e0F1MdQJq0inkX+y5/R894PUIoyU2R8SLr0KrsjeUCEkhVhgjQ9DF9gJXirslCnixHrJfVCK1L/EHYHhxY6GuYf/lGAbkmhoPtcavpzvP+MUyEQnhthG9Gefk20cSIcsUcn/gO8GTPHiyCgOEdmC+buYi7OEOjWf/PdrPNASsY2MiAod7S2www8gPTyZHgd45nLZl4byzRme56eUMly78gfC3MsTrvNoPF9ICosm58a9JtzgLdwuHhQNBfm6jkOOcvp3MhekI3j7nI8rE+ykCGCoqdtWpycpfbPBD6AdgHc1Th7r5OmtvRC+G2Boy6GpS4uOoYB/m22/6EULrC+4Sq54KvXiCaxk5cCFQnjjitshT3h5QAQGVN+Ol9l3YkdMhhEP/kww8gKOVO7GWx+b9StM21g7LC8kXTW2UlfhAdTwNn2Qqf78Kppn5/UA4Rmd7//GZ5QY2msH2WHfKMDfU96SM17AOw/DtP+rxdhE4pPfLTBcyMDV80+nDSydMM8/GTTxh7dXxuxjXKv/yIG89s5C6OhVNS8v5Sbuy5nReXjvR7TJ61PPK2K7v+PQYG7KSjWOBiBGZYHfG1yLoZ6rnirWyToQePvp/sgO5eI04Wl7NidB0wAiWosu8Sm/E5f2fdQWgiujW5svybmOaxobFfOY61Z80tKUwdNhOu6v/3wFYx/vxTuHrn9w2/qqtQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199021)(38100700002)(38350700002)(82950400001)(82960400001)(36756003)(86362001)(921005)(2906002)(6666004)(107886003)(10290500003)(186003)(26005)(478600001)(6506007)(6512007)(5660300002)(7416002)(7406005)(8936002)(52116002)(6486002)(41300700001)(316002)(66556008)(66476007)(66946007)(4326008)(2616005)(8676002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qSXq/nYl85E7O1mimCDWYl8PQSKT1OoE90G5RiKbaagAyh0aP5wtMKGc6zca?=
 =?us-ascii?Q?AjB/PRZtpjMzwjFWxJV0I5cDRVmkMjkcdgh7pgUQ3ptPKmOLWRs5iS3JPBYV?=
 =?us-ascii?Q?vRM1S29L51IP0xmrsnzZu4tytPHZkLiji3ln3/Z1xBnZFqbZlYYkUKxOJ00q?=
 =?us-ascii?Q?tO/uaGPiwa4agzNdOCOq1boqFqMqdqdRuLfsy7fH1fw7hn8JKCzv5E+Hi9Hz?=
 =?us-ascii?Q?kyJutZUZh+O7bZmpDPHtd6+81GYi7jPu+wv1d1gn2+3MkBEPgK7BgDooi4Gd?=
 =?us-ascii?Q?5VM8CZyvoIPGOvDICIQrjsewv56TYkMllTvYA7693eVaxh0GZZghXIfkTdBj?=
 =?us-ascii?Q?ji1yOdAvxaVzkG5WpxGnXhMWgX4bP9jCtA+ZsWRgC6/LUx5tXnjFQdmOTLD1?=
 =?us-ascii?Q?jELtbaSGZiiu5k/BBfXGgeDBNTX466ArDfAgr0M4v5AVzfLdyZ/E25m2wcqF?=
 =?us-ascii?Q?af13wruw4GsOHRMZ+1asM7NbPGJ6yQ/9+aT7mZykq3aHE6UJATd4WYzt+hKk?=
 =?us-ascii?Q?r7STkBfBWw8RKCUswuIDRNVCTXKzcwX44CS+rw42Jm8sAWsnzFuR3ndwrSg0?=
 =?us-ascii?Q?Tsevi7ccSNXet6dbDzHLSWA5RcZJ4e2DnVFBVWb5dn4YbNrNNgcHvIrox3gu?=
 =?us-ascii?Q?MjEwmU8aQ0K+6qbcIa5CG01TFFSRUhJSl8BjJq/5uAIdwJoYMHLIykdaVeXh?=
 =?us-ascii?Q?s+aBEHHhzF2a3xSDezqtfMzjQfbK2sABKJAqeJrb9o4vK6j8kIIHF2HocEeM?=
 =?us-ascii?Q?c3TvDGbO/dW4NQ70RLYugHI6VyvFdg1gcuRqxluU/pcGiRpNFDzgkMsMqR42?=
 =?us-ascii?Q?bkf65voD+cHWAyyU2xSSrze9MEEX409vJDYfn5fFovY872fd9sIPZCwpgNCo?=
 =?us-ascii?Q?oxAJ9YgU+s6qhL6LrbV5UoMCc9AtpxSj9bw/omyy4ou6ZSihahKtM3NXalHC?=
 =?us-ascii?Q?CgxzXmM7WwoHMTHvxnDqIMcTZQ0SkQWQ7FWlDFhBn3dnaSJ7jmGKe/eTze8p?=
 =?us-ascii?Q?f8FVV06pmYTAlBqppV05zch/eQd00P7y9NpVZt0DGQZ9O99qLrpNf/AscA+u?=
 =?us-ascii?Q?i2hBSFa5gpsIqkHX54yC7G7AFpLnaUHawlveX91NQMMtIhemYH8ainvqFH60?=
 =?us-ascii?Q?SPNhx3M0UsHul31XYRIpVs0Ctyyzjzjagcr9hMLdbHoPu+0W+fB98Yfsuk6A?=
 =?us-ascii?Q?nASa1/HSy2WWzqitNdkiCFn+sPThOI+rVGhKI7EwOg+5t8Q07SQ7WBCM8BmY?=
 =?us-ascii?Q?1P9O8HX8nP1zP8oaw0yXcM8YVhQr8eqgs8Pp+Z4RZmvx70z7/3XzYVjcOwTh?=
 =?us-ascii?Q?osXB5QbvtFtwVq+f7RVNTFFgK2nz9Cy+vUWI1k1thLyeFKTBwtYTUxXeNsOb?=
 =?us-ascii?Q?R61+1wlOVuDr+zyQfgrMy5NM6agPQ35eiJ0svZR6XPPOce+sm4ZQTPZ+1AnY?=
 =?us-ascii?Q?0/U0s9ynJhYAerrvhAgg0F73bjpBOdsRxCGPtDdYauy7cznf/1bDs7mgjnTf?=
 =?us-ascii?Q?NQ5YwgkQ/vYghOyQMqjF0BYEdMTt6kvZGQTLmAz7MoD8b3DfKycAka1Gg98L?=
 =?us-ascii?Q?I5xORuA6CGCsZ3bvKBSsVgSx2XLzVRqoYZ1nchVTbeNhXquUGUNwOXIMWTfm?=
 =?us-ascii?Q?oQ=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcf3a441-03ba-42a3-a887-08db2e017b35
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 13:53:30.1689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QiVyTTzfiMJpGhZNivf+WtX1xrGaqeJWSBo8jBWYnKXt9MiQ0WRyBp6HKazzv6OBKJC9F2EwPUxuZXCD5RVKuA==
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

With the vTOM bit now treated as a protection flag and not part of
the physical address, avoid remapping physical addresses with vTOM set
since technically such addresses aren't valid.  Use ioremap_cache()
instead of memremap() to ensure that the mapping provides decrypted
access, which will correctly set the vTOM bit as a protection flag.

While this change is not required for correctness with the current
implementation of memremap(), for general code hygiene it's better to
not depend on the mapping functions doing something reasonable with
a physical address that is out-of-range.

While here, fix typos in two error messages.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/hyperv/hv_init.c |  7 +++++--
 drivers/hv/hv.c           | 23 +++++++++++++----------
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index edbc67e..a5f9474 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -63,7 +63,10 @@ static int hyperv_init_ghcb(void)
 	 * memory boundary and map it here.
 	 */
 	rdmsrl(MSR_AMD64_SEV_ES_GHCB, ghcb_gpa);
-	ghcb_va = memremap(ghcb_gpa, HV_HYP_PAGE_SIZE, MEMREMAP_WB);
+
+	/* Mask out vTOM bit. ioremap_cache() maps decrypted */
+	ghcb_gpa &= ~ms_hyperv.shared_gpa_boundary;
+	ghcb_va = (void *)ioremap_cache(ghcb_gpa, HV_HYP_PAGE_SIZE);
 	if (!ghcb_va)
 		return -ENOMEM;
 
@@ -217,7 +220,7 @@ static int hv_cpu_die(unsigned int cpu)
 	if (hv_ghcb_pg) {
 		ghcb_va = (void **)this_cpu_ptr(hv_ghcb_pg);
 		if (*ghcb_va)
-			memunmap(*ghcb_va);
+			iounmap(*ghcb_va);
 		*ghcb_va = NULL;
 	}
 
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index 8b0dd8e..00823489 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -217,11 +217,13 @@ void hv_synic_enable_regs(unsigned int cpu)
 	simp.simp_enabled = 1;
 
 	if (hv_isolation_type_snp() || hv_root_partition) {
+		/* Mask out vTOM bit. ioremap_cache() maps decrypted */
+		u64 base = (simp.base_simp_gpa << HV_HYP_PAGE_SHIFT) &
+				~ms_hyperv.shared_gpa_boundary;
 		hv_cpu->synic_message_page
-			= memremap(simp.base_simp_gpa << HV_HYP_PAGE_SHIFT,
-				   HV_HYP_PAGE_SIZE, MEMREMAP_WB);
+			= (void *)ioremap_cache(base, HV_HYP_PAGE_SIZE);
 		if (!hv_cpu->synic_message_page)
-			pr_err("Fail to map syinc message page.\n");
+			pr_err("Fail to map synic message page.\n");
 	} else {
 		simp.base_simp_gpa = virt_to_phys(hv_cpu->synic_message_page)
 			>> HV_HYP_PAGE_SHIFT;
@@ -234,12 +236,13 @@ void hv_synic_enable_regs(unsigned int cpu)
 	siefp.siefp_enabled = 1;
 
 	if (hv_isolation_type_snp() || hv_root_partition) {
-		hv_cpu->synic_event_page =
-			memremap(siefp.base_siefp_gpa << HV_HYP_PAGE_SHIFT,
-				 HV_HYP_PAGE_SIZE, MEMREMAP_WB);
-
+		/* Mask out vTOM bit. ioremap_cache() maps decrypted */
+		u64 base = (siefp.base_siefp_gpa << HV_HYP_PAGE_SHIFT) &
+				~ms_hyperv.shared_gpa_boundary;
+		hv_cpu->synic_event_page
+			= (void *)ioremap_cache(base, HV_HYP_PAGE_SIZE);
 		if (!hv_cpu->synic_event_page)
-			pr_err("Fail to map syinc event page.\n");
+			pr_err("Fail to map synic event page.\n");
 	} else {
 		siefp.base_siefp_gpa = virt_to_phys(hv_cpu->synic_event_page)
 			>> HV_HYP_PAGE_SHIFT;
@@ -316,7 +319,7 @@ void hv_synic_disable_regs(unsigned int cpu)
 	 */
 	simp.simp_enabled = 0;
 	if (hv_isolation_type_snp() || hv_root_partition) {
-		memunmap(hv_cpu->synic_message_page);
+		iounmap(hv_cpu->synic_message_page);
 		hv_cpu->synic_message_page = NULL;
 	} else {
 		simp.base_simp_gpa = 0;
@@ -328,7 +331,7 @@ void hv_synic_disable_regs(unsigned int cpu)
 	siefp.siefp_enabled = 0;
 
 	if (hv_isolation_type_snp() || hv_root_partition) {
-		memunmap(hv_cpu->synic_event_page);
+		iounmap(hv_cpu->synic_event_page);
 		hv_cpu->synic_event_page = NULL;
 	} else {
 		siefp.base_siefp_gpa = 0;
-- 
1.8.3.1

