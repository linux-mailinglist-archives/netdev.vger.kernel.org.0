Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B542233D0F
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 03:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731171AbgGaB6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 21:58:37 -0400
Received: from mail-am6eur05on2083.outbound.protection.outlook.com ([40.107.22.83]:58208
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730989AbgGaB6f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 21:58:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FId0CmQtziIvFKvDjCAUsTjR22HBBEndS+Q3YTr7+WI3yt0DAW6y7vbqpbdCV3eTxTyKjrQofekbEMMYYYKtOyrsnjIuEOUwpx+mWDID7xEakBEIxnBuXGkG5wZA58lw3HjNoyzUlLDgR7iPRhdZrTffTQvsQuykNv23atfaI4CsQtZDaQ0nICUif9AUCwtwtCPhj4D/95aAtob9igfgVsSzJlaFAE7zWWE4f2LzVvttbFex8RPJMKB61onVj2RkP1Zwx0jM6r+1hxeEcOPb63le9aHTFmhkS6M/vrfsEc7HPdkyg0sLzkKxwT9bzw8Xp96wCx437c+bygsrX9fSYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X1RjUYVPITL1SKiCiRDicx9m1JcgX+HguJlgtBnAp2o=;
 b=gDxFftLTTJZW/IIHg05h6vXW0EAbCn/lNHilIh2NZM+mNQTyLhLjTwL7+f4KVSKsGtsKqS1QEL+BLh87uiruDrlJf4eFkzEzghTKyoXyobPVXitNWGEYj3mmId7TUemgI+r4IhM/V6HxqZoX7S20PdFMjtUhvlMRcmptKgueWGEzo+12bzF+N71dtmnsrOPh8rvpjHZUGTzF3S0aE+GvyuRA/aaD+WchzBb5Oz14yfk0H1g8vdwp0ziq3A5OjiTRfzzlcgOawnoks3MotF2XhNXSYMp0e0RtOzvc4BI2B6ll3SOIA1RBqMQR3hhFx4vBbYq2P//JG3LKSgzk8nd7jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X1RjUYVPITL1SKiCiRDicx9m1JcgX+HguJlgtBnAp2o=;
 b=NlougC+uez/hgBK/aJ/CRpJDjObu48yfi5/g+RiOwdtePuih+upalx18nsZrH7UeFVglHJCFB03tQl1QMGgNhJks5/CT0K+LnMjyeivKDrPh9SAgIrJtc68i2/WxSyzG2AS4Y9o1C4b++2IZm+3plZze4hywIZZJfn3Iwca0fTE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB3997.eurprd05.prod.outlook.com (2603:10a6:803:25::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Fri, 31 Jul
 2020 01:58:24 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Fri, 31 Jul 2020
 01:58:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Xin Xiong <xiongx18@fudan.edu.cn>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 4/4] net/mlx5e: fix bpf_prog reference count leaks in mlx5e_alloc_rq
Date:   Thu, 30 Jul 2020 18:57:52 -0700
Message-Id: <20200731015752.28665-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200731015752.28665-1-saeedm@mellanox.com>
References: <20200731015752.28665-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0075.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::16) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0075.namprd07.prod.outlook.com (2603:10b6:a03:12b::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Fri, 31 Jul 2020 01:58:21 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cbfa2879-fab2-45f4-4dca-08d834f53500
X-MS-TrafficTypeDiagnostic: VI1PR0502MB3997:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB3997370ADF9A9F6626CC7052BE4E0@VI1PR0502MB3997.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U3/iOca9bWP+WylXVkfKKyTgJxek5WvQprg4f60p8u+z1VEJ0LuDNGymSQeoRMfmYfF+rKsmAn20j5FtwD5OqQJL1QRzRTNI95wcG5h7R5T19pAANzP+Zv2GYR09PXu7A4mnMeNU3o+iEBvQJuW4LIKvxi6CDkK9QruxfbBTMWhn268NCDrnNpF4oRavz89FjpN7loGxuD2OeplBXCoiVa2DeO8Y7xEyuoYo+yBoe4W+dbtnhwOyM87YhNrdLs5ucIPjzzhk3hGH0BdE7t/tSYadxfetwRNgOUZ94hEe/KZDWCU44IjSbABBluhOrcS5no8DBVWMfsAzgOCZQuj5v+XCA2BT/sJZluQUzAG+IG33lt5r9IVqjn9EttFHX8JZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(346002)(366004)(376002)(396003)(4326008)(5660300002)(1076003)(16526019)(6506007)(6666004)(52116002)(186003)(26005)(478600001)(107886003)(6512007)(316002)(54906003)(6916009)(8936002)(36756003)(66946007)(66476007)(66556008)(2906002)(83380400001)(2616005)(956004)(86362001)(6486002)(8676002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tnAU+k7ZkjNiRHPp6TNuRNqj9l9dVHKS6xCtXuhxzigmWAwxvxhxP/yw8NYAAc8TEc0vDqfRj9dI1zzRJbdRF8p5rlBz7EkBLuoc+rjqJuxAF6INh3fCrH5iqRk+p5wY6U9y5FKrglRIFfKetuQbMh7KJPL8gWuhM0MXOtJByJKwW4Ly05Rd0wWSOBtb8a7Cbw2L/oUMvmFnkNrC8kgS/yd7Nl0ANJKGVIp0KUtRTsUxzloQVqxXlJc5hYLSytfAOI0BEQQtsIH5pNcX9Sj+qt23ScrHXKvr+sB7aYBstzTAfG4/C2cPqdC+QY1PvFWDaAI8vChn20oeIX7aVtXDDwk44YUo2OdEmmXim1iv3lMRD+37uEY66d7OMWQLUllzp7IVlkTtIYGu247zOUc1ltIdRhHbFIf0kf5JMloFK/AmZSOAv76nx7duvD7bxpwLQ0H/RLWhmAPiDpY4QJrD+MavaKNxNAo65M72o+0VrLYk9+t0ULktTZ2MfrIXRwqzmKF/f3uSNhnN4Rz+6O1IlruUU12Cz8QXLBRI9cf+ZNyanRf/3IauVCXbVPLe5W/x+lS1Yx1tZUwFxj7CDRBDfWfIx3N3rBrpxE5z+byA6Mv42NN+ekqfk4RI9APK6ZtJK7uYlWq+/Xf7hESv2smZew==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbfa2879-fab2-45f4-4dca-08d834f53500
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 01:58:23.5630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xR26mBqFCiHdB4ZC6xVc1EgCNY67wd/fksz/NYoW4TSuuX3KmS4IYLAC9qLA0qG7FSc1HrGr613+J/fcCD9x0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB3997
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Xiong <xiongx18@fudan.edu.cn>

The function invokes bpf_prog_inc(), which increases the reference
count of a bpf_prog object "rq->xdp_prog" if the object isn't NULL.

The refcount leak issues take place in two error handling paths. When
either mlx5_wq_ll_create() or mlx5_wq_cyc_create() fails, the function
simply returns the error code and forgets to drop the reference count
increased earlier, causing a reference count leak of "rq->xdp_prog".

Fix this issue by jumping to the error handling path err_rq_wq_destroy
while either function fails.

Fixes: 422d4c401edd ("net/mlx5e: RX, Split WQ objects for different RQ types")
Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 07fdbea7ea13b..3b892ec301b4a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -419,7 +419,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		err = mlx5_wq_ll_create(mdev, &rqp->wq, rqc_wq, &rq->mpwqe.wq,
 					&rq->wq_ctrl);
 		if (err)
-			return err;
+			goto err_rq_wq_destroy;
 
 		rq->mpwqe.wq.db = &rq->mpwqe.wq.db[MLX5_RCV_DBR];
 
@@ -470,7 +470,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		err = mlx5_wq_cyc_create(mdev, &rqp->wq, rqc_wq, &rq->wqe.wq,
 					 &rq->wq_ctrl);
 		if (err)
-			return err;
+			goto err_rq_wq_destroy;
 
 		rq->wqe.wq.db = &rq->wqe.wq.db[MLX5_RCV_DBR];
 
-- 
2.26.2

