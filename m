Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A751539F96
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 10:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348357AbiFAIfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 04:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350874AbiFAIfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 04:35:13 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2119.outbound.protection.outlook.com [40.107.94.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835785A2C1
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 01:35:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXDR0OS1EAoKZvB067cW83lSH8V6NDsuL/wssNXrZVTWb6FcrmsN1QTSEp7PCrXGL6OCQsRo9oIF5plTk7RSdan1wUEpIzrGYyAsg5yGRuGpTAoJAKUnG5sQQnAPPM/hdgny27WY5oA70Fcyp/uawF0OldjHxNyed0Rrhj9rcX5I5Aub8GT5tfDqpCL2vvWZF0IfjaKyiFBPRCiJMzsKdUlLWAxC8OOXlqkihhjDrfedC+QORcnhWM5/CznVOSvmngZwimBhspLMU55Y4ch4dPzbIZVenaVWB3bsxkcVPrKe2yOmqemsoSU8s4k+fXLc+OTM9Diwh5Azcz411e758A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aCu0FnC9w7aR0ZSs4YTfi/XR5c6h41dL24uoM/FeMto=;
 b=dl04fSgcvV2kek9aQui8DiEteCRUeF34IZ5RFr0DVDIdI+5nyGCjO8SG955hrYqQgacrsbXwMvMO/9IOw7chApA2o4pgoy/ue3kgdeYwWrd5mfoN05C/T4LzL1ZHxgZQYqRhJWMLu/Tr9WAnkEdcG6ZkD+dJffOruzTzc6I8u8sE7OH4BexsXCOREvvTi2m/meuRw9gxCWnUUOYl22yH6YpLkr2KXuEmzzP5Xr91dsrIwkwwdtGBTccBkWnFoCLe7Rf8PvH/tZpeEbumLjKyJ0Bjatt9ihnNk0BlrpK41evFdr6JLRDzUP/CrhcHxdEIzuveRrSqoZ7t1aozk4gkAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCu0FnC9w7aR0ZSs4YTfi/XR5c6h41dL24uoM/FeMto=;
 b=HWTmZG5PFM7Emo2sMGQMetdf9y7tce1OpxagZaH39z08q2rQcRgkyZCtN417mY8roSHYnU8Xk1/mMBhDcrx8tNRFsLYxmkUhM7c3Q50ngp9J94yoipLkp9CXDgcPLgPp0dN85AODEhkBt5yomch96VZ+udYL1GNvbOc1Au1Xd88=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5542.namprd13.prod.outlook.com (2603:10b6:510:128::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.11; Wed, 1 Jun
 2022 08:35:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%7]) with mapi id 15.20.5314.013; Wed, 1 Jun 2022
 08:35:08 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Fei Qin <fei.qin@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net] nfp: remove padding in nfp_nfdk_tx_desc
