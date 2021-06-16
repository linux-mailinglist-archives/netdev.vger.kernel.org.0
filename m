Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152CF3AA6B9
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 00:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbhFPWmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 18:42:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234004AbhFPWmf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 18:42:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA9606008E;
        Wed, 16 Jun 2021 22:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623883229;
        bh=zgXRJIhDMOKNhal8b4+HYhzgHPYYTsWiyKlldA9NKMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PEV79fbBThKMSbRC20HU25FroHlivFDezBRVC3sR70UW6cBTFBNx6j9KEQp0G+3LQ
         PSvox/Y1DEgjwD+WssUYY24LIORzJ7T2iWOKkeyI6WrsZzCS/urqOuO3d5+2pd9fa7
         elI3EcJfdGRGsUmlj1b+7xoQOtyM0QF8JO8FXgGCfIWtthgZLUWX+OvbV6CH/IRVVH
         jH4XkV29Xhp+sBzKnqZdseMvoLlYJaMhuWxp8bUSEDIT4cJhsmzww9ElMbT6ISAHoT
         OhWpzpTTGVEsgDdpB99x/pLKJPu/Q4M19/FxqQJExDpMBRKNwGVGgzk5Qbei4Bh8fF
         c6xeHHIwXO6pg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 5/8] net/mlx5: SF_DEV, remove SF device on invalid state
Date:   Wed, 16 Jun 2021 15:40:12 -0700
Message-Id: <20210616224015.14393-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210616224015.14393-1-saeed@kernel.org>
References: <20210616224015.14393-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

When auxiliary bus autoprobe is disabled and SF is in ACTIVE state,
on SF port deletion it transitions from ACTIVE->ALLOCATED->INVALID.

When VHCA event handler queries the state, it is already transition
to INVALID state.

In this scenario, event handler missed to delete the SF device.

Fix it by deleting the SF when SF state is INVALID.

Fixes: 90d010b8634b ("net/mlx5: SF, Add auxiliary device support")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
index 6a0c6f965ad1..fa0288afc0dd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
@@ -163,6 +163,7 @@ mlx5_sf_dev_state_change_handler(struct notifier_block *nb, unsigned long event_
 	sf_index = event->function_id - base_id;
 	sf_dev = xa_load(&table->devices, sf_index);
 	switch (event->new_vhca_state) {
+	case MLX5_VHCA_STATE_INVALID:
 	case MLX5_VHCA_STATE_ALLOCATED:
 		if (sf_dev)
 			mlx5_sf_dev_del(table->dev, sf_dev, sf_index);
-- 
2.31.1

