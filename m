Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F33F1CBF08
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 10:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgEII3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 04:29:47 -0400
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:50670
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727829AbgEII3q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 04:29:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YqNV/b1g8RGFYYuoYx9QfMY5uetIigkoq/lUWvzJt5+xHius5YM9Qm4LqPOzSMOwVAOptQSw5NeKwhV/B2zvh6sIfJv3uWswAbpM78QRX9W5DMfWvAu+8boWmUtZ/hpaQZzgJNZ4iGoxcmftFGh6wj52n67S6YamoxOl5oSEv7jfzjc/MRrLwN/7Q7iW03ncJf70RvKeC+904zyB+f0rkMLJrDwOXOfk41WZtIVmPmG/N25vBaNTP5/ZMeLknm4wcPhQU5xjmhMJPxeT6I0r9l2K9Oo6XNwAgU7aBSuM34gMfEp4h/cORxpANyXh0H3aUemtxqPiP8u+nfQIeWDnzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=arWffuLIXU/57evNpKYZ3W3KYC5kc2C9w9WyXr/j4KM=;
 b=SwM9jGcGa7daF/Lp47iq0cvqr6Djoozz8NT7brnK4BIKcFTnabh4k3AB8MY6XW0GL8beMTccHtBYpfLb3t/Axs8P8G1zRKVOgAC6S26hF17cF/hRJiWjx3nsuIHMgbtdg49r8LJ+2lLw738FA3A/oXJulbO411Dwf5YxNl3Kxo1Oba2XLh6wytZZ6s22tS+FYjyytSdyN+n2pTPKsk4wViKJSmTTVXfCZg3uszNFYgBxnNbEbMjl3cOjjQVKu1K6PJxadPbZDfcDRMdmO70dcKV9iv65+wTAy0Py3+XRxP5T80pofQPF7N7a+Elvdbos8FWH2YlO2PEVnVvQbZOqSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=arWffuLIXU/57evNpKYZ3W3KYC5kc2C9w9WyXr/j4KM=;
 b=gVqHhJDoOb6lratCv9SiFfDByV2GaCZ4jXNljeLM999QKdRstsHhTiUYbJ0xsArfzlTkqc8cN8dS3jjpXEAgiNfzR5MKnDcqnBiWkFAzNNNwGTdq0ThB0ESwuqBszyBeKSvoaV6N3JAAGTHx9Vvmt3H9+C6ge5jHwg2ZpuiE0EM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4813.eurprd05.prod.outlook.com (2603:10a6:803:52::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Sat, 9 May
 2020 08:29:34 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2979.033; Sat, 9 May 2020
 08:29:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/13] net/mlx5e: kTLS, Do not fill edge for the DUMP WQEs in TX flow
