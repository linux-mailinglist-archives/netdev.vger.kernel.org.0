Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153933652B4
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 09:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhDTHBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 03:01:13 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:17797 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhDTHBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 03:01:12 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FPZJj1w1szBrWF;
        Tue, 20 Apr 2021 14:58:13 +0800 (CST)
Received: from localhost (10.174.242.151) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0; Tue, 20 Apr 2021
 15:00:27 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <dingxiaoxiong@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net-next v2] net/mlx5e: Fix uninitialised struct field moder.comps
Date:   Tue, 20 Apr 2021 15:00:26 +0800
Message-ID: <1618902026-16588-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.242.151]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

The 'comps' struct field in 'moder' is not being initialized in
mlx5e_get_def_rx_moderation() and mlx5e_get_def_tx_moderation().
So initialize 'moder' to zero to avoid the issue.

Addresses-Coverity: ("Uninitialized scalar variable")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
v2: update mlx5e_get_def_tx_moderation() also needs fixing
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 5db63b9f3b70..17a817b7e539 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4868,7 +4868,7 @@ static bool slow_pci_heuristic(struct mlx5_core_dev *mdev)
 
 static struct dim_cq_moder mlx5e_get_def_tx_moderation(u8 cq_period_mode)
 {
-	struct dim_cq_moder moder;
+	struct dim_cq_moder moder = {};
 
 	moder.cq_period_mode = cq_period_mode;
 	moder.pkts = MLX5E_PARAMS_DEFAULT_TX_CQ_MODERATION_PKTS;
@@ -4881,7 +4881,7 @@ static struct dim_cq_moder mlx5e_get_def_tx_moderation(u8 cq_period_mode)
 
 static struct dim_cq_moder mlx5e_get_def_rx_moderation(u8 cq_period_mode)
 {
-	struct dim_cq_moder moder;
+	struct dim_cq_moder moder = {};
 
 	moder.cq_period_mode = cq_period_mode;
 	moder.pkts = MLX5E_PARAMS_DEFAULT_RX_CQ_MODERATION_PKTS;
-- 
2.23.0

