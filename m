Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6AB9670E1F
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjAQXwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjAQXv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:51:56 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2082.outbound.protection.outlook.com [40.107.14.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F3A4FAD0
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 15:03:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SF6krqyMKbEKLKm/q5k66qo734PAkOoLSTu9qDNHNqsVGqdSQaC64F23LAmVCA9gcKTA8+3vcmEg1tn8+j5fv1XOBMJO4VkfhYcXPSocjTX1SY4mDNNstydsyyh2PNouZtMK/6dmrA+cjmRuyfakFd8+a5ezoxH0jOb+w9U/LFZJ8dr5atiPX0CqkfEBNlmVq+DpXCVmefGno4XVRE+UclWgWqY+uHbBKhbN7ZAUPZNDS30ALMSaUIfkGO7Oa9xsEf0q8H9edeQTtnhQ7ZFql/vV/XGpIIA8Z6R5qN5SSX2iut9Aq5lhUc9lcMXvPR/pcgd4x7qtKfUl4LmItilK4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SwDqFvWRugxaHVGGKZaPnjWxCS4qo7/yHoZKCJKa5NE=;
 b=ZAdnRzso4GKcIgB8+phNFljmVLX4osSSqfvwzLf3e62KsBvmt8s3A6i1xwbjXdJ8arvdIl+ExUuHOvraGK/8UE/O8atDKTcuTFgj3uNFiBl0/0XQB1wDJzyvTZE3pGDMoqNv0tLLeZdAVvYi6vZn4iQySTtD1D4b2YDnB1RXvRu4g3KNhGrLFwUos+zep+x5wcpBx7lCOIkVkfg53sMiJgepyoPvG/jmtse7CSEusjzpOe+wx2kdgLq3BVfxn+q0yrmSOp9clNj68V+yjNFvbw+R5NOYlkYzflms96yR+G0LcGNE+rLIiECC01zA0bU6aDyu6PSWmeXTxGSj7vHqAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SwDqFvWRugxaHVGGKZaPnjWxCS4qo7/yHoZKCJKa5NE=;
 b=NwVQdgzvkVUYDzn1soN8eGxst8HEId/RjGHqQ5cYCSx5+dIsAOAmNA1clLLYchmRepDB06GzGkxHa7a2KSwhlsDTti7a8VkEouK/wVs5zEAHPBNGpSygIvzGKPJ+8+tJsGY57tHl7DW+vtBKW88wgNjeseuT4Mfy324z77EbK/Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB6808.eurprd04.prod.outlook.com (2603:10a6:20b:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 23:03:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 23:03:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 09/12] net: enetc: implement ring reconfiguration procedure for PTP RX timestamping
Date:   Wed, 18 Jan 2023 01:02:31 +0200
Message-Id: <20230117230234.2950873-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117230234.2950873-1-vladimir.oltean@nxp.com>
References: <20230117230234.2950873-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P195CA0002.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB6808:EE_
X-MS-Office365-Filtering-Correlation-Id: 259e4183-01a5-405d-b156-08daf8df0678
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xmN2SSct0CbjC6bNpQvzhyz2hMDDcbpe056GgLvtobKW8Y2Aoyt2vr5AHOePzfZuF+ADmN8qripv9Uv8+m1gjWjXijqu+4XMYApjRgdM9vbajjUm/wgrVCaVP/StIxPDJ7YfXNIFXw+ZKGh/HZ5sYSV3ppaTc11wYyZKmqPn+x7UawWxdRlYYCFoNPS+cAtWpEaVMJAbIHrahARTOUiorHDZkPYY2jYAnf1teo+69qNVvKr/phDBo+LvtPIK4GEkAX0mQdvzAYwRxwEdqtr6BDiCvKbf5ncDZsmdvY42YIWse7eToWzM2Y2PpMhUrlWBZjxFGsYbMM1MolLpSS1lVL3Od9s/3pfsIvk7SDNtxrgd35AD+93D+9m+Ivnz1JyMLA4lDC+oFo1PIgNMEHGHUfL32mCs+yPSP/BSfgRL9zrauP3xMt0kVSqd+6wSwjmq1I7D6TY2lHNR1XyWAGbqsCC8la+I8bwAoSvZlk4dCSgi9hcPpQJ+2izlOi08MN3Q7EZj0CmO8WUI5gHBJLr9A0Imd18CoIg5/Db2X1IVPgYW0v2JlTfSIKxjnlNqvsrXxFSJLoy2Ficjukx6LjaTf1vSP/zc5FDsracctEHdbQVKzeEa+Lxj7/1yzWEezCozT+c3NoO3s5nuXwt/egD1AmTb3nPdqNEInP0IbR+6cLDWyo791iSZIgZRa7DnVjj8pdXkFD4B86EL1CGxcmrNCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199015)(86362001)(36756003)(38350700002)(6512007)(8936002)(44832011)(41300700001)(5660300002)(66556008)(66476007)(8676002)(66946007)(6916009)(316002)(4326008)(2906002)(2616005)(52116002)(83380400001)(38100700002)(186003)(478600001)(26005)(6666004)(6506007)(1076003)(6486002)(54906003)(66899015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KnPbofgSZrKM63b2/RF/rZ/MBn1EIiGoAayNl3LA53X1TyoMaOi25D9JaNaZ?=
 =?us-ascii?Q?AKDqA5NeVN7WhFQMdvzij4QUtSBqofTBo6PSCQ2Gh1dkn0jTzOoP2ZMVh1OZ?=
 =?us-ascii?Q?Bls2OaNr2iMEQZBJxLnQvHkSEc1Oo23aGl+kFG1Nk+kb6XfDhdmhNLXTqm5S?=
 =?us-ascii?Q?VsqhmaI32DnHcuE6h962DZx+a1OGe3uN/XNqCrnf98zqUdr09CwOd79j8ieD?=
 =?us-ascii?Q?7ADc2XavXuzr03BTaUZzt1YD04fB8tONRMcVZnp0rLKMhk88/hx/2huZmki4?=
 =?us-ascii?Q?AUlN7ML7stmnE+CzAwadI9B+tLvnbP22LV1OUBRsKoL4p2CgP4N8abR91usu?=
 =?us-ascii?Q?kjAzkuHfTDlCh3rP6tWlx8pCtPD5EHoxnorLOp/ydPNgsNRLEPBDtFKxN7iT?=
 =?us-ascii?Q?pbps98AwqLMy46Pg1bUxMyjMyo6oHRWGlVpgVdGqgIS4V3Ojz+aLStyoupzS?=
 =?us-ascii?Q?yKVTAwh9ydASeoSke/k5bgCOoJeOGKaVVViUXfgJhs3T2pL+hS9K/fEK4fEH?=
 =?us-ascii?Q?TSpeyPzF3yNl/VMRetpuRuwUjE8xR/RTCsEPgJmWx1JsmWYc5NAdwQ3IcJhP?=
 =?us-ascii?Q?pdOwdIDWkIJ4GCyRAJsv6LAadyS8SorctVxV2YyQgLx6o4M+OChM6sqTsPzy?=
 =?us-ascii?Q?TBzQa4Qw0z+ZTslaDNs491AzbivTPWo8t7gbKc+HrzxR42u/mnoDw+w9U9T9?=
 =?us-ascii?Q?tjc49dYCTtVCM+1xBNr7bA+vG++K+pCXDA2Or88ralr750kOixuE0dJuiY01?=
 =?us-ascii?Q?0deJKRbPhFVtqQwdmq4gb60yOEdppz+qTBPGAfGkOyFGat/31Y8EAxGkpAQL?=
 =?us-ascii?Q?6h5k+HGIE5e0gQTTcQbE4UULptVDSfadRTxIgAtJ1CwYpRUsVFz/APHWPoK7?=
 =?us-ascii?Q?T56sqdJ5nd1vQMPiWtx6q19CAjbkm7+DlyhpMfbwxdZZOHYc27kqPEhCIeKY?=
 =?us-ascii?Q?APNjtQvVRV9Tc/HNOnYodZwN3cIKFA27phbTrkKQTVskkkFfbMr7+Rm4sc78?=
 =?us-ascii?Q?RE/D+q+gTUw9bykJCpcalIhELvtHsBkj8Z9qxfh+IoHqf4D+cUmnck0uLjxa?=
 =?us-ascii?Q?ouZCJ76yumqXZg1EKh895E3etfO7pPatZmbL6TuSEG6/LdrDc9VgjIoVnC73?=
 =?us-ascii?Q?FcCAgeHqRjC+7yXvcedlVnT5A4s1XvramIoFHD6TOca7Dy+IHWI2c1xiZJQO?=
 =?us-ascii?Q?AZ9oJifPHjq306HDfjM2plbl7UtiyrWZzUmAw+3tCCzK7YIXTxBdj0QaVBBZ?=
 =?us-ascii?Q?dwSBUiq2WGoFMHjXfFDMuQmdbrltoJofBuR1YOv01p/2NU9+BnVppqS9nB8e?=
 =?us-ascii?Q?w2Y15b/YFXdksQIf11qB8ywK8GGV9C7Yq3TZyCu3zV1BzAU6tBoV7iDCwej1?=
 =?us-ascii?Q?X6Yj2jRAU3JL0+Lg7Zj/NqaeLHm1Zd/7JX7OUqbCaSdxVJ2Dg5eSqJiK6xgJ?=
 =?us-ascii?Q?XkL1TozK9RPQGwNSxu/oxLMPrJN1k8HTn/a0KzyxGYcGOw6goxRz6LXjSMRi?=
 =?us-ascii?Q?AUMctDqQHP1dFev9wriaA5rguvAPff7qvIW7mJpQ1cIMe9CFlyznJ7xfHpYL?=
 =?us-ascii?Q?RXHnIy5BsFG5iwcloNhwmB43DYd+eUHyaAYAzUFM9Dn/tT5NiQ4RS9WoV8gf?=
 =?us-ascii?Q?Mw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 259e4183-01a5-405d-b156-08daf8df0678
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 23:03:19.8971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nPrBw6Qf+KYXUMSsiELhziI8TekH21bbytLREjvoA9/FjFlCZCRe1DUgOCOLYIakLl8qA30uQnwYcV6hk2i5/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6808
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The crude enetc_stop() -> enetc_open() mechanism suffers from 2
problems:

1. improper error checking
2. it involves phylink_stop() -> phylink_start() which loses the link

Right now, the driver is prepared to offer a better alternative: a ring
reconfiguration procedure which takes the RX BD size (normal or
extended) as argument. It allocates new resources (failing if that
fails), stops the traffic, and assigns the new resources to the rings.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 68 ++++++++++++++++----
 1 file changed, 56 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 014de5425b81..dc54fe7b4e86 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2489,6 +2489,46 @@ int enetc_close(struct net_device *ndev)
 	return 0;
 }
 
