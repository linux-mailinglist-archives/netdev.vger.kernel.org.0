Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62036191C52
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 22:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgCXVxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 17:53:30 -0400
Received: from mail-vi1eur05on2072.outbound.protection.outlook.com ([40.107.21.72]:6069
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727613AbgCXVxa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 17:53:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AsZPq8e51vr/5HcoRbaC7sJThmmqKseXubff8Tm34tYzwpWWgy6JmhL7532XCaEPGKFVZLLqmGEXQUniK5sAncHDXBLqcJTXxLPq881tJfWseFff5LZNJ643v+XAd5u/xFKLpxUKMUmPblgK4u81Q+OeCauAwUKflyyi+ikRKvbnRaiSKi9z6NSmUAdnJcoei1PR6zzT4KXM0iVnUjgjDKyUM5tNaSMrDDQTQhT35jDq2S5LFYoyjHRYhLZ23RxhPUfnYd5OcVcozBF+7HB81Ywm3Xp9iaGff/00W4Dknrui233PvOP7FLLCA09YxDBfE0GIZf22medbW87fmEhK+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hgu+cGiHeq7g1OLb6fJhF9t4RyU9XMMNxv7ctjvE0J8=;
 b=XK1/29UaGjOovyq9wSSQdQmnbcWNGbbN/lWrNkP20MYzGyO1oPjKruBU7n5q7U7RHhybOVNcFetasgUxL03HHwFhX3t1zaHN2syXAiOlyAWKhK3uqhZ5ib0aWuxw8IveWCHmzwSfMGHqxWHz99zi3jBPhgBNv7p+YN6OmhhJQ8VulpgePWRJ66Uh+/P2uZETBCaXdHKJHnaSNnabph1fsLeAxnBH+M4fCs21poolQdB/Webk6axcQPALGZQpt7C7o7m8l+n5sBm0gfDgc8/Cybsmbx8I3f4l9Zraz/xQVyGNBFc9NBweNed2OdA/JTxoi6lmZWlmTDwnkWHYXIPfIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hgu+cGiHeq7g1OLb6fJhF9t4RyU9XMMNxv7ctjvE0J8=;
 b=lNSbUdDkSC1ykN+GQUIrS9Kx6oaajGJ2oAo5+DzSRy6ySUZMSjLPgp2W7H2ZnhRFZAEECrW4j9Ss9aa4nSv/CmWaPjc912XiPMgALt4uh5p4SK0GbqWurqulPusjx2iyO9O57i63r5o9RIn1O/1hKjvmbVm4i2S8R0iVg5FrR0Q=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4973.eurprd05.prod.outlook.com (20.177.52.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Tue, 24 Mar 2020 21:53:26 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Tue, 24 Mar 2020
 21:53:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 3/5] net/mlx5e: Fix missing reset of SW metadata in Striding RQ reset
Date:   Tue, 24 Mar 2020 14:52:55 -0700
Message-Id: <20200324215257.150911-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200324215257.150911-1-saeedm@mellanox.com>
References: <20200324215257.150911-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0049.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::26) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0049.namprd06.prod.outlook.com (2603:10b6:a03:14b::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Tue, 24 Mar 2020 21:53:24 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 322b5fed-b5a7-4313-b424-08d7d03dc7e1
X-MS-TrafficTypeDiagnostic: VI1PR05MB4973:|VI1PR05MB4973:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4973E500271FB0284898F3C9BEF10@VI1PR05MB4973.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(39860400002)(346002)(366004)(396003)(6666004)(107886003)(54906003)(8936002)(2616005)(16526019)(8676002)(81156014)(86362001)(956004)(36756003)(6486002)(81166006)(186003)(66946007)(6512007)(52116002)(2906002)(5660300002)(6916009)(66476007)(66556008)(316002)(26005)(6506007)(478600001)(4326008)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4973;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TwN+VpXrKEz4I010TDp/wY4MnJ6o4+7CKPscZdA4Bz+LXcHgvl2dTx2T5pI6SUw4KeptybQybUQrfUqwhGEOJ/hV7N74Yh2rfizNeYhVa8EDgUyDBzK4HYQAC1m2qSFlHUkWvwqJIWaw2LcY6fnI0eM7gPhA2/626/nMLMtB64MqY/WtX155KFUdGWhzUQ7ss5+aOWbOVsAG0YZpkCks/ldXmWlEiUEE0Fr6ITCj1HxnMSLEF81/YgDZIdzqYUp/tNQpeemixZTRHHdZMGJbb2yKPTxUoOvETtbihtXiXkvBK9vPKOThLwvss1y49Z+wWoI909z4wT6+8cR+MnMVk+Ycdlh2KNPXFDjYeksIZwbhln6cSV/4oT7Q5dp3lZdmJa6sWJaOTWiQxTW11BSh5FiNOCGarYOA13PWima421iMAtnjawGrhCqGQxkIJtNY6kJlm2uwtEKRq0mey0sFuJ2OAfSQz1qKIXg9SYMern+5iU95pEv98KgX/AbwLpNfbLzAwpYOwzU1w+obS+89xy2hCo1lTni3J33xui8VrIE=
X-MS-Exchange-AntiSpam-MessageData: C9IQ6Amy0oHJUeNYEkykb4XfDPSrs63Dn6tW53Nf7vw9HwfbeiWa4X7WZcKDp0ExqVXwbuRaLbFL2MS+k5r7WelUmNRE+PZreEDhhlXwcCRSdoWSVp0UkffmbjE05K4l2UZBqk6d+fDufTbVtrO8pQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 322b5fed-b5a7-4313-b424-08d7d03dc7e1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2020 21:53:26.3263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MZnRBOasThwftZdwoxKzC1jOC7wkzXEd8CleVPbyGlwlhVYzfawajdHxoyrpx8NbZ23IA6K1oB4/4ntjpWeLKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4973
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

When resetting the RQ (moving RQ state from RST to RDY), the driver
resets the WQ's SW metadata.
In striding RQ mode, we maintain a field that reflects the actual
expected WQ head (including in progress WQEs posted to the ICOSQ).
It was mistakenly not reset together with the WQ. Fix this here.

Fixes: 8276ea1353a4 ("net/mlx5e: Report and recover from CQE with error on RQ")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index a226277b0980..f07b1399744e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -181,10 +181,12 @@ mlx5e_tx_dma_unmap(struct device *pdev, struct mlx5e_sq_dma *dma)
 
 static inline void mlx5e_rqwq_reset(struct mlx5e_rq *rq)
 {
-	if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ)
+	if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
 		mlx5_wq_ll_reset(&rq->mpwqe.wq);
-	else
+		rq->mpwqe.actual_wq_head = 0;
+	} else {
 		mlx5_wq_cyc_reset(&rq->wqe.wq);
+	}
 }
 
 /* SW parser related functions */
-- 
2.25.1

