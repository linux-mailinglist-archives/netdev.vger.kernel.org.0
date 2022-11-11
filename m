Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 975F7625395
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 07:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbiKKGWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 01:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232729AbiKKGWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 01:22:30 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11022022.outbound.protection.outlook.com [52.101.53.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF9A65E56;
        Thu, 10 Nov 2022 22:22:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GVcGn8cyaQGiWKjphjLfA7sl4O/5mulT/YMgxdCm/eUu4ALoXUgNo3mYN6BDYrfQaII5kKKgXs1paqf125mtqlIDb8y49u5fSK6dsF/G4BqmccTZ0Mj2UDo2NXk1LFcw6ossMC7rqSv5yLBZUOtQ6JH0CcGX+XndTV0qKXE+rldC5mB7q9LdUJu8auYssaAlXnA+6vEKHR8vxY/ocl3ns6CuQSEpOL+xSBNK1aaTQV40iJbBsSwIRctNCohXpN2T8A4g124CI0kCceqB0mDD+fdM14tEQCT58k6DNSIxRNDK4eBSUDi1ETF7u7P67x2DD7f6qk5HoXS2kBmnSyjelg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a+yUY1oU7EZvlInJkWwCVnIM5lY35B5anu5GgTI054E=;
 b=L/naLONsWajIBztUnkDr8tz8+Cenel5dH4uNatIzih32Jy3Gsui1br1YLWkWO7YrEGbLoNeKSjt7oRnafdYEDduH6ZHatmo41qDGCERFaVIJS5WZ4/UIkNqPcIAiL6pKmhr36gvBXEyUnFg4CVDLYwajdF31aAZKkBLUdlkFOebGSwlE1E8y0Bhc4VMOi9qbIh9o1E+clOh8qPtgNYKqjysdguf1Owdqy/vd6LJKm1DcXzx78Mlr0R42+pWgz/I8AovDt5GE5N3hxalmknZhsk5yQ4Zgt7yJf14I2A49eUbhx05mFVFWB3TXBkc+Hthv5nrt22LAKoi6mF6hOh1ghg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a+yUY1oU7EZvlInJkWwCVnIM5lY35B5anu5GgTI054E=;
 b=E0gtpm1EhC7ibUs3psSkDfoZSmKAQrvqUD6TK7/6JKfclIs4fhwyeHzuf6Maosi6c1GE4mRMUZ2x1cbkzSGsROSG+7z50cjt7X0eTlGFmu5i83Ms1MAhFGYqxDQ2/cMa06IKHqtxOb5NcFu99PNsZvuFbGLMwVsJE1DbzsyX90k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.2; Fri, 11 Nov
 2022 06:22:18 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::c3e3:a6ef:232c:299b%7]) with mapi id 15.20.5834.002; Fri, 11 Nov 2022
 06:22:18 +0000
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
Subject: [PATCH v2 04/12] Drivers: hv: Explicitly request decrypted in vmap_pfn() calls
Date:   Thu, 10 Nov 2022 22:21:33 -0800
Message-Id: <1668147701-4583-5-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
References: <1668147701-4583-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0329.namprd04.prod.outlook.com
 (2603:10b6:303:82::34) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|MW4PR21MB1857:EE_
