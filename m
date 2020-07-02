Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62FBF212F72
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 00:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgGBWVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 18:21:07 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:22294
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726298AbgGBWVG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 18:21:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WL340CZFKwN7bLAeo2QZYZhuLhoG7HDryLLvDSYvWirscs0FzD3YXhBCUb5fY2y0DvoVEJQA03XPX2DBfR9OerbPCZ12lUA62dITySAHN2V2KY/jtdH0AJo8TZUqXLDOQYiBegGMugwo49NI1KIZ7udN1ehZqrMao6h8B5esCaUDctEiqhBNEJuu9Wq7qTEYjcQSo/27Fb/NpWKa2NwmrUW8COlqmip3eZ2cceRsoH/+okLPncqpiJ2I+BRP2psf8//2z0iRInD6u0TwXIV0HJerYYIN/YzHWZ+ffY7JYSVER269IIqNQJ6clAkaM58Tgk165srrKmaaMUGTCJ9slw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n3ISsaoAVE4MqFYgU6y/L4W8FeiK38odjh2vqeTo6dQ=;
 b=mlBjtLWSosBFn6x3JRnsHQi3mz0rC8YguAe4FC6EvJgcNENvtjxYg+2JYvI/UuC7VI9Nov0pcTB3CVTW8al8qgSr3XxboBIRxwdhDQZ6wRF/m4PHqujI6mIX11LhXgpzCzDMSPsVq6g4wQkPNtexlfMij1oNiuvyqqCNDpWHTFI4H0TIQZWyBtc9M6lvdWtUDR+AoTa0VcnZh5SLfR4LokMEFqjv7tX04Jyg9fX2Wm6RqNVgeYeUnZnWPbFc5Nu2QRdQkFM+O3NUgtrnE3gS70x2n67pM4XSirRuK6Xp9zZxv1c4aVLdFn6sMz4Fwew6YGhFJzCb/HOFUKLpYXcg0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n3ISsaoAVE4MqFYgU6y/L4W8FeiK38odjh2vqeTo6dQ=;
 b=qrKiRfLVcj698CyvK5+nqDNNZ7OZ5TV7YjtZMdxF2mqfsMhZcrvDnBFobT1t/e4on0ihyErZOnoz/D405GHkz2lZVEug1MtN4e7BW0aCFnlYKIhZWehWSNgAVsMMNRjUC6TIM15HBt+H55mLYVvZMZUpttP4mplaebbc2OmfYgY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6109.eurprd05.prod.outlook.com (2603:10a6:803:e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Thu, 2 Jul
 2020 22:20:56 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Thu, 2 Jul 2020
 22:20:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 11/11] net/mlx5e: CT: Fix memory leak in cleanup
Date:   Thu,  2 Jul 2020 15:19:23 -0700
Message-Id: <20200702221923.650779-12-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200702221923.650779-1-saeedm@mellanox.com>
References: <20200702221923.650779-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0030.namprd04.prod.outlook.com (2603:10b6:a03:1d0::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22 via Frontend Transport; Thu, 2 Jul 2020 22:20:53 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 31b70f07-1e60-4497-619c-08d81ed6302d
X-MS-TrafficTypeDiagnostic: VI1PR05MB6109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB610929F4EAE10C17F57933CFBE6D0@VI1PR05MB6109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0J4WBYYtaUQqGPoyqNleVuiosOIQSy21IMBNjVkJmOJE/usX60QMeXB4/mp4tKKVv70N9u4lBmGl10t39enLUQmRU2HLyVqODOxwUM1KsjcLMmVjTrP3b8K6oGszd/nXt0FYe01DdcC9pHnxj5HIH/Jvz9XmYVmqfDvk+p4nTPCGNyWbOv3/QwFQuqVDh3i8VIXPcHwalJolXLWr3x9JGPKBRMfSHF6UtQA9EvJFUWBPiTKzv9JajLbVA/L1h/r3QhJpFDBawJaWNgj+81F4HL8bkIUQxCNFzZTQVL3juru3kYHAqW0ISsp+1TKgfs6XXxo0kt/53T3YS5+GwJWuxahSM9iwtRQ2K69AEws+IEalpELy3Dn2xLVnYvsj1XLi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(26005)(2616005)(316002)(956004)(6666004)(5660300002)(8936002)(86362001)(110136005)(186003)(16526019)(107886003)(83380400001)(4326008)(66946007)(54906003)(8676002)(6506007)(6486002)(1076003)(36756003)(52116002)(4744005)(6512007)(66476007)(2906002)(66556008)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Utv+8WXy2y/PcilmHgIoNnMdQxWWnZ43p8/ajKDFyPUq2nVowDHDoo3E4WIuUvQ3xD0Mb3zvXWt4OdNdynre2Fgm6aptJq+JK0I0ELRgUOJj+Hm5/Q9J5FryFRKUa8Iet+KwM/j/WW8CPkk/GLUJHar1rXGu1lwom1p8xfB7AJCSWDB2wDDoU0tW9+H+3b1k7TUPE3wNdOaLwmtq9RxVKDgM1mho7Qrt0MuXHmPg6u2cDCPPkLChSgklkDE7RHWklUidieHGewTeQbPihlJBCdszupykgOJOUi1hcUZdC6O0GplQL5rktDSg0/mrIV0bOtE/QfpAOJI/PSl0XSFWOriEFRGd+S1PUn+pygY7m3W6TKIJUyPpE0eoGpyGKQcSGppfL/BhbEsd0Qtx8qxOdKWNLrRxtQXQcBrH3BAHZsbBv8AmK5gCtzEJQ6HiMc9pX/cSKL0P50pLT1/dsXXMN4yUfQJ9Y4aFoy5plym46Zo=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31b70f07-1e60-4497-619c-08d81ed6302d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 22:20:56.0685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IMQlZMXCVQv9pet1SEPbL5lXXtoIdcpZfE/5tI36Mj1xZCAYEshcvi/wxsfpbGQHOkih3WrnUH7ISRrh+eRezg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Britstein <elibr@mellanox.com>

CT entries are deleted via a workqueue from netfilter. If removing the
module before that, the rules are cleaned by the driver itself, but the
memory entries for them are not freed. Fix that.

Fixes: ac991b48d43c ("net/mlx5e: CT: Offload established flows")
Signed-off-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 430025550fad..aad1c29b23db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1097,6 +1097,7 @@ mlx5_tc_ct_flush_ft_entry(void *ptr, void *arg)
 	struct mlx5_ct_entry *entry = ptr;
 
 	mlx5_tc_ct_entry_del_rules(ct_priv, entry);
+	kfree(entry);
 }
 
 static void
-- 
2.26.2

