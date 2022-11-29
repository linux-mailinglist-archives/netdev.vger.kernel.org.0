Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16DAF63C210
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbiK2ONj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbiK2ONU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:13:20 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2045.outbound.protection.outlook.com [40.107.14.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7B4B7D4;
        Tue, 29 Nov 2022 06:12:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EYdB41zQR2myBGpsh7Va00EzzEfNBtx2T7vX4Ncsc/bPrmTBs9ILMHBoetTzjC2jFWJo7a131aumR6jC8vw/3y3QSxbDmYiRDHixRyxbTXzmhfjtwQn4wmqtGwvtg/TQIzBrJHhR8teb/aaua83ebquZrrIyM+rfOviubZKNKUXqPf0ZMfG4hXiLH7b7warGMh6JE2YZJs9iGzrOp86rXchXs4LTb59jm7VkbSkLNBxsENnKQ5ZujcQp3oUmMLhSrqYBTGQaKyl4rJ9a3IW37AslzeN35D5yv0twNBArOKkI/osxTPAqlLtfiLlomw84IwAgFEEu93VLPkg3a3UHZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JWyHTdZFx50lrOJ8mm45qoA7mpswzw+G3u2nOR+johU=;
 b=TtClcarQlLWrHi4oSPOSqKBI4VjOasBtu5VkhThz0oI5Y09Ir+BEpA8IAnJViaRtkI9MC8bLfj9Ytab9wcZ7ezc5BGHKmyBOtoo1Dk5SI1oqClSU45t4D2GGvzpMhlCdYKVrNASMbbYJ66Ce1c4W3K7n1xRV4kib+SJtcFtG3aZRkL7s9O/Et138iLO9GFQijRqrBNpxBbt3sYya7GIZDX+ksyL6eJmF7IMm/N634jYraCBFZPtIEip4OFAvPzMnDEVG62rSSJILRNnLI+yQP3b9ibnZ2J/P2Aq8zCNRI1vYdmoJD4P7SOl84PWdqOKlugatWrMkUjMAKTLjyd+Q6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JWyHTdZFx50lrOJ8mm45qoA7mpswzw+G3u2nOR+johU=;
 b=sn8J2Aw6LuWflWXnM2aZA1HIGwHI/bjqui7VhRZhL8NVD0TF6GzYsvj/Kll4St5XPK/x8rArO2FIU7KRY9DO/ZPNAOwMlYsVMlEo1wDTxAJhA00nHMrQTvP+pJ3oxpnTdqyINYJtN+c4chieBYV9SHD296mw6pVxw2H78/vLEEw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8724.eurprd04.prod.outlook.com (2603:10a6:20b:42b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Tue, 29 Nov
 2022 14:12:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 14:12:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 01/12] net: dpaa2-eth: don't use -ENOTSUPP error code
Date:   Tue, 29 Nov 2022 16:12:10 +0200
Message-Id: <20221129141221.872653-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129141221.872653-1-vladimir.oltean@nxp.com>
References: <20221129141221.872653-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0029.eurprd07.prod.outlook.com
 (2603:10a6:800:90::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f8a25b9-98bf-4543-d380-08dad213c2fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z95SJpfO7cZMmYF0sgvEcpoOKIqW+LY+5scqQKriovrCwmVEkj6GgyMaqJj3GrZ5/pm8S6GAwIAKHgE7QaHBmglsTZee0YkJJ8CwmyoOHf7oaMWa81Dp82FlovICjqWCDrC4W3hn2G/c9ecwMKkxtHruARE+igsA/fkza2fHr6HJgXnYH54P4ITMsOafza4CJhuHXJbdTxKEBgoYape27we0frn9LRBO/b8w/HN9gOW0D1C2GqVQOD8jP3mHcKRPoBL8YZYwIp2yiWH5NWKuP3d74/gs416F4shSfRxTwTsmgJei4LVdAxBUUBMp0myCzfdRf5Eh7PwT8FpktBx8O+mShYcW1uyUBlMXi5Kn3+z57ZxH4ncCC4KKcvqIfk563t1iWmA7s3dCTgmWcIe0vOYUzxRRO0TeApZABrgFVwcIBJC0dmpE/g3r4hnufVcFVaZe3EHMu5OFWyseum0K8jX3CD+Go8NJFZtjZ2PLH7urVfAL3j/oul1vx9tXcSPNlKbSgcd0jlHTFlvcWau3mx1t+zLIQ2fIPNvyXbF8ssDhSuScfEZH+2KjEZYr46j9SU1U5t/GwLRg3F+ZSEhexQ2opgK3acCSqZVN+Ww6M8qgCqWbLsD1/PK2wbTtTFptOFHM5ca6d09yTRW4kDbWgTbXB/FPUxN/Zvz5EVrp8BM3ZOCaeLm6v/EwyouI7OfaJNksRWuR6cryMYmUtrKgzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199015)(6666004)(6506007)(6486002)(478600001)(66476007)(1076003)(36756003)(186003)(66556008)(2616005)(66946007)(8676002)(4326008)(6512007)(52116002)(5660300002)(26005)(316002)(54906003)(6916009)(86362001)(2906002)(83380400001)(41300700001)(44832011)(38350700002)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WLvmr+KWWIwKSh8RpvasyZ7Yllu3fWQsv/ajVMKimxMjEQQMwlEJp7CaHG4w?=
 =?us-ascii?Q?XGTzSJN2yKnlh5qN9fZJ5z1p8jl5lTw4Emobdd7SB5CByKTM2ay5Wm6BCSnv?=
 =?us-ascii?Q?KVoAu0BPzVqv31mT1pGdKZAgcDOWdLPXA2BFFLOI20pZYzLisDtBczfxhyl+?=
 =?us-ascii?Q?v2+cRoYX5tpB51aqm0kqFV2uNnVDtxTotUMcIxRFvDevspYEVTz5TnjyViqW?=
 =?us-ascii?Q?+qVJIgR8Bh5yLk0cwu9BR5sJD280s99KIG5hnb3L2FGxvyZtdeSTqqrg3nsB?=
 =?us-ascii?Q?oSr/rATo7GdHh9r6Xrlw811Op8L3EF8AXG4QNLwcRM0pXatWx51Lrgqp6/Bh?=
 =?us-ascii?Q?prZFodyfme+OMx8AwjA6nHE1UyRNKD7OOkaQ5VWg6wElh+mug2Ttg+fK4crc?=
 =?us-ascii?Q?CmSrsSJEkGbu4mFB7L9uDOO3x5jxfJIeVpTPtEWTXmM8p+ayH4ECrwpw7WUf?=
 =?us-ascii?Q?eUDvaiZRQ10gZVPPlJDQB0JuXATGCgqzf2LfAxdYUzzoHr/UlDOfwkmpP67q?=
 =?us-ascii?Q?H53+/vYRKEwztHE6L8s0a9EItka99IWaGnHwnF1feM+u5OsaH0RLnizozbPA?=
 =?us-ascii?Q?xD6mVRQaswLM1sukNsoEC+ZDKYQOag4Lj9+SrX06jAWX/p93XttZ23yg1SXs?=
 =?us-ascii?Q?e+iEqfQ0oR+XQ4jMZZnpk5NmfzwhgJ9DqqKtJiWz42HDHfYPrG0Wn2+Lni7q?=
 =?us-ascii?Q?VjW35c7JHJJadmm4eKllRZoshDGdbgdbkIv+r+D/7RjqxiTYghdUE6CB7/mH?=
 =?us-ascii?Q?d7T/rEumScxKAhZo+S+meSOr6dzTMIfKCP1t0BX2I3pJXRfAtyHDfSfzVwYu?=
 =?us-ascii?Q?5uGLg/wL+qyqSK9oC67lhqXoNwcPU8S+ewyJw/ddx6XHQ1F/mINGPrlI8WWM?=
 =?us-ascii?Q?sd6Q4wY+urS1B6K93gnOln551CrCrWA/Z7zK0bISV1jZ6AVbdejef40qSWxY?=
 =?us-ascii?Q?eziQEDov/Rf2lEYDnVej3Nkf6RXTZbp+JmwmKE0py/1o2lP9tuJM8T3MtfUL?=
 =?us-ascii?Q?FxUBCOKbzhAYmRDNg9aER8CiyLqLR45QTy16nfJ4y2Fb3YkkglkaYyEIhnQU?=
 =?us-ascii?Q?05djxvKrba6qPOIrsdjEd2LQoeSYy3CiGSp/v6PG3RnVZdoQpoOm9A/3+bRf?=
 =?us-ascii?Q?3JTYLlbWJH/eZ+swuZfJnaZo4z1dIBBao55YUzT42CNWFZQcjdG7BYlZQn/W?=
 =?us-ascii?Q?VpOC0qly3vAZMtewwSpacjRe7GH+77o2pKgaIpMf20Z9eJpPPgBuwMho6xCY?=
 =?us-ascii?Q?xgUoFQVlq3kAgKsPb8BqskvIUQkpV8W0NgiFAp6Eg/6sl+9HfJhG7EvumTFF?=
 =?us-ascii?Q?O8lISHrwbQPWmCsEmLAxfG7yrYTvGU+0S/rnUOwoWoJVdrOUe4cJK8h4q4dW?=
 =?us-ascii?Q?fagpKa7frjEL91bFXbFqnweKvofbB+MmNm5baEGROmD5eurygEehJ38gzzR+?=
 =?us-ascii?Q?8I2GJUvdvpWehpr7i9NKuSHOYriOJPhE9G1W94WtnDXtiic9+ZauNUXicKtD?=
 =?us-ascii?Q?bpe2m78Cp6wWep8leZvqlruOnMXtkxebGgHuNbGpsRU3T5LxfqKxbMr4p70n?=
 =?us-ascii?Q?CkGx+KQWTbg7/0HJs0juj6vGhLN8SsqmU3ygK0i5bmPy5I+Ve1R2iuvrGPsi?=
 =?us-ascii?Q?Mg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f8a25b9-98bf-4543-d380-08dad213c2fe
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 14:12:34.5913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dgnSa1BQKHJh6rcjqaxzF/ReMBKhtCbzxBGN3HL9z4kjXK0wRNWmaetvFrD5hT2X7244AzfCJurmFKB4D6ZD6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8724
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dpaa2_eth_setup_dpni() is called from the probe path and
dpaa2_eth_set_link_ksettings() is propagated to user space.

include/linux/errno.h says that ENOTSUPP is "Defined for the NFSv3
protocol". Conventional wisdom has it to not use it in networking
drivers. Replace it with -EOPNOTSUPP.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c     | 2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 97e1856641b4..515fcd18ed72 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -3791,7 +3791,7 @@ static int dpaa2_eth_setup_dpni(struct fsl_mc_device *ls_dev)
 		dev_err(dev, "DPNI version %u.%u not supported, need >= %u.%u\n",
 			priv->dpni_ver_major, priv->dpni_ver_minor,
 			DPNI_VER_MAJOR, DPNI_VER_MINOR);
-		err = -ENOTSUPP;
+		err = -EOPNOTSUPP;
 		goto close;
 	}
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 32a38a03db57..ac3a7f2897be 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -117,7 +117,7 @@ dpaa2_eth_set_link_ksettings(struct net_device *net_dev,
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 
 	if (!dpaa2_eth_is_type_phy(priv))
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	return phylink_ethtool_ksettings_set(priv->mac->phylink, link_settings);
 }
-- 
2.34.1

