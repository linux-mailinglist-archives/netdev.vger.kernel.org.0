Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B991DF359
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387477AbgEVXxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:53:09 -0400
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:15428
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387437AbgEVXxG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 19:53:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kMbfqhrYX36BfJ6EDBw28yppw1JHNumVAcJNFLUYMgvLFzD8zP4Ei2qvJZez02GASZxZWYkm/Kj+9gOqtjNCuclY3pPsdcrwKzKlDPYN1gZTb91OQS6EEjDg9YaE7FRUZ0W2a3pE538M2J06N5uiPBY73aUheGUnq31n/m+ZBXy2RKpSr7T8Ff3eoaMuLYE3tN3UcKjkyvuGK1J5pMJpOXR7Xl59i956qVPqHG/ZiL1pPLMotqVTBqk7SXMge1UlqTLI1zvWenR/F6cyiDI7j07b8wlviDzeGIEP77niGPFhwOM9i/mmX1rShNCgx+0TjlFUncooZNKbTvuLkDyIRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kji4dcPHsJFf8F8l9aTkTg19/g3gqV77EGF1azlWASs=;
 b=fPahEuyeU/YDobb01eKnEyDRccO+58LZ4PKMp4oIHbkf9QuZyxUBfGuBKN++xivWnBieLy3Ro9bBTsqSllowqmNm5kb72rjFj7kHEJn9zuWF+iNlLmN9AO1qawPoWUpAadzhd3UUelyVfjRlwF3Pm6wve6r7nvOq4pIPNPsjKHNzVAsyZaoSPs8F40MXJCjmMeqoangUUmoywctLyIIS4wv3A7zaQUbzDH9F0e4xOZq0NaHlHZ2iJzMh7g96gJd5/cR3AT+3OP3pJZ1MxSb3RHg8xKnV8N7Z72J1/mj8MUTVtfjZvH1cg95QXNHMTR8o/3EF7fg/Q+15evY+JrGbQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kji4dcPHsJFf8F8l9aTkTg19/g3gqV77EGF1azlWASs=;
 b=rxU/J6gigkQG024XKFxSABVftDCYypUP8Ny4+46WJefJAgTnPkwUHyqBsblVzlpoEPFez7c271w/shomOviiMh+bqfQkkQY4YQ/ILacdtOVdipGt3T2Qyc82JZ47UAd3rv7ui3RD38rtn2Jc2bsJWev5C8F7/XaJYtZqX4BYwR4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4544.eurprd05.prod.outlook.com (2603:10a6:802:5e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Fri, 22 May
 2020 23:52:33 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Fri, 22 May 2020
 23:52:33 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eli Cohen <eli@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/10] net/mlx5e: Support pedit on mpls over UDP decap
