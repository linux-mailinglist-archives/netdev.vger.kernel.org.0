Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E75E1C0270
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgD3Q0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:26:35 -0400
Received: from mail-eopbgr60079.outbound.protection.outlook.com ([40.107.6.79]:10070
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726839AbgD3Q0f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:26:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ByyrB91m3AohOKRPphoMFIAcFw7bCf5fm8k1X5+stxXhR2xGUfuRYg7HziYxNbgHKd4R4mNbB9bnYayIGiXdr0C0r8hAH0bKCu/J+8QVZwc6+6chZtQNpKPyxJ5drVsF91N0NVJwb5gPR6bJeEIkvag8SJrgbAbhmM95MfdRcDDBlRJ//ydiIBMll9Ej4Haw+MR0eQgUgnCGjrXgL3H0c+vWSFgyOQqGA59whh28aTLVKvjgRdNucWVH1/bS2cAucGxyWHwr+VjKdhaqlcCypqgPg8svhS+63NhzSjB5JEecF6eWdjRSKX9CVoiOmr7lj4bkc+UJ7bG92cvjy+7jhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OTtUiRkkxCXZot63MFRXM8FIhhj7QEossWMro4dok4=;
 b=W1cqdKBG8bNmbCkUzuoYbDGwbqdo6uYlG89npYDTDaZT/4efnEzf4V9Jp2SBufyvOyrZOhXhvwQbNxlAMvQZ7oQAwfTfMJYpY00RDnSNkxrStZFESmYVpZaMtjHYT0H0xjmhcQ9kvQ1YnpXSm9/BK4powDM9mTL2UZf1w5z+ijWhx6Qb0j3y7vzxauDWsHWD+Sy4zKQlkTktE8puZJlTbPM2K3CSUNHAyZha/3rH2O6jLed2lXWIoxAbyAoAKR1cVw3VwGbA8wWDE0J/ZrLcJv70jeks8gNtXEgGIZzfDlErf9j+G53lm8BQBRbL/et9eJqeLwxge6Ksve17+bhdVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OTtUiRkkxCXZot63MFRXM8FIhhj7QEossWMro4dok4=;
 b=WSTYlw5hagAdd2gycY2rTVspHW9VYntJ27hpEgDUuYwZMixkBvMWypQ9J9Mrn4es82W+KgHGhGxdyzVfvpCEFaUqEkniaDRAEiGpCenbVI2tRa9hNLS26NTPznT1SaAIMo1hmIq/6qTtYz9zQ/8aFEzgSF6o0eY0MI3BAz3fQ3Q=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5376.eurprd05.prod.outlook.com (2603:10a6:803:a4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Thu, 30 Apr
 2020 16:26:29 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 16:26:29 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 6/7] net/mlx5: Fix command entry leak in Internal Error State
Date:   Thu, 30 Apr 2020 09:25:50 -0700
Message-Id: <20200430162551.14997-7-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0070.namprd02.prod.outlook.com (2603:10b6:a03:54::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Thu, 30 Apr 2020 16:26:27 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 20009214-e740-497d-690a-08d7ed233c80
X-MS-TrafficTypeDiagnostic: VI1PR05MB5376:|VI1PR05MB5376:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5376BD682EC904609EE5DDFCBEAA0@VI1PR05MB5376.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +EX5v3Ul9RPH+8kp4cQ3psgqBNWsDYmb4Z71E0TFebx0NK6kvbwBiRnLdu2BhQO2Wn3JwLq4NW9ZrwXARSmKI4U+1gqSb51SZ1twRzbhOn0b6PRCToDK63JdK8QiRDhpIfxjlZgWZllgQI1dp4cHVDWpbOZsqmBsBfbDVEyF+yy+Go75moadn4/8KZwgdvVaL2CdaY4LjpQy40I47bWbIv1PRlrjTovSuae7t3FMIay62u2jFCeLMgKG1xS1bkp2cwFYMcM65cgX9Xmft2gg++9uU9ctasLq/elMqT6VJjBcswBCsnKiX1c3Nt9dqv1Vf1ILAioyPKJfiJp7gkGVLUrAm5QYclc6l6YmlVxon6dU/syh64CQteiy9+3EDH1mgvXuIsUlT0yam/6GJDEjqYapUvaKvCYBLcxksRi39WtMBNA8IP4yXzoIkjDYJghP4DPnkQK/9h0qBKp0CYa1hsh0v7o5w6gJ2abJSCQQ6LwQsBCg5l9xRbKs3QoOamu0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(8936002)(6916009)(107886003)(36756003)(4326008)(66476007)(6486002)(54906003)(8676002)(66556008)(66946007)(2906002)(26005)(6512007)(1076003)(316002)(956004)(6506007)(86362001)(6666004)(52116002)(2616005)(5660300002)(186003)(16526019)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: z+SnyIpVIX7sRKDHs+XsqBfqUesKislXKi76sjiDRaOUo68z0ZpdPEg42mB67hhRNpH+ZU9CXfFRlEBf73qsVsMZLlBFxxVYFXP6Njs6s2A5LrIHhiKVLEM97ejOi1eWRPGbwkKFr73NxoZuUHVQ2X+6HGSDcgb9s/Cb/D4rDeFN2iHC6r+LL5fOAg0lDTa6kzktSTIuuGcGcATXR5iJwbpKVbB2glQvYs4kov2pZ5oNp3QxLePerw3mexiDDAUzs7p9cDpjmVsMacGV7dmR1PasTY4v7ebmB07TREMXaf+syaj8DpIfbKB49Cs5wHn65ssliPSrL3wbHejpDzvG3IhkBs1nAW+8GVE99qB3G6nl5QUAN7cc7YQMWl5+2oU6wRvcFBmR8MbdMz7Bes+LkTDSpWeH3clgSK3nSDOVenr4GWBnj0mieOkDscJ+VYPhZOIfMub80kUyPGaJYyu4UG0FjU/N3MPJwNnnv0FSyP0h5x9uLFfrTIVMo5cNYqOhtZMEUzdxXBhSI0D9kKa3hx+K3zm4pSKq6gkCBs9ZLiT2tjPs/RFE/4elpYCz87GGPi+rOgCflLnPoq27CTt+vNPNAylfy+1ZPll/VDWz0I8Gxawlxe9lTI/wJwnWFrvFByxV3Ko2KCfU2LQNyfmfZY0FOnWQcVGurku47aZmYRNOYLL8hON+k4ckko7ox+Tv3VrlfZKEvO5RGjHgWRhSC1dRzVvFi0zeR2v7jAbBcHyyvJYrVMdVTFsA8b0T3b88tcT6it6+2f7mdmwvxlApQzB9Hz+owpnKaj5oa5+a/Lc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20009214-e740-497d-690a-08d7ed233c80
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 16:26:29.4489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YiU70m0uHgjbow/abi26f9f/E4feE/5OfvnOIj9CBAyHtf9sQmzLmUI43rO7ctHdjfXa0CFUvZIT4QRCddKJlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5376
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

Processing commands by cmd_work_handler() while already in Internal
Error State will result in entry leak, since the handler process force
completion without doorbell. Forced completion doesn't release the entry
and event completion will never arrive, so entry should be released.

Fixes: 73dd3a4839c1 ("net/mlx5: Avoid using pending command interface slots")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index d7470f8d355e..cede5bdfd598 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -922,6 +922,10 @@ static void cmd_work_handler(struct work_struct *work)
 		MLX5_SET(mbox_out, ent->out, syndrome, drv_synd);
 
 		mlx5_cmd_comp_handler(dev, 1UL << ent->idx, true);
+		/* no doorbell, no need to keep the entry */
+		free_ent(cmd, ent->idx);
+		if (ent->callback)
+			free_cmd(ent);
 		return;
 	}
 
-- 
2.25.4

