Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2A71189840
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbgCRJom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:44:42 -0400
Received: from smtp-rs2-vallila1.fe.helsinki.fi ([128.214.173.73]:51552 "EHLO
        smtp-rs2-vallila1.fe.helsinki.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727577AbgCRJn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 05:43:57 -0400
Received: from whs-18.cs.helsinki.fi (whs-18.cs.helsinki.fi [128.214.166.46])
        by smtp-rs2.it.helsinki.fi (8.14.7/8.14.7) with ESMTP id 02I9honR012853;
        Wed, 18 Mar 2020 11:43:50 +0200
Received: by whs-18.cs.helsinki.fi (Postfix, from userid 1070048)
        id CDCDD36032A; Wed, 18 Mar 2020 11:43:50 +0200 (EET)
From:   =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
To:     netdev@vger.kernel.org
Cc:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Subject: [RFC PATCH 09/28] gso: AccECN support
Date:   Wed, 18 Mar 2020 11:43:13 +0200
Message-Id: <1584524612-24470-10-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>

Handling the CWR flag differs between RFC 3168 ECN and AccECN.
Take it into account in GSO by not clearing the CWR bit.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
---
 drivers/net/tun.c               | 3 ++-
 include/linux/netdev_features.h | 3 +++
 include/linux/skbuff.h          | 2 ++
 net/ethtool/common.c            | 1 +
 net/ipv4/tcp_offload.c          | 6 +++++-
 5 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 228fe449dc6d..d376a7cb0d63 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2788,7 +2788,8 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 
 		dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST |
 				   TUN_USER_FEATURES | NETIF_F_HW_VLAN_CTAG_TX |
-				   NETIF_F_HW_VLAN_STAG_TX;
+				   NETIF_F_HW_VLAN_STAG_TX |
+				   NETIF_F_GSO_ACCECN;
 		dev->features = dev->hw_features | NETIF_F_LLTX;
 		dev->vlan_features = dev->features &
 				     ~(NETIF_F_HW_VLAN_CTAG_TX |
diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 34d050bb1ae6..c7065b468d21 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -83,6 +83,7 @@ enum {
 	NETIF_F_HW_TLS_RECORD_BIT,	/* Offload TLS record */
 	NETIF_F_GRO_FRAGLIST_BIT,	/* Fraglist GRO */
 
+	NETIF_F_GSO_ACCECN_BIT,		/* ... TCP AccECN support */
 	/*
 	 * Add your fresh new feature above and remember to update
 	 * netdev_features_strings[] in net/core/ethtool.c and maybe
@@ -124,6 +125,7 @@ enum {
 #define NETIF_F_SG		__NETIF_F(SG)
 #define NETIF_F_TSO6		__NETIF_F(TSO6)
 #define NETIF_F_TSO_ECN		__NETIF_F(TSO_ECN)
+#define NETIF_F_GSO_ACCECN	__NETIF_F(GSO_ACCECN)
 #define NETIF_F_TSO		__NETIF_F(TSO)
 #define NETIF_F_VLAN_CHALLENGED	__NETIF_F(VLAN_CHALLENGED)
 #define NETIF_F_RXFCS		__NETIF_F(RXFCS)
@@ -205,6 +207,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 
 /* List of features with software fallbacks. */
 #define NETIF_F_GSO_SOFTWARE	(NETIF_F_ALL_TSO | \
+				 NETIF_F_GSO_ACCECN | \
 				 NETIF_F_GSO_SCTP)
 
 /*
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 21749b2cdc9b..fdd73dc126a2 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -594,6 +594,8 @@ enum {
 	SKB_GSO_UDP_L4 = 1 << 17,
 
 	SKB_GSO_FRAGLIST = 1 << 18,
+
+	SKB_GSO_TCP_ACCECN = 1 << 19,
 };
 
 #if BITS_PER_LONG > 32
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 7b6969af5ae7..26241b5d62a4 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -27,6 +27,7 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN] = {
 	[NETIF_F_TSO_BIT] =              "tx-tcp-segmentation",
 	[NETIF_F_GSO_ROBUST_BIT] =       "tx-gso-robust",
 	[NETIF_F_TSO_ECN_BIT] =          "tx-tcp-ecn-segmentation",
+	[NETIF_F_GSO_ACCECN_BIT] =       "tx-tcp-accecn-segmentation",
 	[NETIF_F_TSO_MANGLEID_BIT] =	 "tx-tcp-mangleid-segmentation",
 	[NETIF_F_TSO6_BIT] =             "tx-tcp6-segmentation",
 	[NETIF_F_FSO_BIT] =              "tx-fcoe-segmentation",
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index e09147ac9a99..7a81cf438010 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -65,6 +65,7 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 	struct sk_buff *gso_skb = skb;
 	__sum16 newcheck;
 	bool ooo_okay, copy_destructor;
+	bool ecn_cwr_mask;
 
 	th = tcp_hdr(skb);
 	thlen = th->doff * 4;
@@ -121,6 +122,8 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 	newcheck = ~csum_fold((__force __wsum)((__force u32)th->check +
 					       (__force u32)delta));
 
+	ecn_cwr_mask = !!(skb_shinfo(gso_skb)->gso_type & SKB_GSO_TCP_ACCECN);
+
 	while (skb->next) {
 		th->fin = th->psh = 0;
 		th->check = newcheck;
@@ -140,7 +143,8 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 		th = tcp_hdr(skb);
 
 		th->seq = htonl(seq);
-		th->cwr = 0;
+
+		th->cwr &= ecn_cwr_mask;
 	}
 
 	/* Following permits TCP Small Queues to work well with GSO :
-- 
2.20.1

