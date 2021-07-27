Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1583D83D1
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 01:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbhG0XVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 19:21:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232817AbhG0XUz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 19:20:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67E3F60FBF;
        Tue, 27 Jul 2021 23:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627428054;
        bh=A31QcYY0yKwOqn3XXZ/5B7p6MdKQilU/7ih9lbWpakc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LukqI6MPAGOOU8Q4l7nTzsVEOh8kaw6P7AWe2/ERLlFOkeY1+yMSr6adJRAXuYi84
         D2G9619XnYRw9hmE4SkUW4QkxUGp5qp7eQEdNixjRzxQmvy6kaxk4biQGwc1pqrMuM
         PiH8QAMuSRXbHPLlpPiAS49PaYPYJC/pzKFwuNgVFoEyaIePmvZxa0PAkSfXs8SBWO
         y39U3rSP/e5YPVIKWvt/N6oCZIMzmeJc6HgUoQSS2VInyCAqX0+W749nEpKhBRHyop
         VZ5qs3d9tpsSgVw6Nc4RoudCg/o6lBMbqAZ/1lqUlWp7MTnMofLSqPAZMBkmvgm8gC
         xekXx8cX0R+kg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 04/12] net/mlx5: E-Switch, handle devcom events only for ports on the same device
Date:   Tue, 27 Jul 2021 16:20:42 -0700
Message-Id: <20210727232050.606896-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210727232050.606896-1-saeed@kernel.org>
References: <20210727232050.606896-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

This is the same check as LAG mode checks if to enable lag.
This will fix adding peer miss rules if lag is not supported
and even an incorrect rules in socket direct mode.

Also fix the incorrect comment on mlx5_get_next_phys_dev() as flow #1
doesn't exists.

Fixes: ac004b832128 ("net/mlx5e: E-Switch, Add peer miss rules")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c              | 5 +----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 3 +++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index ceebfc20f65e..def2156e50ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -500,10 +500,7 @@ static int next_phys_dev(struct device *dev, const void *data)
 	return 1;
 }
 
-/* This function is called with two flows:
- * 1. During initialization of mlx5_core_dev and we don't need to lock it.
- * 2. During LAG configure stage and caller holds &mlx5_intf_mutex.
- */
+/* Must be called with intf_mutex held */
 struct mlx5_core_dev *mlx5_get_next_phys_dev(struct mlx5_core_dev *dev)
 {
 	struct auxiliary_device *adev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index b0a2ca9037ac..011e766e4f67 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2368,6 +2368,9 @@ static int mlx5_esw_offloads_devcom_event(int event,
 
 	switch (event) {
 	case ESW_OFFLOADS_DEVCOM_PAIR:
+		if (mlx5_get_next_phys_dev(esw->dev) != peer_esw->dev)
+			break;
+
 		if (mlx5_eswitch_vport_match_metadata_enabled(esw) !=
 		    mlx5_eswitch_vport_match_metadata_enabled(peer_esw))
 			break;
-- 
2.31.1

