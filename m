Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F40A135A40
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 14:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731182AbgAINfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 08:35:48 -0500
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:51997 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730311AbgAINfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 08:35:48 -0500
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 0F968366824;
        Thu,  9 Jan 2020 14:35:46 +0100 (CET)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.92)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1ipXyT-0002FV-PF; Thu, 09 Jan 2020 14:35:45 +0100
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH ipsec v2 2/2] xfrm interface: fix packet tx through bpf_redirect()
Date:   Thu,  9 Jan 2020 14:35:43 +0100
Message-Id: <20200109133543.8559-3-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200109133543.8559-1-nicolas.dichtel@6wind.com>
References: <20200109084009.GA8621@gauss3.secunet.de>
 <20200109133543.8559-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With an ebpf program that redirects packets through a xfrm interface,
packets are dropped because no dst is attached to skb.

This could also be reproduced with an AF_PACKET socket, with the following
python script (xfrm1 is a xfrm interface):

 import socket
 send_s = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, 0)
 # scapy
 # p = IP(src='10.100.0.2', dst='10.200.0.1')/ICMP(type='echo-request')
 # raw(p)
 req = b'E\x00\x00\x1c\x00\x01\x00\x00@\x01e\xb2\nd\x00\x02\n\xc8\x00\x01\x08\x00\xf7\xff\x00\x00\x00\x00'
 send_s.sendto(req, ('xfrm1', 0x800, 0, 0))

It was also not possible to send an ip packet through an AF_PACKET socket
because a LL header was expected. Let's remove those LL header constraints.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/xfrm/xfrm_interface.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 7ac1542feaf8..60481acb10d2 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -268,9 +268,6 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 	int err = -1;
 	int mtu;
 
-	if (!dst)
-		goto tx_err_link_failure;
-
 	dst_hold(dst);
 	dst = xfrm_lookup_with_ifid(xi->net, dst, fl, NULL, 0, xi->p.if_id);
 	if (IS_ERR(dst)) {
@@ -343,6 +340,7 @@ static netdev_tx_t xfrmi_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct xfrm_if *xi = netdev_priv(dev);
 	struct net_device_stats *stats = &xi->dev->stats;
+	struct dst_entry *dst = skb_dst(skb);
 	struct flowi fl;
 	int ret;
 
@@ -352,10 +350,29 @@ static netdev_tx_t xfrmi_xmit(struct sk_buff *skb, struct net_device *dev)
 	case htons(ETH_P_IPV6):
 		xfrm_decode_session(skb, &fl, AF_INET6);
 		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
+		if (!dst) {
+			dst = ip6_route_output(dev_net(dev), NULL, &fl.u.ip6);
+			if (dst->error) {
+				dst_release(dst);
+				stats->tx_carrier_errors++;
+				goto tx_err;
+			}
+			skb_dst_set(skb, dst);
+		}
 		break;
 	case htons(ETH_P_IP):
 		xfrm_decode_session(skb, &fl, AF_INET);
 		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
+		if (!dst) {
+			struct rtable *rt = __ip_route_output_key(dev_net(dev),
+								  &fl.u.ip4);
+
+			if (IS_ERR(rt)) {
+				stats->tx_carrier_errors++;
+				goto tx_err;
+			}
+			skb_dst_set(skb, &rt->dst);
+		}
 		break;
 	default:
 		goto tx_err;
@@ -563,12 +580,9 @@ static void xfrmi_dev_setup(struct net_device *dev)
 {
 	dev->netdev_ops 	= &xfrmi_netdev_ops;
 	dev->type		= ARPHRD_NONE;
-	dev->hard_header_len 	= ETH_HLEN;
-	dev->min_header_len	= ETH_HLEN;
 	dev->mtu		= ETH_DATA_LEN;
 	dev->min_mtu		= ETH_MIN_MTU;
-	dev->max_mtu		= ETH_DATA_LEN;
-	dev->addr_len		= ETH_ALEN;
+	dev->max_mtu		= IP_MAX_MTU;
 	dev->flags 		= IFF_NOARP;
 	dev->needs_free_netdev	= true;
 	dev->priv_destructor	= xfrmi_dev_free;
-- 
2.24.0

