Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 238A213F878
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730550AbgAPQyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:54:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:39126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731921AbgAPQya (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:54:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDFCF20730;
        Thu, 16 Jan 2020 16:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193669;
        bh=SyAiXWfVg46pD08w1xZSzZgC3r0KM/T5sI+w/77cPaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zqbn4MGnB+/ceJc7SACNTa2lgIP48E9HxKnFn9SeVmRnRT+4WuyyV1HdVo3ptJRK6
         uDhfoXeLvR47HK1PjyXiAHdDcy4E8nwIgc1FIpJPh6qwMZ8FsMWt6xZ+dryaSWF4ku
         c1rh87O2vtSbRWwrgjLsATQaG9MijQWSx8Rj3GaM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roi Dayan <roid@mellanox.com>, Eli Britstein <elibr@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 195/205] net/mlx5e: Fix free peer_flow when refcount is 0
Date:   Thu, 16 Jan 2020 11:42:50 -0500
Message-Id: <20200116164300.6705-195-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

[ Upstream commit eb252c3a24fc5856fa62140c2f8269ddce6ce4e5 ]

It could be neigh update flow took a refcount on peer flow so
sometimes we cannot release peer flow even if parent flow is
being freed now.

Fixes: 5a7e5bcb663d ("net/mlx5e: Extend tc flow struct with reference counter")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Eli Britstein <elibr@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 947122c68493..96711e34d248 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1615,8 +1615,11 @@ static void __mlx5e_tc_del_fdb_peer_flow(struct mlx5e_tc_flow *flow)
 
 	flow_flag_clear(flow, DUP);
 
-	mlx5e_tc_del_fdb_flow(flow->peer_flow->priv, flow->peer_flow);
-	kfree(flow->peer_flow);
+	if (refcount_dec_and_test(&flow->peer_flow->refcnt)) {
+		mlx5e_tc_del_fdb_flow(flow->peer_flow->priv, flow->peer_flow);
+		kfree(flow->peer_flow);
+	}
+
 	flow->peer_flow = NULL;
 }
 
-- 
2.20.1

