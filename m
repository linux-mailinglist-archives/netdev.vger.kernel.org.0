Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8970181B5A
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 15:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729916AbgCKOeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 10:34:06 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43397 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729057AbgCKOeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 10:34:05 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 11 Mar 2020 16:33:59 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02BEXxtO016507;
        Wed, 11 Mar 2020 16:33:59 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next ct-offload v3 02/15] net/mlx5e: en_rep: Create uplink rep root table after eswitch offloads table
Date:   Wed, 11 Mar 2020 16:33:45 +0200
Message-Id: <1583937238-21511-3-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1583937238-21511-1-git-send-email-paulb@mellanox.com>
References: <1583937238-21511-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The eswitch offloads table, which has the reps (vport) rx miss rules,
was moved from OFFLOADS namespace [0,0] (prio, level), to [1,0], so
the restore table (the new [0,0]) can come before it. The destinations
of these miss rules is the rep root ft (ttc for non uplink reps).

Uplink rep root ft is created as OFFLOADS namespace [0,1], and is used
as a hook to next RX prio (either ethtool or ttc), but this fails to
pass fs_core level's check.

Move uplink rep root ft to OFFLOADS prio 1, level 1 ([1,1]), so it
will keep the same relative position after the restore table
change.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 3aef7faa..a33d151 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1607,6 +1607,7 @@ static int mlx5e_create_rep_root_ft(struct mlx5e_priv *priv)
 	}
 
 	ft_attr.max_fte = 0; /* Empty table, miss rule will always point to next table */
+	ft_attr.prio = 1;
 	ft_attr.level = 1;
 
 	rpriv->root_ft = mlx5_create_flow_table(ns, &ft_attr);
-- 
1.8.3.1

