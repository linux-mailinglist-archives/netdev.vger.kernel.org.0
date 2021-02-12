Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B69B319873
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbhBLDAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 22:00:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229837AbhBLC6n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:58:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C30664E7E;
        Fri, 12 Feb 2021 02:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613098647;
        bh=69WY3t5m/esoqjxtqw864acej/9lZGJEhVUzRdDtmrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M2BJZUNijcbWqu5csWIig4ug3tWkc6DiiMQtcqCsW8W/7/Y0CUr/El6KwHUXIK9BQ
         JWKBWyNdGRFdXmufdlrL19HkaE1DQ2xwP2lnU7lDw0A/YOfDy9kgo42PVlmTgG1v4L
         p5XJbSKdBO97Z1adTRJdToIJOjt3XrayHLU7hS4RbjPyAPpO9Rci7UzCNsgZ45vRvF
         M5lZHoQTlpz9gAHZHzwrYWTwL5CKU+oxRg7lI88HzgAbxdEkFsh1K+zTvVc/Ew6T2e
         oh8GUDK80bBCpgfV+VxlbeoqDNWIEad0mt0LagbccvddBM/ACsy059ABp2tVS7Hl+W
         4QHIDnKhnTjxw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 13/15] net/mlx5: Disable devlink reload for lag devices
Date:   Thu, 11 Feb 2021 18:56:39 -0800
Message-Id: <20210212025641.323844-14-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210212025641.323844-1-saeed@kernel.org>
References: <20210212025641.323844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Devlink reload can't be allowed on lag devices since reloading one lag
device will cause traffic on the bond to get stucked.
Users who wish to reload a lag device, need to remove the device from
the bond, and only then reload it.

Fixes: 4383cfcc65e7 ("net/mlx5: Add devlink reload")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index c7073193db14..41474e42a819 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -128,6 +128,11 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 
+	if (mlx5_lag_is_active(dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "reload is unsupported in Lag mode\n");
+		return -EOPNOTSUPP;
+	}
+
 	switch (action) {
 	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
 		mlx5_unload_one(dev, false);
-- 
2.29.2