+static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended)
+{
+	struct enetc_bdr_resource *tx_res, *rx_res;
+	int err;
+
+	ASSERT_RTNL();
+
+	/* If the interface is down, do nothing. */
+	if (!netif_running(priv->ndev))
+		return 0;
+
+	tx_res = enetc_alloc_tx_resources(priv);
+	if (IS_ERR(tx_res)) {
+		err = PTR_ERR(tx_res);
+		goto out;
+	}
+
+	rx_res = enetc_alloc_rx_resources(priv, extended);
+	if (IS_ERR(rx_res)) {
+		err = PTR_ERR(rx_res);
+		goto out_free_tx_res;
+	}
+
+	enetc_stop(priv->ndev);
+	enetc_clear_bdrs(priv);
+	enetc_free_rxtx_rings(priv);
+
+	enetc_assign_tx_resources(priv, tx_res);
+	enetc_assign_rx_resources(priv, rx_res);
+	enetc_setup_bdrs(priv, extended);
+	enetc_start(priv->ndev);
+
+	return 0;
+
+out_free_tx_res:
+	enetc_free_tx_resources(tx_res, priv->num_tx_rings);
+out:
+	return err;
+}
+
 int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
@@ -2681,43 +2721,47 @@ void enetc_set_features(struct net_device *ndev, netdev_features_t features)
 static int enetc_hwtstamp_set(struct net_device *ndev, struct ifreq *ifr)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	int err, new_offloads = priv->active_offloads;
 	struct hwtstamp_config config;
