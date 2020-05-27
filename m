Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E396C1E34FF
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgE0Bu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:50:26 -0400
Received: from mail-am6eur05on2043.outbound.protection.outlook.com ([40.107.22.43]:6191
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727808AbgE0BuY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:50:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yo4o7n42DZ/N+9iVOHu9eTLFUmAJRDrXEFIc31ykib8w9jLP4x6R5804rGFlpOQa+7AB+SaIyJ9dZxfbbx8BI5Uv642R0sNyEdQvgDdTYWlwQvnaTJ24J46EgX+8g4yGuO5EZbLfb20OUbpSRaZVZzFyeGcvMaH6me0TzejTH3JdmpXdz6f2p7cYEt3g/L78RydX4o81M6EA3QeGHGy3Po7INg76h5DpFuV+30IdqeDVFEVyl1Lpd+0gUQtnnZXSkwyeXWb/1a495GVwdg9F4GcoqZEQMKwfRUPNc83eZTUQqpb9ruvZ/ZqhLIAk1IVXfzWZXFXSKPi4Gfn99Sbx+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNDfq2VjNAJV05zCZWy8VY9uReFl3XJ9uTc3N23cfT8=;
 b=MSRYoykho6DRc5CcyErMhzgyzS+VpCrUQIp1UinMkhVPq0hXHDWVJ20eOFz/07rvDzT/wU1/NEU525OVcDP7ZknMp9+VW3SVQ25bhMf71JljEsxXE/ScAqyrrsn4UNBVxko+KmjqeL6rNUZSrh02ftyzM1HdDxPOUhieK5+dWtt1KZunr5vQwRQU39VzrxHuokdpSaHfRyY2ZHBsgELU/zFsYSZMpSa4vYWz/2iJw0RatTp/XXROPN+JrW9CecbvVvrN9AR9xEZsKU+if4TOJTexTJzey2L/oIT8t0YAfdKAg8Opns3D0PPtLFcgJaFBXAuka8UzcSW7cbDETyMRqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNDfq2VjNAJV05zCZWy8VY9uReFl3XJ9uTc3N23cfT8=;
 b=nh06XqAUD9h3Dh9b0DwobdGhj8nwgYeTRcdSqIH4GB/ID9kl+20jVvT6bQ49b9ZtYn1NRs/DmEyUNvRPesBdL0vn6OkBTWBvyOFqVyKRZidtUiAAPukEcqkm3BcRudfjJ/LFYsY9DN/BleV+QOZ5gaGKhsoQ8AZJwhj+TLC1ySk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6637.eurprd05.prod.outlook.com (2603:10a6:800:142::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.26; Wed, 27 May
 2020 01:50:07 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 01:50:07 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/16] net/mlx5e: Offload flow rules to active lower representor
Date:   Tue, 26 May 2020 18:49:14 -0700
Message-Id: <20200527014924.278327-7-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527014924.278327-1-saeedm@mellanox.com>
References: <20200527014924.278327-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0061.namprd11.prod.outlook.com
 (2603:10b6:a03:80::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0061.namprd11.prod.outlook.com (2603:10b6:a03:80::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Wed, 27 May 2020 01:50:05 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1ffe936d-cfda-4e72-4da6-08d801e04898
X-MS-TrafficTypeDiagnostic: VI1PR05MB6637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6637E1C52C6269D01E593B36BEB10@VI1PR05MB6637.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0N9tZfuze6ye2HabO2ZV9HnCkEkXrwFvkM/zXKaiKu/iI+VUogPv/U1jQeYjPD8WP33as0Wre0WwHpNgw0onbJnmjWQSrvu3vcXYALX2Oy0q9xQdKd4JmlDpydCE2b3UiHYJ5qQHYvU7KmfETGpPy23VkMpycH2wyPFw8J+ZrlRl5W8obmSUWcWgXhjsxWJst/P8UAoM311AwSlM2GkxQ1vKupj3FXXskC1EwK5rZSZrt8XkQATq9I6JlsesK8ntDWICjxy2H81ZmdedesEUWliKBxoKRQlhcYWJzuuqmfF7sMPD/r4pZgKjtOSdt8PfiIObZ2AOnqFW2HgSaoiWMYCgaWeIm2RRZ7b/A8xwXwhrAuFooh/wA6MLDzHSbNpN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(366004)(396003)(376002)(39850400004)(26005)(6506007)(6486002)(6512007)(8676002)(478600001)(16526019)(86362001)(2906002)(186003)(6666004)(5660300002)(1076003)(66476007)(36756003)(54906003)(2616005)(956004)(66946007)(107886003)(8936002)(316002)(52116002)(66556008)(4326008)(83380400001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 7JIFSJbTYtuwQKi7PgZ3+4/6qaHBbSIVZXlOYS0Z6hQn4Ev/MlUTHbk5EurF3ME7Orri8QxaFjD7Q3jOsK82U22L/LavIHnNAasiAf+KIBI5/e/qcLe/hOEbdoKvKbSf5SquXGfD6oAfn/Evut8VdZPLHF3eMYOY4T/WclQn4jA4TH8IP4AtLYqOx/l/7b3bXGNBgJkdfcPZfvDs62O7bDtR1W3YjQZBhWcntVyZs9e94C6M3AGl+m2OlD/GlB+oC0KN9YI6ZLi75t8T6mYb6o+QL8HOp09vnDlGRNK+MvwP8oIZo/vLlk8GNW9vYVA7LPVVSQilHjJ3bDnFh0akutr42zuhyN9v089ya07VZZydJQp3XmVuU9d31633/wb4n8264R/SDcQaLsxZvRk1N//1Zsm7aFrDLRyjjt4ezU9V6Vjj1JvakpB2rOrwkdwRDmtentkX/p32MjJEm1u2xWSz0bqyRBLAxijfODGJ0U8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ffe936d-cfda-4e72-4da6-08d801e04898
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 01:50:07.7216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FTVybGz0sLFmazefsewC2NjghLFY0Qs8FLGUEJVoQ4ml8i7Tri4vkttnqnCgeRcXoBZ0Uhx16x1Wokfur+il2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6637
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

