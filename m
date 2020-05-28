Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C6F1E52CB
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 03:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgE1BR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 21:17:58 -0400
Received: from mail-am6eur05on2056.outbound.protection.outlook.com ([40.107.22.56]:6231
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725940AbgE1BR5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 21:17:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iCtmbBmN+G/vjgNtuUnSF6/XIcuK2QeXIZEOG94TNlmWZdcyh5q0v8r3l/91TyZCfB/exdfJ0LBkqtdeCHFJ4HKYVVJOQUREpTC87jVbSPeVDGoDTZPeWxEISnhVXp8/b6XrJEclC9Nv4agMmUMvnfH/V+SYkYirmzZVB3fT62FJ8z7g4Dk4Saayc5vCYuHUe3tnUnhQVPsdeeUI0xbg6Yj00GdTRwPRDhE+M6ifW0CItJF8o+RJhHpLqmBYyo7aPF2nWeIoT7295mcC5KLA8SioSLbHCkErLxsWzpF3CbpH0z0rxishQbAbfQn7Jn7o8jgmMkDvbk68kuAuqyixng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNDfq2VjNAJV05zCZWy8VY9uReFl3XJ9uTc3N23cfT8=;
 b=aQVIGXBMQxOniSa/LdUBM5R1uGcxNaagTImCNnTd+yzpHoMSknwgaJhrZJbpvrs7WRtWrHdX9p8msUPwhrYQInaxYJZA5CsS6bg+mO5RZHmY00v12ipWMBvM/rcfj4jsJpmmNWnF4933W8o/2ubjMgbVDWPp5wDJNdq4gTnztFP7+HFRE2StzShrGXvYXkjiCE29vF5ClyaehymWmafdVA+ChXQG/mmJmBrWkIjXT5L82LCNCGS+SaZ3TXARalH2fOzIgTPr8Yi5b2kQM5Nena4U7gIH1N9pqGYcFfrAChJ9i1YWDL8UILGytSozvGRamzuTSn7O5wwxoyRpHIi+Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNDfq2VjNAJV05zCZWy8VY9uReFl3XJ9uTc3N23cfT8=;
 b=jZjHSxnbd0SzDY3JHKOOpRiLlSMh0lOjkcNRLMbI4LPPW4rSPs1MFggZDNYYfRucAUMnIiRrSywYwVQSMpMzTB+eL5waft5lPJDGTTxgR2KCJJVD5uzf+3l47fXzmoos+RQakPyBM+5QQck6PT4m/4M54Ems9ksnJaGIx9dukt8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4368.eurprd05.prod.outlook.com (2603:10a6:803:44::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Thu, 28 May
 2020 01:17:39 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Thu, 28 May 2020
 01:17:39 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 06/15] net/mlx5e: Offload flow rules to active lower representor
Date:   Wed, 27 May 2020 18:16:47 -0700
Message-Id: <20200528011656.559914-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528011656.559914-1-saeedm@mellanox.com>
References: <20200528011656.559914-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::11) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0001.namprd04.prod.outlook.com (2603:10b6:a03:1d0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 01:17:37 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 15af07fd-dd7c-4154-8101-08d802a4e9ba
X-MS-TrafficTypeDiagnostic: VI1PR05MB4368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4368608652F76A4510C42F6CBE8E0@VI1PR05MB4368.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7RKaA5f/CfwdCmgPeCwMYwBReKgmxmzfCOXs0uvvE0moWvY9mIo8tNPCYb4nvaSZdKFBQmJbDrWjgVe5mjo5SrVFl3aCNgysDKhPTBE5uP9Nsc1xsexAB5KdI57hkJFC3ponGcMLQgFws4J/eKpQj5GtOaKBWtxyuEoBa5mAVhLYVdJ5QHw9uZd36mbkjuOmj4ALC50l42L8NvVp5zr9me6kxcE6tNaE/8z7wSWIY8/cfV2k9PhkXQCr0GcLfVT+rgGJ+UFsEVCYBNXsgqIS4ibi4RslinLsVLVaaFf7yNRRA8hVyBsr9j29JiQHHtuSFLrp1GgGxuL835D/FFiQxREYbZVWZW2CdIg7wlElaBs981yCuBbcZ1n7/gbbyOwN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(26005)(54906003)(52116002)(66946007)(66476007)(86362001)(316002)(83380400001)(66556008)(5660300002)(6506007)(956004)(2616005)(1076003)(6666004)(16526019)(36756003)(8676002)(6486002)(478600001)(8936002)(2906002)(4326008)(107886003)(186003)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GBtIX0OwpqVPwULhfczcuZC8vCZI1AVSPo0MaP6r9+r7U5iJW/ijcmlF03n9crbfftGL8HEEzO8SSRr3Cd3wNVSA916L/6Eh6O2izPZiR0NOk7SbOe8gQ7AbMONzbwrEleyp95F0krZVhOe4A4h8zbGvHYRXNAQuoHvlibtajQAViAICzqvHuWTkn7p0+IxY6vmiaTede9YNa2Zikp3xNfQU/0JuY/rNrxyK1q3lYfx08XLZuSgzd171gRt9PZsnPkPf8Bi2LWt9KYbbVrLhlnazT/bq6idquvIjJVVvi4YDXRXfcUJsnOfLJ/1lIPhKW0lhJNNhgkoLPmVDfpuhFmeWjCmz7YvoHBBW3iGDvLrLsqxJPPV079QtC5ANLtLTu21TotDuLS6kQIcNw//tJOqbnglM8DU1/Z/cY6Xau12npKdRHexiFIrW+8COwilS31ab+pOqAXXOLNgNXGTAuR0nsMvNj+/IIb6Hbi85kC8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15af07fd-dd7c-4154-8101-08d802a4e9ba
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 01:17:39.4190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9kWbcxhMc2HmfRtALTcuRnxY3bA6Q3YYJie6ECo3x9iRKJH0BxrCUOQSq1MoIqLZTLtjUYRJrVTc8KFch9ZxNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4368
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