Date:   Fri, 22 May 2020 16:51:48 -0700
Message-Id: <20200522235148.28987-11-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200522235148.28987-1-saeedm@mellanox.com>
References: <20200522235148.28987-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:a03:255::20) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR10CA0015.namprd10.prod.outlook.com (2603:10b6:a03:255::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Fri, 22 May 2020 23:52:30 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4a60aff0-ecb9-4023-9602-08d7feab3239
X-MS-TrafficTypeDiagnostic: VI1PR05MB4544:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB45446F3491A547AF94E869BDBEB40@VI1PR05MB4544.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 04111BAC64
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LJkzZqicPemCTF7PDM8USjQzdleKS/Z1XxWXbRUa21onR1TITfLIf9BKO84dZ6Mbc+8kTSW2osexmNJgLiQWuTenYmhNCH5CFPAk3Lc48iTKTt2IFmr5tAAOim6lYlE+mraNW+3rmgl9HdA2yxAYTod3qvi08MS+jYYsaqbXNorONhAX4NUPFUEtnOEKSamXuY7g9W7eqYQstaXCVXrmD3qwOtZG/hE4/yfGp1TAGla0ENVuZtJ0HAFATIPb1vrQMaTrck0NaPGf7ZmB0fHiUpoahUtttQvdPPOLi6FDqxsTYGrDggKzi/mct/mCHDbIf3b1s1AaBZRsfTthEHT4o7Od6zJTsWh8DQyXI/yd3oANX6st8Pu29B+qTJ5X2HMg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(66476007)(956004)(6506007)(66556008)(2616005)(66946007)(107886003)(6512007)(1076003)(16526019)(478600001)(186003)(52116002)(26005)(4326008)(6666004)(316002)(6486002)(86362001)(8676002)(54906003)(36756003)(8936002)(2906002)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2cPpY7j6sRLsxNo5x0i/l6+/tx0JYvjTZQ3p/DBYg0Cuz4YvPO8E1ZhKIdnQI849rwy5LABZxp9kQG5CiW9kMWMWhq9XpTM35nTjPtJwI1r6G6lZJMW3O4e15CTbN0NyeN3O7tRLnHnTthgKnjxvAckF4OGIf4UVjVEIup4zq28ANNBHw8PsQ7bx12c1c4g5GGJZ4PJDTMgHBzFb12Hx3zkFmGEoir7oe4jmKlXmHmsRbn4H7DNTXNiVQDMTzDjIowA15G77bECCsEx4GZSJpevO6O/WFDvzpHmD7wg9x+KfMxkfhHH1YZRPtmuiK3MmR8cdZnJM4iOFe/mnCqinnsk4Qml285hbqCsz1ZYjZMBeFR7CKnXaimbas56vIM7WRgU6eHri5M8EI0tIS+K6yOQzC7w2HaT2jw9N0xs0NDm/UQoyJWgkHjVvO3Tpg4iAxsZTsGMU3pij2HSKrpf4mfQeGyowB+Wat5hihgSSN7I=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a60aff0-ecb9-4023-9602-08d7feab3239
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2020 23:52:33.3421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cno584zKuAHnzM15gdOZ29dJ5EgkMOauvbrW07/FVXUXnU83XFpcf5xyrsS783VsuJ1cnxdC/ovFsUJdu/4ocA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4544
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Allow to modify ethernet headers while decapsulating mpls over UDP
packets. This is implemented using the same reformat object used for
decapsulation.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 65 +++++++++++++++----
 1 file changed, 53 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a6b18f0444e7..cc669ea450ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2900,10 +2900,12 @@ void dealloc_mod_hdr_actions(struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts)
 
 static const struct pedit_headers zero_masks = {};
 
-static int parse_tc_pedit_action(struct mlx5e_priv *priv,
-				 const struct flow_action_entry *act, int namespace,
-				 struct pedit_headers_action *hdrs,
-				 struct netlink_ext_ack *extack)
+static int
+parse_pedit_to_modify_hdr(struct mlx5e_priv *priv,
+			  const struct flow_action_entry *act, int namespace,
+			  struct mlx5e_tc_flow_parse_attr *parse_attr,
+			  struct pedit_headers_action *hdrs,
+			  struct netlink_ext_ack *extack)
 {
 	u8 cmd = (act->id == FLOW_ACTION_MANGLE) ? 0 : 1;
 	int err = -EOPNOTSUPP;
@@ -2939,6 +2941,46 @@ static int parse_tc_pedit_action(struct mlx5e_priv *priv,
 	return err;
 }
 
+static int
+parse_pedit_to_reformat(struct mlx5e_priv *priv,
+			const struct flow_action_entry *act,
+			struct mlx5e_tc_flow_parse_attr *parse_attr,
+			struct netlink_ext_ack *extack)
+{
+	u32 mask, val, offset;
+	u32 *p;
+
+	if (act->id != FLOW_ACTION_MANGLE)
+		return -EOPNOTSUPP;
+
+	if (act->mangle.htype != FLOW_ACT_MANGLE_HDR_TYPE_ETH) {
+		NL_SET_ERR_MSG_MOD(extack, "Only Ethernet modification is supported");
+		return -EOPNOTSUPP;
+	}
+
+	mask = ~act->mangle.mask;
+	val = act->mangle.val;
+	offset = act->mangle.offset;
+	p = (u32 *)&parse_attr->eth;
+	*(p + (offset >> 2)) |= (val & mask);
+
+	return 0;
+}
+
+static int parse_tc_pedit_action(struct mlx5e_priv *priv,
+				 const struct flow_action_entry *act, int namespace,
+				 struct mlx5e_tc_flow_parse_attr *parse_attr,
+				 struct pedit_headers_action *hdrs,
+				 struct mlx5e_tc_flow *flow,
+				 struct netlink_ext_ack *extack)
+{
+	if (flow && flow_flag_test(flow, L3_TO_L2_DECAP))
+		return parse_pedit_to_reformat(priv, act, parse_attr, extack);
+
+	return parse_pedit_to_modify_hdr(priv, act, namespace,
+					 parse_attr, hdrs, extack);
+}
+
 static int alloc_tc_pedit_action(struct mlx5e_priv *priv, int namespace,
 				 struct mlx5e_tc_flow_parse_attr *parse_attr,
 				 struct pedit_headers_action *hdrs,
@@ -3197,7 +3239,7 @@ static int add_vlan_rewrite_action(struct mlx5e_priv *priv, int namespace,
 		return -EOPNOTSUPP;
 	}
 
-	err = parse_tc_pedit_action(priv, &pedit_act, namespace, hdrs, NULL);
+	err = parse_tc_pedit_action(priv, &pedit_act, namespace, parse_attr, hdrs, NULL, extack);
 	*action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 
 	return err;
@@ -3263,7 +3305,7 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 		case FLOW_ACTION_MANGLE:
 		case FLOW_ACTION_ADD:
 			err = parse_tc_pedit_action(priv, act, MLX5_FLOW_NAMESPACE_KERNEL,
-						    hdrs, extack);
+						    parse_attr, hdrs, NULL, extack);
 			if (err)
 				return err;
 
@@ -3932,16 +3974,15 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			break;
 		case FLOW_ACTION_MANGLE:
 		case FLOW_ACTION_ADD:
-			if (flow_flag_test(flow, L3_TO_L2_DECAP))
-				return -EOPNOTSUPP;
-
 			err = parse_tc_pedit_action(priv, act, MLX5_FLOW_NAMESPACE_FDB,
-						    hdrs, extack);
+						    parse_attr, hdrs, flow, extack);
 			if (err)
 				return err;
 
-			action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-			attr->split_count = attr->out_count;
+			if (!flow_flag_test(flow, L3_TO_L2_DECAP)) {
+				action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+				attr->split_count = attr->out_count;
+			}
 			break;
 		case FLOW_ACTION_CSUM:
 			if (csum_offload_supported(priv, action,
-- 
2.25.4

