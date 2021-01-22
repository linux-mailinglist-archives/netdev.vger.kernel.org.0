Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76FEF300438
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 14:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbhAVNbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 08:31:11 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11573 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727856AbhAVNac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 08:30:32 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DMg7G6RH5zMLXq;
        Fri, 22 Jan 2021 21:28:10 +0800 (CST)
Received: from localhost (10.174.242.175) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.498.0; Fri, 22 Jan 2021
 21:29:28 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <jerry.lilijun@huawei.com>, <xudingke@huawei.com>,
        Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net v2] ixgbe: add NULL pointer check before calling xdp_rxq_info_reg
Date:   Fri, 22 Jan 2021 21:28:25 +0800
Message-ID: <1611322105-30688-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.242.175]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

The rx_ring->q_vector could be NULL, so it needs to be checked before
calling xdp_rxq_info_reg.

Fixes: b02e5a0ebb172 ("xsk: Propagate napi_id to XDP socket Rx path")
Addresses-Coverity: ("Dereference after null check")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
v2:
  * fix commit log
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 6cbbe09ce8a0..7b76b3f448f7 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6586,8 +6586,9 @@ int ixgbe_setup_rx_resources(struct ixgbe_adapter *adapter,
 	rx_ring->next_to_use = 0;
 
 	/* XDP RX-queue info */
-	if (xdp_rxq_info_reg(&rx_ring->xdp_rxq, adapter->netdev,
-			     rx_ring->queue_index, rx_ring->q_vector->napi.napi_id) < 0)
+	if (rx_ring->q_vector && xdp_rxq_info_reg(&rx_ring->xdp_rxq, adapter->netdev,
+						  rx_ring->queue_index,
+						  rx_ring->q_vector->napi.napi_id) < 0)
 		goto err;
 
 	rx_ring->xdp_prog = adapter->xdp_prog;
-- 
2.23.0

