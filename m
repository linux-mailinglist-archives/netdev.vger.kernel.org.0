Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF026822E1
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjAaDeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjAaDeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:34:20 -0500
Received: from DM5PR00CU002-vft-obe.outbound.protection.outlook.com (mail-centralusazon11021022.outbound.protection.outlook.com [52.101.62.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3931B2D6E;
        Mon, 30 Jan 2023 19:34:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hzNhfaoESEqEC/LgvaikcW1VCkl2TWaNPiOv3jgzlEAqKFiwkJ+ricQ0jX6+mRC6mzp+YVKjVbjTNPs8Ts2mwQ5KouoiL/RZUf2LW8PK1iHtWqkCEKDNon+zM0AIpzrrVPzBvu0hPCZnwRq/hGBUqsLuijZbdDaFGocM3MTcH83wcmr241eBLPGCGZF/4kuE6rX80cQyHcu7C09mIS2EXldqGeRKNVIi7gE/mWn38R/XXX3Wii8EJz016R7thCfTU5Up6F2/X7E/4KrrvF31SyO365Vk0VbP/9Df7ztPmrY1RRobsXcWCEkyqS31PUX3HWl342zSOBf9sR5iYPYbXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B1TN/soyJxcEfUdF7pZ8jHLorMgnT7s4953SnsHBXLw=;
 b=YvRo8HWlNy23+L+mKK2HQIqAAdkKr4tpeIBL7UwpDWffNQJm1PyPlBLoa+CHb2lvn5rhF/16Yq8y0HiKyINYLzG/1/FywZoOKPGsyhnDU9oRTu6qx5SUPgJtBf5i2zdl69jVrLZiUgBqL8gBQFWRcQWoTu0U2O4zhyS+ojPWlfryKRcA6zV5/YGqA4m0YuM7VjLhvhg6z695BBk0doP5jrv337kNDBfNrg9Kzl22VuEQwV8j+IhoOYMQR1ShwRFEmJSxVusQNkQ5wVhQ/QbSotEGWUTDaMOU2K9cJoc3aI9yP1OsHKJGcgmEGjA3qEwD472Vs1tT/Q0Ol/7QDuLySg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B1TN/soyJxcEfUdF7pZ8jHLorMgnT7s4953SnsHBXLw=;
 b=ECT57UyBpU+8uOoSDD+GXCxfubz2EB9ymLZ88avioO2UJTV/HZE140GAxkZGA6wve3SVa47GwWS4U3qTd2JrHJB7Qs0C9K8HNpHQUg1cRIl+PkPTODQEhCoF/Jz4EehgCMB2jrOQNkUVnkDL7nq53bH/2RyxrjAXVi2z0PQP4dE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by DS7PR21MB3150.namprd21.prod.outlook.com (2603:10b6:8:7a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.3; Tue, 31 Jan
 2023 03:34:17 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7%7]) with mapi id 15.20.6086.004; Tue, 31 Jan 2023
 03:34:17 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     mikelley@microsoft.com, stable@vger.kernel.org
Subject: [PATCH net 1/1] hv_netvsc: Fix missed pagebuf entries in netvsc_dma_map/unmap()
Date:   Mon, 30 Jan 2023 19:33:06 -0800
Message-Id: <1675135986-254490-1-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0055.namprd04.prod.outlook.com
 (2603:10b6:303:6a::30) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|DS7PR21MB3150:EE_
X-MS-Office365-Filtering-Correlation-Id: 8048df16-08c4-40be-4952-08db033c07cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hj9+g3hDK9DIjRkx95hYfZqpi8e7Uf2cCfatALXy1t/3Ha0ZHW4BWS494/tIqUGVnm6A13n+MzKj6Zk85cWtTv3tVWheFJuSLudEuF7UYBfx3qoiN2xWEUBkl+QOWr11VkQCCwxPE4jwOnILsTycX1bHA3dGhTFGFoqkcqGujAJdLbULHHiGFaaBAVpH1euu3OQtUCHb7tibK2MorUY3QzM7QqIxx5ToWqBjekdeMmWaqzeNwfOK45olOoGLECDECT3tyQieB9yE9IrxKyFTNOj47MYe0D2+7uQBRbEXFtU1KkPY1bTBWQIh1XK+suYrd5/hhh5TYvXybpLzYXBLCa5o3wgl/1sqpUMnED2IRpxwVQRPLHNrKdd7yUtWjpctejSaur9LxWNjwDLGzUJjwu/93Pii0jlSiVrwqVYAzsdzKHBYJUSnDCmmH+iBpOLC2J/hvTqXgKOxmbHA+IYOLHpGcgpasZkc1DQ6rCxxBXpW6EvkhcJ3FtNprLWG0P3unhU+XHI7m3ImXYWSBLgl9BktUMeJ8GD2DfFrAFY5r6EBf/RVcD09JeiCVyJrKthWKSCqmlSqWwCN9HOE3T2dD4KKQe8o8Id4Y86a2o2sN4/R6c/OiT7iXdX/zDmJyzlc45C6Tg/aqSrHmK/2tcHNiylHm1mkfgp0LyF189p8u7d7iU5xaju5ls9LEouEY5+g2HTv7wAu/S7xARM6SPNle2nS7+xI/LzigfZlL66yzX/gjMcwBBAoUpTikPh/O6uLPi2V7xHI9AzEl1mQJBAgwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(451199018)(82950400001)(36756003)(38100700002)(38350700002)(82960400001)(86362001)(6512007)(316002)(52116002)(6506007)(186003)(83380400001)(6666004)(478600001)(26005)(10290500003)(66556008)(5660300002)(4326008)(2616005)(41300700001)(921005)(6486002)(66476007)(66946007)(8676002)(2906002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OW5kR1hvNkFucTcxeGYxRWNqbXBuVHpYZ2pJd3h5bzlzNFhmMkE5Z1pMNXJu?=
 =?utf-8?B?QmFmRkxnSkZuNWVyOWtrTEt4QjVLRHFPc2lhM09QLzhENC85MlNLb2E4dEEr?=
 =?utf-8?B?aVdJeVN4Rkl6azdLeTBoRk5DaU9ndFU1ckZ5MFNqbDkyaCtuRi9PUXl1Y2V5?=
 =?utf-8?B?VkRjcTlNQy9pTG1kZzk0YlNvUDlwTTArdXJxZzczd3hMV2ZiRUE3SjhaT0Ja?=
 =?utf-8?B?a1ZTVmVqdEtONzc4SnNFZE9ScEQybWhodGVpTlNua1hOaWJmMXVUV3dSNzhy?=
 =?utf-8?B?Z3VKVFJqc0F1Q2g2M1BNcFFxRmNleHkzYXVZU2ptUFhCbEJFd2p1U0J2TExo?=
 =?utf-8?B?Z1ZzaTkyVGpOY2p2Sk8rVGtpbVRDNDNZc0o3SU5uc0pSUDQ3RXRzbkh3WDhD?=
 =?utf-8?B?MW44RGY2dGo1MmY1Zk9QdVpkTW5sZ2F0N2didldYYVNrQlBCOWdmQmY5aXEx?=
 =?utf-8?B?ck4vUUs4bHdrdUl0NWNCV0ZSSE1LNzZMRHBJOWEwekZyNER2VG90WFF4Z3N5?=
 =?utf-8?B?UEJhbVJySCtrYU1UOUVlK3dIRHZmdnpuMC92SzNwNk94UGlJQ1QwSGhXSEtT?=
 =?utf-8?B?UXpuR01DOU5rTWp1Z2NqZkcveEJkRC9ld3lWVzFncDhtV1NTRW9kL3NCYjY2?=
 =?utf-8?B?UWRCYWt5Y2gxTVBtNkNzancydTQ5TGNtREFzeUJzLy85dURqcFlTajhLNmtP?=
 =?utf-8?B?U3NsVTlRbDlkcXpwUGk4TDRVV09ZWFJ0ZVFOZmlqZTRiRUtVYVVkYXZRaFJv?=
 =?utf-8?B?SXA3ajh6K2tTeHFKN0VydjFtamwzVGVwM0VRcFZPdXpOWGNMUTVVaXNGUlpZ?=
 =?utf-8?B?N2JYL0ZoamJWYUhOY0JKMjg5WGNROWluaklqMHdubm9mR0d6OUZWTklJNnBj?=
 =?utf-8?B?dytRQmM1VnZXRTUxdkdxcFJNSDE2QTR3cGpYTTg4RmJnOHlvVUlGRlBENnRz?=
 =?utf-8?B?L0FteDhkOGlQZThrbmh6eUJXa2tBbEJleGVLMTFGVnFoRlc5STJiQmlQWHU4?=
 =?utf-8?B?aUhVa1hCcFRrY3dWTzdTQlovUE5zU1VQSnB4UWk4WEFOT3c5MXFUU1JRRjlE?=
 =?utf-8?B?aWFNRFNoZ0N4RzVYUnJjVThGSTF4UWN5SDZ2dWh5R3ZxNm92dHVONjFwTnlX?=
 =?utf-8?B?aldxRkN5NE5ibkd3U2hOVjNTMnlqbjM0eDJnYVR5cHpnT3ZhcnJKSHBtc01X?=
 =?utf-8?B?KzdsL2tmU1BiQURkUmxuajVnR3J2KzhjOVVOZ3pYVys4dkhKV3kzWHc4RFZn?=
 =?utf-8?B?Um96aXBJaG1MbzFVd0tudHRHNmQrLzlwTlQ0Zi9QTmJ4SEtNTUd4eVh6OXVI?=
 =?utf-8?B?WjkwQk02M24xNGk3TzRHUG9ySkVBSS9uL21Hb0dMdDZYL212eHJVYTN3Y1RM?=
 =?utf-8?B?bmI1NnFjSVlHUXBhb2NFMUplaFQ4cm1IWERURkJEOHRvZFJ6bzVRTXArc3lz?=
 =?utf-8?B?NXRuVUZHbHJEbTlVazlSNVpBSEdpWkJkVHVPd3lxWGlDamJySEJxMm0xb2dN?=
 =?utf-8?B?cnZHay8zS1MvR1J1NHE5bmZuMUk0VEFoYk9TOE52OTQzTGpDMFlpVFBiTEJn?=
 =?utf-8?B?cXdMeWRvVEhxQkFnWTJScmt6eTcwY1pLNW0yc1NvYTJJZDBkbU94VlV5QWlP?=
 =?utf-8?B?T1VMWlRSenZsTGtRS3BaYkJZV3liV2c5V3lEYjJmdjFUL2pzU1lWWUxlalh4?=
 =?utf-8?B?V1lJUnE0TGZHQkNZTWs1SGhhcHBkTGJxVmswTnFBUUxSTkxQZnNla1NJV1ZD?=
 =?utf-8?B?TS9ZYjU5YnRpeWtrNUgzRndWMzBjdE5YMFVBVGorUFQ1UEhOaDBuRU45Umcr?=
 =?utf-8?B?a3dxN1pLWDQxMU5qb1VwNzltVGN3Q0lvRG1TNW1ZQllvL1lsRnp3QXRKNGdQ?=
 =?utf-8?B?QUVyTHpHRWtkSGlkenJHMEFQQi8rbGtRanpYd2ZNbmRSdEJWUmFLcGRaNUI3?=
 =?utf-8?B?YjE4UVZyR29RV3pkMkdPL3hQa3ZFbFJqeHBGbFZYN3BiU3AzaUxJS0s4Y29a?=
 =?utf-8?B?dzd6R2tzTkpNRE45TzdPU090aUN3dWR5MVVsMjFPUDcydjA5S3ZxV00rR2Jp?=
 =?utf-8?B?ZWdXWjB5OXN3S3pqOWxKQWFBVjFIT3YwK2pYRUFWVzBDV3Z4L3NMSXpULzhl?=
 =?utf-8?Q?ZIcss/X06zbvZ3oDLbMBGRfov?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8048df16-08c4-40be-4952-08db033c07cb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 03:34:16.8459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JlUXHo4QxcCxrQ83Nq5hJ5n9lodjLUNsQ+H4Y2igZms5YpKH85m/Dij2wEc/Nl6ph7S4h63K4/JP3Y3mZIroYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3150
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netvsc_dma_map() and netvsc_dma_unmap() currently check the cp_partial
flag and adjust the page_count so that pagebuf entries for the RNDIS
portion of the message are skipped when it has already been copied into
a send buffer. But this adjustment has already been made by code in
netvsc_send(). The duplicate adjustment causes some pagebuf entries to
not be mapped. In a normal VM, this doesn't break anything because the
mapping doesn’t change the PFN. But in a Confidential VM,
dma_map_single() does bounce buffering and provides a different PFN.
Failing to do the mapping causes the wrong PFN to be passed to Hyper-V,
and various errors ensue.

Fix this by removing the duplicate adjustment in netvsc_dma_map() and
netvsc_dma_unmap().

Fixes: 846da38de0e8 ("net: netvsc: Add Isolation VM support for netvsc driver")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 drivers/net/hyperv/netvsc.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 661bbe6..8acfa40 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -949,9 +949,6 @@ static void netvsc_copy_to_send_buf(struct netvsc_device *net_device,
 void netvsc_dma_unmap(struct hv_device *hv_dev,
 		      struct hv_netvsc_packet *packet)
 {
-	u32 page_count = packet->cp_partial ?
-		packet->page_buf_cnt - packet->rmsg_pgcnt :
-		packet->page_buf_cnt;
 	int i;
 
 	if (!hv_is_isolation_supported())
@@ -960,7 +957,7 @@ void netvsc_dma_unmap(struct hv_device *hv_dev,
 	if (!packet->dma_range)
 		return;
 
-	for (i = 0; i < page_count; i++)
+	for (i = 0; i < packet->page_buf_cnt; i++)
 		dma_unmap_single(&hv_dev->device, packet->dma_range[i].dma,
 				 packet->dma_range[i].mapping_size,
 				 DMA_TO_DEVICE);
@@ -990,9 +987,7 @@ static int netvsc_dma_map(struct hv_device *hv_dev,
 			  struct hv_netvsc_packet *packet,
 			  struct hv_page_buffer *pb)
 {
-	u32 page_count =  packet->cp_partial ?
-		packet->page_buf_cnt - packet->rmsg_pgcnt :
-		packet->page_buf_cnt;
+	u32 page_count = packet->page_buf_cnt;
 	dma_addr_t dma;
 	int i;
 
-- 
1.8.3.1