Date:   Wed,  1 Jun 2022 10:34:49 +0200
Message-Id: <20220601083449.50556-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0016.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6277178c-0413-4c87-32be-08da43a9a25e
X-MS-TrafficTypeDiagnostic: PH0PR13MB5542:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5542F226EF78452BC4637DFEE8DF9@PH0PR13MB5542.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bk6yVk016nYNqceL6AtqD2IDZXaJAkyzBS9N6CijpHKQ5icghQ/UXqfT8MsCRnljH8kBWfk1cmmSkE6fo5Pz5lKFy4vb/HpqwSUvs/lJ0pMwlfvZDTchXsljdbWv6XsBqK6msNU2xF4u6sfZJnaH9ZINR2/ks0poI0IvB6e8raBjYvd60SNGsE01pmT3EC5FcwDDUMFGNIRs9VafENB5n4Iph2FDQRLXqPx5Ak4bzzLMMaWrOnwVaphrd9xjs0QiY6EfdasAuHpRM37KlGlpnJ3oM8Ae4DZs4pkQgEtaoLQSY51+a7Qw23kgedBucuCFQHEejX5nnbdK8Rtg6azrEk8fed5AWACUWMXPBu0Co6Uv/H8ZPZ+nhziMtwJ4poC/EpiMwx8X86ZFDOrkb6HUXSgLMl+RdwvF8PZJZOpJe/ZCERXVEXUSF3BIR5WBmAi4xaSs8o8WhlkNxElq40Ej47vTliKwdNPbhULaicaJpq6NFdE/72R34rA2RNABKRoW39KeUqi5F5v9CYYvNycqH5WG48Etjp0M4BX+yHwF7MU2gKLpPezr/g98hNnrkfdlRO1P04mBpFBc5PlYDApx9B8JRorfPUPjrLMmWsqeObbk2B35QU1kZwEt9fIfhnMOB5LoNBfbQGh5N8jLM4gbKLdoHRPRGUa+FVTP3SNNt60DGnU8BatBQ+lTAozmHDDr9ICH2wxFnqecmzoz3vaqCudziB3V5SL4N23AYxpsqo/TJI+0Nfkg9dnaStgjvAJ1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(346002)(376002)(136003)(39840400004)(396003)(66946007)(66476007)(66556008)(86362001)(38100700002)(36756003)(38350700002)(316002)(54906003)(110136005)(8936002)(1076003)(4326008)(186003)(2616005)(5660300002)(107886003)(52116002)(8676002)(83380400001)(508600001)(26005)(6512007)(6506007)(41300700001)(6486002)(44832011)(2906002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sURztT6SytYEX3Dg8qDHu0x9TH7xvrfTUJKfYEBDhu4Irk0sEhzEshh7ZG58?=
 =?us-ascii?Q?GjYy5+aXv6l2L5nDw992YOR/nsqVnygEq72kwjfPaxiSer5bQxYfQE1cDQGV?=
 =?us-ascii?Q?Z6XmZxtAJdMFwpgnwY5ZeWQaRgi30D3j9JBdT7Wi1tBYR8/CFb860aP+hDvv?=
 =?us-ascii?Q?BXOxBWD/50t5Kwilmk2WpsqityHRjsxRQQsTE0VFTZL984GHN2MPMjQ1Vh7+?=
 =?us-ascii?Q?jcgYko4eEq0o7s6QLD+s0bCZ3OWsi8rXbv+Ab+ztXehndbgLsI8APXhg7XYv?=
 =?us-ascii?Q?0xUkdePRAiWw6oJYiy28VRQkDohX3U4/ZR8xQfSgckn2QWQmNpter7iwmiGR?=
 =?us-ascii?Q?3Xh6RsCjut5NmhjmOgasSh6Zt5FufDssvCyeBEq3s96wZwaASDd4ht9KU+tD?=
 =?us-ascii?Q?bKa2GCOp1MKo414Z9whXtCoPgnGRTaC9FC5isFdIXwA4mxN4qW87e1NmYQOj?=
 =?us-ascii?Q?R/Euo+BD1x2iUxRUwQmM9v2drBE0xRFW3HuqIrdY+NN+uaLOUC36JWn5IbEm?=
 =?us-ascii?Q?CsNqL8ceFWi3eCwfqKlreh9IgU9+zKb+lwHwOP3QuyvRaWAS4SqEuk28jInj?=
 =?us-ascii?Q?M71fWpDtT5CuP2aUqEmCRVj0GIfqCAeWdg9TdB+FhzP+KAKP4jaRprmyiaRa?=
 =?us-ascii?Q?MmJaIb/fITGysv85fqaadYnj7tYSWEZbzSIcQYOsMrCGWJngXnwcEiPTxhDn?=
 =?us-ascii?Q?wOIuugBRP8iLsJUqH52+5kzbifhnvA78UL8zEpkHXKEW+n/x2swBHfU5fA3i?=
 =?us-ascii?Q?aQZ35b3O3U9pG8AJyiiL70ynTLl0v8fxf91Vzq9N08BlMzBOaTNZ5D3I/gDF?=
 =?us-ascii?Q?b7P/Bl0u9ODsWXqFpIaegrQvSUCxnSjL5BbsD/IP5AiTTWcrdHRdndRyuZqK?=
 =?us-ascii?Q?9ur9+zK2G5XJCTNVHV9zHNIn6UqtLRmHA1yIDRiyfWKJ0jgsdwU9nrjO+Jj+?=
 =?us-ascii?Q?58Qmq91N8A6q9HP4yTpatiTXU6r71uZQAuMbO1lWTesjbjD6Vsb40wrNDhHH?=
 =?us-ascii?Q?nbWpKbFgHybYRRS7mFcm0htFYiL9KPi3v24d4auL8olaiXDfE0rhySwv3Wca?=
 =?us-ascii?Q?hIXHCyqRX8XHFHBlwN9lBT4VtDvatw8SMtBEpo2bsVvMyBun8KSRr0P3Rzsj?=
 =?us-ascii?Q?O8Hg0bYYwXGxvj1keGLaJxbMw7kvWc6Q4fiBF/xI6ykOAnb5bsSF1jkAhL1h?=
 =?us-ascii?Q?LfqZK8VEJYj3jul1QdIW1zy6vi830BuvRAaxAsEtOFtn3rKOJb1hmy5UPFPz?=
 =?us-ascii?Q?q5UJW+E5oJKrQnixeaUhRqXz4pp0H5nEqiJeYG7YVqnyKYTowT+44QLzFxKz?=
 =?us-ascii?Q?dpXzJDI+xbiRk7JrV9TQlGY4vD0eFFWeaF/1PiRDvVac6kPhYd+5W/8C6nvM?=
 =?us-ascii?Q?SPPS57gQ/cDJjgBgqkyQDlvRAqAAORg73FlgzfPW9QqATTQTyBjuglOhNNGh?=
 =?us-ascii?Q?NzS3grmfGhCaOxpaXhdhoGQWTj+GuOrdvHbD3ddfqw4FgQfHrUwM7zS57CEX?=
 =?us-ascii?Q?BURsEjv6o7nm7Ff/MN6UHbj6JxB0sN9jTKc3ntrP0yg3h7GxTo+GsfhyMIZa?=
 =?us-ascii?Q?rO9MAwozG5zhvAl0f018HotIZZiaEMe8ZIic7Qo5VkrFWY2caKGH4u8wU3UG?=
 =?us-ascii?Q?Ej33YHXbr7l+PjZCYFtgIN/g/0wJQUxXvaIllSmKEhYMFaAF4ULSG5WJR8UK?=
 =?us-ascii?Q?t4GgaZurtJqneRygImSNyuNMQaTy/3HtyIWIPsNXVT8Tu9hK10aMjn45TE3w?=
 =?us-ascii?Q?YH6gZsYc4D7jjEVz5tQSxKdYyQ9OMR4=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6277178c-0413-4c87-32be-08da43a9a25e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2022 08:35:08.0212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h1IBUk9AW1O+y8YQZmtS3ZkzahHWY4EBkzo8K0BAdKCeAnzntDluyC1ncirx5ag97HqUp3R9ZbXg+4S5WXdWK8w/OaYZ0uuR3c5wCr8ttGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5542
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fei Qin <fei.qin@corigine.com>

NFDK firmware supports 48-bit dma addressing and
parses 16 high bits of dma addresses.

In nfp_nfdk_tx_desc, dma related structure and tso
related structure are union. When "mss" be filled
with nonzero value due to enable tso, the memory used
by "padding" may be also filled. Then, firmware may
parse wrong dma addresses which causes TX watchdog
timeout problem.

This patch removes padding and unifies the dma_addr_hi
bits with the one in firmware. nfp_nfdk_tx_desc_set_dma_addr
is also added to match this change.

Fixes: c10d12e3dce8 ("nfp: add support for NFDK data path")
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c   | 12 ++++++------
 drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h |  3 +--
 drivers/net/ethernet/netronome/nfp/nfp_net.h   | 11 ++++++++++-
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
index e3da9ac20e57..e509d6dcba5c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
@@ -314,7 +314,7 @@ netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
 		    FIELD_PREP(NFDK_DESC_TX_TYPE_HEAD, type);
 
 	txd->dma_len_type = cpu_to_le16(dlen_type);
-	nfp_desc_set_dma_addr(txd, dma_addr);
+	nfp_nfdk_tx_desc_set_dma_addr(txd, dma_addr);
 
 	/* starts at bit 0 */
 	BUILD_BUG_ON(!(NFDK_DESC_TX_DMA_LEN_HEAD & 1));
@@ -339,7 +339,7 @@ netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
 			dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN, dma_len);
 
 			txd->dma_len_type = cpu_to_le16(dlen_type);
