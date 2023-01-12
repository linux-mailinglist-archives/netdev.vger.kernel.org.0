Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D49C668611
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 22:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239157AbjALVuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 16:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241013AbjALVsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 16:48:43 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021021.outbound.protection.outlook.com [52.101.62.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45717C09;
        Thu, 12 Jan 2023 13:43:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=StQK7IwVUrkLnBCelOwtgjll6GOzJJpIG0/dJWdkXRxcsPrKwj6X/0zbjfX7ouMv3+/mp2zEL4X/uVDYGQ9vawqWvY45L5W3qOfi0W58wPttI6V1oBLsPZdeAtdRpXlHwbAnlppV9Mp+eqtVp+i29rd357gmUzTxSkSWmBhlgzaRfp8B17Bo+uScLxpe+7q63j5q+sSchiby/wCn5txgqJ6pJM4ObGlibik2Hr2am7lm/Nt8L/qp9txhIle9Vil4nHtOzxb84FUZxWH4nXRP4eqLtF7qFr5Oze4Al09nZS1hB6sdNCBeQQ3pEgoPEJym+/hflN+cCxsKAKfWKfneiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ogveo7t/IcowXK13Ts+Z+XPBvrmc2pZAZdqL5WY6LIQ=;
 b=k6BksbXpHmM77V2cz5SIP/Bn81vbJuapIb43SG6DBrYGveKnmKerrCf0xGsX601YERQoKyuTqyMBhjpnfyx0mtgdAnmpeW8JbIXoilJtg65OwrlxZjEHlVK8ttej/17VDvXXKF9R5Kg+I19AE4A0TL+4Y1Qu9VVPSrRrsG7n+vy3UgZNttrs1aLXLESoAsRZGCsRA8bCsR6c6/rBv0kKOsnScZLDghP2uGIHtnP2oJwSdsWcZ8vo4jSR2SYI8iZKdV5It4xoqSm2Nrr+bHGZWysVlqSnahLrVv/aplqHjhyaA7qm1H+1r7Q2YOeB3yzmd7YE+wUtaFolOcXNsrZvBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ogveo7t/IcowXK13Ts+Z+XPBvrmc2pZAZdqL5WY6LIQ=;
 b=aCP8HPynJKzrhQKRmF/BRH5bWU94zuUuv8qCHkDf190H2a8GNw8p/mxJhy7i6ep4AnFGNkXGzfmo8Q/k4Ym1HiUN6TYk6tE38AcayvucPzAVc8oLWKH6nbRySWWNfNy8+F33AxIuipl3o7Xw0UyyIhEui0/Q+uv+RfQxfnmW9JY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1953.namprd21.prod.outlook.com (2603:10b6:303:74::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6023.4; Thu, 12 Jan
 2023 21:43:17 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7%8]) with mapi id 15.20.6023.006; Thu, 12 Jan 2023
 21:43:17 +0000
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
Subject: [PATCH v5 10/14] Drivers: hv: vmbus: Remove second way of mapping ring buffers
Date:   Thu, 12 Jan 2023 13:42:29 -0800
Message-Id: <1673559753-94403-11-git-send-email-mikelley@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 85ac5d6b-0d95-49f9-db06-08daf4e60415
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D1e3OJJG4aDwd9bZ8No8pimky4HTlS0fwR6c71XG0+j9/dxyYBbdUdjOsxc/WEMXFAsuuzDRQ2XmjzBbsh92lzJg4qRiSq1Y2kKBNJeKh1DIzXP6scbf9x/psRi7RVrpISEN7wsmwTcaMFK9LElY1WyDmeamStcO2YA5T2HN51XLSTEy1sL/oN3Lllx4ECukIxY2IV7BzmAGI6rKT71QXXkvG01ieTOCjVxONzAsDCqcL6a7NkZ2pvJrXH1O3IyzulQmNRc4ItwxQM1fW2vWujMEhOVNy8k5j+LXpf6AaQscSDPQxg2ECfV0lY9kXGmEayWRKEELnd7d18+gW3GpkkT4Q5zBEpefu/abqBEmo3SRo2HkQ5KxyhoedRX3JIvPZHyInaP7lwMgmjgndffDhrWjDI+XZolwXCCY8PG19buu5kCspa9Y75DJKtSFTXLTOae56uD5lJiVc5UfdTmb8rG1W9dbxL1Zf1Ql+StN+pgoAmIvIq+4VyXP/Gv7aZNRuIoi4PCMd4QWFRBTJzUVye8Ju1Sldf7YcklZRX9H/e9YCkvbARAnfdECxOEY+TEvl12Z+NJNX3TloniRwVxEyxgOzlUsufSZCbVCYkp6OOmv7bmio13NSmqAbWm9YpSzzfB+ZKBQVNoOf7RbobJWUMrgYut15d4iLXutefJpab5pqk+gz0sHf94PVJbzlvr4p+sHOsyVcBLPr/gAAv66FISjKkex/giDhWWVS5rDMo0kA51yntFZZVwPWeZav9MSKM+08JlWzBaNJk8uUBjxug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199015)(186003)(26005)(6512007)(82960400001)(82950400001)(6486002)(86362001)(52116002)(478600001)(2906002)(5660300002)(4326008)(8676002)(38350700002)(66556008)(66476007)(316002)(7406005)(38100700002)(10290500003)(41300700001)(921005)(36756003)(66946007)(7416002)(2616005)(8936002)(6506007)(6666004)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bsRWLJaAcEkkXUJwXAr0VoJ9CZbsxrtOkblFE6pSCsUJRAikrTkk5j1H2FBG?=
 =?us-ascii?Q?UXNItHUaMdpS9bu8uHHNT7D8SbSQRCug/eXZjCDudnjJCeXVgyZ4zRRFbuJP?=
 =?us-ascii?Q?yKcjesXHDONZmWi1T19gmEaCLbIGGnqXSxFzhm/xulixbid+N7sTwSOxMSNt?=
 =?us-ascii?Q?Ms3DMfq9E3zOqoPojlTUCTH9tsvwTQznmRqGyehxdxv6fPBTIpsYA6D/eWgs?=
 =?us-ascii?Q?Jn0qxZRCO78pKFGITLx9zcy5m6PGeM+6fJ6n5JsbjjudJosPTrNKV8hQ/CHI?=
 =?us-ascii?Q?d7nltNB6PbDs0lLswG4nkq70TI6P0stNUWW4zPOi5HLaKvNjzGCAWi94LWXu?=
 =?us-ascii?Q?gautocNnM0wO2fBt6SnYkWRqjVL8mFtrcHRuHCsDr+Gti03iJdQce/Ng2N0T?=
 =?us-ascii?Q?U3HxV9dwV3iER53Jjwut0uYEO1vmZYe+rMUegtWyW+pdraaOCJp9B7gi65yO?=
 =?us-ascii?Q?M+Czf+KPOco/DZNEGJ1z4NVw+DyTqgXjpc+lzyysVb54veC05LsjXwQUArw+?=
 =?us-ascii?Q?eF7pVTuDwUfB6dSM9z4lGtCzf9sUt76A0SeW/sKA5g/8hgdZiqbhebSD5l9k?=
 =?us-ascii?Q?KfVU5Y4PU6JYMEqifuJuggFkuz5Yt72jj/LJI28NBEoDjKR7k2pf1nkmntXw?=
 =?us-ascii?Q?DC9uUR/JWXC3dabzFehzIr+HGqMXE6IQG+lJzNDsQMZMGve6QO74Ugi9MJJY?=
 =?us-ascii?Q?sI6kUVaZfv+X0iK+erzbTj13V4/FgkleVnLMFUpxPikUlexkcVeM8QzQYUUG?=
 =?us-ascii?Q?DVsQPMUdIBvO0LW0ypI284nXRruLMzVn+qw/Mo0144ETDR+M5qucLenxhzSZ?=
 =?us-ascii?Q?ARRYPFO8Bc7XYqq7UW7TEO3IABZp8lCcziKisHeTdE+dbg4CqI4xxTNvWZli?=
 =?us-ascii?Q?EjjXHT2wEaTJzZf3QFNSBCCKJaZN7fYT4VGIUEI3j+T4t6F77l10rZiEAJ0P?=
 =?us-ascii?Q?Glr7B2pa2nqYeyx4vAHg1MVRRgufB1ydrAl+wnj5RFjA1bQKtuf24FcpX7F4?=
 =?us-ascii?Q?HA1E9zyP3P19+iYQszG6OW9HdJTRrEKGLwM3xhmImxo9XoFWT0CZxjbUwBZg?=
 =?us-ascii?Q?rC232ufzR6uZ9+ASWqBU2qSfczwKZLLC4DIFTu/dz+guUHSXVPE4KiEa+QUg?=
 =?us-ascii?Q?Y7Qr3DHQ+RCXCwvCEMnHtscnPBmDLtcHVcZ0MsSUZUi8pFVBUrpB3imulIb2?=
 =?us-ascii?Q?/05zZ2RVMLyp00F92kHUmACjE/+Vbv8O4dxy/ntgwKV0bs9gffSe+0btQ9Uu?=
 =?us-ascii?Q?3YbIxtB3D4mLJmfnV/qEetdaL+EJwif0Cuv4dPq9Wuuio802a8CKVlrI8eTp?=
 =?us-ascii?Q?SzFUoECV2vIZEYGOKB/YZt/8v9VEeA4WvLc5rWUf99GB/r9YbHt2npBsDbKJ?=
 =?us-ascii?Q?XXp2UEKuHw4egg8b5qm6lBmuzDjpQ9Zb4rSk4NJKmuj0wTnIGTOZI6JBi84T?=
 =?us-ascii?Q?+c8rAyFsCa+xOwCYOolMYX19EmUOBFjm3MwGpjXO0n75d2vGRe9gUKEZWwEL?=
 =?us-ascii?Q?A/I9EkUBzJz7Zz07DhPQw03lgkiTP1g+bNbHKJru5OALX662HPV9pXUJFgxh?=
 =?us-ascii?Q?3aRWEV0CLaZoBwdKXEds4dk3PMFip6K2Lt7HSK7U?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85ac5d6b-0d95-49f9-db06-08daf4e60415
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 21:43:17.5793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yF7dZc320IClOu2BQ9gb1NkWXeoiVLMpqaLswhNjspookvdiedXIdqHYxr/0EDRyOZ9WAQtBtE1Q920wgA0QZA==
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

