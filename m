Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC33324C79
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 10:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236088AbhBYJIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 04:08:25 -0500
Received: from mail-eopbgr30043.outbound.protection.outlook.com ([40.107.3.43]:36993
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234713AbhBYJDG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 04:03:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PYJTy18AXXXhcGYCeamxPFYzchHfS5adNstd4lrHDrsZVIM33uyZfkPv5UQ3U7TNolB4XLQ57+T4M5HAZInBwWiW0xcWdwds0u7uGU+UD5cIJ4g560vw3u0VJMp2q2lTzUXR4l0ri6Maixfbt+yCPLF1tIpi+Tt6xh3PqEU0uCHQgdUYSaVps3kM2PLUoG2NTmR+2zCJYcW+Tei65Zby5OLebhI5NI5D0IE0GtI08QlksbenHKkzLVxazPx5o6EDrYMArcqcMVEtCSVhCt4JqB7XCSNVFL+riC3FGDfRWgAQiZ+iHqQTHcUFnwxqLo5XmczEB9r9CfIwOxKUpTMcSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eYoOYNfbVZd1GfYgY4ZUiQclcSa/RllzkBFFgdzh4Cs=;
 b=oXBzs2hdKaVcH3TAMil6Nfnb3FPciWyGkOiLbcLy3ZyrJ5Gzlv3Bxsez1LGUtrzV0+SsrxAJH70qzRmLcsKP/2Z10QB6dRpIJmZc/ZvMqhrTeUm0b9T6O8N9CIfkRjcJqTo6FhVr/qVfl5daUuKB0+4bJVbHpAFqYi1Qkc/d2uk5T9z7zxAHBxhlv4MUBvjCwtdiF1FJ4Br3p1tBct0QIHMlQdQEHFUBjkO0Al2TqMcSoOJBJZhw4dZnZMcDNLJXa4ylQDiMzD0N4DGFPAnr6LEhMO5fDDiC4XT0k2qzMgE75zKHalTzagX2QLvVTMmYWUM98CDCDhJ09e68M/WSwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eYoOYNfbVZd1GfYgY4ZUiQclcSa/RllzkBFFgdzh4Cs=;
 b=nyB2t0t4WF7MQ8yU7LEBIMJNUP4RGT9lh3U9hL5oOWduGEvwFqQD34bbID1+q1ssC5xWsVysl9v8viHtI/+TH4cEJ2FmjPiw5Esxi9ykaXzzweCXjQPpvE8+onZfxUppCfF4k2YEBGEBFAbaVkxRUpjkGk4VMEdTccnwc1yD4Xo=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6970.eurprd04.prod.outlook.com (2603:10a6:10:fa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 25 Feb
 2021 09:01:45 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Thu, 25 Feb 2021
 09:01:45 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V5 net 5/5] net: stmmac: re-init rx buffers when mac resume back
Date:   Thu, 25 Feb 2021 17:01:14 +0800
Message-Id: <20210225090114.17562-6-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210225090114.17562-1-qiangqing.zhang@nxp.com>
References: <20210225090114.17562-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: MA1PR0101CA0036.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::22) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by MA1PR0101CA0036.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Thu, 25 Feb 2021 09:01:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fa8c3d9c-9156-4ac8-04e6-08d8d96bf9b2
X-MS-TrafficTypeDiagnostic: DB8PR04MB6970:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6970A5F6761661E74683743FE69E9@DB8PR04MB6970.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 04aGvJ7krFPm6Ctj0SzNqJEi4zfGr8DZaJ9DiA0Zo/W0lDjiku8dQjIe4MlOXQeU0MSfnWxKDbl1BzmFBd6P8wHj1dZbROHQ7frcGhjQQJF/rr2vzh9jFnwGvqt/vm282PmLXybomt0bGbbHw4x/iaQNjpRjHpSF66XeIKLdf2p2E1NjG5G522DpaYULgHmbd8A3bK72appGFOW3cyLsQJdrsGZQUGqrQDoRIslpbr3Jf2wv8EyXlQsYQDw9tOgcejO7QBN7P4RIzpecuuq40UdG2GRubKg9+W5YF6CrLhn/rJh110+Z+DkArY9Qs+d1tZuAO9B35S8BRsxn07TajvX6rsV2H88XxtI5dQEJSZhymLlWwy+ho7RPJjre4jyNl62kJ797p4AnHgDnnG6hR9utgcbqyQx1VSfnqG8gKwHzvayFP99apyEco2wsnlGWFeDhk3JGLEkkBKZbWP9Cejyz9oSoyOW+L/OJ3hHK3WWc4kDNHoJsSUF0zcUFES+Q4ACzUmlOXz8ccwgrhuMaWCvD891O3DZ7Abi8W3l8Z3WdRlNMJzeofeVlLxvTP3Xbnv7D5Cv0Hj7xcjqmMvxR2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(52116002)(36756003)(5660300002)(478600001)(83380400001)(6512007)(6486002)(1076003)(26005)(8936002)(86362001)(186003)(16526019)(6666004)(2906002)(956004)(69590400012)(316002)(66946007)(66556008)(2616005)(6506007)(4326008)(8676002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?yX3/4a6Ev6fU/bDXoumSZWHxzO6tdZaeSuXHraPTgYBzNSGFFA7/rSmdF32R?=
 =?us-ascii?Q?DhCyH6qr6y29gsgPH98yYfGSgqH22VCgCzK9LC8OkyiINmY2FO58YeiFp5Q0?=
 =?us-ascii?Q?keNN9my6AcobHf0ZFPgL+tEY6KRRZiRYRyO73jILmFb7of0oFOEg9Ypxcufs?=
 =?us-ascii?Q?nADxUxZ8pDtWAlJ7JtoltgUhEH/7rutzlXz6p1wmOj7zG/PqJ0zmgIEqSJtG?=
 =?us-ascii?Q?e0yo0Ht6189DvF0uXNgvAWzGEi22fOkzDnuOH5R7LI4CQOw8UBNsZpg8O2q0?=
 =?us-ascii?Q?A/bvjNGCGq3Kx02CUS8PxX9W3sxMBvCmUU/zUoePdBN7zMORojoN+gFYMzdk?=
 =?us-ascii?Q?gXs+86RRUAhmbOci40On5adESvuUyTRrYbdzIDPsZtEa+fDmE9sdI9V05NDj?=
 =?us-ascii?Q?REKfY2BwZwxNDU5SbF2L8Z2anju0tarZgPw03kzH/yHPTFCI9MMuHoaTl4M/?=
 =?us-ascii?Q?S0ZLGCcqBdLbWn1d1VqOZCIwQuQJ7aCC6fWGrrQbH7viUfGipPeGS7Q3543i?=
 =?us-ascii?Q?n2u8RXKDmgsy+PDYqw2aixvHokpwYJPBfkL1DAxRZxe2pc55JVr9hvbQWav/?=
 =?us-ascii?Q?CXjFXGKaVPdZ0PsUPJgZi+n+432N9lR8NA0ZACdOjNHOzvFbX98kAyq2GbyE?=
 =?us-ascii?Q?2+efzOE66TBwEcD2jXoTQYfPK4FOotTT+d+QmMd9+09JaHjpMOHQvHyEYYhK?=
 =?us-ascii?Q?7eCw7FZxCOh2P4uosUisC4xzYrmnryy4LdBmIiT7m4yA8pKcAlmJpF7thJMH?=
 =?us-ascii?Q?fNLJyeRBX0LNWfvSlRNU95nzrzjIClMzUNi7nhDxjY5QHMNK9/zv6OiBg9q6?=
 =?us-ascii?Q?LEPWIDnrS9PZczbORKvXcfqtK+sckxFIdKeqlpDTyVPYU8IrkAwYeIJ5iv9N?=
 =?us-ascii?Q?wfPd62BTyt1mTdHNHC/tzsL6EBpWTlJGONtK7brPnxY3ue0xLguFSNBPd20z?=
 =?us-ascii?Q?yIUbbVoxLf52iMfoXep+UzWc3bedzz4jQjEc+bD+iP/y1TGU6IdLnm5dnzxf?=
 =?us-ascii?Q?KAvDsyjCAin1aZt5TDSo59hOXLV2jd87JMegY+IpT6zYo3jptudluqJnQY/1?=
 =?us-ascii?Q?FMW5NqctFXh9ch1J50Wd5h+iZBWOgAjt1X3fLUnDy8cDZcbnbSqkCEOTBSpT?=
 =?us-ascii?Q?rlvuHqukiovtwIzLy8Eu+utb+jn/f5MVYwOPpqE3Co3piVSxVAUk4VhdTctU?=
 =?us-ascii?Q?IrdQF91qiY15eTOPaYcaN2ZtF9li7JxajzsTWJJt0C3g4xfhnAtlsGn/WhH6?=
 =?us-ascii?Q?OrDaMHSLqgGyCXArni8TIU6z0B16UqBj+Chi+N/+MgfHOsjZ/JVsZaD4sLRg?=
 =?us-ascii?Q?ibk/TmI9a0ieziAIXfLVHxzI?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa8c3d9c-9156-4ac8-04e6-08d8d96bf9b2
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 09:01:45.0898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ai6Svqx4JL7Ru+Nhukns8LTMFu1CkEaZTudjF2kZyjLhx1SZ2YBCI4x0JwhkqaQc1kzxOkxhwEuBtjmciFULHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6970
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
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 84 ++++++++++++++++++-
 1 file changed, 83 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6cf6ba59c07f..0c97d1a5504e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1379,6 +1379,88 @@ static void stmmac_free_tx_buffer(struct stmmac_priv *priv, u32 queue, int i)
 	}
 }
 
