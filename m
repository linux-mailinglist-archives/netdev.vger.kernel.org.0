Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C012CE5F1
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 03:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgLDCr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 21:47:59 -0500
Received: from mail-eopbgr00061.outbound.protection.outlook.com ([40.107.0.61]:4739
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726780AbgLDCr6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 21:47:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HTSaFnAgoYO8o7SrPw9BXujISPILC8Wouu7Tfvd4LcscpqRBCDc1yRztoGqOboWfLzx9gtOB10Mfs6leRhaT5xjxV3xDBSnkE4jSs5uy41n/LMlGyzXXQPSbjr2ULNsKD12SIqgs+9wzNtfNrY2mXFwNt6Y+CHMalH5WoaGrrUt5BfUfTvzmZK8qiOY3pNTBP8D9ZQDd4tQHHtgWApSJ5uZVEG1xVzdjfhV+4PqfXcrqAo/SSua6N7qgijavhYFbpVxloG8tirqBTY1GONUvjXTJNfIcSmkRaaJMHkEjvgIbrSIzk7SjXOttoN0eSnd/09kqF6J7kkuujbIB3Yroaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ch/DjUYcGvIpPGFaxHPMdxxti+2VSWbLnImpNceEVaI=;
 b=oIKxq/JmwUv4ICLewb1v7o2N0zd8QGqXgAlG3mN02E7KVhuWYme0i6acJn55iPQMruCziLt+FBz+QUj7A4VMlhjDiKbDe8gc/7GUGZhryOa1NUJAwp8MVAvtcJ2DJcjH5BF5+3Zet0gnulf8FvGEv4WLeMwWSYdu73xDvZMBCLIJyAVbKutJnkMk0Os0XySnSOMwUk/8ZDVNVYMKP3iRRg0n8er0Z0tNRnUBSWOCaoI8dXm4Msz4dCOPqzi5zg4uJkYS6qPLAwxAYCU17B06L5UPZZ0I+AH03t3ayfCc5Q3M/bsAlXl1FkHAnVp5sm0olJ7pg8H6p2h1+J1NCP9bnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ch/DjUYcGvIpPGFaxHPMdxxti+2VSWbLnImpNceEVaI=;
 b=sB8RTK/I5N4wPpPeQUkOz8uguvWT7o5tRdiNuQkqbuzusNcFk8JIMda/BgF8D7GOttPCub5P/sp7vFxBGA/6D1KqUfm/KUGxp5bMGIJ2zc1NK8hfuazES8xEhU8+KXhT8nTsD9b19cIKF5vvzJLfebEtb9Y9IyaVTusfyIGowpY=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3707.eurprd04.prod.outlook.com (2603:10a6:8:2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Fri, 4 Dec
 2020 02:46:34 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.021; Fri, 4 Dec 2020
 02:46:34 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V2 4/5] net: stmmac: delete the eee_ctrl_timer after napi disabled
Date:   Fri,  4 Dec 2020 10:46:37 +0800
Message-Id: <20201204024638.31351-5-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201204024638.31351-1-qiangqing.zhang@nxp.com>
References: <20201204024638.31351-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:54::16) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0052.apcprd02.prod.outlook.com (2603:1096:4:54::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Fri, 4 Dec 2020 02:46:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2821e27b-1078-44a7-2d86-08d897fed057
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3707:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB3PR0402MB3707C68FC9CA01FF51D7A5C0E6F10@DB3PR0402MB3707.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0m0PrGNWCLtgdzGAYgLO+8WYXfzPqKeJvYpBoEcDLjNlksiYuI2Z5b9NfkDhegvqu6wVD8sH1Yx306uyKZZkQo/txadDhVctk2eaDWHhN05EkIt5JIBjcQ36rGJprI69HuoGwgo7Sy2Dy9rnEYf9iVFGnL9uiKSgjy53kkBfA/Prddeehnavqd75zWvAiNl9kI2ItYwbZ9ZqOSS4NcDEDcY0Q7C8EeM9CbsvDqs0IjkGwUC50FfgmXokYqF5DrBCZ2X/UVvSFaSKLhRL4p1PSr8F70L/WEDTNkIYtVV+ht/6/HxcbTDrZ4IUTTQKQliLojJv5uCH+eTLI54sJRHQjbNqqvg6hbAkHXWYLj25t7pzEkuux3thqMbOfOl1vsED
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(478600001)(69590400008)(1076003)(6512007)(66946007)(2616005)(4326008)(5660300002)(8676002)(956004)(86362001)(66476007)(66556008)(2906002)(316002)(36756003)(83380400001)(6486002)(26005)(6506007)(52116002)(16526019)(8936002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9WbctopTkhcJ1w3otjsrahQLYA734Hc9PfVxKOPcG6hbWUVMAB3VrERwtD20?=
 =?us-ascii?Q?VWCUzMhOiaSCF1f5KuSZSqrcpPQwGiywew3lMQhCBc3PXj6ipGk2R9UpfnbR?=
 =?us-ascii?Q?T67HpL0GPEtJcAP6wGVQmX+oQO8aTLggOK/NhiOdZOHL/WuG06DnIVm0bx/X?=
 =?us-ascii?Q?omwRc47O1HthY6eIUmOeU4OzZk/OH5SGTU+sdSrjcCE6AIH2jgjJbk5cb/5w?=
 =?us-ascii?Q?FC6K8+g1xLvHihUTUOZTsU3UO4dt8ZBcjUcqGb2sGW31PM9zXWJqnp4s4Wda?=
 =?us-ascii?Q?oGSM7RBNxQRTNsHlvOPZY9kVAgY6EjFzzrZooZi7Wl2kmgL4bszH0dzAF0J0?=
 =?us-ascii?Q?5Hd8JBezLTVt28iATUrsjdwZKS9i67njvQBzhVDOXN2u5gtA+cxCBit+GUpc?=
 =?us-ascii?Q?jypK7xHihF896NTrbHQH4HwZeKKxn4R4ztuygTxg6eAyQtfG0+Z2KAwd2wak?=
 =?us-ascii?Q?ybyoxXG8CSWYHgR31b56eazxQu5ZnlTjYzFfY1kMnxHsvukzsibPymSiq23A?=
 =?us-ascii?Q?e3xo3vl3WqPEkH2MWVnyiZXGz7to7Q1fGn0RTSeVZb70VD/rjwSdXlotC4Yp?=
 =?us-ascii?Q?M+TSOo8mqb+eawM9v7Ta6li2qjljV2YVYOcsjxyGaDmTIdFM4tOYtDFcT5/F?=
 =?us-ascii?Q?ishnGx+gm+eRKHZvKVCK2/BJo2tqtMG6/Qcx9p33ThLzm9OR6N9PsG3B0vzp?=
 =?us-ascii?Q?+ZMtvebS+tDmIlUpuEV6FZBwnw4cbqp0wMJf0sW1QOlV7Hjax1RrgfZ+gv9d?=
 =?us-ascii?Q?7f/yxfVL1F9z29XIwRK8YIHmfTDNq3EW22xDn5AT7vwWJTSUk3khyTBT0ZNY?=
 =?us-ascii?Q?AU/uw44jxbg85RptXpgT1bxtyXkJFBp7dUwQxb9FOA7dwE/aDZvAuBcaO/vn?=
 =?us-ascii?Q?hPcdLmAUW7OcbUhJ7/ySYB4kecbFf8ZN1NWsPieK1ajORHZm9l375RRyKaEA?=
 =?us-ascii?Q?U7rEvhD/pa1XfpqF7h0HoIxAsd33fhJSAgzXltyMTKvmbdzdUxH+uLfLTed7?=
 =?us-ascii?Q?BhP8?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2821e27b-1078-44a7-2d86-08d897fed057
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 02:46:34.7857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GE3df8YIzenQ01xas5PErZUfe+RGlRPgxOx9dZjZiEHo9se+P3iquoGBGmv1bIqrletuM/O8OOD5SS7CH1pp8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3707
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

There have chance to re-enable the eee_ctrl_timer and fire the timer
in napi callback after delete the timer in .stmmac_release(), which
introduces to access eee registers in the timer function after clocks
are disabled then causes system hang. Found this issue when do
suspend/resume and reboot stress test.

It is safe to delete the timer after napi disabled and disable lpi mode.

Fixes: d765955d2ae0b ("stmmac: add the Energy Efficient Ethernet support")
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 53c5d77eba57..03c6995d276a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2938,9 +2938,6 @@ static int stmmac_release(struct net_device *dev)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 chan;
 
-	if (priv->eee_enabled)
-		del_timer_sync(&priv->eee_ctrl_timer);
-
 	if (device_may_wakeup(priv->device))
 		phylink_speed_down(priv->phylink, false);
 	/* Stop and disconnect the PHY */
@@ -2959,6 +2956,11 @@ static int stmmac_release(struct net_device *dev)
 	if (priv->lpi_irq > 0)
 		free_irq(priv->lpi_irq, dev);
 
+	if (priv->eee_enabled) {
+		priv->tx_path_in_lpi_mode = false;
+		del_timer_sync(&priv->eee_ctrl_timer);
+	}
+
 	/* Stop TX/RX DMA and clear the descriptors */
 	stmmac_stop_all_dma(priv);
 
@@ -5185,6 +5187,11 @@ int stmmac_suspend(struct device *dev)
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
 		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
 
+	if (priv->eee_enabled) {
+		priv->tx_path_in_lpi_mode = false;
+		del_timer_sync(&priv->eee_ctrl_timer);
+	}
+
 	/* Stop TX/RX DMA */
 	stmmac_stop_all_dma(priv);
 
-- 
2.17.1

