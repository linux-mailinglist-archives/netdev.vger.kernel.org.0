Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4892F2E0E
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 12:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbhALLfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 06:35:23 -0500
Received: from mail-vi1eur05on2052.outbound.protection.outlook.com ([40.107.21.52]:15200
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729394AbhALLfV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 06:35:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RtEHkbgP9xTh0LP2Cy7Ce5OM+54CXtoyOTvcq8pNvda0x1CiG3M6DIfCJDknXb3OOH16ac4YLPwXUBz0RAeVmThwUZEAGY6oi+mhASVdkKnSY0I2IG/gubmpKhA6HvvxXAA7vmr7hBrT/tk7NHhv9JzbJcTMD4bGbTOBhNy3aU5uLNXW8GwFYHQjzhLIBeeCHwgHwOAz+m3NFnaNsSEf/EHf52G8BegQtkX/Q60HJu1YP92ZbYNQEs3LhrSSnoxCKhpHwmM2LnCFCR2lnJ/s8GI6UgCGjr8aNZp43YTzUw9rQaUS7Z6mx8ofche2eY4vI965fNCOAwRVkkmNmMJ2qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YM17wVEpH9qdTMQ+k5KCvv3NSBwq+TxiHNXpXb8VR2Y=;
 b=CbdRFAuBX7gRNmAQsT9C2g3cvgz3zVuZ6pkPCw1QYhBDkX3iCQbbzIfznfAUyEzjZJU51TbU+JFGniQon57/UHr3X7Kszvl95F5ho+fuLmS+lHDXrT5GkLEwC/yYJHBbRF+HB8KYKodmlVlR+kupjiHVQmUs0fYtQjlyIp+d9DrnL+C8e+ZAtdTn/rb5EhpON4ZkI7UdmdYRYUlnX/AsuHpxrDpBlU5pPkkwgh3Cg6wUQPbKUw7iNTMa/rTr6Wyxb15s7ZXChLsdOHeco0r9sz7lqdR2LZIA6i641l9wmLFfDO1TGpvzmcFjiAfCEimOlfJsARnnhuuSgdcwKVHY8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YM17wVEpH9qdTMQ+k5KCvv3NSBwq+TxiHNXpXb8VR2Y=;
 b=Z/Up0ZMKrTgP+VfY2azkKYu46fSGAEEaNO7D3dLRxnrNN5eYQpKOc1rHshHRC6qDT0TLYjWbGvEP5Pz/spJaPNcH3CJ52wcO1un072C57imeQxKFOdUChw6rECv3lwLauh41pBdrzar8i75gXCXhZ3znIUtHR2UqHyMfDbuIC50=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4108.eurprd04.prod.outlook.com (2603:10a6:5:21::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.9; Tue, 12 Jan
 2021 11:34:31 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 11:34:31 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: [PATCH V2 net 6/6] net: stmmac: re-init rx buffers when mac resume back
Date:   Tue, 12 Jan 2021 19:33:45 +0800
Message-Id: <20210112113345.12937-7-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112113345.12937-1-qiangqing.zhang@nxp.com>
References: <20210112113345.12937-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGAP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::28)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGAP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Tue, 12 Jan 2021 11:34:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: eeffe995-e263-432c-48a2-08d8b6ee0756
X-MS-TrafficTypeDiagnostic: DB7PR04MB4108:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB4108247C29066EDC4C0422FFE6AA0@DB7PR04MB4108.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jwTo9c5P3FfjHIDe1nwQ7yCBjMxDCL/BVevk7CVuW4Cnbu2TVulnDLOFA2/UHV71G7DBPCjSEe1QIF8k1BXOpNvtbVpWGk/td/mCx4ft72TN4HtrViVHI/yI+menqiRxCW57h5FdNRselAtkTj6DvlP1fzkgGXeriSimzp9kMUl30fwsQfxStLkp4zRneD0lR/kM/oJyKd5r1EVYcUZ51QB1HF4fqsjlAdGCKx4Ut2jcIIYLxJZs5gHJURGQ1YGRPX1qtXk8+Kif7uEHjIOsQe74gOrhdyi3bmRpf2VHYyc08/lhJulTbQypJnWflHB94+iEGPhtRV2eUmH7678qSOjNrkUNl47IasHOCZ4N5RjZ6OsSO9tNEggVATPj6dSSk5JNcjP1usrJm2WifW2WreNvTQ+qRYCF5eTclQHlkDFKYYCJwoat1p/MR37xad0y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(8676002)(6512007)(83380400001)(26005)(16526019)(66946007)(86362001)(2616005)(956004)(8936002)(5660300002)(6486002)(4326008)(6506007)(69590400011)(1076003)(498600001)(66556008)(6666004)(2906002)(52116002)(66476007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?X/HKMX+8lopG3SajRKxQJpWgLZlybrX9HnBMHklI6cXvGPT/OpaFpAI06GgJ?=
 =?us-ascii?Q?/S/Qm/e9GRp/i5EVrM+iX78wcqYI2erjYuaKwDvYtu1bFitTp14/I8mrJx4s?=
 =?us-ascii?Q?djEuMaE7gxeIt7bnEtW0RtvlpWJbXJPDD1KLZqusZU8sRYYNRJk3TqhDnqB1?=
 =?us-ascii?Q?2S37noWNRr4/R07XYHdGAs3SsGjsRw8Rt0YVZ54uRoy+tgROipXLV+fPhERT?=
 =?us-ascii?Q?Txyp0e3Ixd5DwUhErU/lKgv0zBbHS5JH8nJsjw5GYdqwXb1Pj80XUSHzmaCW?=
 =?us-ascii?Q?pj0/osqtRyUw8HjyZNUFTvRHNpskYZWqieF9/VrkfdC11ip9fzLwsfRvXChs?=
 =?us-ascii?Q?tRftvnCA09K7x/NDnPuU5mKgpTVWqFPCnDiJ59j/cpQAf7BfOzDPfKUH7DFS?=
 =?us-ascii?Q?mH01ckUBfc8E0Iwm/pGXbK6RvodN2ZGq+gbwhD93Q0ZvKTV1qQhfG1SwTMkR?=
 =?us-ascii?Q?TzvMssRjKN8hS5iYNXR2VWVnPVGFH4yWIEpKiSJrVCyXeE9SHf3Dg8HM9tif?=
 =?us-ascii?Q?5Nz4ikDxMHW28HlfSWCf1W9Femycul2C0agfZWtuNlQfw560utiuY2VpH4hM?=
 =?us-ascii?Q?vIK0wohtXNm9RZ0rCLDgiI1doo0IRdMnqrAU2csGrLcqhPLmnOg22jLJsUZx?=
 =?us-ascii?Q?79AwtF2/ioOhk8XqQP5Mtg/m8H1AysbPVsi5+dJCsTvhMD+2/E84Bz05EOoJ?=
 =?us-ascii?Q?Kq8znMGpS3xiroxy7SKmnXca4orCZs7WdIvkvZbDA3USifXPZ+sMpKnUvREl?=
 =?us-ascii?Q?xZcR0rmGZb1B6wy3Npn2oEynmptShXfZp6p6MWy2xLUg4ehKlMnz7Q5sZKeu?=
 =?us-ascii?Q?q7zQoY6RL5tYqvbQ1famqqGBJsZ7LGMjv7c/xsDN/GtfTHTJEwLZikm5nBks?=
 =?us-ascii?Q?V3x6mRSePEFeKZJ4d1Rb9i9xe2RzjQC4zOdnSbuvhqZVUQDShy7HTIWZmLhk?=
 =?us-ascii?Q?KmI1WCDJGIiEfGRdetKJdjYmFEBTQVMWkFGN3CP9tB/V30nXEZQ5WA4yejqp?=
 =?us-ascii?Q?eb1/?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 11:34:31.3536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: eeffe995-e263-432c-48a2-08d8b6ee0756
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ter9zg/HOkFiwI/vw63zO0Hr1+tT7DSNsX5bF0C8b3rd6NxkOGrpAuV/XcS4zsvhyjR+QCpojJUeIpKkmT8kNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4108
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
index 3ab1ad429aec..2016d7fbf497 100644
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

