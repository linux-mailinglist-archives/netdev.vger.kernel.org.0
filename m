Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3648C17EE1A
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgCJBnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:43:25 -0400
Received: from mail-vi1eur05on2057.outbound.protection.outlook.com ([40.107.21.57]:6098
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726284AbgCJBnY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 21:43:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZUea8poMjXn076K8R41RmO8x5k8sUhsKcI2atbQpGwczb1IJmae0kIUlGpGsOkFFfJz1FuyoWfEf4ewQwgV+U3H8Y7/ZM+YLKA1CzeRPlC9BYzZpDqC5vFJ+7Z0Ug+++oT2X+/+BBQq2IQHi2Jjf8dDlP6nqsaq8XCXAoMSzpECPpFt0K/w7YboVDTfiBPmn1I9si0MAt95ppLp/WWkohg3Y/lRJTpMBQEY6w9fEP01FfCit9JJeRmpGs9c0BLEtX0qnTnGADMpotg8sYzzL6SUIXdANC0A0iNfo4dbQMRsFrmoqgD7UvgPZDehK8M2IV5P9/JYQKrdav7Nco5oIvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XUV4PprUL4yPW7PHHQYhQYYtRhD1D4ijQ5ftHFPSk74=;
 b=FvTcKh6OJ6o2CzMuEPhASK22O7sB0zhJ/a7Fxf6LkJ3FnaYsW1KOAOHfM2Up9NHd5OPkSCpri9Ew5p9ffEPKEH7Z20sTWVA8TJFcaS4w1OWC3WTrvl2ktnllxw/4jd+fiCnOBdSpueUg230eXnFij6omMqNuoHvY9CtPFFFI94ku5vdTl7s4WXVfmO+fzdmZEqJ//BnfjbJKffSBN+mwCZZ4snfbaLM0hFotM1sndwkNGUtQT/J24ay/CF22v1HWvrbnzZvXIodFvOA2FU8EXZQBnZxUbZM6BtBRjtnHoH33DZRzhFhHsffUjtIEwSUu8ZDKHjSLezgYwQZ752tBbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XUV4PprUL4yPW7PHHQYhQYYtRhD1D4ijQ5ftHFPSk74=;
 b=JrNEtuUBFwD6SUAN9nPuIxfjGoc7qYgZaCrdYt/l3A40TresRO/IAglK06WVrunfeHESsGnICzq/hI08M3gYx9ZzTf/L4QN3b983e7lpeB4pjEBGeORAHRcZZEZLezHQfQQ0ANkTXTup2874n0BbLX3Ua/51d6i1MtPSfCXLBt4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5533.eurprd05.prod.outlook.com (20.177.201.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Tue, 10 Mar 2020 01:43:12 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 01:43:12 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eli Cohen <eli@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/11] net/mlx5: Verify goto chain offload support
Date:   Mon,  9 Mar 2020 18:42:39 -0700
Message-Id: <20200310014246.30830-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310014246.30830-1-saeedm@mellanox.com>
References: <20200310014246.30830-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0068.namprd08.prod.outlook.com
 (2603:10b6:a03:117::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0068.namprd08.prod.outlook.com (2603:10b6:a03:117::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Tue, 10 Mar 2020 01:43:10 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f7db22ee-e277-4947-2d0e-08d7c49464b5
X-MS-TrafficTypeDiagnostic: VI1PR05MB5533:|VI1PR05MB5533:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5533751CECCBE1BB97207A02BEFF0@VI1PR05MB5533.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(199004)(189003)(66476007)(16526019)(316002)(1076003)(66946007)(66556008)(8676002)(86362001)(6506007)(478600001)(107886003)(5660300002)(81166006)(81156014)(6486002)(956004)(15650500001)(36756003)(2906002)(6512007)(4326008)(54906003)(8936002)(26005)(2616005)(52116002)(6666004)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5533;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0uoMoEnFH2tT5YTvr1y68FmVjUBfFK4twTfdYSq29ht74yiP212Fzu7FTeIQTDLicOgfGcRnM+hGc1ncAG6VHzfmAnE4oZ7JvtMJEauOMhKNAi2C98QIy6Qhe1808B2Zjhh+PBybg2J8Jhbc9uuRA4E8dChDnt4bSzybAbYGt/dYv1EZokhwsLBnWJiMUCfru1dQDGq/nKLx6qq1uSx4IvCaH5rLApeMLu4fStwfIzErXMty0IzDxwsHUJ3K2+BQrbCq6J+pKPeqmat/XPAXCN5O5VWT9Jnamr8cZ+h9ITknuc8y0YG1WrhqWsr6TjHm8ZQvSqac6kEO91SGxYZiPmjjz4ZmSfYGJSG5c4vGCMG6vej3XJ4nd/PSXhx7kNJOm9asXcW6UsSzr+RCKWqhHkgw699trJUfL39jJTmYt706sCY0qViN6WMtky25Gjy+j6edIIKI2d93CuWoJ/pn2gCStvHfp+p45klBZLiFy7y/QiaNygKXAbNEGn+qIKVkxCAe0Uahly2pfGlSeIIjKfLcMNajWdCaySbqNsKrWzs=
X-MS-Exchange-AntiSpam-MessageData: xdTrUzm7BCFb6rXa+X4gBmARkyeyUQTYFkHR3LN79qyYfAjkg5akMn+gwNkcLZPoem+mPKmfalcloSFPHKUAxyDRRRrWyydp4CHieS43CtKRif9sk5UdbMypYe6aupTy5moSTEtYd4huLzCsikq7dA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7db22ee-e277-4947-2d0e-08d7c49464b5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 01:43:12.1762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CkuB6nlWgUbzBlLWMrp/tzRQstmjFoB8d2/lLiP/i1NKn3sNmCkCqcLFmw2eFD29tHtURxFTQxSxc7kcs5Yt5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5533
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

According to PRM, forward to flow table along with either packet
reformat or decap is supported only if reformat_and_fwd_to_table
capability is set for the flow table.

Add dependency on the capability and pack all the conditions for "goto
chain" in a single function.

Fix language in error message in case of not supporting forward to a
lower numbered flow table.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 65 +++++++++++++------
 1 file changed, 45 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index cdc63dd59867..33d3e70418fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3313,6 +3313,45 @@ static bool is_duplicated_output_device(struct net_device *dev,
 	return false;
 }
 
+static int mlx5_validate_goto_chain(struct mlx5_eswitch *esw,
+				    struct mlx5e_tc_flow *flow,
+				    const struct flow_action_entry *act,
+				    u32 actions,
+				    struct netlink_ext_ack *extack)
+{
+	u32 max_chain = mlx5_esw_chains_get_chain_range(esw);
+	struct mlx5_esw_flow_attr *attr = flow->esw_attr;
+	bool ft_flow = mlx5e_is_ft_flow(flow);
+	u32 dest_chain = act->chain_index;
+
+	if (ft_flow) {
+		NL_SET_ERR_MSG_MOD(extack, "Goto action is not supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (!mlx5_esw_chains_backwards_supported(esw) &&
+	    dest_chain <= attr->chain) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Goto lower numbered chain isn't supported");
+		return -EOPNOTSUPP;
+	}
+	if (dest_chain > max_chain) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Requested destination chain is out of supported range");
+		return -EOPNOTSUPP;
+	}
+
+	if (actions & (MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT |
+		       MLX5_FLOW_CONTEXT_ACTION_DECAP) &&
+	    !MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, reformat_and_fwd_to_table)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Goto chain is not allowed if action has reformat or decap");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				struct flow_action *flow_action,
 				struct mlx5e_tc_flow *flow,
@@ -3534,29 +3573,15 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		case FLOW_ACTION_TUNNEL_DECAP:
 			action |= MLX5_FLOW_CONTEXT_ACTION_DECAP;
 			break;
-		case FLOW_ACTION_GOTO: {
-			u32 dest_chain = act->chain_index;
-			u32 max_chain = mlx5_esw_chains_get_chain_range(esw);
+		case FLOW_ACTION_GOTO:
+			err = mlx5_validate_goto_chain(esw, flow, act, action,
+						       extack);
+			if (err)
+				return err;
 
-			if (ft_flow) {
-				NL_SET_ERR_MSG_MOD(extack, "Goto action is not supported");
-				return -EOPNOTSUPP;
-			}
-			if (!mlx5_esw_chains_backwards_supported(esw) &&
-			    dest_chain <= attr->chain) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "Goto earlier chain isn't supported");
-				return -EOPNOTSUPP;
-			}
-			if (dest_chain > max_chain) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "Requested destination chain is out of supported range");
-				return -EOPNOTSUPP;
-			}
 			action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
-			attr->dest_chain = dest_chain;
+			attr->dest_chain = act->chain_index;
 			break;
-			}
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "The offload action is not supported");
 			return -EOPNOTSUPP;
-- 
2.24.1

