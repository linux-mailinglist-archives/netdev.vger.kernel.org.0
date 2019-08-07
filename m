Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6DA84E6A
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 16:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388144AbfHGORK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 10:17:10 -0400
Received: from kadath.azazel.net ([81.187.231.250]:45992 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730018AbfHGORK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 10:17:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NXYlR+HQFy6Sx3WKUA4m6Y2xbDfp30z/3OvKHIZmSz4=; b=JcHs9iQUOwQu6eK0Rp6bunJAyf
        9uR1HrBaVXK3EN9rOFZTX5+sfiNbY4QjJMOGFopHeRQ+a4P98vayC0HjOCVMbUz67uRziMKPX5hs3
        e6PPLT5L+tq5jhmYa4z5Nggjfh5yDhSpsmVBxJKhRtmD5Rj1o4Jicme+UHZ4/GjhsRANbJjBGIl5B
        4f9mhbSq06as7EqzXrFD59g4EioUXb6SMs5vW5YxOweClC7aZE5j3pVEf/fwmBv46msjxA+mnR3+8
        lOBm3EdzqgYlCtzsccW4tBEUU4m4jFXt5wrOYaycDl/FcskD/BGb6zouz+eY+y1RpHFOEreo5orTA
        vZdZ5Evg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hvMkU-0001Wc-Jw; Wed, 07 Aug 2019 15:17:06 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Net Dev <netdev@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH net-next v1 3/8] netfilter: added missing IS_ENABLED(CONFIG_BRIDGE_NETFILTER) checks to header-file.
Date:   Wed,  7 Aug 2019 15:17:00 +0100
Message-Id: <20190807141705.4864-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190807141705.4864-1-jeremy@azazel.net>
References: <20190722201615.GE23346@azazel.net>
 <20190807141705.4864-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

br_netfilter.h defines inline functions that use an enum constant and
struct member that are only defined if CONFIG_BRIDGE_NETFILTER is
enabled.  Added preprocessor checks to ensure br_netfilter.h will
compile if CONFIG_BRIDGE_NETFILTER is disabled.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/net/netfilter/br_netfilter.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/net/netfilter/br_netfilter.h b/include/net/netfilter/br_netfilter.h
index ca121ed906df..33533ea852a1 100644
--- a/include/net/netfilter/br_netfilter.h
+++ b/include/net/netfilter/br_netfilter.h
@@ -8,12 +8,16 @@
 
 static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
 {
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	struct nf_bridge_info *b = skb_ext_add(skb, SKB_EXT_BRIDGE_NF);
 
 	if (b)
 		memset(b, 0, sizeof(*b));
 
 	return b;
+#else
+	return NULL;
+#endif
 }
 
 void nf_bridge_update_protocol(struct sk_buff *skb);
@@ -38,10 +42,14 @@ int br_nf_pre_routing_finish_bridge(struct net *net, struct sock *sk, struct sk_
 
 static inline struct rtable *bridge_parent_rtable(const struct net_device *dev)
 {
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	struct net_bridge_port *port;
 
 	port = br_port_get_rcu(dev);
 	return port ? &port->br->fake_rtable : NULL;
+#else
+	return NULL;
+#endif
 }
 
 struct net_device *setup_pre_routing(struct sk_buff *skb,
-- 
2.20.1

