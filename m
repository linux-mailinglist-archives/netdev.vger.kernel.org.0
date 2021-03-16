Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E9B33E267
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhCPXvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:51:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229613AbhCPXvV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 19:51:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A27A64F18;
        Tue, 16 Mar 2021 23:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615938681;
        bh=OpZVJcRscMUbx/d75cmrAZiI+0OrjmAG/7gJMxOHkYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNFcUl9Co0IJmyTsSELC8UDiszOKY35+49xmaF3ZYD/W0ezFgZ+kSmPw/7A2jPUMO
         6AcewKeilNEXF41mxUUXa8gEzTZxFMN2SxzVfHjdIZtuVFg/AjH0e3zpIFPPo0zIJa
         Wo2l/Ut0JKUoHI1ykSYUKTK4Z8cOcJTpWbwkYuanXNYZVV3hQentPy05pw3EpxV+n+
         rPT0GN+LMH0+w1qDtQK/JslPHFrtiH/2KAqYysrFB2PZ6wmELf9R/s+U8+rqsO/U7d
         rAya332sS7wG00NiZXUCCA79Frq8wytD1/Z1S3IbFn/P/JEO60XQVPecVeZs+4gE4H
         Hma8YKd6kRi2g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/15] net/mlx5e: Unregister eth-reps devices first
Date:   Tue, 16 Mar 2021 16:51:09 -0700
Message-Id: <20210316235112.72626-13-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316235112.72626-1-saeed@kernel.org>
References: <20210316235112.72626-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

When we clean all the interfaces, i.e. rescan or reload module,
we need to clean eth-reps devices first, before eth devices.

We will re-use the native NIC port net device instance for the Uplink
representor. Changing eswitch mode will skip destroying the eth device
so the net device won't be destroyed and only change the profile.

Creating uplink eth-rep will initialize the representor related resources.
In that sense when we destroy all devices we first need to destroy
eth-rep devices so uplink eth-rep will clean all representor related
resources and only then destroy the eth device which will destroy rest
of the resources and the net device.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 2f961bd9e528..685cf071a9de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5900,18 +5900,18 @@ int mlx5e_init(void)
 
 	mlx5e_ipsec_build_inverse_table();
 	mlx5e_build_ptys2ethtool_map();
-	ret = mlx5e_rep_init();
+	ret = auxiliary_driver_register(&mlx5e_driver);
 	if (ret)
 		return ret;
 
-	ret = auxiliary_driver_register(&mlx5e_driver);
+	ret = mlx5e_rep_init();
 	if (ret)
-		mlx5e_rep_cleanup();
+		auxiliary_driver_unregister(&mlx5e_driver);
 	return ret;
 }
 
 void mlx5e_cleanup(void)
 {
-	auxiliary_driver_unregister(&mlx5e_driver);
 	mlx5e_rep_cleanup();
+	auxiliary_driver_unregister(&mlx5e_driver);
 }
-- 
2.30.2

