Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2FF230632
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgG1JLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:11:13 -0400
Received: from mail-eopbgr10068.outbound.protection.outlook.com ([40.107.1.68]:63277
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728338AbgG1JLL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:11:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKj+EHXry4BwQgvFAmVirFw6CKSMqeLD+CT3VJOp/YvWiAHbyg7Q+CSP8yTFc9mhWdJqtYOWYmkIblkeaK9ZQr5F3shHHljhdwPTPQbFlDMhxK4QGbS7dvEZMBXdn33fK+aplPy+HXTMPeyFDrO5z9sqi6H9Pl/zfL+vXyDrey3lE1wSgCe6TemJgMMF9mbvyvpaxNwkQLzBOLWCl/4e2d4VTdIeyCtuW+gYtgnNno8x+R7L9vpAI95fG4qeSZOABWe/YuQVrPI1TmjdmzuhiwTn3Zkm36LG8Zl01SaG5SCK3E2sgGulESo+JM8923J/ViWC9p8cBujkJbHTDZWVCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gXrl47i8PA3EGMT5i4vfMZ74q6UW+TArcbHtIexVBKE=;
 b=jm0300+rF5a5PLi1+NgMS9tIv74NUYD54SWdbLAsdzK2spg/YSQ95rCzHpu7JznP15GhSHjMA85qwhTopDboioDKMwdUYxdXWf9IFQNxt4oD6+HtWNRzgg+ZfW2u4TdZiEQ6Zw9z2XLUiEjwhim3z03X0xD4GgbjhnS6TA3Z11n+0zla7JLy/6nnYalxsAYW9GQE36XD5LBGjvRyR6wge6u8YFIKRXnNDqCgmtgcf19E1GjfHkKZhFK5SYyOLsoASmfeQYGRZA7JIkFzCr5Jt8Vsg0wZORtUba7OW+FkZugYCnfSHBIKqMwrgaAUpRemuK0wWmzX47go02GAycX4eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gXrl47i8PA3EGMT5i4vfMZ74q6UW+TArcbHtIexVBKE=;
 b=iXEvps/W4+Nw6cUtrSDcOWtq2/LykG5M5sAqRGHdftpzO0Qea7ZU7QqtG3ZZ5fNkFhDeie0nRrgx9DryOpmWtKNZtBPL+WiFm+5Dsj6y2vBNiW5EPliuTDWs9uNGqeM7RGi2DgcsIazBR+4ywJ9Qi5sfyusIcUtEPgBBdhqL3Tg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4638.eurprd05.prod.outlook.com (2603:10a6:802:67::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Tue, 28 Jul
 2020 09:11:06 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:11:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 03/12] net/mlx5: E-switch, Destroy TSAR after reload interface
Date:   Tue, 28 Jul 2020 02:10:26 -0700
Message-Id: <20200728091035.112067-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728091035.112067-1-saeedm@mellanox.com>
References: <20200728091035.112067-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:a03:254::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR05CA0022.namprd05.prod.outlook.com (2603:10b6:a03:254::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Tue, 28 Jul 2020 09:11:04 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cf8af54d-f32d-4156-eafc-08d832d628a7
X-MS-TrafficTypeDiagnostic: VI1PR05MB4638:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB46381A15C433E606E583D875BE730@VI1PR05MB4638.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:79;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: URmUnt31lGrP8cUabnnDnkddFinS9z4zP2MCUJh8f02Ca2n1y1VYRZ6uJr9K4+pFue48koog9ZtTxesOBywB0AjqzLwGukVdpILdP1N5y9bbRWXJXuHrN4yQ8MNqXXmVJ3HTafSrCcZ/1a/ilTviRGF/Xoj7Fefph93uw02eTHPhi44CJxtDc5QRcG43z5yWTcrlrWLNZpcCRgL9nSNCg2jb/IU3cdNVs1Hfy41X8piVZPY/915pO/fVp7jpi3ATfIfRj82OAXwb9IICMxnlXQnak2vPwh1JQUFCFI2X70KJeoPHw768iFJEQ3lrztYNP6KKdg1DI8qq5nsUdpgPasoSryylIwmJLy2aK+BO9IdXEQwcHm8bLD9m6GfQB3IP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(110136005)(52116002)(478600001)(956004)(54906003)(4326008)(8936002)(16526019)(107886003)(2616005)(186003)(6486002)(316002)(8676002)(83380400001)(6506007)(6512007)(86362001)(1076003)(5660300002)(26005)(66946007)(66476007)(66556008)(2906002)(36756003)(6666004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rBaXyqA2mGkURaPudPeHHObQVRpCnTyOK7acatcYe9Qfjx/mu1yHRFtqXzRcG2f7K0+zZ7BF0R9/kYQDwqlh/EyvMb88k0cSuVT1GMkpl7KHgKeCdPFanYs+ZkvCYHXdGPs6636tpONkTJVm9FMa3D2lxaAwqiy/1Nga6i0gRYI4N0W0ZPA8KQKgDWJrsgejRaVTv30l4F0tICMxjhcabX49d8FjdHxjaZAuHtJtLKypzl/wY0B27miU3njYGB3s4/jZvYD9Akr4M+o6jeeREosfNQ6v7htbFxK3xw04gzh6CTDDDmqY0vAXUcf+Omc6CS5d4WKY/OYoNTxj4d7lusOtrcc0+xpusplXWgdj1djYzxRWCYaGO+BPZNA7mEBTFLl98Ajtxai9jn1Itu/SVDjihmH6DOROUgI3ru8Scj12dpKwc5UTzTYQJwGC1A+AF2dsFHWe3pf6uEKb9ouSFS3nOOPs2CvOsyDSebUPQMg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf8af54d-f32d-4156-eafc-08d832d628a7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:11:06.3560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d4Kttu8B/nFBkicJzKNVGrwDhpQdQrKK2ns98qUoOJBYTg5pfY36n7O5byO8tZw8XZcMsx0ZiOBTyVuoBcAp8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4638
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

When eswitch offloads is enabled, TSAR is created before reloading
the interfaces.
However when eswitch offloads mode is disabled, TSAR is disabled before
reloading the interfaces.

To keep the eswitch enable/disable sequence as mirror, destroy TSAR
after reloading the interfaces.

Fixes: 1bd27b11c1df ("net/mlx5: Introduce E-switch QoS management")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 9701f0f8be50b..d9376627584e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1653,8 +1653,6 @@ void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw, bool clear_vf)
 	else if (esw->mode == MLX5_ESWITCH_OFFLOADS)
 		esw_offloads_disable(esw);
 
-	esw_destroy_tsar(esw);
-
 	old_mode = esw->mode;
 	esw->mode = MLX5_ESWITCH_NONE;
 
@@ -1664,6 +1662,8 @@ void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw, bool clear_vf)
 		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_IB);
 		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_ETH);
 	}
+	esw_destroy_tsar(esw);
+
 	if (clear_vf)
 		mlx5_eswitch_clear_vf_vports_info(esw);
 }
-- 
2.26.2

