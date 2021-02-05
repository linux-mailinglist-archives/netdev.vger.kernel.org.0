Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F7A3115F5
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbhBEWqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:46:42 -0500
Received: from mail-eopbgr50071.outbound.protection.outlook.com ([40.107.5.71]:21318
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232466AbhBENEB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 08:04:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VQSz+CJQ0bgbgzjumd23Pr+NjYndTwIPGi9nml2lFY4PfHxceqLJoGzU7bl1q/c0y1zc/k2/TftjfVVAokWL2Hzi7eFXyj60qXFnqLfPCTacqFn71q4tQmbySBuBnaCi2BLD27a1Vr+np2GG18tAN2lNnfL0uyYWhwVtifOQ0JuPFILSsLVMji+lkKh2Up7OkqJrCCBndBb/M0auOxwsOZD8z22g9oN2J0fVX8igm3/N+UlAIT+flK1G31p2tFqZg24DABm167MVIiL4d9bSGxZRwA8DR/NPOqkdLDXosXblG6V1VFLks9P42g+ExLotLzqkoNibwZrGgHaP0C1TRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lp+AGvLsLN6tC9hk0uH+apufGoxmvGjlqq9D0ZDxIFY=;
 b=g/x55z+iGW/KVO7FpTFbykPcPUVDy2bSG7O1xVFj3kMMtpk90HkIk3VPcwWWZGbzxKt7EL1GISv3QKwVe0ZxgOTso9lcEtO2pp71/k1FbhvS+nuEft7JPI7LysLHNSsVvPXiluELVCtUI3j94vH1i2tvfgZH78PgIZxLZkp25g7Gfd6K4wr+5YRcDH4V5KCdQmfKeDES6vnWbGM/Dx2FqvifCikC9IAtPiYETDu3x7pBOR9c3DlNlIGeNRMV65tIAvRuDAdUcwKL60lqS8HXuwo5znZeaWb8f1vMJDKD3mWEViD6YlGXzhXUopCr2vtUBO7xPp97RXchZCBDML842A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lp+AGvLsLN6tC9hk0uH+apufGoxmvGjlqq9D0ZDxIFY=;
 b=NvV8sal47NcGRL0nrqtTSwIUHuoqe7QcqFSXXQgUtP7Bhpwg6E6374IPKhbjppdnKU3fKfd5S/FUHeBnonwAUJ9+U8ZtixP7tVzf3nAXAXju+cAyJt1ObeKJ71QvZb4Yt2v1V4WCnW285vuCoQQFHlZVRnVK3xZo3k2FmHPKhXs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2863.eurprd04.prod.outlook.com (2603:10a6:800:af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Fri, 5 Feb
 2021 13:02:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 13:02:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v3 net-next 02/12] net: mscc: ocelot: use a switch-case statement in ocelot_netdevice_event
Date:   Fri,  5 Feb 2021 15:02:30 +0200
Message-Id: <20210205130240.4072854-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205130240.4072854-1-vladimir.oltean@nxp.com>
References: <20210205130240.4072854-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.12.227.87]
X-ClientProxiedBy: VI1PR0502CA0004.eurprd05.prod.outlook.com
 (2603:10a6:803:1::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (5.12.227.87) by VI1PR0502CA0004.eurprd05.prod.outlook.com (2603:10a6:803:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Fri, 5 Feb 2021 13:02:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f1d57f0a-4f06-438c-1880-08d8c9d65d17
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2863:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB286368BCBAFF457ED410F0DCE0B29@VI1PR0402MB2863.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TgFurUlPAj3pL34FFLic0OLa/Yt/k0QlbwggKh2Z0ngcNpKv8QhjduONGfS+B4NCCXJp4+mel+xC/ILkMyprk2I4xfHTpGkmU6EU6snxvIhSyzODT3pEBCiXizXZtwiM1mTKN55GmJs2hZlXTZfd88/2sCSsoiOSbctYMNJMEGlLduy4ExU4ve38i14Dl1dVqre1y8udwMQ4KhCmicxMIO+slKiMMT0qIu1Zyt9op6O7mC1IKXQ3RapoYem1Y/rMNyRTfNNW9yfquIshhEqo126YjsMKW7UfRK0ZZhYLR3FXI+0KCtXhHhGWxAzEqm/Z/d8tQgQEVfGq+38+GIEb+IB3WFN6jUViIKCZ1Be+zdEQ+Tf1SATnXl5/XfQbKov9aHKL2sd00BXh9AXFa34gkTv1QR3YRemdMXhV0LXVnwRbWnYd2NTIc/UE+1P4yjKMOebCb3rQaMLh3Um61VlnXKXJWObd+WvcuuMmSOd8g95YcncuyFYdfi0ezXI0NyQpnCWpeiZMQu+boe99lcTRL+iKEaQ9HfGxK6tKzmOf2yorL4/4Vem95WX6BP52Z0U2fftOjqlusXlyhFB2fmlUAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(39850400004)(376002)(66946007)(316002)(26005)(86362001)(6486002)(83380400001)(186003)(16526019)(6506007)(69590400011)(2906002)(5660300002)(44832011)(478600001)(8936002)(6512007)(4326008)(52116002)(54906003)(2616005)(110136005)(956004)(6666004)(8676002)(66476007)(1076003)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6YPYZn06XCTuEV/K68RP2ScFFvGWCF4A00F0hwCiDukYW71bxq2OF591eIsN?=
 =?us-ascii?Q?OtRidFcv7ySjAH7nBpbLWjN05MDQvDhcmVb3YycmhImfQjMyFVt2Nkn+ohG2?=
 =?us-ascii?Q?agSd31hKpXZJxoC70xYL86P4nArreFupEjTS75yx5SfFt8hVGf+wYRjN6XY+?=
 =?us-ascii?Q?RgrQdmRr58feaqk+t4n/lVyjSAxQ5Qk6NlHtjfNG7ZZ8o7xaOo3R+RK0DAAj?=
 =?us-ascii?Q?CN7OsO3Py8eqc/6RUhymtco24JsmMMupggfKKtTojQ8lIE3XTGGrYwE+PQHB?=
 =?us-ascii?Q?GHq01Fwq8RSeUzFa3BQIDGfgjhdQ6FYM/6OHGKlgbZD6Fpb7zOU8bjQBI6Ak?=
 =?us-ascii?Q?plEuzAkML+WGcXAJr2Hv5fNOZXVnislfhjlMfkdQ1ZgNThNhmU8ZWVFt+4nd?=
 =?us-ascii?Q?BVCRcitFXG0U+2DQZiGVTqdQURk2Trk9kUuf7w7o6fyJF8HcHbj4/+Wg0L8X?=
 =?us-ascii?Q?bvi1qIhL0YG+hikRM3wb3K6dPGQzkH+zFPCTWsLROevN/xDRUrI/r3ssa3ZG?=
 =?us-ascii?Q?rmrlrcgJPq40/3ivkPSaRuCrsJW0me9NSUq6qkV50Qj9AVzs+uzmUaciUZ6t?=
 =?us-ascii?Q?o4fMaH9ZD/uJS42XEz5fFNusVUAuM+aVOWqB0X2M9dpv4Cq8EcwJvvFbrlk+?=
 =?us-ascii?Q?5tey5pa+FbGzCUlLSciJXkGTwl5I41VzjS+LVm81BxyuD5XK66FFds9wrAs2?=
 =?us-ascii?Q?Ok0JJuAq28FwDZay1Ip4/BH9oj/fVbu691mnl0g9Um88vyX8/LsoGi5eU95E?=
 =?us-ascii?Q?xtCQXcrJVTlh8lQq00KmwmAIIC/CeTuRwGz5/+41DMr+PY9PSYWw/25eVDU5?=
 =?us-ascii?Q?VuW+BInLi33Y8A9fvs/Q99+NNL8qruC8kBbAmkHFEKsb98ygXZQi/TwvQgeF?=
 =?us-ascii?Q?iNCgbVzvE+maysy47lhLhPDJbyxVTp1LLJ7fcMpb5W4RbURvQQ6bNLkpz8tU?=
 =?us-ascii?Q?88wCAkIn46OyB7cNQuN89YvcTSo5tGEYcxwtt5DIDfKgfWg81D8OvViCCDjF?=
 =?us-ascii?Q?2zmo5ayXvRul0FSPG6qkelHz6Dmow9k++Y282zOBdqTo4QARgORt3e/vTB5p?=
 =?us-ascii?Q?ei4HiN2d7ZV3kNrhkuZ/T9PVVvTj3D4FP3THyHyKC3Gu+cMCrl7ZqRBbw6i3?=
 =?us-ascii?Q?r4MGmmMwHpPeoHYBCfw3JGbPnoqUPBO73W4IDesssObVet0m8LB+3shEvmhl?=
 =?us-ascii?Q?3SP7d6uiwmxbGUJ6uEPUi/V5nk/uTvMZq/g8oikK8hsMbJfPhw7IwzI9CiP1?=
 =?us-ascii?Q?/0Xp8aFCGBKncu2uPmJorAnjrIO3TLp183y3UB4LfrrwUfabwegdlQndjLbY?=
 =?us-ascii?Q?yYD00Hc6sLlWqKrHMMusS8W5?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1d57f0a-4f06-438c-1880-08d8c9d65d17
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 13:02:59.7812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oOG/lyv6mFZTqPM86JIQDzcuODHbZ1IpwK9vgH2B3uyINfNvMHE1lvL0JmQOQQTAVl9AckdKVXZiEUZti8A0Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2863
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make ocelot's net device event handler more streamlined by structuring
it in a similar way with others. The inspiration here was
dsa_slave_netdevice_event.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 68 +++++++++++++++++---------
 1 file changed, 45 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index c8106124f134..ec68cf644522 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1137,49 +1137,71 @@ static int ocelot_netdevice_changeupper(struct net_device *dev,
 					      info->upper_dev);
 	}
 
-	return err;
+	return notifier_from_errno(err);
+}
+
+static int
+ocelot_netdevice_lag_changeupper(struct net_device *dev,
+				 struct netdev_notifier_changeupper_info *info)
+{
+	struct net_device *lower;
+	struct list_head *iter;
+	int err = NOTIFY_DONE;
+
+	netdev_for_each_lower_dev(dev, lower, iter) {
+		err = ocelot_netdevice_changeupper(lower, info);
+		if (err)
+			return notifier_from_errno(err);
+	}
+
+	return NOTIFY_DONE;
 }
 
 static int ocelot_netdevice_event(struct notifier_block *unused,
 				  unsigned long event, void *ptr)
 {
-	struct netdev_notifier_changeupper_info *info = ptr;
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	int ret = 0;
 
-	if (event == NETDEV_PRECHANGEUPPER &&
-	    ocelot_netdevice_dev_check(dev) &&
-	    netif_is_lag_master(info->upper_dev)) {
-		struct netdev_lag_upper_info *lag_upper_info = info->upper_info;
+	switch (event) {
+	case NETDEV_PRECHANGEUPPER: {
+		struct netdev_notifier_changeupper_info *info = ptr;
+		struct netdev_lag_upper_info *lag_upper_info;
 		struct netlink_ext_ack *extack;
 
+		if (!ocelot_netdevice_dev_check(dev))
+			break;
+
+		if (!netif_is_lag_master(info->upper_dev))
+			break;
+
+		lag_upper_info = info->upper_info;
+
 		if (lag_upper_info &&
 		    lag_upper_info->tx_type != NETDEV_LAG_TX_TYPE_HASH) {
 			extack = netdev_notifier_info_to_extack(&info->info);
 			NL_SET_ERR_MSG_MOD(extack, "LAG device using unsupported Tx type");
 
-			ret = -EINVAL;
-			goto notify;
+			return notifier_from_errno(-EINVAL);
 		}
+
+		break;
 	}
+	case NETDEV_CHANGEUPPER: {
+		struct netdev_notifier_changeupper_info *info = ptr;
 
-	if (event == NETDEV_CHANGEUPPER) {
-		if (netif_is_lag_master(dev)) {
-			struct net_device *slave;
-			struct list_head *iter;
+		if (ocelot_netdevice_dev_check(dev))
+			return ocelot_netdevice_changeupper(dev, info);
 
-			netdev_for_each_lower_dev(dev, slave, iter) {
-				ret = ocelot_netdevice_changeupper(slave, info);
-				if (ret)
-					goto notify;
-			}
-		} else {
-			ret = ocelot_netdevice_changeupper(dev, info);
-		}
+		if (netif_is_lag_master(dev))
+			return ocelot_netdevice_lag_changeupper(dev, info);
+
+		break;
+	}
+	default:
+		break;
 	}
 
-notify:
-	return notifier_from_errno(ret);
+	return NOTIFY_DONE;
 }
 
 struct notifier_block ocelot_netdevice_nb __read_mostly = {
-- 
2.25.1

