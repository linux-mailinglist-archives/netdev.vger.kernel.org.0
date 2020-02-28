Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E087E172DA4
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 01:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbgB1Apw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 19:45:52 -0500
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:20112
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730500AbgB1Apt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 19:45:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S9Oxgpdtf3uSra8aIMkCmxNcVzlH7bTLaKKTbyoFKPCrZCyXYF5CdAKJBzc5q62qqwbmG0/74ftp2Hj6fSEtou0353742+2PYVV4FDRZtGxqS5cxvMDdPYS8H4BRBxGnqdYeEf+X4JdjrfBnNbiCRu79fcemB/kFfPSZAUbWzV/427DXjdBVGL+9Su5ULpHiSEgDYzz9Jo8aSlW5RVLTud14gMSjrSYsENSXe7qP5Q2adhqRtTF4ugHtl7aAXnj8gOFBkUCkWfAJ44TI0VlbVcVPms7UqMTkhuXqjhWcc94uY/Rp8z5ME6t0SiMjr4OD1WABRMz5JS/efxVnvTnI9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SEiPL15mlButM58ENQBLMX4qWO8dRptR70WGBZYFHkI=;
 b=TM9DLt0wGurWt+beNF8ZRMsmaI/fd4cSl177Ft4/OnN3+S/nKZY+Z2M1LyUjkZFLQmpOHPTF4vIwnuW+sgCfKFTD+YUcnJorzYmGdYyxzEUQ8E3rrPDw9lhBSUIF4rqFt2quEfD93hczydbjbQCrUTCwQIO4d4Q8TCnB0G2eUALAklV5gn6wwPGk3yOx0apP+JcBJZI4bZqtpHpgkYQLFBE6FNlpbkQc6inuydMnX2RL4Cgst/QCp8hIpuc3wr1ZD/kmvUoT5cuX7Mb5jmATlr+7+IzkTFVaRvEO6txaUx75WTPfbmbUeHgJFHfYTDvoKYsLLkyhEK8y2oW2LbO22A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SEiPL15mlButM58ENQBLMX4qWO8dRptR70WGBZYFHkI=;
 b=NwG+qPHMA0MnJCR+kmfv8TOUgKMK6qXVf78cQEsu/1O8rto5O24FFncyZov4SDQyD+OOYh3HO+18lYZr46NCApknYEpHwc7dZSbsp6Ia7uY/n6MES/C025RJUw52ZdU/2LT7ingU51BSAgJwy+MPp/7o5EzGbncVCUaGU4Nhwd4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4189.eurprd05.prod.outlook.com (52.133.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Fri, 28 Feb 2020 00:45:38 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.024; Fri, 28 Feb 2020
 00:45:38 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Eli Cohen <eli@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 13/16] net/mlx5e: Use NL_SET_ERR_MSG_MOD() extack for errors
