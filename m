Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4C66B1976
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 03:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjCICoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 21:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjCICoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 21:44:09 -0500
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021020.outbound.protection.outlook.com [52.101.57.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29F0D4609;
        Wed,  8 Mar 2023 18:42:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iWzrAzvisnaSWGjEJZui8j6Ozr0+xAlBE3WaSHrsn3QH+Z8/iRcmTVeU2k4KbtLm2OjgiPHEHEXLySMngjXEaxGTxBxhhlCBNKG2G/S/JM5W3AuKJmwFo8GwwEN11HQPlWicfmF8ETcTeHCcK7Gg7xWaEfkA71Mjn5grlEH0ziucDUHZ+X0Q15CsmqDugiEtxmIboBYBKdRiW3fofeSCQIrA6wnQs4zgaYnl0jjMcPqDrYzEhxTBru3OgO2vFrQjvNt+pi5WSEdQ8H0J78xr7XhvuMZFxpm87IfMG0L7iZ7PurdNHriHELN7DhrYo4ACe/18TC1WbJGCSQVQ3Y3i3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ogveo7t/IcowXK13Ts+Z+XPBvrmc2pZAZdqL5WY6LIQ=;
 b=Ffay8jNFAdWm+zs8frjhsk4TdUJp5XihsW4VGK8zR2c75kkm/ShzmMsIQ+hIbGmSZ/HvQMGfjtwpRc3hHMDngmPfo27TE5hW0VQRC1jc1c5dVdlRVeFmvYaTf6ohThzFxgzhNWGc8r4Tx0/laX3v6JH8AknK2Hr22ALbrEemwuFrgbWSGhMqlGHFiEYKxpzUQvb6nzn9HKcaw5ZE6SM8hkydd8Wkkn3I/3xzknd/dDhzdpmMXmmw5Ol12n95sqjf8nxQG+SL7N8QRIv0kaMVNO49u6HolhTlEIJY0vGDI+TGNOlX30bzz96zO9fjQ6yIz7rOR1ujJM5aebDkuO2hKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ogveo7t/IcowXK13Ts+Z+XPBvrmc2pZAZdqL5WY6LIQ=;
 b=INqPYVLObfsM9Ld5clXRjEHuYyXGpVNNeCAnd0+tB5hhiElZ12S9eca5J2mmvdpI3SG87GAI5/GsuElG8Vpkgx4+CawCN5WoRvyJdTLNHVjxE7wR7rrq+vTjpnuqC/r7QPjoCUYwj1Yo2fDwFQlov7x2gzXOMBW5sBQRq74rTfE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by BL0PR2101MB1313.namprd21.prod.outlook.com (2603:10b6:208:92::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 02:41:53 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::caf1:81fb:4297:bf17%5]) with mapi id 15.20.6178.016; Thu, 9 Mar 2023
 02:41:53 +0000
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
Subject: [PATCH v6 09/13] Drivers: hv: vmbus: Remove second way of mapping ring buffers
Date:   Wed,  8 Mar 2023 18:40:10 -0800
Message-Id: <1678329614-3482-10-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1678329614-3482-1-git-send-email-mikelley@microsoft.com>
References: <1678329614-3482-1-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0008.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::13) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|BL0PR2101MB1313:EE_
X-MS-Office365-Filtering-Correlation-Id: e2eddb81-1bfc-4c56-ea38-08db2047d795
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zdr1wkybDb85VRdpDsCW+4hPoSJYfFJJ9xnKgLTlEFZUJI0afZahZF6kpDXSytDNsWSQOsvzG/3xM7h3RaH4MNP3s2jR7wybVrjEh6MCWUm89uWFb+CIP2WeWSt4mZulzMXNzAL9A3tUd4xGp152t8pJihe5amd8A6Q5GPiarsh1QXt7Be+NfUO5tiAQduBZBvIdTN+drh0pJ2KjG6B87/4cIyPhqYpEbC8+j50R7feH1SynMUqSBB2GXLFQK92pUXVHv16CBQIEhwS1MfoYrGDZibVLi7ZuFMjryGm1Xavjxh3+xj5YNbLBQArCyEQYiEAEMC0sCfBMQb3lzZ7532FZQn6riP3bD/Q6lrfdTPjcTt+72kTLkPIpl60Q3uhhlWmeEi+RtqXQF46qpiZ9pfGl0krdUW0Urexrh0AFB/VjCthDYOtBQWWnOJ3XU1y9ooKd/Gb7JKgltnGFhdL1kzA1xj0aFDil+Dc8miFXFEvP77n4d0CdLhSMOU32odv+wU8QmMUYf0vm3TMK/3him19MqI790W/1S5wkZDKe9PD6rOtstsLoX4LtwD+RoNI6g4Zj5QhnMUFQsCB9OEbGrR5J1XOgx7WpNiC9ZmiTEaBPBYWsQ4L43ZRuKE4enad1lUFfwWrTE0+9k2er7Qfbwet1f04OdGkBg6nRpkGcqqGUQfYbt426NxCGVx3oxI7+Ag6YgO4N0F+SI4nBqAY70uQLu7aqnRXtdxabomiq6X+PqVbDDvYVNPD6y1DT9AptrDZf6kqgiLPmjiXfuWg1aw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(451199018)(82960400001)(82950400001)(83380400001)(36756003)(10290500003)(478600001)(921005)(316002)(38350700002)(38100700002)(2616005)(6486002)(6666004)(6506007)(6512007)(107886003)(26005)(186003)(7406005)(5660300002)(7416002)(41300700001)(52116002)(66476007)(66556008)(66946007)(2906002)(8936002)(8676002)(86362001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qUnBF838IqXF7s/cMsglZzCEyY6LKgfE+PHNJ32qOVo6xlaJcdVgiNTLRM5+?=
 =?us-ascii?Q?v3EdT8NZ8sBF7FNGcQquKFmTKsnc9zL83EA72vbMqTNqW3sg9B330DQkQv5O?=
 =?us-ascii?Q?V592/j04kneI8+XL5JMOUEy8HFli0zPQJSVYF3W+IL7t4Nj1Wsh3CmwoK8DJ?=
 =?us-ascii?Q?shzSXD4SEamuryEfFrUj9ov4+1x7vv9FmfA4//kNiy+QtvKofcANQh7bkOQb?=
 =?us-ascii?Q?+Ak9SDYELlQakz3j65Eb1gYqmkAOw7Mmi9q9IUQRrJ5GUd3kWK7YLqL7qLp8?=
 =?us-ascii?Q?m4JJIdE/CEFuBI4kDy0skxRz4qekfwjre4QJ1EpEoj1pT+skp8aZA9fsh4Mc?=
 =?us-ascii?Q?zZ8s03URndPff5DGvgmvYQnJsPoPmMa4Jr1B2Bi/ppzhrVxKYqGgAsnDAwwY?=
 =?us-ascii?Q?ScXVGdajpeUCrPdMmW0RGogD4xP7sbjl26HKM9uIyb7ExX2F+zezy8rynO6R?=
 =?us-ascii?Q?XgmMg0l3sd87p443n5+dAZVqdEAObXMcn60KCXBynmmIBk2I59EaRMS5sdkD?=
 =?us-ascii?Q?4bNW0McrbZDCYqZUhRZbzAUZGtDgiasFrxnpBPZseuK6xlw+1pDun3GpSp+t?=
 =?us-ascii?Q?EsVssWHlpEX9AUtIehopruBHDDCTjetIK26QTmbfowcYP28uLiFerHcfZ5E/?=
 =?us-ascii?Q?dpdg6ly3j6fOk6ribjOoq8E+ox4jLVzF990sRnW8DeKQbWPUNQGfgSSELlNb?=
 =?us-ascii?Q?GjWLtlalBlHUY6KdQGU/I8C6T27+j8FpyG0wjiYEKnePDYB0t7XuNUS2jI3r?=
 =?us-ascii?Q?B1WvPD8/cq351goDoub4qLufF8jXx9uANXWdJIB/d5CvJ27v3MIifxxc9que?=
 =?us-ascii?Q?iPN7APbtEKKiHnP3+HkkL9RwCvi6KRMz0Ol8Qg7ila4Yr2hh+QSHtODzdD5d?=
 =?us-ascii?Q?5X3KcLDeX/JKGFsKforJAskq1Lar2rwnmw2lt/wHNmvKeArYu1EXFa1srEDQ?=
 =?us-ascii?Q?1XrZ3/nCr1SLNUx7MwlOuBXxekKQhhbDADf0nupmo4AdkL8Q1HFiLkI4SJFJ?=
 =?us-ascii?Q?gEykLHbHinBvaetl0py1qChPnob2E0LIh9g6OC+H/1P/nPuxWT90epMtmv/c?=
 =?us-ascii?Q?MNQezJ3F1VN1WE2c185Qmqi0sRF+ocW/skAjO60ct111GbLC3tE4k9tw+BFN?=
 =?us-ascii?Q?vpkziR5Vj7Epw29iDv5KeTlqmszRUfJHf+jbkcGCFhc7Fpez/nlFqRsiwJSF?=
 =?us-ascii?Q?efIpTBYJv2FTgydXcKKM/1/6cl+1+0vvkTRYoZp4o0aVYh4uZk9EIfoy7sHO?=
 =?us-ascii?Q?yYsfHy732x+d/Htxw6J5AL/M76SAacngMpSXwgykbbO3ARydTIeluZaKEp5G?=
 =?us-ascii?Q?ok1vNEg3w7LGDLHFNxNyZnxJ0lbjX6nc6GufqhbXO5b15y9zVryFITDzmMV+?=
 =?us-ascii?Q?Z7Xkd2C7qsyAeZS/zK5A4ruvXotK1emm8qVq6Lyt7IvxxSMhTXnTLQSZ+TsI?=
 =?us-ascii?Q?tLEB71dBf4uciR6s9s6XBgyG/hAEHFI0sxkzhCQTBWwNIu4Gj5G7w2ACrSDv?=
 =?us-ascii?Q?8Qp+MNKy7+OAIW3eGLhUsLwrYyM4WGkHzuFZDqOUyfgyFR3mTtFECyy6hd7G?=
 =?us-ascii?Q?ezZl/nj6EJv3L3rDVgCGtRk6ATkaddqkbt1qpnAf4zAyy7sF+mncosEnHVB/?=
 =?us-ascii?Q?4A=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2eddb81-1bfc-4c56-ea38-08db2047d795
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 02:41:53.6916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mnOlyPA9pCG4qeAQ3cGyNYwz5sCSV0ZQdP4ET5vonX2VmPX15M0kougC2f41WWXJRsw/UFJjOZsCHKBKSCBeZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1313
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

