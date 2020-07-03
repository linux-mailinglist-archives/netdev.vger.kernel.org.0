Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7962521329C
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 06:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgGCEJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 00:09:57 -0400
Received: from mail-eopbgr80059.outbound.protection.outlook.com ([40.107.8.59]:59118
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725960AbgGCEJ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 00:09:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mpIVOQrndIapachyj8ObCyLMduwAeiE+tHhhbB8HASL5KXl+oj4uJI71rcMnPJLfQhdBLwyeguhyqeJRWJzhvea4VFk0Rh1lCIOasGbX0G2pU7haBoWieUG91dSbbrL/iSWmKaStLvRcnY8cHU3FyVtQ/OlZvyjW92kY1S/2P59xqLRqnYKjqxrVyhHXEV5WUUiEyrNe8IKwyLiTrWRhOCDcwn6KAjZqxLgSAG3spWje5SI+wmZGWRN1GBq2jW9HqnTkw+MqHNFsH/qNabRSIzcTsA17iWdqgiwBn+N6UPiCD3zxcEzuZKMekW6LeBvn53/rYO6jSjIQrMEhsSbW/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lvEjTX++H4yq1U7u/C484BPUuGlr2T+UALZgA7XfaW4=;
 b=Ta6HVy0UyZ9+rq9iYwwLAaJN55+HwPW4csz4mbM4GmsdQNBpYQWI2CkM9Tq1nri7PZDDCEx7fjD6pWexRmCcTa7sQrtZ+qKwRdaBRDA+j+6UBwooFt3kcmI8Fw9JHwTBN7H8D1/zd8DRY7h/tbNlMe5Myf+MjgG3Cw2M1afbGRvUfyAWr7QUgqIQS/+63w4UWIG2fjtl/xa89XxYutXJ0pwMQ6BCxTUd/GS9D6vp8jBohBteM2/MgH7XmCZhAMndwo0sShR1vm19J/6K+9gOwOYL15/9/HtJkpxMcaOW8AXwrmQ6diBxeS63NyGbmZpIZYltxsF1CCqCfypk62Pk4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lvEjTX++H4yq1U7u/C484BPUuGlr2T+UALZgA7XfaW4=;
 b=UBq1dbY1D+ffldycTYkW4utQClwJ3yFQTjxxIhWSmQWftiL4NzXaLOPaCzPUz2aHtZRVJYRgXXunsA2o/Sht+2Sue0uSSmJngE85ivHRlLBZmZUx81D5uBZro1qbMTDaSiroVZ+bqBL3Z65fQw9g+TQvvEY/YFkIdC5/MS7nXhk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5534.eurprd05.prod.outlook.com (2603:10a6:803:9c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Fri, 3 Jul
 2020 04:09:24 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Fri, 3 Jul 2020
 04:09:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/12] net/mlx5e: Add EQ info to TX/RX reporter's diagnose
Date:   Thu,  2 Jul 2020 21:08:30 -0700
Message-Id: <20200703040832.670860-11-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703040832.670860-1-saeedm@mellanox.com>
References: <20200703040832.670860-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24 via Frontend Transport; Fri, 3 Jul 2020 04:09:22 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9e694aca-0471-4245-a325-08d81f06de8e
X-MS-TrafficTypeDiagnostic: VI1PR05MB5534:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB553456D42DED1A7E3A54605BBE6A0@VI1PR05MB5534.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-Forefront-PRVS: 045315E1EE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wyLKTLDhFJguCSTQIF3k6STvSEbMezS3QjH7DIdf1shHNvwNP44IdKgt3ltnNg0gfQbodqAT30VmvM4VLLjR7Y0hivgMK9mr6BATdwUx7vRcrjkh9Ri4yuYHFenbzxclbSf5MGAt8wcLraqdrjaTZb+fbSZue7RdEcafznksJ7YIbYedkZsVmxLzvW3QyEbcmFIdahPfqRtJ9LOkiQJWnd7dOYNQazeMUOgzdksWJARnsP/GBlJkIyqVT9CyiRXtOiqKBK9/y+eN+9FIRO7UaAQh7vGtnbfwj0KOtCCWh1Tc3wEMyaQnf0ABCysKd741lAsk13gOyd9+SFsdTsRO7yH49mu/coSZWLgO+aMKUNH4fzBKkO2evyZmlMOtUN7l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(6486002)(107886003)(26005)(16526019)(186003)(2906002)(1076003)(6512007)(86362001)(66556008)(66476007)(36756003)(66946007)(956004)(2616005)(5660300002)(6666004)(478600001)(4326008)(8936002)(6506007)(8676002)(52116002)(110136005)(54906003)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uHtzze2YLucQe53lEETsHiMt6xIRq0kgQbAEhYfTt9DNdaEh2lj5HaUy9JTqOy+1Fn/BzyqlBT5MSg41BC/tKvycuzuIf3LLTmKUfEiiawnuWXWBM45CGi5jum2R2aluWptNr3eLYST4T6d8ZUyMCHib8/RcxmNV9GlCG03Jea8fNJqG2LitSC3hoyRMmFnZe7OQ7C8FmDDmAZuuVoP9ZfYNF7LVCwpCd80Pm4o649TFEK7dD6KYsy57GGa07u8YQvTWK3fpxh94CTj8eOlE20RosrFNxlFGuwWpZLc88JUZYzyDvTdCgxcFneK/TqTz/Sy3sx2XoGVowN1jU85U2bDMRNcTDK75+LXHXUfXte/GduwsrNan6HZAiighhWEamSogAoGDJkTbyTHlcEYe4o72Q1qYXH0ApvIR3Hm4HDNmTOIzjQHFZgMVjFArBQ2kzrC3T2khowtKjI/gHjEqaIPT7ti297rvq8CUb6TnOw0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e694aca-0471-4245-a325-08d81f06de8e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2020 04:09:23.9978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j6z3goliiK++t1vS5yX2/msKlpAXz/3EBNLB1++m3g7Meca+Y1G51w4mhiHnXQRXUZ+um1T9eXfpntYjjB7RpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5534
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Enhance TX/RX reporter's diagnose to include info about the
corresponding EQ.

$ devlink health diagnose pci/0000:00:0b.0 reporter rx
Common config:
    RQ:
      type: 2 stride size: 2048 size: 8
      CQ:
        stride size: 64 size: 1024
RQs:
    channel ix: 0 rqn: 1713 HW state: 1 SW state: 5 WQE counter: 7 posted WQEs: 7 cc: 7 ICOSQ HW state: 1
     CQ:
       cqn: 1032 HW status: 0 ci: 0 size: 1024
     EQ:
       eqn: 7 irqn: 42 vecidx: 1 ci: 93 size: 2048
     channel ix: 1 rqn: 1718 HW state: 1 SW state: 5 WQE counter: 7 posted WQEs: 7 cc: 7 ICOSQ HW state: 1
     CQ:
       cqn: 1036 HW status: 0 ci: 0 size: 1024
     EQ:
       eqn: 8 irqn: 43 vecidx: 2 ci: 2 size: 2048

$ devlink health diagnose pci/0000:00:0b.0 reporter tx
Common Config:
    SQ:
      stride size: 64 size: 1024
      CQ:
        stride size: 64 size: 1024
SQs:
   channel ix: 0 tc: 0 txq ix: 0 sqn: 1712 HW state: 1 stopped: false cc: 91 pc: 91
   CQ:
     cqn: 1030 HW status: 0 ci: 91 size: 1024
   EQ:
     eqn: 7 irqn: 42 vecidx: 1 ci: 93 size: 2048
   channel ix: 1 tc: 0 txq ix: 1 sqn: 1717 HW state: 1 stopped: false cc: 0 pc: 0
   CQ:
     cqn: 1034 HW status: 0 ci: 0 size: 1024
   EQ:
     eqn: 8 irqn: 43 vecidx: 2 ci: 2 size: 2048

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/health.c   | 31 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/health.h   |  1 +
 .../mellanox/mlx5/core/en/reporter_rx.c       |  4 +++
 .../mellanox/mlx5/core/en/reporter_tx.c       |  4 +++
 4 files changed, 40 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
index 4bd46e109dbe..3dc200bcfabd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -105,6 +105,37 @@ int mlx5e_health_cq_common_diag_fmsg(struct mlx5e_cq *cq, struct devlink_fmsg *f
 	return 0;
 }
 
+int mlx5e_health_eq_diag_fmsg(struct mlx5_eq_comp *eq, struct devlink_fmsg *fmsg)
+{
+	int err;
+
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "EQ");
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u8_pair_put(fmsg, "eqn", eq->core.eqn);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "irqn", eq->core.irqn);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "vecidx", eq->core.vecidx);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "ci", eq->core.cons_index);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "size", eq->core.nent);
+	if (err)
+		return err;
+
+	return mlx5e_health_fmsg_named_obj_nest_end(fmsg);
+}
+
 void mlx5e_health_create_reporters(struct mlx5e_priv *priv)
 {
 	mlx5e_reporter_tx_create(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
index 6e48518d3d5b..b9aadddfd000 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -23,6 +23,7 @@ int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq);
 
 int mlx5e_health_cq_diag_fmsg(struct mlx5e_cq *cq, struct devlink_fmsg *fmsg);
 int mlx5e_health_cq_common_diag_fmsg(struct mlx5e_cq *cq, struct devlink_fmsg *fmsg);
+int mlx5e_health_eq_diag_fmsg(struct mlx5_eq_comp *eq, struct devlink_fmsg *fmsg);
 int mlx5e_health_fmsg_named_obj_nest_start(struct devlink_fmsg *fmsg, char *name);
 int mlx5e_health_fmsg_named_obj_nest_end(struct devlink_fmsg *fmsg);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 4e1a01d871b7..5f7fba74cfd4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -242,6 +242,10 @@ static int mlx5e_rx_reporter_build_diagnose_output(struct mlx5e_rq *rq,
 	if (err)
 		return err;
 
+	err = mlx5e_health_eq_diag_fmsg(rq->cq.mcq.eq, fmsg);
+	if (err)
+		return err;
+
 	err = devlink_fmsg_obj_nest_end(fmsg);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 9f712ff2faf9..465c7cc8d909 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -170,6 +170,10 @@ mlx5e_tx_reporter_build_diagnose_output(struct devlink_fmsg *fmsg,
 	if (err)
 		return err;
 
+	err = mlx5e_health_eq_diag_fmsg(sq->cq.mcq.eq, fmsg);
+	if (err)
+		return err;
+
 	err = devlink_fmsg_obj_nest_end(fmsg);
 	if (err)
 		return err;
-- 
2.26.2

