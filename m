Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA5F2F1199
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 12:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbhAKLhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 06:37:43 -0500
Received: from mail-eopbgr10070.outbound.protection.outlook.com ([40.107.1.70]:57742
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729760AbhAKLhm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 06:37:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hxAK+RuDplIWIiQUVjuV7nxuCTaMV8ckCgC8YoG6ToABjClvqdKmygAIL8Wb5ke6PHJp3ITQHRUeWwdDbDrtdKR6wDLsQNlZz9OoEECvh5vPX2zK448mSMHn9aN1gCoGHc1f1jGeXDnc6l658jylrAPKI6g988BzqqLEQATF2uPk1qnUY0F5ThY6LS+T4+Op6Tm0Ely7hOKoXzZFwnTY072tN9lbvcUtmOohy6MRHzmYjP5RZdQDBV7+7VTp+JA0/+YyA3kLyHjgT9uG1JgtIr/GKU8NJbmZEm+RCIQY6acgjJ1m52ltS98o5zYM2qEZDm2kjZx3ozINOjf5oxV8xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQHH37juAr+2j8jNeRVJt0TEgDe/mPuItrnLw6fochw=;
 b=IheAMznTy33W/nhiLHm86gbrXjbhvsc9ntV08XXjcLjOnhTEdP73GV+ki6z5rKjcmw+dctGxu9qcyqPa6NeOAf0j9Xy8MVKrO8qUWrVFj1tHsfo2oFb3Oh1tWkk8BnkTOdxRQGSaNQwbs4WeB8SW04h4oOg2CMUbqsU3JwESZURkQYMRPF5cVu8f3k/O1Mbhs27gOXnhTj66RrC4e4fwlF7i0JkMnXaXNkK5N4Mleqm0eqa6hj3fEh/pha2C7qgHG1/iYOcmVFS8Vl/R494KBSF9ebdGr5LnkX2E1gKR/62bDHYM+R0VJf/HQ1um5kRxGbfb2Guufu4Pobng3vx1SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQHH37juAr+2j8jNeRVJt0TEgDe/mPuItrnLw6fochw=;
 b=sYE/nX8FBMp9G7zOl84GafvsmMfW1PRRW9te8yTG84/ypbPsUZTS9q1V6cu+U2214lA07zH2sFPzpFn3cz6+r1I5em2OaEoU9+E6QpkOA/NTdjm6iINMkhujHULN4Uza7k+Ahs7/pDc409sXwk7zliNw6SqRnpsWj2QJY1CmJto=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB7674.eurprd04.prod.outlook.com (2603:10a6:10:1f5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 11:36:34 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%5]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 11:36:34 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH 6/6] ethernet: stmmac: re-init rx buffers when mac resume back
