Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C851BEC36
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 00:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgD2WzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 18:55:23 -0400
Received: from mail-eopbgr10044.outbound.protection.outlook.com ([40.107.1.44]:62734
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726164AbgD2WzW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 18:55:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hKwCU0K9V53R5qodstJqfD+lv/jW0if86a70XXygswTpBM7qrRASHTgiIbhzSdtPcT3yaS7ifGs3bKQAUDu56cNnSy6f6KyURiqWQNNvahvWKssbfVus4sjjKcKsB65cHl1Oes18p2eyh1E4X126hAxBClMzLyaoNh/THcMNszoqzWgLJJZP1DOwfUhym3n8DBfJ0I9+sXSD5RqOeEIx+d5nBcwNgd3FE9t6/QEKhewHDcPtk7+HpRjBpd3PeRe3l4VD2d1/dw1Mli/ZUVErCtopnK9ruYQGrBiTdoC07L/dyyg5pPw4IcjwvSgERnDT4QeSYRwJA7CxhHD95yZFDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yUUfQGm9dEFRtllrurkLra+TvryAZHLiXCxBc7Xzj4I=;
 b=TCRgjRJ11IWDsyMrfRemULXMkKyIvMShKNoiGjQY8z2c1YfsaeZiXWas+1a82WZjy2q5HDFo5P9jAzy9v6B9HtOjt5p+uJolj71oO17S59grxwLQSS385n6G/x58SW1HW4mCTMx4zwYhyTSYjLIkHtJFOD0YikHmJ3WsC8qnHangBTEMV5UbwVZ0Nty7yVnvZLZkOBLJVhFbLxLCgsBESqnBvZNPrpnW39A3XSaUfzP2fvKz/2/SklO5GDIT9514SlP/8hn+ZA8ipZG6odVf7Q+9JWchfm6xV8Vz2LCFSAMe/rzJzYV6Ca8CsYRoNw+ov3D1J5JNcHpEfoY6dQZdWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yUUfQGm9dEFRtllrurkLra+TvryAZHLiXCxBc7Xzj4I=;
 b=m9Ct25AynQgfdp7jt1eCQsoz5qipYF30KmGNBxWGcOWow842aJrwg+qO6rP6UExIhcKHTBt7vkTnLqKAVCIazwxI7KaDuWihhw3FcH7+ljpOCmcjvTHvtLFrznqn5RNd5ad3ETvrd34mWwF5uYbEt+hvlOglDBL/5zgQ6LNWN1Q=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5247.eurprd05.prod.outlook.com (2603:10a6:803:ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 22:55:15 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Wed, 29 Apr 2020
 22:55:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 2/8] net/mlx5: E-switch, Fix printing wrong error value
Date:   Wed, 29 Apr 2020 15:54:43 -0700
Message-Id: <20200429225449.60664-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200429225449.60664-1-saeedm@mellanox.com>
References: <20200429225449.60664-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0022.namprd04.prod.outlook.com (2603:10b6:a03:1d0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Wed, 29 Apr 2020 22:55:13 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6c00ca15-ba2b-4491-6e72-08d7ec906112
X-MS-TrafficTypeDiagnostic: VI1PR05MB5247:|VI1PR05MB5247:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5247CF94020E5832ADDF1851BEAD0@VI1PR05MB5247.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:247;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(54906003)(478600001)(6512007)(2906002)(66556008)(6916009)(66476007)(316002)(107886003)(6486002)(52116002)(6506007)(66946007)(6666004)(2616005)(186003)(8676002)(16526019)(26005)(86362001)(8936002)(36756003)(1076003)(5660300002)(4326008)(956004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 237HhG5OiqSqSqDVkCq3X7rMKoJ9aRUigQvsuMoN9DYjngddpIyj6GXQsbRvvY4WYoMA1r6LoJYxIEd8g+/xF/+H9O6/zRiohONOhBW5yOufO72IrJ8m/op2V/6J8ZIoqoMwaDeBji2LaCqphCNbuBXUYWZKAm+XGhPyvmM90YEv6L188d2AmZoxPdKAstjm6X3yrRiVRt1Wsndq77j05daFhvj0NlDLglYGIWICbWmAFRav3JI3AnhTfNufrhySYywBM3zq6rEw1bS/wrecfHFyyWY0GhbmyY8HHDzEGYkcHfMatYX2xUtGLVWS6kS8UQmveBxv3xr1nYbNceRMRW3kqMucVWewp12GLcUJcW+qxknzIxnyg7Fr98cfDrGShzl42d/pRVgedJ41oeEtpSqanUuAD2kc84IlY8eDnKH+KZuxB0dtB1UisZvhdWKZAf+QYLbhk9Oozn1n2MSlEyOclMQrboZpj1GKrZILrcZK3TYpDboQKDFykEXImVvQ
X-MS-Exchange-AntiSpam-MessageData: GCg9UgX1p4somihkmjmy0WWXXL7/LMseGMBaAxdg7BZtitT01nHxX+EHeCl/vRu1hG1pLTx6eo2MhYBSHqoAMxvZ/E7cX3o+odLeEjq0ola0qbnaa0zUHQs9QmZJpwgTjasE+4D7QaiKVIUigrViQBmYmzWgRX43dBiaS7+toBxgKegW4Vywdlx28E4OMPudRG/ZGvcm4x7IOfsWQcppa6WNz20JNwzdGbL45nS4BPvGueDqvuyUhtY7r4KSQNxV3s4RtHb5J2VFNhYZ3NQgqidGk3vEMn1YZifrW8D9h7mXYWktcvoKg694vWiW38GGVDNrTPfsMSXjL0kfUs6Qo+I0++p47KYcO/atz5WSoMrPoLkCBeE634208oCfGmhAFduB5Qdc1qnILmflx7jH+33+hABH0KAQInN0Il0HchkyuE9XEdOyu1Xhx++JTzC3m+tvzK4Owpk/aBgDI2nF4Al2DW3zu4ZE0Ipd4MpXXRkOb2cr5mSEO8qoHvXSY3hmcDQwSgPBeODj5Jyz8hhvITDlpygv6K0vzR3A20kAQdOEy+VoHoDynPJNIR+Cqidj+WMvzj/qRuCfmhDWPwjqJxCCben+Sa5HSFtvyNOQ+NJiDtzuqqSVE0UiciZaneE5OdtfBTCbCmJ9mQa2zh6oQVM94YGo3Yx/yjtht/bW6Weo3RgsJgRvAfYcPgVPIMTgLfFygmvs821duLnGTl1iXuEDjefp0mXxcdAhZnC4MRYkxlCYxxy8RkDfVZsqBm7z56Ta1s7triIcKpRbooKP7s+ytZgofo5ucdhEqaBi7uA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c00ca15-ba2b-4491-6e72-08d7ec906112
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 22:55:14.8465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lBiO+Mu44VeXp9Q5dHvz14svKErIhlzzfYcV0Bu4hAPQ6Ga039ZVf/f3jt9P2DzF26Qy89LSWrpRn7gWdbUUKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5247
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

When mlx5_modify_header_alloc() fails, instead of printing the error
value returned, current error log prints 0.

Fix by printing correct error value returned by
mlx5_modify_header_alloc().

Fixes: 6724e66b90ee ("net/mlx5: E-Switch, Get reg_c1 value on miss")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 94d6c91a8612..8289af360e8d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1550,9 +1550,9 @@ static int esw_create_restore_table(struct mlx5_eswitch *esw)
 					   MLX5_FLOW_NAMESPACE_KERNEL, 1,
 					   modact);
 	if (IS_ERR(mod_hdr)) {
+		err = PTR_ERR(mod_hdr);
 		esw_warn(dev, "Failed to create restore mod header, err: %d\n",
 			 err);
-		err = PTR_ERR(mod_hdr);
 		goto err_mod_hdr;
 	}
 
-- 
2.25.4

