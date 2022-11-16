Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2BAA62C7F3
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbiKPSoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:44:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233895AbiKPSn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:43:26 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022025.outbound.protection.outlook.com [40.93.200.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A49B627D0;
        Wed, 16 Nov 2022 10:42:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XmXdOpued6dD138prVJYigkbWyRvwjvK54QsQAV501GcL7CVM2x1xmah+1MTZc28s7r6c3V2OUyBDZukn5jF1g0SYkeqA1UM41h4eWMsP2dpzSHp187mYBI7DC+CfIvkKhtvCuhQZlGqc0USuWruZKQEw0JPDQ40lkxGSXxH1mmCD/fr1tC7pLwQx2VeRT0IceNa6ozJtQjleLwrUhClzz0lXVRLk6Md/X9UATITTudMrhghn3/aHYnA6Uh2bM/2OVr74Ux+O7iG1wA9Q6MPwm25U6mm2hF3/aXa3YWmGctSh/GjGge1e0+17LoWHANCuPVMHjqXmuuNv+tBNkCp3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TAJjZIeLGBziRMUt8JU3NW/gfbVay1UmgHRMzXLEb+A=;
 b=ONi/HGLa9eZzLAT1vF5WTQGf7G1Z3fuhyjtLUKOe1SkIkJoN8ZEC0iX5qL3g1gTOD4JPMbisx6TvzHfU736NKGrE2a6IF4teyaxw4t83utSQBaCWaM5pOPI9wwqksKBzw/O53aBVrbInavKFYjf3V40LtXWBHUb/8YPGOBCZVIqGu3/bZKFbAZqaADC90Z4r154PdNn4/0OkLw3GJK1pwblAN+dcj6wEyyz08+poxR/ni8aklDx8IP3UTFMgAcZDvN4BGsxBxzkK45CBHx9JDUBI8Ddn26rC6nVeKjlGBjXYNoT4iCzaBhP/SBjG4QKD0JqgWuFP91K63hKL4vOuDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TAJjZIeLGBziRMUt8JU3NW/gfbVay1UmgHRMzXLEb+A=;
 b=UJuV396GjJG6ZcmQvMSvnfU5cEeG7oquPubph/e/0kmpGuF4zoDTyBLHUnETLv57b2/Iq3mmYTTaVpB73u+1znnDZ0ZNe2IVMGkFSarnoWf4k0HAftPh3YBan6EgpnVVjF9p6jYgdIjw5lrRAd3+l6DXsXLf5IGGB8tWDyqvuwI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by DM4PR21MB3130.namprd21.prod.outlook.com (2603:10b6:8:63::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.5; Wed, 16 Nov
 2022 18:42:35 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5857.005; Wed, 16 Nov 2022
 18:42:35 +0000
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
Subject: [Patch v3 06/14] init: Call mem_encrypt_init() after Hyper-V hypercall init is done
Date:   Wed, 16 Nov 2022 10:41:29 -0800
Message-Id: <1668624097-14884-7-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7d65217e-3b9c-4acf-ed5e-08dac80253ea
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yNVIrArlO3bLsiM9KXIdg13lyAFEiSP5Fe0Ss72NBAxSYPeafJg3N7xbKtoBWkynsVDdoEQqIVq/tHK38+QEqPJxzUjISllRQDIQlu7ggH0NmaStloBRBC5qg2PnyJd6Nq9hrbk2MrhWhqw0lGfkXM58bIubi5J5yF/mSHm9KU5mSjl7LVo4/w/kIdDKEi1CtWicrNJV/5qjt+9eU0G2J1bOc/Y+75tFkrN06sZBngIgu7WiapAwH20MYFEV/a3i/eMlkZIq5Jgds5tS2Qj2KEIxHA3ppFIX/rCRR2QSLorWhe5Ufvg4ahyBHuBYl+4ZrAvl13pWEwhs0ZcVS9AZ1g+cw5suQtYz6PyBP6z5b/+cr50XPrWmspfIgZPvQ3D//0Oy24uLOfIrqkWDn2I8B8APq7gX8LBEsT4LgHVApWy2zZGn9gsPiix0sLicHC4e/eenYb+N5z/WFsItlq+3dgN+w5foffbqS4uinWZykVt7axeFdnZrcsZu4dLXqDyX5B1qUKJVKQilzHUTyNsQQeVhaHUTnx2YdNanmd7hjoJLmxYSWEwq/CvaIucv6skzM2Zqtj7qFBaF+GqoxbgSmkFhBauwe5Pf9repqOY6RWzF28w399KCV3Yg3nCxWP4b/+s9HUCtJFTbfc4h4qVjVeFVtlqOINZNpxHmbtncjMhUwEk7lEUwqIVXbwstjNon3HuehFBWa/VoKu5GEiUG+jTG1WGfb1k18FGG0g9wUrD6ERnJxU8gPvxTOC6XzuYlS2crA9UOmKffjCuOYv6mKQYMdXSdnRIDsyyjleYhg6nKVYVh+KpMkRpWlzM7P5KfzmjwPEM1dwEMi8ItNlWnNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199015)(4326008)(5660300002)(8676002)(8936002)(7406005)(7416002)(2906002)(66556008)(66946007)(66476007)(41300700001)(107886003)(82950400001)(52116002)(2616005)(6666004)(82960400001)(6512007)(26005)(36756003)(10290500003)(186003)(83380400001)(316002)(6486002)(478600001)(38100700002)(38350700002)(6506007)(86362001)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nk5RYgeWZErILh2AybHj1Rh5e/rN+6JU+8bBV7DBQWrEIwT9GPM7/sVl4kvz?=
 =?us-ascii?Q?NcUyu3Ar9lgj//OcHKnrMOfHpNPIXR7WXp3aH+DEpI+nM0uQ6nLtPzjit/JJ?=
 =?us-ascii?Q?mYtgMHYNYgN5m7UrFvskqX72GrI+OU1t8cNcEQkpg9m9ihAUBkNFJQE2fDPa?=
 =?us-ascii?Q?PlcuN4ZiyB1t2uYSMVt/GxPOepA8JjCXNhumMpNIk3xj3eWMpocGUGUSkch9?=
 =?us-ascii?Q?02GUTNEIB6s3O3EaPfggXKFfvaPe76IsHAYDhSxnuDMivSeXd7iEhvwxVo4z?=
 =?us-ascii?Q?/U34HV4k4L42GBMP5h7cInq6SJ7OO2zPeSK/LH4frz4p2qdgXjAjzhpsACK4?=
 =?us-ascii?Q?kU4ZnWcmnIO8c+6o6U1QyDsSvHaXaGfjqdA0vp7HsCYgNJBh6gHdcfw4PKcS?=
 =?us-ascii?Q?s999YZB9k+CfyUvktghBSjNuyAQitPKVDxDZFecP7BY8+GUsDB1+ISLrmuPD?=
 =?us-ascii?Q?a9s7/h7OqxUAnTb9uk7anQm6F2LVtGlxXlTFUbdOts5xySNiCGKse/cA2ExV?=
 =?us-ascii?Q?vqAbh/3e+zirBlvHjCpTl6JVejlH824QezcjWdzK8yFkaoWIPPd32QHSdiTD?=
 =?us-ascii?Q?kQ25FS7jlkbZu0fMxAJ7XXH0G2enQc84qk+1VJdQJsxRQXzniQ8jGWAgtFhS?=
 =?us-ascii?Q?l05ljTGnq7mj0gz3eR0l2+rrIh/L1qQ7KxbdueMLgTjOwEXdwwVeesPyuNHB?=
 =?us-ascii?Q?cUjRjDi5wve/8q47EcU55dRXHMM5z/dbyfi4m6m9UyRH6r0RLvBXdDUdOqW7?=
 =?us-ascii?Q?uyzjCSfVHvK7eaXNUwVCwYdOGWth8/B/s/riSbThEShM+Ce+mZfqCDP884rj?=
 =?us-ascii?Q?79GyN6YNdNzLTPvpCBS7J55D9nKiFfOgyY5hu92gYk8f8J/rO9Wx3idpHCoc?=
 =?us-ascii?Q?u928ccgzAE8MWaGKlgInSg3pMaib3YtNEtQaaaJGcofzzHfMHk+9xeHgBqeS?=
 =?us-ascii?Q?HNI8MXAw7/LCRmys2OuuzCRTbGZU5655QiChUBuSiA2wtZH5thIgeIu0NxQN?=
 =?us-ascii?Q?kT2JtJXWbJGvS1rMYInqKG8Kgu2h8HeJCg2RNn+p7XFkyJCbDJ/H4tKIIqc4?=
 =?us-ascii?Q?jFgVnm4eFwOhSr1t1lvVWII1NRSaTpNj3ncbGutxOqNksKf7esx0RlHifUhC?=
 =?us-ascii?Q?VjtafuMRNrpPsyy4o0rYBy40Od5MaHyTyBaaXb0fsB8W2BcrHqlZIySLZX3l?=
 =?us-ascii?Q?+e6rz6XX0W/AEh86/DKf/zN3oAxW8uXP4WtnqRmW2GyZ+lTllcqZRV668YJW?=
 =?us-ascii?Q?ew0I7y3XX9/3OWl/PkY6GFQuNFz74reOZeWD9xbklSZqAhGmBVSPhcmkN+LP?=
 =?us-ascii?Q?5wIjOlQBNQgSv0fYPhlR2sccf2j0eoG6hb3yK25f5YvY0Zx8BdmhGhXP2n0X?=
 =?us-ascii?Q?zI4ZMZlAdN+y31ClQJ0PFVS6yLtCMIw1s+SIAcl95wJKSHPcmQ7VgbmiFiyq?=
 =?us-ascii?Q?8DZVrHK/KS8KYQ2mUDBkpn+l1ECs2IfE0Wi9sGn/4LBmhQSG122SVovuP8ZE?=
 =?us-ascii?Q?zvVeZwbWRBRtX36hVt8qI63xOikOzU4j1sqdOUdOeZayiQbSvkI6r3Hww4jS?=
 =?us-ascii?Q?X4AdNJrlxDBNCc2+scc7kc+5F837yc6Poyv2EX54?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d65217e-3b9c-4acf-ed5e-08dac80253ea
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 18:42:35.1616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ErtvxZYDyOQqshIpRpxKPnsDGyE5rgAYy9ybuoWfE6uY5NGDq5PmL3PHyGZtKOAQLLWPQb6lwCfWFS1VKdm7w==
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

