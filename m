Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300A5303C6B
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 13:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405090AbhAZMCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 07:02:55 -0500
Received: from mail-eopbgr60077.outbound.protection.outlook.com ([40.107.6.77]:2353
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405496AbhAZMCR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 07:02:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tpi69Gl8xvoEmF3clW1xRxswHKpnKpru8dJtVnn2EOcrzOQw4xh61fOi0lbTJCP8bLPYFt9MmIbedyDJuGTQ12iuMKoZLOvSzYY9jS2Le+LmcENMO8RYQy4JbwNGZwSgurl2W19hbRGUQ6Dj4cDcPsRcqwO8rgK6R/gheLnlyWG+WTiyq2W2Eawr7NBtd1heneiNb2VuTbJtl+Ew7l6/TXHmZKgsYKvVoRwV0kiUsJoBVX3sgbVHGAUR55kBBhU4fkjg/U0Fg09XS2IKZD9fEj2BmJGGuFoBa2rsLmub3cNPXP02kt8GFFG88RvaeqFPx6FcfecDfO4xG3L+yI7w/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eKbL0jswLXuTy8xw6R3Hhe00rRmsx4WMMmYif1vT0G4=;
 b=Vj9hURZzWL64FsbaPNeZH5QUmtJEFmCv1tkmv6siAsosVTCq7Qhkbhjm90pkpj0gg8qT3CzWWbFeGjYibDITfqIE2JlAeIGXiPq37uBv5GYIcULbgytG/x8M2dIIhfL96Q4WvYFb5DV5wrB2K7h7dT4LqZqBI7r/nvnGr4j6W89Iz3/TRsLuNca87taq00gsRXBx9YvRcsWioNuoCJITIT/kyQH7m9Qfd0yMGBuXbnnCHWTgK7dchR+lR+58Fe0bZY0EOim64aSgiRzHko334R0906UsL1e2WUokO+jzaYRV8PiDQGv7X6JYeAELYviNQANs7XOd3e/VTBqOkUloPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eKbL0jswLXuTy8xw6R3Hhe00rRmsx4WMMmYif1vT0G4=;
 b=jUL4m01Cf0+1eaHMt+wRhOieYf369GN/AYTszrwt9vPfG1hZ1mJTAAl3zgOM+MXpw5t+GuwUuIEIFZdQ7EpF+CuV2c/Y04YW2aW7jKJVVbsw9jhZTRGSwv7aY36qCCrS1oy3nsg8AhfixbYQwV3D2JffXLZd2OnUilgDUeI+gc0=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6971.eurprd04.prod.outlook.com (2603:10a6:10:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Tue, 26 Jan
 2021 11:59:56 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920%4]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 11:59:56 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: [PATCH V3 6/6] net: stmmac: re-init rx buffers when mac resume back
Date:   Tue, 26 Jan 2021 19:58:54 +0800
Message-Id: <20210126115854.2530-7-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210126115854.2530-1-qiangqing.zhang@nxp.com>
References: <20210126115854.2530-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: MA1PR0101CA0061.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::23) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by MA1PR0101CA0061.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 26 Jan 2021 11:59:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f7209219-f73f-4045-82ba-08d8c1f1e637
X-MS-TrafficTypeDiagnostic: DB8PR04MB6971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6971C19C22257CE9F4CFC251E6BC0@DB8PR04MB6971.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VB+VpR1KUpF+J8EWAjfUsXi9gbBwln7dw4E37d1wd2pKdpvzVWWtB7ggu01RFprL8qXjrrENXEwbhSdk25LyUX25Vp5s4iSnPoaMkIkJnAdgyPPMr1DtZxszM8lZcU8YaOICG4WadMkVLfm9CcRtssuqerKYokLL8ibnWRCzB2rMpozc6W45pBOD+bscBTU/st2dBkGUbQ6Irc67OQtmQCk3cp2h0ALS0D2iqw6TE7wIwzTUQSW1F2mSRfCB+L93tkmyqxw2IbV3NoRuDr/KPeUPzen6DgIaF4BmowR+w8Md5Rz8k8946lFmXm25a0clYNAOQs5nRQENxqdSUtWFs+SZteeSasmHGYJIPtAgRhh+jhZg/DtmpbIHa6N3ZJoVnZcT/wegq/v2rjkVCrprmG+94rh7mP6hOXo6b+ja9NgwwfeN9XJia/ckd6gkisjotDiaF3XbFT+QMc5nbixjQX7QF4I+bcJ9BPQBX4MsKISdu1c3jR6KdnlcUu7YQpXHpfizXtaJVxBrrG2h//FNp+CaGqJzAJVd88kQBWgQ2mCH7F054y0sjLjIs1q90KJSSUIFZDK4CVyIohUTzYsbsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39850400004)(396003)(366004)(136003)(52116002)(6512007)(66556008)(86362001)(66476007)(478600001)(2616005)(6486002)(956004)(66946007)(186003)(2906002)(16526019)(1076003)(26005)(4326008)(6506007)(8936002)(316002)(69590400011)(83380400001)(8676002)(36756003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zbUCRo4Sg/QjDghYu4LMo9eJQ5EU6VwKAuZkdN3v1iNn3QPxTTISbJN4Shi7?=
 =?us-ascii?Q?5g3mzTFgBtnqDyw9+FWc7yp3pK4xVTzR6ZJRiNMPeM+gUjNb0a6ERPXJlEx3?=
 =?us-ascii?Q?x9FcICBABqZh6JVfxtncgKqwmgVXCRZf6nNRqwgrPHlOGt8mxK5+7qNTmdVJ?=
 =?us-ascii?Q?Ags/tjBXumgkYVTmNpwmlMx90g/U+VP3O7gSrk1YxEaUVMWBTAPLFMKz2XG9?=
 =?us-ascii?Q?wF4cBSq3OC8KOf12RWadUXu+Hwciqui8nfhH5sxYq6ddCKO2sQloDheePHWD?=
 =?us-ascii?Q?UIrbJutT0nsX8b+VhLYsZgf43gYnXM40DoW51nAJZdNx7LYRU4itLEQp2RTl?=
 =?us-ascii?Q?mv6H7cb08ed6EQ13CDg/Kt69TQFdavd2u3IqMwl59dCaxgBFjWnZAaK9Nv7C?=
 =?us-ascii?Q?ROlDrYq1tzwReOgiGTNs8TAwvVzw8yJmpbAjpDCQA/rlkMOH+uiaI/kt75bc?=
 =?us-ascii?Q?I2An81DOQG/JiiFHi4zXNHEaBlXk3YKz38R2cXARD7CGH8DllNjm7LgqeHc1?=
 =?us-ascii?Q?AzAazjqIn4rrLWNX3nvPePzmzdb3Z2P89SMcjIYo4yI5F8QKw5rJTJY3BGEd?=
 =?us-ascii?Q?N1o+EH0zwMu5qENNfLF9xCZx8aUr1sD0gAEsw2UUnxaUXvoUPZ0oIGaWm06k?=
 =?us-ascii?Q?bOi2AtxRVWKkfn6VZrdFFHxHwuMyMDG5H6xMpY4jvNVR1msSMCEBBOBqAwkf?=
 =?us-ascii?Q?sVQ6N+4oN3yyVi9h/LDhPkkWfbPygTgVSx2FvFR0/X/JYlOFjf6cvATx5+Mu?=
 =?us-ascii?Q?L5viz+cCdGy62GVlG81K6JIKXLP0Ivukn/DQWP4LKTP9AoeG6cdx9sounr2J?=
 =?us-ascii?Q?vkvACEvPv1QNsDSs4zezaMjP5TRUv2dS3xBh/6hDFR2DsHIMUjEVFPXHMPaQ?=
 =?us-ascii?Q?6uxUwrsb1zr2aulfAhqj3Ewf61XNLUGYQLvlX3C2B2cv4H1ep145hMhSpL3j?=
 =?us-ascii?Q?gcDWsw+i76AYzkcmxTsnL4Pu1aQQ+QNRll+Y/rHd14KPYEVaCMjhEKOZD9Vy?=
 =?us-ascii?Q?ETNdpJVCuvev+QyL9+3PozwNR//foU9x9+9iOJSIvwb/IoUy/zsqc2i4/9gG?=
 =?us-ascii?Q?Dc6onUP4?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7209219-f73f-4045-82ba-08d8c1f1e637
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 11:59:56.8702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6GhQWb0OSzekHe/wdIt/yeGmYbHXMdbT0wz/LrtVMMPudTzkZDM3NPs4A6jjVBMJ1U2ItEJO/z5mH5+bBgan6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6971
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
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 87 ++++++++++++++++++-
 1 file changed, 86 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 2505e314f543..e657e879c8bf 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1379,6 +1379,91 @@ static void stmmac_free_tx_buffer(struct stmmac_priv *priv, u32 queue, int i)
 	}
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
+	return 0;
+
+err_reinit_rx_buffers:
+	while (queue >= 0) {
+		while (--i >= 0)
+			stmmac_free_rx_buffer(priv, queue, i);
+
+		if (queue == 0)
+			break;
+
+		i = priv->dma_rx_size;
+		queue--;
+	}
+
+	return -ENOMEM;
+}
+
 /**
  * init_dma_rx_desc_rings - init the RX descriptor rings
  * @dev: net device structure
@@ -5339,7 +5424,7 @@ int stmmac_resume(struct device *dev)
 	mutex_lock(&priv->lock);
 
 	stmmac_reset_queues_param(priv);
-
+	stmmac_reinit_rx_buffers(priv);
 	stmmac_free_tx_skbufs(priv);
 	stmmac_clear_descriptors(priv);
 
-- 
2.17.1

