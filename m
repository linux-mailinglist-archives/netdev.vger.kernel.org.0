Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C06A1F2C76
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgFHXRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:17:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730377AbgFHXQ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:16:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC5D02083E;
        Mon,  8 Jun 2020 23:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658217;
        bh=MjL6Vdhzate10lRynbI9YZLl5Beep4bbfnO2HAisn9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WH1QCj4QbeWxRtDTRKCVlpcFcoWzcGjxG+uy5tRvha7YP9dtg+ZJj5Da1p4brvMG3
         gY75yxvJ/bh/gIjv9ij/s2OKXJCnMDzucELr+d27w0Ib/4lQBalyWDI+wPjMDrK9mD
         S4LSm8w8xg76vVhNhcZYN203FM3TtJujcQcXHXbk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shay Drory <shayd@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 233/606] net/mlx5: Fix error flow in case of function_setup failure
Date:   Mon,  8 Jun 2020 19:05:58 -0400
Message-Id: <20200608231211.3363633-233-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@mellanox.com>

[ Upstream commit 4f7400d5cbaef676e00cdffb0565bf731c6bb09e ]

Currently, if an error occurred during mlx5_function_setup(), we
keep dev->state as DEVICE_STATE_UP.
Fixing it by adding a goto label.

Fixes: e161105e58da ("net/mlx5: Function setup/teardown procedures")
Signed-off-by: Shay Drory <shayd@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index f554cfddcf4e..7d67268ff686 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1179,7 +1179,7 @@ int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 
 	err = mlx5_function_setup(dev, boot);
 	if (err)
-		goto out;
+		goto err_function;
 
 	if (boot) {
 		err = mlx5_init_once(dev);
@@ -1225,6 +1225,7 @@ int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 		mlx5_cleanup_once(dev);
 function_teardown:
 	mlx5_function_teardown(dev, boot);
+err_function:
 	dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
 	mutex_unlock(&dev->intf_state_mutex);
 
-- 
2.25.1

