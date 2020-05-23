Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4416F1DF394
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 02:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387492AbgEWAlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 20:41:31 -0400
Received: from mail-eopbgr70075.outbound.protection.outlook.com ([40.107.7.75]:1415
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387484AbgEWAla (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 20:41:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n0nzwuSgP/3Y4yHpkiS8ilKrz1CjEGzvpfS4B8BML1Pfe23Yngn0tXU4FIaY/sKj3KiXTfCM7aBGDnMFebD7y3Pl67kszA0F2VuffcrSxtFfwUJyBpE9zYksS2Ctqf4SVsE62Jry+FQTk0nBFJvbaRnpvwCF58d07j9KHFwf1ffwPPxztHsLuTFwARq8Tg1nc/qADB4Rejlldi8bVXpzMMYdU0E+7SJIGL0TaYqkUXBS+t+Vrx9QnyIdi/69YcXgcMfrYfnc9LtJEb0CWTFipFPJfdX73yCLcaxz2meDyNeMOsrzoEs17Oq+4mYfcA2H8UomwbIunUNB2/rJE65o4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXSUdohoApKl2kx2/Wmz0//oLVkqZuDgXhLcuRJvKdY=;
 b=IO7GizsGqlpHJ5ordDtd8a7iuQMNwOv92dQLQ9j2H/oaWc3elQMBFvXHfCeBdTHp5BHV1sKffZa0fk1cB94MQkyxv/WYmGayFK+dLxc1an76KhvkYyyuSbh2BLfF08P87VMecocHjNs6+l9cd8YRqsTlutdFJZsguMVTtqWvOwu3i8gQLzMe62FIJ8Xaq/B3aYD8vQPVXfrYCL+PI/pOCgITV/zW6LwdQhg/eJFhu07Gjxgf7xnNYZQp/H9iFzrL2v0ZVP87BFETuiXnSk/uSokYeQs/ZtxeMArUot/8IdbPviY1cOe/u+0pMEKUPvmelpqK1sWFD/jCRnmp4GIoww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXSUdohoApKl2kx2/Wmz0//oLVkqZuDgXhLcuRJvKdY=;
 b=eKtjRd/G8jN6quYbOPY7+LOGPpO7iNDZvvAmAsgNXqE45mbn1gJc/vghs3rwAPITqnqOjhgSfalxX9YdvzM8dfSXdRuZbQuGCC6JCBu1YY+hz7IY46Sc2ei/6UdyltXo05Mo/qZumLWaZd+q2ICpBVjD05mJE1JWntNbpCPMxbs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5391.eurprd05.prod.outlook.com (2603:10a6:803:95::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24; Sat, 23 May
 2020 00:41:18 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Sat, 23 May 2020
 00:41:17 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 05/13] net/mlx5e: kTLS, Destroy key object after destroying the TIS
Date:   Fri, 22 May 2020 17:40:41 -0700
Message-Id: <20200523004049.34832-6-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0042.namprd08.prod.outlook.com (2603:10b6:a03:117::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Sat, 23 May 2020 00:41:16 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9d4e70ff-9118-4271-6b33-08d7feb20143
X-MS-TrafficTypeDiagnostic: VI1PR05MB5391:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB53919F8B7E02617DAD9951B8BEB50@VI1PR05MB5391.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:86;
X-Forefront-PRVS: 0412A98A59
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4z4LhdX4TC3kdC/gpRpkS4hhxRXBsCN319egISOO+uqDDdwc6T5zfN1NYgK8vX140J83TrvqkvDkFxMoBEreeXlQ5cD5hWkdJrq5O9OYMfi2GWGYDQ+u4JQMFA26VkkrZCmzVH815zr4MIfmjkAlRys14v4pBCJkmXyx1b8TAOBLrIgJijxl0GSKzXcQcUbUd7wakKr7RFGuC19k0TT8u7OXmiZZytZsvNBUNVIS7xaCaVzuuKZpWHkusE9yqxe4TsG3i6afUciYkgeC61fDKz6hxuJoTDi+U9mQtZgzTfkAQjA4g6RcyFsWiMFaBixX1QMDC15AMt6+u74bC8IVnSN5PlJ6OwMV68laKue/JJ/RvivBUQaxUBlgjOuGd+GT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(1076003)(8676002)(2616005)(956004)(4326008)(52116002)(186003)(26005)(16526019)(478600001)(6666004)(86362001)(6506007)(6512007)(107886003)(36756003)(316002)(5660300002)(8936002)(6486002)(66946007)(54906003)(66476007)(2906002)(66556008)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uog7olrfe9VYfmFsm59rQ+wgrcHy0eIq2oFxErsYjfNSJ4udryz/tALaShcGw1BkxrkmOLpz7HoOQGELyjuwkQTh4m9bdD47iLohu2KeVytKAkPpmKYRDAJVKijdW2Ek8rjOV7nlrlsNo1QmljAPk3sn8ZS0fqNeKZ5M5ttdGWKvxHqjlHGRyBr2qfS59qt3byCzyuEYMyB8D0i0tGfjsQqHnMQI26zgjZZaAVbaIkA7t3LpHStJkhynH0nUVh5Cp1dU5wxoTjrNHXtg0T0I14clyBckaS3+nCrzDm5+9AEMyE7ltWr1cUJ5MnSlEpD2lflXV6erGpvdmeUjaHL6bavhQSEmj5Nh/iaoJAOhDEBe9P/AV1vMutZQIGRDAdx1AKw6i91/liWFwlFmyf9n+qZ7LVNREM7Z/P3wZ7cyZra08WNluszpX5BdkuKNEMj1Qvp1n+SKvsvoyY96DzO+a11y1SA+JS3z2Xq7ye44fAU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d4e70ff-9118-4271-6b33-08d7feb20143
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2020 00:41:17.8891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: azv/8ff5MDyKXx3+pYrYSQ8tDNxMLIT3g+TnmK7vhOvJ/WRiPIM3lBKixO8BCNBKj0Cc45JE5GFGRP/4+OsX7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5391
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

The TLS TIS object contains the dek/key ID.
By destroying the key first, the TIS would contain an invalid
non-existing key ID.
Reverse the destroy order, this also acheives the desired assymetry
between the destroy and the create flows.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index 46725cd743a3..7d1985fa0d4f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -69,8 +69,8 @@ static void mlx5e_ktls_del(struct net_device *netdev,
 	struct mlx5e_ktls_offload_context_tx *tx_priv =
 		mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
 
-	mlx5_ktls_destroy_key(priv->mdev, tx_priv->key_id);
 	mlx5e_destroy_tis(priv->mdev, tx_priv->tisn);
+	mlx5_ktls_destroy_key(priv->mdev, tx_priv->key_id);
 	kvfree(tx_priv);
 }
 
-- 
2.25.4

