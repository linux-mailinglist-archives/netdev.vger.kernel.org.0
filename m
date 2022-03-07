Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93ADD4CFDE6
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 13:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239690AbiCGMMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 07:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237610AbiCGMMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 07:12:44 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E330B7B54B
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 04:11:49 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 104BF205A4
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 13:11:47 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wa1oOUZXgWU0 for <netdev@vger.kernel.org>;
        Mon,  7 Mar 2022 13:11:46 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 7594320504
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 13:11:46 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 7084C80004A
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 13:11:46 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Mon, 7 Mar 2022 13:11:46 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 7 Mar
 2022 13:11:46 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id E6BD03182EA9; Mon,  7 Mar 2022 13:11:45 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <netdev@vger.kernel.org>
CC:     Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH ipsec 3/3] net: Fix esp GSO on inter address family tunnels.
Date:   Mon, 7 Mar 2022 13:11:41 +0100
Message-ID: <20220307121141.1921944-4-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220307121141.1921944-1-steffen.klassert@secunet.com>
References: <20220307121141.1921944-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The esp tunnel GSO handlers use skb_mac_gso_segment to
push the inner packet to the segmentation handlers.
However, skb_mac_gso_segment takes the Ethernet Protocol
ID from 'skb->protocol' which is wrong for inter address
family tunnels. We fix this by introducing a new
skb_eth_gso_segment function.

This function can be used if it is necessary to pass the
Ethernet Protocol ID directly to the segmentation handler.
First users of this function will be the esp4 and esp6
tunnel segmentation handlers.

Fixes: c35fe4106b92 ("xfrm: Add mode handlers for IPsec on layer 2")
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/linux/netdevice.h |  2 ++
 net/core/gro.c            | 25 +++++++++++++++++++++++++
 net/ipv4/esp4_offload.c   |  3 +--
 net/ipv6/esp6_offload.c   |  3 +--
 4 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e490b84732d1..b1e59ccbb8e7 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4602,6 +4602,8 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 
 struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 				  netdev_features_t features, bool tx_path);
+struct sk_buff *skb_eth_gso_segment(struct sk_buff *skb,
+				    netdev_features_t features, __be16 type);
 struct sk_buff *skb_mac_gso_segment(struct sk_buff *skb,
 				    netdev_features_t features);
 
diff --git a/net/core/gro.c b/net/core/gro.c
index a11b286d1495..b7d2b0dc59a2 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -92,6 +92,31 @@ void dev_remove_offload(struct packet_offload *po)
 }
 EXPORT_SYMBOL(dev_remove_offload);
 
+/**
+ *	skb_eth_gso_segment - segmentation handler for ethernet protocols.
+ *	@skb: buffer to segment
+ *	@features: features for the output path (see dev->features)
+ *	@type: Ethernet Protocol ID
+ */
+struct sk_buff *skb_eth_gso_segment(struct sk_buff *skb,
+				    netdev_features_t features, __be16 type)
+{
+	struct sk_buff *segs = ERR_PTR(-EPROTONOSUPPORT);
+	struct packet_offload *ptype;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ptype, &offload_base, list) {
+		if (ptype->type == type && ptype->callbacks.gso_segment) {
+			segs = ptype->callbacks.gso_segment(skb, features);
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return segs;
+}
+EXPORT_SYMBOL(skb_eth_gso_segment);
+
 /**
  *	skb_mac_gso_segment - mac layer segmentation handler.
  *	@skb: buffer to segment
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 146d4d54830c..935026f4c807 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -110,8 +110,7 @@ static struct sk_buff *xfrm4_tunnel_gso_segment(struct xfrm_state *x,
 						struct sk_buff *skb,
 						netdev_features_t features)
 {
-	__skb_push(skb, skb->mac_len);
-	return skb_mac_gso_segment(skb, features);
+	return skb_eth_gso_segment(skb, features, htons(ETH_P_IP));
 }
 
 static struct sk_buff *xfrm4_transport_gso_segment(struct xfrm_state *x,
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index e61172d50817..3a293838a91d 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -145,8 +145,7 @@ static struct sk_buff *xfrm6_tunnel_gso_segment(struct xfrm_state *x,
 						struct sk_buff *skb,
 						netdev_features_t features)
 {
-	__skb_push(skb, skb->mac_len);
-	return skb_mac_gso_segment(skb, features);
+	return skb_eth_gso_segment(skb, features, htons(ETH_P_IPV6));
 }
 
 static struct sk_buff *xfrm6_transport_gso_segment(struct xfrm_state *x,
-- 
2.25.1

