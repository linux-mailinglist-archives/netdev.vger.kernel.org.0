Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 319DC1088AE
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 07:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbfKYGXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 01:23:23 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33239 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbfKYGXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 01:23:23 -0500
Received: by mail-pg1-f193.google.com with SMTP id 6so2130778pgk.0
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 22:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BTd8p/jPCYoYqKGBszOxX1hObb8IyhWUaJxq8bYk43A=;
        b=lzdoI2Mes97x6tzIXU5OlGbK9LAJkDn9sOp4ZFqwuuER0DFnH+ubQybPXRSHKe/mom
         NibuN31xllREiBOQZRK/Tyur9sk8nZNsKoFckjiy8flpNXIhvA4rRNY1x3zY30ZKe85c
         oyIMPckOYRQYvFwkk8KyiryM833lEUU1MALzcSWrJ60XJCdbfhdkpOmXUo/MXDhglufG
         W17A46HPvrhXfmuSE/4MuRYOWe5SMrWuSfGoM9ZcUbwVpNJDRtFZyngOcezdjBEMzSlv
         6Xs1YQZUz5C1Q7lTHU4dKpH0FBjBfZV6fsXVonC3uxyEn6+7qE7u+uOQOpS50rtoxFxZ
         3iPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BTd8p/jPCYoYqKGBszOxX1hObb8IyhWUaJxq8bYk43A=;
        b=le9GXYoiTHnssAqYahJ1C+3Eu2qDh4i/Rhf7z+daLpUI2nt6F04g+CfZF0KBII72dh
         pDVgVpafJ+6J4KI0r0OUvgGAnjVoSsKG9pDkI9V4Dj+QnbV7EaV/YGX7bmBZj9M5+/US
         tnGkJ9fwHHttsEvm8elBVukoxhWGCWFwTx9lLdaFEAX/Xj90kZe/i3hPObhYGSO6NJFr
         GhgwYLBxoIIrlakaiYRV7MtI5vNtO2tmQHGmhar1efBPOJJBfIw4xk6RBQ/iCGIuqOfT
         cL18fZeUIb3wZs3hSf6r1SKGh37K9aqSVGFInwu7CQp5DJ6HCVtaRH4gSXZsFDvRMXbU
         tbhg==
X-Gm-Message-State: APjAAAVboOWUd9rIuw+Mlvglh+RuzvMx6iqd9KSKv02NJXGD2XsK9NDf
        tD8Vmivw0ShcncQNNLNbHvIF8cOC
X-Google-Smtp-Source: APXvYqym2eVMeMgBA1pTGcBphAhFsQ4PeLVbz2+i5IxoIOPNMP9uhI91K1YEYiXTcBo0AAIZw/FFnQ==
X-Received: by 2002:a62:2f01:: with SMTP id v1mr32705411pfv.73.1574663000677;
        Sun, 24 Nov 2019 22:23:20 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 76sm6587505pfw.128.2019.11.24.22.23.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Nov 2019 22:23:19 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, David Ahern <dsahern@gmail.com>,
        jbenc@redhat.com, Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [PATCH net] ipv6: set lwtstate for ns and na dst
Date:   Mon, 25 Nov 2019 14:23:12 +0800
Message-Id: <3743d1e2c7fc26fb5f7401b6b0956097e997c48c.1574662992.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to fix an issue that ipv6 ns and na can't go out with the
correct tunnel info, and it can be reproduced by:

  # ip net a a; ip net a b
  # ip -n a l a eth0 type veth peer name eth0 netns b
  # ip -n a l s eth0 up; ip -n b link set eth0 up
  # ip -n a a a 10.1.0.1/24 dev eth0; ip -n b a a 10.1.0.2/24 dev eth0
  # ip -n b l a vxlan1 type vxlan id 1 local 10.1.0.2 remote 10.1.0.1 \
      dstport 0 dev eth0 ttl 64
  # ip -n b a a 1000::1/24 dev vxlan1; ip -n b l s vxlan1 up
  # ip -n b r a 2000::/24 dev vxlan1; sleep 3
  # ip -n a l a vxlan1 type vxlan local 10.1.0.1 dev eth0 ttl 64 \
      dstport 0 external
  # ip -n a a a 2000::1/24 dev vxlan1; ip -n a l s vxlan1 up
  # ip -n a r a 1000::/24 encap ip id 1 dst 10.1.0.2 dev vxlan1; sleep 3
  # ip net exec a ping6 1000::1 -c 1

