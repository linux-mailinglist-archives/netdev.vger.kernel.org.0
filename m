Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137975ACD93
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 10:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237186AbiIEISs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 04:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236960AbiIEISU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 04:18:20 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1073F31DDC;
        Mon,  5 Sep 2022 01:18:17 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MLhBr2f7RzmV7W;
        Mon,  5 Sep 2022 16:14:44 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 5 Sep 2022 16:18:16 +0800
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 5 Sep 2022 16:18:13 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <lipeng321@huawei.com>,
        <lanhao@huawei.com>
Subject: [PATCH net-next 2/5] net: hns3: support ndo_select_queue()
Date:   Mon, 5 Sep 2022 16:15:36 +0800
Message-ID: <20220905081539.62131-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220905081539.62131-1-huangguangbin2@huawei.com>
References: <20220905081539.62131-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support tx packets to select queue according to its dscp field after
setting dscp and tc map relationship, this patch implements
ndo_select_queue() to set skb->priority according to the user's setting
dscp and priority map relationship.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 46 +++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 481a300819ad..82f83e3f8162 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2963,6 +2963,51 @@ static int hns3_nic_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
 	return h->ae_algo->ops->set_vf_mac(h, vf_id, mac);
 }
 
+#define HNS3_INVALID_DSCP		0xff
+#define HNS3_DSCP_SHIFT			2
+
+static u8 hns3_get_skb_dscp(struct sk_buff *skb)
+{
+	__be16 protocol = skb->protocol;
+	u8 dscp = HNS3_INVALID_DSCP;
+
+	if (protocol == htons(ETH_P_8021Q))
+		protocol = vlan_get_protocol(skb);
+
+	if (protocol == htons(ETH_P_IP))
+		dscp = ipv4_get_dsfield(ip_hdr(skb)) >> HNS3_DSCP_SHIFT;
+	else if (protocol == htons(ETH_P_IPV6))
+		dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> HNS3_DSCP_SHIFT;
+
+	return dscp;
+}
+
+static u16 hns3_nic_select_queue(struct net_device *netdev,
+				 struct sk_buff *skb,
+				 struct net_device *sb_dev)
+{
+	struct hnae3_handle *h = hns3_get_handle(netdev);
+	u8 dscp, priority;
+	int ret;
+
+	if (h->kinfo.tc_map_mode != HNAE3_TC_MAP_MODE_DSCP ||
+	    !h->ae_algo->ops->get_dscp_prio)
+		goto out;
+
+	dscp = hns3_get_skb_dscp(skb);
+	if (unlikely(dscp == HNS3_INVALID_DSCP))
+		goto out;
+
+	ret = h->ae_algo->ops->get_dscp_prio(h, dscp, NULL, &priority);
+	if (ret)
+		goto out;
+
+	skb->priority = priority;
+
+out:
+	return netdev_pick_tx(netdev, skb, sb_dev);
+}
+
 static const struct net_device_ops hns3_nic_netdev_ops = {
 	.ndo_open		= hns3_nic_net_open,
 	.ndo_stop		= hns3_nic_net_stop,
@@ -2988,6 +3033,7 @@ static const struct net_device_ops hns3_nic_netdev_ops = {
 	.ndo_set_vf_link_state	= hns3_nic_set_vf_link_state,
 	.ndo_set_vf_rate	= hns3_nic_set_vf_rate,
 	.ndo_set_vf_mac		= hns3_nic_set_vf_mac,
+	.ndo_select_queue	= hns3_nic_select_queue,
 };
 
 bool hns3_is_phys_func(struct pci_dev *pdev)
-- 
2.33.0