-			nfp_desc_set_dma_addr(txd, dma_addr);
+			nfp_nfdk_tx_desc_set_dma_addr(txd, dma_addr);
 
 			dma_len -= dlen_type;
 			dma_addr += dlen_type + 1;
@@ -929,7 +929,7 @@ nfp_nfdk_tx_xdp_buf(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring,
 		    FIELD_PREP(NFDK_DESC_TX_TYPE_HEAD, type);
 
 	txd->dma_len_type = cpu_to_le16(dlen_type);
-	nfp_desc_set_dma_addr(txd, dma_addr);
+	nfp_nfdk_tx_desc_set_dma_addr(txd, dma_addr);
 
 	tmp_dlen = dlen_type & NFDK_DESC_TX_DMA_LEN_HEAD;
 	dma_len -= tmp_dlen;
@@ -940,7 +940,7 @@ nfp_nfdk_tx_xdp_buf(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring,
 		dma_len -= 1;
 		dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN, dma_len);
 		txd->dma_len_type = cpu_to_le16(dlen_type);
-		nfp_desc_set_dma_addr(txd, dma_addr);
+		nfp_nfdk_tx_desc_set_dma_addr(txd, dma_addr);
 
 		dlen_type &= NFDK_DESC_TX_DMA_LEN;
 		dma_len -= dlen_type;
@@ -1332,7 +1332,7 @@ nfp_nfdk_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 		    FIELD_PREP(NFDK_DESC_TX_TYPE_HEAD, type);
 
 	txd->dma_len_type = cpu_to_le16(dlen_type);
-	nfp_desc_set_dma_addr(txd, dma_addr);
+	nfp_nfdk_tx_desc_set_dma_addr(txd, dma_addr);
 
 	tmp_dlen = dlen_type & NFDK_DESC_TX_DMA_LEN_HEAD;
 	dma_len -= tmp_dlen;
@@ -1343,7 +1343,7 @@ nfp_nfdk_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 		dma_len -= 1;
 		dlen_type = FIELD_PREP(NFDK_DESC_TX_DMA_LEN, dma_len);
 		txd->dma_len_type = cpu_to_le16(dlen_type);
-		nfp_desc_set_dma_addr(txd, dma_addr);
+		nfp_nfdk_tx_desc_set_dma_addr(txd, dma_addr);
 
 		dlen_type &= NFDK_DESC_TX_DMA_LEN;
 		dma_len -= dlen_type;
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h b/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
index c41e0975eb73..0ea51d9f2325 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
@@ -46,8 +46,7 @@
 struct nfp_nfdk_tx_desc {
 	union {
 		struct {
-			u8 dma_addr_hi;  /* High bits of host buf address */
-			u8 padding;  /* Must be zero */
+			__le16 dma_addr_hi;  /* High bits of host buf address */
 			__le16 dma_len_type; /* Length to DMA for this desc */
 			__le32 dma_addr_lo;  /* Low 32bit of host buf addr */
 		};
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 428783b7018b..3dd3a92d2e7f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -117,13 +117,22 @@ struct nfp_nfdk_tx_buf;
 /* Convenience macro for writing dma address into RX/TX descriptors */
 #define nfp_desc_set_dma_addr(desc, dma_addr)				\
 	do {								\
-		__typeof(desc) __d = (desc);				\
+		__typeof__(desc) __d = (desc);				\
 		dma_addr_t __addr = (dma_addr);				\
 									\
 		__d->dma_addr_lo = cpu_to_le32(lower_32_bits(__addr));	\
 		__d->dma_addr_hi = upper_32_bits(__addr) & 0xff;	\
 	} while (0)
 
+#define nfp_nfdk_tx_desc_set_dma_addr(desc, dma_addr)			       \
+	do {								       \
+		__typeof__(desc) __d = (desc);				       \
+		dma_addr_t __addr = (dma_addr);				       \
+									       \
+		__d->dma_addr_hi = cpu_to_le16(upper_32_bits(__addr) & 0xff);  \
+		__d->dma_addr_lo = cpu_to_le32(lower_32_bits(__addr));         \
+	} while (0)
+
 /**
  * struct nfp_net_tx_ring - TX ring structure
  * @r_vec:      Back pointer to ring vector structure
-- 
2.30.2

