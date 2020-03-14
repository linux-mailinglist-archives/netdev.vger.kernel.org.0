Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E514E1853C7
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 02:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgCNBRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 21:17:19 -0400
Received: from mail-eopbgr50046.outbound.protection.outlook.com ([40.107.5.46]:31971
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726591AbgCNBRS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 21:17:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=llLf6IHPGODwUKojcCBYw4p2QUuHf7QualY/uMXtpwoerHyHxrDlW5VUMNCgAiF/go3r1zQQWwn1cp91zWc77Hn5EhQ1uAO3hjTvHGj5Ns2n0S0AwoV55N1q+FTGP8eQ+uoGeUhZbRW6NalKSKw3ZFudmsIc6DRVbLB8+JiXXL2NGzT9hvO0qRK3RlCFU2BHBmmEZZ3bWvYdFu8pya1vkSB28IVd4MVx3q8aXf4xlt9gWsiqWRIeoL2uvuGYr7rKd391vamJBzXm4WwCWmNi+c6oluMGASXi2+5MnI97xCPJk4l38YgZBWwZdcOg+EaeUYDf49KNSvMT/t6UigJNzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekvCY8bD8VRYLZ6cQpueM/wKQU1A8+mXcyjPDSDLlZg=;
 b=kTutycHFRHPYWHNf/6XPjBGE7zTHbMIT3NErJdm5okSSu5i809+8Rc8ywXUuyxmL9HnyK7rxOj/nPGxHfFvYSvcF60Y7diY4GLft/xJaj//sRnhIgqhD8hON+46HmXxW0W0qXpbqIgYEZ0LUatLaN5f46MwWOJu45b4fPiwmNeiRfmhss6S1giJ8oMNxK4BIyiz19bG7nMSScyIyTSpQ2l9FlOZSXtRJhDs8FPtWzVpjSdksYYi2nglq1aUtSkzz2nxHlEfUEZ0oxWeDFvlFCmFuREe2yN/m4BgsfBCKos5wo2anRv4EWD6OPDiJJb5KqXlt8Y7EiKTqSAoquKzI9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekvCY8bD8VRYLZ6cQpueM/wKQU1A8+mXcyjPDSDLlZg=;
 b=kNSDjR+Bulubf3FnNAB/tVEX0AgTxKs+bMSj9fmxWiKZ1rLfEmg1SWwD8vuicQpbqV1yjK0xYk1Wwl/HHbDPH/CHOMV0HBwQE9A+EkC1FvY48ai7qGJwIXpPnw5R7AZTKE5MLoFZdRP+a/MHhcPbC+TS6CE+UzJsZ7hy85ebbU4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6845.eurprd05.prod.outlook.com (10.186.163.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Sat, 14 Mar 2020 01:17:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 01:17:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Bodong Wang <bodong@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/14] net/mlx5: Avoid deriving mlx5_core_dev second time
Date:   Fri, 13 Mar 2020 18:16:20 -0700
Message-Id: <20200314011622.64939-13-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200314011622.64939-1-saeedm@mellanox.com>
References: <20200314011622.64939-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::15) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0005.namprd03.prod.outlook.com (2603:10b6:a03:1e0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.16 via Frontend Transport; Sat, 14 Mar 2020 01:17:08 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3f84342f-1146-4489-026e-08d7c7b56bdf
X-MS-TrafficTypeDiagnostic: VI1PR05MB6845:|VI1PR05MB6845:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB68453FB194F5A62B52007A4FBEFB0@VI1PR05MB6845.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(199004)(86362001)(54906003)(6506007)(52116002)(4326008)(6486002)(6512007)(107886003)(2906002)(5660300002)(478600001)(316002)(66476007)(26005)(66946007)(8936002)(66556008)(8676002)(81166006)(81156014)(2616005)(36756003)(956004)(186003)(16526019)(1076003)(6916009)(6666004)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6845;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W/r3JadT+tajEOxrQZxveGWtpR/N8A3d4q8o4g4BWAvRrj4/Z4XRgH+Kj2kON2fxZ1Q21Io0qyQuIZ3gqgg/2K3odex0yjBaJlglD/uc1cxJfyL8bVuhwDuB8yJOgIOoqGCa/hZDxhkwEnqC9x3e2PBRd/DEt4ot6ySudj2RyWfr+S1NZLRasI+SB4c6AcPNPT1wjbTPHgvNtxgXo3Ydy6goXE15xa7lb2Y7DaZ//YZ0PKet9KUweqK0XJWTfbBkzgNVWQ9GIgiRgdSEQdqB9l+farn/ilVGTNxJFhxIAEh3qeoyQz/54q1BewWIxJ62w0ZfGqm/pNaWFYWaSd0Typ6Dq0waWQDXI8RA+j3PUblmfBWaAkzllBuIt3BzQ/BjU4P+LwN21URhhQFNOR8K05kMWILBu7PIj78tz5gnmeehgS4jBtr/4ZniITyKOpQNC4faQ8m+bpREt1LZE5J7LYEPMEkyNvoRGLNI1bAXVtn2NkoO7kGRfdQ9UYefmwH9IFMyM7qPTstvsHdtm+VUYLduCZPw83fOc9GsD7PiLX8=
X-MS-Exchange-AntiSpam-MessageData: a+l5txkv15kC3v5ctUqMWfGUVr/v4UxeHTopv/5/3M3Oqd/vn1eW3HHrvVrbaf3VEUZA6GAcjmjhD9AYH1WHjlsyL7jel4adlkoZIJcCXiBSlNY2O/RQn9wHvuDPwWUUBiP4GN+od8gImuwFDYkkkQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f84342f-1146-4489-026e-08d7c7b56bdf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 01:17:11.2088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A9n2D4/oBsztNrVNhItfHJ0nUvRP1UrgErTa2eOT746nx5bn12WWPw0IFTiKKl53i66sNxVrhFzSaLIQOHmx0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6845
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

All callers needs to work on mlx5_core_dev and it is already derived
before calling mlx5_devlink_eswitch_check().
Hence, accept mlx5_core_dev in mlx5_devlink_eswitch_check().

Given that it works on mlx5_core_dev change helper function name to
drop devlink prefix.

Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Bodong Wang <bodong@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c        | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 5b05dec75808..e2a906085a98 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2478,10 +2478,8 @@ static int esw_inline_mode_to_devlink(u8 mlx5_mode, u8 *mode)
 	return 0;
 }
 
