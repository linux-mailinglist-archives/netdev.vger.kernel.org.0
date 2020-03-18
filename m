Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3E9189427
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 03:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgCRCsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 22:48:47 -0400
Received: from mail-eopbgr130088.outbound.protection.outlook.com ([40.107.13.88]:62369
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726229AbgCRCsq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 22:48:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSKYz89gqYQ+O9fJrUYTENHFXD9vPR122IHEA7xuYpZrpbrwfm4FtFmw1oEmlBUtiFQuZtKbBMJWfr+gMc3Xkv+6AQFJvJReHZ/OQRrdrqARxDGBpqT8rMf1OBN9AZpshSK+4/h+hpU0dqdR+WdGoKQL7OwN0G8a9pb7DdDiJq2ZbnaRJO+OYhZSVppITFM6PXwm5NsKJKeBorwJNoQ1L6uniwo+o0F6JfXCYhuaUbc3ejy23EaC2SCNc9mFpaBd2prXIViCFJZ+qOukEmqOfm3tN3nhG7TwnjwWoo7NYp7dilE3w88mG+1CiZGGdx04elXaHj09uQAvX9Q1uY9pBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BPmI65yBOQWHgfwyNAoVsI/qOEDJlTdp8ylS1cyhg8k=;
 b=W6vstfZOqCXjNp5CT4rRTIID8Q7kjdE6sJGUQWCf7bcJ7PTQL7iU29NCeIO26uUUHQOj+gG9TcRJTzyImYHZ5L6zdSPVXw+3NftidxtpkkK6u16PSTKwSdr/VVMH59ngmabSm83ofI1T4BTkdCv9UQ6/GGECox3/fxB6atpnP4h8Gk4Vha+ZGJhVi04KOf7dgDHRSEHZ24V3srX79I2/N9O4ZKaxOerWtsjpYe8vuseDR7LgWFyhhT1Mq3tieVbg7kX1kfEDVv6tcwPJml/dZ54ssvzK22gb2EYCRpaYJ1BAXqRD1XVRMAFpZzGir6uGeXvXbg6VU0Uicb9nzBndTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BPmI65yBOQWHgfwyNAoVsI/qOEDJlTdp8ylS1cyhg8k=;
 b=cxcIsyOwfuVwF6RZAUtrVwsPjaFq2fFGSAnRgLV+9wSjO3vzp6pLWAmsnXj0SHItFjjwUJPJp3kHgKd8M8M00M08ihxGI3Tdpb+BSzi3qn8tKuA2W0HcuuuAVmmEVThQulbc147sfgcxEnN1Rczm/2WGeIRSFiqnftaj54n99S0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4109.eurprd05.prod.outlook.com (10.171.182.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14; Wed, 18 Mar 2020 02:48:27 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 02:48:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Eli Cohen <eli@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 13/14] net/mlx5: Eswitch, enable forwarding back to uplink port
Date:   Tue, 17 Mar 2020 19:47:21 -0700
Message-Id: <20200318024722.26580-14-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318024722.26580-1-saeedm@mellanox.com>
References: <20200318024722.26580-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:180::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR13CA0027.namprd13.prod.outlook.com (2603:10b6:a03:180::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.12 via Frontend Transport; Wed, 18 Mar 2020 02:48:25 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5c59ad20-592d-4995-0da1-08d7cae6d5a8
X-MS-TrafficTypeDiagnostic: VI1PR05MB4109:|VI1PR05MB4109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB41091918C660936978BB702BBEF70@VI1PR05MB4109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(199004)(956004)(478600001)(2616005)(6486002)(2906002)(54906003)(5660300002)(52116002)(86362001)(81156014)(6506007)(81166006)(4326008)(107886003)(8676002)(8936002)(26005)(66946007)(186003)(16526019)(1076003)(6512007)(66556008)(6666004)(66476007)(36756003)(316002)(6916009)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4109;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ynoeWisOtc/DqWloviD2U1aqTFCZ4bdbSBfvzOscwq5ztTpO9jynSov1m0y3/icSdNRYVfdVloXl3Gbij3eQPHbDTgMXKMyM6QE4AgvqYhgm79bs9SSApCSeHNshCa8MwdIeqPZdiw2cny3HqJRbdl3QvyU3VLILVXen4RafCJj6QcxHerjppyq81vFs4UFBmATTbXeCUcWxZSFk5V7xeCUhmpulP71tpZc83zMQt9c9xgUTNMf3LzDjALQUfvleWUF2dN1E6dzTi28FK+3asbHLqHA82EfwspIN4sZqS5CjWJr3ZN7szne9oRd/vm1aB3HdopEq1GBdedYMKO9nPcwMdPgh60nOLAgFWar7/zthQH5VaYIK+QXC9fBx5KMJfViq5N2ecAC53lT5DfdfseQrDCmn2muAQCidYrRQeD+pUkBbWwyvKR0aX3UocY0ioH69wtnRBBHdr/KW8t1wnxCoMC6ulvsY5YUrGkyi98CfVrCORypTCiYzgljywpMcOMTv7I4cIO4CG62ol2LoI8PELPc6HLzVY4nbNrX+1tA=
X-MS-Exchange-AntiSpam-MessageData: c+1DRLmDuDCocY+oPM7C0Ivf+jYASV9Y0p6H0MV1ArJbWGXmnNQpJ8lj711P/ma7Cp5EX9Z46BWNW7/Pit/90GpmpL8Kk0hFn3RYdyB77itqHsSiFAbRQM8z8P2u3i2GMdHBwIFFtgrrLmSsLHiSYg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c59ad20-592d-4995-0da1-08d7cae6d5a8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 02:48:27.5981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bbLPj5Q3QOCy7sOgT5qVuh0OXIlph11fkVWiTm6xWsBcv8h9jE9qwqND8sbHs6MxVqtlVlfE3dxe4Ns8rBqh6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Add dependencny on cap termination_table_raw_traffic to allow non
encapsulated packets received from uplink to be forwarded back to the
received uplink port.

Refactor the conditions into a separate function.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 59 ++++++++++++++-----
 include/linux/mlx5/mlx5_ifc.h                 |  3 +-
 2 files changed, 45 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index ddb933aa8d59..ebf60ff30295 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3641,6 +3641,46 @@ static int mlx5_validate_goto_chain(struct mlx5_eswitch *esw,
 	return 0;
 }
 
+static int verify_uplink_forwarding(struct mlx5e_priv *priv,
+				    struct mlx5e_tc_flow *flow,
+				    struct net_device *out_dev,
+				    struct netlink_ext_ack *extack)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5_esw_flow_attr *attr = flow->esw_attr;
+	struct mlx5e_rep_priv *rep_priv;
+
+	/* Forwarding non encapsulated traffic between
+	 * uplink ports is allowed only if
+	 * termination_table_raw_traffic cap is set.
+	 *
+	 * Input vport was stored esw_attr->in_rep.
+	 * In LAG case, *priv* is the private data of
+	 * uplink which may be not the input vport.
+	 */
+	rep_priv = mlx5e_rep_to_rep_priv(attr->in_rep);
+
+	if (!(mlx5e_eswitch_uplink_rep(rep_priv->netdev) &&
+	      mlx5e_eswitch_uplink_rep(out_dev)))
+		return 0;
+
+	if (!MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev,
+					termination_table_raw_traffic)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "devices are both uplink, can't offload forwarding");
+			pr_err("devices %s %s are both uplink, can't offload forwarding\n",
+			       priv->netdev->name, out_dev->name);
+			return -EOPNOTSUPP;
+	} else if (out_dev != rep_priv->netdev) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "devices are not the same uplink, can't offload forwarding");
+		pr_err("devices %s %s are both uplink but not the same, can't offload forwarding\n",
+		       priv->netdev->name, out_dev->name);
+		return -EOPNOTSUPP;
+	}
+	return 0;
+}
+
 static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				struct flow_action *flow_action,
 				struct mlx5e_tc_flow *flow,
