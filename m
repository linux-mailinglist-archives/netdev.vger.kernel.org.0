Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E655225988
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 09:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgGTH5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 03:57:53 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7788 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726254AbgGTH5w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 03:57:52 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 09BFAF405D2241A1E172;
        Mon, 20 Jul 2020 15:57:44 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Jul 2020
 15:57:41 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <joe@perches.com>, <shayagr@amazon.com>, <gtzalik@amazon.com>,
        <saeedb@amazon.com>, <zorik@amazon.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <sameehj@amazon.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3] net: ena: Fix using plain integer as NULL pointer in ena_init_napi_in_range
Date:   Mon, 20 Jul 2020 15:56:14 +0800
Message-ID: <20200720075614.35676-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse build warning:

drivers/net/ethernet/amazon/ena/ena_netdev.c:2193:34: warning:
 Using plain integer as NULL pointer

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Suggested-by: Joe Perches <joe@perches.com>
Acked-by: Shay Agroskin <shayagr@amazon.com>
---
v1->v2:
 Improve code readability based on Joe Perches's suggestion 
v2->v3:
 Simplify code based on Joe Perches's suggestion
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 91be3ffa1c5c..3eb63b12dd68 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2190,14 +2190,13 @@ static void ena_del_napi_in_range(struct ena_adapter *adapter,
 static void ena_init_napi_in_range(struct ena_adapter *adapter,
 				   int first_index, int count)
 {
-	struct ena_napi *napi = {0};
 	int i;
 
 	for (i = first_index; i < first_index + count; i++) {
-		napi = &adapter->ena_napi[i];
+		struct ena_napi *napi = &adapter->ena_napi[i];
 
 		netif_napi_add(adapter->netdev,
-			       &adapter->ena_napi[i].napi,
+			       &napi->napi,
 			       ENA_IS_XDP_INDEX(adapter, i) ? ena_xdp_io_poll : ena_io_poll,
 			       ENA_NAPI_BUDGET);
 
-- 
2.17.1

