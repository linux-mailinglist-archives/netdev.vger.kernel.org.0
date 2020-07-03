Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6DF21329D
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 06:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgGCEKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 00:10:00 -0400
Received: from mail-eopbgr80059.outbound.protection.outlook.com ([40.107.8.59]:59118
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726236AbgGCEJ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 00:09:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YMhLvD2fDlduRvdiMcBcbpIeOUq2GovqtNSKhaaQqR90U7WQkFsuJwCJ3EqWM2hp0nm5/OzZIinU++l5ZEX+MndALmfipFJPCeWKR4DWkflC2f48/vxuvwgEV3OTblCpgwq+ay3Ye6X8uIURCMsxBvQz5W9WnR8dGjowQUmP/d9v+JsvHYm+zClCwslQfEhDZkG3ahrvWOHc8S3y5b4oDwe2iwcAOEnIB+J6AQLj0GONlz8iE7feP50XOZiznblqIpp84Bws3XBtEz7Rc+1x962gwRjnzDKcS1UzzRTXm9BQY80OT+2irMqcbq9/90lf/M/PPkvZfu47SKIlRUmeEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M/n+jGCFKR6XaO/coDdi4kXzn28AHuJ2sDK3FRctqTA=;
 b=Jwdik0MTsWrNKBzl13l+9CjAjv2z25LF87HikFxoNFmbLGJaoF/H3zNHNqiTC7yHHlC0R4VC+Q9kKAdtGjOfVkzDqEGePEMxmaWsCNkBYCaksMO3SVG8CizkCzGHuAFSnzJSzORqI4PWTF7FNjiNmFsGEq8ml0owiy4N/n4+9DIjWWzHw4ldpKIbWkjqDYCr86vz6aod330VuNTxkZh1D57jRBACG9aoASt+8R4F7CnScnM6pMnTBYUHa4NCpoBxH/L2fLfkWJMFfmoxBqntSfXFzIDcttGmvcg67+WsoQWnm4Ht7JSFJiA+cGYlfMQO1DM4lMEJekpT0aq8Sz5DsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M/n+jGCFKR6XaO/coDdi4kXzn28AHuJ2sDK3FRctqTA=;
 b=KWeWDMVOys5rqUchs/I0tVL5xt9MYbbhLsozps7uI4+xh0l9C5+q4wW+SlbbgVG2CTdStFaVmLFLZyEU5nOgnPWm9vrm6pJiFeSiuE5A2sIWNaPwtrXc4gcMPgA+WJIRQTbSOiIp8KCNOfZx3RgK2uADx32H4+pbstoThHmZZRs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5534.eurprd05.prod.outlook.com (2603:10a6:803:9c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Fri, 3 Jul
 2020 04:09:26 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Fri, 3 Jul 2020
 04:09:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/12] net/mlx5e: Enhance ICOSQ data on RX reporter's diagnose
Date:   Thu,  2 Jul 2020 21:08:31 -0700
Message-Id: <20200703040832.670860-12-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703040832.670860-1-saeedm@mellanox.com>
References: <20200703040832.670860-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24 via Frontend Transport; Fri, 3 Jul 2020 04:09:24 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f0b9aa7a-f7c1-40a5-0619-08d81f06dfc8
X-MS-TrafficTypeDiagnostic: VI1PR05MB5534:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB55342DF89A071BBE813E4888BE6A0@VI1PR05MB5534.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 045315E1EE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eFz0yR5ubJP20Z3l2J7B08ol2E9lEL2kKxpSsh1aLEtn5/hXH5PF8NOGo9/D0GTleI6YGMj9OG/u2tVU6VQJTyo4k214k/bO4PHjbQD5vGiOxkDoGb3phBp+4ffL+C9kgJ+ylip0N2ZqZy8XkSKV1ruM+spwuNDOp98BSwvOy2kDYvGaur41AL8w4rLh562bKDUn5gc8fxqhZxlVWDSnOWPDoZX8chnvyOLJtAo5yqBczjTTXwY6G0lHDUd4bS1rP8Bvq0+0UfKOox2wiiQB/E/52Ui+QEzzXEmP4X/0WVsoQBJn4yszxEDC1PNey5M1APT1oUOyp5s4LV5GwD0lw8YPFcwBVGCZo+m5buHkXD3fl7CZTH9l3qnXWM7fwIZs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(6486002)(107886003)(26005)(16526019)(186003)(2906002)(1076003)(6512007)(83380400001)(86362001)(66556008)(66476007)(36756003)(66946007)(956004)(2616005)(5660300002)(6666004)(478600001)(4326008)(8936002)(6506007)(8676002)(52116002)(110136005)(54906003)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: MjkiSDOHF/bzYkTID92kSiPetmq4vYyEtH+aozZBuVxVvonCMQ2GlA3VDofvujjEPWckjm+l2+AbAXKxV1y5dfmWkkfMkOOKNHJdHO9WGdezXiu/tj4A4JNbOj5t80twGbE9AfPUZff9IgE0aersW4FmH2j0kIoCUpf2pV1NNR+e+6OXmbi5q8wWWj8ZLJnqNQAPvNSJWn/HizypL2dCq1OVjdl1QgVEk9jOT6mvppJ51yvFHj0UgqZmb7y0n/y86fT+pypTRVkXcyL6HjOoVr+DRi4G5CfiBPfNxNRer3cHW09jXvyS7di+5WavMllHjuOvKQX79teAycQzqmB098qMCBwG+YOUX+ApCQLvDsv6ZnZokpbuigl+R/pRZRdN9zUwT1QxAamdhaHMv5GhKPJoLCpRu7s6Z348y8jz4/0lGYFFS+uHovx5djFeRyllOWXwqOjZlKMYCgtscptZoJVr2bCgKabEDu2PxRG6YGU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0b9aa7a-f7c1-40a5-0619-08d81f06dfc8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2020 04:09:25.9237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g8anSYOnVd0dz+EwZFCOT/S1WzkuXklzhP7hVAKpMqBMJ8DHV+jfUaWp1qgIQ+m2R7kwCX172zYzYzm0Z6TQ+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5534
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

When the RQ is in striding RQ mode, it uses the ICOSQ as a helper queue.
In this mode, RX reporter dumps more info about the ICOSQ and its
related CQ.

$ devlink health diagnose pci/0000:00:0b.0 reporter rx
Common config:
    RQ:
      type: 2 stride size: 2048 size: 8
      CQ:
        stride size: 64 size: 1024
RQs:
    channel ix: 0 rqn: 2413 HW state: 1 SW state: 5 WQE counter: 7 posted WQEs: 7 cc: 7
    CQ:
      cqn: 1032 HW status: 0 ci: 0 size: 1024
    EQ:
      eqn: 7 irqn: 42 vecidx: 1 ci: 93 size: 2048
    ICOSQ:
      sqn: 2411 HW state: 1 cc: 74 pc: 74 WQE size: 128
      CQ:
        cqn: 1029 cc: 8 size: 128
    channel ix: 1 rqn: 2418 HW state: 1 SW state: 5 WQE counter: 7 posted WQEs: 7 cc: 7
    CQ:
      cqn: 1036 HW status: 0 ci: 0 size: 1024
    EQ:
      eqn: 8 irqn: 43 vecidx: 2 ci: 2 size: 2048
    ICOSQ:
      sqn: 2416 HW state: 1 cc: 74 pc: 74 WQE size: 128
      CQ:
        cqn: 1033 cc: 8 size: 128

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en/reporter_rx.c       | 59 ++++++++++++++++++-
 1 file changed, 56 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 5f7fba74cfd4..32ed1067e6dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -177,6 +177,59 @@ static int mlx5e_rx_reporter_recover(struct devlink_health_reporter *reporter,
 			 mlx5e_health_recover_channels(priv);
 }
 
+static int mlx5e_reporter_icosq_diagnose(struct mlx5e_icosq *icosq, u8 hw_state,
+					 struct devlink_fmsg *fmsg)
+{
+	int err;
+
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "ICOSQ");
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "sqn", icosq->sqn);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u8_pair_put(fmsg, "HW state", hw_state);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "cc", icosq->cc);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "pc", icosq->pc);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "WQE size",
+					mlx5_wq_cyc_get_size(&icosq->wq));
+	if (err)
+		return err;
+
+	err = mlx5e_health_fmsg_named_obj_nest_start(fmsg, "CQ");
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "cqn", icosq->cq.mcq.cqn);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "cc", icosq->cq.wq.cc);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_u32_pair_put(fmsg, "size", mlx5_cqwq_get_size(&icosq->cq.wq));
+	if (err)
+		return err;
+
+	err = mlx5e_health_fmsg_named_obj_nest_end(fmsg);
+	if (err)
+		return err;
+
+	return mlx5e_health_fmsg_named_obj_nest_end(fmsg);
+}
+
 static int mlx5e_rx_reporter_build_diagnose_output(struct mlx5e_rq *rq,
 						   struct devlink_fmsg *fmsg)
 {
@@ -234,15 +287,15 @@ static int mlx5e_rx_reporter_build_diagnose_output(struct mlx5e_rq *rq,
 	if (err)
 		return err;
 
-	err = devlink_fmsg_u8_pair_put(fmsg, "ICOSQ HW state", icosq_hw_state);
+	err = mlx5e_health_cq_diag_fmsg(&rq->cq, fmsg);
 	if (err)
 		return err;
 
-	err = mlx5e_health_cq_diag_fmsg(&rq->cq, fmsg);
+	err = mlx5e_health_eq_diag_fmsg(rq->cq.mcq.eq, fmsg);
 	if (err)
 		return err;
 
-	err = mlx5e_health_eq_diag_fmsg(rq->cq.mcq.eq, fmsg);
+	err = mlx5e_reporter_icosq_diagnose(icosq, icosq_hw_state, fmsg);
 	if (err)
 		return err;
 
-- 
2.26.2