+/**
+ * stmmac_reinit_rx_buffers - reinit the RX descriptor buffer.
+ * @priv: driver private structure
+ * Description: this function is called to re-allocate a receive buffer, perform
+ * the DMA mapping and init the descriptor.
+ */
+static void stmmac_reinit_rx_buffers(struct stmmac_priv *priv)
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
+					goto err_reinit_rx_buffers;
+
+				buf->addr = page_pool_get_dma_addr(buf->page);
+			}
+
+			if (priv->sph && !buf->sec_page) {
+				buf->sec_page = page_pool_dev_alloc_pages(rx_q->page_pool);
+				if (!buf->sec_page)
+					goto err_reinit_rx_buffers;
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
+	return;
+
+err_reinit_rx_buffers:
+	do {
+		while (--i >= 0)
+			stmmac_free_rx_buffer(priv, queue, i);
+
+		if (queue == 0)
+			break;
+
+		i = priv->dma_rx_size;
+	} while (queue-- > 0);
+}
+
 /**
  * init_dma_rx_desc_rings - init the RX descriptor rings
  * @dev: net device structure
@@ -5343,7 +5425,7 @@ int stmmac_resume(struct device *dev)
 	mutex_lock(&priv->lock);
 
 	stmmac_reset_queues_param(priv);
-
+	stmmac_reinit_rx_buffers(priv);
 	stmmac_free_tx_skbufs(priv);
 	stmmac_clear_descriptors(priv);
 
-- 
2.17.1

