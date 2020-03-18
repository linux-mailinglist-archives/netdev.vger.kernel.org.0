Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A1818941F
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 03:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgCRCsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 22:48:17 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:20090
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726616AbgCRCsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 22:48:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YHr3Zoyytg/kLVkGJEX9wifUyMkxeX6FPs7zTW58gdPmtnbZfwu8h77UBNgMvoYMSWKcTq0JMKppu5jFXhjbjdbd3rv9MhxAkp7mKp8iofLNfDyNrO+2OvxElm0AkVKsIWt3vep6Ra7GxD6PTNo4f/P4pHvfJgPhsfyk+xBPoS7Y24sjqLfdYpLtuZMOYNOEr85Jlg+SQO2O9Gs+DY3+4ZvG5khhKcBmI1IZ3DXnoQKOjCv9jfJqyJdJ7gzK/1hl/FrmXjZmuQTo8YI28gn6XnPmBQ2aHuuqelEkXmKcd0aF4ivIAqawVMnmd3lovBZMgnN+dhIqPtGt9giayrECEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qqw0KKJxvcNaYuFzc0U4W8nYxKuS0nKmkUSzrThxC44=;
 b=XcC/MwpTj8y8Txv8qTq3IrrYPB+8qQzV/HAFvBfYhNR6jb3EiCfVHYhMS0ZNIn2EbKU5fBpa4pMh4lQ6+Jx59dsZdfS6iUWftoEcbVQHDwNTtnUw8JJQQoK85LY1KXJzj313e4OcZk9S/I9bSQxTJlXXfyTu1lx7mEI434jid/F6WAsh93sOR9xR8y1CGB+LFoixnxlkQq68UFka2lD70Nk+iWBN3917EwOOEPW+VpK5po6BX96EeEzyEV1w0ZvoJYvl3p/rFKlcPMfKYfwRsKKS158gtEAV1EfSt5w50aXfv3w4WRCwC+WmhXxVAPgmLKz32x1RzJSs5udrDywk8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qqw0KKJxvcNaYuFzc0U4W8nYxKuS0nKmkUSzrThxC44=;
 b=PQ2tI0cqboBDDq9bjE3cYasFXlTORmBd5j+e8gR6az/if5MOzyF3hM/8N7JQ4dfIHOFdlg7zUvMn+gp8xUhE1a93++eugjZee+6JkRpTiINDgTzJnnwWn1SUg0qbLzr3rIR30mMuprYZsuRiJhRjkXiNUOtkIzk7n1PeB4hQBtA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4109.eurprd05.prod.outlook.com (10.171.182.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14; Wed, 18 Mar 2020 02:48:07 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 02:48:07 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/14] net/mlx5e: CT: Fix insert rules when TC_CT config isn't enabled
Date:   Tue, 17 Mar 2020 19:47:13 -0700
Message-Id: <20200318024722.26580-6-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR13CA0027.namprd13.prod.outlook.com (2603:10b6:a03:180::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.12 via Frontend Transport; Wed, 18 Mar 2020 02:48:05 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 79c807b3-b4b8-4a5d-8f61-08d7cae6c9ec
X-MS-TrafficTypeDiagnostic: VI1PR05MB4109:|VI1PR05MB4109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4109271AEDCD5A3611D26108BEF70@VI1PR05MB4109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:513;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(199004)(956004)(478600001)(2616005)(6486002)(2906002)(54906003)(5660300002)(52116002)(86362001)(81156014)(6506007)(81166006)(4326008)(107886003)(8676002)(8936002)(26005)(66946007)(186003)(16526019)(1076003)(6512007)(66556008)(6666004)(66476007)(36756003)(316002)(6916009)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4109;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AXtci4dA1LPuLkDiB4HMM3Q4rADlpkFNRs8KtAX3jCJORd6RrgS0MUJSzeF27BNaqHA/tdq1M90GL1wuzgXJEeyWFwu9332ZIk6FdZFUs9UT7nMEL3Teoc9/VUKmW5YppAhsQ54lEQHiQVpUjr3qzhLvs6TKsZR/BkZny9KJUa8fsJwaoiiM0Bpk6KQ9cvECu8+JsYRHdBLqge1i5YJkYsoKmkHos3zhYVUpcFHfvH/2r6qwJFQTnLeTCyKVWh4wG2odYw3+ZPpbsC85tQVKwxRH7NDkowZGatiOaguNPBfaDMIYWXNeAEanG/diQFk6ReHNKnAcAGqVlZwPjKRl8C8USCgwl3jU4PEnIeplxgArpc0Sw+VaM9MWNo/VTGwnFdZ1IKWIH8r6wZoCLTcbKKTDsNdLq2QPouW+9IhQRTDcu5P+wNUaCAt1GnWzzemRx3YU8HpKsq6ohbllZ90/5ceDO9NnF6uZmXwtPMiquosvPjTrfu8kXHyB8xT+JDepHQVxOOjpDQtfWV6jKAVFgFad+e+mVM6uwQEl/YnHAqg=
X-MS-Exchange-AntiSpam-MessageData: uvy/Lze4iHQfcAThMzjCXEGa6Q+Pgha+6UYwlXDv1id/ECVIDSie53zhCb8ifWfsF9+GNiXtvGPTpDkzunwga7chsNVvgbUehkAxKGhVJ+wVBK1OI3pJIqqiCo8f7H0iqt1gzN20iIIpxCVbF2joDg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79c807b3-b4b8-4a5d-8f61-08d7cae6c9ec
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 02:48:07.7685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u3Xor1UaGAuNnbN1UkS1PwcOQN4oBfMOxdXrh1G90bTXizhlYB8QuuAkLGGSuV2YJPXZZ+jWInmerduBDPqqIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

If CONFIG_MLX5_TC_CT isn't enabled, all offloading of eswitch tc rules
fails on parsing ct match, even if there is no ct match.

Return success if there is no ct match, regardless of config.

Fixes: 4c3844d9e97e ("net/mlx5e: CT: Introduce connection tracking")
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 6b2c893372da..091d305b633e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -8,6 +8,8 @@
 #include <linux/mlx5/fs.h>
 #include <net/tc_act/tc_ct.h>
 
+#include "en.h"
+
 struct mlx5_esw_flow_attr;
 struct mlx5e_tc_mod_hdr_acts;
 struct mlx5_rep_uplink_priv;
@@ -128,6 +130,11 @@ mlx5_tc_ct_parse_match(struct mlx5e_priv *priv,
 		       struct flow_cls_offload *f,
 		       struct netlink_ext_ack *extack)
 {
+	if (!flow_rule_match_key(f->rule, FLOW_DISSECTOR_KEY_CT))
+		return 0;
+
+	NL_SET_ERR_MSG_MOD(extack, "mlx5 tc ct offload isn't enabled.");
+	netdev_warn(priv->netdev, "mlx5 tc ct offload isn't enabled.\n");
 	return -EOPNOTSUPP;
 }
 
@@ -137,6 +144,8 @@ mlx5_tc_ct_parse_action(struct mlx5e_priv *priv,
 			const struct flow_action_entry *act,
 			struct netlink_ext_ack *extack)
 {
+	NL_SET_ERR_MSG_MOD(extack, "mlx5 tc ct offload isn't enabled.");
+	netdev_warn(priv->netdev, "mlx5 tc ct offload isn't enabled.\n");
 	return -EOPNOTSUPP;
 }
 
-- 
2.24.1

