Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7906C18941C
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 03:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgCRCsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 22:48:08 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:20090
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726769AbgCRCsH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 22:48:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hj0ngTxph6ChGQSyhDzTiVqijt9jx4AkjrZXYWQ0JpHJ03lfjSxsFIU3vSwA+3Ew8ruhXhEs+hlmXodqOQl5iMnN7JFLI9ifMTN7te1MEqMJwX20Uycv38i+LOJZD5ml5oxwdLjF+zhOf3giqEBC8v4z+VmNcmLqs20xpyn7yNvSTszsyUol1bsVJtj6Dlhvv2R4HnR5S2+F3F7CLKSc/DLZiDtccQsfGUToEeitfxq8FmELuKYKBsI9EKzdm3JfqUY5/gbzd+/IkbO/FOL6gKm+l1vxNyC5/B2z0L/qsiIzV45gojzb7Svlmrp5qo9HqgehPklPV3GOX6pNBk179A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cyOgnNF/Y/m1VYp098ilQ1NSBHYS/JDqKStNnp7TZAk=;
 b=VSqsndqgVIzNhoXtVlhj9siEmJ7zT+kJ2P3Uy84+taNaRr5khqCZMwH/TPDJbX/Rns7MvYzJMQpKzEnYaB3r/Tx+qx+9X8Ii8yn2XwDN4XME8MpKJtazeDRFq7NZzjUr/894om+3GvJGXEVJFJSGSW9PkzOD6p9dRzTjLhAgTCj0B61RscjCEDqu3AjtHQqekbS19gX4XIDTJD78gGkhE7nOR/g7+5uxYlKSTID8ushq7XeSrabzgNeOp+7YX7EewVyRcNqcNTiH2CkWfVM3t80UH5GJduuJ9DDWcPAPgrB0DdLcTX7hSBpt5QVqDxDvsoSWB1D4LT7XHExnZNnm6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cyOgnNF/Y/m1VYp098ilQ1NSBHYS/JDqKStNnp7TZAk=;
 b=VX7v/jleIOl/8nlioCqhvfPAVzpTh3IwjAbToTnOWmGw284FFv46Wsq17A8hIJI0WpULVwwiuTIqqRZmUvtJrmamIcN5tDrjmHy1aIhpGvtH7/zOnGJHfZpqAjfAdsOhJgkOysPFmSfvf4bg1XqbEu53xiCbkfCReNpcOajPr6g=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4109.eurprd05.prod.outlook.com (10.171.182.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14; Wed, 18 Mar 2020 02:48:00 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 02:48:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/14] net/mlx5: E-Switch: Fix using fwd and modify when firmware doesn't support it
