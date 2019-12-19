Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 729BB125BBE
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 07:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfLSG6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 01:58:04 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:51222 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726536AbfLSG5u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 01:57:50 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E8E414080D346588586C;
        Thu, 19 Dec 2019 14:57:46 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Thu, 19 Dec 2019 14:57:39 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 5/8] net: hns3: implement ndo_features_check ops for hns3 driver
Date:   Thu, 19 Dec 2019 14:57:44 +0800
Message-ID: <1576738667-37960-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576738667-37960-1-git-send-email-tanhuazhong@huawei.com>
References: <1576738667-37960-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

The function netif_skb_features() will disable the TSO feature
by using dflt_features_check() if the driver does not implement
ndo_features_check ops, which may cause performance degradation
problem when hns3 hardware can do multiple tagged TSO.

Also, the HNS3 hardware only supports checksum on the SKB with
a max header len of 480 bytes, so remove the checksum and TSO
related features when the header len is over 480 bytes.

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 32 +++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 5679a0c..840a1fb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1556,6 +1556,37 @@ static int hns3_nic_set_features(struct net_device *netdev,
 	return 0;
 }
 
+static netdev_features_t hns3_features_check(struct sk_buff *skb,
+					     struct net_device *dev,
+					     netdev_features_t features)
+{
+#define HNS3_MAX_HDR_LEN	480U
+#define HNS3_MAX_L4_HDR_LEN	60U
+
+	size_t len;
+
+	if (skb->ip_summed != CHECKSUM_PARTIAL)
+		return features;
+
+	if (skb->encapsulation)
+		len = skb_inner_transport_header(skb) - skb->data;
+	else
+		len = skb_transport_header(skb) - skb->data;
+
+	/* Assume L4 is 60 byte as TCP is the only protocol with a
+	 * a flexible value, and it's max len is 60 bytes.
+	 */
+	len += HNS3_MAX_L4_HDR_LEN;
+
+	/* Hardware only supports checksum on the skb with a max header
+	 * len of 480 bytes.
+	 */
+	if (len > HNS3_MAX_HDR_LEN)
+		features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+
+	return features;
+}
+
 static void hns3_nic_get_stats64(struct net_device *netdev,
 				 struct rtnl_link_stats64 *stats)
 {
@@ -1970,6 +2001,7 @@ static const struct net_device_ops hns3_nic_netdev_ops = {
 	.ndo_do_ioctl		= hns3_nic_do_ioctl,
 	.ndo_change_mtu		= hns3_nic_change_mtu,
 	.ndo_set_features	= hns3_nic_set_features,
+	.ndo_features_check	= hns3_features_check,
 	.ndo_get_stats64	= hns3_nic_get_stats64,
 	.ndo_setup_tc		= hns3_nic_setup_tc,
 	.ndo_set_rx_mode	= hns3_nic_set_rx_mode,
-- 
2.7.4

