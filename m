Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A728E6C94B2
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 15:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbjCZNxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 09:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCZNxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 09:53:19 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021022.outbound.protection.outlook.com [52.101.62.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6322D7A88;
        Sun, 26 Mar 2023 06:53:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PoGK1hoWcW5JXX6k63W18u575S+LffM7y77LaMrKRR7WtgjRILd+PEeI6d/CWOwWW87Zbko1QKrP7WBOtLtLh6u3j8/Hwd+T/yjqq9d27fShbnFgv0EU1zYLfCsPSxXTFtYmXsjVEk8HBwkjktORXBar/z5zNxxHs5Q+G+iwBZfA51Wn9MFD82GOiZ8AQaV35mRZcHafQk83oD4RciUBgoUxLrw4rKXS8KSgHwYO9SK5rv+19YIlSLyt4+ErRR6fdI6BTDrlGRc/P3rmy9CVydi5Qm3xIYZIdhxzva0gZQc1JF6JyU2Ysz2gHq9l3CzbFk8bKTDvP98iqoCvU0iL8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+vVCdaTFGXtkZXyLDOxaOfi/6PmqIHiJZMVI3+wmvEE=;
 b=b0IuYMh1KaUkIN3c4Pjp4nck1EnYK/kMXuIvGeISZ72gnJHvT7X41mNdvVdFCxRw74n7CIigIXVGeqqaV1ArdcNhPhsCLg/5TY6t9zVVCHmDZPODq8dWFCqFg5IHxKT6IkIVHEoeoIwDBpaXzaTsPVx9MN0JvWQjF3EfTCyPciUJazRUoQDrR5dvjCvqX07P1PhQqaEOrMSWjSSLTujdkXnSzXl7B2w69d05VQ2wheejOr3xHC+txhI2vUujlUyDzGYbxPafKkb8YIQ/wFhFxyITy+X1yCBRRiLdc0M/TydFmsFgE4i3Za+3859QvHMjQ1yByf0qx3hFsODpLC2rKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+vVCdaTFGXtkZXyLDOxaOfi/6PmqIHiJZMVI3+wmvEE=;
 b=FLbRtS9yGjcyhuMk871R+IvisOrMCPOtYKOasdkSIn92GPkh3DBEaW0fZHTGCUApFYe+L49cZ0xRf5uExONGWS7OZ1ooJN6sYV42c/B2WtZdUVQuDO9qmXD3h8sf6yxeTiCY/Fw6ga4EVc5EPZWXj6WGL4ql9sydtzF94J2tJ54=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by PH7PR21MB3044.namprd21.prod.outlook.com (2603:10b6:510:1e0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.16; Sun, 26 Mar
 2023 13:53:15 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f%3]) with mapi id 15.20.6254.009; Sun, 26 Mar 2023
 13:53:15 +0000
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
Subject: [PATCH v7 04/12] x86/mm: Handle decryption/re-encryption of bss_decrypted consistently
Date:   Sun, 26 Mar 2023 06:51:59 -0700
Message-Id: <1679838727-87310-5-git-send-email-mikelley@microsoft.com>
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
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|PH7PR21MB3044:EE_
X-MS-Office365-Filtering-Correlation-Id: 0be3ba50-76ea-4d2e-a7dd-08db2e017297
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JdUm/R0lWK0taqorcLmc75vT6I9ybWPfnGcDNko1z3thiyfKt9VBFZpfNBnHXlmUKUHRsuQRZfpjUm0Wxbd7wqbOl3YzquxW60DyR2wWnU5DdvhZCUNwJBZDbfqHEAZso3Aw27gU2aReXhjFKT/7iX3O46U0Qexzav3tiKbuWfnnw5JUEJ8kjikMY6qjnHGoWjcl6vWfn4/k6GsOOBI2b6TzhVpVTRwiqilPJ6puCH3eNVaI/buK6ECDJ1SsUrEGdTYXxa/OSTTvaNN4mOz5jcstIAopEJKH1w/VOnXATB68gx97iSb35jF4PIDKaRyV7H5Bftxdk3RzV+Ahjus8NV3tpGTfu4t/w553O3bl0C6PK44BuTkaOicgE0ls9sx4LHcp9Uqu0CrK+LHkVh9t8RHBaM9loac1sMU97GzJHNdl2v3nzpAHEA1B/uGylIK2StVru1mxuA2MI9iXhRwIDFEp1Rr/Us/yitV4hG+Ord8zeprnsrK8KKdk73H9AGhX+ocimVWW79q2/ecwclLBvOZY3JJN6wIZYwk03PJ1tAlQ4ampmYeaIaQBQ7vqhBDGt68waw3lHT2Td4CF3e0uS4iZ+5NSZBBWu419H74EUrOiytkmDsPdtw4rxNTI6ybNZI4efqbtyPsDUZOZJgrxRf/hFpmHIzGNW73GnTP6U4NICh1jm2mSWrBEO7FBCD5E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199021)(38100700002)(38350700002)(82950400001)(82960400001)(36756003)(86362001)(921005)(2906002)(6666004)(107886003)(10290500003)(186003)(26005)(478600001)(6506007)(6512007)(5660300002)(7416002)(7406005)(8936002)(52116002)(6486002)(41300700001)(316002)(66556008)(66476007)(66946007)(4326008)(2616005)(8676002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dmEy6PY7sTpNIjh3tcXKRRA3YTXI1l/E0EtWF0myN4cgfJlqqrlqWGE02Tf/?=
 =?us-ascii?Q?f2D4csuuu7zj9V/oRdKUIv1CbKDL7gCthQHKTe8CZ4xRgjWUjuTj3UpU52yj?=
 =?us-ascii?Q?2v2zmXnSVC3fDJYSa+lAtTDpdV+yTdZRS9qgT5ysGGDu6MFS+jPAmQmyZNZt?=
 =?us-ascii?Q?IfMJ4arfJ0Qcx8kGNxh0ha14NKVFydKY4lVT2Dr52cJ8gK6eDWhEVZVS8Jir?=
 =?us-ascii?Q?3uDLYN8Fty66MRlV1rmqg68RLPruM6ibPW72ArF47C7q8PfyvAouyy9hKuz7?=
 =?us-ascii?Q?7Cw+yQeO/eO49K4d+irkt8LOlcw5u0kOyl24CvUGL7Xn74nnGoVuJYqg/CAN?=
 =?us-ascii?Q?M26rf54RBLyOh/rukhYHlSir4pR0mHrl3gMzSOW1YMi/uy2MA0JVJMUIKIiA?=
 =?us-ascii?Q?BvIDa01+wZzaKWl1npjQ3YqWBWboBVzak87prJG2L2Pi03OdALvUnyxTnoL2?=
 =?us-ascii?Q?eYhbEbPIiV71XPFv/GxB3LFTnFpTs1z10YqTQMF8HhQLqczt1pHg85fEXcdS?=
 =?us-ascii?Q?dFIO+iv7OJato5PPEigPzbT3LWVExCyzG23hfSFq34JK6o+h3dbP89xw/T2w?=
 =?us-ascii?Q?O8Emt3sPuPRWfCvthUirIEHUrxXoTJob7L4EMXcAgWdl109xDiZwo93uPYPX?=
 =?us-ascii?Q?jiM/d/vMl5WT+Lf6hjOJOEKf7M1gxeCCZKCaE/dbo/o+OEVaA3xMAGeqDBIw?=
 =?us-ascii?Q?w7+TDBGjkIrpOM38zHLpaiSRtOYpxdNKqjVYLTpGtNdW9i+QTqyw0UeKGZ6h?=
 =?us-ascii?Q?Fnvcqa3eebGrCtztpqSDHu8rJpXDZlFtjTkPLpR/9Dfy17cOw/KV24ghDAG2?=
 =?us-ascii?Q?9o3lg3FDL3ffmaLsWCYDM/nfox8fIU+SZouJ1K3q+JLAjqNypTUY/jXgGU+x?=
 =?us-ascii?Q?5eul+3ntsv+z8fIa6YuBSgWPGEY2t2MIR/cI4pazdtT9/q47Ks0Ij+wLTKs0?=
 =?us-ascii?Q?hbAF/d5srISuDSkWjZrq7UjKwVdT5PIhbHLU0KyJsxMsuI+PPwFq7vi5SfEv?=
 =?us-ascii?Q?Kemny+ICKFKqTedF1NUGH63ZYehAaNz/9nfZlmrZNO2Xv5e8/imTlbIw0mdl?=
 =?us-ascii?Q?DGduLFDOff5B/h/NlI5eJJstYH1ScK6I9koftY6w43obRZmSwEBJIO48GoWF?=
 =?us-ascii?Q?SOZ6Qe0IwKmP+Hbtg3KAQgFGAG1IBWlhEmAQSZb/58v9iGrgPINl7x5qUkpX?=
 =?us-ascii?Q?x08hg+OknQjel92fuIeD/DINtwJynU3dNsL6B86+X8xQzcMpKc163+Kd+P4J?=
 =?us-ascii?Q?O3Sl+zLd59px1qVabc+vaFvrgJCj617Oh8PWZol7CDlm5f94J3O0tyq5M3pq?=
 =?us-ascii?Q?Lif4zsSneiFkiIyf9OLo7U1pASB0lNW7ecPq+7zQ0axW2XdXOQzac2m2qSX9?=
 =?us-ascii?Q?HUTAPFQ9rl669p/HSN6P0VkaaPCnhpD+J976YJAAi3e/eKa6hSSFQSKJEls0?=
 =?us-ascii?Q?AR5Dkh21aDnot7wxNibBC5bPsd3yqYN0Ol1A3Tv6sFWCliwXFVm2tAgvqZg0?=
 =?us-ascii?Q?+UcgBm+Qlg8r2xpW55FXFdZ/phml4++drrYwMETGcJgO8hUhLXpuhZSg3FbY?=
 =?us-ascii?Q?3lBBWotshDFiyBESeIMCGdbsfg0Qd+fs9C8oduQbYwqrertC8yEHfyswccYH?=
 =?us-ascii?Q?VA=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0be3ba50-76ea-4d2e-a7dd-08db2e017297
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 13:53:15.6751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vdF1y13ySNbb7E6pDdsNOt2DIgo0HWAAwBY4YW/fXq7SHFlvkp4D19xMV6dFXAjofCwAWTgF28Exz2SQ+ZpiJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3044
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sme_postprocess_startup() decrypts the bss_decrypted section when
sme_me_mask is non-zero.

mem_encrypt_free_decrypted_mem() re-encrypts the unused portion based
on CC_ATTR_MEM_ENCRYPT.

In a Hyper-V guest VM using vTOM, these conditions are not equivalent
as sme_me_mask is always zero when using vTOM. Consequently,
mem_encrypt_free_decrypted_mem() attempts to re-encrypt memory that was
never decrypted.

So check sme_me_mask in mem_encrypt_free_decrypted_mem() too.

Hyper-V guests using vTOM don't need the bss_decrypted section to be
decrypted, so skipping the decryption/re-encryption doesn't cause a
problem.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/mm/mem_encrypt_amd.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index 9c4d8db..e0b51c0 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -513,10 +513,14 @@ void __init mem_encrypt_free_decrypted_mem(void)
 	npages = (vaddr_end - vaddr) >> PAGE_SHIFT;
 
 	/*
-	 * The unused memory range was mapped decrypted, change the encryption
-	 * attribute from decrypted to encrypted before freeing it.
+	 * If the unused memory range was mapped decrypted, change the encryption
+	 * attribute from decrypted to encrypted before freeing it. Base the
+	 * re-encryption on the same condition used for the decryption in
+	 * sme_postprocess_startup(). Higher level abstractions, such as
+	 * CC_ATTR_MEM_ENCRYPT, aren't necessarily equivalent in a Hyper-V VM
+	 * using vTOM, where sme_me_mask is always zero.
 	 */
-	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT)) {
+	if (sme_me_mask) {
 		r = set_memory_encrypted(vaddr, npages);
 		if (r) {
 			pr_warn("failed to free unused decrypted pages\n");
-- 
1.8.3.1