-static int mlx5_devlink_eswitch_check(struct devlink *devlink)
+static int mlx5_eswitch_check(const struct mlx5_core_dev *dev)
 {
-	struct mlx5_core_dev *dev = devlink_priv(devlink);
-
 	if (MLX5_CAP_GEN(dev, port_type) != MLX5_CAP_PORT_TYPE_ETH)
 		return -EOPNOTSUPP;
 
@@ -2502,7 +2500,7 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	u16 cur_mlx5_mode, mlx5_mode = 0;
 	int err;
 
-	err = mlx5_devlink_eswitch_check(devlink);
+	err = mlx5_eswitch_check(dev);
 	if (err)
 		return err;
 
@@ -2527,7 +2525,7 @@ int mlx5_devlink_eswitch_mode_get(struct devlink *devlink, u16 *mode)
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	int err;
 
-	err = mlx5_devlink_eswitch_check(devlink);
+	err = mlx5_eswitch_check(dev);
 	if (err)
 		return err;
 
@@ -2542,7 +2540,7 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 	int err, vport, num_vport;
 	u8 mlx5_mode;
 
-	err = mlx5_devlink_eswitch_check(devlink);
+	err = mlx5_eswitch_check(dev);
 	if (err)
 		return err;
 
@@ -2596,7 +2594,7 @@ int mlx5_devlink_eswitch_inline_mode_get(struct devlink *devlink, u8 *mode)
 	struct mlx5_eswitch *esw = dev->priv.eswitch;
 	int err;
 
-	err = mlx5_devlink_eswitch_check(devlink);
+	err = mlx5_eswitch_check(dev);
 	if (err)
 		return err;
 
@@ -2611,7 +2609,7 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 	struct mlx5_eswitch *esw = dev->priv.eswitch;
 	int err;
 
-	err = mlx5_devlink_eswitch_check(devlink);
+	err = mlx5_eswitch_check(dev);
 	if (err)
 		return err;
 
@@ -2660,7 +2658,7 @@ int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
 	struct mlx5_eswitch *esw = dev->priv.eswitch;
 	int err;
 
-	err = mlx5_devlink_eswitch_check(devlink);
+	err = mlx5_eswitch_check(dev);
 	if (err)
 		return err;
 
-- 
2.24.1

