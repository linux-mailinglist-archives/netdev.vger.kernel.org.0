Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A47095C9F5
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 09:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbfGBHaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 03:30:12 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35052 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725845AbfGBHaM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 03:30:12 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D5C8F26AC966FD5D207D;
        Tue,  2 Jul 2019 15:30:08 +0800 (CST)
Received: from localhost.localdomain (10.175.34.53) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Tue, 2 Jul 2019 15:29:57 +0800
From:   Xue Chaojing <xuechaojing@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoshaokai@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <xuechaojing@huawei.com>, <chiqijun@huawei.com>,
        <wulike1@huawei.com>
Subject: [PATCH net-next] hinic: remove standard netdev stats
Date:   Mon, 1 Jul 2019 23:40:00 +0000
Message-ID: <20190701234000.31738-1-xuechaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.34.53]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes standard netdev stats in ethtool -S.

Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Xue Chaojing <xuechaojing@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_ethtool.c | 47 +------------------
 1 file changed, 1 insertion(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index 8d98f37c88a8..73a20f01ad4c 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -440,35 +440,6 @@ static u32 hinic_get_rxfh_indir_size(struct net_device *netdev)
 
 #define ARRAY_LEN(arr) ((int)((int)sizeof(arr) / (int)sizeof(arr[0])))
 
-#define HINIC_NETDEV_STAT(_stat_item) { \
-	.name = #_stat_item, \
-	.size = FIELD_SIZEOF(struct rtnl_link_stats64, _stat_item), \
-	.offset = offsetof(struct rtnl_link_stats64, _stat_item) \
-}
-
-static struct hinic_stats hinic_netdev_stats[] = {
-	HINIC_NETDEV_STAT(rx_packets),
-	HINIC_NETDEV_STAT(tx_packets),
-	HINIC_NETDEV_STAT(rx_bytes),
-	HINIC_NETDEV_STAT(tx_bytes),
-	HINIC_NETDEV_STAT(rx_errors),
-	HINIC_NETDEV_STAT(tx_errors),
-	HINIC_NETDEV_STAT(rx_dropped),
-	HINIC_NETDEV_STAT(tx_dropped),
-	HINIC_NETDEV_STAT(multicast),
-	HINIC_NETDEV_STAT(collisions),
-	HINIC_NETDEV_STAT(rx_length_errors),
-	HINIC_NETDEV_STAT(rx_over_errors),
-	HINIC_NETDEV_STAT(rx_crc_errors),
-	HINIC_NETDEV_STAT(rx_frame_errors),
-	HINIC_NETDEV_STAT(rx_fifo_errors),
-	HINIC_NETDEV_STAT(rx_missed_errors),
-	HINIC_NETDEV_STAT(tx_aborted_errors),
-	HINIC_NETDEV_STAT(tx_carrier_errors),
-	HINIC_NETDEV_STAT(tx_fifo_errors),
-	HINIC_NETDEV_STAT(tx_heartbeat_errors),
-};
-
 #define HINIC_FUNC_STAT(_stat_item) {	\
 	.name = #_stat_item, \
 	.size = FIELD_SIZEOF(struct hinic_vport_stats, _stat_item), \
@@ -658,20 +629,11 @@ static void hinic_get_ethtool_stats(struct net_device *netdev,
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 	struct hinic_vport_stats vport_stats = {0};
-	const struct rtnl_link_stats64 *net_stats;
 	struct hinic_phy_port_stats *port_stats;
-	struct rtnl_link_stats64 temp;
 	u16 i = 0, j = 0;
 	char *p;
 	int err;
 
-	net_stats = dev_get_stats(netdev, &temp);
-	for (j = 0; j < ARRAY_LEN(hinic_netdev_stats); j++, i++) {
-		p = (char *)net_stats + hinic_netdev_stats[j].offset;
-		data[i] = (hinic_netdev_stats[j].size ==
-				sizeof(u64)) ? *(u64 *)p : *(u32 *)p;
-	}
-
 	err = hinic_get_vport_stats(nic_dev, &vport_stats);
 	if (err)
 		netif_err(nic_dev, drv, netdev,
@@ -716,8 +678,7 @@ static int hinic_get_sset_count(struct net_device *netdev, int sset)
 	switch (sset) {
 	case ETH_SS_STATS:
 		q_num = nic_dev->num_qps;
-		count = ARRAY_LEN(hinic_netdev_stats) +
-			ARRAY_LEN(hinic_function_stats) +
+		count = ARRAY_LEN(hinic_function_stats) +
 			(ARRAY_LEN(hinic_tx_queue_stats) +
 			ARRAY_LEN(hinic_rx_queue_stats)) * q_num;
 
@@ -738,12 +699,6 @@ static void hinic_get_strings(struct net_device *netdev,
 
 	switch (stringset) {
 	case ETH_SS_STATS:
-		for (i = 0; i < ARRAY_LEN(hinic_netdev_stats); i++) {
-			memcpy(p, hinic_netdev_stats[i].name,
-			       ETH_GSTRING_LEN);
-			p += ETH_GSTRING_LEN;
-		}
-
 		for (i = 0; i < ARRAY_LEN(hinic_function_stats); i++) {
 			memcpy(p, hinic_function_stats[i].name,
 			       ETH_GSTRING_LEN);
-- 
2.17.1

