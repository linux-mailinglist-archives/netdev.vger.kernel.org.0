Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86171BFD11
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbgD3OKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:10:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728152AbgD3Nvl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 09:51:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5269C24953;
        Thu, 30 Apr 2020 13:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254701;
        bh=Y+UUWSoIDCIpgXx9xE6XqRNIwYNkaFmOrUW01mRiSPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ztKeGvx8oqtlO69NVtac6yeQI4NrNmp+1ChkjKkc82MuahyoK8PrvnrvsD7/GAy8Z
         jM6f7sAjTcr7QwEhEyEBqpL7Hg93Ou/DfZgvwbDjlD3vTPQBveNbF7BVX3E0sIt6QK
         8uCL31jVwGlHC1mCOuCFlzeMiifl3kDgjykBuNKs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhu Yanjun <yanjunz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 50/79] net/mlx5e: Get the latest values from counters in switchdev mode
Date:   Thu, 30 Apr 2020 09:50:14 -0400
Message-Id: <20200430135043.19851-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <yanjunz@mellanox.com>

[ Upstream commit dcdf4ce0ff4ba206fc362e149c8ae81d6a2f849c ]

In the switchdev mode, when running "cat
/sys/class/net/NIC/statistics/tx_packets", the ppcnt register is
accessed to get the latest values. But currently this command can
not get the correct values from ppcnt.

From firmware manual, before getting the 802_3 counters, the 802_3
data layout should be set to the ppcnt register.

When the command "cat /sys/class/net/NIC/statistics/tx_packets" is
run, before updating 802_3 data layout with ppcnt register, the
monitor counters are tested. The test result will decide the
802_3 data layout is updated or not.

Actually the monitor counters do not support to monitor rx/tx
stats of 802_3 in switchdev mode. So the rx/tx counters change
will not trigger monitor counters. So the 802_3 data layout will
not be updated in ppcnt register. Finally this command can not get
the latest values from ppcnt register with 802_3 data layout.

Fixes: 5c7e8bbb0257 ("net/mlx5e: Use monitor counters for update stats")
Signed-off-by: Zhu Yanjun <yanjunz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 2650739964326..d02db5aebac45 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3568,7 +3568,12 @@ mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	struct mlx5e_vport_stats *vstats = &priv->stats.vport;
 	struct mlx5e_pport_stats *pstats = &priv->stats.pport;
 
-	if (!mlx5e_monitor_counter_supported(priv)) {
+	/* In switchdev mode, monitor counters doesn't monitor
+	 * rx/tx stats of 802_3. The update stats mechanism
+	 * should keep the 802_3 layout counters updated
+	 */
+	if (!mlx5e_monitor_counter_supported(priv) ||
+	    mlx5e_is_uplink_rep(priv)) {
 		/* update HW stats in background for next time */
 		mlx5e_queue_update_stats(priv);
 	}
-- 
2.20.1

