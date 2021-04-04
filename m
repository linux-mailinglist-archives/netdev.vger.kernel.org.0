Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0800C353669
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 06:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbhDDEUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 00:20:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229907AbhDDEUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 00:20:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 607EC6137A;
        Sun,  4 Apr 2021 04:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617510007;
        bh=goTS5X6vx5R9KrKvidzu6h3Mb3qNtNyAXx+Jq29o2Lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZbVXa7HGMxeU/11K+i4Y3kjVlaZLv6MTx2AeUdZWfo4kx8SUJqgcN3VQet+Ou6NP
         bdi4iTyN1lhzW5WooNHty/8FSNWKUJxnMa/SxXIrI9Lsi3bunPN9od16NroKf91Otl
         Wld98e++wV/biSQELh/F4I2Q7Mez8CUK4jCVDuneae+UIiArfaV1MjrRW2hIwJJL7G
         XTOsoel6RTbdieUPYRCB8sWnYA+XDcfu8svs2aI4GtzZN8ZmfiFAl9EZlFo71zW2Hc
         LCTEYpdPtKqmFDPNuCHzCd6nZ10kbwqJAiaK5jKb3e2MiABIVjsW+8AwUBkcaK8QPt
         6HW7GKHt/yrIg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/16] net/mlx5: E-Switch, cut down mlx5_vport_info structure size by 8 bytes
Date:   Sat,  3 Apr 2021 21:19:40 -0700
Message-Id: <20210404041954.146958-3-saeed@kernel.org>
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
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 56d85cedb9bd..0adffab20244 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -118,13 +118,13 @@ struct mlx5_vport_drop_stats {
 struct mlx5_vport_info {
 	u8                      mac[ETH_ALEN];
 	u16                     vlan;
-	u8                      qos;
 	u64                     node_guid;
 	int                     link_state;
 	u32                     min_rate;
 	u32                     max_rate;
-	bool                    spoofchk;
-	bool                    trusted;
+	u8                      qos;
+	u8                      spoofchk: 1;
+	u8                      trusted: 1;
 };
 
 /* Vport context events */
-- 
2.30.2

