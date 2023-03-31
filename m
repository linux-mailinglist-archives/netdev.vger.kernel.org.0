Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133636D29B0
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 22:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbjCaU6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 16:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjCaU6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 16:58:15 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2047.outbound.protection.outlook.com [40.107.104.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687BB1D2DA
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 13:58:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c60tIAwUrsiV38tVj+GY0YYffIq5vU3Ms5p/0GlgF86RTLrh0h686vcXzuN4ymkVd88IhI5LWmOT8jNtZ8zKS79MhlOPk+NVhgtdo9sngXnWdhb3Y+uK0up5o0duxurHBR+v61OVAA4Z4drCPz4732nFpjf+BllEXD/neWhmCk8tHW5FHbRjP0/0uB7eZwPtevvLN1+b9YwFI8xOfK5DpBDr/53ZgprOJL+PNMRV3b8umaKfONZ89KtQy0LVCffdhPIS2BMw0s+iY9EyjLKHW+IANMId/3zwSQhdTVwyHPvXaXW1FFcM8uaskTIYufnbeXBj5FqurBogd5tGZomKEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uR6d0AOWvtLiSX9/sXhFUbQrY/UmzvZ18zgbWJkzZqs=;
 b=cz9RscJhjmFCRSOKTsY99cs069Bur166ew6IUEWIRQeycuO24Z0j1h//9DraPfrFf9ifAcWYRN75KC7te4ODXTJOxdPO99pVIIo54el9jVxNglfYj4ystg/lGtTJuErtLUZ36em7Ou+oKXhfQuf+as/uMz5T9kkJ/QJKFQ4h0vth/jDqwdVHrauGyY6oLtxWvvQCDQsyan62GM63vq6RKlD2cNzdeTlheyQ8AaiQzykA1eHaKKnISdkyiXDA/pvwJLQWb2waI+hdMgZv48yjRpMqZsn72Zctc7xwyjXyYsFgrcT5VLnOIMjuq9X4VD/IcmU3WSoh5ekUfcz79jRJrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uR6d0AOWvtLiSX9/sXhFUbQrY/UmzvZ18zgbWJkzZqs=;
 b=a6kuqQkcZSelU09wR6XGdl5Uqq/t68AOzhBvgfYDm8nmVV7/CD7s0J+DzXqR9npDZ4YZijg/Wyf+kZPEPc3fXr696CuWTctTbsnwAqGj8bnBKUyfdp1meTx+gOTlVmQ4qAoL+Tgq+NfngnJeYtvG7F1XizFiXHlch5kvMf8cIiU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PAXPR04MB8205.eurprd04.prod.outlook.com (2603:10a6:102:1c2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.21; Fri, 31 Mar
 2023 20:58:12 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%3]) with mapi id 15.20.6254.023; Fri, 31 Mar 2023
 20:58:11 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev
