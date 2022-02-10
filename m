Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5228F4B179C
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 22:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344640AbiBJVeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 16:34:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238886AbiBJVeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 16:34:00 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18E3102F;
        Thu, 10 Feb 2022 13:34:00 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21AKAGMs023570;
        Thu, 10 Feb 2022 13:33:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=qCzCSgS0EvHYLfG1a4cFRdi+ByR03+ywpwbAO77w7aE=;
 b=GiD3KhiOR4Fnj+jw8/PMfvFJ6zsCiDzxgnGpdIcgQM8HYXtt9G3rhz0V7cU4fcI5Boea
 l5okZ4TB0kRE54aiAaB6vGHsHVz5SztIIVuWygwmq2rAqT41sAXYLXXEGtqpsEilw83N
 znRoAS9jMGwdm/gGf5/vkpm129Fhu4T+InH1Q5KzkNkEIS5vPL7IBoMvDbAE0Wh1S7xg
 5iceir3aNTUFVyocz9DADo2F35WyBrhM2ipyTFFuvgi44rzfaHMKAlzcBf5oFpQyBKNe
 Q3s2ebtOOf/Bzvni39+vy0dZudo4/HMa94q2woU4H7yTfqaNiyYyADqmO7tGrAzu3sKe xA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3e5134ap32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 10 Feb 2022 13:33:49 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Feb
 2022 13:33:47 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 10 Feb 2022 13:33:47 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 79EC83F706D;
        Thu, 10 Feb 2022 13:33:47 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <vburru@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <corbet@lwn.net>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Abhijit Ayarekar <aayarekar@marvell.com>,
        Satananda Burla <sburla@marvell.com>
Subject: [PATCH 2/4] octeon_ep: add support for ndo ops.
Date:   Thu, 10 Feb 2022 13:33:04 -0800
Message-ID: <20220210213306.3599-3-vburru@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220210213306.3599-1-vburru@marvell.com>
References: <20220210213306.3599-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 4w-enySeltePAw64fh59oMVrTpBV94o6
X-Proofpoint-ORIG-GUID: 4w-enySeltePAw64fh59oMVrTpBV94o6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-10_10,2022-02-09_01,2021-12-02_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for ndo ops to set MAC address, change MTU, get stats.
Add control path support to set MAC address, change MTU, get stats,
set speed, get and set link mode.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
Signed-off-by: Satananda Burla <sburla@marvell.com>
---
 .../marvell/octeon_ep/octep_ctrl_net.c        | 105 ++++++++++++++++++
 .../ethernet/marvell/octeon_ep/octep_main.c   |  67 +++++++++++
 2 files changed, 172 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
index 1f0d8ba3c8ee..be9b0f31c754 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
@@ -87,3 +87,108 @@ int octep_get_mac_addr(struct octep_device *oct, u8 *addr)
 
 	return 0;
 }
