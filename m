Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0B3F189422
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 03:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgCRCs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 22:48:27 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:20090
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726895AbgCRCs0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 22:48:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IILajKKDMliQwQAWAD8QY2szbENfjlRgVIC73vpPmETjwVuogWwfICUdgs0X4t04iTwjQVIOTjHr2cz/R6YRyZ7jkEuFzc8twYhjJMke95CigH/xMG7YHe2GuG7SCtWhF5Br+UgIn6rUCiCwLRS4laJBST7ZZp4KHEkbDLo4RpxUHRwM2OJ+vkejplznS2YLxZPvsB8nJZbDNPGIdu3DLJQRYhq9fHICXXXar52SOZ7KOLGOvqAYKWihcY27tASgERb1aG05pUTH99fz6x/JJp0BYL+RQgf+zqIYn3GOeF8gNka/VZ0k/LHXZYh1ayevO2cl6tu4SEfbY/vJ/c5lHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BcDM39iTwNceVn6FzcyZtL7ycsWF6KdY/v4ETqid4Kk=;
 b=c3EXJN6ICWzeVVUMpowQKG+Ca8MqTJ6Xak3ePt1N9XQYIhu7IGUbX0TN0aEG8AtIPLMR/x4pPp0yVs7ZGVbCQNfTkrOuc77u+92IEzopgTcVZ1FJFoYF5hzT2WWyD0571SXK+3PltgwEUuZQnG6FAtxgUXqpHe1TtyuUm6xIZh4/ANuiuBtfgCYNlj/Yd0RfM12ouZ3f0RREIiWmD+eo+OmOMFTRDfx5jKAejTrsQzE5f5ZKdphgXWT0enytQCgDE6FeGP3KDmapzljE+eAxcTHBQbZ8lr91B3P7Kes/4Egcdlm/3ZYCG4Xo9VcUt044sBOQ87D6o6MN1xNjZZ3O5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BcDM39iTwNceVn6FzcyZtL7ycsWF6KdY/v4ETqid4Kk=;
 b=lgUpaYRIiqoCvk8cLZE8UoEoz6yn3SOrh+lCllnL7YxQJ4AHWBA1E1TxUZub/R9oUkhFMXk6xoim1HCKyaTGC3xkPXAr/fplv1hZTJgIy9/U/UFtjEG4PJszuXXQbdYNvd/8xsypfPzoEM3Q64o2AR1rScmaCNxpHh4iA+lqITw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4109.eurprd05.prod.outlook.com (10.171.182.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14; Wed, 18 Mar 2020 02:48:15 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 02:48:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Roi Dayan <roid@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/14] net/mlx5e: Fix rejecting all egress rules not on vlan
Date:   Tue, 17 Mar 2020 19:47:16 -0700
Message-Id: <20200318024722.26580-9-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR13CA0027.namprd13.prod.outlook.com (2603:10b6:a03:180::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.12 via Frontend Transport; Wed, 18 Mar 2020 02:48:13 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aa6c13a7-d6de-40af-57a8-08d7cae6ceaf
X-MS-TrafficTypeDiagnostic: VI1PR05MB4109:|VI1PR05MB4109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4109A87E4E9155A7429A0B68BEF70@VI1PR05MB4109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(199004)(956004)(478600001)(2616005)(6486002)(2906002)(54906003)(5660300002)(52116002)(86362001)(81156014)(6506007)(81166006)(4326008)(107886003)(8676002)(8936002)(26005)(66946007)(186003)(16526019)(1076003)(6512007)(66556008)(66476007)(36756003)(316002)(6916009)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4109;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mzo03a6rPT6rRE7+OxqNRm9auKUXQWlullcZ1zmK8SPrZUQL2kf0+ElrINCrXPSiq2X4zxt++KiSPF7er0Y12+XUyF+k3y6fLmxr7xayKdZBcA5cHYlcf042K1jqoCCk85AOqk4eowlfUSS8eykyEghBoRLfuym+0ni47a4Lbc6IaNTQjCilvb4p3+X/8QhpufY72SKWUSJyQsGaLTvJjvjTSyt0vuBNskkf0rE9P3mFRc/BPrE0UZC6llfU6BENhQkbMWOVKxabUOjJeqMaO5/o6xX8ZP1Pc8hEBKdSc1f7y+D0IH2f7qPf8Z7fR0O3Q4iPSBrO73hjMPn8MogXx2EMiHFVDH9JFkebSeyjdMdCuBWM/BxH9VvIceIr9qBkzfOdjbSF/fsQYXeDjva8DE2T6wcVaEcUZhmWbat7DrRv7fusXe7ZNmgNIYEKNGpgIEshRG76UXnEkzNeV9PsbjueH+a2JgHrOmyS3QTWnk8T4/Sv6cF1XISG5pkK6ikiAUSJm5UmRHgzgAEyYoTiEM2mS+oG3zU2SSNrSP/TiyI=
X-MS-Exchange-AntiSpam-MessageData: 4Z7Ih9ATBuR+MSAsvqCcsMRhqu/Zps6Wugj/dnR05waRSmp4dumKZgPb5qTzSMdCQeG3uN+iNmYowGhmKiPiOqiqzMYPKBT4sB7h7g7sSwqKmE6J7DyQEx8MmkgDPoqyz+6wIofnWcnIzFA9SGz8bg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa6c13a7-d6de-40af-57a8-08d7cae6ceaf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 02:48:15.8059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x2RBnuvyaob12kO8tLCyDpaVBMYAod8v8ahWsGBBdQdvQMCkGTSAPR0Q6CzbBs2fFhwySFDmgzYkB4pvLx/1wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

The original condition rejected all egress rules that
are not on tunnel device.
Also, the whole point of this egress reject was to disallow bad
rules because of egdev which doesn't exists today, so remove
this check entirely.

Fixes: 0a7fcb78cc21 ("net/mlx5e: Support inner header rewrite with goto action")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a2ff7df67b46..db1aee1d48e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3044,8 +3044,7 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 				    struct mlx5e_tc_flow *flow,
 				    struct netlink_ext_ack *extack)
 {
-	struct net_device *filter_dev = parse_attr->filter_dev;
-	bool drop_action, pop_action, ct_flow;
+	bool ct_flow;
 	u32 actions;
 
 	ct_flow = flow_flag_test(flow, CT);
@@ -3064,18 +3063,6 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 		actions = flow->nic_attr->action;
 	}
 
-	drop_action = actions & MLX5_FLOW_CONTEXT_ACTION_DROP;
-	pop_action = actions & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP;
-
-	if (flow_flag_test(flow, EGRESS) && !drop_action) {
-		/* We only support filters on tunnel device, or on vlan
-		 * devices if they have pop/drop action
-		 */
-		if (!mlx5e_get_tc_tun(filter_dev) ||
-		    (is_vlan_dev(filter_dev) && !pop_action))
-			return false;
-	}
-
 	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		return modify_header_match_supported(&parse_attr->spec,
 						     flow_action, actions,
-- 
2.24.1

