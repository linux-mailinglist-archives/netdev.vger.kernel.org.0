Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D357126B039
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbgIOWFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:05:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727907AbgIOU0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 16:26:52 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2153E21974;
        Tue, 15 Sep 2020 20:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600201556;
        bh=rIbuF4LBIDj3nrco7Vxo0vv2OzeqRPw/dqH/gR1Urtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dj9/Ovb2VLirUEWerTggRLTHhNKUiS0uoH3jSNuJhQeH6BTY8dS/2fF4LCwSyelUw
         Hbn/J3D36w0i5JaTTEVwDZ5Shwol2TnN1oUcn5XqCsZuBGVd3haAQdD5EfNEDA3Vcy
         c4bNfQQFPcR7pe1zHgrzd9/jilK9SPPe/maTEShQ=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/16] net/mlx5: Release clock lock before scheduling a PPS work
Date:   Tue, 15 Sep 2020 13:25:22 -0700
Message-Id: <20200915202533.64389-6-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915202533.64389-1-saeed@kernel.org>
References: <20200915202533.64389-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Holding the clock lock is not required when scheduling a PPS work.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index b62daf7b9a5c..f8465e42b238 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -581,8 +581,8 @@ static int mlx5_pps_event(struct notifier_block *nb,
 		cycles_delta = div64_u64(nsec_delta << clock->cycles.shift,
 					 clock->cycles.mult);
 		clock->pps_info.start[pin] = cycles_now + cycles_delta;
-		schedule_work(&clock->pps_info.out_work);
 		write_sequnlock_irqrestore(&clock->lock, flags);
+		schedule_work(&clock->pps_info.out_work);
 		break;
 	default:
 		mlx5_core_err(mdev, " Unhandled clock PPS event, func %d\n",
-- 
2.26.2

