Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5547621DE1
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 21:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiKHUoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 15:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbiKHUn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 15:43:56 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C891EA7;
        Tue,  8 Nov 2022 12:43:27 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A8H0a3q008588;
        Tue, 8 Nov 2022 12:43:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=FcU2dlr+DRx+pTr1JuPDcQGS+0IRbDzQkOXlGOAdSPY=;
 b=NiDZS5WVkatZvKEDzwIk1Gd98Xmyg1vECuLXta2LGgoIihKd6AapSuaWgIYP2zGQ1MVE
 6EEOuExG11sOFTvLG42KK67Ja+zpFg1QvvFXJC9BZYXY+Qdvj/Of3fKeUCVOxBGt8AUX
 sV2VA6BCgCgCtQ2BajgfA/9PqmISvgMq5B1qwANlI8KzwoyPhE2Do8ExG1Yu52iZ+V2V
 s259631pjpG/Z14u0UGq+LA5ZpFvKI7NoYifpXi/gyoq4xXGgxyWT+rzmk5w94+GTvgN
 IhpPfnUBmwk8Ulp4zXZnus7OjqQeeeaJPWyTLavGZPqbCg+zGZOL2HcpMPhBE3bVBS1d Gw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3kqu4vh08g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 12:43:19 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Nov
 2022 12:43:17 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Nov 2022 12:43:17 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 3C1AC3F70D4;
        Tue,  8 Nov 2022 12:43:16 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lironh@marvell.com>, <aayarekar@marvell.com>,
        <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Jonathan Corbet" <corbet@lwn.net>, Andrew Lunn <andrew@lunn.ch>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH net-next 5/8] octeon_ep_vf: add support for ndo ops
Date:   Tue, 8 Nov 2022 12:41:56 -0800
Message-ID: <20221108204209.23071-6-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221108204209.23071-1-vburru@marvell.com>
References: <20221108204209.23071-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: HzoQf_k0j6HGz3iG-J2ppfQ2BCoZdfQB
X-Proofpoint-GUID: HzoQf_k0j6HGz3iG-J2ppfQ2BCoZdfQB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for ndo ops to set MAC address, change MTU, get stats.
Add control path support to set MAC address, change MTU, get stats,
set speed, get and set link mode.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
Signed-off-by: Sathesh Edara <sedara@marvell.com>
Signed-off-by: Satananda Burla <sburla@marvell.com>
---
 .../marvell/octeon_ep_vf/octep_vf_main.c      | 93 +++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
index 9d1fc867bf5d..d788846b12e7 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
@@ -183,6 +183,23 @@ static netdev_tx_t octep_vf_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+int octep_vf_get_if_stats(struct octep_vf_device *oct)
+{
+	struct octep_vf_iface_rxtx_stats vf_stats;
+	int ret, size;
+
+	memset(&vf_stats, 0, sizeof(struct octep_vf_iface_rxtx_stats));
+	ret = octep_vf_mbox_bulk_read(oct, OCTEP_PFVF_MBOX_CMD_GET_STATS,
+				      (u8 *)&vf_stats, &size);
+	if (!ret) {
+		memcpy(&oct->iface_rx_stats, &vf_stats.iface_rx_stats,
+		       sizeof(struct octep_vf_iface_rx_stats));
+		memcpy(&oct->iface_tx_stats, &vf_stats.iface_tx_stats,
+		       sizeof(struct octep_vf_iface_tx_stats));
+	}
+	return ret;
+}
+
 int octep_vf_get_link_info(struct octep_vf_device *oct)
 {
 	int ret, size;
@@ -196,6 +213,42 @@ int octep_vf_get_link_info(struct octep_vf_device *oct)
 	return 0;
 }
 
+/**
+ * octep_vf_get_stats64() - Get Octeon network device statistics.
+ *
+ * @netdev: kernel network device.
+ * @stats: pointer to stats structure to be filled in.
+ */
+static void octep_vf_get_stats64(struct net_device *netdev,
+				 struct rtnl_link_stats64 *stats)
+{
+	struct octep_vf_device *oct = netdev_priv(netdev);
+	u64 tx_packets, tx_bytes, rx_packets, rx_bytes;
+	int q;
+
+	tx_packets = 0;
+	tx_bytes = 0;
+	rx_packets = 0;
+	rx_bytes = 0;
+	for (q = 0; q < oct->num_oqs; q++) {
+		struct octep_vf_iq *iq = oct->iq[q];
+		struct octep_vf_oq *oq = oct->oq[q];
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
+	if (!octep_vf_get_if_stats(oct)) {
+		stats->multicast = oct->iface_rx_stats.mcast_pkts;
+		stats->rx_errors = oct->iface_rx_stats.err_pkts;
+	}
+}
+
 /**
  * octep_vf_tx_timeout_task - work queue task to Handle Tx queue timeout.
  *
@@ -234,11 +287,51 @@ static void octep_vf_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 	queue_work(octep_vf_wq, &oct->tx_timeout_task);
 }
 
+static int octep_vf_set_mac(struct net_device *netdev, void *p)
+{
+	struct octep_vf_device *oct = netdev_priv(netdev);
+	struct sockaddr *addr = (struct sockaddr *)p;
+	int err;
+
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+
+	err = octep_vf_mbox_set_mac_addr(oct, addr->sa_data);
+	if (err)
+		return err;
+
+	memcpy(oct->mac_addr, addr->sa_data, ETH_ALEN);
+	eth_hw_addr_set(netdev, addr->sa_data);
+
+	return 0;
+}
+
+static int octep_vf_change_mtu(struct net_device *netdev, int new_mtu)
+{
+	struct octep_vf_device *oct = netdev_priv(netdev);
+	struct octep_vf_iface_link_info *link_info;
+	int err;
+
+	link_info = &oct->link_info;
+	if (link_info->mtu == new_mtu)
+		return 0;
+
+	err = octep_vf_mbox_set_mtu(oct, new_mtu);
+	if (!err) {
+		oct->link_info.mtu = new_mtu;
+		netdev->mtu = new_mtu;
+	}
+	return err;
+}
+
 static const struct net_device_ops octep_vf_netdev_ops = {
 	.ndo_open                = octep_vf_open,
 	.ndo_stop                = octep_vf_stop,
 	.ndo_start_xmit          = octep_vf_start_xmit,
+	.ndo_get_stats64         = octep_vf_get_stats64,
 	.ndo_tx_timeout          = octep_vf_tx_timeout,
+	.ndo_set_mac_address     = octep_vf_set_mac,
+	.ndo_change_mtu          = octep_vf_change_mtu,
 };
 
 static const char *octep_vf_devid_to_str(struct octep_vf_device *oct)
-- 
2.36.0

