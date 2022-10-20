Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5E5606772
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 19:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiJTR6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 13:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiJTR6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 13:58:42 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022020.outbound.protection.outlook.com [40.93.200.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A75F199F4A;
        Thu, 20 Oct 2022 10:58:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cwPWgVu2ZuNb1XYp4JyjksPx7hAEJiyknfOR0OY0tLXCM7eMkqcoHoGchSBY+BT1VJkXqg6QZuXZHYGghCRNMBLw9+unqNwGMAu7P59L2ERBn4bbhByitNn4iQ7/8bD44ZOTESnHMLfw28vfXiCdOTdgFS8sQRCE0TxxUTFu3PBTA5QDWTC+9hLqbz72U0zU62s5sIqtKq9uC7GAIg1g5gMsYbBKyZwj+PX/fu8IaH4vUQX6DMyrPY/r8llCdYJsHmi7REneAXoMajS/Bu8/fwnuI4c9DEMx+Bh5svbr76l5jQy1P2oDz4Ek7h1EuKhc5n6CRjImYLkiq3kA17P8VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gFDQLJOQVpUWkm3kDdRVko3vVZx0WrPkQzObAxlAqGc=;
 b=hGNoADVEABu5ixhhMwrBnvHS7Tm4s2riggbjCxpToBSmSyanXgq3vU6fv9k+hGvLVwByE25nerqkw5oLxhBT7iMxUJbx4hXmFYlmdhmelnmnUk508MHX24AHjcQSN6mutJSsLbOK2wQWvCAxhilcfbr/GZZv32Zdu9QylMf3pYVY/64453ii0clsSf89dpTqlijgVpCech6lGxr3K8szNZH6NLZGXHQV1/IBIC5wmb8DgaYE5IBhZ/AZhAcGnp5nj/b01U3geJzL279D5Wy5fM3DfSzds1OUPPE/amNS+uqoY9Zyad0s5cjQvCS7pI+kZ2oWJAia5CEerNMrH2OrlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gFDQLJOQVpUWkm3kDdRVko3vVZx0WrPkQzObAxlAqGc=;
 b=bySuGWgiMZqfMhMDFE8K8mNnzt61mZaM0p+D6PfeAiXi2Vsu9TEuirsMrIOrOcvY8mlLvQH16+lQFxGV5Ws1AjpaDD4/Euhs0UU1f7v+KczV9Zr+k2zPiv1bCjzi0uKbt+3gv+YZXnxWeeu4mpQxg+p0ha7zoXq9jy5SlVZTVcE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.17; Thu, 20 Oct
 2022 17:58:23 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa%3]) with mapi id 15.20.5723.019; Thu, 20 Oct 2022
 17:58:23 +0000
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
Subject: [PATCH 01/12] x86/ioremap: Fix page aligned size calculation in __ioremap_caller()
Date:   Thu, 20 Oct 2022 10:57:04 -0700
Message-Id: <1666288635-72591-2-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 63219d09-63bd-4cfa-5a77-08dab2c4ae27
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QZvBN3LtGzsafs0AJT24XkmVUW2FNrBHNC4M4NGQNVR4ngUUnaIOvkFIPkC1I8LEQvDdZ3La8qFCbrVCv7DVJ/zN6U7jEbPjPiRtEtgv5882YN3rhS8+FVXFEFuxM7pUKtmdzqDxYsQDDFYBUIa4GFNU7gaTuzp6MZpHveAaMYmydwKDySOgkfekM9wHFYJtQs5dc+TKL7/k+k//D001fmTZiRobyHa/pQ0R8Y2DZk8UOXI3A91QlGl5VKM6Xc/7ZqvB4OR7r7SB3kgct4ZQnNt6rFuVZEcdXSEHOu1xAz8vil0Vuf2H4GbHSUgWQ6zhV6HzkLgmAtWnE7O2QubnLk8PjnlGPuBFT1a7K4FWlOzmwAlswwGgVjbJf2iyzVKYI63cdt6+z7Ns2hRhaMTD2xif45CjdRfjvM5sdK6l13IgUlmyc60vqIMIRmdCnJmF1CL/co7wGw8YRqh+t3B61KiZ11x8xBgp1GZYyapo8Cnwb02Y6+FbvGb0WefQQe3zJz7txo4sGsjvXx1KDWbUZ7ZS7EbuZ0bZQsXCiRGK6490xWgEK3bL5y009TFf2k1EO0UTBXuVyDTootqGq1vYIvU+XwXYjx/apYKFAwCp1utvIAlvSyiwTpbk6obknBMPX/YmtITDi10NB0ffCjNk5lWIs7s5kZ+OjFFXULINPXTt063pZPjyB1+z+GBlwnecmq24W4WkrePTr5YEAsdTmuskSLGa2WjNMQ+b8Vk0KXVjFqv0oEpLkJE7BUCTYvfOyDvhAsGd43cbk4fE4SbIjPyKqjJZFFEfbVrGD/RK3Hsha6/hQu98I9bQ25B8gTnW2mA+4rikZKiq6LwXAzkg/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199015)(186003)(6512007)(6666004)(107886003)(83380400001)(7416002)(52116002)(26005)(2906002)(4744005)(5660300002)(6506007)(66556008)(41300700001)(8676002)(478600001)(8936002)(316002)(4326008)(66476007)(66946007)(6486002)(10290500003)(82950400001)(36756003)(86362001)(2616005)(7406005)(82960400001)(38100700002)(38350700002)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IViR8EqqOXo6V209ArdsQRWE4a8kg5eK9qIN1EH51JYeJJy5inzXDCRpPmXi?=
 =?us-ascii?Q?mokW/Yumz6UxcNwP0GwB0VFsdVsShd2kXrI7vKzdU+It6B5cGDRDBvBEs87k?=
 =?us-ascii?Q?TfrecQajRRF3P/gVVnirR/lmNtgTlOVEA3mTG2CghZxOE8Zrv7rOuRYnmRWt?=
 =?us-ascii?Q?qfL5y6EWMMViG9s5glVlDG0iP88cYv/uZj1bodk2DPJU+HqE4enXuKLVNPN0?=
 =?us-ascii?Q?NL/2fANs86PGeXCYQ4VJYDvPfIstVLjgvjMg4GhX5ddzHxPw9HUWi2s7k8RM?=
 =?us-ascii?Q?2zKgMR3m5NYFR2LIiD9L4pUqqLGploAX8zlnG4Xkps/pIaHa0x7/cJ80dW2g?=
 =?us-ascii?Q?qf7UlcbA71PvLpCZxpyn8xZxvgngv3JX0aDUnTqry22yq/Yo7/rykOa32vaI?=
 =?us-ascii?Q?OCoca4lbcIqwoYKhlLlQCyDmcpPiG5B1qXyLdKeZg1/7nTPNlsY2o3NcX0a+?=
 =?us-ascii?Q?SUxSpU1ZgApOnxT5uKAhUA3fL3Uvv41u6i7quXzdQoLohTlAC+XUz+UK9kz2?=
 =?us-ascii?Q?yp8m+BgBXSzPU36+WljK+koUraFxgwnrkcdl+Wyoj6RBufw7zjWKPAakvTcX?=
 =?us-ascii?Q?DRAy312t6CJa4L57C7PxVGieipz09vNU/Qr1VtkYW9qfHn0eidAHlPO2EnxJ?=
 =?us-ascii?Q?uKknw3EwlakPugWZU2GVmJffeb2cTm3iMY/QVllqFDvnoQ0ZHXu8SnTKThhH?=
 =?us-ascii?Q?BU2K6BNmZ0MbKmifJNEzonqsWApMfewyqVxzNA6jEhELFxhE1JVcvxHjgY7A?=
 =?us-ascii?Q?OYUGqAsmASOskx6HBsxznqcVwCRSHJINtRbtDbYvM68zPUMCys692Wk2qwIT?=
 =?us-ascii?Q?OtY0PCkoXP9uKRVR6A8YJTRFAM4o4t5dxcezzfadKaT+Ae405uQVg6SBD3jc?=
 =?us-ascii?Q?JxkCTZTjF6mIafG4ZLR1PX1Wqm3EXmxeDVRfpr3IZ+X/8wUxnzIdoCbVnUz5?=
 =?us-ascii?Q?CdexZYwqTAHnBDYKZ/S4jAUX+6UgaufdtmtOUGd4B+M5+ye76BV7ukb0AQs+?=
 =?us-ascii?Q?A8kzWMFaEaPruIfeyENq1pEheUEVViXatQ9MOOzp0GVGr8YR/p6mL51/jmmv?=
 =?us-ascii?Q?ncPjZku3FWC+I374ImibvzVMjK8kgkfao6IJWdChGR4UgOdCFftn5XU/BBV1?=
 =?us-ascii?Q?AWnbbaekO9Jd7ZvQcXpOJHi2XG6ZAJFg41UwWIPahEQj/W7ZSHid3Egx8hFW?=
 =?us-ascii?Q?Hm637pi68jxnyrgAlZJtZENU+uCvFY076kgjM/BaeLA0t29aiWphawuSrh3Q?=
 =?us-ascii?Q?2ib0la9HAjjyqfy+dyZB2opDrZVrGyfsag6iumNBXHmtmsUohtBoK92nXciQ?=
 =?us-ascii?Q?kUFiLSx9W1+s9L21LEq4upjgiPauLZEo+TjC4LI4RhekBOOMRiQrtC7NP4VW?=
 =?us-ascii?Q?G2oA2i5IN4NvWUZ8mXtx6tZHO3y+cZ7diQj5SVukgwLzSVnqTacrm5p79szn?=
 =?us-ascii?Q?m6SdXeAuSCvPSLmBHZEAJIspEWIBRqxzatfGQqvv/bT5dgBXPI7f5xVyZadH?=
 =?us-ascii?Q?FgQ/BU5vAnCWUVDLHMRDyz71Ws3OFZcGEAJUT4wpfPCn8PdRoBnzQO7g5ast?=
 =?us-ascii?Q?7AZ0a5dNHEMQjXLjLmKC2dva8Yy7df3eGZLlSffU?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63219d09-63bd-4cfa-5a77-08dab2c4ae27
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 17:58:23.3838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: whsvVNXcFswK5ZdrO+lwCxXzhsAG9Mqp7yGBS++CfqOGpuw1SL7gXl3v2uZ/DgJhgdGzE1kz/Pri1PKPSFs5Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1857
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If applying the PHYSICAL_PAGE_MASK to the phys_addr argument causes
upper bits to be masked out, the re-calculation of size to account for
page alignment is incorrect because the same bits are not masked out
in last_addr.

Fix this by masking the page aligned last_addr as well.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 arch/x86/mm/ioremap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 78c5bc6..0343de4 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -218,7 +218,7 @@ static void __ioremap_check_mem(resource_size_t addr, unsigned long size,
 	 */
 	offset = phys_addr & ~PAGE_MASK;
 	phys_addr &= PHYSICAL_PAGE_MASK;
-	size = PAGE_ALIGN(last_addr+1) - phys_addr;
+	size = (PAGE_ALIGN(last_addr+1) & PHYSICAL_PAGE_MASK) - phys_addr;
 
 	retval = memtype_reserve(phys_addr, (u64)phys_addr + size,
 						pcm, &new_pcm);
-- 
1.8.3.1

