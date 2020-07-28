Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0794231353
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbgG1UAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:00:14 -0400
Received: from mail-eopbgr00062.outbound.protection.outlook.com ([40.107.0.62]:13198
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728527AbgG1UAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:00:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N4dlmJBu6WRPzAsHKWkhax+4Wk0sB+ZHs08cOEZ+tphuCwWiIHcax3LHOyld13IRpzQlwA0txzK9ocslk3eygQtcJP/yh2y9qXgsD7JbJ4CmWKZVs9kk6Pq4qVy3d6oNhUK2BALY/sBAmGt/ja+tF2jbDJGi51+QLMLRX3I1d2YbjutwzsggCccy4Y1UnSi5J/XKTbjy0pXrGohmE5O3By3rZh9FSQ6CT2vNfeOYRf6k5M3/6izzukRVMTzgvcyXLNXwRnscMi8JjclwftI66SX6RppnRX506inr1gTMQO9vVCdQPonn0CAkjHtvtBleHzRaY6feY7ABgl3jujOuNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7/1yDK+ivw9ePtT0Eql+6kkxMnJzsGiQRVpRr7tOCM=;
 b=c+S70Wi/durzdlRvLQvqpgZPKZR1kffPOpEDJ+ikg4gLty4czvc2SEBHXK8urOvKgS2s0yYTi/OHgDGfVbRErMDIqdDIHbwR0hsTzoSttJpN1YlcPSEjjJ9f0hCAaoQqJEi/6J0fW+7VvKCc/x0l8pLB0oxwFOUFUN8aisio0ayj4lOI23UZF+5gUEJu8zfthKg6Ko+sB2Xh7q4s5qN4dJRySJXsFIxGRGr28cl76tUn708saKJW+C+nvySJKx8PY6X9cBKQzwxMAr1jjw/ex2caBRbfr5dBXRm02eM0pl4PNp2LM5KPoDd7gIMYQWElEgbYmbV8sSyQmP5j/n0lAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7/1yDK+ivw9ePtT0Eql+6kkxMnJzsGiQRVpRr7tOCM=;
 b=aSJqfePMD/cf0J79p+BMHsA+LL1YwsliGYAQLv4jMghjH+2MqmJcQmTrI0NsW/k3WzdWuUpEZzEBqdMw8v4YeOXiosdLkmTOlUoUqXn5PsADBcbSwRfEJrZ+iFPUW/rYDGRnWXUOYg1zT/V3BjGaHTAgTNYMQSea7LevbeLuk1g=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2592.eurprd05.prod.outlook.com (2603:10a6:800:6f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Tue, 28 Jul
 2020 20:00:10 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 20:00:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 01/11] net/mlx5: E-switch, Destroy TSAR when fail to enable the mode
Date:   Tue, 28 Jul 2020 12:59:25 -0700
Message-Id: <20200728195935.155604-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728195935.155604-1-saeedm@mellanox.com>
References: <20200728195935.155604-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0058.namprd07.prod.outlook.com
 (2603:10b6:a03:60::35) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0058.namprd07.prod.outlook.com (2603:10b6:a03:60::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 20:00:06 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 785fc63d-8672-4c00-351f-08d83330d442
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB25921F41CE345D693AA6DDA5BE730@VI1PR0501MB2592.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:576;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zTmOOJapb2zHARIxLAdtD66hROXBr3sj0fLKDgEtAHhslqi279PToQi4zg141BBwhDiYsiuX8xadc273J4+EtPvKqMIpa+jzrmsuZRso6rEzrkKxkPOlKnQOIGd7sUElwH/W1ApSYpLMas1cjgU98acYqPkUldo4ZOGdl4dygXAfLf07xae/4TktvaYfGmtjWP0mq3+aIPb/XvD2U8xexLi3oxXmV4B8eZhUur6QbTmpkVKVa/9YVdK3KUVSg/9mBwKBzejuIbxrnGd0PU0SIlltWUlrweUjsNaldsttyg09iNI1bbd+W10zes30nwEZqQ5zAPZ0PTH0ChJDwCdOpShSSMOZ668+r7EJy9WDIwGFIZ3KxzuPi2GfHXnqx9Fm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(186003)(6486002)(8676002)(83380400001)(498600001)(6506007)(54906003)(110136005)(107886003)(86362001)(36756003)(16526019)(26005)(1076003)(66556008)(52116002)(6666004)(66476007)(4326008)(66946007)(956004)(8936002)(2616005)(5660300002)(2906002)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: KI/B8dLxWZ7vAGP7qcD4GUYgH4sk3wMP+kTDyHX8Lui4+bssvok5vNVkIyvHx8L/00rJFQYC+CnMYalnSgKl38oC8BpeFBXAcjE2QaGDk4IX7BU23Zkmd1WYFPfpwlTC4dGWTeaCpvGxEMjxtmpjljTVHAznGYvwvExh8QPAa5Kv0nzlNR7Kg4T9kajlhxkYms4xhIdjpV3jx1+qkKbZP3ZJ9ue78ntJNWjpL4Bm28sCRCg72Ni2R0fSdxyCAYFq0IbBJY2SEXOOWEBd1xTa1DvQ8mUS1LOrjA+YPDG3xzsTOuqFrmtldDhwmDeX8P1tsuwliOTcwMdW49/abf+izo1eUohFbYpFx3JK4nBA2hCHGmKxloxqfbXDw01yU7siAEzTEupf0eIRvWkwNhjNbJuiKSEdMCHRxgG8XoX5RJL1rsUrW0gZ61Vebp7LIuZVg3ogfMohHLQzD07pyg7O/AZ6lju+oSIwm0k9qZhLNOQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 785fc63d-8672-4c00-351f-08d83330d442
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 20:00:09.3141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5bRyHuqf78pOTGAjo8SVEXcsl7HkSE0Xdem2Ce6QnS+skuY+pbLLeAf6HFbBoPDzdBwHCYMPMnzsarur596RuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2592
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

When either esw_legacy_enable() or esw_offloads_enable() fails,
code missed to destroy the created TSAR.

Hence, add the missing call to destroy the TSAR.

Fixes: 610090ebce92 ("net/mlx5: E-switch, Initialize TSAR Qos hardware block before its user vports")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 1116ab9bea6c5..9701f0f8be50b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1608,7 +1608,7 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs)
 		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_IB);
 		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_ETH);
 	}
-
+	esw_destroy_tsar(esw);
 	return err;
 }
 
-- 
2.26.2

