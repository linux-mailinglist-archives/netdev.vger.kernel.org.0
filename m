Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5AA6D4BC4
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 17:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjDCPYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 11:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjDCPYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 11:24:39 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2059.outbound.protection.outlook.com [40.107.22.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC93B1B9
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 08:24:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZUAAaNeK83i4QJ34PUtCkf9M8M1oP99WIAsQcWQHRpXA5e3JsXPZWSy8xr04I6emK6CN2nIaIxyeZLjdxWGdZdZlgr0Ph/tSFOUo9OVxjRdesHyWqcDxYSog59KlZfAvkuKeMGf2A6b3aXPTDdw4EuJZmH6p80UlOuZZJefO5W2uvZqDAZwp48f3PJB0Lim1ifInAUAiYRqHGHlH6y0x0zYFMlbomr3h5HrALSR/9eoXcoLqXA5s4qqg8LlSlhERLQ5MB2y9LU3Ooc5kXk2hB9jIMPTsEfQDlrlgEhHEVIaq2QObQEHy1nd16zUGqfCFnOdbjllOkedgAv/vE0xcOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GxGReCJlmTHaMmHuzXzSEQ2BFfUN2YkWJccVtTR7tIU=;
 b=Wb9GmjBJ/MiLbUDLrjVT1crEyMp4HePQCcvfLhRcIV0ltmHIP6nF2gWq6hgV6XZcrSaF4/WURQJGVGjTCBg56PEx+3x6K65BqeGYkifKwWsVFhUr8oCC7ayOHroQAklmHf+Gy3n+pFvddJ6ZbpgYIhXJQb+KCRZPSv0RpKNTZK0OUTrL9TXcf091GmzaJkfduKFvg/s6CfnhJFRt1+adj+Fr/l2GB0uHiNQV5uZiqFWeyGQ4cta8fltZy56U1PQKczLobNdZLfwFV4uzvUeNkX96niZ+WHftdpsKwMgAucwpIEbd/tEXfqj/10ffBXfoTpoPLJUrCyC5+MUTHDptNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GxGReCJlmTHaMmHuzXzSEQ2BFfUN2YkWJccVtTR7tIU=;
 b=nhxdOlhpnkk5Gp2pF6/lIZotSfCf1Mvci0GFKaI5DbqH8zE1VTAqLXzxBGqe+vrA9vYD/IgAUYJ8JYR26omEGhfIpCgwQcvWt7bgF0tONHq6qCQ83k/YR76uJZQZ7qtcrLDsrjUxIeHRJ6jtjCNjp/N8fQZLOa0yyiJgsjsdblI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PAXPR04MB8717.eurprd04.prod.outlook.com (2603:10a6:102:21c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 15:24:33 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%4]) with mapi id 15.20.6254.029; Mon, 3 Apr 2023
 15:24:33 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Jochen Henneberg <jh@henneberg-systemdesign.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Shenwei Wang <shenwei.wang@nxp.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, imx@lists.linux.dev
