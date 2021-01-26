Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491453050D8
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238783AbhA0E3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:29:02 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5318 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389807AbhA0AJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 19:09:30 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a9810001>; Tue, 26 Jan 2021 15:45:05 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:45:04 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 04/12] net/mlx5e: Reduce tc unsupported key print level
Date:   Tue, 26 Jan 2021 15:43:37 -0800
Message-ID: <20210126234345.202096-5-saeedm@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126234345.202096-1-saeedm@nvidia.com>
References: <20210126234345.202096-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611704705; bh=KNqsRppoRR8Z/pHvGyCv+bh9Q04D7unmLyhyCdrwzMQ=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=kaBepdyzXBiZOE/FZFEJoka5QkQ/3dsGqq0EKprjRCAeaYcfYqi6PPLYL7Xcbw6wb
         XXrsqXyxQNL8UrFXPmdxH0PSoSQ3JMum75g8vpv23k0yXw1J9/7Xt1f2aQ7nMCrYIq
         xSNWdtKomjX0+TArPEBHnEqMn1kCIW8RwkQJPfKb7Enb0/pSHdWd4p5Xdh6/lWhY45
         DhF2lmsvRum/l5a/LXAxMYBydPL1oppDkMnKd7f5iwiNwXucZ7i+ayK6QuFjnXcyi2
         vPpFiDsYsMdBS5YzY8OWeDadIAx5ZCz/oIvRM52j6sxnz3K54DW6puittDsGIzmPZL
         t45fqrbUevKTA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

"Unsupported key used:" appears in kernel log when flows with
unsupported key are used, arp fields for example.

OpenVSwitch was changed to match on arp fields by default that
caused this warning to appear in kernel log for every arp rule, which
can be a lot.

Fix by lowering print level from warning to debug.

Fixes: e3a2b7ed018e ("net/mlx5e: Support offload cls_flower with drop actio=
n")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 661235027b47..f4ce5e208e02 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2270,8 +2270,8 @@ static int __parse_cls_flower(struct mlx5e_priv *priv=
,
 	      BIT(FLOW_DISSECTOR_KEY_ENC_OPTS) |
 	      BIT(FLOW_DISSECTOR_KEY_MPLS))) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported key");
-		netdev_warn(priv->netdev, "Unsupported key used: 0x%x\n",
-			    dissector->used_keys);
+		netdev_dbg(priv->netdev, "Unsupported key used: 0x%x\n",
+			   dissector->used_keys);
 		return -EOPNOTSUPP;
 	}
=20
--=20
2.29.2

