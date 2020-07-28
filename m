Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C9323135B
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgG1UAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:00:31 -0400
Received: from mail-eopbgr00081.outbound.protection.outlook.com ([40.107.0.81]:56865
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728452AbgG1UA3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:00:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FzRIvXfsfERKVRrhiB9/CzHbKAgDFDNAu6ZAQh5ygK3bDKr5+3lnTwfoTt98cSXR+5FtIdNUr/tHwa3e+oEqthllF1WwHYshqmmWmNhrHw7aKnyvL4yakzPMlhaIgIQjd9t12sin0k+7HDS20B2YrineekuKgK5HBj6LM8DZ6y6uwt6B/gWF9Z6NRGVHI5dSztTRTY+nI7gVlexvEN4eNNaen0mV1cxMWdkUMXJNxy5AK6vek6Zx6bynhBiRXD1xX6FoulYp455JfPSCsfERGvR7Cyx4NIxkyXUfOZG/+gY4uU5CrSb3q0ccXFPq2t7PLMxTyh9SBcc9qgb5aAbQCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbS4hf242e7gV3+n9hr3DrvbJkJ5Xo4xW1uimBlEXUQ=;
 b=HgQtOqWWxoQgmJzp3GOrs/qOdcWWkDEzwwC2FqaCxBSnzrE/nZO6OkjEyJHf7IlOlhtPQbcL+To8kqOhvHBFXeLPEck5JZ+peWR09zCuAneYA48/jbA/xAHtgBZEwUZMkLpEsGlTqESeF6OqN/FEfZgctYoIRRdIGioubLVCDUfdAmbiRq0SQneiQ+9XcfS8HkxabNL/yKvwyb+QgNUq7a9+H4sycwXU69gBHp1Xp67DE4cbEo5h83zlEmObYLgQEb5g8qEgw1NNHcUG8HWRnrX3XM0TArrObKscaoNaFs4GlUsb0bsvo4k0DiX6hae5KPW5ULGm9lOSkWx/zln4Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbS4hf242e7gV3+n9hr3DrvbJkJ5Xo4xW1uimBlEXUQ=;
 b=PBn8AP0ynWNs/thUmqm6SIEcQf+9Rd6YqYmENWTyLzs7GYoMdFtyybcpUIr/174d4nne/+wFGY4+uPv6SxXpItGHXAKgFLMlBYoMh7IfPkHsivl88J5Oc9T2BjJN01DtrGdJWtuXUreNt6iRruhb+w+SkrydSPdM4s1/fjUCVc4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2592.eurprd05.prod.outlook.com (2603:10a6:800:6f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Tue, 28 Jul
 2020 20:00:25 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 20:00:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 04/11] net/mlx5e: Fix error path of device attach
Date:   Tue, 28 Jul 2020 12:59:28 -0700
Message-Id: <20200728195935.155604-5-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0058.namprd07.prod.outlook.com (2603:10b6:a03:60::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 20:00:21 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 06a33746-d0e3-49f9-6f36-08d83330dcfd
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB2592A8ADE09F0AAA988582D0BE730@VI1PR0501MB2592.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d2d2AkJN9/jzndXVd8/LW8p3aIBpHCvVhMJEMUqxAvm9sJ6WHPCH8GK7BB8tNaX8pzpeHRWCQLyLBw4H+RN/bBSmUa+Il5G+Lhg9DP+9PtcjyBvEpKqQdphdcMVYIu4X0I5eltNzbq5ZIP+cmqDcA+/jEXrgq7O+v2syubbwEjso3qBSVTiGyhO7cPYo/uzpP43Yt8oDSOpmga7DFAqUEMoCOvczztoWYNgdF2qFFWNwrgpB5CPIm8Hhc3vo6YDVchOA5MjTMMbeTcQcOx3Ow0IKR2Db0gzJtRXl252r8kYLiKq3hZJjv53b8shtKhf8Ury+f0p4eAXZ4ZDNc37bL2A/1Ii35NU3aXg7EFQbyL6AlTs4oZdniMr4TYvD6RtG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(186003)(6486002)(8676002)(83380400001)(498600001)(6506007)(54906003)(110136005)(107886003)(86362001)(36756003)(16526019)(26005)(1076003)(66556008)(52116002)(66476007)(4326008)(66946007)(956004)(8936002)(2616005)(5660300002)(2906002)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OpaPpJvSxiVgogzQqaMLSTX3F7xElxg6he4Epeh2LK0KdC2HOr04JvA/IX1LkXBj3gVuAalAO3CMCp6JWxSaiDCwo/pW8hQ82AoNDDwR79CHNuBDxhSIOJIX69Er54t0XXJI5URMaz0OSs0IqBHTcUOA6wF4qtgBF1Q7cAg1Ukopr3yQuJbxqY4TQdlWUHByjA9cmJylQafvIoX29lBv9NgbUSNTrANkeawZmOahjK7hurywvydbaN/cDONBOJukUDKqPiylewUvHaKdHFf7mxKdLBY4MRvdGf8Sp59nf3KkFam/y19Iq0sW3ocjmS00fikdJG7r8xqQ08EjoBEcSr+lKU/cy70w2pFmhm6m4osapYwXdvImqwcbpp1FIVLFxZP0ppGpSm1F1mT5zWlORpwWuw1C3UWurj6+UJth9s1SD5SIRVNwEW5J9PyelzLeKZKzwvUETjsqdtjmqNL0+Jk5m/q98MKBhXiSJ2FzOGA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06a33746-d0e3-49f9-6f36-08d83330dcfd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 20:00:24.6341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lpg3wgQUod2ZtUI5fHYmXFKKmeVpPo4pE9YYwVyrMo2ORTdB3taUe920y3UlbaHv+3QIqh9mWthlVGUwcSrYZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2592
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

On failure to attach the netdev, fix the rollback by re-setting the
device's state back to MLX5E_STATE_DESTROYING.

Failing to attach doesn't stop statistics polling via .ndo_get_stats64.
In this case, although the device is not attached, it falsely continues
to query the firmware for counters. Setting the device's state back to
MLX5E_STATE_DESTROYING prevents the firmware counters query.

Fixes: 26e59d8077a3 ("net/mlx5e: Implement mlx5e interface attach/detach callbacks")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 081f15074cac4..31f9ecae98df9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5390,6 +5390,8 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	profile->cleanup_tx(priv);
 
 out:
+	set_bit(MLX5E_STATE_DESTROYING, &priv->state);
+	cancel_work_sync(&priv->update_stats_work);
 	return err;
 }
 
-- 
2.26.2

