Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2908485C24
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 00:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245321AbiAEXLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 18:11:36 -0500
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:32794
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245315AbiAEXLd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 18:11:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ykl0MhveQeyFHtCUciYnxZAKTdu2eGQmB0lMFt0ks7C+nZFe2LbaqHDt6l8YTkqmqPhPSavUuTd4+6Zj+Qp6ybZZtZadKiQozv+/q19qH9kKMncEzizKnD9KIv8VaCBL/I3ion04BWAcn5NDGoQ/N73I4hSqQZ3Vn5sTNSGNKYV4ULrLxHdldAJMeNtJeDKwQNU/a5OFRBUV3KYUCq/2pB6PpKWGc2bRfDj72hcPRoB2V0MA971LCh/+Gbn8bn+hchedLjZIzxEfoAdBb/nlJjrzN0ZTkp8FGbd+cUW6671XvZuHsvTu5FJf6l3weVx9gM60M/5tS2ckYdXeH41sDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CCv1XAfSgWVWoG50wYbuhv4Ds/TH+NhgS4MWIH/kdig=;
 b=KS3hF+xtqfp15TIp2KAd3oNiiHNZscJQw/4CqLFkcJVZMHTgX8O4W2s0lbJqpAu+smd/exO/amA+7n5vxZ4ENOkNQtNUc0TyF3tAWppNIQYfYCcuDPWr+yhbVnxQwK0PhkwQm2GuGQoo3/fFjP/1XBiFDQIKiNkQ728sJmvCuz/PJpPA10j1f+B3SuxV68blwJK0OUiG4rwkkEZB8lyb4fXA9/jhidIT0VN4h9D7qMH8LeATQ2jzLpN0ZcoQYPd5497Wz58y5Ek5RmhgTl5/TkxlrY6eEMDwpdNCR4hPC926jelemk4xF50H4jJjBQVe1DSxhSDGW7glOMBREbc/IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CCv1XAfSgWVWoG50wYbuhv4Ds/TH+NhgS4MWIH/kdig=;
 b=UxntodjMDCOhqqMakiBwl1jSE2WMgLbvY94bYeKBHHOab8IIZLxUGszJ9zNYrpxAkEY3emNt1yTkywAK3E8d49PmAeEcix8tou1bfEycALs+SBe0KD/OGBNeR+o/T/+ZzXk5TpUrYKGRMHsja+MTfdbfNhDsNbozUSAJBiI/byw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3069.eurprd04.prod.outlook.com (2603:10a6:802:9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 23:11:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 23:11:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 1/6] net: dsa: reorder PHY initialization with MTU setup in slave.c
