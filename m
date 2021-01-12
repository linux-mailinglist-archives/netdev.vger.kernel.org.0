Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5BD02F28BD
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391894AbhALHOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 02:14:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:37558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391883AbhALHOY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 02:14:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E42622CE3;
        Tue, 12 Jan 2021 07:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610435624;
        bh=PRD0C0CukMOoliU1TJTVvJ7qCD21WQBO6LpD3X7upIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R+MpJw3nv1SU6EjyvqCMk2WnXabc4URSB87dJm3AbqRkGqpDSxz6H0KdGp4v9C6qd
         tDtN4wZbdovA1dncw1RL0mp/onb528UndmZVaNbQlTG3GU9jHBLPLcpv7hq1PNPu7y
         Ti7Nw+ZP43zDQ+u8F/6TeMwDpkjMGM3xe8kjZjeQ5DkAfcDOPxq/eRr3Lcwrh2wN32
         MViLJtctv/louy+aHrCP4P14TSdyFR5TCgj4PFz2G4UMkjhP0kAjOu/K3LPdaxYkjO
         wx762ycxn5SfJ5UbB07jYVYPU8Uxc2wgh3UfmzP2x3q+9jCwpAopHSGzTdSS58Oike
         0zy9MM7wM5iKw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 02/11] net/mlx5e: Simplify condition on esw_vport_enable_qos()
Date:   Mon, 11 Jan 2021 23:05:25 -0800
Message-Id: <20210112070534.136841-3-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210112070534.136841-1-saeed@kernel.org>
References: <20210112070534.136841-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

esw->qos.enabled will only be true if both MLX5_CAP_GEN(dev, qos) and
MLX5_CAP_QOS(dev, esw_scheduling) are true. Therefore, remove them from
the condition in and rely only on esw->qos.enabled.

Fixes: 1bd27b11c1df ("net/mlx5: Introduce E-switch QoS management")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index da901e364656..876e6449edb3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1042,8 +1042,7 @@ static int esw_vport_enable_qos(struct mlx5_eswitch *esw,
 	void *vport_elem;
 	int err = 0;
 
-	if (!esw->qos.enabled || !MLX5_CAP_GEN(dev, qos) ||
-	    !MLX5_CAP_QOS(dev, esw_scheduling))
+	if (!esw->qos.enabled)
 		return 0;
 
 	if (vport->qos.enabled)
-- 
2.26.2

