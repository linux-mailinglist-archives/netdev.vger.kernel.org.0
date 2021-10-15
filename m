Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B8042EA35
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 09:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbhJOHd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 03:33:59 -0400
Received: from mail-eopbgr1310117.outbound.protection.outlook.com ([40.107.131.117]:13872
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234603AbhJOHdx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 03:33:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LsHh238PycTcAPRtRrxjFK5RlBDgT4sXgGRExUbzAroNmODT/P6VJ80BJduZ2ysOJ3bPPcy/uh+1OOhZErbGZxmxftQkKw9x9ZQ1JFUYs95S3VjJNsJ6zP0bwfLfjv9kJ76UQ61BXGQKUygtXtdkUGdyNnmQVM3v8+kckVBkgIWK61utxk0d2N8G1suUIct0FbMC+IdSj55F18K4mWzYJ9Q5qUn5IWLQ/75LbSX6AIJ6Y5I3GMwqgYNTdS2ph+Np3aa7/eUvfLjmZdPEKM3TYpCD4qZkb7cpFZ6Cr/VafDMmWjnmVM3qaIE2CCzDOWQYAW//7cw0Tsx+Lzn7ThxN6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SfBOPJYbjsFhI8TxiXamOfsUyoXFN9Arcx8qkPfuIq8=;
 b=At/83Lh9fxrVxS0nUtMDNWS9ta5a3mFIfFeO5LnpxePb12e1UXo/O+zg5qQWijmJ+C9i6fHnjkRk+5aSeDKJ9lCIpjH7h1aTyjTwyXGd3RsYD1OGUFGXmWuI+v1ReSRb77t1kqTJbLdr9tetRJ/ToilknvvNnBzQQB7FzGWR5MJVkt0XbgLDBfS7CtHcVqpb/on4n1l7aEs6QCk6FacaY2bu4s3be/cpjiLUsxbwohFElQjP+Hiy1igs/ghifan5emzo55O3N7UjH4uFnCtkOJb//RRO480W9yQwT7nG8M+6LzEgoZHOOTuQR/FtMTzrMpIAGHzP1eNyYdXeAggP1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SfBOPJYbjsFhI8TxiXamOfsUyoXFN9Arcx8qkPfuIq8=;
 b=e+cNCicki0NZqwTM+kKOLNfFIJ7vJJSD21YvQ4yCw83YpbRbrcD5kDDdYN/quGG1hO50kkRQtpTST54BbpH4nDFlKzu0zjbTMTYaWtU8UjUfBbmyKGeLAU5dB7IBIrpKS8oWykq//gACpvOUhUtMgOedYLsljRaKcD+jL4nL/cc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 SG2PR06MB3578.apcprd06.prod.outlook.com (2603:1096:4:a3::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.19; Fri, 15 Oct 2021 07:31:43 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0%6]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 07:31:43 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Leon Romanovsky <leon@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] net: ethernet: ti: Add of_node_put() before return
Date:   Fri, 15 Oct 2021 03:30:57 -0400
Message-Id: <20211015073107.13046-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0141.apcprd02.prod.outlook.com
 (2603:1096:202:16::25) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
Received: from localhost.localdomain (203.90.234.87) by HK2PR02CA0141.apcprd02.prod.outlook.com (2603:1096:202:16::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Fri, 15 Oct 2021 07:31:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9820adb9-76e7-49e2-50b1-08d98fadd5b8
X-MS-TrafficTypeDiagnostic: SG2PR06MB3578:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SG2PR06MB3578EC23B4FD117CF6143492ABB99@SG2PR06MB3578.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: px7GuGGWCxT5t8AqCbh6cnvSSL21prstV4/Wd5B8+ibY3a7S82/2z8h45cnAFPqSxG64MqLNT2ImX2Tj6vwfZ8o06PdcTI00zPHNt2gMmz8iDv8+YDjJhwIJMTyiH3Sfgg16mv93UIDdutFEFmqKvF/40CdMALBHWkHswOERX6ELOOhdrXqxdN3MP2yWHFsS/jBAUyI13bcOTxPtBOjpKd2rzaa4X2GdLbZhwHVykfx6TVX4TFiPQMyxJCCgn/MdZyIaXwm+PB5hWHNS/dPsgkmLYUFJObggvDlWl2Cghx00tjYXDSSROCSKjWutSBljQmaij4pOBf4auQfUO367uK0O+hzi3OlqPY/3h9oW4SELJqAwxr7lIID8P92yWEBBVRmEOAhJjPr4KHT48N9SM29vRF9wWc29iB5xlOblsRgIrieDFWHOSdpM9mrqHGVaV207/F6lTiSitsUR67Si/L0aEbQjZxvcoVwle+Roao1lkK1kEEwTT6HJKYWhO8V8mv9BS9AWkvZUOmYJiYSpyJcfSSOKXq2ba+QQ3LrY8EZmxXaP4HCN7T7fpuIJMcBNl1o/BZnwm3MaX0MqVOpz82QXKTddINtLCoEnV95MFrZVVQEWDt/1qp2Br36LVoLQouen8BbNT6ouyMBfzI8W1bAnK0o1enjIGLp6xEN2VM9OlNG/YGTerdUMvSSwGd23oX0SAO9pRgmjVAmF//hcw3IaP+/nEsusiwhJ2XV5+qo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(4326008)(6506007)(316002)(110136005)(186003)(36756003)(921005)(86362001)(7416002)(66476007)(83380400001)(107886003)(66556008)(6486002)(38100700002)(8936002)(26005)(508600001)(66946007)(6512007)(2616005)(956004)(5660300002)(38350700002)(6666004)(8676002)(1076003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iNEXfipzYb0oh7c72ytFmM1HNJiHZ/2TGOQp29eDkmcm6dBqp3r9HrWL2h/1?=
 =?us-ascii?Q?I3eJJWeBGZFRiOIFVnJ2nCiuHPHORqoS5gkvmXwK6qfkuWoX97kA1kFd0tbu?=
 =?us-ascii?Q?MmAvsRIWXuoplp54hxGPd0FUwXLcNKUWhWWsyHWkxmXvFZBBkFEOXAAbroEv?=
 =?us-ascii?Q?dkC208cvVo2jT30YJ7uRzQ6c7/ADirNd+A7KvNl36Ejo/UBjGoNCujxtesm6?=
 =?us-ascii?Q?3E1SWw2uuHubN9KL1ztFdGOAF/N0zfGZ6CAzgiWs9BVGI8bT6jut5VhyKiWk?=
 =?us-ascii?Q?RMDqdDqEGyDtYsJU+Qvl90tN0Mux/1ljxXkVvM0rXw7Dt/sjmOSW/FDMSblg?=
 =?us-ascii?Q?ETLEKzp0IIUlvvxd1U1RwfCwnO58cyz1mHEJjBlp6Wi49bJwf6tq26w6Ng85?=
 =?us-ascii?Q?q6QFW9PwJ9jli2VzURSi5YrL4Y0nkSHJmNG4tP6C8KlXia4eNMaCw3CNaPKd?=
 =?us-ascii?Q?OImYO4ZuGYIVhqMXawieG4dn83qvPhBIGPqdNI0Y8EUf4ouLnmVjohB/zAje?=
 =?us-ascii?Q?yvQImr7C4jwpQPb+1ugqweOsp6znVd/p0tOpu2kZ1KBwAi8t2n3ADS2jmtxK?=
 =?us-ascii?Q?fdERu6k8aNf5C0jtVM9wHEpqO01B+HnfmPNxcJcFMoCh0v8kru2O0LOnXDDa?=
 =?us-ascii?Q?uIk5KXAIEARDcXLRrqMH14NUFLINjiQeBEL+G5I7SpmvV82s1Vm/qr6H0gnn?=
 =?us-ascii?Q?zsSyTQyIj9Jb3xjz8YR4ueK2a8icUmLN4iYiZCqEBpcenQ6Qj3LCQxMenT19?=
 =?us-ascii?Q?Isdl8aM6xnlXjVR+nbxHgcOEHvyZqCIWKe87aRPcRFhu8WYiZMGpWG8I+LjP?=
 =?us-ascii?Q?PC0+1x+OMAeW8i+10C9IgoIi+jRj77ZOpqZ/+EVX3IYYix6rREpuI+62wQ7m?=
 =?us-ascii?Q?ug3zuNtKJDhLNNmhAtr7nbdikO16STthYkT33zb/aMk5yQ4YDp8OwTf4svmG?=
 =?us-ascii?Q?CLo82CQhE8PYc/yW28MfdFYaCz1AJwFTfGT6I+UboV5RKDoZtqM67Wo5ZGbV?=
 =?us-ascii?Q?6yaWXl7yHzgBV/3ZCJer7L+n2PsJeijv7pognuJyOjixvid3wdwnYewvl0If?=
 =?us-ascii?Q?36SB/JkIqSl/jNsbu4FGR5nSKq1TZlyd/bRfTzHnoYvLMJwym+BO3JqYYrrq?=
 =?us-ascii?Q?3mkP0rgX38ke7y/mRght+Cweyhodz4CapiZrKdGo5c/Rvg5l8eosqM4IXB4d?=
 =?us-ascii?Q?fR44kxjcpKOZWhLxKfQnjg/7pSzsJV5IJKoiGSIbQxnXh3J06LBe8H+bgq3r?=
 =?us-ascii?Q?1Q9yunkno+TjUZl83dDzFUkgNcVT1AQTNL8/vMQLas8qaMtFR52iz5MDq26v?=
 =?us-ascii?Q?d3Shrz4kkhRbcE0pgleW7NoZ?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9820adb9-76e7-49e2-50b1-08d98fadd5b8
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 07:31:43.1144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ei7h+ltTnN27gpKcnyEJAU+m1h7pOb7YqbMxp0wCKzCSCt/9gpnTvzNWoNQirh7tnXxyHs/W62dIj78A5Gvimw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB3578
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following coccicheck warning:
./drivers/net/ethernet/ti/am65-cpsw-nuss.c:1835:1-23: WARNING: Function
for_each_child_of_node should have of_node_put() before return

Early exits from for_each_child_of_node should decrement the
node reference counter.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 6904bfaa5777..00ef27cdde84 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1844,12 +1844,14 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		if (ret < 0) {
 			dev_err(dev, "%pOF error reading port_id %d\n",
 				port_np, ret);
+			of_node_put(port_np);
 			return ret;
 		}
 
 		if (!port_id || port_id > common->port_num) {
 			dev_err(dev, "%pOF has invalid port_id %u %s\n",
 				port_np, port_id, port_np->name);
+			of_node_put(port_np);
 			return -EINVAL;
 		}
 
@@ -1866,8 +1868,10 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 				(AM65_CPSW_NU_FRAM_PORT_OFFSET * (port_id - 1));
 
 		port->slave.mac_sl = cpsw_sl_get("am65", dev, port->port_base);
-		if (IS_ERR(port->slave.mac_sl))
+		if (IS_ERR(port->slave.mac_sl)) {
+			of_node_put(port_np);
 			return PTR_ERR(port->slave.mac_sl);
+		}
 
 		port->disabled = !of_device_is_available(port_np);
 		if (port->disabled) {
@@ -1880,6 +1884,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 			ret = PTR_ERR(port->slave.ifphy);
 			dev_err(dev, "%pOF error retrieving port phy: %d\n",
 				port_np, ret);
+			of_node_put(port_np);
 			return ret;
 		}
 
@@ -1889,10 +1894,12 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		/* get phy/link info */
 		if (of_phy_is_fixed_link(port_np)) {
 			ret = of_phy_register_fixed_link(port_np);
-			if (ret)
+			if (ret) {
+				of_node_put(port_np);
 				return dev_err_probe(dev, ret,
 						     "failed to register fixed-link phy %pOF\n",
 						     port_np);
+			}
 			port->slave.phy_node = of_node_get(port_np);
 		} else {
 			port->slave.phy_node =
@@ -1902,6 +1909,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		if (!port->slave.phy_node) {
 			dev_err(dev,
 				"slave[%d] no phy found\n", port_id);
+			of_node_put(port_np);
 			return -ENODEV;
 		}
 
@@ -1909,6 +1917,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		if (ret) {
 			dev_err(dev, "%pOF read phy-mode err %d\n",
 				port_np, ret);
+			of_node_put(port_np);
 			return ret;
 		}
 
-- 
2.20.1