Date:   Tue, 17 Mar 2020 19:47:10 -0700
Message-Id: <20200318024722.26580-3-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR13CA0027.namprd13.prod.outlook.com (2603:10b6:a03:180::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.12 via Frontend Transport; Wed, 18 Mar 2020 02:47:59 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 16b117ab-fefc-4c1e-05eb-08d7cae6c5c5
X-MS-TrafficTypeDiagnostic: VI1PR05MB4109:|VI1PR05MB4109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB41097039E7FE606B7887DEC2BEF70@VI1PR05MB4109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(199004)(956004)(478600001)(2616005)(6486002)(2906002)(54906003)(5660300002)(52116002)(86362001)(81156014)(6506007)(81166006)(4326008)(107886003)(8676002)(8936002)(26005)(66946007)(186003)(16526019)(1076003)(6512007)(66556008)(6666004)(66476007)(36756003)(316002)(6916009)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4109;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ew1O3e5F02j9/kS+uOAj1V4XS0Mtr4Wmdc0dC8N3JYH+kWYIpL8nLAUYwKFoNiW5rFbySUyocWf1hUs/EQCIKOUxbau1a3vdTBVLofAGvgsvzuyXfiS5xKw6ad+/F4mIAC6TvuTavYduwWDntDIsrj8QIMCbLROfR49iXJjWJA/QZwxH/8VJ6vBcz8XVwGixM9VkQFMhjMoIZ8i/5IBsdOhW+etdf2meBT8hu+WmnLoxroc6CbaqafoNfRcHqhF6FgM55Q7Ys7LedkKqE+9d40IDC7kexY9fcdlX9mU/lRM7jS0xw+7gM7FA58ayG6VoTu6hdaSpkVFwmk/3F/58XTMDP6Kk8N3d7s8sBRbRwTGbdFMsRPMxHrZNy1fV3bil4Se4X7Lb4m0P05cDv3JfCckm1RfOsUoeXLViVpQiKl28Sk/0BBDHyFJ9epZekbSfXdxZMjdjqbIFga797/djK3zrZOqPWCeD5OHO6S1wc0+u/nHoZ6CQM9rBsEZFZYdlAqH8R5idqeKuaHKK480ak2gqRz54asYFUpkX4mWeV+Q=
X-MS-Exchange-AntiSpam-MessageData: 6DS7BJVYfvLGFksnkbkcm+SUSAGBC3zfG3jckTYG6dXBomaxyC663oXYmHHSX8GQ42IGuN+AgpM3xiuXoD/Ycqa5WvnNId7vk30K7wINvWxGJVJLHIMppJoyxpuoD/5ezxPDP3t5MucK116lL3K8iQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16b117ab-fefc-4c1e-05eb-08d7cae6c5c5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 02:48:00.7775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WjNMGNLkvu1NWc4qdjdoQSAOxlpfra0zEs6iQyUR0wut/xHaXBPjPmrS+9XXd3TVKmbKbUlfRNEypbse2hq4TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Currently, if firmware doesn't support fwd and modify, driver fails
initializing eswitch chains while entering switchdev mode.

Instead, on such cases, disable the chains and prio feature (as we can't
restore the chain on miss) and the usage of fwd and modify.

Fixes: 8f1e0b97cc70 ("net/mlx5: E-Switch, Mark miss packets with new chain id mapping")
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/eswitch_offloads_chains.c  | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
index 81421d4fb18d..e1d3dc31311a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_chains.c
@@ -23,6 +23,8 @@
 #define tc_end_fdb(esw) (esw_chains_priv(esw)->tc_end_fdb)
 #define fdb_ignore_flow_level_supported(esw) \
 	(MLX5_CAP_ESW_FLOWTABLE_FDB((esw)->dev, ignore_flow_level))
+#define fdb_modify_header_fwd_to_table_supported(esw) \
+	(MLX5_CAP_ESW_FLOWTABLE((esw)->dev, fdb_modify_header_fwd_to_table))
 
 /* Firmware currently has 4 pool of 4 sizes that it supports (ESW_POOLS),
  * and a virtual memory region of 16M (ESW_SIZE), this region is duplicated
@@ -107,7 +109,8 @@ bool mlx5_esw_chains_prios_supported(struct mlx5_eswitch *esw)
 
 bool mlx5_esw_chains_backwards_supported(struct mlx5_eswitch *esw)
 {
-	return fdb_ignore_flow_level_supported(esw);
+	return mlx5_esw_chains_prios_supported(esw) &&
+	       fdb_ignore_flow_level_supported(esw);
 }
 
 u32 mlx5_esw_chains_get_chain_range(struct mlx5_eswitch *esw)
@@ -419,7 +422,8 @@ mlx5_esw_chains_add_miss_rule(struct fdb_chain *fdb_chain,
 	dest.type  = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest.ft = next_fdb;
 
-	if (fdb_chain->chain != mlx5_esw_chains_get_ft_chain(esw)) {
+	if (fdb_chain->chain != mlx5_esw_chains_get_ft_chain(esw) &&
+	    fdb_modify_header_fwd_to_table_supported(esw)) {
 		act.modify_hdr = fdb_chain->miss_modify_hdr;
 		act.action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 	}
@@ -779,6 +783,13 @@ mlx5_esw_chains_init(struct mlx5_eswitch *esw)
 	    esw->offloads.encap != DEVLINK_ESWITCH_ENCAP_MODE_NONE) {
 		esw->fdb_table.flags &= ~ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED;
 		esw_warn(dev, "Tc chains and priorities offload aren't supported, update firmware if needed\n");
+	} else if (!fdb_modify_header_fwd_to_table_supported(esw)) {
+		/* Disabled when ttl workaround is needed, e.g
+		 * when ESWITCH_IPV4_TTL_MODIFY_ENABLE = true in mlxconfig
+		 */
+		esw_warn(dev,
+			 "Tc chains and priorities offload aren't supported, check firmware version, or mlxconfig settings\n");
+		esw->fdb_table.flags &= ~ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED;
 	} else {
 		esw->fdb_table.flags |= ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED;
 		esw_info(dev, "Supported tc offload range - chains: %u, prios: %u\n",
-- 
2.24.1

