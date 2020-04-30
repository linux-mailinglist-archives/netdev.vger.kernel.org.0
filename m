Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECD11C03D0
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgD3RWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:22:07 -0400
Received: from mail-eopbgr00053.outbound.protection.outlook.com ([40.107.0.53]:60730
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726272AbgD3RWG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 13:22:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XAuTBjlqFx2/FDSefpv0fl/WGhVq42PnJILNiwNe7kTCLt4T6ZvaukzEjlCm8zmpdo8BjYPrZKK3XvpgrUxXa3B/f2DCtXR1rvWcqWprg53pF6seeb/Zb//M7XBLO1jJHmtRyMYOpHcIWQQLVoKs9TgjecfXWLz05ZzOxbIWGKl0vHEMR0LfRWpRXaLJPrZ2M+Uj7VnsxYu5qSQef8fFC8apvGNx0wKdun6nKVkCmnoL0/fmPxiTPylJDoElr86z/B2N2824AwIXFK06+J625e0FSWaXTnTKJTw0LoVhPnMzYP/36dKqRG5GlCtk23/R/lzOOZyHZ9zQInLku0NeJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DK3r7H0ud06k6PHC8QvqTwq6xK3UtX/R9EYmzZrWR+4=;
 b=HUjBh0BINcmdeaIDDk6CiQO8M76bPUMa5RdPLQJgqZjSiPFyaY62UuFVJ0LyRKWjFCckZu7Ryc4DwHINLqys45GPeRZUeXgyDLyrytDdlwyxaGNIqLyRt552SVHUrnnq/QtK88Xz1BNYUpUBtReHx/KMBXG8MXBzBCCxC1H3bsFqF3ReRpdDy/3H7PHAVcyG5MSQG8cufypEVCx0TPhuWfbtzUMvW2azg7nF/EwdcX1PShq1KfJ22XSbi/xoDSUs2pwLTev+vuPhIIelNQ+0N6jHe2FfFjFlzR5DXeQFgyUC8QOvFiBHaKnNJZOrlw0BuKMPAD/j1YM/YCqeAgzayA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DK3r7H0ud06k6PHC8QvqTwq6xK3UtX/R9EYmzZrWR+4=;
 b=OGpuUi6tBBaPPHu1K7p5BBTsi2vMstG5NA6QMC/CLiukRIufDtHLEkBnpO7BH+iJ2IUtZ87fiOC0wGfliep/iTql7Xh04bLf0jSdZq8DiEo8oTaFGnsi9xI1G0cO06eJUm+z/jnzdamHbe9Wy6qYj5YSVyGySbTzuNHJbf/03c0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3296.eurprd05.prod.outlook.com (2603:10a6:802:1c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 17:21:24 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 17:21:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/15] net/mlx5e: XDP, Print the offending TX descriptor on error completion
Date:   Thu, 30 Apr 2020 10:18:32 -0700
Message-Id: <20200430171835.20812-13-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430171835.20812-1-saeedm@mellanox.com>
References: <20200430171835.20812-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR17CA0030.namprd17.prod.outlook.com (2603:10b6:a03:1b8::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 17:21:22 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8a1ed96e-0cbd-424f-0354-08d7ed2ae854
X-MS-TrafficTypeDiagnostic: VI1PR05MB3296:|VI1PR05MB3296:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3296E5A9893C07B21CF9499CBEAA0@VI1PR05MB3296.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:989;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Fko2nLdf/Qa3esrBSVs258aBZbKRZmpxVkLRRBQ16D7QBPDXvbCNOvSsmLqb+90B26p3o160iVlbwOfOEObbyoy1BmJlh9U/n6aUbCuMQyR40swZ80r7B3MKLto1j6FxPg4bvIzoy/Lp4oxEix00NPEmNVM5k6sWCIVEIYqwfoOdR4o23QSEyX3Wc1MqC9si0xehrU1DcszjU5/yGs7A4kZp5ai/OIOI31Lmf5SfEf53B1aNZC4zow6ip6UD7lK479r3kST6VFmzBs12INHpcsKpOa8qR9xTAJpb6z57KHDum565og8Wmtzi5Egjf/73rv2lXb96PHowHMiA8ZTEVqserRFo5z6BrtMCcfI7wyleYBvPPhwlNPb4ARyQNLa5KlgqsOtVcm+n34zQ/E+/H2p3JBZRfphVOfHxq2bpWYkkvdXmPE+/Gnb/U5XPqFw/rJpGa2qmIi8k3J5CYKuHV3nWzkgtM5oNT4y0AxPCNcXXApW4sFTyoh5UeRp7lcC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(52116002)(6666004)(54906003)(2616005)(956004)(316002)(2906002)(478600001)(107886003)(4326008)(66946007)(86362001)(66476007)(66556008)(36756003)(6486002)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(6506007)(1076003)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: W7Hav5QPMcva2M+jcnW/AY5t5NrVPyPWlmRP33aeLRC1ee50C9GXQsM0sWLGquSjCbEfWFIkap9VQ3ZzbH3PXrWHu+mtMGljTCEijfwjCJMsu79VFaYgOWUYSRVZTSeYsFAtnFCeuzcn0Ew8bbAFBpakRQWIbvRZg7qnT9UrrQDubW/pOmrx4tzvxlZnx8FKCk4jNn9C/6KjFZku3cD0ONPvz9VoFX4xLu7mLz7Z4H0oysaAw0HX1hXzFSRcoHa/+jI686sMdEcHYahxL3M1hUV9rrgn4a5SsH0+5gNHjQ7h5gd6WH5GQTqvMOzhHoALtxtybxwQDDwol74nxEY4ErjF9r9SFBeYkF3d8514wo9haJyPtwKIaXdey9XqMbiRiRM8YMJ0s/hvYo3iAGye6WAxoXY0rC+2curBBXBZoiIweovBWEPKzDxwGWmIWOJRZSzAf/ZtRLG4rdEjMbuUUrDWP5fSpdXwYHriNX41ddueJFfidd+x17KBS6leVwNdW7TvN5e/rsUvkyozn3uQ9UiNCNvGP1vjNuG9tuW7BFbFzGRhIVvP2vynx5S1vHPY0Fddp7cUzKljzzTQxlKPc2EF+pPfSzxCK7qBCKILeM0BzfmrH+/m7Io+jKqL547+oI+iH7ReFfllO6R4E4nHFHjJL07/y3UvsvgMNMpnV2xxP2kWkLf8sdhg0AaRWD6mKEOPqI2NcZUhc/w6ifb90QscnCWcqeBVlRxQ2L9oeedZnCTdXi3jsIn4tkhrC4CfNUgnN4X5vH8RgVsjZ0aYMkNDeTQ4ye8kx+hB0o5D2mw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a1ed96e-0cbd-424f-0354-08d7ed2ae854
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 17:21:24.0572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TFCYSy1nsrtZY1Cd3cYRFQ9om9QCY0s4rqZ+JQQR0uwMMnBr/hv/2mWcezibQEWt0yu69f/plAfTKn8gbe4cWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3296
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Upon an error completion on an XDP SQ, print the offending WQE
to ease the debug process.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index f9dad2639061..6f32a697a4bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -408,7 +408,8 @@ bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)
 
 	i = 0;
 	do {
-		u16 wqe_counter;
+		struct mlx5e_xdp_wqe_info *wi;
+		u16 wqe_counter, ci;
 		bool last_wqe;
 
 		mlx5_cqwq_pop(&cq->wq);
@@ -416,9 +417,6 @@ bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)
 		wqe_counter = be16_to_cpu(cqe->wqe_counter);
 
 		do {
-			struct mlx5e_xdp_wqe_info *wi;
-			u16 ci;
-
 			last_wqe = (sqcc == wqe_counter);
 			ci = mlx5_wq_cyc_ctr2ix(&sq->wq, sqcc);
 			wi = &sq->db.wqe_info[ci];
@@ -434,6 +432,7 @@ bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)
 					 get_cqe_opcode(cqe));
 			mlx5e_dump_error_cqe(&sq->cq, sq->sqn,
 					     (struct mlx5_err_cqe *)cqe);
+			mlx5_wq_cyc_wqe_dump(&sq->wq, ci, wi->num_wqebbs);
 		}
 	} while ((++i < MLX5E_TX_CQ_POLL_BUDGET) && (cqe = mlx5_cqwq_get_cqe(&cq->wq)));
 
-- 
2.25.4

