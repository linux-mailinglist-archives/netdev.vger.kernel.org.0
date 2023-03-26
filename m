Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7766C94C7
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 15:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbjCZNzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 09:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbjCZNym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 09:54:42 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021025.outbound.protection.outlook.com [52.101.62.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2030E7ECF;
        Sun, 26 Mar 2023 06:53:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBzdGnozYZ0OB2ytSuF0QWmzUHEvVf1pjWV+4w2WNK7CQw1YdUQh6N86Dm9AHvNLx0avELggxreawQdtGTRtQ4XhRY+5xtP7HNXz/fOeTfiCSv//SqIiTXu6oTBV5LzIyzDeL7VVjYtQptMPWZUXMunrbI9ERFYF8UFCyVh4oqpCRFAFC51jLwmDIJyCCP1Ndot1JpjnMJE7PzC3TJibyxJiG0hUWz1oe0KxsPz+iXA6q57Oqa4cddwawhumq4PBt/nO+PsOh3+/WZQMQnY+4SCc3WppO5VpOaXR2x4KQsfkcFW2g2jfBLKfdvxM3yD9pb3NiT5Vp2CPslJ3di8f8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ogveo7t/IcowXK13Ts+Z+XPBvrmc2pZAZdqL5WY6LIQ=;
 b=HohFbk4hBCnVLjNLBWp3K/Ie7KAdJdY0jFJzPHXZhfhllJ2MprvyhGr8ns5vzRMvm3kJ2UV57aJqKwaQ5BXeCdOI9lOAtp35fW/dDhl+b1CuMNKQpTjD7AZrNvbwcjezB9sTVLx3iewVjLk0cO5hXn34RiPVYPyf6d7f8zLwF2qqnq+lVVxyeSpN3EWbgwSogZudDIF0YkQfy88kFJkqE2Wbi8UZ+Nh9YP8DZiR27igIyKTFT7sbSkkOlt3Cynw5DgCp9cg+E8ErwPhVygzwdnjSwgLnpR6XObezMuOkgVEmoQk98ji2WDKleMMqomBZUYQEs/oQyr9opRlIuvi6ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ogveo7t/IcowXK13Ts+Z+XPBvrmc2pZAZdqL5WY6LIQ=;
 b=CtZ9j81bQR/YvQVfPIOROE5hrP/0faUOJnQa47/mZjoRcqbv5L1L0fTDBeZHTq/lpF7xR3Dfq8mRBK9MJxBjjW28Z11Ov10eB4iS+UQ8CPT7DYJMA5K6H+FbBlZK6qJRRSfdVet6y0l4NnRCBl8GmwRfL2b6AtAthKsy+frKAcM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB2001.namprd21.prod.outlook.com (2603:10b6:303:68::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.15; Sun, 26 Mar
 2023 13:53:26 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f%3]) with mapi id 15.20.6254.009; Sun, 26 Mar 2023
 13:53:26 +0000
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
Subject: [PATCH v7 09/12] Drivers: hv: vmbus: Remove second way of mapping ring buffers
Date:   Sun, 26 Mar 2023 06:52:04 -0700
Message-Id: <1679838727-87310-10-git-send-email-mikelley@microsoft.com>
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
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|MW4PR21MB2001:EE_
X-MS-Office365-Filtering-Correlation-Id: 2aecd170-39a8-4e80-927a-08db2e0178bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OVlkv08PVa8+45487HO+svSvSj/xphVezzJrpy6CKsCmXoBifaIAsIAQC/o7oBKTfFYtLWh8bcHkH2B7OhIy+7wEpeRlBe92oyonv3HWMeEURtAt1sNQMmmc7DOyLqgvnBSUnbetMvNMZMGw0Lu2e4Dj/gwxehcOfl6tGBVfXZL4FEEDpWMa7Ll/NtmoGjopRUPs/mO5+br8g55s1NG68kP/VqXveihjt+mrqa+Q5+kx6RUprF971LSNamjdHVF0Nk9x15JHig2kCc+JPsuUJds+vADfmsxyAd/rnwf7BDjeSYAU9dpEVtwZF+atYiuO4+Sjaey/OHphfq0Txy3SNppvcqrLO7UtH09zHSGueg2oTmbKWhWlX/srjsZv7KEljmHEMu0FSBDq4UN0/FbYu10q5t9STY/VTqTzTYnYPMEMx1jn4tFu+lyBod9q0imLrmUJMY2JuBP2X4xxOyNelRXAfxa2ckL80+hNHrHvGFdBRAlkdqILOZ9mJXtXsY/FhRF/MWvnD3IIt0yRnFCzQt0LI7shJFpnrBHco1ucf4He9foebqHwuvHiu7tj4eYhlp1r0pv02cLBSW/+bKJR2IBdqNOYRrThHlVDqG9CmR0VKVr1hZsiTbsHjwvNC+i899AI4pkhXJ/rXFToHY/LSsO3AQEjGx8lluP8q6dZ7y6EAh3/XZ5/nbvbG+ch7QNH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199021)(38100700002)(38350700002)(82950400001)(82960400001)(36756003)(86362001)(921005)(2906002)(6666004)(107886003)(10290500003)(186003)(26005)(478600001)(6506007)(6512007)(5660300002)(7416002)(7406005)(8936002)(52116002)(6486002)(41300700001)(316002)(66556008)(66476007)(66946007)(4326008)(2616005)(8676002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OP8SFpm9eTNOw9S9MM/V2DxQMfYosELPN1ycrl2JPMg717Bfblhhq5I0XNn6?=
 =?us-ascii?Q?/sofaJ2DiRc72bNxjeHaazTfTCJ19z0Oo895t+kisuxrhA64Zh9QM0pFRanh?=
 =?us-ascii?Q?nG0GEukLbUrFTugFtLEeEQzWSUJ5brhfz5uFXoA1vs9c4CSOhy2LxreVM5iq?=
 =?us-ascii?Q?iLKJFW5wOdaqQSSkHCPAmcD+Tdrws58i2XD2PqjlauK4hnJe1OL1K4/Cmi17?=
 =?us-ascii?Q?skLilwvpSClih7LLvpZkT3ESKTzed731RO/9JnQbfP2tOigJBW+0e4FbbC5C?=
 =?us-ascii?Q?VPXU6TAwbQz9sgVTkPrlp1x2yRC02Hf17MfCF7pHILwl2zhGhxb44WPr1vXV?=
 =?us-ascii?Q?8x0LKkRROHwmodqo0k/S8cdFnmMsdjt+r/tu1r+iouYOnev09t9Mosr+Pctr?=
 =?us-ascii?Q?YxR8RBZJbCJswbt7MoKTxkkJrHPdhxGipOa5UuKH4lS1YqdWW21hHhurr4Hp?=
 =?us-ascii?Q?ZGsIAET2C6DCK+l9BBVv9sMhMrysGQBjLFJ1lNNipnEzGfxxRTphgBZVkLH7?=
 =?us-ascii?Q?mAK4eUPY9qzta2K7pTLuYf/EuyATeVpHSmeg2XcIUQ9StGcXrmwoekYFHa2k?=
 =?us-ascii?Q?CpV5YgE+jBPpO8CF25Z8cqanA7Z/xy99LIUZSp900hH6wFDs0KRXGM4RHqGa?=
 =?us-ascii?Q?i506XMlhDip4voaMx24xEz+8EUrDHqibpXDpOOsarAivVJYP6nSlVuxW9hU9?=
 =?us-ascii?Q?DmPSP3LDtlurqotnLfh/quQf8qnsdwWbVtx6I/Zv/aKACsd6I/LFUzLBekc1?=
 =?us-ascii?Q?K4KZjlRcOOVvfQJKpR0oZL9jFBx+vcouYl6y99LZVtIqjrmvfxFaiOCHwVKr?=
 =?us-ascii?Q?7QlHzhbAb/22N7VsacD198yvzerGwKAGFysBQ8qXKxAKkHZ+OACDlj0b/A9+?=
 =?us-ascii?Q?DK5ph0jCb+WjdDnqnK65QskhrTSKVcJYojYRM2YMBaD+RCn8cMAJSIO3tW+d?=
 =?us-ascii?Q?ILr1DMKYaMyNhyFb/vUlVae4KMrmgmZMoVP6pKhUsYPWJuTLjtB5Gz56Oo5O?=
 =?us-ascii?Q?NAGzarlNUeOSAFbZ9Vw3hlk10VIakAbLRB8pSnr3gH9EsQas0IA9UM0nGxt+?=
 =?us-ascii?Q?5oJxjonqkCyrfMzj06ps3s96dtRqahQI15jataqDGl6tWLZyHld8aGO1rKFQ?=
 =?us-ascii?Q?YetSZb1AoNw3MD4lgpjAdlxdEkZrZCsP39GPo/WJ2qXfksg35h5dXxhTVVHO?=
 =?us-ascii?Q?BfcpuXomBXIQ7SjzMAN1uclJAT9+hQuDQEY5e5wfHf+csyWCPXk4rckdjajG?=
 =?us-ascii?Q?2Lkr/65/9o2hYpqGVENP0LF+hDOc+mIRTe/PZHl+jc1j8scgPXdZPaukgCSj?=
 =?us-ascii?Q?OV7eL6IBhs6nMDPBApMFfrr4kqsJ38i9jQw25yyrqWMU6p0IAaV7JRVH7LoL?=
 =?us-ascii?Q?JhOkowhyWpJxUn08i8cm5fTcjdSHX3dQ/EXjb9tu1uA7guXf9VWZajMcvBpL?=
 =?us-ascii?Q?VcO0xbGoTVNinJMxi5bmij8fMHkk/buqo+/hb5tYDIpvbtlH4ISkI8houJQb?=
 =?us-ascii?Q?2usij796o/40OjPNcndQ0YC4zW4SMadBKlIElJCL+h82Hbw9sqglISTYtCle?=
 =?us-ascii?Q?8XVxxRJ5CFeYWZ1ltTPBOGLoHJFKj4Rqfk7arCHbsPgvxA3ccyFLQdXxqMrU?=
 =?us-ascii?Q?NA=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aecd170-39a8-4e80-927a-08db2e0178bd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 13:53:26.0213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bLw3XS59nEeJQgtVHpdGZoh+/EZBEpSDy8LUWSPZUbIwPXcBczH4W+yfnkXDY10iP/Rd0id67bEPl0ypAI06Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB2001
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
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
index 2111e97..3c9b024 100644
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
-				 pgprot_decrypted(PAGE_KERNEL));
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
+			pgprot_decrypted(PAGE_KERNEL));
 
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

