Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67F263FEE4
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 04:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbiLBDdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 22:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbiLBDce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 22:32:34 -0500
Received: from CY4PR02CU007-vft-obe.outbound.protection.outlook.com (mail-westcentralusazon11021020.outbound.protection.outlook.com [40.93.199.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB86CDA21B;
        Thu,  1 Dec 2022 19:32:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eup+UgVEn5ii3ebb1/kzyPOGNIIkCvJ8QYGKUyr13fbQVDP73CeQGKuLaRP2luWnJivdyrLTHNbO1wxjb4j8sKOmIVJGMsx4+OBJW9kK+O9wadiDi8LoRHoVxsJlkco2q6a8NHHcWFBEMsTMvsC7g++aLe5J6cPn6dfSKdmq7wRJuC/3ZpBGXVBpFd0L8hNPkhbS10C0QUY6eRsR8BCOJmhTMVifewXXzGJxkgHLfKnDm/exJ73vQ3ugkRlidsAHxQPlEuKMQqGztOpurpVnqCarxybchpl158ml8LIJSry9RKd+qv6vS/k1kdU+snPMSgmfJGc1u0KCIe6nLP6wLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DPzeS3vuc5jrpXr50Jyf5rW/rJkXmca3k54eyBANkUc=;
 b=ItNKaBljjceQYXbdfcraEzpn8sCJDeOGtGe0wPdH8izkKClyRvb5Sc4/7zvl1sGifJConukCYKxwo4ApqOrM1RsnI2mY76NgDuAYL1MCo92NQupShhZ4OWUbK/7M/EDA17vak1FNQl2tem6TuJQufMdayUJwEConrKF7vFpFe3UZEw3QE8imQl5LBqxgP4bUrP/ik/TGFGEw2PFARxj/UjBXo+4749MAzVR4JKYYLT1ZI7/KzDHkILlAS0jDv1oPCmxcIN+SnIsF48J7CuRKDxpBXUWxvGCOEoHdIkReA+x0xUIAaVZHZ23SgxiGN95hH1EuKXxg2iKFzFvnWc+6PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DPzeS3vuc5jrpXr50Jyf5rW/rJkXmca3k54eyBANkUc=;
 b=YUw5vkBcWDALOJK4Muldv7vvpEK8vwBgCUeMZZz7f2ynVzsCCa0Br4uV63gP/fvH8YKodI8tUw1uj1zcjAobUGQjov7mq1Qz6emq2u3GKCq4meDdy6J73X8Vi0pe944rVP0vQNPHVu+/4+Prqjdtx7sQAhQXNLRhtsqLnIakPvM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1316.namprd21.prod.outlook.com (2603:10b6:208:92::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.8; Fri, 2 Dec
 2022 03:32:09 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5901.008; Fri, 2 Dec 2022
 03:32:09 +0000
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
Subject: [Patch v4 03/13] Drivers: hv: Explicitly request decrypted in vmap_pfn() calls
Date:   Thu,  1 Dec 2022 19:30:21 -0800
Message-Id: <1669951831-4180-4-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: e6bf6661-c1ee-413b-67d3-08dad415caf7
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A8LVF7SjF2oBU285AIvLRLOewZ+1PRTkolYBtH/b239WSUfqH7kSg1Nv93Kr3upWoeWpDg/S0RyJDUVyILaGLnOhfOSJAYvjWCuRukoIFKRlovaATK0pSuJWAmd42xCqhcKPThTNrlzoOKJTRbx9pOmrOetdTTCIpvVDOmRU+O0ryDXgToyphpLX92cZ+goucV4bcCXrkcXOGAK70K5oLfN/5DdAHVuM0Bm/AG86kAwzbRdhlZL32F0aEwRO/PfnMmttOHzWvMeuS7sgnQUIrwSdHT/k25qOVKtjrgRfrrdfKts0AsAhP0sKlUiLedUzY9fDc6NrUFJ9gpEfIUKtZ7C5MSvXxN7mBdy1NWvkAHH3RrA9ZckgUVBwK0Z0L1Y0n/KR2R0AQs/rBTN1hQtvy8YUZhrMhJ8YzYmqAVuAV04RCTHNelOxvwN5Gex6DNbZOY4X1qUqbm3J8a9Vz/8nAG7HjwCuQCzZJBEh682Ykjq4Yf69a/v6jtZfTiMhKF8PEP5tg7QHgrJVLwb0iJWAf697zkyW4O7+r8ftWRg8Cerv1H/SbTpjAGZiNfDvOVp5LodyygbTdeZD+Y7pnLf7XQaiKKYoEQUl3hqAsyHmjmnP/v/urlKQ9NuE/tQeyqPYMvPKMFO3WqxhDECfOi9bSBCvGSgYlCJGnH8IS7O2zwaMPnKfmMu08RFRYPkMH8VIO+uLHqbemg7PnSCL6tiEgx5zqo8WUXxXO0UrEsU5Vsoz8dVJrj+ajK0ZHq5S5ptN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199015)(86362001)(921005)(41300700001)(36756003)(2616005)(186003)(8936002)(5660300002)(66476007)(66556008)(52116002)(66946007)(82960400001)(7406005)(8676002)(7416002)(6506007)(6666004)(107886003)(6486002)(316002)(478600001)(10290500003)(4326008)(6512007)(26005)(82950400001)(38100700002)(38350700002)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BHxpQDi1MeWxxnA4r5KnOdRMnXDy48AnUoUarlXTajVcq8ngIEQVgcmXSNPi?=
 =?us-ascii?Q?FdWzvP/e4gUm4mQ2sTpKjf7chjGt3/kBSI88KLh3ldVi9Yhc88NdhgZ6nGcd?=
 =?us-ascii?Q?og/M5KRR7zcpnF/hNEP5AD3uhYXoVQOGVNkWG3EhXV9ERVydxEzeo02R4vef?=
 =?us-ascii?Q?w44bqsH9t1qE+PXSxd1JD9nUxGiNLa+oEMoPM9V+JplGvotojaqW1eJKNVzv?=
 =?us-ascii?Q?2Wm2KxoHD0NOHYL5D3y33wZFbVIuD/huylrFNtcEvCWwjSV5HmXLz/UTDAvP?=
 =?us-ascii?Q?96D9tux4XzNri2hkNzZ10uuxAZjRnOXUlRMhvUaGbvGfmqPrxh+6Kg6ADbTo?=
 =?us-ascii?Q?aRP8+C5pwOUyeGO6hpXz2N1quh7JngRxcksZyqo119wR/E/RpssauZiOpcmv?=
 =?us-ascii?Q?bW96hMRDVrww7Xw8gCB7j493W/gsb8Nz6MNox1u9l/r06bBHU32VF0nmOvt5?=
 =?us-ascii?Q?Av8sG7Zdz2z6ftz6CsoFfdmh9A2Rs8A+JNgSzGTS0m8EAIh/2T7d8GPmSi6M?=
 =?us-ascii?Q?Y3GT0aHCjH9MwLL1Is0o/E1YNfxZLZP9USqXOEF9XzS1oTd4x+TDyqMYuusu?=
 =?us-ascii?Q?xl1b8LZ+TnX4gxvRopiDmtmR3XVkc0bqQlCUgpncb3RgHEZ/ipXaA4ylG1rl?=
 =?us-ascii?Q?CAhgyj7C4bniHSD/qYUdKNCaPSNu/tiZb1NwX+2D8zJ4DB7aAPp5Faessr4Z?=
 =?us-ascii?Q?trI7keojKKYI10BjMWybJb39Bi0VfOQGo5aFtn1iKMlKwBG/r7edETBlIU1f?=
 =?us-ascii?Q?vFZlH3g2YfJim27BVtA3nJ9zxRz3MwmXwjZOI78kLkTtSNsGbZKVgnZb525P?=
 =?us-ascii?Q?K2IPgXJl8krrMt6BnB3fEihuGwLyhE58yMqiCa2PmUdy7xhVdFPElBi4h9qo?=
 =?us-ascii?Q?hqIShVGN0fFkE3PqqNuGBM/uFtnOVqOEabhlRsCauFuTu2t56ETBIsRSxVZP?=
 =?us-ascii?Q?MmIR53XId34hVFXcy0Bg7eIdhqhRSAA+0WyKyt1oaFRZzJWKuGsyYI3aq07D?=
 =?us-ascii?Q?jltYxHbCvonJUrz0ULGXhvNWjUox650qtm1Rc0WXQC9aunkg+pMdKM4MGxpu?=
 =?us-ascii?Q?+3Rl4azseyRjBdMgN5TWnfbXnXbDH9qzd4bqWpR6uNzWyr126WfbGmNDfTRC?=
 =?us-ascii?Q?ojavpbimHaj3bklQZ/Pp7cL9zpvNUcVf2SJnxuyaD2lmOSjPKWyueAdAOtGx?=
 =?us-ascii?Q?LjHfhV1K8oqtRcU/0oG2ZyxMs5ygY0NSuQtUrbJCKZVqxtJRHuppP+f3UdJ+?=
 =?us-ascii?Q?5Adshmp3BLrTcIYF+b7IBFsW94FJqKiFKSHpRKaVEmIuklSQsmutKbPP2d46?=
 =?us-ascii?Q?RAKzjpa4lhOQr3tsjNkcN0aJZvLoQR+UNrOle2aZiolMwaXqe8zoUEMk7uFp?=
 =?us-ascii?Q?MWP75vyUScKwkeHj0E+BcfRGNuDFmO0WozikUYb6RR2YkpxRHafssfHHRZae?=
 =?us-ascii?Q?vypBATX1tS+uyNCN2lDXXfes75P/lMGk8JE+2QQGh8QoCDXdqR464kwsiGUq?=
 =?us-ascii?Q?hlikiBgLhSFWgVb3a64L9qWP4DbfYOlv3ifM29XQ9oDh0MQTkhqHMez/26XN?=
 =?us-ascii?Q?XIfxOtQ3QzhVs417k7rO2ECSfNAO6IsRhm1gNb4tpd9up6MIPm/MpBJbym5F?=
 =?us-ascii?Q?Xg=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6bf6661-c1ee-413b-67d3-08dad415caf7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 03:32:09.3772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bq/CTvNjQr3KyMXDGsIYBapFjYbmeXQakSTbsmehANQ2SjkyHM7/Zxnp3xpKAwy2yzIMJLkoFksYiSZHHrVLLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1316
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
index c6692fd..57667b29 100644
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

