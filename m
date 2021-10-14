Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23FC142DFD3
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 19:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhJNRFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 13:05:15 -0400
Received: from mail-eopbgr00044.outbound.protection.outlook.com ([40.107.0.44]:20865
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233025AbhJNRFN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 13:05:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LpUBQu+91eoBuXPwYfAYCowVVqfd4zJBMFFYf4x6kwtzq4rpZzQk/78uAxpeC/xrQPHx4SG6am6owGtBj3TnTt6tuuwrG1y2aYNqR9AeCnFp9vzGYbA/wMbmfAcRkbn9q67tAUdpEsbSpHlCo/T71TIH6cEQgFyv1mxOSUVHWidTINkCW7beyGal1FLGrff+287bwLREC3vQAxjQ7phAJR9ZFUu5we1+wPVFU0YkmjrVnACpy5IAxYFABPbC8Qnu7sLLqbNIM2aUxtflQmjYbh51E5g/JPQ+TvjSnVu2RHCMZmZhAguz4+qRvZxR2Ab0q9ScNRYHE/xtu+db3EWBtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ADUl24fy0VEkDTx0Ptz/Op4gkKH39MdHFZIQJRKE364=;
 b=AV3JoanttG4rQ+opjvJwsUxP9ULchQtMmYMGpHuLkNEASU87GsAmUBerbIIQmM/II3U9wbYS3n73TTQ+toldNbOOXUN+6Oh0ExImw3afQz8Ws57AlHig5MHNr07WrENi8vfkP/DqIbhqcunOO2Lx5bH2YS64Ta9hvsfPFXHBJ9mTjdfzsOc34BVTX4F5ke7uAPOpkxk9pD4u18RSrqcmsF1IkaxzhDL10fRbap9aLMOqEeOgHzr4ZDAlZ6YELJxd3pHjHAILCsmzs3YF1vU/qByOEV4gm3tw43JYnK2LuYlyTYezURvP18MdFo06qwsonCMf0qH6TyrPMgU6Rbrulg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ADUl24fy0VEkDTx0Ptz/Op4gkKH39MdHFZIQJRKE364=;
 b=bWZ/VWKTDMCXLS38n1TxYy6wBihfuRi3ikbjjeTHPMxnK07VfmqeUzqtcd5rutskSVNy66WqffUPDS89b1OtybZt9RyUk05zrl83wFgJyOcAEZLk+atqY3KKJE8W+MWp6IrShVSDuw8z1k33SRgrI+Wi/EDd3qm1iP0ziLKkCtY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM0PR04MB5825.eurprd04.prod.outlook.com
 (2603:10a6:208:127::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Thu, 14 Oct
 2021 17:03:00 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4587.030; Thu, 14 Oct 2021
 17:03:00 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     youri.querry_1@nxp.com, leoyang.li@nxp.com, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 3/5] net: dpaa2: add support for manual setup of IRQ coalesing
Date:   Thu, 14 Oct 2021 20:02:13 +0300
Message-Id: <20211014170215.132687-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211014170215.132687-1-ioana.ciornei@nxp.com>
References: <20211014170215.132687-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P190CA0029.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::34) To AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13)
MIME-Version: 1.0
Received: from yoga-910.localhost (188.26.184.231) by AM8P190CA0029.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Thu, 14 Oct 2021 17:02:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4949c38-99e8-4811-1b0e-08d98f347a09
X-MS-TrafficTypeDiagnostic: AM0PR04MB5825:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB582535641DE2D1774494FE7DE0B89@AM0PR04MB5825.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ykDG3Z8n+zOciiJH678pl10crClOahxFvZFPHnOz71WCv5AVKP7CSNYohUOlLnor45ssVdwhRDQ7wg+0mxtpeLSHDlaYjQW/0YLEyJiJZpZPNcBJwtZOrCSgGaT2TL42BNHjadG2V0u8xP15CoYMc2Jhk/lfB36GzzrDVeGviM1r+8MPlKC0htTzyFgtYnRBxincVRtu6ykW3csU4+OD+UYxkY309xLMFuk7JTbXxutdGQcfHEHY1mVg4tEtRq+cBeI6x5T9Dxt4Q25AX/cLMeAeZ5zrVZp8tpYPFo4Ylq3kCvGw+JOKlVC0VTyo1SzbtiAT8CDD0tq12UI6P+G2O9yVBy/YwIYZQw8SrZTpC+Pqib1SLhTKtanROeSHHE9+TTH4Ei5o4hxvTO4gjWIAc32vvww5GjHWvYd+mQbyVeYkfcjJCn2lknQQT0tsJ958gB07O7ysothJebi0RPDZaSieP9jF85MC/KgCkCVXpjs1D0hhmYN/KzELjh+mX1wpsgwn95+LtXHFNBluKMfKuJEw2w8mv1D6FcuTOED5253zYNw2RXeCplDseEZp6rYgengKFOi/klccC8tw0tkMfNd74wWSrqD5zhPcanGimE3KzBFMpYCeZKXlwmwyFKgONEG8R+1MAaK/W1NgU4Fg2plS1wl95BI9z7O2cxGqlya0ayeaQ65eht1ohYi+WmCQierr5oZcQ7eaJgl0HPllxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(5660300002)(2616005)(956004)(1076003)(8936002)(6666004)(66476007)(186003)(316002)(36756003)(8676002)(4326008)(26005)(2906002)(6506007)(38350700002)(66556008)(52116002)(86362001)(44832011)(38100700002)(83380400001)(66946007)(6486002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Llix/0pER7Unth9LyVFpxOno5MbRZ3r6vtdNhWWh5kjB8G7V9n42XZsXDuFt?=
 =?us-ascii?Q?Y9+Ztnogu0vZe/uXujRNLISFniOpvf/y78BZ7vDzND36hmJBKIEx4KUqaagk?=
 =?us-ascii?Q?qkdnb4RSRCAs8rlxroOgFu5oJqlCxwwV/Pq1WYlQm6Bzj4Vy7nsld+LkgiHP?=
 =?us-ascii?Q?3c7s9hyvIG5WbWGMFxom2NcXH/JVRLhQ5c27Kuw/OPGmJ5WqBgR3+gqhBq17?=
 =?us-ascii?Q?m1TbPXb2gfX/ydJyeLllYne1diCv6cDJAZV6eADjfdntcOk7Tp+5YF/TCjHj?=
 =?us-ascii?Q?2lmIOFZz+0l6q1HveIyMJey1yEZqT+98RvySM8cGDo14OXz9crezaCUZGJwx?=
 =?us-ascii?Q?0MrIBJ9xxSJvGIU7vXZ//0X8okHgSxRqP4qK3jjbrrAV6RAYmwxyLsK7so/L?=
 =?us-ascii?Q?DJPdUgeIc2Be3gE86PQlMaZ+UEOKm8xxsG2S+ZK5OvgUlRg2cUpMXeRkggsL?=
 =?us-ascii?Q?tWCkPGsq0rTsoDJaOdVWvK6oEVNPYBM+KGZy7Vr1v23vg4AbvPpnoUdKAz1I?=
 =?us-ascii?Q?Hz/OU4kwUE038Hcu7HSY16RyNUkAE7Q6dJC8ZGMLF8j1ICMhysZGi8OmcUc2?=
 =?us-ascii?Q?HAJ/n7uz4csJdlNF3aWJOH1AbiI7OVBUt4DyD9/jqkMjOIPLCEFhUT/YwhXH?=
 =?us-ascii?Q?zEp8nodxwZNv+xdX+uhmOnrzam6TUDUGuRIH6fQn2a0tjjqtjn45xt/CT4GJ?=
 =?us-ascii?Q?LQg47wtFQ6BXbP5tD4gq4Knm5PfmP5xwK/dk9JUFehx41gximxhncGzcmCD5?=
 =?us-ascii?Q?tqjIvfSysOfkXfyZVgzJD2qfa/D+ZUvLWt4+e627OgV36ujojQWeI0Qguqrz?=
 =?us-ascii?Q?GdeEzbVkEAn/EP2H8qlJ7wa8PKSh5tQnPGjbGaKbiQbwuJiE6E4cQFwmHPmQ?=
 =?us-ascii?Q?rNQfUJRgx+DtM05OqgFKrpGELAxtx61t0RKHaowm+hFGTSwtOOGi7emd9pFW?=
 =?us-ascii?Q?G/DJ2AJam7dYNbIFAv+VP9weh/kbfwl62V2rJW27WQiD0W9TEo5kifq+E+jH?=
 =?us-ascii?Q?kBdLREdYTaAozG4aPIS///At5Tf6tahfYnUcWi6/kS7gSLacMsFrujhO4Kdl?=
 =?us-ascii?Q?Tt5gC1tqY0ifOWibryBTgTto4N9LOXi737yc4b+ul+FD2+9d0vRbspk3fAmp?=
 =?us-ascii?Q?IXlNIhaqrcieoQwW/XxoHjUVfSQ0KiQg648B/AFbfnpp17yJrWpZRbiJQnq6?=
 =?us-ascii?Q?4wfOyUve8FrIzHfReOSp/rHabSnmQwmtMJxZ1Cf0dnDn4IJVSig5HoOILWQ/?=
 =?us-ascii?Q?aoxZR0t4qgYkRuLt/NLq1ZrahhbwFc8kr/jJHRZjr9N4v8JSMFaVhbg5F8Vn?=
 =?us-ascii?Q?rYMvln50RWpiTQwIT1no1OhF?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4949c38-99e8-4811-1b0e-08d98f347a09
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 17:02:59.9603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8OaxDimbnwDgizm+izD1DesmPIglZyGNVa2XRo0/Knd3OYKsCSS1sPv9ZBqYenf+tUGsNFSHt+JVFpG77vtbOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5825
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the newly exported dpio driver API to manually configure the IRQ
coalescing parameters requested by the user.
The .get_coalesce() and .set_coalesce() net_device callbacks are
implemented and directly export or setup the rx-usecs on all the
channels configured.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  | 51 +++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 2da5f881f630..69a6860e11fa 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -820,7 +820,56 @@ static int dpaa2_eth_set_tunable(struct net_device *net_dev,
 	return err;
 }
 
+static int dpaa2_eth_get_coalesce(struct net_device *dev,
+				  struct ethtool_coalesce *ic,
+				  struct kernel_ethtool_coalesce *kernel_coal,
+				  struct netlink_ext_ack *extack)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(dev);
+	struct dpaa2_io *dpio = priv->channel[0]->dpio;
+
+	dpaa2_io_get_irq_coalescing(dpio, &ic->rx_coalesce_usecs);
+
+	return 0;
+}
+
+static int dpaa2_eth_set_coalesce(struct net_device *dev,
+				  struct ethtool_coalesce *ic,
+				  struct kernel_ethtool_coalesce *kernel_coal,
+				  struct netlink_ext_ack *extack)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(dev);
+	struct dpaa2_io *dpio;
+	u32 prev_rx_usecs;
+	int i, j, err;
+
+	/* Keep track of the previous value, just in case we fail */
+	dpio = priv->channel[0]->dpio;
+	dpaa2_io_get_irq_coalescing(dpio, &prev_rx_usecs);
+
+	/* Setup new value for rx coalescing */
+	for (i = 0; i < priv->num_channels; i++) {
+		dpio = priv->channel[i]->dpio;
+
+		err = dpaa2_io_set_irq_coalescing(dpio, ic->rx_coalesce_usecs);
+		if (err)
+			goto restore_rx_usecs;
+	}
+
+	return 0;
+
+restore_rx_usecs:
+	for (j = 0; j < i; j++) {
+		dpio = priv->channel[j]->dpio;
+
+		dpaa2_io_set_irq_coalescing(dpio, prev_rx_usecs);
+	}
+
+	return err;
+}
+
 const struct ethtool_ops dpaa2_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS,
 	.get_drvinfo = dpaa2_eth_get_drvinfo,
 	.nway_reset = dpaa2_eth_nway_reset,
 	.get_link = ethtool_op_get_link,
@@ -836,4 +885,6 @@ const struct ethtool_ops dpaa2_ethtool_ops = {
 	.get_ts_info = dpaa2_eth_get_ts_info,
 	.get_tunable = dpaa2_eth_get_tunable,
 	.set_tunable = dpaa2_eth_set_tunable,
+	.get_coalesce = dpaa2_eth_get_coalesce,
+	.set_coalesce = dpaa2_eth_set_coalesce,
 };
-- 
2.31.1

