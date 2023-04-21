Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B458D6EB038
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 19:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbjDURIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 13:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjDURIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 13:08:19 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020020.outbound.protection.outlook.com [52.101.61.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA4D14F73;
        Fri, 21 Apr 2023 10:08:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WOZIAsabLeElelHpYnRgGESRg03v3VZeYf3/HhWFnWmrmK7+ljwzjjJYf4+keX/Xv+Gg9XTDqNYoDFVMNvAVO/fd6xvVUD5l1BzqmWJTH4pd3o1ZPgooQF1Yux6rBYuft/miK8eQClxRIow3VcRtUQleqWnJaYaQyGOGoYkiwhtoISezkzj/3WeVTHQnWF52QEaonFfC25xdZBxp4lrZjEtelmaGKk3EEGM9QzeUcyxxlMsdwZbVliLLYXp86obeDxNJ3FjRuPe2F0/vCAoE9JeBXYzf/HWTFxHyscBZ6IoEKTHzt85V9ANpH5u/zg7/IOBXw2OQcvSIxhy6Z4CVOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HokZVZmB0QLjZGEZYrBqXZ1bRmR73URn6MkLEm6ke4o=;
 b=YVFnH/qTI1S9NVRVHdvx5V4dwFvnoLIiNu77AA7QfS8woSEeYAh+XxYhV2FCqJgqR7d+EZb/tBK5p2TxvxZge/exjdoBZ5jywrE5Szy5ExOJMeO50doN6LbX3F+8RhCT13BPbg43JljkavxvuruA3KXLFfu+V6lgeJh8UPmJMdZ03JlqBRLAcBf/oVCCNTVZLSpu/acS/Hg97H1IYJBentIYF0e8Tv5xSPvD+MBuf04GCor8IRhab8AZ32pE+/CXnOvUlpxVUc+eL0I4Q2GDYbAOoU0fU/26iUTyagEArgUetHl6Mes9XArl5SmBxqd3Li/rimy+BHM8ZJylr34GrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HokZVZmB0QLjZGEZYrBqXZ1bRmR73URn6MkLEm6ke4o=;
 b=Pt9kNOiC94ZZ+vxYdqI0mO5Qky75xFRJ+H+odQ2MaD+bgHCNmoEqlrswEJ6zyc8y1M8QqkbivHzwrowhm6J+3wNsr9MZn5arjtC0J6/p2rNASbeI72aBwytXGjwBw2fmwFicnXN8rZaO/lXb+ZHAsruu9fxpjFtfgmYQ23qMmAc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by CO1PR21MB1316.namprd21.prod.outlook.com (2603:10b6:303:153::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.11; Fri, 21 Apr
 2023 17:07:58 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e5b:6d93:ceab:b4c6]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e5b:6d93:ceab:b4c6%4]) with mapi id 15.20.6340.015; Fri, 21 Apr 2023
 17:07:58 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        paulros@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, wei.liu@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, leon@kernel.org,
        longli@microsoft.com, ssengar@linux.microsoft.com,
        linux-rdma@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        sharmaajay@microsoft.com, hawk@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next, 1/2] net: mana: Rename mana_refill_rxoob and remove some empty lines