Subject: [PATCH v5 1/2] net: stmmac: add support for platform specific reset
Date:   Mon,  3 Apr 2023 10:24:07 -0500
Message-Id: <20230403152408.238530-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0104.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::45) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|PAXPR04MB8717:EE_
X-MS-Office365-Filtering-Correlation-Id: 59b657d7-73c6-4647-1a0e-08db345786a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e0cjH/TyqJATd15/dtoKEfyo1vlkEzTs6YYYG8VHUfQ4N8fJN7tHZm+nzLKoJCQLWtJPEXhDEmuaEVW4jqJAwDQy/72QRyQFQ9dRss2MmLPbvfez5CMyEtji2wxTl3kLnytEpOA5cLsP2xtxVxUayKzSi33k3UYOtHHg1vr+iFTD2rtrm3Tqw8iWimDsS1MjJh3aQ7rBlQXw0ACl/1IQqSgMftR+4ROs28hiuCTOeYjKKpO4BCxwOz78ypVn7M0WM319JhTywMeB+4CDTIccvDRZ0nHRe+WTgut2rHdByQWCjLrAAEu7NRH1o/zXbNAkuuGbI8SV9OGlnfYIPgU/dxqngenm/FQOgIQCEnoWcf9MI3ZqRV6IePm6VNR0E9TU4M1GM4rPT6k65pUMav64M9MmC+6BsjDFKCFdtaVfiUclCpwk26HoWLxrQd/as7gvz9pwV2Ehmik+YuCWdZAXTtjY8GthVfaBRkW+hSJPn+hLE/TnolFAyXLBaLbh6QtAg8VYaEve2uRsy8Y5/wU0ck7XoMpUxkVpAuhTNZMz0aDDN9ZT3wP1p0U7lEXUiofR3sjuGxS6MpO69cGl69fwsza9dhCmS6psiuCMSW21axmygwW3Bhys9azquZ5Ms6CR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(451199021)(4326008)(41300700001)(38350700002)(86362001)(38100700002)(52116002)(83380400001)(55236004)(186003)(2616005)(6506007)(6512007)(1076003)(26005)(5660300002)(8936002)(8676002)(7416002)(44832011)(54906003)(110136005)(478600001)(316002)(66476007)(66946007)(66556008)(2906002)(6486002)(36756003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F/4YqvPIGoPIVPVwUDV84YgFlwLeEq5h4TDSv0rsG/sDV2ebjl22O/h3KvSc?=
 =?us-ascii?Q?2vmgNIb6WgG0uJ5NwwthGXu41Mmc5qcJ92vP+HxwhCqSoJHsMwgqg93IK2K/?=
 =?us-ascii?Q?9uaFB80f2D+2i9ipEvaJmLSEG9wCbbbtdAhDGUrYffJv6Ez4YoujI7o0BkMP?=
 =?us-ascii?Q?I/foh7ImPK9PMRIssMFVC6hms3A8O1aXFHDCNfjyA95nXHR1yQACGFgVRGK2?=
 =?us-ascii?Q?gELmwo81paIY3RLdhZrgBHJK9tVNM18F9CoSZ9bXQ4zHMAPplEWfl3krqTOI?=
 =?us-ascii?Q?W13MHAUO1635TJoiDY/fZ2WOKEx/RIkqlIde0X/xTOCiTepEWs6y05//pf6v?=
 =?us-ascii?Q?sRJl5jVmDRw5w22b/nEJxxH91ccRNxEK8SfpTmCIBY0A40vU9l2bFzuIiWga?=
 =?us-ascii?Q?4qoCqj4z+ZXaSLT1fE03Ec/RE+NZ4Tm+Pd+JqnLnA8pkYj5axNjnHOciQnFz?=
 =?us-ascii?Q?B1O7rsh6m3JWlme24vlYGN2drTui3ru/VBKFxmLJVP72TWJvMB75W7xslBHx?=
 =?us-ascii?Q?y34kvIgt2zKBmdkLwG7NoSNpZ3BSNSev2QZOoc3pbxuBAPZd/miom4zzZfHx?=
 =?us-ascii?Q?Nv8VL7ZBv7R3VCyU2jvnNJW+Bhikg9x+eqWtCXG2rvrGhBd+QAVhflFAX9Rv?=
 =?us-ascii?Q?NL8jdUoi5rCb03bDqrIXoJqnA5715pxT8IGRvVQNJAuDLmO/50PsdBGJO+dG?=
 =?us-ascii?Q?4uQUpRNnIeAbv2MooSRkfOMyeIJk0u2dud72OX/LWq+o3B1TCpQkRKgcztpx?=
 =?us-ascii?Q?Vy/dhpqqcS+suiWqXSpaTOUNcgUI29ZmfiLdYTVjiPZSxcg/oTBA7KUMctoO?=
 =?us-ascii?Q?SAF/0luNPzki3lND1yWEzekrkAhYT+/TMeRN91Dl97CjYSY7m4eoL0QjOGFD?=
 =?us-ascii?Q?v97Q7/zyGOobUNk/ghDYfAaPemND/WN/QDk69ez/dUejQ3tWiTtYphA/E5kI?=
 =?us-ascii?Q?aP9mMCBzKMkft5vM8+o9MmG0N0b8wNjKqYhGooTrrrWbGUQQaRAfPi7AVx47?=
 =?us-ascii?Q?J8aI9s9JpzB35VFb/JAIBXMayj2deJrsERaSsDHJjKaxvSefcsFLLLSvcVZi?=
 =?us-ascii?Q?mLz8FJJ6qfZXgKB8ZpeIjNUlXrQBKaFdQM15tTdixc/ZQUAzvY65rsMQyQRe?=
 =?us-ascii?Q?lKMfVrQDXYzgOYcm9f9jSys8oF9NSfx87z3pbPz5g5D4LMG95tqrigE5VQ9e?=
 =?us-ascii?Q?tJVNETqtvuTS2D661/BKuUb2lR4MCFrKwatTolnMQNaFrDBO1qh/xyLKBamH?=
 =?us-ascii?Q?PtNstl7uQGmhpS1HCe/Jt+5CR+PRk/dmF3+zA2ZRAueRuhDeTSEVPiSnIiMA?=
 =?us-ascii?Q?/tMnC7QDR2SDTd7rPCoSn4dtFm8s8AUszMt4kWIeLoWqO2M6wgfd9fXEz2pw?=
 =?us-ascii?Q?A1I7K9ZlErKXFm6N/1ictas26px4q2TFMpWuh8cGw4pk7DjrWDZI9CcWsn3n?=
 =?us-ascii?Q?0XOWliYMC2pjnkwxTaAPpsfgSTW36FBAPddER3T7G3XH/Zd3yqSrApu/sNBx?=
 =?us-ascii?Q?Uxea1+H3G7S67qvC4cXXPNzi+l/ZlxGMAMDAz7xaE/NW5DmHRlpFziwXltfv?=
 =?us-ascii?Q?gxXn+Jm1tL/ugencftFGqoW8GLDey9frwoxneX67?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59b657d7-73c6-4647-1a0e-08db345786a7
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 15:24:33.1797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L4utCq2ZMVQ7Cnesv68U4X7XKXfzzPRxGGRLGYXR9SLB5hEgAuws5uZMt9E8L0jQ9Yuyn0CPQ2Xj9+xFiHpsZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8717
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for platform-specific reset logic in the
stmmac driver. Some SoCs require a different reset mechanism than
the standard dwmac IP reset. To support these platforms, a new function
pointer 'fix_soc_reset' is added to the plat_stmmacenet_data structure.
The stmmac_reset in hwif.h is modified to call the 'fix_soc_reset'
function if it exists. This enables the driver to use the platform-specific
reset logic when necessary.

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 v5:
  - add the missing __iomem tag in the stmmac_reset definition.

 drivers/net/ethernet/stmicro/stmmac/hwif.c | 10 ++++++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h |  3 +--
 include/linux/stmmac.h                     |  1 +
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.c b/drivers/net/ethernet/stmicro/stmmac/hwif.c
index bb7114f970f8..0eefa697ffe8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.c
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.c
@@ -87,6 +87,16 @@ static int stmmac_dwxlgmac_quirks(struct stmmac_priv *priv)
 	return 0;
 }