Date:   Thu,  6 Jan 2022 01:11:12 +0200
Message-Id: <20220105231117.3219039-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220105231117.3219039-1-vladimir.oltean@nxp.com>
References: <20220105231117.3219039-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P191CA0081.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8a::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f5dc1a2-f7cc-4369-972f-08d9d0a0b554
X-MS-TrafficTypeDiagnostic: VI1PR04MB3069:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB30699E900DD4836A7892460CE04B9@VI1PR04MB3069.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y5+kjwqfvQVtAgXJd2yVzGIPzx9plMm3yAYbRkmHHNsJUbrrdwgFpzAlu+hTXIVtazIyPCvvS5ONm6w9Y2W6zTt2DufD+Mbas2SCovwSYbXdqPzx9BtQ3bEM3WOUYqffOriUif1jt3HzDUtO/Oqzi8apPoga5Uz5g+9g/LlmyYf8jTtIi9+3c2A7MguTu7QNnXu3ekKpIFrO1ku9o3e1EDd4Ai+yFAPgzcs2wFeniDUAaq/nZ/MOv8EjjaYbIWaaxXwyMRt2M3+7i+6Grxu+eN+n+Z4Crp3ilh/pezjcJ/ma9A0KXJD++WulL3ZbDDpZls3xaY+i5uzWwHSScALkbk+EqUhRt0ZSRyb6L/W4Gsj05UUuvjDtOiqx/5+d9LLBxDyy4uJ8D5SpvkoOT/27YQuix4gDjsjuEl1ZR0z5f5dWeVYWlWBEC6EK1Aiew9bB8lqm933Z0EUCluO8ZcTrPFCzRVbuUMoxYh6UeegMJ2fWRaCkkyP79KfcGESNJbZrgkiX0AmfeEq3AJLGDBO2iSC0tRt2gLaERUrQnZ6blWRMsiTpsZKwngNTyOv5G+i6TlPg77+O2r2wr/OdX/T5DGJnChj5L/pqG/AHzt/1n6zmKVlgmHiNr/Jfw6owFFSzqBa+3BliFuPW6yPZSddrFgtcVhSRXEoiRRffpCtORHYQHf0VxW/aONwAsHj4baJe+z9efAMTZC67pZojER/rlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(5660300002)(66476007)(66556008)(66946007)(36756003)(1076003)(38350700002)(38100700002)(54906003)(508600001)(6486002)(6916009)(8676002)(4326008)(6512007)(316002)(2616005)(2906002)(6666004)(44832011)(6506007)(52116002)(8936002)(26005)(186003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cbqasTfn8izx/VODlMir2j1T2qtn33HIilLaXTSJwUDmrcN0SIGP2CiFR/1C?=
 =?us-ascii?Q?4te9nBtkXelAFUbesTESOqI7pTm+SoKh4xiI9QlWlZ6lSIIv1gX2g1podngU?=
 =?us-ascii?Q?/+9dVm3gyHoQuJwe4aqBygiwGMyPsh3H9WyV0XnNAtQgyimp8eILprT2vZI3?=
 =?us-ascii?Q?uWT8mYP0FkFFnNHuHwrIrV6jm7yvBApHJkY4esH8hlfsuN2yZc3XV2WU/9ps?=
 =?us-ascii?Q?WTTdam5w6VJlhxnZFqsTFQFLPfTZ0m3ISdYOyggRVSsyX91l6fe8VDQw4Y+u?=
 =?us-ascii?Q?oQzr2/z7A4vaLWuFwHiRjmzdbqBzIvqdYMdmvhriv+Ek317yEUdsMB9F+LyA?=
 =?us-ascii?Q?a0vbz9CNN0Qex7iznotWRk4YNyQJyas4WR8rRDI4iRVOmj7qUn1vI/h9+wVS?=
 =?us-ascii?Q?eG2IxEbCXTsljf8DtKl41OzRPhq1PDfpIKBVg0Z7b9P19YbQOill45U9APr9?=
 =?us-ascii?Q?5CM9A3t8p4M2XiYjfLpAWjqH2pTAZ92HGmAtIRBjaelBG4zHsA/10tEnoNhM?=
 =?us-ascii?Q?0NNacqj8xe3UIUaqN4amltvxYgKZUhQZVGEtCN51zUXwIi5ejLezRYJDRBo4?=
 =?us-ascii?Q?6GfQ/PvwSj6UqR0kThQ8FteYAr5qh2hjrophLdKtcvci4lqNhreYEK7E0gCW?=
 =?us-ascii?Q?g2zwxDPZ1NhTnXUgu1HftDpsd6l7qRPcjkYiHbq4tMKS9y6aKuG0AXE434kM?=
 =?us-ascii?Q?437DR/Iief+ojuWEIg/5YFwSS+/rlIbwQ1L+4wTLJkwx4SCBN5dhFqgKBB4t?=
 =?us-ascii?Q?nnkBoefe3YzMGLAUEpx8V87EnzvhrWkRcOcFWeJikCsorUgBC7hbOXzO5fU2?=
 =?us-ascii?Q?SiVC5/RwrtOUhedGbFHXvJX3o7nZMOI8hNa4FF6OsKRS8+f0Ke1TbOXKicJU?=
 =?us-ascii?Q?1LhpwEg3TKWpTDR+SWHj84KH3PEU08ktuToCQqNeag7Fw2tOSQEOL5vo2Zdu?=
 =?us-ascii?Q?7eAKNWrALlTM5BFFR9KuMx+LrButw5RM/1KjFyNzR3ZQ5VbKde96OS/Pvcmg?=
 =?us-ascii?Q?BMusrWaExCe1VKypqvTaRlHP/Pg5c0EUTf+RWsv4G+i2uySbn0SitdSq6jTS?=
 =?us-ascii?Q?Fm1WEYQ0xBvMJQ0QZe45BftkrO3mb83fd5CsW0uq2EfRx0/l68/snGWEdEuq?=
 =?us-ascii?Q?ygsdYJXImts/NBxvFChExiyAtbv8dXRKBP3ngt39ioWwPAzbrPYYHnXkP9l4?=
 =?us-ascii?Q?tC2ZNb+d2DQfFBK+jFsa7CAwDVGcONe02E6ODTDZzrplfO/C1zZkqGZrNepU?=
 =?us-ascii?Q?pHsJN7ywsFWICpd9tZ1BzK4Ixn8hv++8LQQdjGEvPCfUhOOopp3ur0b2mv8Y?=
 =?us-ascii?Q?EwgdzKUFs+UhZExpUGbtrkt9t51GGByl4XTJaN844GGsLXtzAeQgfmF1RVe6?=
 =?us-ascii?Q?fYytdGzi6hTHvJBTq7VGw+YiVY3IJke66cAGzR1Vald43WbQenNvpE0SAsDU?=
 =?us-ascii?Q?aXt7y48ZwgmAihSuqS3G43pq7wRCKlWJdg5M5XGtO14SdWp850G1l3TfiC4d?=
 =?us-ascii?Q?bLZumfN/gdtmwlczOujDLcqHf1t/7AlgVMz940bVhTqM4dU3RtKAb9s1Lt1n?=
 =?us-ascii?Q?tIsravfy5Dh98Cy3SDgywsuMxJVGqlEU0oUIAJQgQunTyPfRU4MZsGIkiHrw?=
 =?us-ascii?Q?XS3hHygxBg0tYFEMEQp6zjk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f5dc1a2-f7cc-4369-972f-08d9d0a0b554
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 23:11:30.7231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Pc6YkS9sniswkmJhlkbE2nMxRpKnxAhgueE4ZzscE7++xHuht3EhAUwfK8Ekh0F3pLoNZwQ0QTlYVIvBpdb+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3069
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In dsa_slave_create() there are 2 sections that take rtnl_lock():
MTU change and netdev registration. They are separated by PHY
initialization.

There isn't any strict ordering requirement except for the fact that
netdev registration should be last. Therefore, we can perform the MTU
change a bit later, after the PHY setup. A future change will then be
able to merge the two rtnl_lock sections into one.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 88f7b8686dac..88bcdba92fa7 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2011,13 +2011,6 @@ int dsa_slave_create(struct dsa_port *port)
 	port->slave = slave_dev;
 	dsa_slave_setup_tagger(slave_dev);
 
-	rtnl_lock();
-	ret = dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN);
-	rtnl_unlock();
-	if (ret && ret != -EOPNOTSUPP)
-		dev_warn(ds->dev, "nonfatal error %d setting MTU to %d on port %d\n",
-			 ret, ETH_DATA_LEN, port->index);
-
 	netif_carrier_off(slave_dev);
 
 	ret = dsa_slave_phy_setup(slave_dev);
@@ -2028,6 +2021,13 @@ int dsa_slave_create(struct dsa_port *port)
 		goto out_gcells;
 	}
 
+	rtnl_lock();
+	ret = dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN);
+	rtnl_unlock();
+	if (ret && ret != -EOPNOTSUPP)
+		dev_warn(ds->dev, "nonfatal error %d setting MTU to %d on port %d\n",
+			 ret, ETH_DATA_LEN, port->index);
+
 	rtnl_lock();
 
 	ret = register_netdevice(slave_dev);
-- 
2.25.1

