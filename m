Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F16F23AE59
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbgHCUne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:43:34 -0400
Received: from mail-eopbgr10044.outbound.protection.outlook.com ([40.107.1.44]:21862
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728400AbgHCUnc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 16:43:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBrTUR89UTgHsZ2o7QfDgLH3N1P0seGwRY7c3Dt0YgMf7mzfEtlPaZY6wsqrbzdIFpgO3krps8M6bnmZ4g/oqMd1Empp3j6rdNtzjcUcB25kaig+Lj3QEvnT7qkbwUwo2nNPo0qsKNZOoJfVqLmPX32EFvKWHpOp8i7s3CFxLlQu1L6fOlK9tNfCrDYKMjrqj5m/IGCjsHK4pUkO15ubOTZZENc5fGB3q4T7ZN6vxZnnjBKFCTEsBsIRNiZ+PJjyVAEB08uJTwswnlUqIPi5nEJMv7GnXwz2+sCuT485XAEiMvmU1vyNMFzGBfMBUUqfJZZ/VwW2MGJpKdwd7ky4Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wEGV3cA4ewmh/vGgIVB4gWpWUYPr6eN5brIlCd/fUwg=;
 b=asy1PITt7e1dheFI7TE3czVKetu73QkaKyWaMLEeRjp7UWVgqlH4S2sw9KSNeri9D0Xiv+ts35b4JxpESfiPyqdmhrPghZjNdtUYLLyQ8Zz7+lxQqXlgB/haI34BDntheC5jyYUB69GOkHRKmilQAE5c5PwZRRAjTFL8vi9i42bCy+0GSAVArCFIA6vG6gGWxEHXiodWReC+Bn7/isIYiSU8b3hzUR+ejcvGwGYMrw2bdgouUeCO+v6ip+VHxALbMHIQafEi3UyW/yVqbzyNO771tVgrFziCzyw2E7LzC6G1DC/d1MIGHH6J6AyEzbztoP2rOt8Do1VnGO19QC96Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wEGV3cA4ewmh/vGgIVB4gWpWUYPr6eN5brIlCd/fUwg=;
 b=XORpgHZ2iGmU7Qs3yZWf0BtSqr+VEsEZlSWYY5kcY8jGM0idvQ8zTwxgIQrTzW+f9r7EuJiJMi2DT48cIGcCLwd/9BGRVUtGNzeZ5n5CtibPWTHhx5Ge3fECLxF8rUSHxVwwyUlM396+rPiYUwqdrFbK/zjqSzMFdimcdbsuoR4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VE1PR05MB7311.eurprd05.prod.outlook.com (2603:10a6:800:1a3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.21; Mon, 3 Aug
 2020 20:42:52 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2dde:902e:3a19:4366]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2dde:902e:3a19:4366%5]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 20:42:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 1/5] net/mlx5e: Enable users to change VF/PF representors carrier state
