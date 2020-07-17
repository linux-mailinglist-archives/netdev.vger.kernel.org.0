Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4239222FA5
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 02:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgGQAEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 20:04:54 -0400
Received: from mail-eopbgr80071.outbound.protection.outlook.com ([40.107.8.71]:33630
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725958AbgGQAEw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 20:04:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UODyon+CXFxCCcUzeutgtuZMji/ZMIYmxKEgOOeGic63utfRn5vc0s1vGVs1KjDRHECQRHfRilKMYS75ZXvy2e8feV07TvWOBYeLahLK68FMRMOiIKAIfwZznVTPeFYl4e4ZdRlJRuPrgKXICgkKgDiX6TaV5ZtGzT23uPPjwR0FX9/jpyoOhvQ623Gq005sM9o4MZJVclVkwsxmY9HI+u+RXT/dGBSULfazITuLVOKxcJm7Ivo0iXzXoRqNssFT+c2fBAeG2s5q2gGQTWUCCHHNDmSfq7vF2NkkxY4R0BQ/2rOk05GJK4Vlj4zrP+WctXVapIQb6thwnrKkUbejSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCRR7XF87RQ+LPjlTyB5I0hbVpFB8TvaO8mUv1M3c/M=;
 b=erFnxPl5Ey9yoAgwnq4APEHzobjl1fqBTl8ptnYnpk7hJGiTpbgj/fdMdJtVYNaS+TooEl8Ss4Q3lwQya6cqnqxCLVIFClSQ0QBwS2zcwaEftJNejI4kif+/jQO8XoNaAHNbsKQpwOOxxpjRXn4+mOOP01uB7j3MMVHkSQTKzDfRUKbufWxITlHr4P8OQNFPa2/2K67VlUlID8H56+59iBZGMJxJaTRLaFe8tpR5rG91JxO3XU/7C4qkEj7Tx1OkzDyNSyL+JwZqrI5DMwTuhg4abj/NQARSYa/sWDqr7lzqPIWo0x9MUSEYzSvoYjBIkgEn6Qkzx8nKfmVZza4cSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCRR7XF87RQ+LPjlTyB5I0hbVpFB8TvaO8mUv1M3c/M=;
 b=f0iIe5AHHaDwJ03VvGS4ddbz73zhmcwby2E83OXf5AGwD5fvW9pYHGjwfnINBfSWd1f94MAMkgMbdMx8YLPxRFIj+wjjk+NYS+iR35neYFvH8s8WgG/kAlRSp0ZLy4xtH8gF2gJwvCFX3rsO6Ct3NPn0p8RBorBjjlyGvxJphrA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2448.eurprd05.prod.outlook.com (2603:10a6:800:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Fri, 17 Jul
 2020 00:04:40 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Fri, 17 Jul 2020
 00:04:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 04/15] net/mlx5: E-switch, Avoid function change handler for non ECPF
Date:   Thu, 16 Jul 2020 17:03:59 -0700
Message-Id: <20200717000410.55600-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200717000410.55600-1-saeedm@mellanox.com>
References: <20200717000410.55600-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0008.namprd05.prod.outlook.com (2603:10b6:a03:c0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.9 via Frontend Transport; Fri, 17 Jul 2020 00:04:38 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 133c1351-84b5-44e3-01be-08d829e50006
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB2448665B53BC150449A4709BBE7C0@VI1PR0501MB2448.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1HSIB9f3OvP6Kg+ALAxRS0wOZGivelds29SVHKioRYkZOaFdxec0mWfWxPt+6CIZnhsOLquunsgj3QAJSoCs3N6OCNapMjkG4Lq/Hg5UY8V/qjCKQobgry6NCWlxlKJJi1asWgqLyvyZTbezryk8P9pR/fkMpFCr0CxAQle8aR2viisBfkrGBxhjPTsceFgxmSrKykU6HHuIuYUchTmE5cnDl8QNN1LnihgfGpxBkTG+WLx1vq94ZH6x104MNBQT7yt0Yhf8AiW8fO0pAFoPEi6xrh79QhfLRt3oHNJ2Vxjoey9e1lpTKSFXr0ph74jPod89Bq+6giYDkpNkkB7hnL7VMzv3Ny3Va+S8siaY4Smak/u8h5nq/ssnXRmHTnE3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(6506007)(66476007)(316002)(66946007)(66556008)(6512007)(107886003)(4326008)(2906002)(478600001)(86362001)(956004)(83380400001)(2616005)(36756003)(6666004)(52116002)(8676002)(26005)(5660300002)(16526019)(8936002)(1076003)(110136005)(6486002)(54906003)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ai1s6KXvLNFrltD6GHhYCQXZ7Pkn/3/+ZP+AF7+QFkn+OoUvrO+ZVAJ5mX7OTIfn1aWR1aKXYLYWgwJlEsEUSWY+L4THtnl1Elt/ooTdZyRHXSYXoiS1lWkk22oPfsNG0NbakTGOX/eOzuEtitcBsoPznb+M/rdaMR37laEWs4J74GH97AJfkR+COkVI9RBV2L3QVWrLn3XhtKCbeuOISC6UqX25+sVMHVL5BYD7FI2zwW6jeekOB/ejzYhmm8xuMQinc7EbzPaDMi+EmQgyLuKNSUL3YHskVOiv5VZwBuMqRph45uAiLJpGUY9rU2+3m+dnmGhDZkbujEpaT1DAj2596aIHKvxzHkih5ib3p3eIpMXJZP85xZ0g44gUTpprNZKvrvGC6r5pP9CdeKoAJMcx/6fwk9sXQlw/68raZ1jXVuQhv69mqXRmP9ZuEqQjyug3StVnK1JM0zY3tMQIOHgP0UGzFmeh0HtAaPnNPjo=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 133c1351-84b5-44e3-01be-08d829e50006
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2020 00:04:39.9807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1frpKOXKjmPuRI69glcFsxkrlb3gGi8NVEkLSgCdmqSZTOmgiOVfk/kTg3uziKkIC3FWdGF0Y6Fq1gB443H3qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2448
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

for non ECPF eswitch manager function, vports are already
enabled/disabled when eswitch is enabled/disabled respectively.
Simplify function change handler for such eswitch manager function.

Therefore, ECPF is the only one which remains PF/VF function change
handler.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 522cadc09149a..b68e02ad65e26 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -513,16 +513,9 @@ static inline u16 mlx5_eswitch_first_host_vport_num(struct mlx5_core_dev *dev)
 		MLX5_VPORT_PF : MLX5_VPORT_FIRST_VF;
 }
 
-static inline bool mlx5_eswitch_is_funcs_handler(struct mlx5_core_dev *dev)
+static inline bool mlx5_eswitch_is_funcs_handler(const struct mlx5_core_dev *dev)
 {
-	/* Ideally device should have the functions changed supported
-	 * capability regardless of it being ECPF or PF wherever such
-	 * event should be processed such as on eswitch manager device.
-	 * However, some ECPF based device might not have this capability
-	 * set. Hence OR for ECPF check to cover such device.
-	 */
-	return MLX5_CAP_ESW(dev, esw_functions_changed) ||
-	       mlx5_core_is_ecpf_esw_manager(dev);
+	return mlx5_core_is_ecpf_esw_manager(dev);
 }
 
 static inline int mlx5_eswitch_uplink_idx(struct mlx5_eswitch *esw)
-- 
2.26.2

