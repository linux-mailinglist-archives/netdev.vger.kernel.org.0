Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456614CAE65
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244961AbiCBTP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:15:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244959AbiCBTPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:15:52 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70073.outbound.protection.outlook.com [40.107.7.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7817485F
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:15:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HZHP88ISwSHaYCPZMsnVTZOOEKHCS/wRiGfHJ0m94BeZtBzUayI7Mhu+ilREcKQ9qfaVh9NZ76QjMIvb155pmcwlOrNgOsxiY5EyMPRTkpuCQCleabO8uoGyL9AWZmMXj+zmk0pJo8U5UUXxoRQaUTaz5m5nkp8G0KteDr4JvPpTrevGkcBZ3LGCTmCQjovjbm7gL3fqOsPpuEURuVg3QG1IM/qjouKqhK76BKv2EqqRNBoRR8NF0CVQFQh+NKJzUfWZIr4fRTNEoMyuP6VyV4f+rC97vNjgTA1+ypF4w0BKVFOeGY5K0arMlZLSCntlH/uoKshKcLyLT8UCtXJT2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BqVG/1jDSLoRzlCvWZFPZlcaigJM3Pczk1LdlM+sw0s=;
 b=odajHY5QNBIgfEzNGp57mbV7FqTqn+KAnIAhfYRpPltSZmuoLuB0QzTspWUVjbYAE/r0eN+Hpy6BUtHEP5NzgtqjZJynggRPi5NR/TC0ieXIY9qjgXuHxVwSnqHz1DWamHQgPE0/OEmiZ99JbPCGtBb7hjXwWz0A/1xUmMmtdLHmBspcXPWXMqeSvFKHyRRmHlo3Ny0bzRT4EiRO5X0RqDvteSINhGIABppckoxnC7DDB7PXDbx2Sf32JZFdm7/9TSv4EpMt6x4izXgOKf3BBKgVeQf0hez/LGjnbk4A1s4g7PBdgn5ecGGDDhOZq7goGrzY4QDy5mbuz5BjVHUq1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BqVG/1jDSLoRzlCvWZFPZlcaigJM3Pczk1LdlM+sw0s=;
 b=iZtvZ+lEZFtQ/UbJnFsoa7BRCCJ4v6JP/nSgCFTQCuFGUUN4ACJHMKFnn+pI1pS+WrFzwuSR1r6P1uLfn4KiWGgCIA8AuC4ehVQIS9S6dDk51y/Kz5uTGMkgiBpZbpQWuyyaHfpWeuBfkrI/9ckX1f5Ve7Nt0Nwaia/2+4jkONg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2911.eurprd04.prod.outlook.com (2603:10a6:800:b8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Wed, 2 Mar
 2022 19:14:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 19:14:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 04/10] net: dsa: install the primary unicast MAC address as standalone port host FDB
Date:   Wed,  2 Mar 2022 21:14:11 +0200
Message-Id: <20220302191417.1288145-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
References: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR05CA0030.eurprd05.prod.outlook.com
 (2603:10a6:20b:2e::43) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 150c7f8f-2b08-4930-6fe2-08d9fc80efd5
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2911:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB29110A92A9D4C1B0077F9C9DE0039@VI1PR0402MB2911.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xJg4HrEKmtxeaR6rsHODP+8Tjjin/X5GnibSejzTk3wc6dmkWagh6VK5hdZ7fBdhM/gKJyxF+2Z9ntTINM9vwALsvMICP6ebxLbOcF73NSxL5xlZ46wJxSqoDPsJN9UhGrpbocbfO8/HM3GZ5CpFerpNE1Lablx+cFGrsFxDkiig1MUEMWZW1uMDJLU+3FMkuu5upwDf9yAU6MFejunOChAsSkHAsJR561xubDbHrjpvvas2OSW0rUQHO/wD51x+Ra7quioSPMtwGha3WJRvwaxLR5j3xOSoIIb02Ib18u8ePX37Rvjuc4H07ddm6GgQvxXvM1Sf05x4pvAcl2OVpHK5PJBBtg7K7xGs1B5tBdhSHK5Li2hzcuFPJOOtC1uaXotaWzoIecyePy6pxaphTVPSGvvunXecxUgi6S8wuaLdH9C3WYVhkm+9QAR/a9lrd8YHatD+kADxtDCf9ahr6sXMam45hhqBxJJ1176VrOEmY9QSfDh/zsY6t/o4g3k9DBqxrZCRSujgZQR8B20e3K42DVjCgAf4bxK/YnFaknXgW7u6cjMEeDf4vgFSMX1/Q7Z8n6XQJvXqyxtAkawkSLOVQELzLv6poTQrScNd8IZyryvjfuVka8BNITOwnPny3d0S4KJzi7LAm5rqSeNbpZlv4r84VRrNve17WTbH2bL17verFN2Dk5vAiN879tkEzK9aX5fOFLZvlldAQZ/JkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(316002)(6916009)(83380400001)(5660300002)(8676002)(4326008)(7416002)(66556008)(66476007)(44832011)(36756003)(54906003)(66946007)(52116002)(8936002)(38100700002)(6506007)(6512007)(6666004)(38350700002)(1076003)(2616005)(26005)(186003)(508600001)(6486002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9kTQltctCyiuY/sgVR9N850XZas3JCpGqfWfF24jyG0AGp0anDOUhSOqksTB?=
 =?us-ascii?Q?xEGeoiEP1MfeUhXfzZNjJubz3w2aT65QrRb9MnQWwNzj4Rvq9SCjwPDt+RhT?=
 =?us-ascii?Q?2oSgcD/dZSNsi7TrULPZr83RWorUiv/uwqH3QFu6Hysb+YSR8KNjWhzq908e?=
 =?us-ascii?Q?oM+VNe5UL8d8MKUMEHAn0xbdU+DhIh0MHNKTO4IwSueGIYGFWRVFvuVgQD7Z?=
 =?us-ascii?Q?jDjU99iMtJ62YHKpL+WPNKWVS9xvC/9cggrKyfG4BRhxeNwDsmx0k3T3QJs3?=
 =?us-ascii?Q?ho3kAp1tLpvYRWKQTeCPutaO6BWBYC2pPbI2mEqE3ogSRiRyWKlIQh7fdui0?=
 =?us-ascii?Q?ilQ8lkfuru2t09aZ07HmbaIL1iWgvrMvxOGt4Btr04RTZCvivJ8aHlgyOXJ1?=
 =?us-ascii?Q?Z1ZHITB5+LuoG7/XNeu8MMYcbsLibja7bakGxjRrSIpZ2vVjlb8edEJWzm/4?=
 =?us-ascii?Q?GCRwBDW85QiBEMvoijHTn/9DAlUWAllQ8stoyKchwL46k7XoaO9rk06FPVPY?=
 =?us-ascii?Q?VMRLOtlpGOF0eNV0WtxBfF4Gokmwm9eOapugVFqY8Ig7U0Q9GHKWr3LLkySr?=
 =?us-ascii?Q?xYATdybWnEVQJUFyAuP9N0lP28BOqNLPLaZjRdyrw2TsSQvVWCQvKXeQXZ3v?=
 =?us-ascii?Q?WahCIu19zzgeEP/ErVRGDhAfR2lGcp9skA39GlrjDVCE7BjPPrxPyAFaERAL?=
 =?us-ascii?Q?8riq3NzBLs7LZmPMA/GNSOzh5SeOSXCVtqJ7nJKjJkgo2tAQoM4viE7IXlgt?=
 =?us-ascii?Q?p6660qzQdXKoEMEGoMX97edW/DXsl/FNHkD/Ts9Bvu1SaPvSHJShJ18XpndO?=
 =?us-ascii?Q?wGTCzP1UgVQR4myCgJU70UwvspGNQhWDvuPx3x7DOp+3VyDxRlZwM2nldJVQ?=
 =?us-ascii?Q?dqJqVaCIwdeuHAs+t3G75L5w3GiCoRIxQbe4rRJUu1R6Y8sDeF5KSW52LHgZ?=
 =?us-ascii?Q?6yWURnvGyMeR3lKwP/Zs7ub3bFcS1LtniJ/K4hSpTqnURWFHnCb9drt0/qCA?=
 =?us-ascii?Q?K5LdggQUT01K+FKHOvh+D8IE9xgY6TVUnINHb0VRTa82hVMX5DWtWBRREg8u?=
 =?us-ascii?Q?fNgafujIKiCh5geKXpluEc1HVMSZwaOd8tyYZjxX4vgVdddwQ0kQlPTtf/y0?=
 =?us-ascii?Q?caifz3Bq53a1FM3GYoqBKBnnWOzYrVrCRNw2wq96sHv2RgWwWn5Hogv84HiR?=
 =?us-ascii?Q?vh+gFnC+577niMZMbbXd4Le1Jz0sWaFZkLZu43uN6XdwDFveBtsWjMnCw6V8?=
 =?us-ascii?Q?ZkscTA+0pO2kUOkzHvl20nCu0bmsABwDAh8rcpru2R/f43NdYsTXbyBugo3E?=
 =?us-ascii?Q?+7tAfoDPPYWc5J38KhXE/ZHVrIhAM4JJnD0mui35ewiGMkmDsMoXhHqsfaS7?=
 =?us-ascii?Q?cTnr1R25nf/bx0q7YbMjzaRLI8tqyP7OqpiHwPUdMJeABV8rldIUMId6rfI3?=
 =?us-ascii?Q?4vjSh0zWIePBEk0nMgdQCydSUQmQxeLc7tQH8dbeD3X95A1Jvnos/ToIGUlN?=
 =?us-ascii?Q?BC2AT2qQojDXf0Goxq4JMS+C3tx8LKCMvtQ5umWk4qs96i3C3t1HILsrSyxv?=
 =?us-ascii?Q?pYb0U4Sz0Qmjh7ndoHqz7rxBkgUonnm/5hrJSH1irVcShvllJQ9cJZqgZEFI?=
 =?us-ascii?Q?bolZH9itYAqIbjWaS98gDFg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 150c7f8f-2b08-4930-6fe2-08d9fc80efd5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 19:14:56.0797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6vD0GZzOXPQwC9DtaBzO6+eOuzUfQA27mOWSao+GWMEmm65gzUHUD91H0mm7bgAiE2BvQEBhjizzok4JoUsMlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2911
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To be able to safely turn off CPU flooding for standalone ports, we need
to ensure that the dev_addr of each DSA slave interface is installed as
a standalone host FDB entry for compatible switches.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 1402f93b1de2..6eb728efac43 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -175,6 +175,7 @@ static int dsa_slave_open(struct net_device *dev)
 {
 	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
 	int err;
 
 	err = dev_open(master, NULL);
@@ -183,10 +184,16 @@ static int dsa_slave_open(struct net_device *dev)
 		goto out;
 	}
 
+	if (dsa_switch_supports_uc_filtering(ds)) {
+		err = dsa_port_standalone_host_fdb_add(dp, dev->dev_addr, 0);
+		if (err)
+			goto out;
+	}
+
 	if (!ether_addr_equal(dev->dev_addr, master->dev_addr)) {
 		err = dev_uc_add(master, dev->dev_addr);
 		if (err < 0)
-			goto out;
+			goto del_host_addr;
 	}
 
 	err = dsa_port_enable_rt(dp, dev->phydev);
@@ -198,6 +205,9 @@ static int dsa_slave_open(struct net_device *dev)
 del_unicast:
 	if (!ether_addr_equal(dev->dev_addr, master->dev_addr))
 		dev_uc_del(master, dev->dev_addr);
+del_host_addr:
+	if (dsa_switch_supports_uc_filtering(ds))
+		dsa_port_standalone_host_fdb_del(dp, dev->dev_addr, 0);
 out:
 	return err;
 }
@@ -206,12 +216,16 @@ static int dsa_slave_close(struct net_device *dev)
 {
 	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
 
 	dsa_port_disable_rt(dp);
 
 	if (!ether_addr_equal(dev->dev_addr, master->dev_addr))
 		dev_uc_del(master, dev->dev_addr);
 
+	if (dsa_switch_supports_uc_filtering(ds))
+		dsa_port_standalone_host_fdb_del(dp, dev->dev_addr, 0);
+
 	return 0;
 }
 
@@ -244,24 +258,41 @@ static void dsa_slave_set_rx_mode(struct net_device *dev)
 static int dsa_slave_set_mac_address(struct net_device *dev, void *a)
 {
 	struct net_device *master = dsa_slave_to_master(dev);
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
 	struct sockaddr *addr = a;
 	int err;
 
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
+	if (dsa_switch_supports_uc_filtering(ds)) {
+		err = dsa_port_standalone_host_fdb_add(dp, addr->sa_data, 0);
+		if (err)
+			return err;
+	}
+
 	if (!ether_addr_equal(addr->sa_data, master->dev_addr)) {
 		err = dev_uc_add(master, addr->sa_data);
 		if (err < 0)
-			return err;
+			goto del_unicast;
 	}
 
 	if (!ether_addr_equal(dev->dev_addr, master->dev_addr))
 		dev_uc_del(master, dev->dev_addr);
 
+	if (dsa_switch_supports_uc_filtering(ds))
+		dsa_port_standalone_host_fdb_del(dp, dev->dev_addr, 0);
+
 	eth_hw_addr_set(dev, addr->sa_data);
 
 	return 0;
+
+del_unicast:
+	if (dsa_switch_supports_uc_filtering(ds))
+		dsa_port_standalone_host_fdb_del(dp, addr->sa_data, 0);
+
+	return err;
 }
 
 struct dsa_slave_dump_ctx {
-- 
2.25.1

