Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11961DF39B
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 02:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387523AbgEWAlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 20:41:53 -0400
Received: from mail-eopbgr40071.outbound.protection.outlook.com ([40.107.4.71]:51206
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387463AbgEWAlw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 20:41:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTiiqDgzdwKIfPsw6fL6wUI4kJ7fkO8U7fZrHYlzsbYqVADYuS82aqgrVOG2k6cTpYRe/OVLlAlcEXvcjYykfv0o+5FAGFZwXy961so7X5zFQFhz3Rai8lF4MciFV/9HqXpr6PTFVFJXsIRRK+YIMR9mvMIEOVwI+coXR4pYPpASHJENp96jN6i/M1BYO37nsK4OWHMPKsS6ekPU8k4E/fZFrybRvW7bpYpSUa4JfP4a5m8xybinF3HHCasNhbj/Zsbt/mgVFPaQ2ki7ykGDoon7clQqxsnNOCgTlhuUcAjFkCLFz/PUg3vI68/nQPowS0yKpO4VpwnoyyUHGgN94g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HhBtJzEnAo2xU8X/jPL7D6Ch39OwtfNTd13jZYoaujs=;
 b=PNFxJfcDiq4l70+skcZJY5nEsnlWUKsvQfa7+ZobUHJikLmSP/XiBCMni3aV3hHIvwMPNCmAcPzlKmfXpPZk7hqD97UkNEVLeLRSjH5G034T1VIr3M5KEEeiSb3xx2JQ7xCs/c7FE3cM2TjZL7yXOyGChXthmbOQw/1bbji29/zIRwtRBtHrUWhVwkr47onsr5AoOJi5nDLe7Yr/Rs1j6Y2LXxBS88PTU7asNZwLBpr3EnPN0GCscNdq5vhynPiva9yfTvity46fcURxmKQG0XDeC2jPBr57lvWbGMxfd7iS2tX3GWpUd7Qk2E2Dq2VTcw1tw0nAf8cxYs1H73VuTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HhBtJzEnAo2xU8X/jPL7D6Ch39OwtfNTd13jZYoaujs=;
 b=D6zsKeRHVMLsVuEG0QnWEe0lguAeLm3fAjIiLWtoULVDNoe+SzeMReBQzYN7i2zbWVX7qA6gVElgvJWQGXm7SqVdh+Uup/YPPYqlAIbXhw2VkL8SDF9DtYqBmj1LFuWrM582aJbZ1FGF9Bfc45wWvo2SDy17IFbSDwsmmdBng9E=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5391.eurprd05.prod.outlook.com (2603:10a6:803:95::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24; Sat, 23 May
 2020 00:41:36 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Sat, 23 May 2020
 00:41:36 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 12/13] net/mlx5e: CT: Correctly get flow rule
Date:   Fri, 22 May 2020 17:40:48 -0700
Message-Id: <20200523004049.34832-13-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200523004049.34832-1-saeedm@mellanox.com>
References: <20200523004049.34832-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0042.namprd08.prod.outlook.com
 (2603:10b6:a03:117::19) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0042.namprd08.prod.outlook.com (2603:10b6:a03:117::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Sat, 23 May 2020 00:41:35 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 40062619-34b5-4e34-f5f0-08d7feb20c99
X-MS-TrafficTypeDiagnostic: VI1PR05MB5391:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB53918725EDAEC70CBB664E6FBEB50@VI1PR05MB5391.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-Forefront-PRVS: 0412A98A59
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gHri5PqzN/BYCMX78paZtwmfdgkX4eRS5LejuYbDZ7sYqhK+vbkrx8NIyFklxokP2hqelXkqKSQkU/lVkcfmJpLh5egWRznpAyFZaP85rVk6DwjFEvzV9KA49KlLx87Ad706Wt3cbGujC2CYbINqow3rAyc24G9RAX9I2POi6UknyOpsbK4OGNe7ysX4hRLa4OlIpNFoT1KGOEzOq2w8aDGAPA5UcDoQ3W3tPKCAneZqlvku3aLSs3XYuQJILYGdYdxcLvsq5+ujZMS1h5nxHs6rIUt73UKeCqjlhl73NL9YsU2oiH4HBvPYANm4W4s9k8J2ovXbgoKN+9+pXlg07s5EwdDzx2p/wOAbQdPgINpsMfA5gVO74wGzbJ5FLUPC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(1076003)(8676002)(2616005)(956004)(4326008)(52116002)(186003)(26005)(16526019)(478600001)(6666004)(86362001)(6506007)(6512007)(107886003)(36756003)(316002)(5660300002)(8936002)(6486002)(66946007)(54906003)(66476007)(2906002)(66556008)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: SQk2yitR2Ec0NFsSNYx62WYBAytQiSn2jhdomiedYIevv7IBF7XKzhVv5PCJd0faTZvQ79+P6Oazaz1V63jujVWVcNZ579EEQpYaEEJ3Z3AKRe0uoInqydrJ+N2GBKE4My7cMYxK9xnimITwvdKu++Gi+xq1XSlsWEDJnLxa2afRWN5j4ZVsqz7bpzq/NSV1BsQyWAoYZjhkV0mxX1kMVQAyY1JbZwMhjmtIsqF52qazX4JavIxzBsHTDoOlhK3PA5yxJWlY1Y8kWHZgU5ZkTN8Dj3THfIqxcb0rXGJzkqFqagNvmtq016WFgKgtRBQs/Bm7Vat36J98RmbENoqWVXhTFE3m1ZMt7yIhEXZk6v30+8bHasd3rjnD0geuBbarCkSwlYst7u/k1/Qsn1GooqDtYTo7BX+lYEA7oX5YMmInK8vzlgKnKc5wKz7/y/+Lo8bbVvMhP5pVKN0BHOnxXoStDeb0pn/rHN2La3aRhQc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40062619-34b5-4e34-f5f0-08d7feb20c99
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2020 00:41:36.7163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yzf3qTI3XrUYgivvh+6ZeTbbYQGRUg129ZPgKghYLl7Wp+v3sDnOMOuGpkx4ZTcdQSg25RZH3Z5JzDD4gpDMXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5391
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

The correct way is to us the flow_cls_offload_flow_rule() wrapper
instead of f->rule directly.

Fixes: 4c3844d9e97e ("net/mlx5e: CT: Introduce connection tracking")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 5 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h | 4 +++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index a172c5e39710..4eb305af0106 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -699,6 +699,7 @@ mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
 		       struct netlink_ext_ack *extack)
 {
 	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector_key_ct *mask, *key;
 	bool trk, est, untrk, unest, new;
 	u32 ctstate = 0, ctstate_mask = 0;
@@ -706,7 +707,7 @@ mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
 	u16 ct_state, ct_state_mask;
 	struct flow_match_ct match;
 
-	if (!flow_rule_match_key(f->rule, FLOW_DISSECTOR_KEY_CT))
+	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CT))
 		return 0;
 
 	if (!ct_priv) {
@@ -715,7 +716,7 @@ mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
-	flow_rule_match_ct(f->rule, &match);
+	flow_rule_match_ct(rule, &match);
 
 	key = match.key;
 	mask = match.mask;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 091d305b633e..626f6c04882e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -130,7 +130,9 @@ mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
 		       struct flow_cls_offload *f,
 		       struct netlink_ext_ack *extack)
 {
-	if (!flow_rule_match_key(f->rule, FLOW_DISSECTOR_KEY_CT))
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+
+	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CT))
 		return 0;
 
 	NL_SET_ERR_MSG_MOD(extack, "mlx5 tc ct offload isn't enabled.");
-- 
2.25.4

