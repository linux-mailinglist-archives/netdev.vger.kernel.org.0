Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE826B1984
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 03:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjCICpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 21:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjCICoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 21:44:32 -0500
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021020.outbound.protection.outlook.com [52.101.57.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB8321A3E;
        Wed,  8 Mar 2023 18:43:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d7IWfdNl9geToEXeLpbT5rRwWpfKGchas9d6KaA0EE/pcN/JQOqItoiw9fXWJPS0B7Un1zSPXo2cuU1CwUM7ditgQyohXN8RbuYdG7cd+tO2vaoxtk56BtvYwk48oYBfQWylfJGi6hJXwnlvrfemJFS/QqD27dTuTHuLIIm3nClFIMy0LIGbXolAj7Tp/vsJP1/eCgSplN7mZ3QAVHqxik98WyP8SYjjBx0g3lKX6Y91WucOmeyYlOqgMAdQJhbJcrotO91RU0XXp6vzev4lSwDjh2BEgU6bt91fDvdK/dOqrOH4Vd8cIh+q4J65/rVqprqVcd2DQ8P/CmNhZ8hSsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ONuUHkX2s2accV/LU91CFqIQ9xmiy1GHEaZGBeyXQoA=;
 b=GdY9ILZ6x1q80RkgIWVorRUxVioWJ67aXId64v8QPVLgaH0iMr/zYusgacWaP0Hp6nojbPLPO7PgcFM36cRAzWgub4BHZLUNbXJDTwfnKjR74favFkBQLZvMuvSkkwsv/jqKFUv7rOrme7Yhsr2uvDhH/Ekg99mYMtIrMaJCk6Xc9Q79CV6xIYIRM/d3eOY3KFNVypQwbrQ7f9NUXt2nd3EUG3H0/H90VDyYz2Mh77i4dggdVeHbT5CiCYx5BUMRBaamGIKNOncVG5TpnbRhPjFJmYMUsp8xj0MvytiLyep6yn16BjS/vQUVz7Z0YWxtsjALXElorN4J4tSHX1p8Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ONuUHkX2s2accV/LU91CFqIQ9xmiy1GHEaZGBeyXQoA=;
 b=AhYLes6BxDEy3roA4D7HSywijePtBuYBAKwJ16+zv+ifFZ8P2MBkj54FTWBB9aZ5Os1DZNaxXsHgp/5jy1FOQU6tHUw/qTJphha0KXhGuFqmBFmyjJTUeSTNfh4LXDqKK01VI7GAf2U/tEjzSAMJa+W/jUVy8CkPbxj4p3taUIc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1313.namprd21.prod.outlook.com (2603:10b6:208:92::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 02:41:58 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17%5]) with mapi id 15.20.6178.016; Thu, 9 Mar 2023
 02:41:58 +0000
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
Subject: [PATCH v6 11/13] Drivers: hv: Don't remap addresses that are above shared_gpa_boundary
Date:   Wed,  8 Mar 2023 18:40:12 -0800
Message-Id: <1678329614-3482-12-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: aa93137c-5e6c-4864-a194-08db2047da36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KRIjfXnUtM7idpX1/Yw03bKUPX3PCIeHwuvsf61pk40J/hJpntqkGpRCws5aCRtkc8x3K4m8knyNokRux0sJdFrvS3kj7RJ7CHGRL2/vzC0aFUnhDumrCp/w5jm5C3WSNy35lWEFM7rABJkek78CX0Q7/Y2UEx6bZqNYHVdLWpO9SOLYxFTVU2lvvW8Y9KwuV08c/xpYykXs157lD0pYLwlVtraRcc/BlpGcuxUakaVBwPeGW2Xhaonl5z0EV9G2+HnIM5NBRK79blAR0i9XjL0bQaj1/n2KTaL5uMO+J+TEJNjZRlSS03SyYH6kT2nRqpLR1slty/yrxgYPr2mfPDfrsQVeFEmuieaSYu7eWyPMk8e/GP+AgelWj00tfkwgweYJnkvE3SbOxX91il6oTrCSBqI7Oh1HoZwennAewM+ufkvf58u7bQI8F9QoxZu2sOEm+1aiHWOe2xeHieBWKGGPNirortGEf9FMhxJcb5cwhlasRX8WUWFENIJnK8ruEIoOAygav79tnVYD1qjZh8AGvtY3Z85utfR+Sgtg3sN7sJo7HbAeDS4kLa1uUVpFm2G79tfBqIPwuCLAgXeljwxpX0i6pyp3oYNmudLUSSc/5yOyNZ5Tn0WbJSylqUWMimqdFFnpeVUsUL1NbF6DRVWQePlENE9zHgumki9Dl2f4pmixYtZ54i+9ljP6tXhKjyEn5vZJ0DZELqrg/Z0Z6KXSWmIgH6agMpkQeJrAtnXbuVynxuUP+Lb5ebTtR6lhVcKpC+zsnnQnNzn/Lb9dzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(451199018)(82960400001)(82950400001)(83380400001)(36756003)(10290500003)(478600001)(921005)(316002)(38350700002)(38100700002)(2616005)(6486002)(6666004)(6506007)(6512007)(107886003)(26005)(186003)(7406005)(5660300002)(7416002)(41300700001)(52116002)(66476007)(66556008)(66946007)(2906002)(8936002)(8676002)(86362001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZEFCGp3ksZ+STOgtbVN5arwtLkJ3wo0pqh2cRCI/OYyX1rBOQ8Ho3Gfb5BxC?=
 =?us-ascii?Q?5ln9gPMpItW7F5VNgLOt88MI8zVqAcqvbfct3mCjgi2lxxj//j4ULWbbpdo+?=
 =?us-ascii?Q?Z4EkyP24fZb3GvqmB9MBVq1NodchjuMCQCBKa1n9Clnqo4FcMQSoKrhVwBfg?=
 =?us-ascii?Q?PSitFs7BaxCbng98nDBceeMGY9jP22W5tUGUWcka7INOgwyGZFD8vtwLDet/?=
 =?us-ascii?Q?EDp5hj86k8qT3IIpgxS0V6QqxXcaEeGoGRdBADqsu6Y2ugiQWkiiJzm/UEYa?=
 =?us-ascii?Q?VafQn7Iy7vsEbkPUqXTS4nWV2VwEhjXIdJ6qG83zgaUHWUJbMkS4EzcAN5MX?=
 =?us-ascii?Q?EDYjFlfDti9c7GCtEtsYMakRxLlXt6l3TwEw3jJHx/0tKHmp9P2gBXnTTyvr?=
 =?us-ascii?Q?NaZSkBnnUeCkfmV0A9hcIi+Sc+WOr9uiqU5iDkbGGKpzdgUdVnkrOy0Eyrcs?=
 =?us-ascii?Q?A3tpt+wD8nvEoLbz4hbu4lQGnM2C475fb7SDzESmzBQVjVA4XmCYBCvaoXg0?=
 =?us-ascii?Q?gLHQqYq8zzEz/SdD12lGbusRIqFhOjIXe3ES/4+z5ig6tT7q2Iawyee7Gomc?=
 =?us-ascii?Q?sKV6qFVbmtNQn1XERNfBJPIY4Q57UJkMxnf9HPSFaMVuZWmhxMIcRIlgQPY3?=
 =?us-ascii?Q?o/cVfvNifQyHhfTUh+6zKF2Z5sF6o1aPUcNDNU9pv0IdmPHr0WVYWQjXIRn+?=
 =?us-ascii?Q?ew70QkQXQly9JysoU2B1V+h+cy0r+QZLrvD0hup1QvnTD8NFe69R8oLWWgZg?=
 =?us-ascii?Q?oDb203tgiOg8vd7fbTAu5J3nfVcNrt3PDo9vhgbL7MQtg+ZCuAZQrffvf5oD?=
 =?us-ascii?Q?4M1LUTWuIiiJy/ysSsyLba5ZharVSBcUBkjSYlROTJIjXWqpgDtAPzi7j+86?=
 =?us-ascii?Q?6XHQiPr65cXxCa70KdIooRfYHmcY6Sq9QGZYffDWj/bcQvw3qUgFBNnemHgi?=
 =?us-ascii?Q?tvPgCiSlCLgnmhTr2PbiJ8+wAKs74I/KqeCYdEuECibR3SNY8+QIsmpf2VpH?=
 =?us-ascii?Q?QkPKlb/O0YUJeu7/ubZaaM7m+JcWIPIXzCBw9FlweE49iAB/nJ80fpWkqYgr?=
 =?us-ascii?Q?H3cjzaNI3Qn0uHSk8IbR5kl9pEAHrPDUwI2uXiF6hNNUs63/Qz42yUkDPH1Q?=
 =?us-ascii?Q?Nvo2ptZOWBdT2TFlpBZwXKDt38GEW9GSaNPwakjoxsRjIPLGHPBRC42ArTdf?=
 =?us-ascii?Q?YgyB9fhm7z5mTy7duqzkAMf0a54YF+odZQRRGp8dOVYZ581cmSlf/2j1kTi6?=
 =?us-ascii?Q?O4rCSkVe2JSux6K8C+8x7CahzeBT03xsCP7N5+86XvLzwjj/rYP6TbodtoS1?=
 =?us-ascii?Q?VMKnY6xN5wZ6mmSYUPpZ7Zsa5vrE58MwWWFYaz+Ee+A/E3qK4vO+pOqKp76x?=
 =?us-ascii?Q?Ops3rqaC1FQ7nMhw+5ivQdxZEmImMVf9FbWAgCH5a3tZVXeDVfjLjLSqG+n7?=
 =?us-ascii?Q?d7Y8Vy312oDUCusgohH/PFxFU62mrlrRlGXX5iucJ1pU+Gc7K8snWHzd0oTH?=
 =?us-ascii?Q?zeGV6FbD2jnbo1xJ5izL+LXvOHl1eTkD1hz2NhN87ikMr7aXnCqwERgBX1Kg?=
 =?us-ascii?Q?sdstFXK6Osmsb3pe6yPksyEfgrt9dOx8v4SUbrW+ZQ6qAe+AOSP84WVgRtBB?=
 =?us-ascii?Q?7Q=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa93137c-5e6c-4864-a194-08db2047da36
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 02:41:58.1024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rynMVIIoDveqXtLY/RBu7FTY0b0jtgmGFsfX4yLlmLrVEFR51p57i5xsbEQxDXa1l/siX0hVfWY52CdnxdE4cQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1313
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

