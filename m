Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 716CA62C80E
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbiKPSpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:45:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239313AbiKPSoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:44:14 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022025.outbound.protection.outlook.com [40.93.200.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4AA654D3;
        Wed, 16 Nov 2022 10:42:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f3hm96vr14GprrcYHN1j0Nl+676JNXsoS08QK/Y+Ge8AJ1CXkYMSdygwMDwQ88zT0CTvXEzMFTLcU6ZB3iO0e7yW0U9wuQWkSs3suG78tArKMFb8z6q/7j6X65K4M87AABK/+iwz+NXNW+cm+Vcz2/nltL6dGHmRiC9wHOtMPyNVy2m6IcE1xP6M/98mNeAiMbMq3F+MxiJwrkCUYdRWt15ZVrjCWiIECFyyeiuPcZeU3GOeESaP7GkY8Eun7fUOQ7PidwMsdtsMjfwCQ7Ix3ohSe7KwgXHv/X9uu6TsuhvYZvY74F0/I1wIPy/wzThrve2x0XQE4M6sdAxcTjb+cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ukiq3mpmblNcB6SjkymwPbJw8wM1j3J+T3/kZJCLbMk=;
 b=bb/wrS+937CqpUjepl2agNHSBtz9kEVgHGXuB8W1inx9fY/rPLQ7Ym7y/pipsl8ueREBfOoMrr22WiPLDGiau7tA52DJnYXPqPSBIIMB0cQldQlFtnz0+R4UteBJUNF7GFqpoOsiBvl2dZTWLMnDPdJsCIeoCxHqLdLlWehNbWLAWMonCXc13ipPCsqvNYEIgIoRJi49mjG/BN5XXTZRvpohtsHeHqEui651AyeIM87EVsS0C/902FJrC/B3wpUZzTXP3dqg0Boz9G/S39GcjmkwM6lTnSoy+QyDPt3EbjtfwNWehsksBbVdzcvrBj+/YoNHQkWtSQEVYtPq5GMNJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ukiq3mpmblNcB6SjkymwPbJw8wM1j3J+T3/kZJCLbMk=;
 b=K4yGymIr2nVoFquIUE9WLh/xRQW+9f8l0mBR6zEfNEEMUhwYsB77spB/+ctV1FVVyhRaDt/GoxmUcwTYr304a/RAdn27BQUdrQcUHin4Cgld3qE7fHUdVNvVW6YyQeZViJ8ug56zJpEHYt2pIhT+CPp2d8VnGu+W2J2j6QXztfo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by DM4PR21MB3130.namprd21.prod.outlook.com (2603:10b6:8:63::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.5; Wed, 16 Nov
 2022 18:42:44 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%9]) with mapi id 15.20.5857.005; Wed, 16 Nov 2022
 18:42:44 +0000
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
Subject: [Patch v3 10/14] Drivers: hv: vmbus: Remove second way of mapping ring buffers
Date:   Wed, 16 Nov 2022 10:41:33 -0800
Message-Id: <1668624097-14884-11-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: c463e26e-e919-4e4e-75ec-08dac8025966
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DV5N0FcElG28pd4hhul8Nb1UWuEqizTl30SEu2Rmzj0SDmVuhfXTjX7YvRoDDignDTq/8x1kAA3ylQx5UjBxUQh0EKNT6pdRXjGmtESV27YZs02IxPeOa6hLx8VgnRnHPYIF+Wg/IbQryHTixQoPxvIt/5P5Ensf1NzMnsNBr6CceNAgbCCoVeN4tlaGoIN2wRpUQoNglnSe2FrEZS2T5JZzenbVxjH9RWnVCIJeJ9wg5Y2BPNPPMiXma36Wt+M4DtRvjgVm1QsDGxBIuFj/VXWx9zU4TEpeb0K796sW4/s9WQArZzZry+/gjss0iXgKOn0Piv7C6Z9uiQbvA/mCbgjbMysE6WZjnlT5R4Zneqnre5H5zz2SpW+Qr+YD2DXRHUkdfEQmP2EXTjvnLqgWY5TCV5j5z9cIYHx0iOyF4ntrptlBuZmujGm79sm2/rIppJCPYDL9Dy2Z3HoLoshwteiNN4nhNElhfOKiz8150VbXzS+h9BeuHaRG6Sgw3NmSUPOnYEcOby5bq8hgdVAgLt2KU+hPL59nrMdLzQJWc2dUI/x+nCJrqSI9E9pWZzDEGHte+A0i2YqdFlub3Q11jd8/kggtqAji4F5CTopy2gg4ZEz6lGRCq+9vba0IQjxwohT45OVmK8CfNWitgG+nWUNQHdmpxAvpJb6fEbDw17o4N6qLbZ+sUPp67bYhBd4pyn3l3uO3RKoONS1E5tN+806yeTWD7bypEnGpRtALElSPvufJsGPI+CvAy+7iMceDLpUHyYMTCGRMrsfQ5nOD7a/iDSY47uBl1m9TrQyh8KqHgI4IHLHA8gkSi5OYkVqtrwt3eFJNnSc3qfY1/21ChA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(451199015)(4326008)(5660300002)(8676002)(8936002)(7406005)(7416002)(2906002)(66556008)(66946007)(66476007)(41300700001)(107886003)(82950400001)(52116002)(2616005)(6666004)(82960400001)(6512007)(26005)(36756003)(10290500003)(186003)(83380400001)(316002)(6486002)(478600001)(38100700002)(38350700002)(6506007)(86362001)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DNwxNa8l5HwJjWNmhKtgao9kHWkuHA9NhvTCIGiZQgVsr9BKSNAI66VbyGFB?=
 =?us-ascii?Q?UNUIEJ103jyZkozujnLRTr9uziaeNntdZthGUaUsggfI6Ey+qqaeskGmh9pl?=
 =?us-ascii?Q?ZBbIPemXBjw8fSpvkCvwfwVyCGQDUt5rrjW/Pj4A9h6VcugKzMDyVYP12tVf?=
 =?us-ascii?Q?o0+7T/pkLVAF8TJm7L5I+Tb3FGzsrJR+9jmbHWExQtVJihNZdhBKuwc3FvYp?=
 =?us-ascii?Q?3qQQzia3LG4hyU45hg9BSXJRYoXDgIMSuSPekriqqyaYlrK8n9SsxU3vkOuL?=
 =?us-ascii?Q?luwFZ/pMjF6yrV9OVkpmwsh1F02uymcmkFIjXCoWwJwDx0rUgeZ1je6n8hQ9?=
 =?us-ascii?Q?yn5m+c230nWyPaJvntHk/2LslwrhsYdZu0C+ibqAt0R/ZdotAM7NR1mE11pI?=
 =?us-ascii?Q?aEHxxktGK3lv4kNkFUhIiTB+i2/RwdM3X92x/UDPezcF/9khHAOsaf1dsFDp?=
 =?us-ascii?Q?F4wkFMxVVFxVIsehD+DVOWyYChcxI4GxNDsYh0rveKWBkf1t8RL4KNBfWjSu?=
 =?us-ascii?Q?rpJ5F+pENbL0c9t9nHg4vt6YykynGzxxUtu7ilDGzY9PK/94SDndeJRzlxFf?=
 =?us-ascii?Q?7tncRGmVERN5Ce9BI4LNFoSkZKy59w7I1BmeeJfS+PcFSIjJj/SAuQSkYHu8?=
 =?us-ascii?Q?gBBxaauf8d/5EACHFDgoFSGRuKjeZLtWk9R4l1Tg7okGxnqvEymVrl5Uxme0?=
 =?us-ascii?Q?z84vccyWRki9RYM/ad7kb3kV4sWjL1eQwiG0LltWCYeGnQ7rG4ysIeb8j6I2?=
 =?us-ascii?Q?5kRk5JcSTmzK8u/s6IMqJuqSszLcrh0KsLF2O/Qs5QfBi9M8J2SdWH+e+k2m?=
 =?us-ascii?Q?1sLSfZRYTFGw25NNfHSd62r2icsVEVFa+kk7x+2kognXr676lXigYz5JKFW/?=
 =?us-ascii?Q?4l0zHuzDF/f9M8p4ykqCyTapPVZfqD1T9mb7g3Mo12LLTDZ+v7zbbkTy1Udm?=
 =?us-ascii?Q?vKMJVQdIKRD8ZKC4wzhIhHDoog87nzVWYQTLGN5UQxnOsc7YtjqAo4W8A1j5?=
 =?us-ascii?Q?pvbj5JRmwFxxIp80/AWpBnr5YGlRnNrRLEs9fLbxI7aKp/ln5O8uhUwaRQOn?=
 =?us-ascii?Q?Z3wiQZC/WfZrtCFDkkx3wFGhUX/5TFapWaI6/CO2qaR5UozVMiolTavwFOAz?=
 =?us-ascii?Q?73D7tYLjpLVqj1GdyUO4i/3ZlJQtPiilI/nyzQ9YJoKDjeS59zxl74djpzsh?=
 =?us-ascii?Q?K89fZRfuQrDWqnZN+h5ASDEyk+aA3YOojkdTrNuZXIbzyR7EpZ20Gv6DLcnl?=
 =?us-ascii?Q?yUpQ8k5yVpfo9tzxZnKoghzNtgsIJ9zYkAFfof1wT0XSP1aAQ8hOeDIzOnmP?=
 =?us-ascii?Q?Uzsk643GPgAjZVS/n5mmJqBSPYrV5mOaJh/KQZy46KXxO1C8i3hC71D4t8WJ?=
 =?us-ascii?Q?ua2PTD81YrTFxYoAY4fZzCtEFbo65wZnp+o0jq0NWP7k0kPs/NUljLGC/xjH?=
 =?us-ascii?Q?3JHmaFSWBiJo4SPMaqusHRGFjg3M1xPY/Oh5LmH1OMCMbigMJBPJCqBUdBrh?=
 =?us-ascii?Q?My9qZ3Es8PANJhsAVoKhwMIB/BuU1wlV7s0ioI5fPU1pEcpqG+nCIWPsogSe?=
 =?us-ascii?Q?L7++1K1FiTxRSbdbZZfu4u3GgABEk+oUw/dBll2R?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c463e26e-e919-4e4e-75ec-08dac8025966
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 18:42:44.4066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sw+Q+fLus9916g6c/myAfCnY2uzty6PdlsJJGcOT7CXr/3EjWzDRVo0bY9mTEA9JJztaR98GT/QYZx2aaRkpNw==
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
index b4a91b1..20a0631 100644
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