Date:   Mon,  3 Aug 2020 13:41:47 -0700
Message-Id: <20200803204151.120802-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200803204151.120802-1-saeedm@mellanox.com>
References: <20200803204151.120802-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0017.namprd10.prod.outlook.com
 (2603:10b6:a03:255::22) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR10CA0017.namprd10.prod.outlook.com (2603:10b6:a03:255::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Mon, 3 Aug 2020 20:42:50 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fe33cb0c-0784-49d4-60fb-08d837edca9e
X-MS-TrafficTypeDiagnostic: VE1PR05MB7311:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR05MB7311016F4AB944C3164E4079BE4D0@VE1PR05MB7311.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7+HPTj3+fDrjn3qi00GAEFks9HCZwHXWCyZIN9z5LDQxxNVHBz2mYegh3iJz8BaBdApwJtOljroYOmR2UWJ4RZR353xTtUmVPGdQP3IUME15Hd6L3k6YB/3C4t7Q2VdeG5Ovvda1BolfIqv+wO/8li+6N9QUHRxcuzwzq3rUPKI+9nb0JX96G3yDcgcQcVraM1CJPUCwtWDyiW//U1lRZS60v8jvXRJZEXf9E5wyv3RQ7EyzVD8HvzMjspDyNjcHOoP79pLTGImusMDUwILCcHmsikuq9hFFA9k8IHv3XITS/6TR3N73NXjopL91yGEP/nUvEgsiPZE+lvrzwqIGsR4gqajmS1ubtT3EAKtNMjWllLMRoy3IRGvT2BGIXMnRZPpBgqloOXkqeBC8AH9AwTvtrJmUOCOAhT0jK6JwU1W3r2+sCPfndmrEj49xJakvtGTmK2HheT7y7QNCStdywA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(956004)(966005)(54906003)(1076003)(478600001)(110136005)(8936002)(5660300002)(2906002)(6666004)(2616005)(86362001)(316002)(16526019)(66946007)(66476007)(66556008)(6486002)(36756003)(6506007)(26005)(8676002)(107886003)(83380400001)(52116002)(6512007)(4326008)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bz9QiODsL9CRahmJEKSvJK/CJN2KCQQMB9HVuJwM3fo4sy3mOo1a2ZKcdhFW75qSD3HMBwemlol0TGgL00sq0UQSYJGrANBKiRdMthJGJvyfJJzwExLF68q/Xs/U9nfW1IUWJwhHS54oY9l8pUPyMwEEFxNtneGM5MIhpaKxY7nattBaw8K93iT+4xDxezIWeL8YCYrKfxv6ybHANe7TcUqNV2zwMbLY24Zwnt27ht6NwhnW9hW1wj/bpj9gn+HesGB5yjWsXhc2mfgj2NH2xZdoRFpE9cmJJKDSMekdpefekPsPuzJg663kIfRchU2aU7vdVqelcZ0O5TMSWXxXlnxb2UnPsvEJhN6J4MBdmKKSkjk/3aykE2QQQoymIWOhmWHwM4GEGnQXoFaZX+UugUxobWPABrQAloN2lSYeVXKBtllzcEa33Y85Oqpq2zfPLI/DrvZubWY6XlcGJBQKteM72mcgbcMk1JBRH2GIpMacuCa3G/9jWuJc0VvIG6F4xByOAeSYC5Oj36/WRPMKoH8nNOz1yPYsfy9pm4jXPKVRwsltyLp+EyYLWBSp7rf5272A6JdW/Q8mNjX4UeVRsFGwqaIFbYGyEF4MrbbatzSmfE8Asr/qbZJw0/KThtXfN0CiS/A8jrxSYBkDdd6GKw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe33cb0c-0784-49d4-60fb-08d837edca9e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 20:42:52.0968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UeYlW+vaDh3jhfn5VydfJ7mf5yZ3Ic2kPIG2dmXsBTIuCgjYwkrIoQQScVkX9kWUzmTUks+xWCEW8FEVYUjHFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR05MB7311
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Currently PF and VF representor netdevice carrier is always controlled
by controlling the representor netdevice device state as up/down.

Representor netdevice state change undergoes one or more txq/rxq
destroy/create commands to firmware, skb and its rx buffer allocation,
health reporters creation and more.

Due to this limitation users do not have the ability to just change
the carrier of the non uplink representors without modifying the
device state.

In one use case when the eswitch physical port carrier is down/up,
user needs to update the VF link state to same as physical port
carrier.

Example of updating VF representor carrier state:
$ ip link set enp0s8f0npf0vf0 carrier off
$ ip link set enp0s8f0npf0vf0 carrier on

This enhancement results into VF link state change which is
represented by the VF representor netdevice carrier.

This enables users to modify the representor carrier without modifying
the representor netdevice state.

A simple test is run using [1] to calculate the time difference between
updating carrier vs updating device state (to update just the carrier)
with one VF to simulate 255 VFs.

Time taken to update the carrier using device up/down:
$ time ./calculate.sh dev enp0s8f0npf0vf0
real    0m30.913s
user    0m0.200s
sys     0m11.168s

Time taken to update just the carrier using carrier iproute2 command:
$ time ./calculate.sh carrier enp0s8f0npf0vf0
real    0m2.142s
user    0m0.160s
sys     0m2.021s

Test shows that its better to use carrier on/off user interface to notify
link up/down event to VF compare to device up/down interface, because
carrier user interface delivers the same event 15 times faster.

[1] https://github.com/paravmellanox/myscripts/blob/master/calculate_carrier_time.sh

Signed-off-by: Parav Pandit <parav@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 48989541e2ef4..3db81a8cfc1d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -611,6 +611,29 @@ static struct devlink_port *mlx5e_rep_get_devlink_port(struct net_device *dev)
 	return &rpriv->dl_port;
 }
 
+static int mlx5e_rep_change_carrier(struct net_device *dev, bool new_carrier)
+{
+	struct mlx5e_priv *priv = netdev_priv(dev);
+	struct mlx5e_rep_priv *rpriv = priv->ppriv;
+	struct mlx5_eswitch_rep *rep = rpriv->rep;
+	int err;
+
+	if (new_carrier) {
+		err = mlx5_modify_vport_admin_state(priv->mdev, MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
+						    rep->vport, 1, MLX5_VPORT_ADMIN_STATE_UP);
+		if (err)
+			return err;
+		netif_carrier_on(dev);
+	} else {
+		err = mlx5_modify_vport_admin_state(priv->mdev, MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
+						    rep->vport, 1, MLX5_VPORT_ADMIN_STATE_DOWN);
+		if (err)
+			return err;
+		netif_carrier_off(dev);
+	}
+	return 0;
+}
+
 static const struct net_device_ops mlx5e_netdev_ops_rep = {
 	.ndo_open                = mlx5e_rep_open,
 	.ndo_stop                = mlx5e_rep_close,
@@ -621,6 +644,7 @@ static const struct net_device_ops mlx5e_netdev_ops_rep = {
 	.ndo_has_offload_stats	 = mlx5e_rep_has_offload_stats,
 	.ndo_get_offload_stats	 = mlx5e_rep_get_offload_stats,
 	.ndo_change_mtu          = mlx5e_rep_change_mtu,
+	.ndo_change_carrier      = mlx5e_rep_change_carrier,
 };
 
 static const struct net_device_ops mlx5e_netdev_ops_uplink_rep = {
-- 
2.26.2

