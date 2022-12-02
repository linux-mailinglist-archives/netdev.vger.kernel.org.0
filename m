Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB6263FEFF
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 04:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbiLBDeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 22:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbiLBDdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 22:33:17 -0500
Received: from DM4PR02CU001-vft-obe.outbound.protection.outlook.com (mail-centralusazon11022027.outbound.protection.outlook.com [52.101.63.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0893865BC;
        Thu,  1 Dec 2022 19:32:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MYuPdWxNUs8KwschDwyIEfMtePPadA/bMmAPpjI6YKZ+/a7SgdbsbYG8HQxQ14msiwv6N5v3Cpi7WqE5mJuIbzGDnv/7HZ9hR40PWGFi/eLSFv9BCLfCsGcIKUMtfpeH44GKuwXdBTP1OB6VCXX4SPTQYTtuCMPj/w+00gnIFkxjWRcCsPox7BL2DF6S+9TNFAHTohm/JNm3qPCimQmC8x4flEdEN+07eMZIxvV/vWqWKM8wCQxqAI512P0W7R8Fp8r7k+GEqO2CrPNsX0Cvy8ijViwv5Ej+GJTe8Q2mBtAlaUNazNY6VolRPQBS32pflPK/qAxR473zM1xV1XgWOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AcnvgpzsxhSuI65c5UvEjo1C3IpsG+3rnruV2R/KQIM=;
 b=aAqwJonhH7rUfv4CVBCj1edGta4iWgnzIrO90hHO5DcukYaE/J9EtcUiUFbVvA0EPFZeQ69aeVU6FQwK6MInPT4mBBA2mkm0loodbxM9MjXy+zmM2nLMam/fGYdkIhMKInzVHwsWpW4ZYZmTXnRKmK4O+GcJAn+DthrL1K2ljaQKgfHNUVUs7hUjLzMXgIaROnNPBsifL9XbYGW7iBcQcASSr5iWf3Go8hPctQxEYn7EaIm5IRVJEH8iwZdR68/NVnDdFU+7QZJp46sm9ZSqL1JwltUsHSoXuJLY/rgdo0LyVo+DXxmAa8dI9JQLiZhDno3FA5AdYG4APZLk53qi4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AcnvgpzsxhSuI65c5UvEjo1C3IpsG+3rnruV2R/KQIM=;
 b=IZJdLq7VMWZZneUdXSkXp6A5dKmXrdimggL160Zncq89yOJd5zQ48WdEHZruqWAi8++bGi2ET0gGMJ8bWN7VdhQl93hrzgPK5sIcsPCbwCgy4Y3WOzr5RAQyd81z+6GwUXDwUX38UONkb0YCPh3jwYd8PiEbei+//mU4DUidBWk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.4; Fri, 2 Dec
 2022 03:32:27 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5901.008; Fri, 2 Dec 2022
 03:32:27 +0000
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
Subject: [Patch v4 11/13] Drivers: hv: Don't remap addresses that are above shared_gpa_boundary
Date:   Thu,  1 Dec 2022 19:30:29 -0800
Message-Id: <1669951831-4180-12-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9e8f2460-dd23-4a2e-f4a4-08dad415d563
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WpO1MtFr2GFW9XPdEFUZ73I0vWq2PWa27ZnwxP40g3xEj56bV9WpvBgfkk0rXlAtzrv1/4wfq+mwZ6qiZJK08BkTXjHnp1cSxekMCfk3iSsL8hs7ZNWDsvGExKFPDBJddgWC7uoO3y959CuEAXm8npAxILN/LrzpVJgOneuz/zWE7GXJgUEr+Pjei/E/veitsvXPktqXfuEO1c8MKh93Ly42ldaLJC92pMxPh0JxadkO+QXUZKSeviej9GGU7bAZE+vEj3zsvz91cNr3ketRUIFWmJSIQBMCTWqG4rtgGau35AlbgOssTYYxhppXXyleYd1mOJuJ6SOcmKMCOfuQZnJ8iiS4bNNQF1O30HS7qi3x+ikirefhv+o+acKhtr3p3McAcY2PdJvbYcGZQXW7c1bO3q5SSkP1roiCRe9iyJjmnDM3JimRd8wv4EJRo3ZrCIFLrSBkf+w21TKcmylrwpGcF0ZnbIm8f/9UUIj0ywpovKOHQNxRzbYxK50m9kBOezwuLLQ0YMlcuVSIgm63dOgPFGEJlHSKFX20scJ+gNoOm0DsgFd3NlctBiAkk4tESiyK6WucxpwKDZJLicTCszc8FdjCk1UIJZoNYDF7JC7iBbXxNLmStMkA+L42wLLIUOUiJ33CXgon7GAh6XKz1uhtuuo5VlLYvuU6S/gg9Pj32QRFmCZ2i4OUFULao+XILyDPDZtH0zrdsktUf3U/V0xnifpCnAFO135/M5WlHsiYJrhF2ApoKJALJinONrXI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199015)(186003)(8936002)(8676002)(10290500003)(2616005)(107886003)(86362001)(2906002)(36756003)(7416002)(41300700001)(82950400001)(7406005)(82960400001)(66476007)(66556008)(83380400001)(66946007)(316002)(4326008)(921005)(5660300002)(52116002)(478600001)(6486002)(6506007)(38350700002)(6512007)(38100700002)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?egjLJMd1g7mee5I+0sqB+nAezJkeAzNULiYxv36vncLAbv8gt7HaJ3+V8/J7?=
 =?us-ascii?Q?eA+UOHvdIq1h8dVQ1xcDIFSJYSvFsb9OBPRY8nTdZ48zYFaEmBegYetaND5F?=
 =?us-ascii?Q?i6Y4yHdCitWeQU4AhgKZ4rzzVbqPI+Hh1nFncfXcJRuquXPvUiT4cJgd6Rkh?=
 =?us-ascii?Q?C8WzZo6hssIRX6rruLSsX7B8o7l9Y0ZwuR9Gk3dzdMfr5WIF9ACkwb7f8XkN?=
 =?us-ascii?Q?ucy1pEsnn+hoOqP9O8954XvXElqFnyuMusmT9gmKDgaVjre3fvOxf/8lfXLX?=
 =?us-ascii?Q?4xEmxzCPnFwlEL/9u22uCreIqUA3EoAQZXTI/4LhBArnP0RoWJ4/cBTDTE9j?=
 =?us-ascii?Q?CqcjMX+oa8vaJZcf0sG9xYja0HGRMJBBfBMIf1v4Vt0fK/UUwyCb1xXWFCt9?=
 =?us-ascii?Q?G2/m8e/RY0UoZwVevoG+DR2xfSDhlUnHFsr87ydWaTZosRz/FKNxMjdEbp6y?=
 =?us-ascii?Q?1T729QB1Tsv1g7r9wif+XV41mqN5Lx/tySgdAcuEkrSr3LCvNtXJJ+d1u9uT?=
 =?us-ascii?Q?Nsb0vuh6nfJvh/X2t0DVZ5v2g63KtNE+Je1VuEbGCkcFIVUTa94Jdarhid4q?=
 =?us-ascii?Q?FfDyqP0dDLskLnmrLu8HZQxugXLQakwU8pMKbKK7T0p9smPnfCTIxvYuhvnY?=
 =?us-ascii?Q?Iuxf6GOxGVFDqfuUFd8B/c0MpwmkMdkqTkG9IO8Qz1RZct/7eiLebmmWNjLm?=
 =?us-ascii?Q?AL5WHmC8lnNXs58F5ik2LTBQLN0jDwns/yzFDHoYgXOAuchKTKr5LalRcDmY?=
 =?us-ascii?Q?TQl/bpKFbm1d00aji7BaHMvfYjxfXQsmARCzFA/z8Oa38tRA7y3I0BmZUkXz?=
 =?us-ascii?Q?2MPvLxRns4F/3F5gLi9U80MuVykhR9ZA0KFv5s11EHBadReSMwmVBg5QF/hS?=
 =?us-ascii?Q?J0aBnePekH0MonW3S8u4l4gAuIpmwEL8iy6yfe+ZiGwWUJcQxlu9tY9dy6yg?=
 =?us-ascii?Q?RkYQ2DmrhK2W7xQepi3xUOKulGZNr5b2kYeMH6lom4ynQLvAhUJLBQjfYhOX?=
 =?us-ascii?Q?56cxmH7AjimL34drJ08GNbnYT51N7CYV/Gq+F2lcNDF6rX3JLnhv64ix87kq?=
 =?us-ascii?Q?fOzZWp84OK3pPGx2CbOb3l+jc00GFJzSUqA/BTrXxY7axWm99tM88ckO03L3?=
 =?us-ascii?Q?SOwhFu5B6VIRaNXYV4Lcx1GdmVew+ja1gi76HWMNyg7ARiGMcK2HJ0ApMiPc?=
 =?us-ascii?Q?Q2IY4jFZlww8kISemi4jxBkF+BoSJ65R/l50x0QJlX3xYbDvwd+skWR0bkit?=
 =?us-ascii?Q?2Rl0ci1lSsdeDsymMfb+/wk/zCzjXaxAE0b8CM36uKbpG38LZMS+yJo1hLd6?=
 =?us-ascii?Q?3jX1N22bdR78e9WEgyKhXeDmJ4Aa7CtuBr0XUM5FnVlO4lEnsoh8j79iMHty?=
 =?us-ascii?Q?9eLG7uEEQrc64HPFOarhu6hE/pmFEwF2hSnHhLWErBRUOAbBHcBLWcvMMtfG?=
 =?us-ascii?Q?FRkieSdTTUpgTf+BlvtbdVgVzs/FjY8AhkOy3rT2IJWHrLm5WAGYuJmjBpfV?=
 =?us-ascii?Q?LhaeBKMoydGr0KlQ1bPTdcEawfvxyT145aXZTO0A2wBKO0ixPp8N1KQVWkiq?=
 =?us-ascii?Q?APShXWAlrPzINkCo4YY0BCT99GfgzuJmy+euPcMRSW84lR4UK7OK5na7glJ9?=
 =?us-ascii?Q?WA=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e8f2460-dd23-4a2e-f4a4-08dad415d563
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 03:32:26.8658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yFH4xa6ZoERTKuHzhP0VC2pOLXfHN63fLgbI+4bKQG+T5hMKAhD1AoNLLJxQjlMLt8JXld39RnsZ3t+/apod8A==
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
index 6dbfb26..9070a78 100644
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
index 4d6480d..410e6c4 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -217,11 +217,13 @@ void hv_synic_enable_regs(unsigned int cpu)
 	simp.simp_enabled = 1;
 
 	if (hv_isolation_type_snp()) {
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
 
 	if (hv_isolation_type_snp()) {
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
 	if (hv_isolation_type_snp())
-		memunmap(hv_cpu->synic_message_page);
+		iounmap(hv_cpu->synic_message_page);
 	else
 		simp.base_simp_gpa = 0;
 
@@ -326,7 +329,7 @@ void hv_synic_disable_regs(unsigned int cpu)
 	siefp.siefp_enabled = 0;
 
 	if (hv_isolation_type_snp())
-		memunmap(hv_cpu->synic_event_page);
+		iounmap(hv_cpu->synic_event_page);
 	else
 		siefp.base_siefp_gpa = 0;
 
-- 
1.8.3.1