-	int ao;
 
 	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
 		return -EFAULT;
 
 	switch (config.tx_type) {
 	case HWTSTAMP_TX_OFF:
-		priv->active_offloads &= ~ENETC_F_TX_TSTAMP_MASK;
+		new_offloads &= ~ENETC_F_TX_TSTAMP_MASK;
 		break;
 	case HWTSTAMP_TX_ON:
-		priv->active_offloads &= ~ENETC_F_TX_TSTAMP_MASK;
-		priv->active_offloads |= ENETC_F_TX_TSTAMP;
+		new_offloads &= ~ENETC_F_TX_TSTAMP_MASK;
+		new_offloads |= ENETC_F_TX_TSTAMP;
 		break;
 	case HWTSTAMP_TX_ONESTEP_SYNC:
-		priv->active_offloads &= ~ENETC_F_TX_TSTAMP_MASK;
-		priv->active_offloads |= ENETC_F_TX_ONESTEP_SYNC_TSTAMP;
+		new_offloads &= ~ENETC_F_TX_TSTAMP_MASK;
+		new_offloads |= ENETC_F_TX_ONESTEP_SYNC_TSTAMP;
 		break;
 	default:
 		return -ERANGE;
 	}
 
-	ao = priv->active_offloads;
 	switch (config.rx_filter) {
 	case HWTSTAMP_FILTER_NONE:
-		priv->active_offloads &= ~ENETC_F_RX_TSTAMP;
+		new_offloads &= ~ENETC_F_RX_TSTAMP;
 		break;
 	default:
-		priv->active_offloads |= ENETC_F_RX_TSTAMP;
+		new_offloads |= ENETC_F_RX_TSTAMP;
 		config.rx_filter = HWTSTAMP_FILTER_ALL;
 	}
 
-	if (netif_running(ndev) && ao != priv->active_offloads) {
-		enetc_close(ndev);
-		enetc_open(ndev);
+	if ((new_offloads ^ priv->active_offloads) & ENETC_F_RX_TSTAMP) {
+		bool extended = !!(new_offloads & ENETC_F_RX_TSTAMP);
+
+		err = enetc_reconfigure(priv, extended);
+		if (err)
+			return err;
 	}
 
+	priv->active_offloads = new_offloads;
+
 	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
 	       -EFAULT : 0;
 }
-- 
2.34.1

