Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14AB1BEC3C
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 00:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgD2Wzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 18:55:42 -0400
Received: from mail-eopbgr10044.outbound.protection.outlook.com ([40.107.1.44]:62734
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726164AbgD2Wzm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 18:55:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oW2pITneufMF/ez4pykpQcznOkWUgkm3/qVnDKUlMiD8NRqP3lhk9xHEnj7j/IkD4ZODNK4VU8ECwWs3VYIqviLS3FLAX+dM3W032GLDu8nV/XmpZeYX4NGWa7kctb95tGFQOF3p/ngCppczbmRY+d4N3BovaQN9wEquGUWC3ug9Kl82MVAzHZg3W8Ez7JeFQOTCovND1zxfGiFucYIsRHJPe/mCpa6P5SmFkZhgNrnHkqc6ahtTrOsPxsrwmAwJG0e2YPrOMjRJkn5r3dB0OMkcvq/hP5kbZrQeWfpAWAydTAkT80nuIeKV44mWMtrCQSukk2nXw44xkhqLzvxkJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gx1kWX0BhQfyEAdayO9WZjmrGJSzQkJ899m0BqlYtlA=;
 b=Lab5VJbljWW6Y42KdihwBvAgftSs/X55S4OJVuto1d67Z/7s3zcT0ztkkTale2vilUTYiuEcPq0Zx2HL2BIwV3A5TX4asnqS7ChUkaKQXGNQ9QdMB/U8cRbYLWBFhOXqr1D04KeoeGMdguP73YTd7xlzWK9L/8k6Xkp3dPDbhLLb5ranvbmN1zM8Gp8qV5xb8h22BKvpeqe7Rtt11YPADojyiMyinCZqXWDeTAi0jBIkNLlsQN/OOehDav4j6nm0BWczPDx1F4aGGorxxuTb8HwZAp1SbGeThs1jXAYAWU0k+ZU13gdEtvHdFBQNQkLqfllsZ6fwmfxFLkquMmYkJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gx1kWX0BhQfyEAdayO9WZjmrGJSzQkJ899m0BqlYtlA=;
 b=dFNsHYw9BUMWAro0PQRj3R9kN344SqY+oCGGbScE/JXFaT/kvlaoG3NR9lBA7aYriIi0OYdrJSXdpWo9hf0/0Lpg5jcGiE9J25lFiKixYs6G5fU5BQsK+0h6aG2xbxgO4d9CetFtW7k+X5A3YhtcYHLJNTG83/xZEH3Hx29dWUU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5247.eurprd05.prod.outlook.com (2603:10a6:803:ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 22:55:27 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Wed, 29 Apr 2020
 22:55:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 8/8] net/mlx5e: kTLS, Add resiliency to zero-size record frags in TX resync flow
Date:   Wed, 29 Apr 2020 15:54:49 -0700
Message-Id: <20200429225449.60664-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200429225449.60664-1-saeedm@mellanox.com>
References: <20200429225449.60664-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0022.namprd04.prod.outlook.com (2603:10b6:a03:1d0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Wed, 29 Apr 2020 22:55:25 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dbe0e1fb-5e7b-4f8d-d097-08d7ec9068a1
X-MS-TrafficTypeDiagnostic: VI1PR05MB5247:|VI1PR05MB5247:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5247006CE83C897692028E3DBEAD0@VI1PR05MB5247.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(54906003)(478600001)(6512007)(2906002)(66556008)(6916009)(66476007)(316002)(107886003)(6486002)(52116002)(6506007)(66946007)(6666004)(2616005)(186003)(8676002)(16526019)(26005)(86362001)(8936002)(36756003)(1076003)(5660300002)(4326008)(956004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uuNQCh1dlkiNGN6ZWSmLPW6gI1lU5MIthBS+gBfJ18qt8UiUo7QDOpS31Jzo/hc1ADlfltG0EfmwcyhZCD8fZq0L6cL75sA9622q2azfjQOOX1rqtM1a2BnxexK6oVKl57UbaF21xbEkjD6UavhDrd9KJLKLq5M4gBx+bdFnKH0nbE4QESuTqFgaAJQswvQxs/zzEjVMMm8iWx4+cI7r47UChz80CCme110rjEuHO15VflwrBydoUhuI+2l0CybOUsPTKjBcA41aT5nsMu0/zoqDH3fQ6AsOuTpkYPmRQeWBv5xDrGuiBWHWFfK8j+/e5v33SlWUpmYh8Izdm0q55J42YetwTxcpcviEv4lEwkOFGsjmianoyp8O2u+kLOoXP9wIGVOyrsIXcpkFb/EK1caw6HmQaJMH1LLN6GHZ/CVJQPlR/YMVYKKnpPTzLm6GBhreszae5RoHLHd5zKlSNK1TW0ledXmCKMaiPpElYNH4tQom1f/Iwk8LaNklJVCf
X-MS-Exchange-AntiSpam-MessageData: K5ZtdhmnQRzc1ya++ocWS4p6O+e9IY/LLrofugoy88hk3AWEqlu4dW+V7xGyIGXZZkL1SmE79hbtmwZZDXWP74Rj63x54h68vv2fF7dZnxhvEiEmMthVa4C+Lq3emVg4mvp/zdJslF4ygVj65TwxEBcQjeo59mbO8aWFYmsOFRGC5Uv4J4HbZxl3hgNDjuzazeMoE+Bso10g5AmzrdqqpZH2i5nkRvMyqp2PEql9Z3Ti6DPbdXOomNNDP0ndEKjfFLlAEJ+JGcsoFfHa1eICJp1ZZlBO48npzDWh+6w8ZA+TugxPZqHUWLejD9yoX5lgscuVO4VE5emVFnMc9SvsvtMlhWCDQwkXYHh/TsDnjBnhv2eJJgR/5zn84QIvtHbIaqs99FJxFQcunHpeDTFZ/uGeWSRksgUnptxdV2GyyPrtjAjU2w8kh8Y6Zh2wv0VWkLMRIpbpFR3av8Y+ILs2UB8wObAVig6bWBTd/R60+hWw7bTHuGiNmz/AspFhnDk6ZHrweFhwDGSM84xfO8xWqJ62lCdHJUeJdwepEKqTgHe9ELcMaUYBknW8OOfU2WjBSw0ggoyXo0IghtMFV9iL87ph6QyutRGEbkVsQGgJIL6IlOrT6HoZFQ9wXw4e5f1TwRZVfJ9CKVheywm4gTIzgikquzYcsXtogT5+MWytzfwMZkblt2nZ0yUj+vNlHN94S5KbT6QTOIRDPNAVvTOCHC8Z79Sc+UC6q0WAf4sotVMEtWeKzW7f/XruxH+yZy/tNBOi7EGIWoPWMOF0fIIUGAhbe9ZD3NYQdS+dr1d7n7o=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbe0e1fb-5e7b-4f8d-d097-08d7ec9068a1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 22:55:27.4813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vlOowgRJW/3H8maNJenWkvud8vKokPCRGfd3QYp/SCLcxx0ZyKTjEA/btbQ3cebaw6q+zJ+BlDYYvKHEpZH2cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5247
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

SKBs of TLS records might have empty zero-sized frags.
Posting a DUMP WQE for such frag would result an error completion.
Add in-driver resiliency and skip such frags.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 52a56622034a..a04fa23e1a53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -232,9 +232,14 @@ tx_sync_info_get(struct mlx5e_ktls_offload_context_tx *priv_tx,
 	remaining = info->sync_len;
 	while (remaining > 0) {
 		skb_frag_t *frag = &record->frags[i];
+		unsigned int fsz;
+
+		fsz = skb_frag_size(frag);
+		if (unlikely(!fsz))
+			continue;
 
 		get_page(skb_frag_page(frag));
-		remaining -= skb_frag_size(frag);
+		remaining -= fsz;
 		info->frags[i++] = *frag;
 	}
 	/* reduce the part which will be sent with the original SKB */
-- 
2.25.4

