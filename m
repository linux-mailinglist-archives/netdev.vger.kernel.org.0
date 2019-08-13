Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A208C0B7
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbfHMSh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:37:27 -0400
Received: from correo.us.es ([193.147.175.20]:58778 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728100AbfHMShZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 14:37:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0B99EB6322
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:37:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3E774CA35
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:37:22 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E9BABD190F; Tue, 13 Aug 2019 20:37:22 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DCFF21150CB;
        Tue, 13 Aug 2019 20:37:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 20:37:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.218.116])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8DA594265A2F;
        Tue, 13 Aug 2019 20:37:20 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 09/17] netfilter: add missing IS_ENABLED(CONFIG_BRIDGE_NETFILTER) checks to header-file.
Date:   Tue, 13 Aug 2019 20:36:53 +0200
Message-Id: <20190813183701.4002-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190813183701.4002-1-pablo@netfilter.org>
References: <20190813183701.4002-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

br_netfilter.h defines inline functions that use an enum constant and
struct member that are only defined if CONFIG_BRIDGE_NETFILTER is
enabled.  Added preprocessor checks to ensure br_netfilter.h will
compile if CONFIG_BRIDGE_NETFILTER is disabled.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.11.0


