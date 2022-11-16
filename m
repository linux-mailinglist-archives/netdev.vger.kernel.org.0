Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13DE662C7D8
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbiKPSma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbiKPSm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:42:28 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022017.outbound.protection.outlook.com [40.93.200.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3521D18F;
        Wed, 16 Nov 2022 10:42:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EBvuciUlUFkMOLbeT1laddt3/Mn5qh9DCIsKzV9a7hGQ6tdqRJTRQhsYKG/aDYrzSY9lyIO9Jb0DobeF/InVOOqg5HZgq6gmYeTGDvnTwXzPRgzSFtcluRStPrTqY6Sp3LTjlgZHBEwL8ToC6HfvyotdWccNp90iiDlizFy0Yjxf3qr81SW/lb9912B550eln6mZhH1At7eb8FXFo0RDzuBBXgPLvL7s3rlheqSC2qS6sjbvJPJKOXbVo6eCWRSMv+1x5eefpi2VslVCIR7DGC5yvuDogL0oxYOjqJ1pS6ySefbiYwjmcoAFAsPjIBZtnrREPlyW4UaSxenWyqOR1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=455p0PAhRjkQDFU3d5FTc/8biS9vVijN2mB4Ou3h2T0=;
 b=ZHIzP3SdSnuqPgxJ7bbNThaEVBATrwhozDJ6ER2nNOketOb+/V66Gltxni71YHqP9WIH4nE8XUfOFaMmd4fuvUVHRtyU5bZL3UF7VqgdMA4V8fcY5Ei45vDA+ZtrVau+j8ZXJd51rJBUwLbtw85BPFtCFl878sk5UrMt0pDYnXXuboI2GePIVCKfkAieI+AdTJI6Bu6MPCfpwSTjQHqQ20KZ3wvgMIhP2iKW3GxsCHiSGQ6jSElPRL+OaaXROhdGd9S75v9UMxT1obu4YeNTFYkLtZyELZ/A0U2eV9t/lmioUURDPVJtRQu8ALLCAadGUOsz+kpO6Uid2eSFEXSaQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=455p0PAhRjkQDFU3d5FTc/8biS9vVijN2mB4Ou3h2T0=;
 b=dkMTWkb4Tv0GKUYJGFB/XnCgQvkmnXqF2iELY9xxUEGOG/AhvaQvn9MVp+oY34YlOx8Fjjez0sqi5jDsq2aeMVrDpCNu8cOGZq4nyojt41+SFjjddrq73GVFs+yXh20Ub6Vt6qogJjUXwznJkf0SJCSaLzXGyEX+ritcF+Iz40E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by DM4PR21MB3130.namprd21.prod.outlook.com (2603:10b6:8:63::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.5; Wed, 16 Nov
 2022 18:42:23 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5857.005; Wed, 16 Nov 2022
 18:42:23 +0000
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
Subject: [Patch v3 01/14] x86/ioremap: Fix page aligned size calculation in __ioremap_caller()
Date:   Wed, 16 Nov 2022 10:41:24 -0800
Message-Id: <1668624097-14884-2-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: ec1d932f-cb78-4508-9519-08dac8024d16
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bg4Q4tCcZ2sC3QD3sPJrQbVhUJVzbLIaS+Y0MZqh59EMDBJIfnnQzSnXpOMtH9YBN85zhGKZCmOAD8dGea/K+kJUuvf5IzThEAIs+3j6LGliEQLSAapJrnNB7qaQLlhQplpTX1SPuqH6QgJoqRUJFSyMQT09GneHO9vLb1WC1WlF+IJ+pAGF8MirRvDT84Vpn3H+pcdHFViro+pwb/YR7ZQ5sM5x+iC9q+GaomQO7bMTAy5yTXmTzi4mgzGo5a/CoODPcDC7TRQhA04JzYTiSKi7U625uTnKIHB0+PnKai75fCK151ww4jgSJpKcTV15jrjfMLgUVBmk6vsdSv1IqIjIdS8cfeoT8duU1t/2BmRhSWPChMKuexpZ4aouvQxEATps1i2NF0HUXz/A+tdJdY9TKaYC1GJXvHdr6e94HPGnDXpaPdYRO1iX/sgRewjZL6Nlg9qDsRz36wUckGgbaM4JoXdyHVG9crE+dgbdAxU9PRC3gxhg9oj++5/4UHiZhmt1tvtTx3C4cLjNOwQWNqcAr4kmbDUcaqMFNYtUiFhZ9zks+eQlfTvN7hJq4jTvrJTtqmb+MgPEADdXwBo1i8BKG6qG13DJchWHzevYG+s5uUPX3YyDbw6pDxa6295K93WRwA+sntfoI3uHiLOlENQ3c9ei1ZKBh1HrXm38poesWzAvtzTgy7QD/SztJYipb5JjgC16tTkLbk7jD0yQwR/qXuZK2A6s0DOvX+b3YiG/r8/E21rT3fhVfOS0tCi7/4TC0e3OFkSWJfBLHeg7Dr3FMDHnLZKxf+MXrlVDfGROJN7blE9HiZeNKe/g1csE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199015)(4326008)(5660300002)(8676002)(8936002)(7406005)(7416002)(2906002)(66556008)(66946007)(66476007)(41300700001)(107886003)(82950400001)(52116002)(2616005)(82960400001)(6512007)(26005)(36756003)(10290500003)(186003)(83380400001)(316002)(6486002)(478600001)(38100700002)(38350700002)(6506007)(86362001)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X7GBVXybtAAG1M/A4Oydcn05zkMcKGT/tl6zb7KgeS4zfl+Uo6ECucz8uJ6U?=
 =?us-ascii?Q?DzFgKqqed3IbShTu4LJUDeFJ70gUxrPPQTlJPlLaa4MoEXAtts/Mcvzaa72j?=
 =?us-ascii?Q?VMewSLSZXNQHHiMU5Y++CxXGtyg4SWRxpS/3krTLuzOUWc86Wb3kR2mZ/YOe?=
 =?us-ascii?Q?+WJuHC/pV1Wpeq3+CfS51caD2eejzaPGjZHCovsZLKbZIJlfzl2deB5fXG1L?=
 =?us-ascii?Q?zuVHtSxrtS6q11jb6dlZjjylgG+eCgdzajewUY0c4Gi49B2/nhS7PxNui+MX?=
 =?us-ascii?Q?oQM/eJc35R3DpwSo0ZmsVY5AlYQEfl9sWk2Rh7X7vQdhVXZpBo3Wtvw8HrSQ?=
 =?us-ascii?Q?rzvbGw+8qm/N1wi0zll0GXKJ7QGH6t57OmoLLhmfHStOZkwFSN4cfqWI2Twa?=
 =?us-ascii?Q?eSXNoGexIgQvQUkWWtmjw/P0nPp019vEEH/qYpmoN2luFLGdKWdXt0J+SHxr?=
 =?us-ascii?Q?U6jSD4rfzwFnCaLLWSgjHSv8qXLuMnW+1tlEt944FGolGY8bmKFm/9YY25gJ?=
 =?us-ascii?Q?I43EJojwo+P+NsJeNrbuPPJhP3bSNmOAsDMIPj1Li6EyZ+M2kknsfh14i7xX?=
 =?us-ascii?Q?85LvTZcreN4TVv+YQ7l6/JdqNRZOppk6ERm0Tj6xdcwhdbQTpX750KHsvjYA?=
 =?us-ascii?Q?5pnnQjLU60Xk64KG4Rh381ueubkE6GJX7PORVDJHRYMq0sbGO6PRKCA00nc6?=
 =?us-ascii?Q?jCjPl6O0RkW6xt+xrHGuOOnbDDeQJZ+AKzTyz3ZzI5OpYxvcuGwGVJZEUaCy?=
 =?us-ascii?Q?ZDKY+zl0bdQcpFaQjWwbO35ymoeHVxwPfLMLWpKtKCxT8zelwdpkDxdyPV5z?=
 =?us-ascii?Q?POOZ5cj3s/k3phwcUx46snQHE+F+1FvoqPfivDkmV8uUeIFoU2YmveCMfsaF?=
 =?us-ascii?Q?qdqPC3h+CYKgfQl1h2+RSWmCOepii9Kk3ZuxvsIQCPwxkM4zDg4zkJA2mceV?=
 =?us-ascii?Q?x9X3qbdUecBNk08tq63qHypN5uj4pINkO5DmKIKphA3RWIgHJ2T8+3cN33LU?=
 =?us-ascii?Q?dj8nUkGRCGLiCAcEt5zc6g/UvZ/tBfrOUgH2ahr/GYIh7NY2IwDDUqB7P3Yr?=
 =?us-ascii?Q?D4GzUg1Nd7FKFlk39pJ4oAlJeZrPjbOBeqtYg3oT4vAl6FBCQi3VOmzMBMUZ?=
 =?us-ascii?Q?rfHfILGl9vYFvbo+y0wLwvL6ZzIRhpHVgsi3LSpYyKxAtcYqy/McVDobtMy3?=
 =?us-ascii?Q?C+RAKYuS543EmAj9KaG1bfzY2L0YXhl2PSD4pB0m5VKCi/3Lykhh2Y2VdqEU?=
 =?us-ascii?Q?hlI/o9eiiXmGrF3wWIt2Pdnv7zjlfC1e84/gympKNm2d3bC8AEln2HEEXtYn?=
 =?us-ascii?Q?AYDba8yZyjdDf6MJ8y9OJ3Lw8+TzrqngIyTJ/AL8FQrRfIjiAEVr/EYOIMld?=
 =?us-ascii?Q?sf0h0UNaS7mDzZd23OK6eRboog1jnSqvT4EmO/DyrUXsXSlAuRN3HTC0poGv?=
 =?us-ascii?Q?+qtA6s6za6+PvkPe6zTay//m/zGAWrsBp56U1sVepyw2czW+07UL8wEzxsVT?=
 =?us-ascii?Q?Uys+7rS/7KyeXl0C0AXWG8NILgqeOT+w2qdzSaCAeUL6l1vOzIQr1FqWbwP9?=
 =?us-ascii?Q?26ePkQb2DqjBUubPuNIzMav2N4+gui+FtOSm6VwD?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec1d932f-cb78-4508-9519-08dac8024d16
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 18:42:23.7661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: caJJseyWCU87+Dmbfb/3JTtlYiTYMy8sCqAP4oPtkgHnxxQNqp4f/8TB6qon7g7CRBW6Wgb0DFQpMvp5UFA/Mg==
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

Current code re-calculates the size after aligning the starting and
ending physical addresses on a page boundary. But the re-calculation
also embeds the masking of high order bits that exceed the size of
the physical address space (via PHYSICAL_PAGE_MASK). If the masking
removes any high order bits, the size calculation results in a huge
value that is likely to immediately fail.

Fix this by re-calculating the page-aligned size first. Then mask any
high order bits using PHYSICAL_PAGE_MASK.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 arch/x86/mm/ioremap.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 78c5bc6..6453fba 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -217,9 +217,15 @@ static void __ioremap_check_mem(resource_size_t addr, unsigned long size,
 	 * Mappings have to be page-aligned
 	 */
 	offset = phys_addr & ~PAGE_MASK;
-	phys_addr &= PHYSICAL_PAGE_MASK;
+	phys_addr &= PAGE_MASK;
 	size = PAGE_ALIGN(last_addr+1) - phys_addr;
 
+	/*
+	 * Mask out any bits not part of the actual physical
+	 * address, like memory encryption bits.
+	 */
+	phys_addr &= PHYSICAL_PAGE_MASK;
+
 	retval = memtype_reserve(phys_addr, (u64)phys_addr + size,
 						pcm, &new_pcm);
 	if (retval) {
-- 
1.8.3.1

