Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63D72B6FA9
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731370AbgKQUHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:07:53 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1930 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731628AbgKQUHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:07:46 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb42d960000>; Tue, 17 Nov 2020 12:07:50 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Nov
 2020 20:07:43 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Wang Hai" <wanghai38@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 9/9] net/mlx5: fix error return code in mlx5e_tc_nic_init()
Date:   Tue, 17 Nov 2020 11:57:02 -0800
Message-ID: <20201117195702.386113-10-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201117195702.386113-1-saeedm@nvidia.com>
References: <20201117195702.386113-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605643670; bh=kvrzQm2EDXsRFW73B5B5OmD65b5PiaPb/wwbkvA5piU=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=DHzi3T0jFxoTZvp2ZRmI19m4G/7jFZp/c7Spq6TYFGNBdN92kLPrEZv9rXQ0aovab
         1vxgc5iJxYlXl/VKvsCNNdPLg57enLordwy5lM4NOrPi3Yr9PT16hka9aEhV6jyjRZ
         WmrNpe736bSLRNtsAO0WLtJJCAD2+omjL4hYmODAUdIPs2eMnE9gGGfQnhVi0QyIYZ
         S0D4/KbaW/cIlZTRGfDViFDWemsabb8DPNjCx0ZbmEr7K9BkSZndYXvI02tGN7p9J6
         MTIXQ25QLMj0YgsM3agcmxFrWsJN46VSR0iSWcE0edzmPa3qq+NYs/XzZOQvFLvvP/
         Vkh2v2XrpvuFw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: aedd133d17bc ("net/mlx5e: Support CT offload for tc nic flows")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 2e2fa0440032..ce710f22b1ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -5229,8 +5229,10 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
=20
 	tc->ct =3D mlx5_tc_ct_init(priv, tc->chains, &priv->fs.tc.mod_hdr,
 				 MLX5_FLOW_NAMESPACE_KERNEL);
-	if (IS_ERR(tc->ct))
+	if (IS_ERR(tc->ct)) {
+		err =3D PTR_ERR(tc->ct);
 		goto err_ct;
+	}
=20
 	tc->netdevice_nb.notifier_call =3D mlx5e_tc_netdev_event;
 	err =3D register_netdevice_notifier_dev_net(priv->netdev,
--=20
2.26.2