@@ -3738,7 +3778,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 				struct net_device *uplink_dev = mlx5_eswitch_uplink_get_proto_dev(esw, REP_ETH);
 				struct net_device *uplink_upper;
-				struct mlx5e_rep_priv *rep_priv;
 
 				if (is_duplicated_output_device(priv->netdev,
 								out_dev,
@@ -3774,21 +3813,9 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 						return err;
 				}
 
-				/* Don't allow forwarding between uplink.
-				 *
-				 * Input vport was stored esw_attr->in_rep.
-				 * In LAG case, *priv* is the private data of
-				 * uplink which may be not the input vport.
-				 */
-				rep_priv = mlx5e_rep_to_rep_priv(attr->in_rep);
-				if (mlx5e_eswitch_uplink_rep(rep_priv->netdev) &&
-				    mlx5e_eswitch_uplink_rep(out_dev)) {
-					NL_SET_ERR_MSG_MOD(extack,
-							   "devices are both uplink, can't offload forwarding");
-					pr_err("devices %s %s are both uplink, can't offload forwarding\n",
-					       priv->netdev->name, out_dev->name);
-					return -EOPNOTSUPP;
-				}
+				err = verify_uplink_forwarding(priv, flow, out_dev, extack);
+				if (err)
+					return err;
 
 				if (!mlx5e_is_valid_eswitch_fwd_dev(priv, out_dev)) {
 					NL_SET_ERR_MSG_MOD(extack,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 2bd920965bd3..cc55cee3b53c 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -416,7 +416,8 @@ struct mlx5_ifc_flow_table_prop_layout_bits {
 	u8         termination_table[0x1];
 	u8         reformat_and_fwd_to_table[0x1];
 	u8         reserved_at_1a[0x6];
-	u8         reserved_at_20[0x2];
+	u8         termination_table_raw_traffic[0x1];
+	u8         reserved_at_21[0x1];
 	u8         log_max_ft_size[0x6];
 	u8         log_max_modify_header_context[0x8];
 	u8         max_modify_header_actions[0x8];
-- 
2.24.1