+
+int octep_set_mac_addr(struct octep_device *oct, u8 *addr)
+{
+	struct octep_ctrl_mbox_msg msg = { 0 };
+	struct octep_ctrl_net_h2f_req req = { 0 };
+
+	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_MAC;
+	req.mac.cmd = OCTEP_CTRL_NET_CMD_SET;
+	memcpy(&req.mac.addr, addr, ETH_ALEN);
+
+	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
+	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_MAC_REQ_SZW;
+	msg.msg = &req;
+	return octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
+}
+
+int octep_set_mtu(struct octep_device *oct, int mtu)
+{
+	struct octep_ctrl_mbox_msg msg = { 0 };
+	struct octep_ctrl_net_h2f_req req = { 0 };
+
+	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_MTU;
+	req.mtu.cmd = OCTEP_CTRL_NET_CMD_SET;
+	req.mtu.val = mtu;
+
+	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
+	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_MTU_REQ_SZW;
+	msg.msg = &req;
+	return octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
+}
+
+int octep_get_if_stats(struct octep_device *oct)
+{
+	struct octep_ctrl_mbox_msg msg = { 0 };
+	struct octep_ctrl_net_h2f_req req = { 0 };
+	struct octep_iface_rx_stats *iface_rx_stats;
+	struct octep_iface_tx_stats *iface_tx_stats;
+	int err;
+
+	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_GET_IF_STATS;
+	req.mac.cmd = OCTEP_CTRL_NET_CMD_GET;
+	req.get_stats.offset = oct->ctrl_mbox_ifstats_offset;
+
+	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
+	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_GET_STATS_REQ_SZW;
+	msg.msg = &req;
+	err = octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
+	if (!err) {
+		iface_rx_stats = (struct octep_iface_rx_stats *)(oct->ctrl_mbox.barmem +
+								 oct->ctrl_mbox_ifstats_offset);
+		iface_tx_stats = (struct octep_iface_tx_stats *)(oct->ctrl_mbox.barmem +
+								 oct->ctrl_mbox_ifstats_offset +
+								 sizeof(struct octep_iface_rx_stats)
+								);
+		memcpy(&oct->iface_rx_stats, iface_rx_stats, sizeof(struct octep_iface_rx_stats));
+		memcpy(&oct->iface_tx_stats, iface_tx_stats, sizeof(struct octep_iface_tx_stats));
+	}
+
+	return 0;
+}
+
+int octep_get_link_info(struct octep_device *oct)
+{
+	struct octep_ctrl_mbox_msg msg = { 0 };
+	struct octep_ctrl_net_h2f_req req = { 0 };
+	struct octep_ctrl_net_h2f_resp *resp;
+	int err;
+
+	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_INFO;
+	req.mac.cmd = OCTEP_CTRL_NET_CMD_GET;
+
+	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
+	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_LINK_INFO_REQ_SZW;
+	msg.msg = &req;
+	err = octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
+	if (err)
+		return err;
+
+	resp = (struct octep_ctrl_net_h2f_resp *)&req;
+	oct->link_info.supported_modes = resp->link_info.supported_modes;
+	oct->link_info.advertised_modes = resp->link_info.advertised_modes;
+	oct->link_info.autoneg = resp->link_info.autoneg;
+	oct->link_info.pause = resp->link_info.pause;
+	oct->link_info.speed = resp->link_info.speed;
+
+	return 0;
+}
+
+int octep_set_link_info(struct octep_device *oct, struct octep_iface_link_info *link_info)
+{
+	struct octep_ctrl_mbox_msg msg = { 0 };
+	struct octep_ctrl_net_h2f_req req = { 0 };
+
+	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_LINK_INFO;
+	req.link_info.cmd = OCTEP_CTRL_NET_CMD_SET;
+	req.link_info.info.advertised_modes = link_info->advertised_modes;
+	req.link_info.info.autoneg = link_info->autoneg;
+	req.link_info.info.pause = link_info->pause;
+	req.link_info.info.speed = link_info->speed;
+
+	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
+	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_LINK_INFO_REQ_SZW;
+	msg.msg = &req;
+	return octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
+}
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index ec8e8ad37789..307a9ce2b67e 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -306,6 +306,32 @@ static netdev_tx_t octep_start_xmit(struct sk_buff *skb,
 static void octep_get_stats64(struct net_device *netdev,
 			      struct rtnl_link_stats64 *stats)
 {
+	u64 tx_packets, tx_bytes, rx_packets, rx_bytes;
+	struct octep_device *oct = netdev_priv(netdev);
+	int q;
+
+	octep_get_if_stats(oct);
+	tx_packets = 0;
+	tx_bytes = 0;
+	rx_packets = 0;
+	rx_bytes = 0;
+	for (q = 0; q < oct->num_oqs; q++) {
+		struct octep_iq *iq = oct->iq[q];
+		struct octep_oq *oq = oct->oq[q];
+
+		tx_packets += iq->stats.instr_completed;
+		tx_bytes += iq->stats.bytes_sent;
+		rx_packets += oq->stats.packets;
+		rx_bytes += oq->stats.bytes;
+	}
+	stats->tx_packets = tx_packets;
+	stats->tx_bytes = tx_bytes;
+	stats->rx_packets = rx_packets;
+	stats->rx_bytes = rx_bytes;
+	stats->multicast = oct->iface_rx_stats.mcast_pkts;
+	stats->rx_errors = oct->iface_rx_stats.err_pkts;
+	stats->collisions = oct->iface_tx_stats.xscol;
+	stats->tx_fifo_errors = oct->iface_tx_stats.undflw;
 }
 
 /**
@@ -346,11 +372,52 @@ static void octep_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 	queue_work(octep_wq, &oct->tx_timeout_task);
 }
 
+static int octep_set_mac(struct net_device *netdev, void *p)
+{
+	struct octep_device *oct = netdev_priv(netdev);
+	struct sockaddr *addr = (struct sockaddr *)p;
+	int err;
+
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+
+	err = octep_set_mac_addr(oct, addr->sa_data);
+	if (err)
+		return err;
+
+	memcpy(oct->mac_addr, addr->sa_data, ETH_ALEN);
+	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+
+	return 0;
+}
+
+static int octep_change_mtu(struct net_device *netdev, int new_mtu)
+{
+	struct octep_device *oct = netdev_priv(netdev);
+	struct octep_iface_link_info *link_info;
+	int err = 0;
+
+	link_info = &oct->link_info;
+	if (link_info->mtu == new_mtu)
+		return 0;
+
+	err = octep_set_mtu(oct, new_mtu);
+	if (!err) {
+		oct->link_info.mtu = new_mtu;
+		netdev->mtu = new_mtu;
+	}
+
+	return err;
+}
+
 static const struct net_device_ops octep_netdev_ops = {
 	.ndo_open                = octep_open,
 	.ndo_stop                = octep_stop,
 	.ndo_start_xmit          = octep_start_xmit,
+	.ndo_get_stats64         = octep_get_stats64,
 	.ndo_tx_timeout          = octep_tx_timeout,
+	.ndo_set_mac_address     = octep_set_mac,
+	.ndo_change_mtu          = octep_change_mtu,
 };
 
 /**
-- 
2.17.1