Date:   Thu, 27 Feb 2020 16:44:43 -0800
Message-Id: <20200228004446.159497-14-saeedm@mellanox.com>
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
Received: from smtp.office365.com (209.116.155.178) by BY5PR04CA0004.namprd04.prod.outlook.com (2603:10b6:a03:1d0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Fri, 28 Feb 2020 00:45:36 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5aae7cff-bc63-4228-8091-08d7bbe78747
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:|VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4189B337CA37D7E6DCD104EDBEE80@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 0327618309
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(199004)(189003)(66556008)(66946007)(66476007)(6506007)(316002)(4326008)(6512007)(107886003)(478600001)(52116002)(54906003)(6486002)(26005)(8676002)(6666004)(81166006)(86362001)(8936002)(16526019)(186003)(36756003)(81156014)(5660300002)(2616005)(956004)(2906002)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4189;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Q6ixL+SUwW7N2sm4V9rUDwaAGf24RWc1ZXSP0n6yX+jf/QGkXM5EszIu4xK6IirLGgwQ7xsfpmrPN7tu6zS+f6b5dSzn1AVa8MxApmccx9L+1GHE+Ed13XIFjbhaXrYhsO2CHaGIcKwP9O2Te59x7ezU3Qk+6fLyiismUkAmFJdvp9M8yLD3Yl1NQ4db48tXuIQTpX4rFjI3Yman521wdbn68gcA4TMfUYsVKkf5JxLWp7VHskOlmthTy/1H4mwPcxWrKwx0nJRWJTUGt8qJZNWnmjvF/jLW67JlhQavaVM2j1aC1O3X+hxbQ2lY0mhq1ljZswGNIDL/u2C9j8oZcgV+/L52VBrPjoTAGnhi+0xBP7MJZQY1E+UrDNA9dZEq05770qhtwPbUXY5hIqWiqD7UDpKkZr2lvYv5uN1fmdSaFBh03kjQfdGbsfyHs40L43FaFgTG7T9knCAloyGhPbf9aiXUMDmaJX8T77w89f42wWEPs9nZXkdyADGT4ZhO1NIlmqnCYK/wbKM0h+19OHBnDRFwSIJAOIXFkZBsho=
X-MS-Exchange-AntiSpam-MessageData: 9ejIUwpiQ7WSJLwGe0776QQef3MRvol79AtxmXMevCJ9e3+0JX1kpcDQCrTIfMdc/72cwviOIQ/bE7wrsRVc1fSDO8h07ywOeciZw6H8xL4TGYaiFkVjVVjGrQ/C4YQnesHsIaA7J9QaZ26vOJ+uUA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aae7cff-bc63-4228-8091-08d7bbe78747
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 00:45:38.2161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hRWLIhcyb6UPUWgiZsVxRcyfxEQ+68cLf9TXGvc5AswfclgdB7oIzm64dllCqH2UyIS1i/cPg5hLlsC/OUeVfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

This to be consistent and adds the module name to the error message.

Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Eli Cohen <eli@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 21 ++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 14b5a0607f67..1288d7fe67d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1173,7 +1173,8 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	int out_index;
 
 	if (!mlx5_esw_chains_prios_supported(esw) && attr->prio != 1) {
-		NL_SET_ERR_MSG(extack, "E-switch priorities unsupported, upgrade FW");
+		NL_SET_ERR_MSG_MOD(extack,
+				   "E-switch priorities unsupported, upgrade FW");
 		return -EOPNOTSUPP;
 	}
 
@@ -1184,13 +1185,15 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	 */
 	max_chain = mlx5_esw_chains_get_chain_range(esw);
 	if (!mlx5e_is_ft_flow(flow) && attr->chain > max_chain) {
-		NL_SET_ERR_MSG(extack, "Requested chain is out of supported range");
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Requested chain is out of supported range");
 		return -EOPNOTSUPP;
 	}
 
 	max_prio = mlx5_esw_chains_get_prio_range(esw);
 	if (attr->prio > max_prio) {
-		NL_SET_ERR_MSG(extack, "Requested priority is out of supported range");
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Requested priority is out of supported range");
 		return -EOPNOTSUPP;
 	}
 
@@ -3540,11 +3543,13 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			}
 			if (!mlx5_esw_chains_backwards_supported(esw) &&
 			    dest_chain <= attr->chain) {
-				NL_SET_ERR_MSG(extack, "Goto earlier chain isn't supported");
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Goto earlier chain isn't supported");
 				return -EOPNOTSUPP;
 			}
 			if (dest_chain > max_chain) {
-				NL_SET_ERR_MSG(extack, "Requested destination chain is out of supported range");
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Requested destination chain is out of supported range");
 				return -EOPNOTSUPP;
 			}
 			action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
@@ -3594,7 +3599,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 
 	if (attr->dest_chain) {
 		if (attr->action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
-			NL_SET_ERR_MSG(extack, "Mirroring goto chain rules isn't supported");
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Mirroring goto chain rules isn't supported");
 			return -EOPNOTSUPP;
 		}
 		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
@@ -3602,7 +3608,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 
 	if (!(attr->action &
 	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP))) {
-		NL_SET_ERR_MSG(extack, "Rule must have at least one forward/drop action");
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Rule must have at least one forward/drop action");
 		return -EOPNOTSUPP;
 	}
 
-- 
2.24.1

