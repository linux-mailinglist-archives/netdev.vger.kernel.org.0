Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A1C6253BB
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 07:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbiKKGZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 01:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233084AbiKKGZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 01:25:00 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11022025.outbound.protection.outlook.com [52.101.53.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E1C742ED;
        Thu, 10 Nov 2022 22:22:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JO2W/czR37M5ICw6NwvMsTK2N0V0pxL2XWScbdGP6ucPDPI9TWQb5WDKYkt/Mu4lT1AD06s/zJNek0L4d0L1qaddac/ddeOJ3RnG2AoZ+64mnEYVLo+SFxC2qwEmyAOfGq+LcJLxG0wx4ogdAZXcC7xLI3qDmaKfXeB61fsVQ8/VromjEebZZ5vAk8Z1Znyx6ArLgky/qEG7Ma/YvW1n3p3X7nX3Vv/8lOGOoYseXNuDzCyKsXI/6upKnzufpQCWvxjJlry5BuU9Fh8aRubYryix0ktN97aX4WgpfqnCeEfgbjK+9zykYf2uhfi9Siy59op9VoPScbBZycVUYDsV0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=85+v0DH+3mlkLMx0kKGVKEBUtraxUVOFMF0rnKO4Ujs=;
 b=Nmf6qtGeNu8gPS6NOFxsFR2/KGjGTcKHjpWn9mUbqh9B8o0IFmkpIT1bmMGWCm7A4onmsMcTxCBqO9pVFakbLQUTzoy3hWHxiGM7KX6O3Uc/AT4JBGSi7KtpOFolBbZyYBHp9dqcYCSlpw6Of+0UsHxQGYi9TUL+5naEHynkw8dDgOVcWQomcf0hmA1OOZJimcDTAph01fuSYpt7ZOrtWUQGHOf+igTilfIsegnMricHktwm9d/vMt5rtedqzmNGqij4Myh2JWrxLEFKN7ZwbvqP7etYKQYiGXSyIT61X+3X8QE4Tu4FIKqXbC09c5dziGx0nu/uHmD/oYFN0064vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=85+v0DH+3mlkLMx0kKGVKEBUtraxUVOFMF0rnKO4Ujs=;
 b=dD+2/RWGREcqP4efxr72IltZ5Kuj1g5Y9HK7adQhrzfkUaY8OB0D9MJPTFIIWFO5PomXvm+BkSBSDbHWkaoJcUAtRGOSkC8lNorgko3DiRIztwIvI40mPLKMLj9+GW8bjW26dOy3TTK3CncQ3yVJKh4dWbo95qrcDiQrgixyMzo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.2; Fri, 11 Nov
 2022 06:22:31 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%7]) with mapi id 15.20.5834.002; Fri, 11 Nov 2022
 06:22:31 +0000
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
Subject: [PATCH v2 10/12] Drivers: hv: Don't remap addresses that are above shared_gpa_boundary
Date:   Thu, 10 Nov 2022 22:21:39 -0800
Message-Id: <1668147701-4583-11-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: aca4de34-11a5-4b9e-47b7-08dac3ad1d47
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QuuGLwZOqIiFsDou76mZxxZgiO4uWWlMu7Jw+xHuC9GzyIYWBtpWWNy79DbW9Na0hxyt5NFnrava5033PSJllS9wba2tVd4EhUFqydjVN2CjkaavUH6Y9McZjox7wM2xzvM+OpI9hm3zVyQ4VaM3MMr5UdkKHu2Rt7dpOYJOcPnybbTl69JlGiLGj/1U4/cud+REe+x08bKCoNIR+Mg+IBPZauU9QbgohAg0DX0k1gGu1tKR/ezWmMDin7DP0ORWlqIuqsEdsQod1Mu/kmOQuDB189Al0MeC9pgl77zZKioGds2N39z4xvJJK65zkS+DERSzVSMn0WwH4OBeUk2kfh4Hp3cRq7e5sE1qHCQLoMfrKz/GKCrPIOe9sK8opQ+hYikuku89KAagUa1/2tr8gUFU0uZY1t2Jwz1ofYVlkczRVpxAqmrc+bhJF9vrUEuB45ZhoxpogfeI1A1fTa0dkXAzz0rh1xyorVjuc+yd1zjOOfuv/W2BTUT+4D9895ik1LXqd1RLVnEoc1M+vH6WJB1MCRSvQPhYFh249EIxhfEzBxqn5LLfgnIKBLMBSWd0IqRpQ7dBcfUPzN7AaS9Vpq8PM0miwVsbcMZZkXTsbpkhoj84uAJU7WntnroGlud0nxtUgCRVIfuTbpAulELGFAaQAh0lIP2xWb1J6UGlqYOxZAms7HLQTW2OjqAZlaBguMX5NGlrVvzy6XcqRQOz/fsgI3Z0Tz7m/dTWGiYCDqgaWq/Y6mCEMjzgq03dY4knY9Uu49Rxgct6hD6NT3Icbc2sYNqJlQ2qEOtdsqwvp08qfva4/n8aZn93fvZZS32GryQxu7gx0kEa1xf0GQUW5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(451199015)(83380400001)(52116002)(26005)(6512007)(186003)(38100700002)(107886003)(2616005)(7406005)(2906002)(316002)(7416002)(6506007)(10290500003)(6486002)(66946007)(66476007)(5660300002)(8936002)(41300700001)(8676002)(4326008)(66556008)(478600001)(38350700002)(36756003)(86362001)(921005)(82960400001)(82950400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F1rcBub05SGl0Im1L9ZRf3KaqUlASnpz2uzQI1mZe3m+J3Pgrcdf0zOhY3yX?=
 =?us-ascii?Q?HB/CCdmXbblz6NAqnP9N2DSyTWBzK0sxs8hanaLCJH5/0rOxI7v3+1c8focf?=
 =?us-ascii?Q?dbKYknklY6tIOdD0Fittv72aCxW6lKEn8knGI2hMgHF8MCC9fQ+MJQxj/ZJm?=
 =?us-ascii?Q?ALycMq6a1d3Q4XvNBeQkPUub4OhQdiIPXw8VsXnltw7M4rNmHT4G3wHHCfpF?=
 =?us-ascii?Q?GR6Vebm572wzpuXxL54XW4pvgUb2GyweWZTWXGk8UZAy9cwLXAOLs8fwXBTm?=
 =?us-ascii?Q?dG8NW6jDA9zrZRh30kfekjKlVZvF7R6M9fcgxi2fBolkSllr+bvh0URUSnNB?=
 =?us-ascii?Q?vhzrKq8IUNCObgRPESVSlZKnVMNB7XRZD2R65YgxqOnB1LhGR/j9LiZrKWWy?=
 =?us-ascii?Q?DbB0MrsvSwh2KFylWZ8L9UC6GvsbCqYfdyOrsiN+3hr9jfdMzXSIpnQZmd7Y?=
 =?us-ascii?Q?3qa/vi8iBtyW+Xi7c0hlVggO+EosefQSGLPn7a/bQxyTi2bwl8Hf9r4ueFLp?=
 =?us-ascii?Q?86qh1hUiqrVwMk/dfWY6VQP9vbWeCT3LOi1fpXH+cEqhfkwZ7gEVjQ/fmOAy?=
 =?us-ascii?Q?rPoDb4PG/Va2zYJYEFEaqG3VjO384qR4YlBMuJqsK+jsmjZ/4FqVFAPcZfz8?=
 =?us-ascii?Q?ROfK/m8rk1ZzMYaWuHS6f9XjlGIRM7vk1OBRLSGMQBg0CF4+rUFDVm00DXNI?=
 =?us-ascii?Q?PeCvLgjKPemotUUJvWkdL6pr1yMr+0jtIZZK6z3DJUfBROvsottj59DzRrNe?=
 =?us-ascii?Q?r48+6WXjqyD1GNIOPeErP/Bk8LJ19ShdGUKG6x5SIvzYfjcOCAvapk+GmoPm?=
 =?us-ascii?Q?dAbiEwa4UW8DuRH4qQNmaIlM9hsqskaNrWoSxIEkXDpUxgmUnT8T6Nqo3tnx?=
 =?us-ascii?Q?sYCdok0+6944YOzxA/9jYX2V7Op5HP3d9787K/FKVzVjGyS7XiPyZW5FYvlH?=
 =?us-ascii?Q?E3bbXvhpU94LEeMp2Yhl/YqrBaDAXmSsvu7ALSjYxdEtz46M+AhPiWEbxAQn?=
 =?us-ascii?Q?Da5r2aGkYGCrj5lDmyeGYxw4p9M4ee0mMaQpEaIZbUnmszwiK2X2zL10dzKJ?=
 =?us-ascii?Q?ffsKgNT9/VJkHmAHQAE1TBlAJZZUtLnIlUxrmV7JH1pcM/z0vbvz3unOHk0X?=
 =?us-ascii?Q?32HmBSHzVILJz16xTKjhSXYYiJrMtKxliahJ0sjgEKlavyWF0cmy8cQwKVB6?=
 =?us-ascii?Q?MeWXoQH68yJDv64B9j4jYhfTP9LNtyv/i+eAF/F6Fq/Ii1vLhqPjfC3e8G8Q?=
 =?us-ascii?Q?RH9rPn6cVE1cRbOTqBa0awalLUSwL8ZlgEJnSaeXy3lDRE0kJAC3uhaUJ3JQ?=
 =?us-ascii?Q?sRWVeD7mJxTc4l9pWOtnmbggVA2bZKsDqkdm4dgWKrUy77I169s3B6wIK0C+?=
 =?us-ascii?Q?RmGz23WZXj4K4i9WALO0LYGnEAnpN5HMKEXqEO2QRrUpqQ7Ih6Ow/p1ot07q?=
 =?us-ascii?Q?huQk5o1/OkfDN/F/3iuxyTGUrnVd10gWbBlcOhu+CdwfmuOgyOeZB2abq4MB?=
 =?us-ascii?Q?KZNkxquEoNGp1QRgYlYKn5nVg+BLoJq25GzSUU/+B/37Oj/YcDNgAPAsY4cV?=
 =?us-ascii?Q?TwC1Il+IVbKVJbimlqstupkfDvI4MDnAH5jVB5S/GkblBH3aITiwv3h1ECSc?=
 =?us-ascii?Q?DA=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aca4de34-11a5-4b9e-47b7-08dac3ad1d47
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 06:22:31.6659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 29kyrMtGKDfK7i3UczBF5zEruTN7oyukrM/di/N8JlNEipiTnpc7XYb2FBxLXOAxpgQjoGG/eh5L8EFh/y/Ltw==
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
index f49bc3e..7f46e12 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -64,7 +64,10 @@ static int hyperv_init_ghcb(void)
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
 
@@ -220,7 +223,7 @@ static int hv_cpu_die(unsigned int cpu)
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

