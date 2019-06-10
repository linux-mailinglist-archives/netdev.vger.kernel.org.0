Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC383B777
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 16:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390812AbfFJOdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 10:33:08 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35832 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389575AbfFJOdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 10:33:08 -0400
Received: by mail-pl1-f196.google.com with SMTP id p1so3747385plo.2
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 07:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5yeFmHQ/wenwmTujMvYkKLtsigxByABc4GDDYQ/ykSw=;
        b=u0SOapVRWZq4pXyXYsSQG+YnsyMfKCaSA/X4IP2Z78OP+yek2iCi5JPahvqMj+GH06
         Zo1I8bpb4WcTeNUUW0JvgLRyRrMMM8sA7RE5DfjQcc93c+6JMAeibeLVq2Iyz4RnNIQL
         4uSMIqvRoJD/KadKwqwdbL0AHOOdN7zHVIMnyqG0mtTGZZS3gzc3IVtgQlqfazMKhzdL
         FF1/KK+P0JrWaFIrz+XDOYh1y9HuQzoKP3K4sNgywHyMIoU7jKASAIkSv6JA0ma1N4Vp
         eWroRjoWXnAeuTY03l9NahZXHE7lEjheEx4wxe2kUbxAw0rLkbkeGsDHhcJa5PPf2kKm
         RUFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5yeFmHQ/wenwmTujMvYkKLtsigxByABc4GDDYQ/ykSw=;
        b=F+yGWVYTPT2+r3JUhaWjDWU77I+mqWBAcES1tYxAoiJhX3CnS5rJv1u9i1TMaYU+od
         8SOOh1iye64znqXK0kwGoaVH53K0Q3sTGDOIpdCfbXeFsjJ7m9gcsd5xeD5MvOijbzAu
         bWZA4Ci9LeMobvmoPkJ43VoJHAjZjGtXhhhisdfyrqat05Aq58dGgyFF+0F8le6vtC3Q
         KllbpjU7U6UKHS/3zgusihrCN2wWv0I5m2DWo788JU637d728Ua7bH9DBFEKt6DFOpUT
         qUvVd5Ajz+ozAgbtxRkaoJ2RFtYywkidXh9YSifhbUGDU8M7f+r1/J3apNrHb9fPGA41
         n0mA==
X-Gm-Message-State: APjAAAXu7z19PhzB9NhuAdpdFbqzgkK4+p+GCTcYv/Mf/i3M09Mfg7+K
        eVQgjnLAmdmgG1jEeuD4sjoVpa0=
X-Google-Smtp-Source: APXvYqyZ1ywMygabyYPSNgu+IFjKixVpYcnKo0g7Vd2abJpTdRbPzp7vBx3HTQXtmB7boa1LiuYKkw==
X-Received: by 2002:a17:902:f01:: with SMTP id 1mr70365301ply.170.1560177187601;
        Mon, 10 Jun 2019 07:33:07 -0700 (PDT)
Received: from ubuntu.extremenetworks.com ([12.38.14.8])
        by smtp.gmail.com with ESMTPSA id g2sm24793039pfb.95.2019.06.10.07.33.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 07:33:06 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH net v2] vrf: Increment Icmp6InMsgs on the original netdev
Date:   Mon, 10 Jun 2019 10:32:50 -0400
Message-Id: <20190610143250.18796-1-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get the ingress interface and increment ICMP counters based on that
instead of skb->dev when the the dev is a VRF device.

This is a follow up on the following message:
https://www.spinics.net/lists/netdev/msg560268.html

v2: Avoid changing skb->dev since it has unintended effect for local
    delivery (David Ahern).
Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 include/net/addrconf.h | 16 ++++++++++++++++
 net/ipv6/icmp.c        | 17 +++++++++++------
 net/ipv6/reassembly.c  |  4 ++--
 3 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 269ec27385e9..2e36e29f9f54 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -356,6 +356,22 @@ static inline struct inet6_dev *__in6_dev_get(const struct net_device *dev)
 	return rcu_dereference_rtnl(dev->ip6_ptr);
 }
 