X-MS-Office365-Filtering-Correlation-Id: b20950c9-8e52-4d58-e334-08dac3ad159e
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K3P1qiXVjXqAKBRnzvRQEVcWO0E0fIj+6/OuuUAoc5sof06HL9CMTMoGVz214Zj1JyEdKqTwImvZUpRS0bKOL3SQybvtTXUXPKiOO6GpDlbbz4OSsn7wl3a6UmxM7Pv6m1IAnY70/5+xMjN0pugXaHSRQherdA75jwIt5juDloR+PLdkrchNLrbZuBPQkqD80f5MZ/kFEHgQWn7xaHeHmodRvi6AuDXDu1+nrV/OezGJ0TXl/Gx5kqvlS8QzpP4H5JszlOqs06MFtrkLwf2E9vxAPf4TfpiZkgGqM2bxoAmybDDMokraRK0kJWzbmEe81wSFTvzRya+cE28ZAxDFEwGGnR2cngFekxuhuIr7mnBNUCc6DKrZTku4CIlICWvkPicW2+KkFUDuB9i1HZKKZHomqZjHHQz0nADfMvI5NMEmnT5AM6Tv87SHBtU4eJsQqpsbXW9PeqZelqmVMd0XJvTEhnSfVZIa9Z0W2F52LEZrhIX7AIrafitaLAcdlraOd51vnz0fjNFvdleWwaISX8HETmdju1Thdmy7a/oysBULym6xSSNKsMCA8hJ8KU2wKyXW4f78pnmL13kwu8vAAe7bRfHSpMieyuij9uSEtPcvyEAO5E2UCuhPo49tX9AbQMJ/wrm8Ill+Galb+ItIW2EkolLj1pbvaz3qc4Eg9HrVJ2E4Qg0jmX9t3nNvHcuf6XTxN3KIbi4jEnIuCCLjT28HlVt0D1c3Clthp3RVAJDCaRmjEd8dCVRx+t2V3ugZUAplyXPajs/dX8XWo2tNMRr8iW5VN1FJdrEIcUkarrFnDDJ6SjpPLxxhDDYSs607Dwn7oDOXIqhVOBbx94L/8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(451199015)(83380400001)(52116002)(26005)(6666004)(6512007)(186003)(38100700002)(107886003)(2616005)(7406005)(2906002)(316002)(7416002)(6506007)(10290500003)(6486002)(66946007)(66476007)(5660300002)(8936002)(41300700001)(8676002)(4326008)(66556008)(478600001)(38350700002)(36756003)(86362001)(921005)(82960400001)(82950400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gSMAxW0hTsiGVmbKBekmBDEz/vKFo/lo4scH4AstgErLImAG0WsIPjSM7NDI?=
 =?us-ascii?Q?AvBezhP1jCrnPH9Ch7mPdPvsyWKHxXUsG2fIPJw7ML5OAcq9tIl1h2F4PC2t?=
 =?us-ascii?Q?WgKh/0wqOqmxzC40kkjIfoqdWfzRWDdG4f5z4i1AC9XFYAGP8rLN0/0u7Lg/?=
 =?us-ascii?Q?YM5HtoqytZzkIiUP4eYb2iIES099w0+d5UQnPHTNb6K4XP5ZJr40gjtpESN8?=
 =?us-ascii?Q?pbdU3CuyrtiC1jlbBmoTVNwPFHaXyOgKrP2nDpm/j3f5ITJe/wUTnmNDWbGy?=
 =?us-ascii?Q?HP47lWUjPv/3xyfS+qY5U9uD877yotI0nf0gFm5kqVTrULZ4Ft+vGR7FToKz?=
 =?us-ascii?Q?qlxa1jH+SruFx1RxL9znGhPfm6d7FajBjr2qVKv44c41StVeLFWt4rExm2zG?=
 =?us-ascii?Q?6tjBwgq5iNOkhNNig9leo/JED4vpUP9VHp6i1Z6aCQTUgYozVW6stHRkUCFi?=
 =?us-ascii?Q?We0JQPErMtJMvyFjmz2QWf6sztc09FcuXZ56ojIJwVUQxGklK2UhXokiZ6V5?=
 =?us-ascii?Q?lWcpejY+GduSaOyAb8En+y4sNPPeOzsld3kPJ+ELendp6M5cmy33nCOndBSC?=
 =?us-ascii?Q?ioTDHgEHlX28hiJIv+2Ebn0MgrYj9MoxbqCXptuAGWdGPwbOvXGcdBLwPeeE?=
 =?us-ascii?Q?Fjz/siuz1g9TW/46aWcAaKwaX/D+KNWbAnaAhXrYqz4RbIEDKEDDnC8zozOc?=
 =?us-ascii?Q?AJyf6CKA2azOWxoGxyrqFo02dUgKW50LTBILPdu8lbMq8DK2qxvKwyok6Typ?=
 =?us-ascii?Q?Q0ul1IDeltSJcxMeOipnaAacyTc4D9JSeZD8mRnKLnfbz3F+7rPImvbfBU1W?=
 =?us-ascii?Q?Pg/hG+7OWGeE8dsZW/PGcr7Q/0RUEbj/g36HbWi+p7M+c6QSx9UonNpt5amf?=
 =?us-ascii?Q?m126glyjsaYC0+L9020b8q2mG3+1NY0cnO2R5/ksv0HapUCP3vknrBbKsZ54?=
 =?us-ascii?Q?HieW4wFwNEUXCiSQG9MtwQltiMh5wFOVqThKHoZe5YngFqlAL+NBtz4qVej+?=
 =?us-ascii?Q?6HbfsB3ZhloB6DWL6iz7RvybTi4Z8e2SkwvMb4j5CDtStdqud60JP61Ncn/O?=
 =?us-ascii?Q?EfkZpK0CQB3lwuDgbkaFeTY99vbBzTbHq9SQDSW79fSCDcJ2UpluGrsAHbMS?=
 =?us-ascii?Q?TjRrZ2xGZbk7i6YUww1AqlKgXIV4lsQ3KYmmscsxa6h04t5oR0268d/JoRbO?=
 =?us-ascii?Q?Eax3U15c44cx+V4K3B+0FPD3DnhgV5uvke+/IujCJDim0RXJFZ5TUzIRUiSh?=
 =?us-ascii?Q?l0teeVR5P85CXKN6zaHMwB3ibD651YXyZI+gfKv1+nlVs4e6e3cP/YO8XmPF?=
 =?us-ascii?Q?qQ41BTGPNM2Epg2BjogcNh0HjhcY28xPIv01ALaSyD9/WQSGIGh+l+cwDLCx?=
 =?us-ascii?Q?1COAIwf6x1MqlaECKETg+7bpWq5IOWbHeGIZlyRyi84CejTa9aSsoQqWqvt5?=
 =?us-ascii?Q?c3qe7N53w1xwcLW/+Eo1N8qE1JQspRVypPHp/ekbyRTJ3yrF7V5tGJfWoiti?=
 =?us-ascii?Q?6Acwj+OcntSKSVaz7Ag+IoqUyVaAjHajubwe0qcfmcjyYTYm1hSH/o2c8aKY?=
 =?us-ascii?Q?9EVKcm9fd5SLGG2ogeZgFGH7LrW9eNuVS4HkTVNCEg536U+Vwemv0TidpH1O?=
 =?us-ascii?Q?dQ=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b20950c9-8e52-4d58-e334-08dac3ad159e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 06:22:18.7870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CturQpzSe/Is6w6zyRsmLjJnndvA80h2yeQySKBdgEfgIC71pfAt4KQ0sUOZETQx+tQuw73NBqXF6M81N9QZXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1857
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

