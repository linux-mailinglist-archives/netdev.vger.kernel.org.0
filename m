Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBCD4A97BC
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 11:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237095AbiBDK0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 05:26:41 -0500
Received: from [185.13.181.2] ([185.13.181.2]:34594 "EHLO
        smtpservice.6wind.com" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S229851AbiBDK0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 05:26:41 -0500
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id 16E2460063;
        Fri,  4 Feb 2022 11:26:40 +0100 (CET)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1nFvnc-000177-0T; Fri, 04 Feb 2022 11:26:40 +0100
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     pablo@netfilter.org
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH libnetfilter_queue] libnetfilter_queue: add support of skb->priority
Date:   Fri,  4 Feb 2022 11:26:37 +0100
Message-Id: <20220204102637.4272-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <Yfy2YxiwvDLtLvTo@salvia>
References: <Yfy2YxiwvDLtLvTo@salvia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Available since linux v5.18.

Link: https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 .../libnetfilter_queue/libnetfilter_queue.h   |  3 +++
 include/linux/netfilter/nfnetlink_queue.h     | 16 +++++++++++++-
 src/libnetfilter_queue.c                      | 21 ++++++++++++++++++-
 3 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index a19122f10ec6..8a191dfdfeaf 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -96,6 +96,8 @@ extern struct nfqnl_msg_packet_hdr *
 
 extern uint32_t nfq_get_nfmark(struct nfq_data *nfad);
 
+extern uint32_t nfq_get_priority(struct nfq_data *nfad);
+
 extern int nfq_get_timestamp(struct nfq_data *nfad, struct timeval *tv);
 
 /* return 0 if not set */
@@ -132,6 +134,7 @@ enum {
 	NFQ_XML_UID	= (1 << 6),
 	NFQ_XML_GID	= (1 << 7),
 	NFQ_XML_SECCTX  = (1 << 8),
+	NFQ_XML_PRIORITY= (1 << 9),
 	NFQ_XML_ALL	= ~0U,
 };
 
diff --git a/include/linux/netfilter/nfnetlink_queue.h b/include/linux/netfilter/nfnetlink_queue.h
index 8e2e4697ffb0..ef7c97f21a15 100644
--- a/include/linux/netfilter/nfnetlink_queue.h
+++ b/include/linux/netfilter/nfnetlink_queue.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 #ifndef _NFNETLINK_QUEUE_H
 #define _NFNETLINK_QUEUE_H
 
@@ -30,6 +31,14 @@ struct nfqnl_msg_packet_timestamp {
 	__aligned_be64	usec;
 };
 
+enum nfqnl_vlan_attr {
+	NFQA_VLAN_UNSPEC,
+	NFQA_VLAN_PROTO,		/* __be16 skb vlan_proto */
+	NFQA_VLAN_TCI,			/* __be16 skb htons(vlan_tci) */
+	__NFQA_VLAN_MAX,
+};
+#define NFQA_VLAN_MAX (__NFQA_VLAN_MAX - 1)
+
 enum nfqnl_attr_type {
 	NFQA_UNSPEC,
 	NFQA_PACKET_HDR,
@@ -49,7 +58,10 @@ enum nfqnl_attr_type {
 	NFQA_EXP,			/* nfnetlink_conntrack.h */
 	NFQA_UID,			/* __u32 sk uid */
 	NFQA_GID,			/* __u32 sk gid */
-	NFQA_SECCTX,
+	NFQA_SECCTX,			/* security context string */
+	NFQA_VLAN,			/* nested attribute: packet vlan info */
+	NFQA_L2HDR,			/* full L2 header */
+	NFQA_PRIORITY,			/* skb->priority */
 
 	__NFQA_MAX
 };
@@ -111,5 +123,7 @@ enum nfqnl_attr_config {
 #define NFQA_SKB_CSUMNOTREADY (1 << 0)
 /* packet is GSO (i.e., exceeds device mtu) */
 #define NFQA_SKB_GSO (1 << 1)
+/* csum not validated (incoming device doesn't support hw checksum, etc.) */
+#define NFQA_SKB_CSUM_NOTVERIFIED (1 << 2)
 
 #endif /* _NFNETLINK_QUEUE_H */
diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
index a1701431d5d9..b5a3b399f5ea 100644
--- a/src/libnetfilter_queue.c
+++ b/src/libnetfilter_queue.c
@@ -1017,6 +1017,18 @@ uint32_t nfq_get_nfmark(struct nfq_data *nfad)
 	return ntohl(nfnl_get_data(nfad->data, NFQA_MARK, uint32_t));
 }
 
+/**
+ * nfq_get_priority - get the packet priority
+ * \param nfad Netlink packet data handle passed to callback function
+ *
+ * \return the packet priority currently assigned to the given queued packet.
+ */
+EXPORT_SYMBOL
+uint32_t nfq_get_priority(struct nfq_data *nfad)
+{
+	return ntohl(nfnl_get_data(nfad->data, NFQA_PRIORITY, uint32_t));
+}
+
 /**
  * nfq_get_timestamp - get the packet timestamp
  * \param nfad Netlink packet data handle passed to callback function
@@ -1403,6 +1415,7 @@ do {								\
  *	- NFQ_XML_PHYSDEV: include the physical device information
  *	- NFQ_XML_PAYLOAD: include the payload (in hexadecimal)
  *	- NFQ_XML_TIME: include the timestamp
+ *	- NFQ_XML_PRIORITY: include the packet priority
  *	- NFQ_XML_ALL: include all the logging information (all flags set)
  *
  * You can combine this flags with an binary OR.
@@ -1416,7 +1429,7 @@ int nfq_snprintf_xml(char *buf, size_t rem, struct nfq_data *tb, int flags)
 {
 	struct nfqnl_msg_packet_hdr *ph;
 	struct nfqnl_msg_packet_hw *hwph;
-	uint32_t mark, ifi;
+	uint32_t mark, ifi, priority;
 	uint32_t uid, gid;
 	int size, offset = 0, len = 0, ret;
 	unsigned char *data;
@@ -1507,6 +1520,12 @@ int nfq_snprintf_xml(char *buf, size_t rem, struct nfq_data *tb, int flags)
 		SNPRINTF_FAILURE(size, rem, offset, len);
 	}
 
+	priority = nfq_get_priority(tb);
+	if (priority && (flags & NFQ_XML_PRIORITY)) {
+		size = snprintf(buf + offset, rem, "<priority>%u</priority>", priority);
+		SNPRINTF_FAILURE(size, rem, offset, len);
+	}
+
 	ifi = nfq_get_indev(tb);
 	if (ifi && (flags & NFQ_XML_DEV)) {
 		size = snprintf(buf + offset, rem, "<indev>%u</indev>", ifi);
-- 
2.33.0

