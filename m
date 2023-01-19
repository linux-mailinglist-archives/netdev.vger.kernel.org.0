Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0353D673590
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 11:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbjASKdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 05:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjASKdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 05:33:25 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD46346A2
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 02:33:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nmzg2PEd7cwnTyF+FWcUH99C2OHdI9K2vNXhlTL3eSPrXmr1kVYoqvBw1fl9d6XU0i1osMQsgNBT5ldsZ9N7KgLaP6MRNiAxkSX+wqtNLbaQdHh0d1DFxXlNirG+ZFo+R/bfSRUpFGu/BZanFVUKAMiwS6oc5BH+7SWp/0i2OpdBlityfZ6yMfVCS5xN7dDkv3rykp94yYkG22K3FbfdF1eQ2FJ8LeyXlxc8lzLNCM4tGUfvwr0kX9cHEoRYQtQte7nDfEzBzP41sDm6QiCWviEnXL0oCUCs19FKxBdC9lQaN25NZCy/av5CiZaHo1PzT0f6BpaBx82l/C9M03tevw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QZu6vq4vbageQwMLDYV1MxpV4kbH4J0cvCBdOvXqpSU=;
 b=WzqPOYC+GxntwWTTkNKOcxhWTdk17ixMfILwTA0Pux8J9qsTDQpUAhM14+0fVEiwc/RfgjUR6lz9Nwf69Jjpe/v7M8BwCk04ZrQOmBvxHSekvTYng2YQHrsKZ5XAvgIZCkBNE+/kXGEs3iu112OoVYr94hPt6D5mPz7ZrEcncAYV3j8Zxkd7k29Rb8HNiyNkisDTxkQlrffHbEze9N61w1e93Q3VV3K/63px3DSIu/M8eg1V9g3jkN70FOAN0F2dTuXb5EhqJ4SbGz0Nh5dzPXDy3Xv2ew+aWesovXjxZj9aXzOyUg6StBs3a40ywoP+EXhSMuyKwSd1G42trIggTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QZu6vq4vbageQwMLDYV1MxpV4kbH4J0cvCBdOvXqpSU=;
 b=HtmrR6Hd3Bj0r6/AqCrzC0iDUMEQzzsQlgDxgW1xx00a57/BCIOzF2L3osP3ulXd2/UXisZk8E75vY0IYQ0VgJjvq67kuppLAD5r5//D3LA22/0iVQHg6kmoOVsJaDuUFVlb4Q+0YpkAGbFLDlmzxVwEx4iXPxX3HoUfgqY0f2nX+4fW32O4cO7Jk9T5yCMCNYfgZmoHkdaHGasiES4sABBRxIzUsdM6isvxAW2Bkc8S8y0bhnAuTAdC7oGhpZF8V0wZIDmzZ3YC9a+bMa7Ia0SwDdvrG4C5jpopDF6FIFP/HYZo4k5s9O19nrZrvBqJTgyAOWhSmgudCI21wsMmHw==