Subject: [PATCH v3 1/2] net: stmmac: add support for platform specific reset
Date:   Fri, 31 Mar 2023 15:57:58 -0500
Message-Id: <20230331205759.92309-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0366.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::11) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|PAXPR04MB8205:EE_
X-MS-Office365-Filtering-Correlation-Id: 1accebaa-c8e5-45cc-c707-08db322aa357
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pscIpypzCYEdfa8jERdxlEyOkAcflrOaNug94jPY54HkCZyArRMEBjEnoHd0bRdzsjtmHRLb3r+x+Jk65HKi4RUrgGFV9E9Y+lz5/mVfFrr9e3Rq7Z9g3J8qfiGDay476I9MhAkMiBHqSB1f7H843/VTVMemypmxwnZN6S/dAyqSGMBIhV4vccIrJBxMKs7f7jFd78WGtX/wC3GaQHZQvDkTbQhZ2Rok09DGF5u4hiMmtsqCr9ZlaO0WF3g7kZna40VXndXhJkbbNmqTiSxTlFmwmMtltjLiKuGXmrvFoEuA+MJ+SSIE+wRkb4oCy/MU1PXcQI5aksYsDgx2UmblDHSi0B6kEZpEd7OpKuJoq8pH2hbO4GJk32IJTpv5W/9zeKXZClApml6bD1Ps75jmA/5p1mpZiBk90XkcmIz7Laxl+++i05li1D1MuwZXpatMsVzBb2eyFlymFHOYwbKlzVuYOg6B2G39bkD9QeNNrZmel3g2hHFn1OIJDB0/K4AuC7mrnVrA8j/dmrEtmKOd6oTUpwNUNHp/3NZmGWCj+SvtWSCQSbZfIXlhmkaYmeYBeRApwS3nVZndv2a5i5XitIklptqm0mCv1T5ymeWRRjwGi/pa3WmyrglvmhzWfvll
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(39860400002)(376002)(366004)(451199021)(2616005)(478600001)(83380400001)(6486002)(52116002)(186003)(110136005)(55236004)(6666004)(26005)(54906003)(1076003)(6512007)(6506007)(316002)(8936002)(41300700001)(38350700002)(4326008)(66946007)(44832011)(66476007)(5660300002)(66556008)(38100700002)(7416002)(8676002)(2906002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S66nrSIUlzVUByH+b7pb4IUOKk6XGGVOuB02zraKiK2g7KwwBK9PviXOYFow?=
 =?us-ascii?Q?t264K+sJHOUYmexWyybwogZEWVmhf4oEWQzsZRBdpizgZ7YsePYRxtAUNByV?=
 =?us-ascii?Q?CBkuP+P+Z1YEz4H+VjnUjZglJlsc8l1rCVqZQeKzK0XieyaHLk0nsurnBfeq?=
 =?us-ascii?Q?913TvCLwWJWZpc7nG4hsJ5AziINCwPhxnXCVWEUpf3hbzNx9MSgFW3WpOiLR?=
 =?us-ascii?Q?W7cK1rYOYwzHi5uKxFHB3DVM88bnwEn9DbCxLebTPLOpSTaFUGHbQOfNiBwa?=
 =?us-ascii?Q?Y4zyTz3Ase8HOZctAVdiBtHA+GU2vo16tAD/QxzbLBSDxvxb9athjWRHFU/c?=
 =?us-ascii?Q?u3c7LIuu/llYD3xubRJYjKfj3Rnc7pVMlhgcbiUVsmkEDwEjvDoJdyx9we2T?=
 =?us-ascii?Q?L2b6VYsjWk7s5N1bmwNKZosU7HgViWeE4HXlNilmgkpck1v/V50RrDzYy2MW?=
 =?us-ascii?Q?eWlMQV/HEwHtHPQ9rHs+W5Ytwq5t60PLtMvd9u79D5RpO0JwrM3YblJxWHFy?=
 =?us-ascii?Q?IN7ddH+LJBtr9g1GH1ZzSeC9a5gOVYdfDi/YXzX7CWRRaR4rjOVIXLnCssl4?=
 =?us-ascii?Q?8owrQAHfO19f4ZgKBzG7P52NXIjwlyOhMRScd7F/f4IXGbPw6V87SqZBGxfk?=
 =?us-ascii?Q?MWttcdmorvStnkDT7BQryeztNgbQAUpAXlMqzNbOfz9ZmMiDmynPQMYFLGhH?=
 =?us-ascii?Q?KztvGDXmD4Y45L7W4HDkivjgx/9ORPRmwD70LrBwAGQRmWA4jyGt0gpfQF4H?=
 =?us-ascii?Q?2ixp03eKkpXiPnlAPkXaBeCWb7TTzYZgTnt+hPXNkK9sdGV/wdkDz17ZT7Av?=
 =?us-ascii?Q?ZnxR+z5IZJK3E+sbiz4xSrbQl8p1MKAwpTjWT6Xx3t5uHnIwzIEeC0uL4/3I?=
 =?us-ascii?Q?TZ6x9otcsNYMcwhqwdpPJZ7rdAUhjAT/QgvFOUdnKmysEK6e8PgI9i5HpMsi?=
 =?us-ascii?Q?Ut28hBWsWv3/6ZzHJjNDkgoxqo9iZYnUHUObzgTUWYNoZbO4YlKzysnr6hXr?=
 =?us-ascii?Q?fEeapNvmKnEiSOBoznUY+AZlO6SeymBXtPGeshVD35GqZuGoTJsFWOaEsUbM?=
 =?us-ascii?Q?XuSiEd1jCtVjRyQDKMXoC86NAcOnDk/j3Gzq1XLiG8kMhO7vrDAgeu+Eyjcj?=
 =?us-ascii?Q?qFwMj5JOYKnOr/6P6/uIUVWCLOc17bhBNpUVhPMdkBuqMF824rQCHUNuAJZW?=
 =?us-ascii?Q?0SRkM4q2vWXhbR02Vd8wZ0y31jgcFbZ/cvQ9M8jL8JU6Z3tCB+l9MI+X1QGg?=
 =?us-ascii?Q?KelCiDA+1+i8tZkYNdENpTunM4lq3SVfmb6qo6xju0E7g6pXTDNCtgoK1arR?=
 =?us-ascii?Q?puM6zT5ZriGyci4Xjotg+0dHMPpkOjh30dWICAu7V7uEfhRZKvkcGNvxr89c?=
 =?us-ascii?Q?tdCtpHg2YWA4gXUoAiDgpRKJFBvLKlOgFkDZwkjlQzXwwfd7lO55Gb6uxNu+?=
 =?us-ascii?Q?AJvOjS7rWmwgf8zAvBd5XeDUZM1q5casU1oEfwntvzXABf1awClQLETa0xT3?=
 =?us-ascii?Q?Um85AbxLXITZ7v9RM9Q8COykO0bkoQEAmoL+QfW0u+Yp6hwwRiUry3KxK83q?=
 =?us-ascii?Q?70cQAUwFO4TGXDOnJyNWBvSNmM9eHabxBmJtT6X+?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1accebaa-c8e5-45cc-c707-08db322aa357
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 20:58:11.8182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E4xAtRf51vrdQFmpyHle+6wxiAOpHfOwwXGvQymP3I2LzYzl9EQrsPrVPH2mYtx9VteJtwb8K2teYWCi79HRIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8205
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
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
The stmmac_reset macro in hwif.h is modified to call the 'fix_soc_reset'
function if it exists. This enables the driver to use the platform-specific
reset logic when necessary.

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
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
index 16a7421715cb..47a68f506c10 100644
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
 
+int stmmac_reset(struct stmmac_priv *priv, void *ioaddr);
 int stmmac_hwif_init(struct stmmac_priv *priv);
 
 #endif /* __STMMAC_HWIF_H__ */
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index a152678b82b7..9044477fad61 100644
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

