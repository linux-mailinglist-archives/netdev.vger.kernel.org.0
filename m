Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAF73C1DE6
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 05:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhGIDsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 23:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbhGIDsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 23:48:00 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D489EC061574
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 20:45:17 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id a14so4315322pls.4
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 20:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fbmnfWR0VTKmQQpdEmQlhSbIvju7GrnnFUQ9ku9gI2o=;
        b=VwFA4U3ilJVsy0iwd0+dncS7Hxp4ov8nHDX/Bjj1LzGKdoUyq9DLifdfXiPsJXclST
         ntAeB15MQF9KLkaBcUH4yBK7Qh/UKzb1mVynbyzCYWfS0ug0MUGO0dLVVpx/4zft/LBX
         podfAS2u7/y6TddQTEkz1irXhc/ToLCM87K1KQUE8o2psbIghkw8aBp1NF1GAaCm1O37
         kAn55mau4iKwQA3+9ATEugVM5LlhSglE8Uvv9jtNQQMwH5oxTFuaDHra60MjSrrT+BwF
         HojqYSKnpMDfC8I8c3kJ4CO79/IaY58hhHG6Q0vsWvEsIbHmnTMKs6Tjs3G4Aagp/pH3
         +75w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fbmnfWR0VTKmQQpdEmQlhSbIvju7GrnnFUQ9ku9gI2o=;
        b=i4CKYTBpM1H9M7Mut/E1E0yQ2ytnlYn1skzSP2G78qZ4/ivbt3SXSIMcsTDi1mmMRG
         Qbpi/g4I12Y7pCni6rJvi1Hoppu2c6BX5h63Rd5SWMOLaJQ+HHEU0q3PPh5h/lGtV+//
         DZg25lXcLnO0j6lcodrX/uGXn22KukYhjI2lUjrHSxTcG4xs2eBsd3TtfDZWhl24lZnF
         NA9TOypNzaQEKwUO3SdP5e0mmPnzPrCWXBLSK4TCKMIqZLdj50G78N6rYd4ZPGuEAXOk
         HDaOyBFjvdfhpwLIvLugJp+bZsefJ/Imlo2xq+gT3kSsVK6yEuSYMm+DeD7tZpNiNTZK
         2odQ==
X-Gm-Message-State: AOAM531Qvwy1XcsmFzHLop6+w31ytiiQ1xgt4wqaSEc5Cdk9UHYEzk6i
        9hgJsg/I+Fo/wGzELJZerB3YPmKLzZ81DN/H
X-Google-Smtp-Source: ABdhPJzfPFqlP+jx5LjqMduq3q3zArMAI+FYyUc9Xhc3psNKGMbl1B043Qc3YIP0/s+ImZLWKuVpZg==
X-Received: by 2002:a17:90a:4091:: with SMTP id l17mr35031320pjg.12.1625802317121;
        Thu, 08 Jul 2021 20:45:17 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i27sm4940289pgl.78.2021.07.08.20.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 20:45:16 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jianlin Shi <jishi@redhat.com>
Subject: [PATCH net] net: ip_tunnel: fix mtu calculation for ETHER tunnel devices
Date:   Fri,  9 Jul 2021 11:45:02 +0800
Message-Id: <20210709034502.1227174-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 28e104d00281 ("net: ip_tunnel: fix mtu calculation") removed
dev->hard_header_len subtraction when calculate MTU for tunnel devices
as there is an overhead for device that has header_ops.

But there are ETHER tunnel devices, like gre_tap or erspan, which don't
have header_ops but set dev->hard_header_len during setup. This makes
pkts greater than (MTU - ETH_HLEN) could not be xmited. Fix it by
subtracting the ETHER tunnel devices' dev->hard_header_len for MTU
calculation.

Fixes: 28e104d00281 ("net: ip_tunnel: fix mtu calculation")
Reported-by: Jianlin Shi <jishi@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv4/ip_tunnel.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index f6cc26de5ed3..0dca00745ac3 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -317,7 +317,7 @@ static int ip_tunnel_bind_dev(struct net_device *dev)
 	}
 
 	dev->needed_headroom = t_hlen + hlen;
-	mtu -= t_hlen;
+	mtu -= t_hlen + (dev->type == ARPHRD_ETHER ? dev->hard_header_len : 0);
 
 	if (mtu < IPV4_MIN_MTU)
 		mtu = IPV4_MIN_MTU;
@@ -348,6 +348,9 @@ static struct ip_tunnel *ip_tunnel_create(struct net *net,
 	t_hlen = nt->hlen + sizeof(struct iphdr);
 	dev->min_mtu = ETH_MIN_MTU;
 	dev->max_mtu = IP_MAX_MTU - t_hlen;
+	if (dev->type == ARPHRD_ETHER)
+		dev->max_mtu -= dev->hard_header_len;
+
 	ip_tunnel_add(itn, nt);
 	return nt;
 
@@ -489,11 +492,14 @@ static int tnl_update_pmtu(struct net_device *dev, struct sk_buff *skb,
 
 	tunnel_hlen = md ? tunnel_hlen : tunnel->hlen;
 	pkt_size = skb->len - tunnel_hlen;
+	pkt_size -= dev->type == ARPHRD_ETHER ? dev->hard_header_len : 0;
 
-	if (df)
+	if (df) {
 		mtu = dst_mtu(&rt->dst) - (sizeof(struct iphdr) + tunnel_hlen);
-	else
+		mtu -= dev->type == ARPHRD_ETHER ? dev->hard_header_len : 0;
+	} else {
 		mtu = skb_valid_dst(skb) ? dst_mtu(skb_dst(skb)) : dev->mtu;
+	}
 
 	if (skb_valid_dst(skb))
 		skb_dst_update_pmtu_no_confirm(skb, mtu);
@@ -972,6 +978,9 @@ int __ip_tunnel_change_mtu(struct net_device *dev, int new_mtu, bool strict)
 	int t_hlen = tunnel->hlen + sizeof(struct iphdr);
 	int max_mtu = IP_MAX_MTU - t_hlen;
 
+	if (dev->type == ARPHRD_ETHER)
+		max_mtu -= dev->hard_header_len;
+
 	if (new_mtu < ETH_MIN_MTU)
 		return -EINVAL;
 
@@ -1149,6 +1158,9 @@ int ip_tunnel_newlink(struct net_device *dev, struct nlattr *tb[],
 	if (tb[IFLA_MTU]) {
 		unsigned int max = IP_MAX_MTU - (nt->hlen + sizeof(struct iphdr));
 
+		if (dev->type == ARPHRD_ETHER)
+			max -= dev->hard_header_len;
+
 		mtu = clamp(dev->mtu, (unsigned int)ETH_MIN_MTU, max);
 	}
 
-- 
2.31.1

