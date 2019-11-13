Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA15FA352
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730262AbfKMB7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:59:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727741AbfKMB7V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:59:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99CE322490;
        Wed, 13 Nov 2019 01:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610361;
        bh=SUtoJuBQ0kWFqFHCogcPBI0EufRGC1iwfMg31fJcoOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JlhNHwoKn0CHEhCjZzql2GLWeqXxxoch/YxB8/c/YIhBUf2CSlJrNT8LOvekQUQsr
         kEsb/33qBJSm0QUXOoSAXAJ0WsdKAzllw1yJL2EgaLxA1bhX/Q4nIs0Y6cCWp6nlcG
         WQIKlkdj2KbzoBgSPOwDaweS8iRQFOLhtVFvaBW4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 111/115] mlxsw: spectrum_switchdev: Check notification relevance based on upper device
Date:   Tue, 12 Nov 2019 20:56:18 -0500
Message-Id: <20191113015622.11592-111-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

[ Upstream commit 5050f6ae253ad1307af3486c26fc4f94287078b7 ]

VxLAN FDB updates are sent with the VxLAN device which is not our upper
and will therefore be ignored by current code.

Solve this by checking whether the upper device (bridge) is our upper.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 8a1788108f52a..698de51b3fef0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -1939,8 +1939,15 @@ static int mlxsw_sp_switchdev_event(struct notifier_block *unused,
 	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
 	struct mlxsw_sp_switchdev_event_work *switchdev_work;
 	struct switchdev_notifier_fdb_info *fdb_info = ptr;
+	struct net_device *br_dev;
 
-	if (!mlxsw_sp_port_dev_lower_find_rcu(dev))
+	/* Tunnel devices are not our uppers, so check their master instead */
+	br_dev = netdev_master_upper_dev_get_rcu(dev);
+	if (!br_dev)
+		return NOTIFY_DONE;
+	if (!netif_is_bridge_master(br_dev))
+		return NOTIFY_DONE;
+	if (!mlxsw_sp_port_dev_lower_find_rcu(br_dev))
 		return NOTIFY_DONE;
 
 	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
-- 
2.20.1