Date:   Sat,  9 May 2020 01:28:52 -0700
Message-Id: <20200509082856.97337-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200509082856.97337-1-saeedm@mellanox.com>
References: <20200509082856.97337-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0011.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::24) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0011.namprd07.prod.outlook.com (2603:10b6:a02:bc::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Sat, 9 May 2020 08:29:32 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8f842eb0-c156-426e-ae0d-08d7f3f31aa9
X-MS-TrafficTypeDiagnostic: VI1PR05MB4813:|VI1PR05MB4813:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4813D5E79D52CD354426D0AFBEA30@VI1PR05MB4813.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Ux9+VEzJNrsNeB/ofvSncZZ6z2FmYDNAoMkfgzMepqdJLv8vbcxqL6XXhdonf9VigXfsqOFo6UfxxzVKGwsvj3yxY9JtJHTq6QgQSTgcLtFywC62k77Rrj+VOl2TSpYE8CGnWHjNcvxd1+9efmUPQTi2hEnJaaYAzSMcVigEtD0HZx70zIEdQbjKuwlnQb7wDB3Ou1oPNIrxdPt4Ib04Gcf+rUw+KNRGTDmpH7I8NZxYIhFujGj9mf+EiuEBrATYIAPj7K60lOPH2m90BHe38c3cUQ8WLd1urVXMuCGt7UgZabfkdIQdDPNKjoYNpTZukG2md7ma7JuRWyKkwfEwHB1TRfQBJfrYT32K29RiEGDdqmpjjWJrBVPtt4G4fQJVqgf2d5fcttwCaAD8ISECFlOgbyf8ys7EDuxAPmL77/Um6qeP/Ej6KUj5CWDjRdMZQ/Rx2c7O8xfUsNF/8OTt60XcJOS47xVXAZW3xlhCJpPHo7pq7iWo9V/721yULpMZzlMiE04VrPkFZCkVWi8X3vNlDrbmuKgDPhpccF9w42dpev7wpBkZTPrRV8Rd0xg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(33430700001)(107886003)(66946007)(316002)(2906002)(16526019)(8676002)(956004)(54906003)(66476007)(5660300002)(186003)(478600001)(52116002)(86362001)(4326008)(6512007)(6506007)(2616005)(6666004)(26005)(33440700001)(66556008)(36756003)(1076003)(6486002)(8936002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Wl/DTjYKtMAAPCtNPpX8SalN/jUUuJn51tPZuxM8HQ5sM+h9SBb1KHEr/RbQwVAoCK9JiH5nzRn9JxIdFISKoECrOS4MG2ScQqgihglDP19H2kOe33eERWqUUYO70GNvBAd8IzSIgCw5t2w3whyEHWit7mQPcW036XTkwyN/rEUUiJ2p+b5KztZaG1cMsWZc7bT1Rfbm4nml0noGZG8q4+5AI0BKDe0JjfmjeCg1RrXW5IsIhG/PPdTGiBn0LCLE6+pW4L42ZJBc6fEHBJp+y6NaJrujbSdw69MSdEqSP3SohhwSbSl3OM6kJtUcNeQLRxwS9BdcLVVakVmLPF2CG3p4n48+JTWZRnrIDNJk+U3R0J9VDypm6v76/qirgo7ensa89vTfaDPARBxR5CB4bE+3XFMRDWi12QNzUViRpj6Fd4j8NmxKPybs1HgSapdYrO75+G8+Cn/L1UgeFDfxlMjvv7irLrqc2JlPwuFBsHc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f842eb0-c156-426e-ae0d-08d7f3f31aa9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 08:29:34.8183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DzIaLNmHcNvX+Q/0vEg2m/LZ7L8O9Ou91vcB+TGNhP0aicqRIWlAXd4PWO2vF+2FLsHRdPJ3xDWhKkXs7AWsbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4813
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Every single DUMP WQE resides in a single WQEBB.
As the pi is calculated per each one separately, there is
no real need for a contiguous room for them, allow them to populate
different WQ fragments.
This reduces WQ waste and improves its utilization.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index efc271e24b03..1c9d0174676d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -272,6 +272,7 @@ tx_post_resync_dump(struct mlx5e_txqsq *sq, skb_frag_t *frag, u32 tisn, bool fir
 	int fsz;
 	u16 pi;
 
+	BUILD_BUG_ON(MLX5E_KTLS_DUMP_WQEBBS != 1);
 	pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
 	wqe = MLX5E_TLS_FETCH_DUMP_WQE(sq, pi);
 
@@ -340,7 +341,6 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 	struct mlx5e_sq_stats *stats = sq->stats;
 	enum mlx5e_ktls_sync_retval ret;
 	struct tx_sync_info info = {};
-	u8 num_wqebbs;
 	int i = 0;
 
 	ret = tx_sync_info_get(priv_tx, seq, datalen, &info);
@@ -369,9 +369,6 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 		return MLX5E_KTLS_SYNC_DONE;
 	}
 
-	num_wqebbs = mlx5e_ktls_dumps_num_wqebbs(sq, info.nr_frags, info.sync_len);
-	mlx5e_txqsq_get_next_pi(sq, num_wqebbs);
-
 	for (; i < info.nr_frags; i++) {
 		unsigned int orig_fsz, frag_offset = 0, n = 0;
 		skb_frag_t *f = &info.frags[i];
-- 
2.25.4

