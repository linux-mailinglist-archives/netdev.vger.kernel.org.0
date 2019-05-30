Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF7A8304B4
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 00:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfE3WUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 18:20:50 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:55784 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfE3WUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 18:20:50 -0400
Received: by mail-it1-f194.google.com with SMTP id g24so12588089iti.5
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 15:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=w6l6yso3zMtUNFB7dNEQEpN5pXypnoKoLxFLYmsw6N4=;
        b=bkO09GUe40C+GvncLgGvhJUlLPh1M7bodfCwDbRhd2xRBIuSqaINFpW2YMy3waJoz4
         liaNn6EHlZQR7yNWjFGcsoCmFFHZSp4YLh2F2oLT9Jx21kCpm+atZoegGLviQNKgQUZb
         HWZcyrWB+E0jEWgSYDJRHlhNlCaEGlVZWE7Eu0qR8EpWABxCaet9gXi8doHbqedAvliR
         G5YYTjFjtn4+FOy6SBqFzukPO7tsnZEI21IXLeM3ziUdZiTLQncsaEukUCApDK8SPioC
         XVOQUrfRtcvThjzHkeF38fDSaP6CDOj/YOL/5UP7PA2w0q1t+jf5gnUik86/3vhEg+mC
         IuLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=w6l6yso3zMtUNFB7dNEQEpN5pXypnoKoLxFLYmsw6N4=;
        b=b+pQeEZiKlpA0MQ4T8tQ1BugHsaJIK5xNIC+1DXSK+hGI9bHu57HWpIiS40UmcijGx
         c9aQS7ZaCqYVjlOeu5kjqbbdX2iPRNDm9mtrBeKuuVHGIp3dqXR+KdUZ4d10UujYfjBI
         4VxJ/0xtzKL3IrZob87vU0j3kDtkgj1xgZQHylXUH/pFnrYPz9d4vlXisdzwAw8fsI0d
         onpF4Xezv5r5RePJaEey1EL/G8d1SodhkjxMbCUR5p4AVOr1aVWS5yco9ty78ilTEtG4
         5bSRyCF9Ww+b++kDPsnoluaNl+Kst8KA7Sp01Pra6mI4zs247J4t3q22U8TGIQmLhaaw
         hcLw==
X-Gm-Message-State: APjAAAXSguVqKgwTRDYumaYjJCuZTiCzim4WCPdmB43E80+Kss20kWM7
        tEBTaED8vT/xPCPRkjFn4l01xRU=
X-Google-Smtp-Source: APXvYqwyXcKAXyBp6vJQHrupLlctdiSRJdpAEgqJAMIH+POn+Qwp7NonrKfF16aFpMIWub1NzbQmIA==
X-Received: by 2002:a24:7592:: with SMTP id y140mr4972812itc.47.1559251209944;
        Thu, 30 May 2019 14:20:09 -0700 (PDT)
Received: from ubuntu.extremenetworks.com ([12.38.14.10])
        by smtp.gmail.com with ESMTPSA id f4sm1514920itl.36.2019.05.30.14.20.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 14:20:09 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH net] vrf: Increment Icmp6InMsgs on the original netdev
Date:   Thu, 30 May 2019 01:08:15 -0400
Message-Id: <20190530050815.20352-1-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get the ingress interface and increment ICMP counters based on that
instead of skb->dev when the the dev is a VRF device.

This is a follow up on the following message:
https://www.spinics.net/lists/netdev/msg560268.html

Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 net/ipv6/icmp.c       | 17 +++++++++++------
 net/ipv6/reassembly.c |  3 +++
 2 files changed, 14 insertions(+), 6 deletions(-)

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
index 1a832f5e190b..9b365c345c34 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -260,6 +260,9 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *skb,
 	int payload_len;
 	u8 ecn;
 
+	if (netif_is_l3_master(dev))
+		dev = dev_get_by_index_rcu(net, inet6_iif(skb));
+
 	inet_frag_kill(&fq->q);
 
 	ecn = ip_frag_ecn_table[fq->ecn];
-- 
2.17.1

