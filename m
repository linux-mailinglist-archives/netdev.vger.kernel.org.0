Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE23A2B6FA5
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731089AbgKQUHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:07:47 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1921 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731562AbgKQUHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:07:42 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb42d920000>; Tue, 17 Nov 2020 12:07:46 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Nov
 2020 20:07:41 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 6/9] net/mlx5: Clear bw_share upon VF disable
Date:   Tue, 17 Nov 2020 11:56:59 -0800
Message-ID: <20201117195702.386113-7-saeedm@nvidia.com>
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
        t=1605643666; bh=9p1Jrc1uA4CvMtjg+mBLWtEu4eOaKXe0Nl82NrJxTaM=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Epx4v9pMaJgg/I2jmO18MSbZzF3GTyFafIuRrqvHNXmByTVaGexnz1OdfeiH2K4b+
         U27ns63ouiwrvJxPrg4c9cGJQt0GvMYNAD18Rp07C6BMvjVijbym2eUFzu43TrhX3W
         9ouiL4Mr1ozDU0ZLiboX+94e0x9ftCL6kAhzDWL1XUCAh19nspXfguHLv/BQ9glt/9
         oPpOdayDCTsjNngDXVFwGsOvKMTYhO7kgWksz5DBuKqfk4owmgIijHcc+cxx+uVMzp
         IGwiRjRY3qpG4IzDYXfkjCIgLcN+NlrQv7kzH3oztwA1LE3MiNaPnD7p9aZQZd8IwT
         IslBtvvu1QVkA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

Currently, if user disables VFs with some min and max rates configured,
they are cleared. But QoS data is not cleared and restored upon next VF
enable placing limits on minimal rate for given VF, when user expects
none.

To match cleared vport->info struct with QoS-related min and max rates
upon VF disable, clear vport->qos struct too.

Fixes: 556b9d16d3f5 ("net/mlx5: Clear VF's configuration on disabling SRIOV=
")
Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index e8e6294c7cca..6562f4d484e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1408,6 +1408,7 @@ static void mlx5_eswitch_clear_vf_vports_info(struct =
mlx5_eswitch *esw)
 	int i;
=20
 	mlx5_esw_for_each_vf_vport(esw, i, vport, esw->esw_funcs.num_vfs) {
+		memset(&vport->qos, 0, sizeof(vport->qos));
 		memset(&vport->info, 0, sizeof(vport->info));
 		vport->info.link_state =3D MLX5_VPORT_ADMIN_STATE_AUTO;
 	}
--=20
2.26.2

