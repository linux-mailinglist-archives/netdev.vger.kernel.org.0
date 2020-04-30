Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94D11BFC6A
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgD3OFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:05:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728574AbgD3Nw7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 09:52:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC914208D5;
        Thu, 30 Apr 2020 13:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254779;
        bh=FkZ2zWP2/Oyz4STjhptqv0efeZOSnOKK3FTECYENSnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ipqwwLhxIoqdEzGr4dLLIPMtZUozEj3LC7j0sXLd3zaTTGN8LuRtVsR0iJ5vfEl9l
         jDDX8B133jwJrctp6I6gIqg1jOdvltk9KIv2YYZODErNJMqxx4wXI9SRIPFWbAz6K9
         i7YP48A02vBb7xgtRyXNKE6LbquqXqoq4zerOWOM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhu Yanjun <yanjunz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 36/57] net/mlx5e: Get the latest values from counters in switchdev mode
Date:   Thu, 30 Apr 2020 09:51:57 -0400
Message-Id: <20200430135218.20372-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135218.20372-1-sashal@kernel.org>
References: <20200430135218.20372-1-sashal@kernel.org>
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
index 88ea279c29bb8..0e340893ca002 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3579,7 +3579,12 @@ mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
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

