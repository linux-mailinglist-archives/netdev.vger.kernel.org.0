Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D00598806
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343833AbiHRPur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344124AbiHRPtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:49:41 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50081.outbound.protection.outlook.com [40.107.5.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A313AB39
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:49:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AInX3GEULtYUGvsRkRIUlFDQWvoEXu3daU4xD35752cfWRBRP/b4jLnIBZfgwSZggm/xDzFhM9264rEt+L4G9n2ViucpyQp2snJoLya506QORPcMScsMZ+WJ6iGNnSS0XTrxvFDLWSNlavraLe8ftyKNeHX8UfrhEyln+cXSXAntHn5GLM7Xi8/Ys2r9vE72/iyKELnF+1S4LZWPLgQoiPlzm2cSy1SEyT7kq+nB2Ayyc7PD73DWfR11aDJLaNHQ73HJVBOP0xY027hIgL7WTehYHH1WkXS9y8WaiSVYV5jDYSPAl+Blk+kEiZRkW9qIs+4KZqI+WYVmY1TlT3515w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZKfN2NE5ERQMA+UbunLU3Qyv/dOsd+Lg2xLB3t6I4UA=;
 b=UbpitZPyzT5ArXKW3ejsrpMUK4iZH2R1ctDQ1KCZSqtWAMK9dstWlUbRkie9lujpYYe9QQbB6fSywq3YHHO8adhVeoNXXgDXiklVgbVQBNzwz70kp1GLwxcCGmOV/9lkwkhPcqlcwIMp8wLCD0mfQGmG+A543UEkPrafICmA30/yKxMTkmhPZGPN7JltHZfC+7/boS4p0iemeu31fjyik3x+zxSgGYKgPs/TYWA1oJzBONjOpKOxEvo27I8fLzbJ5uWj1NVxXyBQKgKAB/FWkU3ePkE3EwBJrWQR10ocWwfImwb/0qUMefoMyV6qajIGnquWvb39waW6xA5tpaMOjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKfN2NE5ERQMA+UbunLU3Qyv/dOsd+Lg2xLB3t6I4UA=;
 b=LpKYaCa0xBKSRPOPreM6HIvDcsnPsnffJdwJQmNwYM6LMXH5Hy23q44BLTrpMtfP3JVLAEWCig81Jk2Hff4DfxnJ6s11VTL0txyopsZ/H/W9E/YagWU24tuESzNdgTJSUl+NXd+t8R20v+GcMn+zKryvLALyW1inoZ212FOGyXY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6349.eurprd04.prod.outlook.com (2603:10a6:803:126::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Thu, 18 Aug
 2022 15:49:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 15:49:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RFC PATCH net-next 08/10] net: dsa: introduce a robust form of MTU cross-chip notifiers
Date:   Thu, 18 Aug 2022 18:49:09 +0300
Message-Id: <20220818154911.2973417-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818154911.2973417-1-vladimir.oltean@nxp.com>
References: <20220818154911.2973417-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0074.eurprd05.prod.outlook.com
 (2603:10a6:208:136::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41a8d8df-5fd4-4f95-d635-08da8131415d
X-MS-TrafficTypeDiagnostic: VE1PR04MB6349:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fppFDWra3x8W85dgEp3wUR8u2EKCNEAhpLqrkcPDpgMIa4dxIEYYhFgZCY/3Kl4T59la59+qXJejxEiHlB2kM6HlAsbbHus2V2QpFPvrUrT/lxftW2pBaBhEYTJgWYYIMgLPXoU+N8M93K3qX02oKGquukg+64lizVzz57TlzoetMqjfsen1rDbldBV3InxsEGvWM5vyhMHnR85zPnI611G4qHB1FLgopSYSVpwabNlslo/GYsvIS45qe+EHAbDiljEGeoiA8Ux2PLPanMmv6WqV6RTC6EZuL92ONUo4y9mFctCZOoiOlmtpWZ2saITQ8Agt7HOr21OQl0Vb6eGal/0kKA+CxgexfsKx0hRq/feZrfjQlO9u+JZc+uv9vrdpEXFGa9xVvw3Vx/kb/Xq0hsK2YfE1CpH77TvZfFSoKWsTjWGTLUoONTPD6lTB5cEgF6cA0pXtsekgemHXlqoWcX0RSwN2cAHf63CSEm/NYuMQTSIzhDJEplTzjxfSP0MuuIl3mWJeWCqOCcqZ/cVsVS2AhhATXl6Y24oLX7aXhj+K4oxxEjnbG78IRST4MsB6Fkf48VX2ABrK8efGclUNEB1IB4vbeoADlfK6bjspO1i7y5xz6j7bMEJlkFaGy/HTL1dwlpsJJ6uKJ8QOANpy8SdziOcjkXhYnkG01Kzu4cPD/NFgtDR7Gd16JHp6CKEmzTnz/g8XhP5k5nQqA+YauvCVvBYsYJij2VNTbI9MkY1goS7w3l6a6abz6ni7snVP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(346002)(136003)(376002)(396003)(52116002)(6486002)(478600001)(41300700001)(6666004)(26005)(6512007)(2906002)(66476007)(66556008)(6506007)(36756003)(86362001)(6916009)(316002)(54906003)(8676002)(66946007)(1076003)(2616005)(186003)(5660300002)(44832011)(7416002)(8936002)(4326008)(38350700002)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fG9lzwhThX0Avl2aZzV8RE7i+BzAMgdFoUBuPdHinYyWeu6pBF4EGLQjABIE?=
 =?us-ascii?Q?N+qb/AmrtNI2IAR0yxoeoKVlyexxF65SXSiBI1w3oZgJUQjFJ36utoWg5BSk?=
 =?us-ascii?Q?FdZqy8vgh/Iu2vKfeJXHLi2a8HY7NBcrcAg44CYzDPwOk6UEBDEzClWz6Vy1?=
 =?us-ascii?Q?3BLhDpF5djfZ4xbP0Pz6vj5mWD6Aaf78jGkKE4GOMoLW9bRZug1Xs0HRREP3?=
 =?us-ascii?Q?+l6XYnD0V7g2jhZsHhs+oSSts7Xg5GHpViRH7szkMCoyctBbZAeWba4io+Zj?=
 =?us-ascii?Q?v9mUAYuDFnFhkF9yHn9u3tpIyfArYe9pvsvPgDY2JByBtoONvKtzpHdTyohE?=
 =?us-ascii?Q?0c21t1XT/rptZxWHQRy2B2cjIq04j7WSpgqzPWK/5WMqE/hcujU9F5YublV0?=
 =?us-ascii?Q?To87f3pKftVdVqou0tSW59BrQS+PCZjYz0A23zP+5I2oktGYSx7OxyJlX0xa?=
 =?us-ascii?Q?1pEa+0aCUEwf5aFffYkjKQu3vv6xqlxWpTbV72YwSQ3wPUjUsSzbGj8ma+Hn?=
 =?us-ascii?Q?18InBOkXHUAGNvf12ICKNyrV880NZQqKQtiymYSSy6Jad0bQRW/YNnZfsLsb?=
 =?us-ascii?Q?hhLm9jBgFCazo1Yd6FLUxoy3WIW7WVY2HV3qGnu3QQQrypppZJoMlZ72OKCd?=
 =?us-ascii?Q?XIzlp4X78gq5U4JqNH8ZOkivjCfNysfQ6zrRruvB9BQN6jVZVsJrrNqBa4vC?=
 =?us-ascii?Q?Cs3BscusRla3m/95SEHe/myAYv0V5348T+W0FP8AWbKkjVbaGN8YaktEwlK8?=
 =?us-ascii?Q?Lm8uyNcpqSGVSeZES2x6OuJ3FGLSiBBr4caXRnAfAYsXm/tXUE/7VKQYO5cY?=
 =?us-ascii?Q?Ex/ww4UeqKGafydh8I8q3aUjwhHpAsUWi1FDPSsEH9fy5nD63WpzWYGQ7IWZ?=
 =?us-ascii?Q?DE5bo1kI/sBIdvKObbIvSPK+1NSJ18TC8nsjzsI2Bp/XmPrU2p/tz4dELwl+?=
 =?us-ascii?Q?fnSBVYo8hu6Ga7iNTGz6u3Oz9WwQXh7ITY3BYcJW4x+fxN7uGUz1eXxMYGGt?=
 =?us-ascii?Q?7QYZnlAdSBmKLdcN2+7nedeV7K8wDCR2AXTjc3uDHZ28+SsZn4keowSyPt/X?=
 =?us-ascii?Q?QAtQZjKJNTBJw6+gNZ6OPH6ck9UKnFHliecczpTIbBk3cLwJdZPRqQ7hUc/n?=
 =?us-ascii?Q?vNmZSkluH8WnqzTFlZLUSAkGlvl0BqLNfGvCO0cCjgxGHqZp2dvp6HjkcPfb?=
 =?us-ascii?Q?zL4BLQ0/wZqTGKJHe7+KCPnmyWPQnyI4Ibq/ATMFEOtxXg1OV7iK5ocI536F?=
 =?us-ascii?Q?6EiqSNIi26dfnPpD7A+vMKFsTdWQg76kNMjVwqsfirmXS0x01d2uG8HdkjJw?=
 =?us-ascii?Q?tgDzliHKo0EIA5/OGRw0RWPmfW1JQwbN9CwEOCR2TjFaMcTB9xHH2/XBYtR3?=
 =?us-ascii?Q?1MGUSxOsSefwl1pqRVQ7n7ATvf2UHknIvH/FL9ujvmr++36nJiHk2HOK6RFb?=
 =?us-ascii?Q?E/IO+H5bPGYKKt2JZFu4L75r3g4ALmsmzAJO1GF60VX5+n01D8AxBwG/1gj5?=
 =?us-ascii?Q?oSWtfz/D3eqIdHV05Fpg59LX4jslJpLGFlQz51SVwiBom4TaV+lelluvXHfT?=
 =?us-ascii?Q?e9Sy5uVHMDyZsPhU/NEGnZufWwdJjSffNngh+A3iw4eZrre+vuu0Ik7fR95v?=
 =?us-ascii?Q?iQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41a8d8df-5fd4-4f95-d635-08da8131415d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 15:49:37.7958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8yvicxWvJn1K4suiLGcj0J2TvsI8O4CMA8rL0VDFi6F0p6PmV7L3SSGPiQz7QCc59ZLIlc7FJOe8+dmisi4OTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6349
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add rollback to the MTU cross-chip change procedure, which allows us to
leave the tree in a consistent state at all times.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h |  3 ++-
 net/dsa/port.c     | 19 +++++++++++++++++--
 net/dsa/slave.c    |  7 ++++---
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index b4545b9ebb64..6c935f151864 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -230,7 +230,8 @@ int dsa_port_mst_enable(struct dsa_port *dp, bool on,
 			struct netlink_ext_ack *extack);
 int dsa_port_vlan_msti(struct dsa_port *dp,
 		       const struct switchdev_vlan_msti *msti);
-int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu);
+void dsa_port_mtu_change(struct dsa_port *dp, int new_mtu);
+int dsa_port_mtu_change_robust(struct dsa_port *dp, int new_mtu, int old_mtu);
 int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		     u16 vid);
 int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 2fec3df65643..4095592c4790 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -962,14 +962,29 @@ int dsa_port_vlan_msti(struct dsa_port *dp,
 	return ds->ops->vlan_msti_set(ds, *dp->bridge, msti);
 }
 
