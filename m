Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A324606792
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 20:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiJTSAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 14:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiJTR7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 13:59:55 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11022019.outbound.protection.outlook.com [40.93.200.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305C21EB542;
        Thu, 20 Oct 2022 10:58:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bbKWJ2ahj+hMI6+Y5mQjp/Ods7M9pAGw+CPc+3JLvo5qHoXgUpMqSKGis8MJUzIYcKqY/46dbq1+INwznyqHELXlrqQa/n6RxJFXkSgxc2ufSd8nRWop5iAvj8ctTCAOY13fTbR4mFsKtgH33pGnW3mROO8NczJel3iNeNEeb2PBGa7PZzYEd5i4osWEnS3QSsSIsL0hDc3PSL3ZldSrXKYXJmLYzspwrV7jPvG9M0leIq8j/suQhhDLJFZFCJEQNq69wTEPSfafRE5mXvSUmd2yRw65jGlZjFOKtaiVVjQQ9e8a5MewGkR+4usGX+gCm/473JouZpG4kmS4a6EdQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HxJ8C3oTdHyjmsriP5KiVxO5k6CUwNZJzZyGZWis3kU=;
 b=btym7Ecp0Y0CO0TLtJV1D6MhLsd9WzKbCdzWDI+ANFgiKfmSxqHab2HwXjPzkGYr1mkMN0sWQ/R8WL11gl2fkI1SPfggEG9TrfRRXNSkeXWXb7LzOtnWPTRBzCnFzpjSp427mbeRDXHp9UaoEzJizQ4SfWkRdy0s82hu3RGxyMrfP0WiYJYnbQIgsaHouNUeY2SWXx/l+/15XncRLdrZZd+jSgmjiSiOtpUAEe8o5LyT7kwIsQ1hfPlY2OERHKtQZcc+DMfnhVpTCPqrRH1sAla9qdUN2pfkBfr23HqI0Jng+3m+4akQDRRRLXeMsqYzkBiKBXt47/kDUFV3vFD7HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HxJ8C3oTdHyjmsriP5KiVxO5k6CUwNZJzZyGZWis3kU=;
 b=afP3SQy/kHh5Dul1DeUV+YJWDWaiYpSWU0cfyHemXCg2Pfw1EnVWV5l0OS5V6UkE1KroEwgoEwMjjk4GMDlA+FlB9OjuoLYUcw/gt+HMM5UVyEono+M4CIUJVs8zy0k/HCrT8/kjU4tA6f458OpmCAXUhp5uAMhZ6yfjqfT4UZU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by MW4PR21MB1857.namprd21.prod.outlook.com (2603:10b6:303:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.17; Thu, 20 Oct
 2022 17:58:39 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::be79:e2dc:1dba:44fa%3]) with mapi id 15.20.5723.019; Thu, 20 Oct 2022
 17:58:39 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        luto@kernel.org, peterz@infradead.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lpieralisi@kernel.org, robh@kernel.org, kw@linux.com,
        bhelgaas@google.com, arnd@arndb.de, hch@infradead.org,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
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
Subject: [PATCH 08/12] Drivers: hv: vmbus: Remove second way of mapping ring buffers
Date:   Thu, 20 Oct 2022 10:57:11 -0700
Message-Id: <1666288635-72591-9-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1666288635-72591-1-git-send-email-mikelley@microsoft.com>
References: <1666288635-72591-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:303:16d::31) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|MW4PR21MB1857:EE_
X-MS-Office365-Filtering-Correlation-Id: e9300016-2963-43f5-8bdb-08dab2c4b7af
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2UedVTZwPVZup/+B3I+GCrQ04u1QlDrkoz74NV02WzZkqYvqFGDkSHtc7gPRhzD78NgUgdM39uXve9mA/SaqHYu9IP05fACqezq1YvwFcKJbDKWtdBCHgAbDOsKUB0/uBoLTEGDKMNn8UcrOBvAznwroQDKSG2EQDehSnbckkJc4byDl5xJUCAgT1M6BIuylAReQ33Te9xVuwWpGtz6WpScZsNS39YKZztjrnp8FGh+AHX/RvNbhNfU6OL/qNg3COoaanrb8rS/2RJL1pe3BF3M6TyQi2RPYRX+sd03QwOmVk4no5nGRlF+TrUPVIZ7gtGVophrobNGw0frlfY4dU1nf+TuReWkWTbniqN7zelHpYz/tbDYy80aovDSbLKHiOHOs7CSwv3bzkPwJmIU/IR4cDbHUUXFamuLPu8cWpVXpb8940pwoEh2ZIi/z/HNbvs9dQeCWsQo9xQKbtnbh8d4I0BYxJNAfLT6FzTbXKZWQek+Xo9KEOtkIyBMnFKXwUdZ5akJN32kU0bJKWnaE+MhcXXuLwqJzKp/f8D43RGEQVkINjmjLv1zX8GkkMwmm/GCCqh6Mv9imw9EpQW123HPAqk4FvqyCzPqN9/4yon8ja63PY0L3zi7jyPRHYjiKSKwiWU2bFMPHGW3o6Gh3vGyO4xuGgIORxuaL7uZmtVK9X4SsWkymTjcMePi4QkW2b3dDAmqaioZr/8m4Rf10HmLrnX2E7OFopb7u8SPJOjAyQQRg4r+Gu8ntdf4p4o1eKbMCpdUZhakTLLiq6FtVH8/zUuUOfX4/yphUZEmHnmM5ttEI1b6Bov2Uo7CvSEfyk9D/wk7mB+kJ5zIDc9zZwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199015)(186003)(6512007)(6666004)(107886003)(83380400001)(7416002)(52116002)(26005)(2906002)(5660300002)(6506007)(66556008)(41300700001)(8676002)(478600001)(8936002)(316002)(4326008)(66476007)(66946007)(6486002)(10290500003)(82950400001)(36756003)(86362001)(2616005)(7406005)(82960400001)(38100700002)(38350700002)(921005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0ax73wboF2ftmeUuCMabcf9O9Aj+tJouZqd/UdNtkIrw/eerTnExyB6j/xLu?=
 =?us-ascii?Q?1rx0rEY9/mKdY6jcFmvtkL4xNWgL23I7vCef3UqA62yN6oPkQMWj6UHsTO9L?=
 =?us-ascii?Q?Pzef/N2q8/66ptslWz8LnZxjw0z+tk9id50yhPqYd3tYCz0dKJ/0n4ksYtQb?=
 =?us-ascii?Q?ftpw9lor2RWzxah3//XAqlIRPsa9exPonzT7BtBUeI8yBd4am3UMreFu8kM8?=
 =?us-ascii?Q?VLFHTHRo+lOHjeQ+oalCJa/TEcTSQE3CVTM0n8ugUGZEYhWx+yzNvzAfC+Nb?=
 =?us-ascii?Q?RM0cuTT+2EsWBr8fgD9yLtpQ+LPJ5KhhawITiezm2X2ELm2l5gVm0JL9L4K9?=
 =?us-ascii?Q?ZWwUZUIMWral+igx4aIiD4dkL1ZP59qADzH8f5AA0qLPRfX9n3aODPcYerDg?=
 =?us-ascii?Q?uZkbHiJ3uEL/BiGkOfANfYUf8770giZY+sOcLf0pEQxKNEayvDjguEVDV8yF?=
 =?us-ascii?Q?EWLeKmKWCn5pdnhJ3JFJzCVwR8G8+yWaCghQyrkb+ckXdsSQc4whOvGsurDV?=
 =?us-ascii?Q?F+KbGQmwBKQn/tKPDgywTIeb9jNYv9E8ZawrxGkD3hphh/ypObrLp7iBb5ek?=
 =?us-ascii?Q?YYtCnrWV3strnC8qmRa/yzNiZYt9OOEC/NWUxrmaIUzyvXPC7BYbJ01qyajP?=
 =?us-ascii?Q?52pAwR/gDjS8i8tid5uqoxojevEgqAhFT2mgLkFX5lEcTgGtsuzjoUQTcFnZ?=
 =?us-ascii?Q?acsO3ViTKW1F+Lnst92oU4Xx0LQs2QPOizIE0L3PgY2nWSN4PsfF+Q2rmOqn?=
 =?us-ascii?Q?uW2pj9ypZmsNKugZvq2UUYVnvl/cLsE+ReyENz0AVXSL+CV6yn5RXrjyH45N?=
 =?us-ascii?Q?aYzC7wx3TScpsSBYQSAB0k5cFgM/QnNy9YbbO2Qu5Q2ieMRixO3xXYK+sWTf?=
 =?us-ascii?Q?viw7TvYBt2ya9C2Xr9idRGRiH42FlX6N+Lc8RGfiR4WJayMttEP+BjbEfC/h?=
 =?us-ascii?Q?53UvLLuSHLQ/jbgSgnXdNFhW83rpto3wQrJVIT42auaGZVhXt7cMVi+/Xd2a?=
 =?us-ascii?Q?IcOGwFh6dvpaH0fDHKRR47ciRAz4ctvJHOSuKqS1gi5RnJhgvP4FKfUFLg7T?=
 =?us-ascii?Q?ecI33HH9IM5y8Malk3+sRdmpK4wqXyMCw4UrdpkTFhSUUVlzK5N/kGWwVaen?=
 =?us-ascii?Q?ngz8APPWY00M3UxNEDuZfGZ7b/A67FvGl9uJ27sHV+XVF0X1iWL6sMdax1jy?=
 =?us-ascii?Q?OIQ3lDD8S3skkPfG5TDgL/73bYk+YfxOMmCV7MyF818dQNGxhQcWyHl/2/qR?=
 =?us-ascii?Q?fZtl8AS1xAFNlZ2MY7gkrxIM9ZCP77hhRy8mRSK71HlMB4tIul5LwJNdRHUP?=
 =?us-ascii?Q?0bGlht7ioWV3t/GY9/kCcx2Bc1dqu0aqAGnmEWnTOcEqpxIqKFO9/I3NJ51x?=
 =?us-ascii?Q?RI0M6WO/XJwCJqs+hwBqYtNe0riLvKmhLvm6NY2OfIsWqsL+YzPdhe5wMdBZ?=
 =?us-ascii?Q?HaxJBE9aNlBRHObmA3Pny1WTCe72f2VXe6DyIvJ4hQwdEjauwT9ZlT78YM1E?=
 =?us-ascii?Q?TApurLV5Yl9czRBBFWLP+4L8obqIeTbiALukYgnGSX1sJwg47wfyq3tnklm6?=
 =?us-ascii?Q?oDsGjGDUh7Zty5+BGBGopuh5bETw0FLTlT9iqqoD?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9300016-2963-43f5-8bdb-08dab2c4b7af
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 17:58:39.3759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t4qlx55nTvzptZ7mZlrTYVx8eP2JC7jY8fd0x5yTZI8LZ/lbfJUNFSuoxdq3WOBegKlzYuS9itE25OxpyD5CFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1857
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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

