Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFBB6342AD
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234378AbiKVRm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234342AbiKVRmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:42:24 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2097.outbound.protection.outlook.com [40.107.243.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397107C015;
        Tue, 22 Nov 2022 09:42:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DtaTvrg7N3QlvCNMoKWXrLKo2glPv7j/nOPvMvWJKHfsXIgoyIEBFLomSpl0ynPG6LAnp3AAZK0EM81c0inzg/N0rrx/K/1iz9IYYsdlP2QuTCkH3KHH/a3UsmcewzBWqJ2u3y7A/ml36GeIMYUXFznVcrsB7fKN8mje/+4t+4nwrwRPU6qWwZCpS3URLJ0dNqVbslpbhwnvzK8pqu/SszLCaQyKXhU5aI7Rw7izAJ49NE6yazJJI17TbdcsfAHdWBGkdAoLY7cS2Hvk4WpPcd8DqQFc8By2TiZCPfeExL/3ZNXj/9s1VDK5Fx+ZT+4wKhF+vzJGlaUoq+H0Yj5OUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GF+ZspVrzWWFsb4Y1zyj4l5I6i2RQL4kbglTZ1rx4SI=;
 b=UAYsMrNZEQRbs7c4KrvWPKeRtpmiQIEpHOPD5ORBHs20TS2ru0tQEe8xeqrGKe4hFtOXUhfbt8w9s3jiXzlSdDmmJulXHvrd2AtUzQvP5IoRoosUQajIHMGITgINS3dAwTw4jlxaPh7BLedrGV/W3eeu7trthdE0RR1J67fRPBMbWIYfky+jm/FUkpK65jzOiI6SwE9sH8vhAJA1Y4/BUlleJGI9VNo7uxO658bHnooCin6XDryEuEqEocg1K4umY+UschvSVSQN6nDhY4sFa6/oVOHdt5RcBmfXZ12vOkyR/DsO/rNBRX1ajikZwzH9o9kgd4X72K90DUu+GgcjAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GF+ZspVrzWWFsb4Y1zyj4l5I6i2RQL4kbglTZ1rx4SI=;
 b=FofFUq2EDKgfGL0rYX9BBVggmlC+W21LlgSeNHxa/gmdH5tSdaoOtlkY/FdYQ9IhaWuF9suyrlQ/2Gpd5X/j15Uqo/qiMc/mHoStQpxkTYIlh6bVBFvZDrY5LhUzwaEoThtssvK8og99DUsfahi+0/gEBXCQbAoLMNJc90OLzxU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BN8PR21MB1361.namprd21.prod.outlook.com (2603:10b6:408:a7::23)
 by BL1PR21MB3379.namprd21.prod.outlook.com (2603:10b6:208:39f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.2; Tue, 22 Nov
 2022 17:42:09 +0000
Received: from BN8PR21MB1361.namprd21.prod.outlook.com
 ([fe80::a8a1:1319:9d94:77e7]) by BN8PR21MB1361.namprd21.prod.outlook.com
 ([fe80::a8a1:1319:9d94:77e7%4]) with mapi id 15.20.5880.002; Tue, 22 Nov 2022
 17:42:07 +0000
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
Subject: [PATCH v4 1/1] x86/ioremap: Fix page aligned size calculation in __ioremap_caller()
Date:   Tue, 22 Nov 2022 09:40:42 -0800
Message-Id: <1669138842-30100-1-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0059.namprd03.prod.outlook.com
 (2603:10b6:303:8e::34) To BN8PR21MB1361.namprd21.prod.outlook.com
 (2603:10b6:408:a7::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR21MB1361:EE_|BL1PR21MB3379:EE_
X-MS-Office365-Filtering-Correlation-Id: 90f8cd86-1f20-42c6-016a-08daccb0e031
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nkIGM3HcKtGDPHNTsLgtvGhbqgUoacoB3gGQmojiIVL/KYw8M02OWdMjYzSIAKjy47/4dBO8OBtAPLU9gKcdIa9vvNTLj2NkHc8fU8oOCYoQi5sbS+ll1O+BxLIFhKns+hFiBhTOsr/DuS/1Oekle5sMgP7oV4qmTHzt91cvUwdh1f6O/meFbgzQ+Smazt7kfWTzYpJGgGEZmx/FzCuYrj5F8M3y9SAgxrTaFuEYCDIGf+hxQxDddVdAQ31w+Q2yaaxkJBjXEa96tzhhjga88GPJSR8uuDndOQevlvx27bOBkGNrBJdws2ntEryi8xmO0Y4AwoAWq1jq7RiUcpQ0OGS2Jms6AxOJ4FW2I5JTc7NTMDchHEVN0UOujerGMPe6gfs0ToblLwfSLbpJ7rw0GzXZObXNORaHHAuWPYQjxdGY1NlZ4fg3PN09EIwFh+4c7YyUB1oIJzqcohXf6emNrpuZClNF/Q1JZu52BFffxBA6kojPYXlaQU90Bx6lC7TGWYbIwlKn5qlr0zfL6nMBEI7Hxf3aAJM8Z/y4l577FG9WiccXsLAEkHWlzKI4uaIo2X7sUArDgzSQ9T8SL0VNPV8x5MiDTHDv9rKg8SKe2GQYh3sOUYIQsotI1+AeAATqn+KGioCxUIQsNMYku2CXePRW1QZrzxTutu3nMnkiLWxoMf96LU7RJEfQuCGUeYmnFbMRmYAdR+Y+dKxzTVcuyTtp6gskvKCj/eY/a2L+YpBhKtYqCDml2RUlI2tFbUuso6se55ZR/dZOZeszTknEFurrSwZNkprz0GIJSFqH3FI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1361.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(451199015)(36756003)(82960400001)(921005)(2906002)(8936002)(8676002)(7416002)(7406005)(82950400001)(83380400001)(86362001)(38100700002)(316002)(10290500003)(186003)(2616005)(966005)(6486002)(4326008)(478600001)(38350700002)(5660300002)(66946007)(66556008)(66476007)(41300700001)(52116002)(107886003)(6666004)(26005)(6506007)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YBSQ1HoozY0JR5zS2HUPqHoWvcil5nIgsFKE3D1S6vSm3XsM0+pFew9ECGco?=
 =?us-ascii?Q?0TDA2RPcX44zSEkSbH8RDlwuts2e5bgEKzTUoeKmQxih1w3BSfrFrMUBupbQ?=
 =?us-ascii?Q?yCcMEosGbyMkouxvEubXuQoDu4KvhiSLxVbmsCnO7nY7Wada/louJtoHMsPj?=
 =?us-ascii?Q?/y+t8JAZeGAeWxDzec837seX0zOLLjNVtv8G+7mGkCUjePbIdIfXrQgB5zLU?=
 =?us-ascii?Q?Q2FXjSRFQ90qV8nO9fw920ewUn0OCFCayMSiFn9Z+43BDWw4t22GIiUAG8VI?=
 =?us-ascii?Q?tbpXXklcQuhwJQW52nPQRa3sQuTQIDoxqdwUumE0dnPY+/Jm3Aynn3YSyJuG?=
 =?us-ascii?Q?Ko7jMknuh6xGJR1NSatjKvz2SzFUhe09OabAjnN4ZYWe0g10dYON3JCkApjd?=
 =?us-ascii?Q?RTK1oxIICri7PRUeNzRBHdnp3nDC1F+CLavwsaNWfg/7VgpbgEvAufqZj7xZ?=
 =?us-ascii?Q?RizP8BDiewdNfx0YCdbyPUwRbVIcDHANQtAi6od/ZXL7mGnuCNakAPZX4wHC?=
 =?us-ascii?Q?FEVa2CZyqLPRFaqOkc73hsIZluy4c0La6J7UIIPxCzmSCE/jmQuTYYNGlo6e?=
 =?us-ascii?Q?6rUXRJB1RA+DBH26+sD2slFxqEU/c/r6epvMn/ztI5WE25VXyHo3JEYn6Crv?=
 =?us-ascii?Q?ki5X5ASn2RbTRBuLfwX+KL7gVZrhjp9Te8Qmmwa3Rr7QcgLUQS3+l8d2ozkr?=
 =?us-ascii?Q?gMIj2NxZW0EheRDS8/aeANkcZGPovC/lEvLcGDQJYNTAfnuZ2pP1UmH3Wshi?=
 =?us-ascii?Q?BR3bZrSpB2MBTbfkC9/OKnZ3wOTgm2YSDKpWnYhMKJvKj+DQg+0HR9+Dp4xB?=
 =?us-ascii?Q?3EG6GH5OLC2O8qvYYwKRQpRti322htu+pqymnLGG3/NkBAJPV2XPiD2jGqo2?=
 =?us-ascii?Q?AshE64d7x2AjWXK/Dv/SkSN1gJn+ZpAf+nvj5b7S8t9lmR3dZ01l/iGluJxT?=
 =?us-ascii?Q?8C3lYjiKCFMISlr7KyDbff8NPOidQcYwfct/DFqTRV0xXvBkgAefFAej3YeP?=
 =?us-ascii?Q?57OfDJbEUixw7Zh7fl+Fy//6YMfcPMU9OVc/f3k7scKT/ECrPX5g/bLvNLVd?=
 =?us-ascii?Q?M18LM0SPzOHGt/veskukf6OASwjfnQsLeB73vo6PrWHkmxwRD1CjudfTDXu8?=
 =?us-ascii?Q?D+Em3jEVxhOcPCbJIlZVd4Cuvp+EoCDhWihvICP8gC5xeJR9ftoH1YrZ1qO5?=
 =?us-ascii?Q?OLReqt8DuvqavlZ5QNLguUx6Hol7HcWn29luAGKAhTW8JuzXEFfI5u4GdnSl?=
 =?us-ascii?Q?E+ElrlWF//W9EQo3pb16xw4js4XuvtyUenaK03q0JuJ0kikhGciAjiLXSVNU?=
 =?us-ascii?Q?GkSThlHl5fQI0iFt/SY+MCyLULmH5cyFq8TlXE4lf45Krdhf5lchm0ji11E4?=
 =?us-ascii?Q?J1fCU1thYeHfKrLaSs9zxXAOgH1++flKSPSoPbBPW1pd5VDmXaamE64XYjYb?=
 =?us-ascii?Q?ep7Wh1EOE8AasNjzPE9vSPenSOCcOmxlkpy12cuhhaflklNKtrSotyHKZGkg?=
 =?us-ascii?Q?DLHvATesdo64gK1tugH1SVvIPBif+NySDHv06tX1szH2+1JzzW5HNj4D+wDw?=
 =?us-ascii?Q?5UmJ+PRFYr9E/EQuwDDOR//ZcIJjdK/L3d71IKYE?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90f8cd86-1f20-42c6-016a-08daccb0e031
X-MS-Exchange-CrossTenant-AuthSource: BN8PR21MB1361.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 17:42:07.7078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1NNRh5wz6j334e8LlGLGno8gkAOisPCfo96dyRiP9RHX0+zzVO1Mo2AUV8N0dEbHW5MbjlGhv3+Ln9RV3nD+iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR21MB3379
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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

Fixes: ffa71f33a820 ("x86, ioremap: Fix incorrect physical address handling in PAE mode")
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---

This patch was previously Patch 1 of a larger series[1].  Breaking
it out separately per discussion with Dave Hansen and Boris Petkov.

[1] https://lore.kernel.org/linux-hyperv/1668624097-14884-1-git-send-email-mikelley@microsoft.com/

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

