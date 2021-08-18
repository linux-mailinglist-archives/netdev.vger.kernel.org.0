Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F8F3F06A4
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 16:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238891AbhHRO0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 10:26:35 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:51264
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238445AbhHRO0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 10:26:34 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 6C04A3F09F;
        Wed, 18 Aug 2021 14:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629296758;
        bh=DTwOa3CWESrtiaTREvgjdVFPvu/DaRcGwqeFgJ0bd/w=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=wRxLVlKI66AnEPnXtp3RyH+diZ7zXcUuwsiK070puzfLo3+jmY/sZLvi/QMx1D9l4
         7osBIhWLx6VBGQWyAmffAlitNvNGMo02+XrX8myxZRqZCBZOGpN7mzDZRjr/KaxVk6
         36ybNxMcWL6eF03a0agTApUqRg6KbLYJgq8rkwrN4dUEN6uaH4dtJQqYmZaJkMzzyO
         5UZZZWt+vpbRPwP26RFrEtVbUYT3zNEXmOOT4tQVQ1NtKSYrSi0qoMgike2vW5G+pY
         gL6SUzO/ZC+MsB3CeiLC4YUpVju4eyT94+4bI5daHWP7Slf0z61Lu9CxxlvJ+g6X7o
         1eyTRIiZhpFFw==
From:   Colin King <colin.king@canonical.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vlad Buslov <vladbu@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net/mlx5: Bridge: Fix uninitialized variable err
Date:   Wed, 18 Aug 2021 15:25:58 +0100
Message-Id: <20210818142558.36722-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

A recent change removed the assignment of err to the return from
the call mlx5_esw_bridge_lower_rep_vport_num_vhca_id_get, so now
err is uninitialized. This is problematic in the switch statement
where attr-id is SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS, there
is now a possibility of err not being assigned and the function
returning a garbage value in err. Fix this by initializing err
to zero.

Addresses-Coverity; ("Uninitialized scalar variable")
Fixes: ff9b7521468b ("net/mlx5: Bridge, support LAG")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index 0c38c2e319be..4bf860f621f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -244,7 +244,7 @@ mlx5_esw_bridge_port_obj_attr_set(struct net_device *dev,
 	struct netlink_ext_ack *extack = switchdev_notifier_info_to_extack(&port_attr_info->info);
 	const struct switchdev_attr *attr = port_attr_info->attr;
 	u16 vport_num, esw_owner_vhca_id;
-	int err;
+	int err = 0;
 
 	if (!mlx5_esw_bridge_lower_rep_vport_num_vhca_id_get(dev, br_offloads->esw, &vport_num,
 							     &esw_owner_vhca_id))
-- 
2.32.0

