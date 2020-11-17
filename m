Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 662082B6FA4
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731624AbgKQUHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:07:46 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1928 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731598AbgKQUHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:07:43 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb42d930000>; Tue, 17 Nov 2020 12:07:47 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Nov
 2020 20:07:42 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Eli Cohen" <elic@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 8/9] net/mlx5: E-Switch, Fail mlx5_esw_modify_vport_rate if qos disabled
Date:   Tue, 17 Nov 2020 11:57:01 -0800
Message-ID: <20201117195702.386113-9-saeedm@nvidia.com>
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
        t=1605643667; bh=xonxW2t1xct0pu7jYfEgYmtu2hyyxkxxVznxDn89AAw=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=eU8EbgyyGMz8nfWwRLN/f25VKKnhOwV2e9Ipj5qEB+qV+il9R+LE8LuRk4L8jGjRA
         ifoVVtOch01nosMJPCkZxX3BzQjrN6Ww8AYTG7n+QRzlii3LU/iNQ7z0fUcC+Rrs1l
         SOMILa4pz07QfeE6bUjbVY9g7SNm0QmL8ZOydYekv//r8Q+byea05OsUSD0y+azl8C
         3fVWcvSIRYoAutLnX9NMXaLqDA1yDojgTN2QL5+e1R42mqkGJAbp2aOw3xduvBTGko
         TyM2l1mWQs35du3qSQNgLmmaWSduL7hKlM0HmXB/ipfZKRA+4w51smSVHleDMBxOcI
         FLnTKzOgpmJKQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Avoid calling mlx5_esw_modify_vport_rate() if qos is not enabled and
avoid unnecessary syndrome messages from firmware.

Fixes: fcb64c0f5640 ("net/mlx5: E-Switch, add ingress rate support")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 5ad2308a2a6b..d4ee0a9c03db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1142,6 +1142,10 @@ int mlx5_esw_modify_vport_rate(struct mlx5_eswitch *=
esw, u16 vport_num,
 	struct mlx5_vport *vport;
=20
 	vport =3D mlx5_eswitch_get_vport(esw, vport_num);
+
+	if (!vport->qos.enabled)
+		return -EOPNOTSUPP;
+
 	MLX5_SET(scheduling_context, ctx, max_average_bw, rate_mbps);
=20
 	return mlx5_modify_scheduling_element_cmd(esw->dev,
--=20
2.26.2