-int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu)
+void dsa_port_mtu_change(struct dsa_port *dp, int new_mtu)
 {
 	struct dsa_notifier_mtu_info info = {
 		.dp = dp,
 		.mtu = new_mtu,
 	};
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_MTU, &info);
+	dsa_port_notify(dp, DSA_NOTIFIER_MTU, &info);
+}
+
+int dsa_port_mtu_change_robust(struct dsa_port *dp, int new_mtu, int old_mtu)
+{
+	struct dsa_notifier_mtu_info old_info = {
+		.dp = dp,
+		.mtu = old_mtu,
+	};
+	struct dsa_notifier_mtu_info info = {
+		.dp = dp,
+		.mtu = new_mtu,
+	};
+
+	return dsa_port_notify_robust(dp, DSA_NOTIFIER_MTU, &info,
+				      DSA_NOTIFIER_MTU, &old_info);
 }
 
 int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ad6a6663feeb..02cc1774888a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1810,6 +1810,7 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 	int largest_mtu = 0;
 	int new_master_mtu;
 	int old_master_mtu;
+	int old_cpu_mtu;
 	int mtu_limit;
 	int cpu_mtu;
 	int err;
@@ -1849,6 +1850,7 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 	 * MTU, since that surely isn't either.
 	 */
 	cpu_mtu = largest_mtu;
+	old_cpu_mtu = old_master_mtu - dsa_tag_protocol_overhead(cpu_dp->tag_ops);
 
 	/* Start applying stuff */
 	if (new_master_mtu != old_master_mtu) {
@@ -1859,7 +1861,7 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 		/* We only need to propagate the MTU of the CPU port to
 		 * upstream switches, so emit a notifier which updates them.
 		 */
-		err = dsa_port_mtu_change(cpu_dp, cpu_mtu);
+		err = dsa_port_mtu_change_robust(cpu_dp, cpu_mtu, old_cpu_mtu);
 		if (err)
 			goto out_cpu_failed;
 	}
@@ -1876,8 +1878,7 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 
 out_port_failed:
 	if (new_master_mtu != old_master_mtu)
-		dsa_port_mtu_change(cpu_dp, old_master_mtu -
-				    dsa_tag_protocol_overhead(cpu_dp->tag_ops));
+		dsa_port_mtu_change(cpu_dp, old_cpu_mtu);
 out_cpu_failed:
 	if (new_master_mtu != old_master_mtu)
 		dev_set_mtu(master, old_master_mtu);
-- 
2.34.1

