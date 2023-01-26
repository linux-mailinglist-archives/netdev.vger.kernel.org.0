Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F2A67CB5B
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 13:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236663AbjAZMyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 07:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236518AbjAZMyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 07:54:05 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2067.outbound.protection.outlook.com [40.107.20.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21766DB0B
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:53:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WX1pqggr9U3/4f/QJ6fXg31wOr0238lQhPvPlhi/khM+CdIk8Ev2xVbn1zdphgxh68SOnljKoc2bZG8KxCLN86Yo8H5TyOKGhWlHfvEBS2diMJABhXkuehFvJ+QG7f1YtTeZgH4W8SCJinsXo4G6/xk/0y79O0TQ6l0I5Mp/etZjypSK+K7ny6bRht3bLpkKEm5wB/7iv14AtgSFIS6gvd0N52O1D5LCrXVcIAGfqi+HI6t/gMkqtRx1E4GMYcRY6k86fNQJP0Eygsf16El0PXJr3H0vmlsNdH4fsUUU96G4guk43SKuWeCiAwihvZ45wa83bQRGEYp3a+Onyu5HgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZnWYhcsfzxUZCLoz37o6F/w3hYijycrzBaEkcGOkWRk=;
 b=htepwTu2puo8DUJIHUixEDCEWO5xn9oyOM1uIv6L2679CiL4ZKZG5oj/6i1HbgMRZKdpExCGF3eHu+ZICWdZ7RKO37LXa6yTANZorDh70gQC/F5tf7VUY3Uoz0C4NWoW4rYxd6AQZDy5L2Q1ZduDSX5NFw5U2+A2gye90OXvOGU6PN7lKoIJYeVonIjImdD+3VpFEvNoF1u0bjod9rkYcEYUlHhCxsW3xbjIFT4gqT4HWpKLsggdmJmolJyrZsXjYExhpTEgaiETVIFVARewjgUBY5ZbMFQgvq7+S+etUAdcovjhJaUN6v6cWsgXha5HIH4ziaGHnriUTeCP8+0V5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZnWYhcsfzxUZCLoz37o6F/w3hYijycrzBaEkcGOkWRk=;
 b=gcnjGyE02CX5+TiRIWsmCtpHYGomYf8Gg5ZODolr0t9H+ynUw1PkHqzjGToJfmRU1sV5pu7Ub9lTdSYf97CsqYPJFF+g0Jm1M9EtpGBEtvMS2mpI/Wf3G+h6+Lw+shuyEiFyRGRXOFNajhP9zFRc4jioqaTz9as64XpJawAAVN0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7347.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 12:53:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Thu, 26 Jan 2023
 12:53:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 net-next 13/15] net: enetc: act upon mqprio queue config in taprio offload
