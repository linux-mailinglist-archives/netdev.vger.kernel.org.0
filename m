Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D411E668600
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 22:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbjALVtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 16:49:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240949AbjALVsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 16:48:40 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021015.outbound.protection.outlook.com [52.101.62.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23C8B42;
        Thu, 12 Jan 2023 13:43:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BXLiThsE49Ob4Sw51vvlrnTJL67fompncRrtd2IWVs0/GgUwYi7l2ASGitkxbRaGr3wgQggLf47vt8Tih+OdlD46GidwPsWjfvMTWYz9IoI/pEt9wArfswpKFuIevuRwZxRE/tQvMIZVYvza4AHkHPCTMvMHVWRHlI8hOJzhyXdPzyEQ11TaTod6wfY/VABVYrhjcg1K0kOEcmfJ3cYCwq9rMwXmiYgamFaobLXcHC9HSX5BMjftWqEsFjkKHATozYL6X9DUgNdxWmm8NwwfgHjsKXSi6kShHnQ0oadWqzFjd+fA0P/2csovpO03I1N+ybhEmh7Y+GGGR1xjDxa+OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VezcU7/usf/P2gz28QoctXZiJW9x05+beUA8cfnfEUE=;
 b=BMvDsBQdevK1/gN8KS6179jZhqjwpJIKZMDLc2D08D+p79z+EGzHZyxaCV7f30greIT/92zqaAn/HIgdyqQZ/rXVCJ6PS3O6UGdVJCkMQ67K8qZ+lAWwyOvellIorTvkYeNdhwTWjYvjo1j9nsnNrYYFQHxGNGVE1pe2A6azCtKiPiMt1OezrhdH8UVaxCavY0pOejSuU/bBOQvuvYMd6XlZQteIGmhBolchfibxpYKGJGmziiyHSRnNhYoCrL28ahhwXZizmbqM/BrgbGr1Hx01DIWOhw9YmsYawdqFboNUV2vRw1TH+AEFNLRGaWciIicu8ZuwLWtXMlR08giaJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VezcU7/usf/P2gz28QoctXZiJW9x05+beUA8cfnfEUE=;
 b=f9SpmWeteCFfzh1eSWFXfVOM0x39JthsBepXn1y80TNObvwAokB30xpRXlTIk7w3U9B7Eb9b78HF+jRzXJpodwAXVoX17DY0PIeXyu21/ucX3mgh9DA3E5YDPt83foRAcjkRrKGCABOUyrSB6uiIvTtKL+ZSfvYeszXUkab4GJA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1953.namprd21.prod.outlook.com (2603:10b6:303:74::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.4; Thu, 12 Jan
 2023 21:43:07 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7%8]) with mapi id 15.20.6023.006; Thu, 12 Jan 2023
 21:43:07 +0000
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
Subject: [PATCH v5 05/14] init: Call mem_encrypt_init() after Hyper-V hypercall init is done
Date:   Thu, 12 Jan 2023 13:42:24 -0800
Message-Id: <1673559753-94403-6-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1673559753-94403-1-git-send-email-mikelley@microsoft.com>
References: <1673559753-94403-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0057.namprd04.prod.outlook.com
 (2603:10b6:303:6a::32) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|MW4PR21MB1953:EE_
