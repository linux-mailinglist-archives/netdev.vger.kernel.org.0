Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C933C688B7E
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 01:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbjBCALh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 19:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbjBCALg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 19:11:36 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2059.outbound.protection.outlook.com [40.107.14.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752C2751A9
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 16:11:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HiVPeVZdyCizbdNWWKHg341RWMbRCpoBUtajk+aQ/rGUIlw/p2qhmOLOBYhs2/Ref+SLrt5fBRibtN2EM3ztKrv/rRtT4V0eCdN2V9MwhKJKm8SnKC3fuOWRDaxWmz/kaD7tNNHvRkZqNHhDdkFItIXqHZcvfnWz1tkwZLvfglErrBgnQl6VRFMd9cRWyyn5lx5ft7DRJZATkzikYNnPADl+uq4nTngu+OOdw5wST3Zvo5a4idMmExrn7cVrRU5RgJyglvDLAyaTGM3eMJptHLzwgcpfYu1SIsJ3iZJ6NYvd3sx77jLGtigxkivID0jjbArKvExmqwBLOF+0tl7rQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1eRusEOXpkGeD25pJGGLjku5jH7kAocXv6khLKkLJZ0=;
 b=Z/uMduCvtTrlCF2+8a7fDHFVX3psO1WdtXpdhWJIvtoC5a7FoSrzb0X3SWJjmdoSY6LUOsDgxiKmD/YZoqTy4Y+qGEIpm5XhS3weBhoT4t6+Aa3OAlwx22fq9Ke4rgKXwbjtwjx3xJq3A+j9EG6gzBhdBfq3Bz1/T0FymoFie7POn3CHJRf4xKBKE5UFlkqMMQWbMxYRBpp2DVUneCtWGbbiX+AcMh15LmJ+GyvFcZ8gCL1FXJpjuB55r1nWY14ec4hUlrbZCE3Vsf9QelNycWHFl9JZucMc8uvJqoAhy/7oSSYnodVgL0/cQW07yt08+MqfUgn85mzvCvAFe8Vwqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1eRusEOXpkGeD25pJGGLjku5jH7kAocXv6khLKkLJZ0=;
 b=s4fHVAQ5Q8MUyg/xfc5ySIw3eZ2zREmOdipbQacRSEfBaGNGkz2+AXCJSDA4D5Pu+AJk0HHf2rTFLuVAnQMaIpE2z3yFUz/qbTOu1AifW02O5ULBLpnWvM0keag/5nE4wWberazoP766C0aMMRDDcjkudCSqNBaCg1POxFwH4iQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB9128.eurprd04.prod.outlook.com (2603:10a6:20b:44b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Fri, 3 Feb
 2023 00:11:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 00:11:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 2/4] net: enetc: allow the enetc_reconfigure() callback to fail
Date:   Fri,  3 Feb 2023 02:11:14 +0200
Message-Id: <20230203001116.3814809-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230203001116.3814809-1-vladimir.oltean@nxp.com>
References: <20230203001116.3814809-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0118.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB9128:EE_
X-MS-Office365-Filtering-Correlation-Id: ef96bf14-dcb6-4381-b499-08db057b3582
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ai9HETFOSevoe+TvvcveGgvR8qYTo1TVD3QZheeLQ+FEKBacaG7G3OtczdKYD+M+fM99VK5nooqyNXy7Fz7JaZYOzJGB6lJPvOmtSQK2XaWxdhMZcEWRkbkSXWfIG0J7zUQf4hJZgI8eswVA1YNwYFUp2SfI7NGovZvQDC1+lIPvh4tSP9IxCz/N67/Tu+NsKNzjQlbHOiWjnJtCrxe+xerjhAEwnZf+QAVabPe6xs71ID+sF1ioH93Q3YWXV9YUARXRG6tadi67J0F4C9jnKGs/mFlBPpMQRk9f0GDDEouSrD0qN+Mnn1yCJ2fZE843Mhk9QqpZ3uVj16F5WaN666uwNVCzxn4O2KXZ9jsRXJgugMes9tTA46fkSzObFpuzjJh4raw9XVz4Mo96HmdicC1vHnmhaSDlfTYWHAUtWvAn25lFDJSyCu80ovEqyOaxvLHzqI4yITHF3ktdKD7NqCPQNzz+q85H5BsxYANxcECcs5lHIOqBjdS95KV4/b42h7Wv0Pj2zXpZwBkPeIqO4qPfHK1fmt+EgKv4WpJKbkPq/stGlCerQ7WePcLV3/Chl731AwyJI9sTDjkkqsUpDeNscylXeJnGY2TK2x5pbqNBu1k1uAqzj08Xc/vIuAN6oBKflwfgMLYRpzp5J8rZT/l1t9E9tOi0a7UJm8BYv8wY/C5Z1v/ZWoq0NC81Cw7eHqmZSqJo3RX+gkoXb9hBng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(451199018)(2906002)(44832011)(26005)(38100700002)(38350700002)(52116002)(36756003)(83380400001)(316002)(54906003)(2616005)(6666004)(6512007)(478600001)(186003)(66476007)(66946007)(6506007)(6916009)(1076003)(86362001)(8676002)(4326008)(8936002)(66556008)(5660300002)(41300700001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zdWxwjjNrazVYaDPBNqL6Zmje0N2VuZaCVmUL67EYxJkSOfk8+hSQWRNWIN/?=
 =?us-ascii?Q?zCzkeNAtxhF3+c/0sZJvig8/88dJHQ0pVNngV7YBXngq4/0KUqAZnmbiujxE?=
 =?us-ascii?Q?I8/7GC0Ec4Z49DAdMvASJn2p4HFpw+Ele0MPXQ88twlhvkOPdK3I0wb6T1Ul?=
 =?us-ascii?Q?oTUwOlJ6bmF1dOLLK5TWfp5s9T7yH/i6IAAn0DXOH17aDexXi0Mf1/belD7g?=
 =?us-ascii?Q?aJ78IrTVKCFGqcY7ZjkqnQLwvN0eFdcqawB1ojD0aqGuv3cJl0SqK2U1p8EQ?=
 =?us-ascii?Q?dcWoaRwKbRklyruV28GQIZg2KkyZLfGZ2zbIvHaa+pT6ZFHet0yiTxUkclFn?=
 =?us-ascii?Q?ZV9qANXhwQjFrGsPm0aYLxKyYU3nWl2OCMXHXfCLcU3vM3/3EBB2faZxGUNG?=
 =?us-ascii?Q?b453wOHFdYS3QzGBDGXRzUQ2Cl+37yqxUIu0Pfn7x24Ol5bcblohE0+EaEoV?=
 =?us-ascii?Q?qTLAPaR4TfNvsmPMJsvTTenRvmWrLt5gAA4rpaTVZdJlh7HeBvhUxRw0qjMI?=
 =?us-ascii?Q?SxrIzjv7FK3KkGnGJ+SbprQRmYCvg60BV06yfwlNNo0I27sPvoCcbqUgH1V+?=
 =?us-ascii?Q?miB0WeIaRW4CjdZvFl423F+AcKPlrDOSsP/ipeYmhHXsCz5wunzTfCBcaC7/?=
 =?us-ascii?Q?mIoDiYWTiDqBAlSG9cyY+bQsCjhtTASD96zmCnrULh156rH5xBYf+u+M3GVP?=
 =?us-ascii?Q?hzPljOgNZsUCzb8m95q7iMynlLEt2GyHC5pEf/1SM1pTwOWvMwiNfdfbxIly?=
 =?us-ascii?Q?jz2QKJEPffvhI7le+fga1hYb5nqbg9AySav2HbXvb87r4diUnhTp4JgNnXD0?=
 =?us-ascii?Q?wtCKqgojd73xac8zG+9WzAvl5KE33VA0JLMkIS17loBzIiYQ/zjxHvk6ocuh?=
 =?us-ascii?Q?b5/1kMpPUhrlQVNDQfgFr3QPyDvf2XFUjl3CuRewIAY9MepMEl57FHFShE/L?=
 =?us-ascii?Q?ZcZomrAKYHF3TxJ+vrbqWT1aZLBOYxM+ktSjIKe1NEGewSyac9wc2iDAQ48e?=
 =?us-ascii?Q?lm5O66pdEnL4qdaB7Vu/EAo6DOFlbKIjn11tHK8xe2UcaglUXBrRb/Hdtggd?=
 =?us-ascii?Q?7nvYd4STwVgrc28IgMEyEKDi8XXyHXbkqxCs9eo16rl9gfPX/lQJ9YwMbuSa?=
 =?us-ascii?Q?0XNHwbyUaWJVCdk3y6ZXemX/8VLaPwYEbzaXQXkyyZGeqbaR58/kIjpEHGei?=
 =?us-ascii?Q?HFsXYjfnnfLP7Rv06NGDDqkthT9SllAp3hlNYsPTjjJvMxnejq/+lUi03/1O?=
 =?us-ascii?Q?fE1jGELxYIBUvoZ3mNq9O3B2tv6NhF5vYmAvWlIdC0Wk+IGM15Q1xF6Et3Xe?=
 =?us-ascii?Q?dnUeUvNYCZLXl/xeEKtGBEi+dvtRBVNlsvVPqFBhZ9CqHdzMl306XrQvI8/B?=
 =?us-ascii?Q?eOFuzfu9FeiEJmlSw4G5f4eNoYos4q2aq6mu8+V1l37WDfpH/OtPlMAFStqz?=
 =?us-ascii?Q?LUyEervSgZOwAge9fyz0jlOiHt4UDXs4GBgac4fJU42IvSTYqEPKFmMX/+MP?=
 =?us-ascii?Q?KRiU5QmbBdb0KltGgYZX7wmxU/Eb3cz8SF7vNJcJOC/tqz4C3lSq2iUCCkVI?=
 =?us-ascii?Q?sK7V+iwdOWHdzvvaLN7YMcltOURPdOpGlOkPOVCeEAF9cu8EKAwfB+mGccqU?=
 =?us-ascii?Q?SQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef96bf14-dcb6-4381-b499-08db057b3582
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 00:11:34.2587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ioJrTg8SR6Gf0WjAzFxHD/EzKA0J2IgnhbVeIu+1PPT1YGvzIH/4i5uiHuGlLWOnkO8hABCvEWukWt/sHCFdpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9128
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

enetc_reconfigure() was modified in commit c33bfaf91c4c ("net: enetc:
set up XDP program under enetc_reconfigure()") to take an optional
callback that runs while the netdev is down, but this callback currently
cannot fail.

Code up the error handling so that the interface is restarted with the
old resources if the callback fails.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 3a80f259b17e..5d7eeb1b5a23 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2574,8 +2574,11 @@ static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended,
 	 * without reconfiguration.
 	 */
 	if (!netif_running(priv->ndev)) {
-		if (cb)
-			cb(priv, ctx);
+		if (cb) {
+			err = cb(priv, ctx);
+			if (err)
+				return err;
+		}
 
 		return 0;
 	}
@@ -2596,8 +2599,11 @@ static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended,
 	enetc_free_rxtx_rings(priv);
 
 	/* Interface is down, run optional callback now */
-	if (cb)
-		cb(priv, ctx);
+	if (cb) {
+		err = cb(priv, ctx);
+		if (err)
+			goto out_restart;
+	}
 
 	enetc_assign_tx_resources(priv, tx_res);
 	enetc_assign_rx_resources(priv, rx_res);
@@ -2606,6 +2612,10 @@ static int enetc_reconfigure(struct enetc_ndev_priv *priv, bool extended,
 
 	return 0;
 
+out_restart:
+	enetc_setup_bdrs(priv, extended);
+	enetc_start(priv->ndev);
+	enetc_free_rx_resources(rx_res, priv->num_rx_rings);
 out_free_tx_res:
 	enetc_free_tx_resources(tx_res, priv->num_tx_rings);
 out:
-- 
2.34.1

