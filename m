Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B95963FEEA
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 04:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbiLBDdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 22:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbiLBDc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 22:32:56 -0500
Received: from CY4PR02CU007-vft-obe.outbound.protection.outlook.com (mail-westcentralusazon11021023.outbound.protection.outlook.com [40.93.199.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EDEDA227;
        Thu,  1 Dec 2022 19:32:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxqZoQQddbxno1wEbDpgd0dZK5gzQxAoYq+mDiLwLPHcBjZSWTYxR2LL1KWrunSV9LlBGvijZxuDCCrDhtSCvckPg88ir6kaibEaZMg1UhfO1jeeWSUY7SYgQOsSWyXcRLWpqBnrWmIYUKLGFcMnW1J8PxkWodmW3Z6rdxf0Nw4VTAequQxirUkHXO3bBZ21qNnjem6tBrxdDnd5IKqXOll9cS9l6BwK1aa9pyif9dMI/oIkQ6J0a1iX9jA9olWQUR0dlVWV8zHK7WanQ6k3ktPIsqimPcvwr7y6HsxK61cCQdUNHjV4f6ySE7R1kj5cyCcf6cMeNcOWS6S6TijABQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VezcU7/usf/P2gz28QoctXZiJW9x05+beUA8cfnfEUE=;
 b=jH+5NIB0+GWK9eTSrhlQtxY+SyrBj4yeQ0Zj6qISAS0rmsn0IFWyoIu/UpEwrHpTyxSzLwDikmAAXeZXj2De3XHc/Yotp2Ej22/UmfzWqojHZwcB0kKmB7V0nVSwHyVgNrykwj/FynTut3ylnV6hRQSS7BpJHRJ77ErrI4sXGTobGtGUsnZxoxDzcDu0Q7OjOhu24EQBEH42KhpkQRrAtkFgza5i+PRICDKf3eK4m6PLpSMiApJwiBOQK3RVYXHtliDZkhHkzw6LZcMWqS9sG64NnZXZWCcOtrDULnLyW4tlImpiXUV1SLs/Y03f86AaJuP0PoIYS8gzWLNHvAUlPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VezcU7/usf/P2gz28QoctXZiJW9x05+beUA8cfnfEUE=;
 b=TyPKXxG7FNxRY0XIJKm7Kxwl2puO0b5WRJTVk4XWl8tupcPRmkpbrYcX75IZViIOemi0E0W4/12vYIXhAuJdiUhTTpN9O5cxIhReG/LcEaa7mH1+HLd7ziediybLNZBRniuyXI7ifc02BPMruUFOyYTAQHSqN+kKhKNIl07EbSE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1316.namprd21.prod.outlook.com (2603:10b6:208:92::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.8; Fri, 2 Dec
 2022 03:32:13 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5901.008; Fri, 2 Dec 2022
 03:32:13 +0000
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
Subject: [Patch v4 05/13] init: Call mem_encrypt_init() after Hyper-V hypercall init is done
Date:   Thu,  1 Dec 2022 19:30:23 -0800
Message-Id: <1669951831-4180-6-git-send-email-mikelley@microsoft.com>
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
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|BL0PR2101MB1316:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b9fd4a8-525c-48cd-4eb1-08dad415cd93
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JVxET2OhyiDAEVPbyQP4isyXi6VFd+KFTzrDBWGzrsLYYlZBoR49D02Px9v9qsTqkFH7RgCXVG0AbE1vbTYoGOBvcJaWxZP4loe+vKel/JOF3bMdUKhdHlUSSJSo5WD1zY96hq1sj551oer0mIrR/6PxeYhD5No6l9A6R8yinijA7rNrb3zf7eAuWxX7RqgrjmTIMwY7BGMflqZm3vWDJTbA4iwornz9hKhgTqQbM7DnfOCIp0Mxld3Tq/BFM8YdwuYdHF+ZyO6f9kKTcNytLFdt8P5rBec8j4vG9FU0/WUKCE16M1zDUrDP4HgGCKeDha5eF1MoaOgTfb3K7BNf4cWJFp1I0IPvQiek6+uH6p7Q82dVgAuNfNLDsfZObt5C/Qr1SxgUjSPHwBu4A7m7Ff1YG3CgDie5miNHHk2dpX4g7/k8JKZ4boGbf1mixXq6FhgaBi2Gnnl8uJah7sgAeOqRBt7ld5Ad77tI1wGbyngedNyiBlVHuu+GdtlinqYTofTdWMDZ/FuSu5w8XBmPKyPZUHfPgiZS0USMcK+ssRPbGrjIuVqGMwm1GVOVITLI2rWSQBMMkybWEkLJ0936vKzFW4nv7zNunVxrVsyxP+mUTeRDRd8w4FauHFfMXmf3nJdvNTD13FNGM+99QLl0ctC7zo9f9+D722eWyuM5nRXxS5ofQt2w45PzGW+pCGqEpB50od/Hf7+dXGU6ENpM2KaxVhi9FTCKtEgfRiFQ9iE5mGmF0bZI1MzYVOJw0eYb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199015)(86362001)(921005)(41300700001)(36756003)(2616005)(186003)(8936002)(5660300002)(66476007)(66556008)(52116002)(66946007)(82960400001)(7406005)(8676002)(7416002)(6506007)(6666004)(107886003)(6486002)(316002)(478600001)(10290500003)(4326008)(6512007)(26005)(82950400001)(38100700002)(38350700002)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lcqtmS43Ol5ajoc5zpOaXU0mJoN15umyI1+IquMZ2QkEQNShy2jKChrdDMJd?=
 =?us-ascii?Q?FQyw/Qjqnv93n2gIL+bm0yMOFSipJkEZP6Dg5wBC4Pi4anW0P5XjRSQJ2giQ?=
 =?us-ascii?Q?mXoSi3py6mj5TqTeLj+zLVzrlc3UogsHreFoS5bK0DUDEOtmRRxmQJ6gYGnw?=
 =?us-ascii?Q?X6JtcmZQktnh+Spehs0C6GhFUYHRkhbTZSdHGAnyYFXkUvgu2VEBN6uJHjhW?=
 =?us-ascii?Q?hLhhcjsI6ZliuHiLBaaLFaZRIN3Q8GkvQEwlkjEwkai2RsEwuaR93YmKCBOa?=
 =?us-ascii?Q?MqvuNaAkRPManOqv6UUoSgeYK1sfQ5ZHrSttGe4mYIHrOM3GwzsezRiv9kNU?=
 =?us-ascii?Q?+uSgbMaPihgn3o3jYJX3jHXVYqNh2erkwX3oWHlr+ySUhqEVyTmY6e8Ex/Nc?=
 =?us-ascii?Q?J3ShbkILHDqB0t7zniS2yzqEq/NC8UnPqeEYteSyKB9gbBYjRd2UIfbZ4m/C?=
 =?us-ascii?Q?g2U7L/WnsgIWOjJOpFxRzMw0M9IIjkD48RZfSs9DiuDVsdAsORyO8JVX1Yis?=
 =?us-ascii?Q?rqS/iOC6ktmbRK/QMtXH+IcR/9gQirM0YzkCDowFiLLTVLsWWoQnKAsurFYW?=
 =?us-ascii?Q?aQct1BdTK4pnUWS3Tw9IpheNaxpF8mHXji0VNPdrxIyowagoqKqJcvCpbvRe?=
 =?us-ascii?Q?H9wf72cBH3wucD6kLDVz5Jht8OSCr0JMHJGs9pkF7ZZt3by+EBT3bxk5TH2B?=
 =?us-ascii?Q?pCpay8bDR3AwlhESfnEnJ8KRB7R/dj79NHkjsSUKhy+284KhsxNSjNQ7ufNl?=
 =?us-ascii?Q?Xtv1LfbxjGeTeptu4Ez39GkY7/JS5hDt2mRXdBZWD8So7R56TxAequd+Xqt3?=
 =?us-ascii?Q?i9i4I3mtoMckC+8xgdnrABi+T2Q9XOmu9IhqCU/tUpNyLKnV8jsW1fCKXNLR?=
 =?us-ascii?Q?fqOUqDNcAv/K+EgqbgkaYmvzAtihDK0QYXB+OUTJLJ0HvT4Wk5nuXsSZVRpx?=
 =?us-ascii?Q?jICI+MPj1jjEj96jbhSii8Yn8y6REXX0WWZhGDyWD170/k6tXrHp26j6wAr2?=
 =?us-ascii?Q?QPyvRnfZtx5azF7KEsY35o52lCLm2QRmuMG5HrkodSRCNw3xJxKRwP0sD7Vg?=
 =?us-ascii?Q?uA9zrcvEky2rMVjBoGqJP3yP7imYYXB/UyVa24CdjcGJpkSiFSkZQbQCPrv8?=
 =?us-ascii?Q?iZr3K48a9DsgQnzCJqndnharH1YVko9Ee7BNw9cXxhesA6dzc7LhU086OKeO?=
 =?us-ascii?Q?bGydm4J1lLYt4s+IrwU5QuiIfgyKDJ6F/N5fDlP42+3Z0hfWkl6dBFI5u477?=
 =?us-ascii?Q?6fLYf9NJC2DORnBaYBPBj6S059L/2lGGLIf5rOiX/hoghf3N5P+ixoPNTSM8?=
 =?us-ascii?Q?jxJpdR0WNqC4UzGXVaOoIon80W8oHQtuJaKieu6CEUn4biprEFmVvE+1Reh5?=
 =?us-ascii?Q?m1V4M3IlXWEvIaxBJbbFaZTZZvYX24+KYYaRapdw/ZMMYiu7cjICwmswmB6P?=
 =?us-ascii?Q?D3w4r8xPNOAKgQ7qCFHlolQlUJz+T4ID6m4cY75skGPqacBechn/IeTcOI7N?=
 =?us-ascii?Q?q4Oj2CyInQF7yq4LOCPq5IsDslky5GKLS9EbKETT37sC1/1n9jSUWmoutdAE?=
 =?us-ascii?Q?kjhahqVpUnjsczA4a+ZqJTIu4RI/cnq6FDoUxH0Gc/RIAxAE16qnrZ/d8asj?=
 =?us-ascii?Q?uw=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b9fd4a8-525c-48cd-4eb1-08dad415cd93
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 03:32:13.7521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dmLPB4x4Ax9gsQtHgdXs1REf4UegYvm8XUdOuP0hhE7z+mMNW3iHBrjq4iU8uMbJawqDh2YiN66dgL54bAO+fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1316
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Full Hyper-V initialization, including support for hypercalls, is done
as an apic_post_init callback via late_time_init().  mem_encrypt_init()
needs to make hypercalls when it marks swiotlb memory as decrypted.
But mem_encrypt_init() is currently called a few lines before
late_time_init(), so the hypercalls don't work.

Fix this by moving mem_encrypt_init() after late_time_init() and
related clock initializations. The intervening initializations don't
do any I/O that requires the swiotlb, so moving mem_encrypt_init()
slightly later has no impact.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 init/main.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/init/main.c b/init/main.c
index e1c3911..5a7c466 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1088,14 +1088,6 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
 	 */
 	locking_selftest();
 
-	/*
-	 * This needs to be called before any devices perform DMA
-	 * operations that might use the SWIOTLB bounce buffers. It will
-	 * mark the bounce buffers as decrypted so that their usage will
-	 * not cause "plain-text" data to be decrypted when accessed.
-	 */
-	mem_encrypt_init();
-
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (initrd_start && !initrd_below_start_ok &&
 	    page_to_pfn(virt_to_page((void *)initrd_start)) < min_low_pfn) {
@@ -1112,6 +1104,17 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
 		late_time_init();
 	sched_clock_init();
 	calibrate_delay();
+
+	/*
+	 * This needs to be called before any devices perform DMA
+	 * operations that might use the SWIOTLB bounce buffers. It will
+	 * mark the bounce buffers as decrypted so that their usage will
+	 * not cause "plain-text" data to be decrypted when accessed. It
+	 * must be called after late_time_init() so that Hyper-V x86/x64
+	 * hypercalls work when the SWIOTLB bounce buffers are decrypted.
+	 */
+	mem_encrypt_init();
+
 	pid_idr_init();
 	anon_vma_init();
 #ifdef CONFIG_X86
-- 
1.8.3.1

