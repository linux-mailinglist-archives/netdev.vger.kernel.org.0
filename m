Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960C239DC13
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 14:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFGMSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 08:18:33 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7127 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhFGMSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 08:18:32 -0400
Received: from dggeme766-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FzC2k5bF6zYspX;
        Mon,  7 Jun 2021 20:13:50 +0800 (CST)
Received: from huawei.com (10.175.113.133) by dggeme766-chm.china.huawei.com
 (10.3.19.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 7 Jun
 2021 20:16:38 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <ast@kernel.org>, <kuba@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <jeffrey.t.kirsher@intel.com>,
        <jan.sokolowski@intel.com>, <magnus.karlsson@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] ixgbe, xsk: clean up the resources in ixgbe_xsk_pool_enable error path
Date:   Mon, 7 Jun 2021 20:26:44 +0800
Message-ID: <20210607122644.59021-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme766-chm.china.huawei.com (10.3.19.112)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ixgbe_xsk_pool_enable(), if ixgbe_xsk_wakeup() fails,
We should restore the previous state and clean up the
resources. Add the missing clear af_xdp_zc_qps and unmap dma
to fix this bug.

Fixes: d49e286d354e ("ixgbe: add tracking of AF_XDP zero-copy state for each queue pair")
Fixes: 4a9b32f30f80 ("ixgbe: fix potential RX buffer starvation for AF_XDP")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 91ad5b902673..d912f14d2ba4 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -52,8 +52,11 @@ static int ixgbe_xsk_pool_enable(struct ixgbe_adapter *adapter,
 
 		/* Kick start the NAPI context so that receiving will start */
 		err = ixgbe_xsk_wakeup(adapter->netdev, qid, XDP_WAKEUP_RX);
-		if (err)
+		if (err) {
+			clear_bit(qid, adapter->af_xdp_zc_qps);
+			xsk_pool_dma_unmap(pool, IXGBE_RX_DMA_ATTR);
 			return err;
+		}
 	}
 
 	return 0;
-- 
2.17.1

