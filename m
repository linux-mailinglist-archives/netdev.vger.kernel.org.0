Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 874591195D5
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbfLJVKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:10:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:60868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728569AbfLJVKl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDE9E24680;
        Tue, 10 Dec 2019 21:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012240;
        bh=vTjg/RaaCMcAwjFaHwFXNC0CgLTYifL+R2P8rT8olCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=un5jo4qTCIHSWUEDrpOmD4pBcSvL4L5XPDhLRFszwctBj/bgX+2oAi/MJr9ghu2yV
         mElMDDgbuoeV+0fvRnCe4DBcOMliBU9wVopowDK6/DL2JfFoAVhKRFpf27XVMNLgeT
         NBH/YCtXUi0WTGUUwwfsNpvdnTB21GCfAaSG680o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 189/350] net/mlx5e: Verify that rule has at least one fwd/drop action
Date:   Tue, 10 Dec 2019 16:04:54 -0500
Message-Id: <20191210210735.9077-150-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

[ Upstream commit ae2741e2b6ce2bf1b656b1152c4ef147ff35b096 ]

Currently, mlx5 tc layer doesn't verify that rule has at least one forward
or drop action which leads to following firmware syndrome when user tries
to offload such action:

[ 1824.860501] mlx5_core 0000:81:00.0: mlx5_cmd_check:753:(pid 29458): SET_FLOW_TABLE_ENTRY(0x936) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x144b7a)

Add check at the end of parse_tc_fdb_actions() that verifies that resulting
attribute has action fwd or drop flag set.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index f90a9f8e0fc6a..1e8bffebc4cff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3443,6 +3443,12 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	}
 
+	if (!(attr->action &
+	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP))) {
+		NL_SET_ERR_MSG(extack, "Rule must have at least one forward/drop action");
+		return -EOPNOTSUPP;
+	}
+
 	if (attr->split_count > 0 && !mlx5_esw_has_fwd_fdb(priv->mdev)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "current firmware doesn't support split rule for port mirroring");
-- 
2.20.1

