Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA1263FF06
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 04:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbiLBDeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 22:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbiLBDdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 22:33:17 -0500
Received: from CY4PR02CU007-vft-obe.outbound.protection.outlook.com (mail-westcentralusazon11021023.outbound.protection.outlook.com [40.93.199.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6EC2AD8;
        Thu,  1 Dec 2022 19:32:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EeUV7OLK2KWPBh5NuVpoExZnmy+fDZK48PlFBTwed7oKWEJza5L5G5i4vujeZ2x4kRYxNnAljNfopSkutS2Qis4GoFjDOLcbLrIlz+NdLzi0N4Z0EGyu4+a/hxnBHa29p7nwb1YNuFarR+E+KBi9xIlkT/XHklRYRdF5xenID+KGeGkMakIVtUJ8hL0vGmTQfU4Bc977g/MDepkm6+XZ5Vfa7GHZGHU3QBgnfxflxFvm4swYnxtDWG+jvdyZaY7Tb5IGxOFJTbwitVTv3VfUKzedqLBrdC0d0mn/3b6v9oMhY8AL8HuDVIjYlNwK+2rYRKLrf93V3FqVlGX+S7rAmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2BgK/x2W5lMaNW4JFyzo6Zk/DXGfuC968f19LbsR/ig=;
 b=lL6PzcQDyIyJMIx8vVQJipLGA8Gep40wRXGgyoJ0Sv81DD9xK8gHcP89PRjjw3a6s17C14EEqu0OhfTc1s6tRWm2IsWOJVHA2IF3sMmgOyxInHPUcdLoc+F/mHdRmkc+ZDQpFD9HS9bHghx/71F0ipBYCzkYOQUGA9Qe1XuUjmIFeE0SxAb7JPbZy5SA/tHuwTC8xmUu6zjQA+7jcTEI+sHR40ZCrBJOBqqdNEyWCnqQGk4S4rRkPsL9C9H69F6W18ZoYjeUWg1wuK2rC6dUBid3nqhffKwnZiX15EaUJXk5VhH/ok6VqaPve/hPK0454fs/KVnq4WAWMRs64C/yxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2BgK/x2W5lMaNW4JFyzo6Zk/DXGfuC968f19LbsR/ig=;
 b=YEn9SdBTHrIjGdLVOnXWN/elE4is/e/NmqVCY5FfVtD/2pxeTggkN0ZYZDk1T4VQSqhnbA6YfhpoHJHZKfGKbkDVaLOIqV4CMo4USzbGWgcl2L6GEidDK8/l++7iyCaXltROEPzyEbPi7S7paB3NN5MsOx4t2AaWH83YrjEW7mM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1316.namprd21.prod.outlook.com (2603:10b6:208:92::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.8; Fri, 2 Dec
 2022 03:32:22 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5901.008; Fri, 2 Dec 2022
 03:32:22 +0000
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
Subject: [Patch v4 09/13] Drivers: hv: vmbus: Remove second way of mapping ring buffers
Date:   Thu,  1 Dec 2022 19:30:27 -0800
Message-Id: <1669951831-4180-10-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8ae30e38-577c-400a-3519-08dad415d2c8
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zp5lXaRrWIjBPf4S/lqjOxGu/uxqEiA9YvKWFLinOoqZznT8vOfEspq58IAeO4w3IP+z3NuOZFTd4PRUmUn6xrAt6QB9lYII3WMgQ0zeqE/s9f/km5FgmPTPDaa105i+FNJfx0wifN5tP+6Hh+utRX/kLhcUv2/DOiJHAI3M31a1aeVp4bLdWTObNSAobHqDkFTXb6Y18+pqqO+7kKLYJ0Wu9UrfP4RcxRbh3yErazTJy2QzIUTF3KCioQbJGOIGW8Mp9NkfjFUc2fXtxgbb5Qf2QUiNlTlEs4Lnl++2khY5lc6mT0MBawNicP2L+DX9HIOrYHUZqpCFdODgbGPCtRdDa8CA/1dxYL9JBa/ydkX7WWxEZVkctlslKK6ZBzBs1BiFB8d9DveP6DZkxzqWNwu5UzU8KjgXEutaeR4OLi6S11JilGlYLIiMCJbguj1sY8zts6zaRh3W+wNK3qulgZlrTD7Jc/xlDeniQTduLdPpHud9Rnq0Cky5VmOqiSD0UkE0D5a/IgVCZZcRMmF7lGyC7SlXjGCp5l9OMrl/w7V7yfOLTqtn7IqeClDGJXuwhh+Ot45F77B+7mH/Mls92Bo8t0XzE7jHMZEWUBNpKsSvww9wChZj6Pz71t3ohNtzxRnB+M0EATSNArgMNw1uDQRrNPpm8ifcLc7eiQXDJx/CPHpDUUqyUsbG4c4aYGxROShR1k95xtcEIHeL3zF57gpzO+WR49O6K0IVAhpcx4at3evgE0+L9VohFCwed0nn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199015)(86362001)(921005)(41300700001)(36756003)(2616005)(186003)(8936002)(5660300002)(66476007)(66556008)(52116002)(66946007)(82960400001)(7406005)(8676002)(7416002)(6506007)(107886003)(6486002)(316002)(478600001)(10290500003)(4326008)(6512007)(26005)(82950400001)(38100700002)(38350700002)(2906002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5vTt4oya+/jcwpiY1jT9NhbkGmv8YTQth0QMnrf3a++Qxboi6R2o4xnBbWOE?=
 =?us-ascii?Q?TOn8O5773kk9QlL2Ikr7n36fLcOgaiuMdmX4h/PBGKyLP66z/XJ3JJ1VkmMM?=
 =?us-ascii?Q?m3PxRvVb32MiPW5c5WZq9z5xDRn4Af1e9xt8SZqDPdZcmsfFmOxrL/GfIMY9?=
 =?us-ascii?Q?56zKZai8LtPxaAO5ZxtMzcYnPYl670lflruAec8F0EXOxm/diD6Feuj/n0P/?=
 =?us-ascii?Q?B+yP2hBZ6WLNMYKSN5dbcehBd1EywcZA6wuh89+yhPvwESwgPbhOrx06MWRv?=
 =?us-ascii?Q?0zrTTfLbiYDv+RwSyrKX3E5CESV8/sqdx+fMLZtZaOcuQcT6gqJWdgEiEq35?=
 =?us-ascii?Q?8p70bDPiOlsw8Pc6ybSaV5ciSBAtJYYNn35AEQbur5byJobjGdia8U67UE/r?=
 =?us-ascii?Q?liaZERB9hTpKaYDISbl7hWr7Tg16GPvKAp/C8lvdVpjRrOlo+LWh6yWIwoBM?=
 =?us-ascii?Q?mJo5q5CvqqLliHBVYuwBzrZhfnlKeZ/DTaef7dJ3pakq++3jkdGwvWAGao9x?=
 =?us-ascii?Q?UBggP6Owyg8VkqRGpem00sv0fJa09Vr8d418ggyGuHXP8E/V8hs7nMgx1dTD?=
 =?us-ascii?Q?9+Xn8jZbdeIMVkCekclbMRijGgvqNVv1Yxx3U0hbC/pdKHUeK4ntYApsqxoW?=
 =?us-ascii?Q?Ecqa/+hD6uoe4cpiXabN58gBX1ncmEjD6X6bFNIa968eaAmA1dTklj1VcMyG?=
 =?us-ascii?Q?RIIbiFQmpj6bWMaVH2oOQBqaMBJRWHn3Scn+qKbu/r6lnJ3PER8tS9RUa/pJ?=
 =?us-ascii?Q?Ib7UQONvctzF9qWWydNH8Vcc/ESXKy5Jumq8tpW7CiabAGevqb01xlvRKTFr?=
 =?us-ascii?Q?LWnTAmoDt1NbcAMNO7u5UC21O/fNgSI6G0PaQ4pnEBIv0xTo56myKp2EadHF?=
 =?us-ascii?Q?GoPaxVKg7TreO86/uO/gQABPMXPLSR5ZTshL60lMpNvsW4UcpMm/wbx5W1xp?=
 =?us-ascii?Q?JXkl0AC4XdeIYkn2+2IHNQyG9uG5LzURiiGkjCAcHBEd3PPoGOd8d8DApQqZ?=
 =?us-ascii?Q?yb4cDvMZJw/lc5d3DTjtc/SjxOlQJYUu5M/IFS+1wJa9/1JBOhKdx/cR3zTf?=
 =?us-ascii?Q?+HAScc1neiXJUzvf8CQR9wU4YMiQnh7zklRHpxcec0i/tcGSpiQbqV0wo9Ah?=
 =?us-ascii?Q?Glb2PDZg5/WuLR6kzeeQrJrbfc07Lgtn6MV95ag8rt2IMqwE8nhQCQZtScCG?=
 =?us-ascii?Q?is6nP2iI7ux9D0s3ORO3lL3iOU2KM84g6h7MEJtfqdt6gpwMXg/uZZhPAbap?=
 =?us-ascii?Q?Bxhy/bH06FkgcrN7emXkUP+52wYUXdh2ZMGcK++eURbrSUmNuTEcCOB+qoo6?=
 =?us-ascii?Q?ivM1xZSNUN5I+3jhseaRiJnna+37uHjTb/C5GNYD/P1pw43af0tylVnu7UaK?=
 =?us-ascii?Q?v67CsAmtyUeT2S4/Qzlk23PmUOYzeCfWymEY9LCiswU4tQQMdZEKJltnMXIP?=
 =?us-ascii?Q?uSvt62ZWE7ucrEGTDbbdyrayJWWYhPYH5oqST292fg98zEOIDOwh11CnSvie?=
 =?us-ascii?Q?QiGkk3SoTCkQ1hGQEAjHPbs0RfU+PbZGUCHkx3LPO7vPtEjbxvZp99eI8N13?=
 =?us-ascii?Q?6dNbjQUeQCEUXUp98g5yHWO50pEVYAmRKRDjvcXnJ6SnqG77Jj3rOmxk+XXh?=
 =?us-ascii?Q?/g=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ae30e38-577c-400a-3519-08dad415d2c8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 03:32:22.5052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XYLby82ApD1YcNPdfJvqGgD7noZVNfBpTaigsnwkeqpNpE75brW4otDLdF3TSiyC3vC7DvORPnLGiT6KFhheZw==
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

With changes to how Hyper-V guest VMs flip memory between private
(encrypted) and shared (decrypted), it's no longer necessary to
have separate code paths for mapping VMBus ring buffers for
for normal VMs and for Confidential VMs.

As such, remove the code path that uses vmap_pfn(), and set
the protection flags argument to vmap() to account for the
difference between normal and Confidential VMs.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 drivers/hv/ring_buffer.c | 62 ++++++++++++++++--------------------------------
 1 file changed, 20 insertions(+), 42 deletions(-)

diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 57667b29..3783d9d 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -186,8 +186,6 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 		       struct page *pages, u32 page_cnt, u32 max_pkt_size)
 {
 	struct page **pages_wraparound;
-	unsigned long *pfns_wraparound;
-	u64 pfn;
 	int i;
 
 	BUILD_BUG_ON((sizeof(struct hv_ring_buffer) != PAGE_SIZE));
@@ -196,50 +194,30 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 	 * First page holds struct hv_ring_buffer, do wraparound mapping for
 	 * the rest.
 	 */
-	if (hv_isolation_type_snp()) {
-		pfn = page_to_pfn(pages) +
-			PFN_DOWN(ms_hyperv.shared_gpa_boundary);
+	pages_wraparound = kcalloc(page_cnt * 2 - 1,
+				   sizeof(struct page *),
+				   GFP_KERNEL);
+	if (!pages_wraparound)
+		return -ENOMEM;
 
-		pfns_wraparound = kcalloc(page_cnt * 2 - 1,
-			sizeof(unsigned long), GFP_KERNEL);
-		if (!pfns_wraparound)
-			return -ENOMEM;
-
-		pfns_wraparound[0] = pfn;
-		for (i = 0; i < 2 * (page_cnt - 1); i++)
-			pfns_wraparound[i + 1] = pfn + i % (page_cnt - 1) + 1;
-
-		ring_info->ring_buffer = (struct hv_ring_buffer *)
-			vmap_pfn(pfns_wraparound, page_cnt * 2 - 1,
-				 pgprot_decrypted(PAGE_KERNEL_NOENC));
-		kfree(pfns_wraparound);
-
-		if (!ring_info->ring_buffer)
-			return -ENOMEM;
-
-		/* Zero ring buffer after setting memory host visibility. */
-		memset(ring_info->ring_buffer, 0x00, PAGE_SIZE * page_cnt);
-	} else {
-		pages_wraparound = kcalloc(page_cnt * 2 - 1,
-					   sizeof(struct page *),
-					   GFP_KERNEL);
-		if (!pages_wraparound)
-			return -ENOMEM;
-
-		pages_wraparound[0] = pages;
-		for (i = 0; i < 2 * (page_cnt - 1); i++)
-			pages_wraparound[i + 1] =
-				&pages[i % (page_cnt - 1) + 1];
+	pages_wraparound[0] = pages;
+	for (i = 0; i < 2 * (page_cnt - 1); i++)
+		pages_wraparound[i + 1] =
+			&pages[i % (page_cnt - 1) + 1];
 
-		ring_info->ring_buffer = (struct hv_ring_buffer *)
-			vmap(pages_wraparound, page_cnt * 2 - 1, VM_MAP,
-				PAGE_KERNEL);
+	ring_info->ring_buffer = (struct hv_ring_buffer *)
+		vmap(pages_wraparound, page_cnt * 2 - 1, VM_MAP,
+			pgprot_decrypted(PAGE_KERNEL_NOENC));
 
-		kfree(pages_wraparound);
-		if (!ring_info->ring_buffer)
-			return -ENOMEM;
-	}
+	kfree(pages_wraparound);
+	if (!ring_info->ring_buffer)
+		return -ENOMEM;
 
+	/*
+	 * Ensure the header page is zero'ed since
+	 * encryption status may have changed.
+	 */
+	memset(ring_info->ring_buffer, 0, HV_HYP_PAGE_SIZE);
 
 	ring_info->ring_buffer->read_index =
 		ring_info->ring_buffer->write_index = 0;
-- 
1.8.3.1