Date:   Thu, 26 Jan 2023 14:53:06 +0200
Message-Id: <20230126125308.1199404-14-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
References: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0123.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: 709e6d91-f52c-4be6-646a-08daff9c5d80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9zXnC75j5qQt2Sv0pgJAR/eUdLGctpoWed9Q2yO4JBiJBjnj+jR9T+YWmcnKEWWpiNhmY3YtM6l4WiQ3NcgTu7xytXi9QzoPaD95xqug9kBVzOOOd5N/81mxTBNjOWGDFk6TBHenD8sw5ar4JzMy3jROLYdZOGOHTcwkhMmBMHSnBevJCfUsPhzCLLC1Jwr5peOK3JW2M+YS96TkJpluIs8RbIRCKdyQ25ZqdfVPAIofO16JMeTIBIEDajUwK6ZSOPVXCgi8CRVk4LfaCgl30KjIk/EsM+ze+GxKRVnczjWsufy69yiQNRZtfJ2odP9eQLyWQVuLClMjJwtUarGdixuhjqbdAx98wokyQB9xbgCj6sMboS3UoM5DcmBLZfCOjc0niTuT9Ruk0kXoamdA6n5gcgidBpmBrr3R0VAfRmoTnWNpl0ucGhGCqnnzFrylJJfPSwqi7IERQul4OW9zmyjzr7e3+zh7Nskz5mjKP+gqbTJwyIzqfx9NHPDWbyVE8q+rHZYAa2RmT3eyIA67HISvAnK1Jsa5NKx30luWW0XaJtAPWO1HV2LRWnmz5zWtU9A6MHbuz3Ac/ApOz3G5UQAq7fYm4o8feFlPM0tdwX+MShjafbUoVQmlhCFY51XU1IqhxAWnqecE/ztwznnGtbahvg/lQbHhgVcIIO34vFhEe+UVyuNR4Z2ugCelCCev9653K0YGhOZcy1dtuaGJ4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(451199018)(26005)(83380400001)(38350700002)(38100700002)(5660300002)(2906002)(41300700001)(86362001)(6506007)(8936002)(4326008)(44832011)(6666004)(316002)(186003)(6512007)(66476007)(66556008)(8676002)(2616005)(478600001)(54906003)(6916009)(36756003)(66946007)(6486002)(52116002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iPS1JL9C7Xz3nu12YkRdl4YhS0kh1kw1lSxPmfekRpOTvPzAd7VGU7auuWgu?=
 =?us-ascii?Q?rtBCBjC9+Rg8BU3Jx9zJfK9W78nwiL6/I4MCO7XG8MjWzh6mzxoTJTFHxgrj?=
 =?us-ascii?Q?Rk7ha7pBPgttNhujNIw+k9m4nYF2MiXxFg2ZKYu39HwYTc5tUimoCruwmaSO?=
 =?us-ascii?Q?hj00BjT1Xig8YByPamsZIvApDDpZYapayFr9uWtrueJUvWOsnyeoP56IrSur?=
 =?us-ascii?Q?6PtJ0JRHrOh5J+pK3iyEkj0PZizR4b0qPOXC80Jtkq3v3oh1vbwBdWmlWVGk?=
 =?us-ascii?Q?2xFvc4mXwQ9G92uziFlAHxQxgqO9MMcxwG96IXn8m3tVBSje1bWatiP1KaGf?=
 =?us-ascii?Q?peTm+99Gd8PLKoOTTETOH5qr36ekXXqkSHgQeCp7xs53lT7/aUsV0Z8eAPiv?=
 =?us-ascii?Q?1X15GBGZop6lAXjYXvJ4CHJ68zv+5gmjVTsILUDhyFey/Q9bgFzyGI9VAWbr?=
 =?us-ascii?Q?aCXW0PVmGMWe6xw6YGK0/AWAKWdHi5oYOAgbhWzWErLQyslXIXbl7qK8Ub1E?=
 =?us-ascii?Q?RAHjGuxhWoHmI2fS6UiajWaceFOqsT2uLn9WrtFXilTfsNm4dQrJNLI1OXQD?=
 =?us-ascii?Q?NZ6PfM8p+ytN06Yc2v4rvugQzcJnN1I6vOYy5Cu4LbB32tYOmujOYdZ/n4nA?=
 =?us-ascii?Q?cOVy3r83HU5fjvc8BD89WO1nBAbB0qJSerBCTdts53hSw+FEM7btl7t+jrv3?=
 =?us-ascii?Q?D9I+qWLPWyR47UvRCb+OuVeWy3NQC3oZEbl9wdPlCOsK/0qTTL3EmMA0EA6h?=
 =?us-ascii?Q?iEGYFHqtnDP5FHQuqeW5hJ+ZYngbZybQVGKtGzjggGk95XLCH9dV+Q6dfC9x?=
 =?us-ascii?Q?zydbKh90pbM0LD5x37PAkrB8Um9PwLG4jUR6VtfxeodkPydn4yLzW/l3S3Aa?=
 =?us-ascii?Q?OhLyMVBJysJyiWqwjtaTH1aMmb1tmar52GUAFwKrQKXF7Tq6yQDwujlBwzmb?=
 =?us-ascii?Q?TM51yHyhwVS79EgP9IkoIAmV27k2WYYLWpH/XN/7RIc8qcliVE1+4r+K3Bqh?=
 =?us-ascii?Q?HrW8EIyj5mIc1baGbmsg++eYAb9qIJahSmp/3hrYvFLBK4BE9vFQT4cBCRVB?=
 =?us-ascii?Q?Yn+eUWfSHm+RsntSN3ISAOSvkwBYjfBHsdswqPRQ3zEaZ4nYUe7hj12VOpEY?=
 =?us-ascii?Q?xkG5tH6EgSPkwK962+0wcuYV+Mubv+FxealzmunVjSQaLluiF5CP5AEE7euM?=
 =?us-ascii?Q?Jjjbda78ODE/38Qo+a5eXYap5y/4hGtMFKzYp9QBlChYDhbsgDjlTcmQ+qxC?=
 =?us-ascii?Q?H98qkMldrJjyGrgzo18ht57nvS/QFEUkJ1vCAH9lDSw8iJ0vfBFIQWtl1eJJ?=
 =?us-ascii?Q?bIS43iQ8oi6ilgfEQPZBMdbME/a2rS/deMZBZQhr87jHy51gjc9ovQLtUOMF?=
 =?us-ascii?Q?IL3m5r0zzItuJMsH4q9iy4C4QO2GoTFfx6Ln6+P6IUsD/F6WMJbVNuIaFSfI?=
 =?us-ascii?Q?u61lLqif0V4RoNBHLUVrCiKphMg4SGK5U2K6LM+BNWqWpusb3kyEtgggAc3H?=
 =?us-ascii?Q?px31FB7uQSqw857Q8UpJzJvvQ7bP0E87GKj2WvjLWo/r6kLaO7u7/wkRlC7+?=
 =?us-ascii?Q?Zb0XqCgsu3aPDCsjVyC5fFUp3cLQw8RzNf1p0GKoQUpHv/X9w9nUyb3QvSF2?=
 =?us-ascii?Q?kg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 709e6d91-f52c-4be6-646a-08daff9c5d80
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 12:53:47.7054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gKtTOoTAuvXpKcPkd+S0nd+AmGUg9lYXAwP7hnAC8Zp2OzHBjXEgJekIvO2eC+v822pBuciFvGxmY91UjWP0dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7347
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
v1->v2: none

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