Received: from MW4PR04CA0033.namprd04.prod.outlook.com (2603:10b6:303:6a::8)
 by IA0PR12MB7556.namprd12.prod.outlook.com (2603:10b6:208:43c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Thu, 19 Jan
 2023 10:33:19 +0000
Received: from CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::12) by MW4PR04CA0033.outlook.office365.com
 (2603:10b6:303:6a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25 via Frontend
 Transport; Thu, 19 Jan 2023 10:33:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT006.mail.protection.outlook.com (10.13.174.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Thu, 19 Jan 2023 10:33:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 02:33:07 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 19 Jan 2023 02:33:04 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 3/6] mlxsw: core: Do not worry about changing 'enable_string_tlv' while sending EMADs
Date:   Thu, 19 Jan 2023 11:32:29 +0100
Message-ID: <899a25e70a744053690f1f7a280e6836ce06797d.1674123673.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1674123673.git.petrm@nvidia.com>
References: <cover.1674123673.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT006:EE_|IA0PR12MB7556:EE_
X-MS-Office365-Filtering-Correlation-Id: b6844d7b-6bf3-41e3-2a45-08dafa0894ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oZpGxA1rLOS+NpKSFAeLgWRfLUT+PulfzB7iYWcA/9/xtMbnH38BFEwRzmhX2uDGFuVbUaLYX3GJxRU9PKJb2T2RdFG2rOeAyvJh8ekT2bt4F+60+bwiSN/xdgpmA3+AtoNu34F0IV7VA1yc2xFfJstre61gxXb7FXrt+Vx2RC4dCXxAvhLsFnvJskio7dUW6ZlTQMnlugGv+7uZQKbVzcvfO07uG9q1e0EozcNIH3+ikj/dYOOZmJNLhlqMOASelcsbcNrivKYAWqWu/zPvabU56NdvWEMAv8HNY2hIDPQTu5JvlSkOXzOnJVPRqAAnZ9ajFuG6kpcO10ssRKZ8Zzfz/X9y3/Q9GLg/VGJpeKHp6eijnMd6IjnEOd+4EoUNa89FMSV48Uho0D4cPPjRQ8oaGsmLlUMgRHJB5DB0H8RyXt2imtzh68FJFK/mKwgM2K4RfJXVd4xwHHf/jr5BqP1uoA3qQLmvYprkIItgTDs9fQPzYomCxXgBmBgfqTZcC2XCagUq2OT8yyD6TESCtTGTZxaye2tPzpzmGNBG6fOV9AkqdYv0si5cXC+yvMfbRMWo5osi4VjQioZjrNpARHtPOY/8Xx/9Zq6ziI7+TkhCTRiFgUfhdc56WkQDVdGKot7citIt6uF1bFQ3HFwb/jbhkWOVuQvKmekNb645zlttgBs2y61KBUB+2DNDTwZ/HLqhUo1fd/hpPI9DXhrhmA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(346002)(396003)(376002)(451199015)(36840700001)(46966006)(40470700004)(107886003)(40460700003)(86362001)(6666004)(478600001)(36756003)(7696005)(8936002)(5660300002)(316002)(82740400003)(40480700001)(70206006)(4326008)(8676002)(70586007)(41300700001)(36860700001)(186003)(82310400005)(356005)(26005)(16526019)(2616005)(2906002)(7636003)(83380400001)(54906003)(47076005)(110136005)(426003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 10:33:18.5842
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6844d7b-6bf3-41e3-2a45-08dafa0894ad
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7556
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Till now, the field 'mlxsw_core->emad.enable_string_tlv' is set as part
of mlxsw_sp_init(), this means that it can be changed during
emad_reg_access(). To avoid such change, this field is read once in
emad_reg_access() and the value is used all the way.

The previous patch sets this value according to MGIR output, as part of
mlxsw_emad_init(), so now it cannot be changed while sending EMADs.

Do not save 'enable_string_tlv' and do not pass it to functions, just pass
'struct mlxsw_core' and use the value directly from it.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 23 ++++++++--------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index cb3715f1582b..36ef9ac12296 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -476,11 +476,11 @@ static int mlxsw_emad_construct_eth_hdr(struct sk_buff *skb)
 	return 0;
 }
 
-static void mlxsw_emad_construct(struct sk_buff *skb,
+static void mlxsw_emad_construct(const struct mlxsw_core *mlxsw_core,
+				 struct sk_buff *skb,
 				 const struct mlxsw_reg_info *reg,
 				 char *payload,
-				 enum mlxsw_core_reg_access_type type,
-				 u64 tid, bool enable_string_tlv)
+				 enum mlxsw_core_reg_access_type type, u64 tid)
 {
 	char *buf;
 
@@ -490,7 +490,7 @@ static void mlxsw_emad_construct(struct sk_buff *skb,
 	buf = skb_push(skb, reg->len + sizeof(u32));
 	mlxsw_emad_pack_reg_tlv(buf, reg, payload);
 
-	if (enable_string_tlv) {
+	if (mlxsw_core->emad.enable_string_tlv) {
 		buf = skb_push(skb, MLXSW_EMAD_STRING_TLV_LEN * sizeof(u32));
 		mlxsw_emad_pack_string_tlv(buf);
 	}
@@ -876,7 +876,7 @@ static void mlxsw_emad_fini(struct mlxsw_core *mlxsw_core)
 }
 
 static struct sk_buff *mlxsw_emad_alloc(const struct mlxsw_core *mlxsw_core,
-					u16 reg_len, bool enable_string_tlv)
+					u16 reg_len)
 {
 	struct sk_buff *skb;
 	u16 emad_len;
@@ -884,7 +884,7 @@ static struct sk_buff *mlxsw_emad_alloc(const struct mlxsw_core *mlxsw_core,
 	emad_len = (reg_len + sizeof(u32) + MLXSW_EMAD_ETH_HDR_LEN +
 		    (MLXSW_EMAD_OP_TLV_LEN + MLXSW_EMAD_END_TLV_LEN) *
 		    sizeof(u32) + mlxsw_core->driver->txhdr_len);
-	if (enable_string_tlv)
+	if (mlxsw_core->emad.enable_string_tlv)
 		emad_len += MLXSW_EMAD_STRING_TLV_LEN * sizeof(u32);
 	if (emad_len > MLXSW_EMAD_MAX_FRAME_LEN)
 		return NULL;
@@ -907,7 +907,6 @@ static int mlxsw_emad_reg_access(struct mlxsw_core *mlxsw_core,
 				 mlxsw_reg_trans_cb_t *cb,
 				 unsigned long cb_priv, u64 tid)
 {
-	bool enable_string_tlv;
 	struct sk_buff *skb;
 	int err;
 
@@ -915,12 +914,7 @@ static int mlxsw_emad_reg_access(struct mlxsw_core *mlxsw_core,
 		tid, reg->id, mlxsw_reg_id_str(reg->id),
 		mlxsw_core_reg_access_type_str(type));
 
-	/* Since this can be changed during emad_reg_access, read it once and
-	 * use the value all the way.
-	 */
-	enable_string_tlv = mlxsw_core->emad.enable_string_tlv;
-
-	skb = mlxsw_emad_alloc(mlxsw_core, reg->len, enable_string_tlv);
+	skb = mlxsw_emad_alloc(mlxsw_core, reg->len);
 	if (!skb)
 		return -ENOMEM;
 
@@ -937,8 +931,7 @@ static int mlxsw_emad_reg_access(struct mlxsw_core *mlxsw_core,
 	trans->reg = reg;
 	trans->type = type;
 
-	mlxsw_emad_construct(skb, reg, payload, type, trans->tid,
-			     enable_string_tlv);
+	mlxsw_emad_construct(mlxsw_core, skb, reg, payload, type, trans->tid);
 	mlxsw_core->driver->txhdr_construct(skb, &trans->tx_info);
 
 	spin_lock_bh(&mlxsw_core->emad.trans_list_lock);
-- 
2.39.0

