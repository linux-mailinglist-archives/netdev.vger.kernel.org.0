Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30EA717B226
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 00:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgCEXSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 18:18:03 -0500
Received: from mail-am6eur05on2074.outbound.protection.outlook.com ([40.107.22.74]:62017
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726243AbgCEXSC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 18:18:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gwESD2PUEzQ+e7rpKDD3S3v9WaoU9GzUqO27vUKCywGOezAQqQ/KYk3pB/n6VtLw8Gqbx2R3EF7V6eht5ehU7C324xa5yJSy93ce6/JJJlawd4Fh5jQoDU15WVTUcQHWBifYsLNGMeanggeUqH5+wjPwzVCwm1Lm+d4dpaDuyJOTOBWhIt/8du2nXijBmLCwwuGN2yD3fCrZ+OGAxgTreajrju09+/wIIkJBUNkU1O6EP/Fb6dUmKE+eX1/sKAbyTCSMiQNvLyoT0x9Ip1kqnmiXzzMLWSNHxIGCPC2MLPasyXKHdYfHebwBBnIxVr0rV2YYRo41yY45uS8sujRkrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylYehKm+3kBqophluCoOKpP0G9wkYY4T3eoi6KNHZmk=;
 b=fIz9gc8YSuyQvH0NwkQSdJhdDgQMJO8V9Ti/M8dVSMd6Cmz0yCqbXwklyvQsaQDeJHBn2NnwuUzayBt4pCl7pZ+18pf+tYcAiXYi5Z6XfIqstx8saThNFrAry+wK2ytoKaA61SYDlC0Xgc03mfMehUSwJIkjQ3UOUaXouoqRfQy8bC4qcaro6FWV2DlDZbgo0759EphEZVQaybVFqxhhSYxoMfmpyc7o02a6w5tk7ldvTpgxbAiuAc3Sz6s+3CRjZ8RLU9ep7EFtB5NDvQYlck8VZatOX9BRYMhYrgdMH6YxFrHlT8M+wxy1Qng4PZFgjNK51DsLuLSPIVnQbPoaSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ylYehKm+3kBqophluCoOKpP0G9wkYY4T3eoi6KNHZmk=;
 b=kAxliXVcD2O1DGLA7l0A84Jqxsv4gdlpQX46ecEt2MLAzw0YC9Qd/5R79YS0B9pceegk9y0vFZEETqNn3+eFSjwVI25m6MFxV9i8z62Qpa/l1Sa3zWOSFZA1+wMbKQjFUnBaEuz9Y61211wgNX1hTPJSWD56qpk0Q8GQHdzztyw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4189.eurprd05.prod.outlook.com (52.133.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.15; Thu, 5 Mar 2020 23:17:57 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 23:17:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Hamdan Igbaria <hamdani@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 1/5] net/mlx5: DR, Fix postsend actions write length
Date:   Thu,  5 Mar 2020 15:17:35 -0800
Message-Id: <20200305231739.227618-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305231739.227618-1-saeedm@mellanox.com>
References: <20200305231739.227618-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0042.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::19) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (209.116.155.178) by BYAPR06CA0042.namprd06.prod.outlook.com (2603:10b6:a03:14b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Thu, 5 Mar 2020 23:17:56 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 82c335f5-8772-4ec1-5f3f-08d7c15b70e0
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:|VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB41897D0BEBFF50F33D1E4AD8BEE20@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-Forefront-PRVS: 03333C607F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(189003)(199004)(2906002)(81166006)(6506007)(5660300002)(6512007)(4326008)(81156014)(6486002)(52116002)(8676002)(54906003)(36756003)(8936002)(66556008)(66476007)(66946007)(2616005)(316002)(1076003)(86362001)(6666004)(956004)(186003)(6916009)(26005)(16526019)(478600001)(107886003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4189;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7e3yMeX8TVjFyB2/Gb2NpLW0kFvbRRv8fLa7B18p+gcuIWL/rPYVI7DfUGKJCzpOX+0WvelAy2Bx1fcLl3eped79aKzev9T8BMLoZiOExQ0n6xZ4qqcJgJ1yV0LsTuEr0BZZXte7Ref7lloMkVI3DilmYMeRddb6hfrNVOKprt/rSeVJXV3FKGh0FHcKsQMOVyerSNOC4fzrr1cMFnBgEqXBHW4impKf2XXvAtzigDTFcI+6DcpPifMDRCXikglcHXVJ+Kfovt95w9nzB5i/g5ohZlLnOfOIMv9anYv/n7hDX8mAIz5o9qaMVjmOz9dRkDRjBzetzwQ0U2sAWh1WoUm8VaILQy0LzFDl6hmOAdFQHcMcnYU7bPF4e7Cf0+bq1qUZR6hzjkqbdRVmQ47JaiRyBVKFXVdgQR30YiafN+vwFf670fyKgM9xJAWDdR+yfWbHLvgWet2sZTq8BOZa2LhgkSn0aV8grfpTBWKpLTCHqfBcmtVFdMY0tO6Z4+mGqatZVrMQKnlEIPPesOLhpShkUGy41E2TQj35PpJD5bY=
X-MS-Exchange-AntiSpam-MessageData: B93wZ4/fVRps/A8o7LGmgBD2eVwYXDOuLP3l3Yo+wjrr1I4eqtKHnKq2X1ST+sGOQTPtQux/WeHDSigPhNUJDDqWQqZCv67UM98r9HXu33uwkAbO8MXfSwfpFlDawkk/d2X1eoJMUrCDUa7C4Jyk1w==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82c335f5-8772-4ec1-5f3f-08d7c15b70e0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2020 23:17:57.7411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F2k0HK6J2U2cJs6qr8dK2xO3bE9cPvgQWQ6VENBygz/KEr78hah/kPgXop7ldMJgeWBYB4/MAQyJj5UtQlsBWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hamdan Igbaria <hamdani@mellanox.com>

Fix the send info write length to be (actions x action) size in bytes.

Fixes: 297cccebdc5a ("net/mlx5: DR, Expose an internal API to issue RDMA operations")
Signed-off-by: Hamdan Igbaria <hamdani@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c   | 3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 6dec2a550a10..2d93228ff633 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -933,7 +933,6 @@ static int dr_actions_l2_rewrite(struct mlx5dr_domain *dmn,
 
 	action->rewrite.data = (void *)ops;
 	action->rewrite.num_of_actions = i;
-	action->rewrite.chunk->byte_size = i * sizeof(*ops);
 
 	ret = mlx5dr_send_postsend_action(dmn, action);
 	if (ret) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index c7f10d4f8f8d..095ec7b1399d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -558,7 +558,8 @@ int mlx5dr_send_postsend_action(struct mlx5dr_domain *dmn,
 	int ret;
 
 	send_info.write.addr = (uintptr_t)action->rewrite.data;
-	send_info.write.length = action->rewrite.chunk->byte_size;
+	send_info.write.length = action->rewrite.num_of_actions *
+				 DR_MODIFY_ACTION_SIZE;
 	send_info.write.lkey = 0;
 	send_info.remote_addr = action->rewrite.chunk->mr_addr;
 	send_info.rkey = action->rewrite.chunk->rkey;
-- 
2.24.1

