Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAE64172D98
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 01:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730343AbgB1ApW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 19:45:22 -0500
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:20112
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730290AbgB1ApV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 19:45:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wk+ZFX3wrhzDfnqKtoADDTOVZ8e63q4bRqFCijYE0RZQhGGRpZeWyIwcWLLpjVjMhHesk4KOHaSSCgDWBn3WfpYMzI56ZKFrlhREd8CO/nWsh7VRQTcmIETiTeNuLQRLtQIh+6PrTn54V4VqF1CD13uOANvWt6D39kN1dXce4WCcirNgSH0KJQ10f9/e47HnWaex4S2qDMMnUizE+pEdH26B1ibId+OSgpJxWFTpAJhCZjcnBFKMDPaVZVRM5tMDCIgYH0HPoQ0OwbGWGae1ndrO4IbBBwEqMsE7w7hMW+0RNZ24ozPE4W7DeVULC6qNddJYp/Ove2TsWwIuG+g0Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yb58xUA5tjQ/UyHk8vlgaSoxJaQitO7tR0z+RUfctFI=;
 b=MKNWAjIfpP2ytZWJTMSSXW4Cakeosu3VOawBhxFghr2Kd3ov+2aRiOQfw8GGQGIDkWfAuhIlQPym9P/RNXjuaCTJWeio4i+g3Y/VRU/4psJhZlSuzNFSr3I7BXUnt8x3UV4drG5v+q/69z353/vbwY7EZGJvg0BbyWTsfJ6AkekZx6JEOA7NyboIZuFu+r3mbSL7+YOzVAkDPHPq3Ze1AS8IHop9FplJSKXkO3cSk3E/EHU+KQpvNbaxt3DeVfF1c/JcoE+r0YZvk5bXHY4Eflf/vjimLevhGGUs8WuyQkJGDkGn/XzwGXV/8AvXmeM4eU+2NO/FdRp/GaBFZS4eEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yb58xUA5tjQ/UyHk8vlgaSoxJaQitO7tR0z+RUfctFI=;
 b=Km1YrbeNtwXtzClRI4yfttLetfDu+u8NFNeKDtfBeqSXMaeVRBUcAVVtLfXtmtrvowhxGA1Oku+MNjh0MfL5K/unklUfLs4izG5lHDyTzGjHij0Nq7wgaCDBslwaeLX66fq9SN1x46H5ojtSCBtdRmZw/dab/9tJ80Pm01Zs9vY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4189.eurprd05.prod.outlook.com (52.133.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Fri, 28 Feb 2020 00:45:13 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.024; Fri, 28 Feb 2020
 00:45:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/16] net/mlx5e: Don't allow forwarding between uplink
