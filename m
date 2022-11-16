Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9B662C7EA
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbiKPSna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234504AbiKPSmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:42:44 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022025.outbound.protection.outlook.com [40.93.200.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D866861755;
        Wed, 16 Nov 2022 10:42:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKgPU8nQ8fsXO2B2bSUjbxDgEluMAJvF0GuI/e+4F5jAOqnmQqc4EtgQBnY7+uO4bA0dd2gs6kSAp2opeg87UOD1vqwTMMfi9Vs9qqQTTy7aAcmow6BvZ/RtXRM93B76y4ImxrUyIGRzt9Ub+QdJ5Nwg46Vymq99W6d63r7BXect5uIp2+9zVqLpFq0Isuqz+9lWvGvRr/cTy29u0YnzTyqj2prlU7TqJCn1Ab+KakuibCmo+OdOSWjRwc942vQ435XzLHySO4HyvlrqGdXxSntgG5ltIpcg+WiVRQX8BsgNRBMkgYG0xp67tuvCTqIR/Q3TD5biUWsLrqLuL07FCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a+yUY1oU7EZvlInJkWwCVnIM5lY35B5anu5GgTI054E=;
 b=DxLJgVvoQ4IgGW6LttwEbuDXYyt7UDjsH4Z38rTgRO/ouQgOgk3SylyQEPaCvP8ZgA8f0aHB+aaWSwHp8nqzkfGZCGVKR1Wzc02zJhA/dwIwH7yTABQw3MIN9DxTgfbbXeeYIvnAhCds87P4VvNJ6+Z88Yex33070/3cxJlTf5sdC7/inRQ7Nzwt52eK+bL1zmpAVFfD+lKfOZN6Xo+pqRM5JsyS+cH6CfVhztmNWYwZXwnsLQPiQm5ObJ9yF/yub2sFzyG5yg+YqR3wgQxuDbPQ8blnCeeFVeQZWFZPkw2wh8LICnJdhGnArZKGA+GgRsPMwQOCdiPpQMnfpwlseQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a+yUY1oU7EZvlInJkWwCVnIM5lY35B5anu5GgTI054E=;
 b=LrqNuFRnpZP7Txjrjwmv2qR8AAKb16jH7GI4wfpAltD4JaprMimNILaagFWkJAQ8TtfNqkc4Tli284m69eEDVIwmISQRMEoNVgM0bIDh3m68FB2moPX2y9ZsMjYWYfJaRAlyyjbKBUIzZWCzgie5SSACtc4BUZu8pYYyQSqSoI0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by DM4PR21MB3130.namprd21.prod.outlook.com (2603:10b6:8:63::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.5; Wed, 16 Nov
 2022 18:42:30 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5857.005; Wed, 16 Nov 2022
 18:42:30 +0000
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
Subject: [Patch v3 04/14] Drivers: hv: Explicitly request decrypted in vmap_pfn() calls
Date:   Wed, 16 Nov 2022 10:41:27 -0800
Message-Id: <1668624097-14884-5-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9f4319e7-e54d-48a1-27fe-08dac802513c
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SmTLd8Ujf4b1B5T1ZdWkU3my2lXcFGd3k8PEvOXO4qvsWsKKAl+O4cg6zV2ilSJCgIqD5DOAE+Jf5cDQWmDCSl8NzaDyzTDnKSXWzjHn5mfbot8g1A5l/8p5nAF2eWQV46dFUeF8Tw6GtbMxZm0CgeshrOsV1mTf41Lx1fIMJhLyZJmvi4VUk4O4kmhQrdvWE1EKaeRDrKUUom5xtnjzOT9F5sjhV1Aovcm+yb8gPIfiW4moUmPc/79HwKy0sibERrT5DKIJyiTCZVQSJW8q5gCnRSHYq+bqlGgJY17WlAY0/XDn4PZvqceeo6ORO6Z6TzCYd++MBEVCRTXPRrbq9I6rtNKRmHDzPMu5QDQbEnu2S2ANAS0Ve3d//tt4Eq+fJi/+SIiGl08Tj7UvNMr2SWMW4eVLbyJy0FXtlIRaVIXWwLZfeGPKXtCCI8lKqFJbwkG4aox7cJc8UflUHwps+AraDrYvCYe2mRM+ZOGzMBRupVyttbCp62WzDPGfpSOrJ+MnXKcNwsHzGLmKQvkgI7Xd2G52/d2CrIt12v6B+j5jGyGkXlHvcAaZeeftFLTJAT86WJmV2yHppslB3ZSKl6PBKyeU66CnWqgoC7npngMuJwLWKMHJdSmm9JWqjc/3QqnflSWOwFLsVRAdcRutZBMo6oMS1YV3dTu4iAQJIZMHzyVDFB+iK2ZImDH/cHdzS9SwqDGW3sOXhsfMG/+JUwoklGq8UZPHye2MJRAwC9XgXu8PwzCRHZ0D6CsjLhmuurwuwTkvHvkW4tXVBoaTYt2lkvOeuyl+GO/Lj2C5UGNFO7R1yDTE3V+9DJoPM8Kj04C89Pvn7f0Dw44SMfqiwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199015)(4326008)(5660300002)(8676002)(8936002)(7406005)(7416002)(2906002)(66556008)(66946007)(66476007)(41300700001)(107886003)(82950400001)(52116002)(2616005)(6666004)(82960400001)(6512007)(26005)(36756003)(10290500003)(186003)(83380400001)(316002)(6486002)(478600001)(38100700002)(38350700002)(6506007)(86362001)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PG3MD3G8R3MGFvR9unUq6Va1L1iQIqQETT0NnX/ZOJp4+KSd/rfhHXzbasX2?=
 =?us-ascii?Q?yeIRfJ32Re5K70QtNZgxJlcfylrRCAW35dYgqMwvhY0if3KeRjQj40i9Upwx?=
 =?us-ascii?Q?tHP4uBlUmWd1tdXbXEwGCbrrUohrtD92ELPlk2F3ZGqxAqexzboe/mlb8sxv?=
 =?us-ascii?Q?83WARkrbpDn7BX1OGDneAX77zUn3Q46fexsZDGpvkB2W5sL/wK/4pM8cC/df?=
 =?us-ascii?Q?Sn8mENjrbBomkyJDPNavZNME/yNweU9Ub0qbLbcgih236mjAbJK7SYWCJf0h?=
 =?us-ascii?Q?TNxQUqJbhkB+I+NCE3+IkRd8mnlt5Zu1GE441F3whi6jiMt8pmGF4pGsrX82?=
 =?us-ascii?Q?g6rac2t0lpUn3Q7dROhdMQMMmGvMRgBA5J3pzK5Atw2wxC0FcVL1kFjygw+J?=
 =?us-ascii?Q?u64Q7mp4UcxpncVfzQpyG2sk8vtn34eCmZSbHeK4ukAe0GfP2bl6LPicHJrp?=
 =?us-ascii?Q?wwkTPCWvEMuG8K/1ukDnWlVeemIQt6foqG32ZXR2bQibh0u8ZfYYGdr1Leum?=
 =?us-ascii?Q?2d4aDLfotaszIB5kR9xeOagnEZcPhn2xYX6IlPKf6n0KCzjZ31BuNvUqAesT?=
 =?us-ascii?Q?4DoTNAsHP10PGLY+g1CgYS6yDVIxzMYWTosWu09TSuj/svS6EjoMneijczt4?=
 =?us-ascii?Q?9lCvWmV2prHGSez7JsdK11d+dd/8nP9GKFOyPVfjQZo5Ewcak0H7LYEN1KXa?=
 =?us-ascii?Q?somk8yWI8/p3mDVO1n4O9JKbEnGWZXdQEqqpgsJPOfkGrBGZR1FdvyygXoDz?=
 =?us-ascii?Q?IXtBC1RmovpZHSadjOCzT0JcJ+a3ktnEcIUNZM4+itlIGxUmI6fwhS4ShFsE?=
 =?us-ascii?Q?CDy5Zytx3FaWLszj4pWw+Fxw3t0+89tTpBEmSrRokvK8G9hgQoK2at9pGgHG?=
 =?us-ascii?Q?B46gWN3LKsjv+XaMFN8+BPnsOg+yF8zLES09KGrpj5tV87yOQt8+KiHhNcA+?=
 =?us-ascii?Q?kUUw/fkzaoueVCpjPgLKcx24UuB40jUo9dSVLVRU96FLPC6rxgTvTtJD6Wx9?=
 =?us-ascii?Q?SwR1BJ3qzeQ9NpSgFYOh4zpNi6/TF9RumV2+YDjcru2DqAMitkVxYa5bMEBV?=
 =?us-ascii?Q?IK9C3Ze4CCNfuEMka+CPe6KKw/g9z1ZEF3MfxLzLhznlc2BAkeXe0ztAf1aK?=
 =?us-ascii?Q?a2EKhTeJ+uod9p2YMowHRhtFUK5NhH7aLUdhgu9zAJbJl3CjF2rGjo0nP0R5?=
 =?us-ascii?Q?BC6DsCHrXp+UN+pbK1/WAxtENUjfdiETHQhXOTXsF1h/tuiqXg+um8ZEkNJb?=
 =?us-ascii?Q?XHz/AngM2UR6eEwpbJb8OElgu/KXcf7+8N3gtyQjVFfczfPo9KrtcFc3N51K?=
 =?us-ascii?Q?XgBWEK8GliyxtYcGupTeg5xcsBio5aWPOgUvF/tdGAaJhLn5/xqH7fs+G+E/?=
 =?us-ascii?Q?OxZSBeOberPL6yMSh8yhmNkeeDCeBTevLwAU37ME8OYj0kuwkXX9HN2IxGwV?=
 =?us-ascii?Q?7h6Xe9fZTNcmPGtlU/3B/KbKM7HGZ9dvC2+sprV6k72Jb9euP4ShtnnYlA0c?=
 =?us-ascii?Q?DjG/I9tz+LCeMUZDrB+KfNRHOlmtIkZwGcJ6DpW8BbjqRjpI+GMe1cgGqmCS?=
 =?us-ascii?Q?KP172Bk1AYtpnAObIAzI2UiZcBiMtxKpUic6/yiZ?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f4319e7-e54d-48a1-27fe-08dac802513c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 18:42:30.6451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iKLxOtXT+tO7L9c87+7uTujAbThWxkMQ2C7cIsfihItD5aF6+j8DboEr/Q1zQeN+QmUW++gFN0dxkV1PyvVXGw==
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

In preparation for a subsequent patch, update vmap_pfn() calls to
explicitly request that the mapping be for decrypted access to
the memory.  There's no change in functionality since the PFNs
passed to vmap_pfn() are above the shared_gpa_boundary, implicitly
producing a decrypted mapping. But explicitly requesting decrypted
allows the code to work before and after a subsequent patch
that will cause vmap_pfn() to mask the PFNs to being below the
shared_gpa_boundary. While another subsesquent patch removes the
vmap_pfn() calls entirely, this temporary tweak avoids the need
for a large patch that makes all the changes at once.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/hyperv/ivm.c    | 2 +-
 drivers/hv/ring_buffer.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index f33c67e..e8be4c2 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -343,7 +343,7 @@ void *hv_map_memory(void *addr, unsigned long size)
 		pfns[i] = vmalloc_to_pfn(addr + i * PAGE_SIZE) +
 			(ms_hyperv.shared_gpa_boundary >> PAGE_SHIFT);
 
-	vaddr = vmap_pfn(pfns, size / PAGE_SIZE, PAGE_KERNEL_IO);
+	vaddr = vmap_pfn(pfns, size / PAGE_SIZE, pgprot_decrypted(PAGE_KERNEL_NOENC));
 	kfree(pfns);
 
 	return vaddr;
diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 59a4aa8..b4a91b1 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -211,7 +211,7 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 
 		ring_info->ring_buffer = (struct hv_ring_buffer *)
 			vmap_pfn(pfns_wraparound, page_cnt * 2 - 1,
-				 PAGE_KERNEL);
+				 pgprot_decrypted(PAGE_KERNEL_NOENC));
 		kfree(pfns_wraparound);
 
 		if (!ring_info->ring_buffer)
-- 
1.8.3.1

