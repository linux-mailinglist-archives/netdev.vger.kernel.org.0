Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23F11E49CC
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390945AbgE0QWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:22:42 -0400
Received: from mail-eopbgr20041.outbound.protection.outlook.com ([40.107.2.41]:46308
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390933AbgE0QWj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 12:22:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tshth2k064/bRDN0dVnGK1fw4jEHhdpZR57qr7Njlo/2koOdOFjPep7E47u55ToFPNDDI3ND8ybCybJeE7yjsD3RlVBxiZaD+yn5JAmjsDXhIp+bBQrYBSVUu2jMrubTorYa256Kc/lXP0giigE9DFNKW6K3gfl/Z6+KCscID43nSpnu54RFiVsSDsQSH1mK+NUhq+wX6meu2xaJ7C2YiRMgWPpFlmcsK6VgjJkHgD5PoVJNc5X15pB4CpSHJMrbHnGXrkYgYaAHDFp1WjgmV0M7BWUJABmnZ/G0Bauab03RgUkDjM3+R4bqgbVMO6XixwXj/b1QRWbZTqgq9/HHww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNDfq2VjNAJV05zCZWy8VY9uReFl3XJ9uTc3N23cfT8=;
 b=LJlctKg3vpACh/WhFMkol/02WJGxBe0BxfAAwBg0DikUqCPoCqISwc9jUw9S/0Mbc881AttfNBubGcVCk3om02sahM4fY9xVy3EhuX1sSsfcjmIjW1UjspQnkKtxDJ5k2jv8Hk0bk+NGkd59TTUvJXBpSEP48Qz5ZwfL8lCvfVh1zeAWMeRlF/uwo9y7SM87YnKzTLg1GcpxUO1TDh7pOav9+PCt/fUi+dJKMtVRz8qtyJS6zBINQMebhT2HeWqji39O9LCMSzQzjepAlOFqGLh7xtnBAYpKv75zz4cTp38lwV2Vyvqwm+xIbipF1rSF2BmrduujXr/YV/9kORDFsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNDfq2VjNAJV05zCZWy8VY9uReFl3XJ9uTc3N23cfT8=;
 b=hSOGzGB5XoAhSGN/4Aw4D42FiVmmWLr9bGhanvzXuBsduq3ek8fpajda905ttrXw4FqQEPxZkuKZH/5XohZfMAI2ZrKSDiE29tTA8N+lxGmd1Bal7tOLtuCEtzTXi/LCKTLNGFuGV0TWoZDRc/mLO3uhlY9rkYCWLizDu6zq/Hw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5054.eurprd05.prod.outlook.com (2603:10a6:803:56::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Wed, 27 May
 2020 16:22:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 16:22:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 06/15] net/mlx5e: Offload flow rules to active lower representor
Date:   Wed, 27 May 2020 09:21:30 -0700
Message-Id: <20200527162139.333643-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527162139.333643-1-saeedm@mellanox.com>
References: <20200527162139.333643-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0071.namprd02.prod.outlook.com
 (2603:10b6:a03:54::48) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0071.namprd02.prod.outlook.com (2603:10b6:a03:54::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18 via Frontend Transport; Wed, 27 May 2020 16:22:09 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bfc95f2c-e950-429d-4591-08d8025a1bf5
X-MS-TrafficTypeDiagnostic: VI1PR05MB5054:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5054044294667186257FFA77BEB10@VI1PR05MB5054.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aZV+a/Yf4dQFwR2s0EYE4+dzTbh+ju/5yVcNz1/UBzp9Jx4NCrKlpSQRuXG8hLYjnojILZFmyERqpsDtH2VC6PU6A2gFYgK0jlTf1j+7LwO8oh3p4TYP+hL/XHD128rt3SxmRYyxmfTOa3T59iZvUF1+oDK8aDBhLwGNtpO1ssqjHccFQiQtC0eU9qA7Q9BtkrDANtwyjmYfg5qkCtlBnJQLbNN7MnT99WLJOanT3AzDUa4J9he43uWt3g+91IZMyAVvE9ev+X5NIECDSheN1auNXYcoN5SldKTT/DSHA1uN8hlI8FyC2mHTDa7HSZai/rSkZbpagTqNKDaIfr8zcYHOw2RUTXbnTk+LEhfZ6AhKIWlnIBG+d5IekhccIQ/H
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(6512007)(107886003)(66476007)(66946007)(66556008)(52116002)(956004)(2616005)(6506007)(5660300002)(6666004)(8676002)(26005)(1076003)(86362001)(8936002)(478600001)(2906002)(4326008)(186003)(6486002)(16526019)(316002)(54906003)(36756003)(83380400001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: dG3cKoDh0sYGNPCrovfuqAbTWMjLFRwBGV98JSWz2++G0vH/e8V11fhfYROyc6c0ASlg3/KF1VPi+rG/uwseolje7DuKT2VQ0bBRUH8qx1WO9toApExSTK0yQ+3SqImQAxEqMdTHeAL8H8n8giIQ+jUyvqyG5bI7ZJgU3rQplT8EVqpBtqWLxE6nLyasVktfGk8N6zNYWRX8W9NTSfr2o8TU7JzZ78IBe4sJ138CoiAh0VmcHP/XXZHZ9POjeEZ1U8jEobhK4q5/jr06ClLIykaEkFdfOlNxpQfgpedarR5dk03LEimN70ALCAVNlgu4C7VKZEynJpiIJLUwKX3lurI78XEnunj6LbucKAXSI/3Tcpn1KbnJwlgJICoWJ16prov7hNnPUE9Cwo4gyWEuUgCHk3wcE9Wr3c4o1X2AmR3MzDM3JxPi9hyuw07iAezZfGtoDs306NAXqvFs3bIgSNiRk2SiasZ+EIb6s+KhJLA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfc95f2c-e950-429d-4591-08d8025a1bf5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 16:22:11.4515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ho7geKmVItUtGfAG7Z8lUsTvjejgztTDkM6uohztdckEWpURZUCjMww9dmg9zwo3URh95/a87fcNKX2Z/1QgVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5054
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Or Gerlitz <ogerlitz@mellanox.com>

When a bond device is created over one or more non uplink representors,
and when a flow rule is offloaded to such bond device, offload a rule
to the active lower device.

Assuming that this is active-backup lag, the rules should be offloaded
to the active lower device which is the representor of the direct
path (not the failover).

Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 35 ++++++++++++++-----
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index f3e65a15c950..58f797da4d8d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -50,6 +50,7 @@
 #include <net/arp.h>
 #include <net/ipv6_stubs.h>
 #include <net/bareudp.h>
+#include <net/bonding.h>
 #include "en.h"
 #include "en_rep.h"
 #include "en/rep/tc.h"
@@ -3759,6 +3760,28 @@ static int parse_tc_vlan_action(struct mlx5e_priv *priv,
 	return 0;
 }
 
+static struct net_device *get_fdb_out_dev(struct net_device *uplink_dev,
+					  struct net_device *out_dev)
+{
+	struct net_device *fdb_out_dev = out_dev;
+	struct net_device *uplink_upper;
+
+	rcu_read_lock();
+	uplink_upper = netdev_master_upper_dev_get_rcu(uplink_dev);
+	if (uplink_upper && netif_is_lag_master(uplink_upper) &&
+	    uplink_upper == out_dev) {
+		fdb_out_dev = uplink_dev;
+	} else if (netif_is_lag_master(out_dev)) {
+		fdb_out_dev = bond_option_active_slave_get_rcu(netdev_priv(out_dev));
+		if (fdb_out_dev &&
+		    (!mlx5e_eswitch_rep(fdb_out_dev) ||
+		     !netdev_port_same_parent_id(fdb_out_dev, uplink_dev)))
+			fdb_out_dev = NULL;
+	}
+	rcu_read_unlock();
+	return fdb_out_dev;
+}
+
 static int add_vlan_push_action(struct mlx5e_priv *priv,
 				struct mlx5_esw_flow_attr *attr,
 				struct net_device **out_dev,
@@ -4074,7 +4097,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			} else if (netdev_port_same_parent_id(priv->netdev, out_dev)) {
 				struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 				struct net_device *uplink_dev = mlx5_eswitch_uplink_get_proto_dev(esw, REP_ETH);
-				struct net_device *uplink_upper;
 
 				if (is_duplicated_output_device(priv->netdev,
 								out_dev,
@@ -4086,14 +4108,9 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				ifindexes[if_count] = out_dev->ifindex;
 				if_count++;
 
-				rcu_read_lock();
-				uplink_upper =
-					netdev_master_upper_dev_get_rcu(uplink_dev);
-				if (uplink_upper &&
-				    netif_is_lag_master(uplink_upper) &&
-				    uplink_upper == out_dev)
-					out_dev = uplink_dev;
-				rcu_read_unlock();
+				out_dev = get_fdb_out_dev(uplink_dev, out_dev);
+				if (!out_dev)
+					return -ENODEV;
 
 				if (is_vlan_dev(out_dev)) {
 					err = add_vlan_push_action(priv, attr,
-- 
2.26.2