X-MS-Office365-Filtering-Correlation-Id: a2946810-864f-4db1-03fa-08daf4e5fdb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oQdjp5Prs1sTDQ4ddPHzuG6+inHiS/T7RaiEP8sXx9cx9xDPIvawpQblsMX/v9trIRDBAOT7uMmtNLPlx9RHTxM7RHETcbrquRLRMvUYAvsrsl5QpdpRlLp+wDm542HkFzwwrlyHrGnvjuDn0I6FMBKJQWv1AGw5yZscdI6X/iGD4sebDCNhrK64+1Sv2MDfJhaYzqddtwXHVK2Jqh7+EMQ+B0EYXnFE8S4ulbM4qRhVo8Ex8wWTVYq4nIBf4QfMMj+b49qZhR0MGxXdX1fTq2qi8X/JQDTgIKQGVm5dGFHDx5fMHc1vERDUlFQ7vwSfJnjhuQZCjnU33N9NLB+sbatCVspudE/RJS1Wq8QfKxZEEfLi0PlD27R2ZQeENJplXHoaifmwazvHpy300dUnMf8+PEhGMQm3yMezQUtKhpwZ3TLIe0MBBlPL232cN40j4EIa7bPdcgSHElPOxSANXWcj4IDbW98sf9ysrg/Lic6hspG/I7x4WwMTx98jJbnHMVKdoF2pOhosX1oxt2rZj3tpvou5+f/XW+V4H53kzr42YW/4buOmacNWSCfJQBi9pdpX3d9elMMGviQYyIR0CvG/GTuw/cSsxwAXTQuc7YdUg2OAb3DHXfyNOYjJPTfcUs4jrAoY3768eyXA+0ipsRZm6mroOn6XkDiZU3iOXcs98325AaaVsVFNPfWkI031/ymPpG/jlxF6uEk/QJShM92bQ/UagbUKuY0afCLdQpyRbf/4TBAe5R8sN2IZhE5O5MgKlKXUCexGY82czu/UCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199015)(186003)(26005)(6512007)(82960400001)(82950400001)(6486002)(86362001)(52116002)(478600001)(2906002)(5660300002)(4326008)(8676002)(38350700002)(66556008)(66476007)(316002)(7406005)(38100700002)(10290500003)(41300700001)(921005)(36756003)(66946007)(7416002)(2616005)(8936002)(6506007)(6666004)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z9DvJmHw5Lp8gCuGcH7PIUbadftp6PVFf83fnsUaN2FlpqNMM+g3BAJGcrZc?=
 =?us-ascii?Q?MEw1m4P3ub5I1Ljcff96U9KO1iuQjd4VchlKSOtZ3k3W2QmkXb1dfTpM4OZS?=
 =?us-ascii?Q?TZ4qaUiikiduX95oxBEK7QHGPda5NxmW0JiIu85aT1t6Q5Yi7+g5/I4rvrZ+?=
 =?us-ascii?Q?J1LP3oAJvg6YLSYKnBeutWITnEy381dJv15VutJcfo1VI3mELIGwxumx6j7Y?=
 =?us-ascii?Q?tOjVO8bPMm6gQ7TJydAG4xx45xJ1CwykouOs4gLvcNwABuT1vlhSy4uVS6tb?=
 =?us-ascii?Q?pAc8QBj7MaxjvGt15ioNdc4uTGktdgZFiH77rZ/dCrEM8trE8F4ttHBl96wQ?=
 =?us-ascii?Q?2TodNNivFgsHu+4YOrxbINeI332KOBEM+p2ntLWwDpzStAwxG8UoDRadGeSv?=
 =?us-ascii?Q?/7rCsKNCH2PLWoY0g2APOunRZvn8fiCgeyvmtVPBK8YaEaMTHFlS7SYye8UL?=
 =?us-ascii?Q?VL8BNI6xTcGbfzMKe6fj+Xpeay3qG9XsLT6GEgTgE3SduuRW8kqvwTpcDpl3?=
 =?us-ascii?Q?RdAasuHO3+CFKpCT8QTww7yjtSpZCvSJ39LruDjK9MMC2Y2DM9a2Qw5wpjQb?=
 =?us-ascii?Q?6YRo34prwa0XjCNSJ4Yt7Mkr5Q7Ki0GxYSXkiaICasnNIlQMAnFJXRTdj5fk?=
 =?us-ascii?Q?SOk0pILp9oUIzQoimaf2Dn8Y57Kwp0OGEFs851bNMzau3AHXwS52DT0OCDDz?=
 =?us-ascii?Q?fHTAtfc1+tr4HVZGa8xWfH8hSp7oy+E3FmFEcaU7tq5yohqccNXkMRQjJdhu?=
 =?us-ascii?Q?qPVh9cQrM/6o3vfKCLMhygGo1sKzDjUT4U8wzvXhPmagbd/nPU4FFDZFAmeT?=
 =?us-ascii?Q?vbztTn2pQeJ40etAQfTLdywlyx42GnkzFW5y2VPGSbgJt7TiUDn6Co6130th?=
 =?us-ascii?Q?xnfyBNbtod2vX2FaLjKjwd2QmkZxXT1c7/cwNwiiUmKryzXXmooSbJEsTqs2?=
 =?us-ascii?Q?RwtLpzKieMvj3p8RXzqSEgtY/Nkf1EZO/qOmwFB6oMOJPRPnAfiB8Sd9Ls0d?=
 =?us-ascii?Q?1aokX2BEydd1/8fXkzM62V8hO/gWeQYlmGJtJG6Yie1sOfdJ8HfMRa5eKtfK?=
 =?us-ascii?Q?HYSqaVVi84/A9YzWwru8TZdA7OSX4W59UWJktm2j+DBaFwQR+obIA1JKHvr8?=
 =?us-ascii?Q?hMv3NahLBi/MiVU+JEGW8QIX1USPBqmqLgxXQ6h3pxXfr/IEbhwJzLQUvl9a?=
 =?us-ascii?Q?nMpJs+2PGncNHpwJ5Jov5Eg5BuaaibOIn4061i2O3zZtfu7MERytnTWsfXe7?=
 =?us-ascii?Q?Q5AZB54FdIVz2cSFSdGwkaxoXPUwYg+DbEgtu4zXtPD0s81k6e0jnpOp24E8?=
 =?us-ascii?Q?VReyQYsZA5XIrQkXyW5ATF9F3LuZO4Z/7Hm/Gn5el8saFMmdFj+p523bIzXr?=
 =?us-ascii?Q?9NgcOT1q47hqR0GqUqPbLqgZo0RFZyz1gDuWlu+FnLMHxxXajw7A26OJ7c24?=
 =?us-ascii?Q?iSeD1+eH6ncYhI21EKE5XE8U4eW1WQzZf+YlYpAgSZfS886ajDdUsroFC0cC?=
 =?us-ascii?Q?zvb0j25HO6MaHAm5xiR38Rf+0YGWEv7YP/wWQP48/HL+MDhBHZ9nLdgWXfzn?=
 =?us-ascii?Q?oR5FTLPRPCLgXQPJEJOYWzzRVPw75cr37zhO10Gu?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2946810-864f-4db1-03fa-08daf4e5fdb0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 21:43:06.8611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MbkltPDjB9OC3jb9+Ko8lDIpv7j3P4ODfpRbDSPelO0S+W+IRDE/K+eVjTz8IdqXQyxVEhlID7nhwpg6MMZb3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1953
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

