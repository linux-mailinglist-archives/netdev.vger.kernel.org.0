Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD7241E4B9
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350432AbhI3XWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:22:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349850AbhI3XWm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:22:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FA48619E7;
        Thu, 30 Sep 2021 23:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633044059;
        bh=fdG55moWQ/ADGL5uRnNCIC1t+GwNJecuJgynVAxk7UE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qmse9vOU8B2kpKtuyiO8gIQLvB3XTkKkI/piYoqXObSsAm1Uz+y/6cnDmCbwPvJ0y
         YwXbiRK6aYmtHXRcjo8JKzzDhzXWS+QQfgpivtEZHAlInHQWJTnkxrWIdjIsxIxH3r
         0Ly7HMLSw942IVq19kOxKFVcOqK2ypow6l8KvmlReYWRvmI93iayrLrT2kV98+ak64
         XEnRK45uUJvxvegvvP/Hk1okmocY8+l8Tg4unLzu66IZ52oKZ5CWlz29wuCmA11y+h
         zYaHUJMafyNm6oa0rsweO2FCVU0FzsaeFB4xE88IH5ilRXLjXLJKwoy0GML1R2fFBp
         dxU5+GCkKMigA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Lama Kayal <lkayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/15] net/mlx5: Warn for devlink reload when there are VFs alive
Date:   Thu, 30 Sep 2021 16:20:46 -0700
Message-Id: <20210930232050.41779-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930232050.41779-1-saeed@kernel.org>
References: <20210930232050.41779-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lama Kayal <lkayal@nvidia.com>

When performing PF reload, VF can't communicate with FW until
it recovers and reloads as well.

Add a warning message when performing devlink reload while
VFs are still present. Thus, giving a notice of an unfavorable
behavior that might occur as a result of a consequential reloads
and cause interruption of VF recovery.

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index d7576b6fa43b..b9a6cea03951 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -136,6 +136,7 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 				    struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	struct pci_dev *pdev = dev->pdev;
 	bool sf_dev_allocated;
 
 	sf_dev_allocated = mlx5_sf_dev_allocated(dev);
@@ -153,6 +154,10 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 		return -EOPNOTSUPP;
 	}
 
+	if (pci_num_vf(pdev)) {
+		NL_SET_ERR_MSG_MOD(extack, "reload while VFs are present is unfavorable");
+	}
+
 	switch (action) {
 	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
 		mlx5_unload_one(dev);
-- 
2.31.1