Date:   Fri, 21 Apr 2023 10:06:57 -0700
Message-Id: <1682096818-30056-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1682096818-30056-1-git-send-email-haiyangz@microsoft.com>
References: <1682096818-30056-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0102.namprd03.prod.outlook.com
 (2603:10b6:303:b7::17) To BY5PR21MB1443.namprd21.prod.outlook.com
 (2603:10b6:a03:21f::18)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|CO1PR21MB1316:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d02f1d2-561f-4faf-765d-08db428af4b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8RGcsWHecvjNNsDIEUVzMT6w2ShNZVVRyltjc54KXTXa83NJb88RRcXlCTqWqRRGSzrAqow6WbU/Qvrp5KpYpoBbiDhClb8BwCjRssFyAzrQKGKybC6nc3tqgIZbubZnT4dUQGgAz70mohkxqWDZTmL/XcqNi9ZxWyHXjnDnCcS/zzcYZIzhcHzkm+YodlURr/+vGvrRH0Q3bCuguj+uobrSJlQbHHsrVbj41K2SFSk45Loi1h4MA3mhhsdlvfYY9d0fTD6PmbsaoFLX7SUTFNkujZ0X1GYlEHDkqK1q/80pLsrb/frO2px6GBebNUaqP3m1Kl2WsQMwmZfc65mMWNLVTBMSf3ZSL8s1fw2IZlyQ2WtD3ndhC7yP9btzDnWqFx1xf42K6WzTiu9qd8U170nkXjxWSmC3/mLtu3Z5HJ5FpkJyBh8g2fXXbiREaESJbiryiNEjmlIxWJNfZM2XjAw7EG7mhuzoMrqri1pu3CgyW+aHcCpdj1aS3lf7MP/R+GnlikslARCy3tZztlV4GUWJfaCj0PmG6t958sQSjyb9QUumd5esx4rX6xaXStazy5B/9SKlPeRUJk+doca8ZuRuLgk+nwZZdol/oY9ZShS4t/DZNcQZtB96Je653ztwZTCp1eJwksThYkkj7nlazre/2VT2/SRtIGNaoXwtnN0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(346002)(366004)(39860400002)(451199021)(4326008)(66946007)(7846003)(66556008)(786003)(66476007)(316002)(36756003)(6506007)(26005)(82960400001)(38350700002)(38100700002)(82950400001)(6512007)(2616005)(186003)(83380400001)(5660300002)(41300700001)(8676002)(8936002)(478600001)(52116002)(10290500003)(6486002)(7416002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kxugOZ8Fz7bdcYHAy+ZB2W1XOJgb0QqqUlZ6nY5jp7CeX9GSVTgw6HPZk/XO?=
 =?us-ascii?Q?+Xbao+8Bq5tonCSCq40wnDqY38aXoRZTqEKLv04hiEqTLVs3aO5kdY83xkw8?=
 =?us-ascii?Q?B+UUU2wU1zERaMyNoG25ctvnEFYcZ6peWrWgKi6VJTYScOAapGf2BXVpqcqg?=
 =?us-ascii?Q?kmYbnWfIE9aRukMRtIQHSMoHoe7A+pJiaMOCOCp5T9Tx2b4pz66DONbz9NNy?=
 =?us-ascii?Q?zbKLib0gFd5ZbqPHnCPuc6X+Ns4bsCSBN2YkyImL8wW7FuQ1ZfmbuzTlXT4t?=
 =?us-ascii?Q?VpiZ2epXuiAK/iSIa4APczZXyJCB/QNZWipiGj9GO2vTgEcaV3uvuZihPls5?=
 =?us-ascii?Q?gItP4va9o/jaoBzp9dnPsBblCZ8T6NzC2iHDKZXESjzMIxOuuReUguDcX7x/?=
 =?us-ascii?Q?hq5HzZ57t4OcAumVhJvFmxvVx1mnBAyhKPggU6yu/M+N7wpSXbv7l2+ZcF94?=
 =?us-ascii?Q?MCmOP+W/MsgnXpCxorkDCsQPxPAwtOKw4qZEyx/ji/EDObpMbeGRZKTtfgqj?=
 =?us-ascii?Q?4P9frCTEY800qGpqfevLlWH7yIMuTiYtQQcAg5ZE9QdPlqMyqNhT6SHl/0a1?=
 =?us-ascii?Q?YmTFmFpOWqYBXivCvtKA/5T1efQFac0i8qO/DLUSkWDvJeNuU9VpA/XUrOD3?=
 =?us-ascii?Q?cxdl02DcOvSmuWio3g4pm4t7eS/xDNsAgQSxzImueS7Ez9J74Z7nUOmJGKQc?=
 =?us-ascii?Q?igGLQwPmJAYQnabXFyg84/mC5/miUmBnYDCcaLv33yrhbkjSzP02OeBw/F0W?=
 =?us-ascii?Q?JGHEvBqUYHS58EbwHKnLao2BWp/1aG6URTMrNaZThRkVUh+w/GbHaz7wGDAT?=
 =?us-ascii?Q?3fkk+e4hfA0LtIKr3G/pHVqvQT8qIl9KpbEEq/xVOywSZzLtWMdHx6s6zdlu?=
 =?us-ascii?Q?YzGPe/qkwyGa/IxyzepesghFIvKw0KuDwpkIi4nQRPGfDp5l+bs/U4C6Jj9P?=
 =?us-ascii?Q?vXL7qUjybzUZK2j4pz0OwpHER+W3yt1KFbfUL9Vz9DBw4WC0H4tTjbuQv7iK?=
 =?us-ascii?Q?lDfj8TaNQLSYzyBRo11fderu1EZO2dWxd3NLwJ3g2pUmsporvZA3NogqwjwV?=
 =?us-ascii?Q?QZqo44YWGUkqWWOEvK0R01fpuublo+Yb9+2WuOO6XppGhx4bZhqAwFKI/S0f?=
 =?us-ascii?Q?hGTdM4rsunKlWWsk30bBgxDObv/8yghioaIC6CvpEBnqH8f5jWNqD8O9Bcnk?=
 =?us-ascii?Q?rUHQXUAHhytdTGrnkysGnfgWVZdkx+zJokegybtYFd5GbLa2gP3U0wJPZ5oS?=
 =?us-ascii?Q?DOrPqMSB3tiN06bX8t9JvwE6SGfQSa9iR6BcfNKmTV3xkFA+s0dbWiMuA7iD?=
 =?us-ascii?Q?Bu3nfB8JLsE+V7Ul4YFqRbr76pcBqEGzE0Er4DNTLnZ+pvbBFC/rEBIR1Pt5?=
 =?us-ascii?Q?jtrNKsBoFxZajhT4uwBGN7AeMmmha2FT62CcqTWiiSt4EE4jIp36c8kHbc3A?=
 =?us-ascii?Q?VVkHDHi5lhjM8Gq1qppVBadWAf3B2aVCTOFIDYYdKnKq1Vj7XuvhZtcV5K8c?=
 =?us-ascii?Q?VK70YJi1OoFlBvDzEJOnCWome7wHzb5mMC5/UgUvh8FjuqAABmS50ZdP0V/R?=
 =?us-ascii?Q?FipGxjifGWP7E+YtY5hm6989FmGBGIX1hT0l3pTf?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d02f1d2-561f-4faf-765d-08db428af4b3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 17:07:58.2586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 30LjWCM/a9AnyTtW7KW+KdV/RT9rK8o5CaavhyrhWdAi2ujXdzZBv3uoL5B1YBIHPKtuCFGJVGeX0TpyZToj7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR21MB1316
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename mana_refill_rxoob for naming consistency.
And remove some empty lines between function call and error
checking.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index cabecbfa1102..db2887e25714 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -563,7 +563,6 @@ static int mana_pre_alloc_rxbufs(struct mana_port_context *mpc, int new_mtu)
 
 		da = dma_map_single(dev, va + mpc->rxbpre_headroom,
 				    mpc->rxbpre_datasize, DMA_FROM_DEVICE);
-
 		if (dma_mapping_error(dev, da)) {
 			put_page(virt_to_head_page(va));
 			goto error;
@@ -1515,7 +1514,6 @@ static void *mana_get_rxfrag(struct mana_rxq *rxq, struct device *dev,
 
 	*da = dma_map_single(dev, va + rxq->headroom, rxq->datasize,
 			     DMA_FROM_DEVICE);
-
 	if (dma_mapping_error(dev, *da)) {
 		put_page(virt_to_head_page(va));
 		return NULL;
@@ -1525,14 +1523,13 @@ static void *mana_get_rxfrag(struct mana_rxq *rxq, struct device *dev,
 }
 
 /* Allocate frag for rx buffer, and save the old buf */
-static void mana_refill_rxoob(struct device *dev, struct mana_rxq *rxq,
-			      struct mana_recv_buf_oob *rxoob, void **old_buf)
+static void mana_refill_rx_oob(struct device *dev, struct mana_rxq *rxq,
+			       struct mana_recv_buf_oob *rxoob, void **old_buf)
 {
 	dma_addr_t da;
 	void *va;
 
 	va = mana_get_rxfrag(rxq, dev, &da, true);
-
 	if (!va)
 		return;
 
@@ -1597,7 +1594,7 @@ static void mana_process_rx_cqe(struct mana_rxq *rxq, struct mana_cq *cq,
 	rxbuf_oob = &rxq->rx_oobs[curr];
 	WARN_ON_ONCE(rxbuf_oob->wqe_inf.wqe_size_in_bu != 1);
 
-	mana_refill_rxoob(dev, rxq, rxbuf_oob, &old_buf);
+	mana_refill_rx_oob(dev, rxq, rxbuf_oob, &old_buf);
 
 	/* Unsuccessful refill will have old_buf == NULL.
 	 * In this case, mana_rx_skb() will drop the packet.
-- 
2.25.1

