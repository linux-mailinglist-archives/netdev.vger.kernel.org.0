Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314976C94B0
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 15:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbjCZNxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 09:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbjCZNxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 09:53:16 -0400
Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021021.outbound.protection.outlook.com [52.101.62.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977427A85;
        Sun, 26 Mar 2023 06:53:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gX8jD7NYdVetl4g/VQaifLsG390Ob8uhtS4kVBVI7m4G6rOB0189re1kMz8dQqvWUhJB62MqSBoU0Dqo5jRCHGXqGYjVCngUW8HhONW9pcLAC9/Vk3waPAiDz7vyJuGwStk6ATA40KvXvUX+8WvGorcwgv71H+9bh0V5NN+hQ94vMjc/vZMD9SoiXOKVae356S/YG5VsIbLm0v4HmFySH9lJZ2CNexjAXPg0Ybxiep+FDJlzYnxl3y1AEm6E4iG+TtfDo/CuvPQKBkzB/Xxnq40dceEO7m32hg2azKATNmhTMG+hmBjvYo878Yxk/Nc1WpewVOc0DevJ9YXfaOb3pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WMpXjLd+UjKJmPXYudC0MTw+Yv2SaNNAfvRbowIeYws=;
 b=BqVoRRFgFTMdPrnS99ZmXSFtuBAZ6szbHqkQS8bqXUWwrGOZpPRuib6c9zZWeohJxsnrKOhFbbMxS6mN8iR4A8d263uQNj/+SxGzfQ+okfxhmxTTkDOQHrCtGDqI/GckeS+WopH5WuCizv1SNuxGnI0Tfu10joYm9KirUyL8VtBHnDAhD78sgZKr0JU+inz7c83GPKkiBIb/SOWwxGRGhTeL9ig6SvdtZqRaIF6myuEleDCVZzp0nussJ5UF6ZkTKcSvKsN6TSCPDNmHCMnU0/Xfu8ORBG6pCQpZRZ6UTUEQwp2y+OY3H+xy390PJA6Awlv7LDe2KCHNVTZWTm6mAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WMpXjLd+UjKJmPXYudC0MTw+Yv2SaNNAfvRbowIeYws=;
 b=Z5Q9I/4rQI4v26Lr3TrSUd2LXgp+UjrUcHDfcjp9Zk8dhFhfcc5H9VaKe2zQ5/QUTWLpt9+mmZ/FA23VAO++ULARzpgT7r/CkGYbZaSSXnFTGI4lyZS/wgDRxRklZieVhLLbslzPbN3d9bEf9koDDIxjRItP8TrVoQ8OKFvAK98=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by PH7PR21MB3044.namprd21.prod.outlook.com (2603:10b6:510:1e0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.16; Sun, 26 Mar
 2023 13:53:13 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::b7e9:4da1:3c23:35f%3]) with mapi id 15.20.6254.009; Sun, 26 Mar 2023
 13:53:13 +0000
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
Subject: [PATCH v7 03/12] Drivers: hv: Explicitly request decrypted in vmap_pfn() calls
Date:   Sun, 26 Mar 2023 06:51:58 -0700
Message-Id: <1679838727-87310-4-git-send-email-mikelley@microsoft.com>
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
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|PH7PR21MB3044:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d4344c3-108a-4bff-200d-08db2e01715d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T6OFpnfYXIWqkewQrLAGBzNOtRw5fJw52xNkLK9DsUvcfwJtUOHprHeOl+kYFpMfCx51zyMRxmAfB9Z2Bgikl+capYhfoPm0E81Epm9qp0hWe6T4JYzHYMNDeRzlbQ6HtZv6VfR8gFpgpHF3mLEmomJ4kfqP8/wqUwk7QC31OyuK4z5KdheM70T+Zu7CuLkwIJ3ff/beacaq+7KtKagIop5jeGoA+3+aB7p+TYhJtH+dIysZpOq64eaJzSaf4hDT/NwA2jHVjmKDyER4b6jxqtYi7Vrr5AGMooTNgbqOLnnO/crYcCOszb9NaYrfCv62QwYTojnlWdKe3UiwiNtlQFc/zRdaNLS7HR+s0pc4vk8ppyprWdnof+fTwjSHRIno5tl718M7n1jHaKcLlae44LrNIpBn8m4pxtvs/xkLdMgadTXvqJrgugMfxcWSQuXn+Zb1cllhMRyR9cB/D3SAky6b61XybHlDbUmnm/anwchMSbD6BvypV4+FA3VM0Z/7UcYPE8X8AFC09yfJ7+vFET2iVLoQeKNjfNPSTrl0bXs2iay9afXWHv77hvuWpbwjfr4JBNS7ZD+8QNwVhwP/QglnLCzVXdWVogba03F8BzJEm2oRbApUnybGewtN2suXychY/gnnQK53EG6e1V9cvhspJAl0zn+KdZmYlklDv6dofodsHMKQzx0Po86gHgWS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199021)(38100700002)(38350700002)(82950400001)(82960400001)(36756003)(86362001)(921005)(2906002)(6666004)(107886003)(10290500003)(186003)(26005)(478600001)(6506007)(6512007)(5660300002)(7416002)(7406005)(8936002)(52116002)(6486002)(41300700001)(316002)(66556008)(66476007)(66946007)(4326008)(2616005)(8676002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ly47m8IUKPLtGbvCQaGI9ab5fuaPa/xAsyOCFtY1zVpGkWHIVX7GXYcxpieg?=
 =?us-ascii?Q?X8MhinRLao+Y+qs4n7V5ur5FvexK8uuFbe/aHCsOxJp39cED45z122Gnzma1?=
 =?us-ascii?Q?XDRxHoahAWfnPEB8eZB/m+7Vh/tGSDJEydwHz5k58z1e8frDVe0wqBgHv2ve?=
 =?us-ascii?Q?J4THIsoxV9H6G9FX7nq9yjPkNSFXJk+VMhEBy3extnrNpPzEZ4vsBRW7aY6G?=
 =?us-ascii?Q?3uIoLoAiUecCdWSfavJ3wgniuVK7gVCki7wkS6YTdarmjhoQWlii7LAQwxpl?=
 =?us-ascii?Q?oFuV/0faykI39QfBMlJUm+oAkpowm0PYzyBXSGrSTJE2NTvOvm0RRShNZH+F?=
 =?us-ascii?Q?E5GrJCPHI67kvuTlU6YDq+bdY8jBf+U5K1VI9rSDZhGYAJ3ugoKay3yXC+Xq?=
 =?us-ascii?Q?4G2GuA2r53VxsTFuQaLn09a0X4yQblyqqnt2p+aWxNyKfu5Uhh7IgNcNFhYI?=
 =?us-ascii?Q?SjIyQ9CzQ5vy25vPIHZPK5xkblwtipuCNDpf8lSyIrDK5QgQttoxrDbrxycL?=
 =?us-ascii?Q?Shcp4PrS33uUj3us+xnrRIbAaMRo58B/K9JgtcVC2lKi2kHrNKiuwndp7RXU?=
 =?us-ascii?Q?jdlh4mYeCUDLU9c5W857skMJsJtMTH4fLWiFkSGv3dxZzy7KUoFgM6Qix0R3?=
 =?us-ascii?Q?XbJ2ght1RCSrNoc8cLByHqfeT7PWn6osO3MXH90Ga/aeXC/r3secrUQYLDct?=
 =?us-ascii?Q?9GiW6OwuHdNsf78hm/kQI+sn665XhAbhr3nXYh/RagCucLHR8XfKk/VmbHzi?=
 =?us-ascii?Q?ci/cYJv/YJpGT9/UWAXlZOmml9b0aVV6OCoCQULc/kwyPFJ0Ov0J3z/b7WvY?=
 =?us-ascii?Q?MF3mmwUHqdgmYHKBeHoptGBEelbvgn1bNCbeJapWwMHbRh5BnVnKl5Dnj+7u?=
 =?us-ascii?Q?3j0vrAcEX5QgmhwxSVmnUuV4IU3F2wsOzrNVsWFw8WYSL3mdCcDE3LM329xO?=
 =?us-ascii?Q?DF1oqwazAFcfoO2Jf9M0E4RWN0PGdFVZBhATWkU4P8PmD3gr7mftPQOpzefw?=
 =?us-ascii?Q?+tMR0zBbihVjHOUWzIJyQUt9NnyCTCIToA5bvXFyIAyXlku3CW64pb3yHXml?=
 =?us-ascii?Q?m/bLi86kL6MyFS7xQkFnKzSqwkRphtqyYzQD6ACl/X4Yd/GjX+Rp8KRvfEkr?=
 =?us-ascii?Q?TLq+yRqwFnWMG5uHnBo0+fnIgL3u0VaeY2+nCw0MVGsPTjKSv/QieMz3vptp?=
 =?us-ascii?Q?wbIagffozuD6j4cWAVIeMsNHg8WWOKPrBrNlY9AYIAG7T2wNfsBlHcUYj+XH?=
 =?us-ascii?Q?SdwkX2yO19/o6olpquXfhpcAkFvea2UQhlXEQqtif6wQ4oyybSuMVLK6CMoR?=
 =?us-ascii?Q?xo3y8V5baCQaK3Tff4/tS7U9SUX3SuZhvjDZSImqEsFLpRnowI32fY7anEzo?=
 =?us-ascii?Q?A7N0atYSyx5/GHma33fbkBFR2C9nZiVn7x69qOfbKoD1YI7lg7ZiAaoiv14M?=
 =?us-ascii?Q?OeeBvkl0rZvThnesfziZWyTYH+aeT7r+um6vm2EP+7/1xGzh2ndpTDxILSa6?=
 =?us-ascii?Q?eIm/fNdW2H6pU2Y544TBUCWMMN82zrtdhYFjP67EwU/p92ourEDeGYWesl9q?=
 =?us-ascii?Q?qzNQfqzS7fahC0ttSJ0si/vlsACn5JDVznS5VIST1rxL1hoPgGKv0h3/9rn5?=
 =?us-ascii?Q?XQ=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d4344c3-108a-4bff-200d-08db2e01715d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 13:53:13.6254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lCG7REtb9b+b/sQq8voh58d++mvNPxuYDeuQykXWyGZXMT4zfwYQ2hFOHp7XTwV4rCoH9Jd601DZl6AQtYUQqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3044
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update vmap_pfn() calls to explicitly request that the mapping
be for decrypted access to the memory.  There's no change in
functionality since the PFNs passed to vmap_pfn() are above the
shared_gpa_boundary, implicitly producing a decrypted mapping.
But explicitly requesting "decrypted" allows the code to work
before and after changes that cause vmap_pfn() to mask the
PFNs to being below the shared_gpa_boundary.

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
---
 arch/x86/hyperv/ivm.c    | 2 +-
 drivers/hv/ring_buffer.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index f33c67e..5648efb 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -343,7 +343,7 @@ void *hv_map_memory(void *addr, unsigned long size)
 		pfns[i] = vmalloc_to_pfn(addr + i * PAGE_SIZE) +
 			(ms_hyperv.shared_gpa_boundary >> PAGE_SHIFT);
 
-	vaddr = vmap_pfn(pfns, size / PAGE_SIZE, PAGE_KERNEL_IO);
+	vaddr = vmap_pfn(pfns, size / PAGE_SIZE, pgprot_decrypted(PAGE_KERNEL));
 	kfree(pfns);
 
 	return vaddr;
diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index c6692fd..2111e97 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -211,7 +211,7 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 
 		ring_info->ring_buffer = (struct hv_ring_buffer *)
 			vmap_pfn(pfns_wraparound, page_cnt * 2 - 1,
-				 PAGE_KERNEL);
+				 pgprot_decrypted(PAGE_KERNEL));
 		kfree(pfns_wraparound);
 
 		if (!ring_info->ring_buffer)
-- 
1.8.3.1

