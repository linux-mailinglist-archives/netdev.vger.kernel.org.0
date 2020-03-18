Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6F2189428
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 03:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgCRCst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 22:48:49 -0400
Received: from mail-eopbgr130088.outbound.protection.outlook.com ([40.107.13.88]:62369
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727290AbgCRCss (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 22:48:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OjxDOv5RNVUkn+eP6hjIA0KEqxXmNXC/FSaXU+62uB0oGL2qgprKFTVS29Vo6tKTg84ebZWQ7PZWTlSObl+ib7fu0olFvf2wLsVIloKEqcRbG4KHrV5DQfu/qehgS1sV8f949//4vDkYTM5raIqZIo5NNg9ED8RactmslvMIzwSXyXGZ0OfYpTpMEMW5Km2Ogu0i50gisuyxEVWKsSI0/rPGRseH3LmgJJBuKxih+uBOjvYamw1zgiaPIxoYWAn8pho9ogsFs1ZA3h5eQECR2W4AUhX46g55jAPv/iWVYaSFtpGmGGwdQijay1FcniWBzx28mRA5mRlfL5iwwLYyYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8UIYYIzdqu/ZdqyernnS2m0VQC0v4yBiQH2gEOWey6U=;
 b=IQ9TLjLwdn6tbvw7FT+2dnYAsF3/hN974BD0ISzZMnmsO6v/HjzXchLkRQY7B3ALy3HgYj/y618dhKP+A4NR7BFr9wDr5aR/oDenCOPHzKBmDD46Jpewp+dyBLK5OwW2UafsgwxDpGlQK1CUmBOGVDKmgO794adQ3KSstXwfJRHq6hlg3meTgbgjYC9e4VYPNtKG1F4zfoZcUgmRdc4DumwpYE43TAhOti91HZW0FIskYHi5t7ZGwOp7YPeqyVD9Tk+4iEI3zXmOlm2sArNzq7AiEoWfxXZWy2CBE231VFhEM3/UtTHo1rA25Ka+Fg//2fLJbrNX3BUZqoOUOaCaBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8UIYYIzdqu/ZdqyernnS2m0VQC0v4yBiQH2gEOWey6U=;
 b=MIRbSR1riL8r4sWklH8l7QmoTQCPYRnD7QXVP6Ha8q9BP7DObJANgQJ3CMfT51S2XWE36MmQdx83BJmgHwBY5Hw1qXtuR6BABxRaRkToCznfrNyAGOd47GDmc3P0fbG+e29hwYsZUoZzsYsvpm2PBH947VdeFabNDsjuTW29xIg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4109.eurprd05.prod.outlook.com (10.171.182.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.14; Wed, 18 Mar 2020 02:48:30 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 02:48:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Eli Cohen <eli@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 14/14] net/mlx5: Avoid forwarding to other eswitch uplink
Date:   Tue, 17 Mar 2020 19:47:22 -0700
Message-Id: <20200318024722.26580-15-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318024722.26580-1-saeedm@mellanox.com>
References: <20200318024722.26580-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:180::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR13CA0027.namprd13.prod.outlook.com (2603:10b6:a03:180::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.12 via Frontend Transport; Wed, 18 Mar 2020 02:48:28 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dff40725-bfb7-49ce-09f8-08d7cae6d70f
X-MS-TrafficTypeDiagnostic: VI1PR05MB4109:|VI1PR05MB4109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB41094822B57D83D62FDE2470BEF70@VI1PR05MB4109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(199004)(956004)(478600001)(2616005)(6486002)(2906002)(54906003)(5660300002)(52116002)(86362001)(81156014)(6506007)(81166006)(4326008)(107886003)(8676002)(8936002)(26005)(66946007)(186003)(16526019)(4744005)(1076003)(6512007)(66556008)(6666004)(66476007)(36756003)(316002)(6916009)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4109;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NTeF3GWu3V68ZWMcIG22a5XWMLikEz2ubYe5mzLjiZPdDDw4h+ZicbDjEizwuBV0dnT2GEASLcm2uBoqR8zSb7BLgFzBamJLbjRg7YQPgcUJKts8/ohANR/y3WnwKDYNtj0MoY6NV5CUh6QKZPrlH1Iac7PMRts8vDZBGf3jPDWjkoE15BrnJQWosmgEGcbkhY9vzScrXsNO05bNPnufaoLaqcsidsdVPJArQCQLa1qzRbaTVPUARkz/HMQvV6tqGxS0NGn4Q4Y7t9pUNBZu9sqfK5BkMOtB16J6b6OYAPQGw7AzHtndOOzhQO9KkPtmeZIg7wTPb5n6tU+Y+TL4jJ2HjmLimLrqyfm8e6MA/RfyHiCxGcKmge9jrgxRMEFkrcKX31T+Cdq42Far0A/0M9P/O31i2y2J4MOj2NeLmUwuliY8VbFEaG71b1VI73Uc/uOisnkqgOI5zhc6KTkBr1s6kN0TTAeFAeAWYs+v85kOjymEO8eF4J+7JTyx2qYLxoqubhztcNoZwueLtgI4OJrvgv+h7WElHg5zcjbRAak=
X-MS-Exchange-AntiSpam-MessageData: FB0OVEBl1PjY0pYjeukFeWoP9ReQ8fT7Ii5Ovzj20mCO6QSqugVOuhAsjU9wa88N0SHfH7bNX90WBA1b9wpIzXVKBEcmuXVIhfyC74DnaGK3CoGIIb4mG6U6XNBhRfaaAQutfMqosB+WyjY/9Lguig==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dff40725-bfb7-49ce-09f8-08d7cae6d70f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 02:48:30.0677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YvS+t2DxrYSPKAsxnO5STaQvH37yNHjgpVdMSjKj08YbEgpsujGa7fhG+/KnqwyOMgrB4aJEh7u8KBwnlAs/vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Do not allow forwarding of encapsulated traffic received from one eswtich's
uplink to another eswtich's uplink.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 608d0e07c308..b45c3f46570b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -66,6 +66,9 @@ static int get_route_and_out_devs(struct mlx5e_priv *priv,
 	      mlx5e_is_uplink_rep(netdev_priv(*out_dev))))
 		return -EOPNOTSUPP;
 
+	if (mlx5e_eswitch_uplink_rep(priv->netdev) && *out_dev != priv->netdev)
+		return -EOPNOTSUPP;
+
 	return 0;
 }
 
-- 
2.24.1

