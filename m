Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8224C270A0E
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 04:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgISCbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 22:31:53 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13316 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbgISCbx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 22:31:53 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9B6D058F76B69594C3DB;
        Sat, 19 Sep 2020 10:31:49 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 10:31:42 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: micrel: Remove set but not used variable
Date:   Sat, 19 Sep 2020 10:32:35 +0800
Message-ID: <20200919023235.23494-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/micrel/ksz884x.c: In function rx_proc:
drivers/net/ethernet/micrel/ksz884x.c:4981:6: warning: variable ‘rx_status’ set but not used [-Wunused-but-set-variable]

drivers/net/ethernet/micrel/ksz884x.c: In function netdev_get_ethtool_stats:
drivers/net/ethernet/micrel/ksz884x.c:6512:6: warning: variable ‘rc’ set but not used [-Wunused-but-set-variable]

these variable is never used, so remove it.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/net/ethernet/micrel/ksz884x.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index bb646b65cc95..4fe8810bd06e 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -4978,7 +4978,6 @@ static inline int rx_proc(struct net_device *dev, struct ksz_hw* hw,
 	struct dev_info *hw_priv = priv->adapter;
 	struct ksz_dma_buf *dma_buf;
 	struct sk_buff *skb;
-	int rx_status;
 
 	/* Received length includes 4-byte CRC. */
 	packet_len = status.rx.frame_len - 4;
@@ -5014,7 +5013,7 @@ static inline int rx_proc(struct net_device *dev, struct ksz_hw* hw,
 	dev->stats.rx_bytes += packet_len;
 
 	/* Notify upper layer for received packet. */
-	rx_status = netif_rx(skb);
+	netif_rx(skb);
 
 	return 0;
 }
@@ -6509,7 +6508,6 @@ static void netdev_get_ethtool_stats(struct net_device *dev,
 	int i;
 	int n;
 	int p;
-	int rc;
 	u64 counter[TOTAL_PORT_COUNTER_NUM];
 
 	mutex_lock(&hw_priv->lock);
@@ -6530,19 +6528,19 @@ static void netdev_get_ethtool_stats(struct net_device *dev,
 
 	if (1 == port->mib_port_cnt && n < SWITCH_PORT_NUM) {
 		p = n;
-		rc = wait_event_interruptible_timeout(
+		wait_event_interruptible_timeout(
 			hw_priv->counter[p].counter,
 			2 == hw_priv->counter[p].read,
 			HZ * 1);
 	} else
 		for (i = 0, p = n; i < port->mib_port_cnt - n; i++, p++) {
 			if (0 == i) {
-				rc = wait_event_interruptible_timeout(
+				wait_event_interruptible_timeout(
 					hw_priv->counter[p].counter,
 					2 == hw_priv->counter[p].read,
 					HZ * 2);
 			} else if (hw->port_mib[p].cnt_ptr) {
-				rc = wait_event_interruptible_timeout(
+				wait_event_interruptible_timeout(
 					hw_priv->counter[p].counter,
 					2 == hw_priv->counter[p].read,
 					HZ * 1);
-- 
2.17.1

