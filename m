Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A1C1DF39A
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 02:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387518AbgEWAlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 20:41:50 -0400
Received: from mail-eopbgr40071.outbound.protection.outlook.com ([40.107.4.71]:51206
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387510AbgEWAls (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 20:41:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/FnG7kVx8Qnts+ig+uycUPzTtLH2wkN30w0YdAk4Tk1MGEdCKN3KnjqaGIXQM2BuDs9Ccsdh72yYIcH4AMITTFIdElEPLO98xKFCQLG+7SEXK0UYlkmr7mFECvNVy5RAkSyTQ+YyFovWRObwxpCb5BvEFqOSZ2j6y5ZQt7n5sNOvb3Sy+gpksOred74EpEtl18SE6eh+zGiNMXHXO1VCBpet8pwtI1uiYPuyRQAqspv5SKag/oh2pmRMqlepjwq8ylV9LIzj38aYShnOuvFED1fmC2S8Oj2SjIftH74cewxnqG+SchqhPLVbxi1ubY+P6Xk+5FKwDia8YtKCKI4Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fsn2U38XGKrNUE+TcNljhvwVvIYvjLVuiTsmLWNcRfA=;
 b=HxResILnCFG797IvWgS6VPTY9pXDIiXtENbJHwjN3o66Cqkwl14U/OHTwUXv7OACQVVEoYOm+mTnJiKOUz6bVI2DUciBv12YmlM0BBklbtNQReWcBNzLzXzM/Tz/TfwqB8xKloMUbecEHm0aF1B4cBOsnwmG0r2zj+SfpqV/2BSQjs9dEYBFoR/SRddfpVBbMwbhmD45VB74qUSmEWRb8m7fpzl4JGQep1EKx2qogzFjQE0dU4cVYXp4r7tVLtqp3eThU0TOG1QUjewXunN8GkxSFWjLGzf/azaki316FNS6JXSp+s9mNWr9xvid5Ktncb+P3xcn1sYH8rsw7kJfEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fsn2U38XGKrNUE+TcNljhvwVvIYvjLVuiTsmLWNcRfA=;
 b=tltCvERFwh7vzI8IfhL7rf7gun8+fxvI24If+6srInnZ4wnVd03Q4vFkI3pKFuL5mkAghVA71PvGTz8In3Xfhh6mvKbsIcvnMxdjgiP5MVlFn18TzBV9HoaybkxS54WtVuZp2pXnvythz5xeyobPvtwcLS33Wz0e8m1iym0S4G0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5391.eurprd05.prod.outlook.com (2603:10a6:803:95::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24; Sat, 23 May
 2020 00:41:34 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Sat, 23 May 2020
 00:41:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 11/13] net/mlx5e: Update netdev txq on completions during closure
Date:   Fri, 22 May 2020 17:40:47 -0700
Message-Id: <20200523004049.34832-12-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0042.namprd08.prod.outlook.com (2603:10b6:a03:117::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Sat, 23 May 2020 00:41:33 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 120c74b0-0c69-4533-2988-08d7feb20b6c
X-MS-TrafficTypeDiagnostic: VI1PR05MB5391:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5391264A547B54A22ABD4247BEB50@VI1PR05MB5391.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 0412A98A59
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oysUrsJZTo4c3sHmsP4kVAgMDz9Kzr5kK+6fAQOm7nVVqtYWuNlrMB4b5nO0QdPhGkIO3RmlgFX2SjCkh2pK9lu3FiO/bUnlRYubaQtql5iS5epYKetVyQ2i2KUZ3ZBFb6k0rwzMqOw5GFu6UnO9py0hvcPExlZS4fiA0174Sjw1hO34uFWKCp1c9YY4wZeYtDzA4ipM9So30wJbv1oMal0HgmI2uXSrxUofjUTiRotZiMtIVEiimZqw8dEXGQQkvG1xsLwA4wAheBrK15rRo77Wb+mAzVNydjXBX+VrTC6n1VwJMfOsFTzXUT00tmBhQA2jAUMWBi9A88Hl1auIrowM86SEJnuNkBmn7dYr9Sjco3MeyNylgBxXInQ1bwJy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(1076003)(8676002)(2616005)(956004)(4326008)(52116002)(186003)(26005)(16526019)(478600001)(6666004)(86362001)(6506007)(6512007)(107886003)(36756003)(15650500001)(316002)(5660300002)(8936002)(6486002)(66946007)(54906003)(66476007)(2906002)(66556008)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zfjNIRVJzmR9xfo7ulEDiaxao9/9Jlps0JnaZs36ziwiyCFLlof1popTNHy6LbTP0s4dkiDSOppRYIrCf2o+RM9YMhENeonEcboAWbdNWrcZKpAOlmV8rIVFvzIIX1IdlAxuQXpfqcyTIGNMuZySN+MdJRtw8lmEswB0Zuo02IDH2igTd3HhOlCKaYZO8im3dTjT06Pd3vX2wcVXvg+273nzsAnngb7dLseAqG/pma8NULkpZlOFhuXDxTYA7iagvhaOv79ni0kCnLDuubfx0LdByALtjkxLPHvPu7sOJGJ1VG199EeRrT/I/EWakeqINKeoYohyq5o6oC3pvuTiQwwt5hhbuNKYCfQtZfFhzkce4QZx+C6D2NRSwT5eNQkfJpZj2WWRgtFg87vbg0mksMeVsQ2XVRt3dECIPvdfTDDilkjSTTX16oC+qlZnhAKbOUXJJzZI8uaI0BL4CLzzZqGLR2e2CRXLJqSSzeCv0WE=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 120c74b0-0c69-4533-2988-08d7feb20b6c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2020 00:41:34.7445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jQEOJ71U890UwpIKStH/cbOiAfxFrKya5jh7SXXlI9nKidGSP7F9K10m34H6IzX5k0rhIiykXQQxnjMPIQRQrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5391
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

On sq closure when we free its descriptors, we should also update netdev
txq on completions which would not arrive. Otherwise if we reopen sqs
and attach them back, for example on fw fatal recovery flow, we may get
tx timeout.

Fixes: 29429f3300a3 ("net/mlx5e: Timeout if SQ doesn't flush during close")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index fd6b2a1898c5..119a5c6cc167 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -537,10 +537,9 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
 {
 	struct mlx5e_tx_wqe_info *wi;
+	u32 dma_fifo_cc, nbytes = 0;
+	u16 ci, sqcc, npkts = 0;
 	struct sk_buff *skb;
-	u32 dma_fifo_cc;
-	u16 sqcc;
-	u16 ci;
 	int i;
 
 	sqcc = sq->cc;
@@ -565,11 +564,15 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
 		}
 
 		dev_kfree_skb_any(skb);
+		npkts++;
+		nbytes += wi->num_bytes;
 		sqcc += wi->num_wqebbs;
 	}
 
 	sq->dma_fifo_cc = dma_fifo_cc;
 	sq->cc = sqcc;
+
+	netdev_tx_completed_queue(sq->txq, npkts, nbytes);
 }
 
 #ifdef CONFIG_MLX5_CORE_IPOIB
-- 
2.25.4