Date:   Mon, 11 Jan 2021 19:35:38 +0800
Message-Id: <20210111113538.12077-7-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210111113538.12077-1-qiangqing.zhang@nxp.com>
References: <20210111113538.12077-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 11:36:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 879d18bc-5696-4734-bf7f-08d8b6252654
X-MS-TrafficTypeDiagnostic: DBBPR04MB7674:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB7674517AEF9C5E5850E9C663E6AB0@DBBPR04MB7674.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HU6CFUdiZNbNk0RfJRzPtuLOcOifDjklnH9ogwascdqsLbILt6biO4XQtQKjR9dCjMWMdSu9lSkoMOGauAkUHGr3tnQX++YFSmiiOycKRlcHUVMJoYrilodLWpsvuIQS89sP+f8o2JAgr07SKyf3zcsGBNKUXQYHMCRI6koRmjkykgVV8RRFkW7zikD2yqI6rwxbeUBFmoQLMKRsb5xyjXoTLrFT6NaflkaMyQZrz909t8K5GtmFB+b9Y6xdEaSJBlnith/wdnHSXb2yRDdScrsyzfoz9B92+lRcrBBgKU+iB1Ok8hjbQWx6W4xczZVeMVbOa07HhYrUpJPrnfS0Q6oROkJKJs5Ohj8uLQC0RMdDdcNNOlVMgXnyVdBv2HcJp1qIJVPQWrfJm+hNTGiRUITz14Jy3xeZWcLyD1lnE0nCE2RSPUYxJExr2Mxs6h8Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(66476007)(66946007)(6512007)(8676002)(8936002)(86362001)(16526019)(6486002)(66556008)(4326008)(83380400001)(2616005)(36756003)(52116002)(69590400011)(1076003)(478600001)(956004)(5660300002)(6506007)(2906002)(186003)(316002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1lVZxsAiS2KAmN/+5VLKf8J3NJfWcKNI4J9Mn4EQobdE5Wfp76eX/XQg/34C?=
 =?us-ascii?Q?iTuFddC+jOX5P8IYtj8Pdx77WPiI+Am7aYD6r2yRI97Bv9vfYaMs14uytQq7?=
 =?us-ascii?Q?F1GjNba16CJbJ+IuaTNHZqNUwHwdSHzCGGgoOwZy3o60X6RTvr3NrvM2GIPJ?=
 =?us-ascii?Q?e+OIFVtW/NraDH4F6bmop4fSLV3kr6MOkfzXWtLBy9TzG7byLIG6gFR174po?=
 =?us-ascii?Q?fSRnHdYFeYRJve1R3z44C7QC2jrYt3xbsCim5OTG2fkTyeuUfTfd2paF893W?=
 =?us-ascii?Q?T7e+oNsfS2h4GrIabZJTXuzgTbhU/rVA++t5ImH0Autx0pkWkCnHZg5K2gbM?=
 =?us-ascii?Q?L6+1XQdSlLeV283IDuV9b8A4CZr+A4I8oHB5PKbgOXcyxuJOZQg8I7TYSSNU?=
 =?us-ascii?Q?QR4Eq0K/u1gNCuhgYlJJjSzMY+Gmm9bmCd2CgIISasAc/ZyGldAqE1vAjL8W?=
 =?us-ascii?Q?VDY0PeebROSd0K4E//iTSkTwEKASiW+qcE5oowCUqfbg/VTUa89APPnfBKh8?=
 =?us-ascii?Q?tD55v26f26hyW+WoVCvp4Nq25Yzqduawf1VJe3/Udvy5pAQk22zvrAfClQRb?=
 =?us-ascii?Q?hfHoqRSH4IocTXeeLM1hgOaJu9uZS8sLYYo2lIJl7wDSyu+FDRGjrO5qna03?=
 =?us-ascii?Q?bg9OQ6hw2pg5UDET9lpTTNISAdxkmsyUzfS2+o1DOuA4FZiImm8DKGzW04GC?=
 =?us-ascii?Q?8Lbh7eeWPTEqb+lgVDuJKIUmvAgsJ0ROUrNc+/V46ijomZ7J8WUbgjkMcaZJ?=
 =?us-ascii?Q?HRcuw8N/L1b4gfyzgQXAF4W8guyswCa+6fJNFr8ySlGQGIgEBFrFKxlHa0Fk?=
 =?us-ascii?Q?ymHd3SAhmCNU8LZ1R76nmKJ0x9S6Tz8FfowX1AVKRjn14hSId3b1uQa5FsPo?=
 =?us-ascii?Q?WpHuSmB3Yi6QqHTV1hj0rDj9faxo+BUu/ycIi7ZJlJh2w1BL19ZuRdZUX6gp?=
 =?us-ascii?Q?MIieLwmAESOf9rk8+5N2jJ/+yGfZGny4W2VwHffL6AShKHr09o6P2KRQG6jR?=
 =?us-ascii?Q?R2cB?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 11:36:34.4555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 879d18bc-5696-4734-bf7f-08d8b6252654
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: etRnSGW+PHAGpqMnoN86Vw5VEivN1BRd2GTaCv8pCUvjLV8bKzLEdM8YjBNpIjPr4xcaVp7zUUYB90tIkM+aEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7674
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During suspend/resume stress test, we found descriptor write back by DMA
could exhibit unusual behavior, e.g.:
	003 [0xc4310030]: 0x0 0x40 0x0 0xb5010040

We can see that desc3 write back is 0xb5010040, it is still ownd by DMA,
so application would not recycle this buffer. It will trigger fatal bus
error when DMA try to use this descriptor again. To fix this issue, we
should re-init all rx buffers when mac resume back.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 73 ++++++++++++++++++-
 1 file changed, 72 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e30529b8f40a..e02d798e605b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1328,6 +1328,77 @@ static int stmmac_init_rx_buffers(struct stmmac_priv *priv, struct dma_desc *p,
 	return 0;
 }
 
+/**
+ * stmmac_reinit_rx_buffers - reinit the RX descriptor buffer.
+ * @priv: driver private structure
+ * Description: this function is called to re-allocate a receive buffer, perform
+ * the DMA mapping and init the descriptor.
+ */
+static int stmmac_reinit_rx_buffers(struct stmmac_priv *priv)
+{
+	u32 rx_count = priv->plat->rx_queues_to_use;
+	u32 queue;
+	int i;
+
+	for (queue = 0; queue < rx_count; queue++) {
+		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+
+		for (i = 0; i < priv->dma_rx_size; i++) {
+			struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
+
+			if (buf->page) {
+				page_pool_recycle_direct(rx_q->page_pool, buf->page);
+				buf->page = NULL;
+			}
+
+			if (priv->sph && buf->sec_page) {
+				page_pool_recycle_direct(rx_q->page_pool, buf->sec_page);
+				buf->sec_page = NULL;
+			}
+		}
+	}
+
+	for (queue = 0; queue < rx_count; queue++) {
+		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
+
+		for (i = 0; i < priv->dma_rx_size; i++) {
+			struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
+			struct dma_desc *p;
+
+			if (priv->extend_desc)
+				p = &((rx_q->dma_erx + i)->basic);
+			else
+				p = rx_q->dma_rx + i;
+
+			if (!buf->page) {
+				buf->page = page_pool_dev_alloc_pages(rx_q->page_pool);
+				if (!buf->page)
+					break;
+
+				buf->addr = page_pool_get_dma_addr(buf->page);
+			}
+
+			if (priv->sph && !buf->sec_page) {
+				buf->sec_page = page_pool_dev_alloc_pages(rx_q->page_pool);
+				if (!buf->sec_page)
+					break;
+
+				buf->sec_addr = page_pool_get_dma_addr(buf->sec_page);
+			}
+
+			stmmac_set_desc_addr(priv, p, buf->addr);
+			if (priv->sph)
+				stmmac_set_desc_sec_addr(priv, p, buf->sec_addr, true);
+			else
+				stmmac_set_desc_sec_addr(priv, p, buf->sec_addr, false);
+			if (priv->dma_buf_sz == BUF_SIZE_16KiB)
+				stmmac_init_desc3(priv, p);
+		}
+	}
+
+	return 0;
+}
+
 /**
  * stmmac_free_rx_buffer - free RX dma buffers
  * @priv: private structure
@@ -5338,7 +5409,7 @@ int stmmac_resume(struct device *dev)
 	mutex_lock(&priv->lock);
 
 	stmmac_reset_queues_param(priv);
-
+	stmmac_reinit_rx_buffers(priv);
 	stmmac_free_tx_skbufs(priv);
 	stmmac_clear_descriptors(priv);
 
-- 
2.17.1

