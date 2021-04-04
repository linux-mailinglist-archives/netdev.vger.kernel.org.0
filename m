Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA54353672
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 06:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236964AbhDDEU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 00:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232542AbhDDEUP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 00:20:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 213D061382;
        Sun,  4 Apr 2021 04:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617510011;
        bh=YN+i2/f2wSqqlKcBi2UPjg4ATZA9ay6h6FMrSyj92Jg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=exf3GLM9tFO/0I/y0fTvq1M1PSyTJjicc4TxydOqkDdWzhbqFUMOsQxLFwD/FTuVr
         7Em396ucQuq5czG/7PbvlPaTymvkMAymSKMVRRYq4tUxCz57a7bsA1JRYVo2voxk97
         e/bX20TlkORxGzf258ooEZ7phDWfpOgAI/m3N5sVN+sPOmFMC4WY+7/R3TIi0GOmDi
         /mNNb89O/WSn0jPy2DXUgLOicInE2wNBo4QQH86N3EtJwraZvWK1NZyqhOdRe4pZSu
         KI9ILGp0pCBRtDPCeKjAqJC9NDHJeIvZ99Yxoy2zGZg0F42/RDTXGacs5waWlkRKWJ
         +YtYnb4t9lqvQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/16] net/mlx5: E-Switch, cut down mlx5_vport_info structure size by 8 bytes
Date:   Sat,  3 Apr 2021 21:19:49 -0700
Message-Id: <20210404041954.146958-12-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210404041954.146958-1-saeed@kernel.org>
References: <20210404041954.146958-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Structure mlx5_vport_info consumes 40 bytes of space due to a hole
in it. After packing it reduces to 32 bytes.

Currently:
pahole -C mlx5_vport_info drivers/net/ethernet/mellanox/mlx5/core/eswitch.o
struct mlx5_vport_info {
        u8                         mac[6];               /*     0     6 */
        u16                        vlan;                 /*     6     2 */
        u8                         qos;                  /*     8     1 */

        /* XXX 7 bytes hole, try to pack */

        u64                        node_guid;            /*    16     8 */
        int                        link_state;           /*    24     4 */
        u32                        min_rate;             /*    28     4 */
        u32                        max_rate;             /*    32     4 */
        bool                       spoofchk;             /*    36     1 */
        bool                       trusted;              /*    37     1 */

        /* size: 40, cachelines: 1, members: 9 */
        /* sum members: 31, holes: 1, sum holes: 7 */
        /* padding: 2 */
        /* last cacheline: 40 bytes */
};

After packing:

$ pahole -C mlx5_vport_info drivers/net/ethernet/mellanox/mlx5/core/eswitch.o

struct mlx5_vport_info {
        u8                         mac[6];               /*     0     6 */
        u16                        vlan;                 /*     6     2 */
        u64                        node_guid;            /*     8     8 */
        int                        link_state;           /*    16     4 */
        u32                        min_rate;             /*    20     4 */
        u32                        max_rate;             /*    24     4 */
        u8                         qos;                  /*    28     1 */
        u8                         spoofchk:1;           /*    29: 0  1 */
        u8                         trusted:1;            /*    29: 1  1 */

        /* size: 32, cachelines: 1, members: 9 */
        /* padding: 2 */
        /* bit_padding: 6 bits */
        /* last cacheline: 32 bytes */
};

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 64db903068c1..5d50b127f81a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -120,6 +120,8 @@ struct mlx5_vport_info {
 	u16                     vlan;
 	u64                     node_guid;
 	int                     link_state;
+	u32                     min_rate;
+	u32                     max_rate;
 	u8                      qos;
 	u8                      spoofchk: 1;
 	u8                      trusted: 1;
-- 
2.30.2

