Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2432A7CA6
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 12:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729887AbgKELMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 06:12:20 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:49761 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726067AbgKELMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 06:12:20 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yanjunz@mellanox.com)
        with SMTP; 5 Nov 2020 13:12:14 +0200
Received: from bc-vnc02.mtbc.labs.mlnx (bc-vnc02.mtbc.labs.mlnx [10.75.68.111])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0A5BCDcF008779;
        Thu, 5 Nov 2020 13:12:14 +0200
Received: from bc-vnc02.mtbc.labs.mlnx (localhost [127.0.0.1])
        by bc-vnc02.mtbc.labs.mlnx (8.14.4/8.14.4) with ESMTP id 0A5BCDd7002567;
        Thu, 5 Nov 2020 19:12:13 +0800
Received: (from yanjunz@localhost)
        by bc-vnc02.mtbc.labs.mlnx (8.14.4/8.14.4/Submit) id 0A5BCBjL002549;
        Thu, 5 Nov 2020 19:12:11 +0800
From:   Zhu Yanjun <yanjunz@nvidia.com>
To:     yanjunz@nvidia.com, dledford@redhat.com, jgg@ziepe.ca,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/1] RDMA/rxe: Fetch skb packets from ethernet layer
Date:   Thu,  5 Nov 2020 19:12:01 +0800
Message-Id: <1604574721-2505-1-git-send-email-yanjunz@nvidia.com>
X-Mailer: git-send-email 1.7.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the original design, in rx, skb packet would pass ethernet
layer and IP layer, eventually reach udp tunnel.

Now rxe fetches the skb packets from the ethernet layer directly.
So this bypasses the IP and UDP layer. As such, the skb packets
are sent to the upper protocals directly from the ethernet layer.

This increases bandwidth and decreases latency.

Signed-off-by: Zhu Yanjun <yanjunz@nvidia.com>
---
 drivers/infiniband/sw/rxe/rxe_net.c |   45 ++++++++++++++++++++++++++++++++++-
 1 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 2e490e5..8ea68b6 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -18,6 +18,7 @@
 #include "rxe_loc.h"
 
 static struct rxe_recv_sockets recv_sockets;
+static struct net_device *g_ndev;
 
 struct device *rxe_dma_device(struct rxe_dev *rxe)
 {
@@ -113,7 +114,7 @@ static int rxe_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	}
 
 	tnl_cfg.encap_type = 1;
-	tnl_cfg.encap_rcv = rxe_udp_encap_recv;
+	tnl_cfg.encap_rcv = NULL;
 
 	/* Setup UDP tunnel */
 	setup_udp_tunnel_sock(net, sock, &tnl_cfg);
@@ -357,6 +358,38 @@ struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
 	return rxe->ndev->name;
 }
 
+static rx_handler_result_t rxe_handle_frame(struct sk_buff **pskb)
+{
+	struct sk_buff *skb = *pskb;
+	struct iphdr *iph;
+	struct udphdr *udph;
+
+	if (unlikely(skb->pkt_type == PACKET_LOOPBACK))
+		return RX_HANDLER_PASS;
+
+	if (!is_valid_ether_addr(eth_hdr(skb)->h_source)) {
+		kfree(skb);
+		return RX_HANDLER_CONSUMED;
+	}
+
+	if (eth_hdr(skb)->h_proto != cpu_to_be16(ETH_P_IP))
+		return RX_HANDLER_PASS;
+
+	iph = ip_hdr(skb);
+
+	if (iph->protocol != IPPROTO_UDP)
+		return RX_HANDLER_PASS;
+
+	udph = udp_hdr(skb);
+
+	if (udph->dest != cpu_to_be16(ROCE_V2_UDP_DPORT))
+		return RX_HANDLER_PASS;
+
+	rxe_udp_encap_recv(NULL, skb);
+
+	return RX_HANDLER_CONSUMED;
+}
+
 int rxe_net_add(const char *ibdev_name, struct net_device *ndev)
 {
 	int err;
@@ -367,6 +400,7 @@ int rxe_net_add(const char *ibdev_name, struct net_device *ndev)
 		return -ENOMEM;
 
 	rxe->ndev = ndev;
+	g_ndev = ndev;
 
 	err = rxe_add(rxe, ndev->mtu, ibdev_name);
 	if (err) {
@@ -374,6 +408,12 @@ int rxe_net_add(const char *ibdev_name, struct net_device *ndev)
 		return err;
 	}
 
+	rtnl_lock();
+	err = netdev_rx_handler_register(ndev, rxe_handle_frame, rxe);
+	rtnl_unlock();
+	if (err)
+		return err;
+
 	return 0;
 }
 
@@ -498,6 +538,9 @@ static int rxe_net_ipv6_init(void)
 
 void rxe_net_exit(void)
 {
+	rtnl_lock();
+	netdev_rx_handler_unregister(g_ndev);
+	rtnl_unlock();
 	rxe_release_udp_tunnel(recv_sockets.sk6);
 	rxe_release_udp_tunnel(recv_sockets.sk4);
 	unregister_netdevice_notifier(&rxe_net_notifier);
-- 
1.7.1