+int stmmac_reset(struct stmmac_priv *priv, void __iomem *ioaddr)
+{
+	struct plat_stmmacenet_data *plat = priv ? priv->plat : NULL;
+
+	if (plat && plat->fix_soc_reset)
+		return plat->fix_soc_reset(plat, ioaddr);
+
+	return stmmac_do_callback(priv, dma, reset, ioaddr);
+}
+
 static const struct stmmac_hwif_entry {
 	bool gmac;
 	bool gmac4;
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 16a7421715cb..1cc286b000b6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -214,8 +214,6 @@ struct stmmac_dma_ops {
 	int (*enable_tbs)(void __iomem *ioaddr, bool en, u32 chan);
 };

-#define stmmac_reset(__priv, __args...) \
-	stmmac_do_callback(__priv, dma, reset, __args)
 #define stmmac_dma_init(__priv, __args...) \
 	stmmac_do_void_callback(__priv, dma, init, __args)
 #define stmmac_init_chan(__priv, __args...) \
@@ -640,6 +638,7 @@ extern const struct stmmac_mmc_ops dwxgmac_mmc_ops;
 #define GMAC_VERSION		0x00000020	/* GMAC CORE Version */
 #define GMAC4_VERSION		0x00000110	/* GMAC4+ CORE Version */

+int stmmac_reset(struct stmmac_priv *priv, void __iomem *ioaddr);
 int stmmac_hwif_init(struct stmmac_priv *priv);

 #endif /* __STMMAC_HWIF_H__ */
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index a2414c187483..dafa001e9e7a 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -223,6 +223,7 @@ struct plat_stmmacenet_data {
 	struct stmmac_rxq_cfg rx_queues_cfg[MTL_MAX_RX_QUEUES];
 	struct stmmac_txq_cfg tx_queues_cfg[MTL_MAX_TX_QUEUES];
 	void (*fix_mac_speed)(void *priv, unsigned int speed);
+	int (*fix_soc_reset)(void *priv, void __iomem *ioaddr);
 	int (*serdes_powerup)(struct net_device *ndev, void *priv);
 	void (*serdes_powerdown)(struct net_device *ndev, void *priv);
 	void (*speed_mode_2500)(struct net_device *ndev, void *priv);
--
2.34.1