Date:   Thu, 27 Feb 2020 16:44:31 -0800
Message-Id: <20200228004446.159497-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200228004446.159497-1-saeedm@mellanox.com>
References: <20200228004446.159497-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (209.116.155.178) by BY5PR04CA0004.namprd04.prod.outlook.com (2603:10b6:a03:1d0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Fri, 28 Feb 2020 00:45:10 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a8c879ac-4c76-43ed-5c4b-08d7bbe777f8
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:|VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB41898FA5559A96FCAAAFB384BEE80@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-Forefront-PRVS: 0327618309
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(199004)(189003)(66556008)(66946007)(66476007)(6506007)(316002)(4326008)(6512007)(107886003)(478600001)(52116002)(54906003)(6486002)(26005)(8676002)(6666004)(81166006)(86362001)(8936002)(16526019)(186003)(36756003)(81156014)(5660300002)(2616005)(956004)(2906002)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4189;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0yz+aPzRAeNBCvbzThChYv9f0VsT3bWFl6xFJgipXUxc/GVNIARdTpJgm4q9G8p2sXNJnNA+CBJDCBpZfJ+5LXPaEUEDaidE4kIzOzJBdluD+lUB+7VJKUJ75jI3uH6TeZOcwAA/fLi2IO3aqvue+j6i28Q9c7ONOIVqm0hqEekbz3HCygkP7BJb/KRtsGskUJW5oPbwBQPsD0TNfCGex7Y+/t5AFUPBcjybEC+9P/JU60sdxiwFKv16fMklOPFvbPBtShH+Slzv93hXp0aQOS8i/7ZFrzxGxFrGJ4MUHTaSANosReM12fx/J855Hem6qXd/gg0J83XHVxFX1bcfT1BFQQoutZeIUFWAknxNlMAKbJK5kw6jXYEsYnuHAU6jYegW5DbCcgOfhrr/fPA5qcPpz0J+VL0kBFn9PEF1etYoQxVhuX4WvKL9wSqqv2bqQy8ZnFFKq1h7qoPzNJ1ji+Mtkx11VwdVKdI8MpenQLemID5gC3Gx5L6ULpNfR4koT0L9RKUPHErQjJltkGejWH2j8YbMWQHsXROkpP/bn1M=
X-MS-Exchange-AntiSpam-MessageData: 9w4tCpqM4+5/sbECjaBnqw7zKTl23MTofoH5Mt3hG/JdEn/UbUpaHCtBZMADvOrx4otML7OprTX1rslc5krRb20zdENARHFSv8VhKfFH5sunX68wQGUg7tFFdjG7+tzPP/qt3yo9o9RYGUoupyO+zg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8c879ac-4c76-43ed-5c4b-08d7bbe777f8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 00:45:13.2492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4qDdsNTyvkmJhWkzzNOwbiTLt/FlAJMO1BNxTc2djflYAeL+JCihUAgpqEYPsRpMUtu+M34p20URyfL5O1Cx6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

We can install forwarding packets rule between uplink
in switchdev mode, as show below. But the hardware does
not do that as expected (mlnx_perf -i $PF1, we can't get
the counter of the PF1). By the way, if we add the uplink
PF0, PF1 to Open vSwitch and enable hw-offload, the rules
can be offloaded but not work fine too. This patch add a
check and if so return -EOPNOTSUPP.

$ tc filter add dev $PF0 protocol all parent ffff: prio 1 handle 1 \
    flower skip_sw action mirred egress redirect dev $PF1

$ tc -d -s filter show dev $PF0 ingress
    skip_sw
    in_hw in_hw_count 1
    action order 1: mirred (Egress Redirect to device enp130s0f1) stolen
    ...
    Sent hardware 408954 bytes 4173 pkt
    ...

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c    |  5 +++++
 .../net/ethernet/mellanox/mlx5/core/en_rep.h    |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 17 +++++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 6be85a6b11d4..3557f85f611d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1464,6 +1464,11 @@ static const struct net_device_ops mlx5e_netdev_ops_uplink_rep = {
 	.ndo_set_features        = mlx5e_set_features,
 };
 
+bool mlx5e_eswitch_uplink_rep(struct net_device *netdev)
+{
+	return netdev->netdev_ops == &mlx5e_netdev_ops_uplink_rep;
+}
+
 bool mlx5e_eswitch_rep(struct net_device *netdev)
 {
 	if (netdev->netdev_ops == &mlx5e_netdev_ops_rep ||
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 3f756d51435f..8336301476a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -200,6 +200,7 @@ void mlx5e_rep_encap_entry_detach(struct mlx5e_priv *priv,
 void mlx5e_rep_queue_neigh_stats_work(struct mlx5e_priv *priv);
 
 bool mlx5e_eswitch_rep(struct net_device *netdev);
+bool mlx5e_eswitch_uplink_rep(struct net_device *netdev);
 
 #else /* CONFIG_MLX5_ESWITCH */
 static inline bool mlx5e_is_uplink_rep(struct mlx5e_priv *priv) { return false; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 74091f72c9a8..290cdf32bc5e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3405,6 +3405,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 				struct net_device *uplink_dev = mlx5_eswitch_uplink_get_proto_dev(esw, REP_ETH);
 				struct net_device *uplink_upper;
+				struct mlx5e_rep_priv *rep_priv;
 
 				if (is_duplicated_output_device(priv->netdev,
 								out_dev,
@@ -3440,6 +3441,22 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 						return err;
 				}
 
+				/* Don't allow forwarding between uplink.
+				 *
+				 * Input vport was stored esw_attr->in_rep.
+				 * In LAG case, *priv* is the private data of
+				 * uplink which may be not the input vport.
+				 */
+				rep_priv = mlx5e_rep_to_rep_priv(attr->in_rep);
+				if (mlx5e_eswitch_uplink_rep(rep_priv->netdev) &&
+				    mlx5e_eswitch_uplink_rep(out_dev)) {
+					NL_SET_ERR_MSG_MOD(extack,
+							   "devices are both uplink, can't offload forwarding");
+					pr_err("devices %s %s are both uplink, can't offload forwarding\n",
+					       priv->netdev->name, out_dev->name);
+					return -EOPNOTSUPP;
+				}
+
 				if (!mlx5e_is_valid_eswitch_fwd_dev(priv, out_dev)) {
 					NL_SET_ERR_MSG_MOD(extack,
 							   "devices are not on same switch HW, can't offload forwarding");
-- 
2.24.1

