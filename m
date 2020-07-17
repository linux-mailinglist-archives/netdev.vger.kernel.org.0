Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D80222FB0
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 02:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgGQAFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 20:05:15 -0400
Received: from mail-am6eur05on2063.outbound.protection.outlook.com ([40.107.22.63]:40032
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726221AbgGQAFI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 20:05:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LaDI3Ck0g+BVHMjOiuuYrp3j6vMowREL+JSq75Gw39aaloqMwR1+4rCpZ3s50dBwhJs1L470bC/lbc2rpwafHNkJ6nDYDyppcZGy1EBZC5EqhnAXQI0yLgBsRxrDlrv2+XDcHeoC2bVtNkPzECN0kjzPXRdw213WSYqj0x47kfyWQBlWIPpBDin6CzKSGYl/Xn3R9LVqkWbhmbpoAOEWQe/bX4DkmW2BLyOoqf4nQK+O+5dWc3bAIc4Gmz6XlW02vHwdGbmtPWOYN+0dyGZh/UAkvAYN5i3HbtI6X50lC/ZBLATidGnfdicZfAu089He0PjMrsSSTTdQEg/suRTYzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNVvI84ZPfYwvr9ZrIby3vdXILL97vPe7zHcaPgnjHw=;
 b=odIwSZvUg0eDUIIpRIdFLzW2qiEHinpJ9zEMrCz7pHqnyu3pz0yi0AJ6bv7qDpXp1jTs4p5ds8uM5ZLx6P+PW9pHHYBu8cGxvb86jgf5sWBWXA16WL27G7DrvOuLyq3dYNVj44lAUfZC7laKsfrM9Swm3Km0fn0fON6WNGhupFItZ6JGT+v3ML4tTWcGXaHf19ZgbGb04FcV/Tw5GGcdsf2wWqJqfkMVkXtygbqXee33HE8ZyKWeJFo6PKU7oPZblZ+64hl8oQ6c/8Yg60YFdAEokShLNLFDh+gEfdZjUhLo1Qd5xeIaN5IMtacw+geH7ggEb7st0lOkeMcCC40GFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNVvI84ZPfYwvr9ZrIby3vdXILL97vPe7zHcaPgnjHw=;
 b=iT6or3MlziROPVzoSjD5bOt0ioBKm89dJO8uHv8EOgcPAT1WsLg8PuU8+Pwi+r/Iv6fvBdhCVKAjgPDI3UC8yP1wPzQdix7sI0zbCXNrgCaNJbppbM/kHjDvGBLQFQw17O/nqz7W3vVxWZJVjWusCGBj394sH/l5DUtTQeUogeA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB3710.eurprd05.prod.outlook.com (2603:10a6:803:8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Fri, 17 Jul
 2020 00:05:04 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Fri, 17 Jul 2020
 00:05:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 14/15] net/mlx5e: Do not request completion on every single UMR WQE
Date:   Thu, 16 Jul 2020 17:04:09 -0700
Message-Id: <20200717000410.55600-15-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200717000410.55600-1-saeedm@mellanox.com>
References: <20200717000410.55600-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0008.namprd05.prod.outlook.com (2603:10b6:a03:c0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.9 via Frontend Transport; Fri, 17 Jul 2020 00:05:02 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c47944c3-1f9b-498d-b4ba-08d829e50e36
X-MS-TrafficTypeDiagnostic: VI1PR0502MB3710:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB37105D711B4BFFFE101A7548BE7C0@VI1PR0502MB3710.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C74TW0fzFoU8dWApolptPPO7rafVZ6lwTx3B7ugA0/jM3odH+QLUUjUs/MFIRm6ND+ShXVl00aTp7QO+Hf/OhIq29lsAMNYLYREFf3NKjyueJnemZyJ84nTH1bMg7xM82cb54L6uL7R18v+ZCn4lbGQLodgyh1Wmwiaafe4QSf7ZP5QdtHYc9aP7ZC+JDLzC+uXfSZ9GOzqJSqCFjYSkzEudnK50WDdAgKm215Nliw03W5RC5v0xIoR/udwASuhsr0iw17VuARaHcKk22h4hG4TJQWZaWCH1r4Gw0RMUjPv7nAIIxQj72Gpr9r/nnTbAQoF/pgKxY140scEhTvcYQD96aHbuJkkNHdk3OkPEO6b8gd4KlrV2Vkhogw9AOlEE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(39860400002)(396003)(346002)(376002)(2616005)(316002)(16526019)(956004)(2906002)(478600001)(8676002)(6506007)(186003)(26005)(36756003)(52116002)(5660300002)(6512007)(6486002)(83380400001)(4326008)(54906003)(1076003)(66946007)(66476007)(107886003)(86362001)(8936002)(66556008)(110136005)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZBq4mFJJSSzwc7jPdNHtg8NUtA5iVRGNpHnB6w3xiPHCOUUA8ZJs7u2zN1O4UQyDnEHh7PATnAUIWLtXzPJ9NL66w34oPnDTPpNXYuHsB9UIVrR5zL/P5ZzNybn3/MxeW+b/g9fu6LnopasN76opmRJHO660kZ6GWWlj6zXfFnZ5moC0OIP9vP59Ikcl6Zo7xeeX2U1RrKslgsY2Oyi5e0lbYdh+IdseRr+HJq6mmqhdE5jCPIo4M0bVX0PLd0ASZYIR3wOIjNIoFyXuO1Txx8mWL23FjVQWiSHhPqrbYwytiLOg0mBGEN+7M7f3/DfPpNRFFveHtgwwq/84xEa2z3kQvI7SY8lw8kMssZ0umaBIZykyHAUPMtLIKnEaO+Xxzo5FsTnAo5J/dnH7Cou+q5BBrm4UC7yNaCnNOnVCh0NeLH/9tXKg112djOIff4YLvFDawLvz09W72edLiJ+A4u8agBpNoIWLacmoqL6279E=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c47944c3-1f9b-498d-b4ba-08d829e50e36
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2020 00:05:03.9208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wKVZguXb8fiOulHJZ/ABIfTZqVoYcjZveeYaxzqvCjDMCP1rl41xEh7r7XV+a1rNJNg+OfiDU5dKRa7JrJd+GA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB3710
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

UMR WQEs are posted in bulks, and HW is notified once per a bulk.
Reduce the number of completions by requesting such only for
the last WQE of the bulk.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 88ea1908cb14a..9d5d8b28bcd81 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -232,7 +232,6 @@ static inline void mlx5e_build_umr_wqe(struct mlx5e_rq *rq,
 
 	cseg->qpn_ds    = cpu_to_be32((sq->sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
 				      ds_cnt);
-	cseg->fm_ce_se  = MLX5_WQE_CTRL_CQ_UPDATE;
 	cseg->umr_mkey  = rq->mkey_be;
 
 	ucseg->flags = MLX5_UMR_TRANSLATION_OFFSET_EN | MLX5_UMR_INLINE;
-- 
2.26.2

