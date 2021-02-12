Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1371E31986F
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhBLC7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:59:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:50010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229809AbhBLC6n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:58:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCB0664E85;
        Fri, 12 Feb 2021 02:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613098645;
        bh=ivbqKM28nFAHJXo6FKMHJyNbwgXQGqilB0pHVrkHTfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DlF11FVDIaMpObZdlg+KPzjIMAKSPBV8+N4QqYA4wPbfL/oOb2FBiwivof79NF/Ky
         GvBucKjQ2PEaOo3tgMvuhx8e6NBScPXnJ8pBqpfi9j7vu16QvO5Vri251uqI7raIMG
         PQeLeZAyVrIKIEO1peR+Wo9iM8+RCLi+2CNB6VJleyLMIkmQ1vLnpJPHKU7gKvPACd
         VRJOPHA5BKNkBzXrbaRYH/VdZHTBrGWHuObe7q6+JFFnrEIzmsjAj8fLijv3X6EMLK
         6yU+0NJTsU1q48F7ld9F9r7FzmydXNo2G5HJSLXWJe2T9IuYuMwmLbT1oEO/5E//hR
         gO6dedbi7XGmg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 10/15] net/mlx5: Disable devlink reload for multi port slave device
Date:   Thu, 11 Feb 2021 18:56:36 -0800
Message-Id: <20210212025641.323844-11-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210212025641.323844-1-saeed@kernel.org>
References: <20210212025641.323844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Devlink reload can't be allowed on a multi port slave device, because
reload of slave device doesn't take effect.

The right flow is to disable devlink reload for multi port slave
device. Hence, disabling it in mlx5_core probing.

Fixes: 4383cfcc65e7 ("net/mlx5: Add devlink reload")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index ca6f2fc39ea0..ba1a4ae28097 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1396,7 +1396,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		dev_err(&pdev->dev, "mlx5_crdump_enable failed with error code %d\n", err);
 
 	pci_save_state(pdev);
-	devlink_reload_enable(devlink);
+	if (!mlx5_core_is_mp_slave(dev))
+		devlink_reload_enable(devlink);
 	return 0;
 
 err_load_one:
-- 
2.29.2

