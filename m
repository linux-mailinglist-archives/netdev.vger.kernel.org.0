Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18F6A138CEF
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 09:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbgAMIcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 03:32:52 -0500
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:40212 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728792AbgAMIcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 03:32:51 -0500
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 50B5F3694B9;
        Mon, 13 Jan 2020 09:32:49 +0100 (CET)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.92)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1iqv9V-0003pi-7a; Mon, 13 Jan 2020 09:32:49 +0100
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH ipsec v3 1/2] vti[6]: fix packet tx through bpf_redirect()
Date:   Mon, 13 Jan 2020 09:32:46 +0100
Message-Id: <20200113083247.14650-2-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200113083247.14650-1-nicolas.dichtel@6wind.com>
References: <6407b52a-b01d-5580-32e2-fbe352c2f47e@6wind.com>
 <20200113083247.14650-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With an ebpf program that redirects packets through a vti[6] interface,
the packets are dropped because no dst is attached.

This could also be reproduced with an AF_PACKET socket, with the following
python script (vti1 is an ip_vti interface):

 import socket
 send_s = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, 0)
 # scapy
 # p = IP(src='10.100.0.2', dst='10.200.0.1')/ICMP(type='echo-request')
 # raw(p)
 req = b'E\x00\x00\x1c\x00\x01\x00\x00@\x01e\xb2\nd\x00\x02\n\xc8\x00\x01\x08\x00\xf7\xff\x00\x00\x00\x00'
 send_s.sendto(req, ('vti1', 0x800, 0, 0))

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/ipv4/ip_vti.c  | 13 +++++++++++--
 net/ipv6/ip6_vti.c | 13 +++++++++++--
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index e90b600c7a25..37cddd18f282 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -187,8 +187,17 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
 	int mtu;
 
 	if (!dst) {
-		dev->stats.tx_carrier_errors++;
-		goto tx_error_icmp;
+		struct rtable *rt;
+
+		fl->u.ip4.flowi4_oif = dev->ifindex;
+		fl->u.ip4.flowi4_flags |= FLOWI_FLAG_ANYSRC;
+		rt = __ip_route_output_key(dev_net(dev), &fl->u.ip4);
+		if (IS_ERR(rt)) {
+			dev->stats.tx_carrier_errors++;
+			goto tx_error_icmp;
+		}
+		dst = &rt->dst;
+		skb_dst_set(skb, dst);
 	}
 
 	dst_hold(dst);
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 6f08b760c2a7..524006aa0d78 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -449,8 +449,17 @@ vti6_xmit(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 	int err = -1;
 	int mtu;
 
-	if (!dst)
-		goto tx_err_link_failure;
+	if (!dst) {
+		fl->u.ip6.flowi6_oif = dev->ifindex;
+		fl->u.ip6.flowi6_flags |= FLOWI_FLAG_ANYSRC;
+		dst = ip6_route_output(dev_net(dev), NULL, &fl->u.ip6);
+		if (dst->error) {
+			dst_release(dst);
+			dst = NULL;
+			goto tx_err_link_failure;
+		}
+		skb_dst_set(skb, dst);
+	}
 
 	dst_hold(dst);
 	dst = xfrm_lookup(t->net, dst, fl, NULL, 0);
-- 
2.24.0