ping6 doesn't work, as ns and na are icmpv6 packets which don't look up
a dst, but build a dst on its own. It will cause the lwstate to be lost
and the packets can never go out with the correct tunnel info.

Also unlike arp packets process where arp_request will get dst from the
data packet and arp_reply will get dst->lwstate from peer arp_request,
now ns doesn't get dst from the data and na can't get dst->lwstata as
peer ns packet lwstate will be lost after doing input route.

Since ns and na are ipv6 packets, a proper fix is to look up a dst and
set its lwstate to the new allocated dst.

Fixes: 19e42e451506 ("ipv6: support for fib route lwtunnel encap attributes")
Reported-by: Jianlin Shi <jishi@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/ndisc.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 53caf59..963172d96 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -517,6 +517,9 @@ void ndisc_send_na(struct net_device *dev, const struct in6_addr *daddr,
 		   const struct in6_addr *solicited_addr,
 		   bool router, bool solicited, bool override, bool inc_opt)
 {
+	struct sock *sk = dev_net(dev)->ipv6.ndisc_sk;
+	struct dst_entry *dst, *dst_orig;
+	struct flowi6 fl6;
 	struct sk_buff *skb;
 	struct in6_addr tmpaddr;
 	struct inet6_ifaddr *ifp;
@@ -566,6 +569,20 @@ void ndisc_send_na(struct net_device *dev, const struct in6_addr *daddr,
 				       dev->dev_addr,
 				       NDISC_NEIGHBOUR_ADVERTISEMENT);
 
+	icmpv6_flow_init(sk, &fl6, msg->icmph.icmp6_type, src_addr,
+			 daddr, dev->ifindex);
+	dst = icmp6_dst_alloc(dev, &fl6);
+	if (IS_ERR(dst)) {
+		kfree_skb(skb);
+		return;
+	}
+
+	dst_orig = ip6_route_output(dev_net(dev), NULL, &fl6);
+	if (!dst_orig->error)
+		dst->lwtstate = lwtstate_get(dst_orig->lwtstate);
+	dst_release(dst_orig);
+
+	skb_dst_set(skb, dst);
 	ndisc_send_skb(skb, daddr, src_addr);
 }
 
@@ -599,6 +616,9 @@ void ndisc_send_ns(struct net_device *dev, const struct in6_addr *solicit,
 		   const struct in6_addr *daddr, const struct in6_addr *saddr,
 		   u64 nonce)
 {
+	struct sock *sk = dev_net(dev)->ipv6.ndisc_sk;
+	struct dst_entry *dst, *dst_orig;
+	struct flowi6 fl6;
 	struct sk_buff *skb;
 	struct in6_addr addr_buf;
 	int inc_opt = dev->addr_len;
@@ -644,6 +664,21 @@ void ndisc_send_ns(struct net_device *dev, const struct in6_addr *solicit,
 		memcpy(opt + 2, &nonce, 6);
 	}
 
+	icmpv6_flow_init(sk, &fl6, msg->icmph.icmp6_type, saddr,
+			 daddr, dev->ifindex);
+	dst = icmp6_dst_alloc(dev, &fl6);
+	if (IS_ERR(dst)) {
+		kfree_skb(skb);
+		return;
+	}
+
+	fl6.daddr = *solicit;
+	dst_orig = ip6_route_output(dev_net(dev), NULL, &fl6);
+	if (!dst_orig->error)
+		dst->lwtstate = lwtstate_get(dst_orig->lwtstate);
+	dst_release(dst_orig);
+
+	skb_dst_set(skb, dst);
 	ndisc_send_skb(skb, daddr, saddr);
 }
 
-- 
2.1.0

