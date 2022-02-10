Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F7F4B0F0A
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 14:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242361AbiBJNpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 08:45:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242363AbiBJNpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 08:45:15 -0500
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-eopbgr40065.outbound.protection.outlook.com [40.107.4.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DDAC59
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 05:45:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mXhMSpjFkYVlO6IjOpiPHJkLjlBbV9R/UFoUpFBhuPi6ZdeuuA2h1cPuYucjlfXo2WVYA3gwoiCyYKebkIMsHtB9+8m4DNS9GQ/wDQOq/g3M5/QdnQEtxqgW1QsJRbqswZC9p2NeoSHdtwhz+k0S0tT3KYezjw9Q2HMTnD3EicX57OXt++uJjM01jzTLZc8ijl7ED9D54w0fSb23FHlEv/7uhwScRLX85OAZ5toVIdSRsZMc/Ue0JqmcTnan+5EccxDbeDtLLYW74/OH30dwTw66D7LibGy2gu49bU0AzElm7sMqutMIg3Pf2bBULk4l2S3A3ztUKtCCq60P/1eWYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=puUUm1aIhfu8KDmV20S1hxdl4XxkX4PCFSfg9kHvqT4=;
 b=hHVzWlndG+mgutSN/4pG9r1dqmFZC5jB99c+CS7LkYqWE+717UP2+UqgXqHHBlN0N2zkaVKVFW+BnB2RYwUy4QMPwgNVJTL51l0L+hH5xjwsP8SqHjMmmG9Im69YwNdLKYmCu3pkB03JCpqekt/wohcW99AZujtxk1+5PzezJNdpsv/4ImHLpZ1Xv35K7y38ZqL3MAMXRldnhu6JzfyYSHccadiW+nmOyY7KoPGMmWvI+EyYnaE3ZCcWjDk/BbZYycsCEt+e9f+wb74iM9BK6ZC+QCd6WINtrqXBz60Ju4guqGza1botfgdTturS3DJ+8SPDNTgD/SlNIjWYSN5GRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=puUUm1aIhfu8KDmV20S1hxdl4XxkX4PCFSfg9kHvqT4=;
 b=fJjztSqyiJILIygNE7apLtOrtaMoDCqGpeJ/FGT7QaFcacNlnLnKPNRwlI8lGw1IacTmObhtSTcDZ1bA1DLM1UTC1GVvzsX9ZNJSflSWBflwAG2CDhNooMGVu8sxbsep7h3KxwZ+kkKe2sw1CXFP2dYyNGtr7J64HtMoCWcyt6U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4301.eurprd04.prod.outlook.com (2603:10a6:803:4a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Thu, 10 Feb
 2022 13:45:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 13:45:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH v2 net-next 3/3] net: dsa: remove lockdep class for DSA slave address list
Date:   Thu, 10 Feb 2022 15:45:00 +0200
Message-Id: <20220210134500.2949119-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220210134500.2949119-1-vladimir.oltean@nxp.com>
References: <20220210134500.2949119-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0097.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73f12bb8-fca9-482e-f0dc-08d9ec9b8fc7
X-MS-TrafficTypeDiagnostic: VI1PR04MB4301:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB430171F6262133271A66953FE02F9@VI1PR04MB4301.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:422;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b4xXjg7cL904u/eN6esI80FcV62kxR/0ntlvIfzRnUI6orlcdFfPhnNsj2rodiFwe6AEqsr5UwfEjjDUZLQNhiQoiRlD3sBrLb1fDRgob8WBfibhqTKMayiO7PZRFszoVPu+f7COY6I3YhrdH6h2Q7X9t6o5DzlMil+mwmkQ58pAkGGW960+c9tj0OgTiNJ7WS8QNZU++iYZQEIrRkAzhd4u3ceqkD99veZ2u5jMrb6+PGkoHRjp3b1XFp1hD88mZ8vQ524bpTTggG6bP6o5lBVcZDfdgT0pdaKSQKiTQDRlUYJXMGXaMpPRfjYJkLCniN22L/thhqIGmaUgocSyLdtC5Do6UHckwMYuNCyvrjVkkhNCKm9B+LbAF5YSyQOs6CnJjLFwt5+TRGBWIcSwk7mpITezbirZsMz0bXfjI6KufzjkEuklFq60RStWJf1ILUyUsUA3/fNa5O0au2gne1xu9EXttPiMJ2fX/BT3aB3E8AoO90bpl+ZC0r4NKBQZjy/Dqn/tesv5tHiw/PnkySlaerIRrISza88CvUDcf2irkShy+Ijb5zrqLBOizEglyapUFEtLIXC5Wx6S/y6pXg2hnbitYsDWudHungRYyWq6BkbKYOMZMwig5aVSOEgmVtOJuCF14qLKSZpfthblOuPIXtnvSd33Of4crbWVTPptucYlXi+O/L5qhjDErPVbTydP8XlfCLbxpk/t+zdLxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(6916009)(5660300002)(2616005)(2906002)(38100700002)(44832011)(38350700002)(54906003)(6486002)(4326008)(6666004)(8676002)(66946007)(8936002)(36756003)(26005)(1076003)(83380400001)(508600001)(66556008)(6512007)(186003)(6506007)(86362001)(66476007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NKO0af8+z7EqT3eRvPNE95tqTa01PKzp3EfiRzbs6AE+BA0a6tHicbPdpT3A?=
 =?us-ascii?Q?KO9EYvBEWx65/uwauuVPKE77TsuDYiMGLMcHoAP/9WI80a8L/xi7x4TlLbA6?=
 =?us-ascii?Q?corrhsEmikHRh9jFG7Hkejr2AsyKOGCl9mCBHJlftJQUEv9brxdrFyiUd5SA?=
 =?us-ascii?Q?cDbrZcKvzRjX9mu/uiQtlxDbZbieka25f6T1OzkP8ksdywm4PzxrrOdcDIWu?=
 =?us-ascii?Q?hMxly+t1x07diG1eaAM+gcKp3spbq5Ptz449h4sHy246OS/FnJce1KjncuzH?=
 =?us-ascii?Q?N5yipZX16KTuiiRMnJKYqmO5FVojvk43g9KQaCJgn5niErDctu3rb5CN9yBh?=
 =?us-ascii?Q?gQuR+Eh7eYpvidujUxltf2vVlCDkBPxqHNH9oIVG4xQxi3Ae+wT+DmNsO1Ju?=
 =?us-ascii?Q?MtKmENU9S9r36vDciMJNqFVT5Exvx0JmLeWzvt6Xcg6uGefmkmEuADYJPmrI?=
 =?us-ascii?Q?EbGitdWa9eTBwxyCQE/jeNPePdcDnSq0EBmD/SI/SKwEFAupMqVGzFUgA7/B?=
 =?us-ascii?Q?2Wj5exnN33eIrQKzEFJjV4ne6R4yIai1TvrEYbj882n7jNElfyO1uhsERj0W?=
 =?us-ascii?Q?XgiNSR4QXOYm6F7yIcDah8pLGq3Tnkp0XbTFHJxBUN1eKHd/4qk76cT7XRIt?=
 =?us-ascii?Q?Mw1OsuDeet5VT6jo2szWUVI3W3GGTSsugzRAZ5WJxeuY3zrxjwf5FRi4AKLJ?=
 =?us-ascii?Q?B/6o2++uIduPeJDykRIzNPJ58FRDudPY6/elc24AxWEK70YRHLuPmmlnUzMG?=
 =?us-ascii?Q?mnfx615ghmyVgC5Aa4L9krrIrjKEnYxTueYyRvyCx4IvLkza84vL6NOkouBR?=
 =?us-ascii?Q?nKcZhEp2XeIv579Jz5jRfxQ5F0iyEzACHtMC+rvxo5UAZhrmcxvthTzqYR3t?=
 =?us-ascii?Q?CNFmEi2l8DQdavKJDXQA8eWB452l8bELeb7xk1+yb9kDZqi5XTGqFhdOCqGb?=
 =?us-ascii?Q?BfQKrITSjrToV0uj9aS9Y68pbRfwhqvQiF8rLw6mU9MpytI+VKuGcXzr1n/2?=
 =?us-ascii?Q?QL64BUMpYCxexfM/qZpvVsBW063ouAlrzXqVsIjyglHZmzMkxXX/tFHUSLG/?=
 =?us-ascii?Q?DbCSwXGtZCNhIN3S++S03Jgy08SjlcjDUQ0T71mvs+aqReBkg6qbHszws8zb?=
 =?us-ascii?Q?Cd1B/Ga1TvcJcYLVhZCQaf5abG2GgU5h+yZ7qTz6c8oYKTE10QLJTzm0xtk1?=
 =?us-ascii?Q?2V5u1W0OHbVpVrniA3ysEAqjx8i47HIn1abPSFi7L15R8Izz2vCuBcbVPgde?=
 =?us-ascii?Q?veutJNygUk6F87A6i+LqvEbFM9iP2sLD1hINI8gnMCkXWtBzq1yNuVeXuqnx?=
 =?us-ascii?Q?R3DLZBoq1CbPidGWftR7TL+0ieqUTCKoolxFvufvoxgRAA4dmjLu3sNXI9YU?=
 =?us-ascii?Q?s4VwwnHGzgwWmPIr49DRKFGK97oByZp5n+3ilQwej8yG0fU+sKr58tO7hRHs?=
 =?us-ascii?Q?OpcdnHVQ0NMZRKf87V7L/xcVqfvzzitcP9eOYKGk0jwLVlW6bTLLd4jz4L2p?=
 =?us-ascii?Q?+rGLNGTDSQkzA4Uyi4Vu9FndFueTPaOv8yJJmGQAZ6cxM1T2vOeoanfyAvYW?=
 =?us-ascii?Q?qPtLaQeEanRFZ8KWRDreCFSg7LrroSFGh/9ZaOzmFwVfEWcx3+sQRAYpu/7u?=
 =?us-ascii?Q?t+gXnTfcdE1LF5/NRsOi6QU=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73f12bb8-fca9-482e-f0dc-08d9ec9b8fc7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 13:45:13.8309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /DaO5BLIaZwMUaBvrD9Ml9wnE4OFcCUb3jIY843VzCbM1X2ZNtB9ilqJsCR0vrLhmMEXCpHgR1y+3mAVCaULAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4301
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 2f1e8ea726e9 ("net: dsa: link interfaces with the DSA
master to get rid of lockdep warnings"), suggested by Cong Wang, the
DSA interfaces and their master have different dev->nested_level, which
makes netif_addr_lock() stop complaining about potentially recursive
locking on the same lock class.

So we no longer need DSA slave interfaces to have their own lockdep
class.

Cc: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 62966fa6022f..2f6caf5d037e 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1877,15 +1877,6 @@ void dsa_slave_setup_tagger(struct net_device *slave)
 		slave->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 }
 
-static struct lock_class_key dsa_slave_netdev_xmit_lock_key;
-static void dsa_slave_set_lockdep_class_one(struct net_device *dev,
-					    struct netdev_queue *txq,
-					    void *_unused)
-{
-	lockdep_set_class(&txq->_xmit_lock,
-			  &dsa_slave_netdev_xmit_lock_key);
-}
-
 int dsa_slave_suspend(struct net_device *slave_dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(slave_dev);
@@ -1948,9 +1939,6 @@ int dsa_slave_create(struct dsa_port *port)
 		slave_dev->max_mtu = ds->ops->port_max_mtu(ds, port->index);
 	SET_NETDEV_DEVTYPE(slave_dev, &dsa_type);
 
-	netdev_for_each_tx_queue(slave_dev, dsa_slave_set_lockdep_class_one,
-				 NULL);
-
 	SET_NETDEV_DEV(slave_dev, port->ds->dev);
 	slave_dev->dev.of_node = port->dn;
 	slave_dev->vlan_features = master->vlan_features;
-- 
2.25.1

