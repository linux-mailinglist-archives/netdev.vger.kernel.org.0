Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C239E213299
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 06:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgGCEJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 00:09:45 -0400
Received: from mail-eopbgr80059.outbound.protection.outlook.com ([40.107.8.59]:59118
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725960AbgGCEJp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 00:09:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YAomLqEhS1t/wxTjA90+JXipW7GA4vbHbu5IEN2pbEIzl6dyMQYrI+1nuVQQY65fXtBEyg0pRLBmGK91EftONvR5wMoXmpNmwKF+yQIk5+6q4sH1Spg6gG7u28dDwqE2TnSXYXkZ6oCuh+e+n2RsHA2fO4f50+dfYCtwhEGxQ1qHVbx3IjngP3IxugrohrxjOpylojPMwL2itDEGLC8jVn1DBhflkyDQyPWeWhdM+FLHS0dzL4FimPiE/phN5pEWqvYZJ0GNOXgqIFW0M2nDhAq/qJmwACDHx0jVrkXRJtRRmVa80txUUtGJ/LNArswNizAWuCJ9XDgJuQ6vVuQspg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PO1cR2KLkCfppH66uYpbdhDIpkuQE1L1Rxkc2+pg5yI=;
 b=L+w5B8oJZPH0M6fSzaVWzsmFMM8VnK108cJkkNbUWiXCuZ8xBWyGcsaC50ZsZUWZJ5inkdGRkws+3I7cd2xts32Nd4xGtp0chDV0SgXIo+xcGdERiBmnjU4hqL2ZqXG9xotFeNKzSD95JgPlav2SMLqHny62EQs4CNUky7Glay8FIblT9FfCUgYcYpNJfXNAPIuprR4JjXrs7cY6Y0t5rCHRXk+RB6Sa6jLgr3Ee+QjERSOdwRzokgZEHyCdq+y/o8i0J/bjXinnw9pxi3jF+AnWrTbwqQAsfHpO1jQV02MzqjPm7ngDkKLc5E+UVnFwMS8WDJiWUElDmlh1WhCMmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PO1cR2KLkCfppH66uYpbdhDIpkuQE1L1Rxkc2+pg5yI=;
 b=Som7qh2p7GYprv4pka+iJeQZrcELTDi86jiVKwgvcMWKW8SQuGI1bEX0qkgZCnmzBZ+NXpWzwYCdZS3N2/2l2zE0DhLnYBKaMO2dSGRGPp291KbeXhbhqiHjB94cXS3VUQsRWJkPvannTajIhyNNHyDVk0nwO62nA+SnnvFmChk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5534.eurprd05.prod.outlook.com (2603:10a6:803:9c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Fri, 3 Jul
 2020 04:09:18 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Fri, 3 Jul 2020
 04:09:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/12] net/mlx5e: Add helper to get the RQ WQE counter
Date:   Thu,  2 Jul 2020 21:08:27 -0700
Message-Id: <20200703040832.670860-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703040832.670860-1-saeedm@mellanox.com>
References: <20200703040832.670860-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24 via Frontend Transport; Fri, 3 Jul 2020 04:09:16 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 892cf6ed-aba5-48be-2b01-08d81f06daf4
X-MS-TrafficTypeDiagnostic: VI1PR05MB5534:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB55341FB4CE1EDE03FCB3CCECBE6A0@VI1PR05MB5534.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-Forefront-PRVS: 045315E1EE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SyEsIa6IuTug09xO26LgOiAuJZvuS96zrwWaUfHkpRlCZbxfPX8ujvEQc/0fWMFP/Gi0EnceWdHVceIAC19GpoCx4FWQWP7NPft/96QX68cmqV4m8HOb07afxDr3ZsPmq7JaWSz4Fpwk+KFg5HGvbYxXFg4xdOKgVLm5phJS0bxdvhgaREJIeNCePV2YvcP4GuxyRQ9xfEKtFto89AJqcc3THZ3ZJw8Od1ywldKcif06WjCegyTZeZ497A4X7jY7nt551LSYkBfqLi3VvCFW7eHw9vhKw0rh8VLfRxsAXxkh4Nae/PaqCM/hhe+3JpVt9+mzq1A1KGCIdMnXUixVaEAB602FBwQUh3dwDyx9y87qdkNAfIxZc4QBCAIeBrskPgrh949+GL7J6moHJOUsSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(6486002)(107886003)(26005)(16526019)(186003)(2906002)(1076003)(6512007)(86362001)(66556008)(66476007)(36756003)(66946007)(956004)(2616005)(5660300002)(6666004)(478600001)(4326008)(8936002)(6506007)(8676002)(52116002)(110136005)(54906003)(316002)(54420400002)(15583001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UkgK+8xemD48b4uEehpzdpfx9xAOUgVQYr+DdzmL7ERkLVPCqXo5Zx58axu0/0w5BuXiq3+gvEarsJSGCO7ZOdBi/H/C2ekzLKtZBni1cXcAvEAhAwOlEyZ9m97bCy9HDLkv7KIXFx6AICqUiVcZxnQpuxyzvcnAXxuN/fJVh5nT0PjPa41xDvpR8GCnde4Oiw65clFw7USpRHoA0CSodR5688DzOLuFqS36wcJysMEOrtseFaOZGVRwxV5Ppv7G7JJIW25+DDvIlSBJTvxyTH0toF1zggElDOs+/wnJWfTxMGviFP1xPg4hw0DhT2iqn2cpzQdPOXt4DFMwEuNC5meTS3kEHiMS1q+Cdnh6KDkEXIFDmj9WP/76eZ3cPoe25gfjGAdiyRkpz5Vj3T0L+C2h/X5uL0EJzHbpDsdEHwSbhMd9rLQIlzc/Lj+xzWnpvJAonsSCzGH0b9oVQz33d24a9zPZ/ZFZlEkaWMM/12A=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 892cf6ed-aba5-48be-2b01-08d81f06daf4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2020 04:09:17.8493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L8pjLyjKMXhB7c6kPtY0som3FvX/DaAslfpspK3MidxKLnJ36R34wV4S0GOEjPrbtJwFX0ufLPuXCIrgOHOpog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5534
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add a helper which retrieves the RQ's WQE counter. Use this helper in
the RX reporter diagnose callback.

$ devlink health diagnose pci/0000:00:0b.0 reporter rx
Common config:
  RQ:
     type: 2 stride size: 2048 size: 8
     CQ:
      stride size: 64 size: 1024
RQs:
   channel ix: 0 rqn: 2113 HW state: 1 SW state: 5 WQE counter: 7 posted WQEs: 7 cc: 7 ICOSQ HW state: 1
   CQ:
    cqn: 1032 HW status: 0
   channel ix: 1 rqn: 2118 HW state: 1 SW state: 5 WQE counter: 7 posted WQEs: 7 cc: 7 ICOSQ HW state: 1
   CQ:
    cqn: 1036 HW status: 0

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/reporter_rx.c  |  6 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h     | 10 ++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/wq.h          | 11 +++++++++++
 3 files changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index f0e639ef4ec5..bec804295c52 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -183,6 +183,7 @@ static int mlx5e_rx_reporter_build_diagnose_output(struct mlx5e_rq *rq,
 	struct mlx5e_priv *priv = rq->channel->priv;
 	struct mlx5e_icosq *icosq;
 	u8 icosq_hw_state;
+	u16 wqe_counter;
 	int wqes_sz;
 	u8 hw_state;
 	u16 wq_head;
@@ -199,6 +200,7 @@ static int mlx5e_rx_reporter_build_diagnose_output(struct mlx5e_rq *rq,
 
 	wqes_sz = mlx5e_rqwq_get_cur_sz(rq);
 	wq_head = mlx5e_rqwq_get_head(rq);
+	wqe_counter = mlx5e_rqwq_get_wqe_counter(rq);
 
 	err = devlink_fmsg_obj_nest_start(fmsg);
 	if (err)
@@ -220,6 +222,10 @@ static int mlx5e_rx_reporter_build_diagnose_output(struct mlx5e_rq *rq,
 	if (err)
 		return err;
 
+	err = devlink_fmsg_u32_pair_put(fmsg, "WQE counter", wqe_counter);
+	if (err)
+		return err;
+
 	err = devlink_fmsg_u32_pair_put(fmsg, "posted WQEs", wqes_sz);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index d787e8fc2e99..cf425a60cddc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -314,6 +314,16 @@ static inline u16 mlx5e_rqwq_get_head(struct mlx5e_rq *rq)
 	}
 }
 
+static inline u16 mlx5e_rqwq_get_wqe_counter(struct mlx5e_rq *rq)
+{
+	switch (rq->wq_type) {
+	case MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ:
+		return mlx5_wq_ll_get_counter(&rq->mpwqe.wq);
+	default:
+		return mlx5_wq_cyc_get_counter(&rq->wqe.wq);
+	}
+}
+
 /* SW parser related functions */
 
 struct mlx5e_swp_spec {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.h b/drivers/net/ethernet/mellanox/mlx5/core/wq.h
index 27dece35df7e..e5c4dcd1425e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.h
@@ -172,6 +172,11 @@ static inline int mlx5_wq_cyc_cc_bigger(u16 cc1, u16 cc2)
 	return !equal && !smaller;
 }
 
+static inline u16 mlx5_wq_cyc_get_counter(struct mlx5_wq_cyc *wq)
+{
+	return wq->wqe_ctr;
+}
+
 static inline u32 mlx5_cqwq_get_size(struct mlx5_cqwq *wq)
 {
 	return wq->fbc.sz_m1 + 1;
@@ -294,4 +299,10 @@ static inline u16 mlx5_wq_ll_get_head(struct mlx5_wq_ll *wq)
 {
 	return wq->head;
 }
+
+static inline u16 mlx5_wq_ll_get_counter(struct mlx5_wq_ll *wq)
+{
+	return wq->wqe_ctr;
+}
+
 #endif /* __MLX5_WQ_H__ */
-- 
2.26.2

