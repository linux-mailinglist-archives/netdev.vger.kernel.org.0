Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F81313F6AA
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389902AbgAPTGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:06:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:53078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388146AbgAPRBl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:01:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78DDE207FF;
        Thu, 16 Jan 2020 17:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194100;
        bh=GhkAe2zMQTLuD474ErZ/Me1pHST6ZgL9D3RwQAoHn7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LO7eXqfRYz59eZLpguPf6nWIiHEUdQZV0ywtvDTnzInYBFyCHuE7ww3zuo6nNIIoS
         /ozFr2lnb77ev3iUKkRJn+Y3n955N/pL/dacG7hB13ROAFNo3RG31pdlmmgTPgF5ww
         3Rmubpy8gaTDlg6MBbUKy6yCs5SMbRnq+B7Yj6gM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 201/671] net/mlx5: Delete unused FPGA QPN variable
Date:   Thu, 16 Jan 2020 11:51:50 -0500
Message-Id: <20200116165940.10720-84-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit 566428375a53619196e31803130dd1a7010c4d7f ]

fpga_qpn was assigned but never used and compilation with W=1
produced the following warning:

drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c: In function _mlx5_fpga_event_:
drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c:320:6: warning:
variable _fpga_qpn_ set but not used [-Wunused-but-set-variable]
  u32 fpga_qpn;
      ^~~~~~~~

Fixes: 98db16bab59f ("net/mlx5: FPGA, Handle QP error event")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
index 436a8136f26f..310f9e7d8320 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/core.c
@@ -289,7 +289,6 @@ void mlx5_fpga_event(struct mlx5_core_dev *mdev, u8 event, void *data)
 	const char *event_name;
 	bool teardown = false;
 	unsigned long flags;
-	u32 fpga_qpn;
 	u8 syndrome;
 
 	switch (event) {
@@ -300,7 +299,6 @@ void mlx5_fpga_event(struct mlx5_core_dev *mdev, u8 event, void *data)
 	case MLX5_EVENT_TYPE_FPGA_QP_ERROR:
 		syndrome = MLX5_GET(fpga_qp_error_event, data, syndrome);
 		event_name = mlx5_fpga_qp_syndrome_to_string(syndrome);
-		fpga_qpn = MLX5_GET(fpga_qp_error_event, data, fpga_qpn);
 		break;
 	default:
 		mlx5_fpga_warn_ratelimited(fdev, "Unexpected event %u\n",
-- 
2.20.1

