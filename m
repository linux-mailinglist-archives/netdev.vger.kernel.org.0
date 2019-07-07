Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2A8614C7
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 13:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfGGLx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 07:53:27 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58842 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726518AbfGGLx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 07:53:26 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Jul 2019 14:53:19 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x67BrJLp031039;
        Sun, 7 Jul 2019 14:53:19 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        ayal@mellanox.com, jiri@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>, moshe@mellanox.com,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 02/16] net/mlx5e: Fix error flow in tx reporter diagnose
Date:   Sun,  7 Jul 2019 14:52:54 +0300
Message-Id: <1562500388-16847-3-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Fix tx reporter's diagnose call back. Propagate error when failing to
gather diagnostics information or failing to print diagnostic data per
queue.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 24626bb55598..b2bc8d8ca80e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -264,13 +264,13 @@ static int mlx5e_tx_reporter_diagnose(struct devlink_health_reporter *reporter,
 
 		err = mlx5_core_query_sq_state(priv->mdev, sq->sqn, &state);
 		if (err)
-			break;
+			goto unlock;
 
 		err = mlx5e_tx_reporter_build_diagnose_output(fmsg, sq->sqn,
 							      state,
 							      netif_xmit_stopped(sq->txq));
 		if (err)
-			break;
+			goto unlock;
 	}
 	err = devlink_fmsg_arr_pair_nest_end(fmsg);
 	if (err)
-- 
1.8.3.1

