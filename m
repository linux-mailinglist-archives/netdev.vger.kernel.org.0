Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D88B6817B1
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237589AbjA3RdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237871AbjA3Rcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:32:46 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2084.outbound.protection.outlook.com [40.107.21.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335F7360BE
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:32:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l/FGUEq+0wphxU4nfVYPiyMBHYM0d5URkgT/kis7ihtUaFMwW9NRaSlDJtLUfHuzrqweVHuEhv+gfjuqxHMAAt/13ZaR7/jrrVQ2cjZJhjz8D2Ue4m9+l7QBTgGwXdvQSiDXPg/fbtKmeILM/1yko43civTQd9+yvlBjAjb/adNXdiGDtXCcb6Z2qZrwkCHJ4QwEXJJ2zAbA9VvgUM/sF6yZ5Ynv8giQkLWItqw1I0FHhJRQn12cI8nLnuUfJjhQ83+H7SZJb7oNmg9XJwi2xVjZ1FL/9gNzws9rSC+kKYFoKLeVnKT9H0v3tVfURjfA+aa5mJJCRXGzHGBgAaYBDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ihs9k5t1nNIELBVcMmQK+rE55V7rM/qPBwko9MudvD0=;
 b=lkJ/IMSW/as8GlkzyJRHCzSoJbFLl6h3uTSgXqD4bhZE4IxvkCY83pD/Pnk4J5iNuDL0jOvJc5ovMoPTgu3COhAvfqmQ/HiQovSCz7E9ktTLfTFnENHfT1eGXgwsE/z6xByIzcPQpYa78lRQQ36eHmMd+k2U2fGlwBaxVlYWaz3riLbGueZYMKpqpk9oRkNpaHAdkZSciAlorjhjrUuIZrdEk/SOPDs6VH9yQ9evBHK0cEGDtgL+PlYFfqCfWuraX2syudiKGLLlhhXE07CECDf1QncMc3FRTYwSyf2mly5y9jKhYs9JZPPuuWg6EOu5n0n4nQCfwQ76qB+KI68BUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ihs9k5t1nNIELBVcMmQK+rE55V7rM/qPBwko9MudvD0=;
 b=L30JjxtST0C66O6ApZzzM58JGf7qjMQ4Zy0lxfNdkYxZ6ICdxWIpQ4Mlb+br7/FtlEwnhy9K/GT1bxlksVudeP+s7C+5BSqODAiyMr4veccsCwHdDM+B++nJLwYagd6Wn/HsgKmyHNzmAvkcbxLImQmcS+qS+VIOmf4Q1qGtODk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by PA4PR04MB7677.eurprd04.prod.outlook.com (2603:10a6:102:eb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 17:32:24 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730%4]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 17:32:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH v4 net-next 13/15] net: enetc: act upon mqprio queue config in taprio offload
