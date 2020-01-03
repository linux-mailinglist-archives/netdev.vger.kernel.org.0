Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3D012F7FB
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 13:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbgACMHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 07:07:52 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8215 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727350AbgACMHw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 07:07:52 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 34DD638F00A5AB5CD926;
        Fri,  3 Jan 2020 20:07:50 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Fri, 3 Jan 2020
 20:07:39 +0800
From:   yu kuai <yukuai3@huawei.com>
To:     <netanel@amazon.com>, <saeedb@amazon.com>, <zorik@amazon.com>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <jakub.kicinski@netronome.com>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <sameehj@amazon.com>,
        <akiyano@amazon.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <yukuai3@huawei.com>, <yi.zhang@huawei.com>,
        <zhengbin13@huawei.com>
Subject: [PATCH] net: ena: remove set but not used variable 'rx_ring'
Date:   Fri, 3 Jan 2020 20:07:01 +0800
Message-ID: <20200103120701.47681-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/amazon/ena/ena_netdev.c: In function
‘ena_xdp_xmit_buff’:
drivers/net/ethernet/amazon/ena/ena_netdev.c:316:19: warning:
variable ‘rx_ring’ set but not used [-Wunused-but-set-variable]

It is never used, and so can be removed.

Signed-off-by: yu kuai <yukuai3@huawei.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 081acf077bb5..894e8c1a8cf1 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -313,7 +313,6 @@ static int ena_xdp_xmit_buff(struct net_device *dev,
 	struct ena_com_tx_ctx ena_tx_ctx = {0};
 	struct ena_tx_buffer *tx_info;
 	struct ena_ring *xdp_ring;
-	struct ena_ring *rx_ring;
 	u16 next_to_use, req_id;
 	int rc;
 	void *push_hdr;
@@ -324,8 +323,6 @@ static int ena_xdp_xmit_buff(struct net_device *dev,
 	req_id = xdp_ring->free_ids[next_to_use];
 	tx_info = &xdp_ring->tx_buffer_info[req_id];
 	tx_info->num_of_bufs = 0;
-	rx_ring = &xdp_ring->adapter->rx_ring[qid -
-		  xdp_ring->adapter->xdp_first_ring];
 	page_ref_inc(rx_info->page);
 	tx_info->xdp_rx_page = rx_info->page;
 
-- 
2.17.2