+/**
+ * __in6_dev_stats_get - get inet6_dev pointer for stats
+ * @dev: network device
+ * @skb: skb for original incoming interface if neeeded
+ *
+ * Caller must hold rcu_read_lock or RTNL, because this function
+ * does not take a reference on the inet6_dev.
+ */
+static inline struct inet6_dev *__in6_dev_stats_get(const struct net_device *dev,
+						    const struct sk_buff *skb)
+{
+	if (netif_is_l3_master(dev))
+		dev = dev_get_by_index_rcu(dev_net(dev), inet6_iif(skb));
+	return __in6_dev_get(dev);
+}
+
 /**
  * __in6_dev_get_safely - get inet6_dev pointer from netdevice
  * @dev: network device
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 802faa2fcc0e..f54191cd1d7b 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -398,23 +398,28 @@ static struct dst_entry *icmpv6_route_lookup(struct net *net,
 	return ERR_PTR(err);
 }
 
-static int icmp6_iif(const struct sk_buff *skb)
+static struct net_device *icmp6_dev(const struct sk_buff *skb)
 {
-	int iif = skb->dev->ifindex;
+	struct net_device *dev = skb->dev;
 
 	/* for local traffic to local address, skb dev is the loopback
 	 * device. Check if there is a dst attached to the skb and if so
 	 * get the real device index. Same is needed for replies to a link
 	 * local address on a device enslaved to an L3 master device
 	 */
-	if (unlikely(iif == LOOPBACK_IFINDEX || netif_is_l3_master(skb->dev))) {
+	if (unlikely(dev->ifindex == LOOPBACK_IFINDEX || netif_is_l3_master(skb->dev))) {
 		const struct rt6_info *rt6 = skb_rt6_info(skb);
 
 		if (rt6)
-			iif = rt6->rt6i_idev->dev->ifindex;
+			dev = rt6->rt6i_idev->dev;
 	}
 
-	return iif;
+	return dev;
+}
+
+static int icmp6_iif(const struct sk_buff *skb)
+{
+	return icmp6_dev(skb)->ifindex;
 }
 
 /*
@@ -801,7 +806,7 @@ void icmpv6_notify(struct sk_buff *skb, u8 type, u8 code, __be32 info)
 static int icmpv6_rcv(struct sk_buff *skb)
 {
 	struct net *net = dev_net(skb->dev);
-	struct net_device *dev = skb->dev;
+	struct net_device *dev = icmp6_dev(skb);
 	struct inet6_dev *idev = __in6_dev_get(dev);
 	const struct in6_addr *saddr, *daddr;
 	struct icmp6hdr *hdr;
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 1a832f5e190b..e219e669ac11 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -302,7 +302,7 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *skb,
 			   skb_network_header_len(skb));
 
 	rcu_read_lock();
-	__IP6_INC_STATS(net, __in6_dev_get(dev), IPSTATS_MIB_REASMOKS);
+	__IP6_INC_STATS(net, __in6_dev_stats_get(dev, skb), IPSTATS_MIB_REASMOKS);
 	rcu_read_unlock();
 	fq->q.rb_fragments = RB_ROOT;
 	fq->q.fragments_tail = NULL;
@@ -316,7 +316,7 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *skb,
 	net_dbg_ratelimited("ip6_frag_reasm: no memory for reassembly\n");
 out_fail:
 	rcu_read_lock();
-	__IP6_INC_STATS(net, __in6_dev_get(dev), IPSTATS_MIB_REASMFAILS);
+	__IP6_INC_STATS(net, __in6_dev_stats_get(dev, skb), IPSTATS_MIB_REASMFAILS);
 	rcu_read_unlock();
 	inet_frag_kill(&fq->q);
 	return -1;
-- 
2.17.1