Date:   Mon, 30 Jan 2023 19:31:43 +0200
Message-Id: <20230130173145.475943-14-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130173145.475943-1-vladimir.oltean@nxp.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::10) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|PA4PR04MB7677:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c763875-7759-412f-209b-08db02e7f2f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F+1dmrrBeCzT8noK/XVLitasVuss2SYc2TYon0z9xsQp31Iyb0J+EArBTBtzgGAuk8c5DwIG/o8lCx2dLP4ifCOcR+x0bfpX1ZLcTBt6EewXEnTmHvL6ZwUuPB3nFBaVQ6gRwu8m3eHzRHclZge5Vvi4qDCQ+2pIj04bG6QjFc6pS1qWnlOvb9BK3j7RzU0U5AyIpCCSi6RcUxjFNe41fqmTM9p4+2rQafa8qTmR9YNL9KMeuOO8UI3LrK0a9Uk3sOpjd5636biiZs1FyI2DeSv3XmX0bOHJQt93xcBt1YoAQcqCaYj+VqT6Fz3tuvyAt7+9Q8FIrnFI5VkOUuaHrEh81dt184b+o++o8lrwxh/CiIqddBVJXXyjxeVdHxYEtFUV/9+/rQ2T0ZfIKCTwpmwmt9BN3oj5PRAQUCN3t6p928tXlNGBK1WUaujM9X5Y50VDs1TvvNERVLNQQjkYIu84XykAWHXo8q1tgL0KbzPFcIW38+mH8nPqplBgUwlZbFHqJf70pIo1lrElnK5j5ECY0fLyYfrWLqWoTUNYJEnPoLTFCOj/av0QSpmQPzVYPvo7dcyEWuUoIOwrGJIcTv7rrOfAKqv1T0xrQzYbq8doMGfQSD4jzF43+/x39qaslQ6jI9DftZg9U+ihmqBWAk8MzgabGcpwtUMkh+mk0pyj0vztEP7q4TBF3N4n7g06nP7XfHcfcX1iB6ITiTnIcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199018)(2906002)(5660300002)(86362001)(44832011)(7416002)(83380400001)(8936002)(41300700001)(36756003)(478600001)(6486002)(1076003)(26005)(6512007)(6666004)(186003)(52116002)(6506007)(2616005)(54906003)(4326008)(66476007)(38100700002)(66946007)(8676002)(66556008)(6916009)(316002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5mMpB6D5/Fwfo0vNX9dtMWqSSSi1+xJI0ITz1+kCNYuBtMnOsfoP5jeA2dJm?=
 =?us-ascii?Q?XoAgdsBNBI05r9ACP0A4B4fpxSRa3+74J8bh6kyaaSj3O6Hutnqayw2nZRoy?=
 =?us-ascii?Q?9HG4WoqJIYD2j853Q1591yVxzb/PIJ51aI2iK+US9NeUparjYE3q4kFxkBTa?=
 =?us-ascii?Q?8TodbLTinYGdBZkdt5wlgY6YKUy2To0gldZtF4qfIvPbMgMzVbDLxgJy/hI9?=
 =?us-ascii?Q?SAybWbdpqmxmXy8WZ3GaC++IziHIjuZHqVyHtI10DtJTq3Ado9guWDkoKYFN?=
 =?us-ascii?Q?UOPZjPNReuxMTNkm+WI+d/rxohMwPVFdgGdv2H/Tmd/N9BQk4oWvuhEu/Gtk?=
 =?us-ascii?Q?x5r2kGwHHv93wY8xO58wpu0wKp9+ffuA3Shq9ELeUTPD41Vjzg4YK8Y6b5zm?=
 =?us-ascii?Q?FMTm1T1Fpw7lt18adssnYkhSU+KARjan/m26W9w0A+cPtlErQX0lFrhSDNXB?=
 =?us-ascii?Q?gawhBhlnLZSW7eX70VOVbDs3SwMtzr2tb0nL0DjiyQhKFLYl4tBGpMuRUWVW?=
 =?us-ascii?Q?rrY9zrfwr+kHVPjLw1KkSdyxmny68N6ImJuvv0oA+3UasisO0Aba+C+inKxp?=
 =?us-ascii?Q?M+xdl2abnISJnFfSn3qTSsh4R1pIGdijf4ghoBNNt6Xwu/nE5w4zSNjHv4P8?=
 =?us-ascii?Q?DrIXIq8YoG2josA1t3CmcSNkqX8ZEE2F70RrUUdv6LmUT0ddzl/9FVNfMDc1?=
 =?us-ascii?Q?/C88VmMlNDT6QbFksK/JRuW6lFWFIj9nrYQxRTvLdPgTvQDRl4VubfFL/36R?=
 =?us-ascii?Q?yrpn7PeWDPgdVrMXf76fF0YNeSMCKauN/6e1AuqINl7Qh4ehSlh8yaBGswU1?=
 =?us-ascii?Q?uFUyGVZH20t0DLupyPL/Af+hwc/nxjJ3eMXEFr6Mh7ZqfoYS5l6PpZGFnkKw?=
 =?us-ascii?Q?DtV3syYWw0Q9NV/jHkT+lJWATB6QOfBljf8EMFRyC2MPcM9CeQXIOEIGnCPa?=
 =?us-ascii?Q?G6Q/MB7DlUDx1xhEg2qMUnHn0vwFNBNcU6Qn93ql8C/ItgVIBGoIyt4fumh3?=
 =?us-ascii?Q?AJQPZFVwRgfM00fXaLtqDMFFe9rWLA4T+V44cgliO7envQJR6Yy/4bcGXnRc?=
 =?us-ascii?Q?1Xo8ZuDBMQmZb9ddiClqCTgu2l8MdqD+eJwkawPu26eieGmxsaUmqEfJjuSG?=
 =?us-ascii?Q?frk10nfeKTgmf68oXbKBV1BvXP/9m+arY+Bmg8EcE+ajYZBhz/JdOza132AA?=
 =?us-ascii?Q?QToIvKbk3+KtLP2T9inmyyiZXH6Nb9iI7GbpLilxpLo9Ko3UKya8xyFVmuc8?=
 =?us-ascii?Q?4mn4TpnCtxO/BYXzgtR4+cRF9nwgnmpR7C6qjAzjiDV6VeVU/StlGbLNpy+z?=
 =?us-ascii?Q?stOyo+2LP88fo4h2xAimskqDVIQEfHIKaX2JG6+OdLmbSnWN4+tcf5g8o/6K?=
 =?us-ascii?Q?6t+UgkAhxvBEEVrl6Wg/qWwVbTCiw6Wdnp2ur6O5tZEkWmCEm79au0PGDXNW?=
 =?us-ascii?Q?bPrdCCBgdbe0iy8OZhRhsSlx3LBg+AWGf2sB6zlaFn3t+hy4h25En52Yup1o?=
 =?us-ascii?Q?VAh0x1qC3KNMfx9xufCMk2bqJFns73BmJ9nk9GSPfQvGjpuPmny6jooBsDed?=
 =?us-ascii?Q?kFtp18RUna1+AZA3HDHPgE/h19FYsu720KYxdzOpzqG8bUr6Y8HFSsCcd+M9?=
 =?us-ascii?Q?hA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c763875-7759-412f-209b-08db02e7f2f5
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 17:32:24.5221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xN9FVo+eXc7xi27VJvIcsoLlWVoq/eqFl3bDAQAZQEfjDslj1s3/TgwfML6WhdPRU3nvNy4VhkI3zjbjI/RVPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7677
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We assume that the mqprio queue configuration from taprio has a simple
1:1 mapping between prio and traffic class, and one TX queue per TC.
That might not be the case. Actually parse and act upon the mqprio
config.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
v1->v4: none

 .../net/ethernet/freescale/enetc/enetc_qos.c  | 20 ++++++-------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 6e0b4dd91509..130ebf6853e6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -136,29 +136,21 @@ int enetc_setup_tc_taprio(struct net_device *ndev, void *type_data)
 {
 	struct tc_taprio_qopt_offload *taprio = type_data;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	struct enetc_hw *hw = &priv->si->hw;
-	struct enetc_bdr *tx_ring;
-	int err;
-	int i;
+	int err, i;
 
 	/* TSD and Qbv are mutually exclusive in hardware */
 	for (i = 0; i < priv->num_tx_rings; i++)
 		if (priv->tx_ring[i]->tsd_enable)
 			return -EBUSY;
 
-	for (i = 0; i < priv->num_tx_rings; i++) {
-		tx_ring = priv->tx_ring[i];
-		tx_ring->prio = taprio->enable ? i : 0;
-		enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
-	}
+	err = enetc_setup_tc_mqprio(ndev, &taprio->mqprio);
+	if (err)
+		return err;
 
 	err = enetc_setup_taprio(ndev, taprio);
 	if (err) {
-		for (i = 0; i < priv->num_tx_rings; i++) {
-			tx_ring = priv->tx_ring[i];
-			tx_ring->prio = taprio->enable ? 0 : i;
-			enetc_set_bdr_prio(hw, tx_ring->index, tx_ring->prio);
-		}
+		taprio->mqprio.qopt.num_tc = 0;
+		enetc_setup_tc_mqprio(ndev, &taprio->mqprio);
 	}
 
 	return err;
-- 
2.34.1

