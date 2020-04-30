Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962161C0271
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgD3Q0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:26:39 -0400
Received: from mail-eopbgr60079.outbound.protection.outlook.com ([40.107.6.79]:10070
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726336AbgD3Q0i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:26:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AF9WEezybA6BwJhpjjBMeBqPuamGqvYbQX5jULxRw6FWtvM4/GkoBg76YG+dUC8RkW/fZlgXuIB6M0P1ckEWif0+8kF4WQsanZk5M+UzIUv11Kifv38cq3+ozUB8oozz493K08KDIP8PQ1L6Fo3R4j7alnW0BMJwYdsgv2cq/ueLRDskVCjVPJlT9aH/Gz9iRQSO8MLIBjS2n044HkqwUFSPd/5qg3Wq8ZqcmgXNYNIPxtQmuQG/h8HET6J0rGOLt621kFsZrDvpYc1zNdalxkkiNg4VTjOIEH4Cb4VyGtVZcTPuOBA1YjyA/WkjPr9j3xNiDgQAZp1mW8Hm1UXSqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2AAhFgVc2ZVICs48Ge6eX4rh1r93rthSxi81KUUQU30=;
 b=ZCgC5kcc+hy2Z2aenX0zXEJF0dWm2ckH1uzcP6fl8dcl1Oyy/w6JaTZ8x19GhbXhhKmRiP0nW3z9MB3TZsKoGzqW8O0++ZCkVVfgO7zPfUgmalG3pmGS/JoaLzuP7Ddx+dN/iNGcniuBuKuxHH3R8GTvx8gbUlbw8hoeEEor6Sp33KPRMPNcOe3I7WKJaEB7xpKC6Sj7CET4+hsm9bNoQN+CvqDDI3+tEcXXYF1pjywePg0ZrWY9NkLllDH/3zEcP7hWckST6uPnAMeqqESsyGl0s9aPcLQSTSjWL1MS4kBqGCFXyH5BVvluqrHyUmb7D9RgUUceFBIF6tz+j9FIUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2AAhFgVc2ZVICs48Ge6eX4rh1r93rthSxi81KUUQU30=;
 b=I10h61V0yky+I9JgQ6We6bqMMLXhSCPyMhyxbgrNHmTjt6Vk2CTFAbNQTYStLXbBwyuLVRTrjwmPBim9g7GFAE7EEHQj+zOLuLzUaX3CA06lvlHSvszQoZa7df3DuDkAkNfQEMRAr9r/zfkxG5U7xEHPjIg9eYEnIPfGwn1fKTw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5376.eurprd05.prod.outlook.com (2603:10a6:803:a4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Thu, 30 Apr
 2020 16:26:32 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 16:26:31 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 7/7] net/mlx5e: Fix q counters on uplink representors
Date:   Thu, 30 Apr 2020 09:25:51 -0700
Message-Id: <20200430162551.14997-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430162551.14997-1-saeedm@mellanox.com>
References: <20200430162551.14997-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0070.namprd02.prod.outlook.com
 (2603:10b6:a03:54::47) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0070.namprd02.prod.outlook.com (2603:10b6:a03:54::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Thu, 30 Apr 2020 16:26:29 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 714d223f-78af-4c4f-3a17-08d7ed233de9
X-MS-TrafficTypeDiagnostic: VI1PR05MB5376:|VI1PR05MB5376:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB537687B0BF8EE53F8B66FFD1BEAA0@VI1PR05MB5376.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:514;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m6j+KISNGpunadZQOwcacEgBL13tm4Y0KrwES1RkY2WNB+CCHW7bwXtY26xr0VI81Ds847OKFPcgoZ5GXxRtzEKvuA4nVMFTrbhPAm0m9xhOgSF5X+012PSgG8e0t3/tldDRPYNnwIPleAWNMkrFBQ8Mpn8DCVdrU64XnOajskmkvQSnOTvaV88RoqkoLYCRbs/kTAnSMSfIhFin2qD/WITR9gBZTm4nout5U9ksQxtCqba1eld7exqBNrZJPzdc6V0InpXIdeTbtyyC42mReZLU5sF1vZr8cxuWV8EE3fkTTom7VVbK4MWEymiL0pJX4rzIZD5tOJJhSWRbOeqbw7h4cy23rUSrSz5/ZKgUmRIrQ4SjyaPlAdTZ/i9M2vbQgpODVrWMfn7xEsFLexNX7VYPFbuKAbwRuV/4HSCJcP+YaLdtvuCq0Ep0M0q6aVY7JL3XaBib1x4jsBMPwj38CxYsfzjueJb4M4EfjdZhEv/yawx1sNOozmHCaArDgGM7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(8936002)(6916009)(107886003)(36756003)(4326008)(66476007)(6486002)(54906003)(8676002)(66556008)(66946007)(2906002)(26005)(6512007)(1076003)(316002)(956004)(6506007)(86362001)(6666004)(52116002)(2616005)(5660300002)(186003)(16526019)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: SMF1fEli39h68LN+Zb+BJ0RGQlti9MGoYroLnBau6NdLUaLdqHKuLTksWySQtKFpgZNMuVTflOldZrbf7uqo8yxlRllcRIlTZjMwJfUPlbUReY1qUmlxfjBLAQ64x+FRHnn6oRoNX5Q7XvR5vN5AzaQG7rWG90KWxK2xfHc2bOH1W+8AD11TKpLLZaJjgvjciadHgY2gKywB5wKi8Qtksv8T+1kH5FMbpfyA2Xl7dNYQIZ5rLh0McG1JvRIGu5S+pZ5zxmMlWRO8TyqFi+YQNYxlbpsjOQo8IkFi/Olw1VjVXmNOhVYuruTU2tKxqJKgg7JFOGSK/PjhclFCNcnqz+aD6kKeVh0PdI+u8DLUMDJXfsHjpo2rEOCFSyXUksO4S+FYMOO6RSYrPq2+DHGppcmg9fbU1bfLhGYYPXbFaLCnaUymXivX2gxV0itBt6Wttfe+8z7tp2Pe8ykqy6Bjf/MoDfbaZNdr5Rq4jV2XfIjGryShSxCqiltOmCxve0rtzWouBkW9ytlunQ5M3nGZaG4QHojMG0XD4Qch1ciFqeQu0acKNNFhbJ1S7Ivo9EE5QpOcMRWNZoav7/TwI9Yd/nOV9wkxEzvsatLIx+YjXuJCUUtPVF0rUYeZhClPcp47GKZloRt/9OncgPwCH3hqe7lHHxyri3DzNtBLNqOBh1lxCsLoZH3lCRgxMZ8zQCz0QjEOGjwUTQgYc9JOUwYgGZv5+J7cnJ04Pu/y16yAiWXlhDTMfxPOXEX9UFDsElPtMnmht+xgoDTrg44nkIPZJ4E/fDE9+h2+7MnwwYqKHNM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 714d223f-78af-4c4f-3a17-08d7ed233de9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 16:26:31.8505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O6JMD5hpwgs87xV2P0hpgfqKFe6V8bJ+MVmevpm9znM6Drm9pNtrgfPgrLUD6QkW4UuBZNa94Ll0Kzttmr0TJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5376
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

Need to allocate the q counters before init_rx which needs them
when creating the rq.

Fixes: 8520fa57a4e9 ("net/mlx5e: Create q counters on uplink representors")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 55457f268495..f372e94948fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1773,19 +1773,14 @@ static void mlx5e_cleanup_rep_rx(struct mlx5e_priv *priv)
 
 static int mlx5e_init_ul_rep_rx(struct mlx5e_priv *priv)
 {
-	int err = mlx5e_init_rep_rx(priv);
-
-	if (err)
-		return err;
-
 	mlx5e_create_q_counters(priv);
-	return 0;
+	return mlx5e_init_rep_rx(priv);
 }
 
 static void mlx5e_cleanup_ul_rep_rx(struct mlx5e_priv *priv)
 {
-	mlx5e_destroy_q_counters(priv);
 	mlx5e_cleanup_rep_rx(priv);
+	mlx5e_destroy_q_counters(priv);
 }
 
 static int mlx5e_init_uplink_rep_tx(struct mlx5e_rep_priv *rpriv)
-- 
2.25.4

