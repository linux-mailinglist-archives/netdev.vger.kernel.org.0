Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8074A9D2B
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 17:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376675AbiBDQyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 11:54:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:48542 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376673AbiBDQyG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 11:54:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643993646; x=1675529646;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W6Z2hTqpTwJmxAmL9WZGv3EtNn3yR19SmpsVjDa05vU=;
  b=PuUhpKEcJuRGPYrJcTi/fWxgkaqxhJBw/RW3BNwIIpCZ2PY7vUMWLBOm
   e49LAdHQaG1b0DdybDhExgsSIvBTNSGqtborAu+T9ruJSPJO9/+0IaOHr
   f7F8TmXCLQmv9YRgjMvGYWGG0f4NROFd3wyu1MWIxBtSHBIN22YpJ4ZbN
   Je2flEEFqzGoV5ugCc+ix2UYSa0IdMWnGP+mt/EuBwBhv0oR1hxeAOfty
   0CapNRgE8kM/JC4QI2F2WhCMCWbCdbmhNgkwQrcNissDPd3et/1q/+EfI
   b9FCFW7CVhwUaWOKb/wpQEDqkIYA7ErIY5SfIv5b2GTF0WLLVQ90XB1Po
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10247"; a="245989138"
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="245989138"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 08:54:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="600278307"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 04 Feb 2022 08:54:04 -0800
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 214Gs32D026658;
        Fri, 4 Feb 2022 16:54:03 GMT
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, osmocom-net-gprs@lists.osmocom.org
Subject: [RFC PATCH net-next v4 4/6] gtp: Implement GTP echo response
Date:   Fri,  4 Feb 2022 17:51:01 +0100
Message-Id: <20220204165101.10673-1-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220204164929.10356-1-marcin.szycik@linux.intel.com>
References: <20220204164929.10356-1-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

Adding GTP device through ip link creates the situation where
there is no userspace daemon which would handle GTP messages
(Echo Request for example). GTP-U instance which would not respond
to echo requests would violate GTP specification.

When GTP packet arrives with GTP_ECHO_REQ message type,
GTP_ECHO_RSP is send to the sender. GTP_ECHO_RSP message
should contain information element with GTPIE_RECOVERY tag and
restart counter value. For GTPv1 restart counter is not used
and should be equal to 0, for GTPv0 restart counter contains
information provided from userspace(IFLA_GTP_RESTART_COUNT).

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
 drivers/net/gtp.c            | 212 ++++++++++++++++++++++++++++++++---
 include/net/gtp.h            |  31 +++++
 include/uapi/linux/if_link.h |   1 +
 3 files changed, 228 insertions(+), 16 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 6fa1cfe023ef..d20bc272ff6c 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -75,6 +75,8 @@ struct gtp_dev {
 	unsigned int		hash_size;
 	struct hlist_head	*tid_hash;
 	struct hlist_head	*addr_hash;
+
+	u8			restart_count;
 };
 
 static unsigned int gtp_net_id __read_mostly;
@@ -217,6 +219,106 @@ static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
 	return -1;
 }
 
+static struct rtable *ip4_route_output_gtp(struct flowi4 *fl4,
+					   const struct sock *sk,
+					   __be32 daddr, __be32 saddr)
+{
+	memset(fl4, 0, sizeof(*fl4));
+	fl4->flowi4_oif		= sk->sk_bound_dev_if;
+	fl4->daddr		= daddr;
+	fl4->saddr		= saddr;
+	fl4->flowi4_tos		= RT_CONN_FLAGS(sk);
+	fl4->flowi4_proto	= sk->sk_protocol;
+
+	return ip_route_output_key(sock_net(sk), fl4);
+}
+
+/* GSM TS 09.60. 7.3
+ * In all Path Management messages:
+ * - TID: is not used and shall be set to 0.
+ * - Flow Label is not used and shall be set to 0
+ * In signalling messages:
+ * - number: this field is not yet used in signalling messages.
+ *   It shall be set to 255 by the sender and shall be ignored
+ *   by the receiver
+ * Returns true if the echo req was correct, false otherwise.
+ */
+static bool gtp0_validate_echo_req(struct gtp0_header *gtp0)
+{
+	return !(gtp0->tid || (gtp0->flags ^ 0x1e) ||
+		gtp0->number != 0xff || gtp0->flow);
+}
+
+static int gtp0_echo_resp(struct gtp_dev *gtp, struct sk_buff *skb)
+{
+	struct gtp0_packet *gtp_pkt;
+	struct gtp0_header *gtp0;
+	struct rtable *rt;
+	struct flowi4 fl4;
+	struct iphdr *iph;
+	__be16 seq;
+
+	gtp0 = (struct gtp0_header *)(skb->data + sizeof(struct udphdr));
+
+	if (!gtp0_validate_echo_req(gtp0))
+		return -1;
+
+	seq = gtp0->seq;
+
+	/* pull GTP and UDP headers */
+	skb_pull_data(skb, sizeof(struct gtp0_header) + sizeof(struct udphdr));
+
+	gtp_pkt = skb_push(skb, sizeof(struct gtp0_packet));
+	memset(gtp_pkt, 0, sizeof(struct gtp0_packet));
+
+	gtp_pkt->gtp0_h.flags = 0x1e; /* v0, GTP-non-prime. */
+	gtp_pkt->gtp0_h.type = GTP_ECHO_RSP;
+	gtp_pkt->gtp0_h.length =
+		htons(sizeof(struct gtp0_packet) - sizeof(struct gtp0_header));
+
+	/* GSM TS 09.60. 7.3 The Sequence Number in a signalling response
+	 * message shall be copied from the signalling request message
+	 * that the GSN is replying to.
+	 */
+	gtp_pkt->gtp0_h.seq = seq;
+
+	/* GSM TS 09.60. 7.3 In all Path Management Flow Label and TID
+	 * are not used and shall be set to 0.
+	 */
+	gtp_pkt->gtp0_h.flow = 0;
+	gtp_pkt->gtp0_h.tid = 0;
+	gtp_pkt->gtp0_h.number = 0xff;
+	gtp_pkt->gtp0_h.spare[0] = 0xff;
+	gtp_pkt->gtp0_h.spare[1] = 0xff;
+	gtp_pkt->gtp0_h.spare[2] = 0xff;
+
+	gtp_pkt->ie.tag = GTPIE_RECOVERY;
+	gtp_pkt->ie.val = gtp->restart_count;
+
+	iph = ip_hdr(skb);
+
+	/* find route to the sender,
+	 * src address becomes dst address and vice versa.
+	 */
+	rt = ip4_route_output_gtp(&fl4, gtp->sk0, iph->saddr, iph->daddr);
+	if (IS_ERR(rt)) {
+		netdev_dbg(gtp->dev, "no route for echo response from %pI4\n",
+			   &iph->saddr);
+		return -1;
+	}
+
+	udp_tunnel_xmit_skb(rt, gtp->sk0, skb,
+			    fl4.saddr, fl4.daddr,
+			    iph->tos,
+			    ip4_dst_hoplimit(&rt->dst),
+			    0,
+			    htons(GTP0_PORT), htons(GTP0_PORT),
+			    !net_eq(sock_net(gtp->sk1u),
+				    dev_net(gtp->dev)),
+			    false);
+	return 0;
+}
+
 /* 1 means pass up to the stack, -1 means drop and 0 means decapsulated. */
 static int gtp0_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 {
@@ -233,6 +335,13 @@ static int gtp0_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 	if ((gtp0->flags >> 5) != GTP_V0)
 		return 1;
 
+	/* If the sockets were created in kernel, it means that
+	 * there is no daemon running in userspace which would
+	 * handle echo request.
+	 */
+	if (gtp0->type == GTP_ECHO_REQ && gtp->sk_created)
+		return gtp0_echo_resp(gtp, skb);
+
 	if (gtp0->type != GTP_TPDU)
 		return 1;
 
@@ -245,6 +354,74 @@ static int gtp0_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 	return gtp_rx(pctx, skb, hdrlen, gtp->role);
 }
 
+static int gtp1u_echo_resp(struct gtp_dev *gtp, struct sk_buff *skb)
+{
+	struct gtp1_header_long *gtp1u;
+	struct gtp1u_packet *gtp_pkt;
+	struct rtable *rt;
+	struct flowi4 fl4;
+	struct iphdr *iph;
+
+	gtp1u = (struct gtp1_header_long *)(skb->data + sizeof(struct udphdr));
+
+	/* 3GPP TS 29.281 5.1 - For the Echo Request, Echo Response,
+	 * Error Indication and Supported Extension Headers Notification
+	 * messages, the S flag shall be set to 1 and TEID shall be set to 0.
+	 */
+	if (!(gtp1u->flags & GTP1_F_SEQ) || gtp1u->tid)
+		return -1;
+
+	/* pull GTP and UDP headers */
+	skb_pull_data(skb, sizeof(struct gtp1_header_long) + sizeof(struct udphdr));
+
+	gtp_pkt = skb_push(skb, sizeof(struct gtp1u_packet));
+	memset(gtp_pkt, 0, sizeof(struct gtp1u_packet));
+
+	/* S flag must be set to 1 */
+	gtp_pkt->gtp1u_h.flags = 0x32;
+	gtp_pkt->gtp1u_h.type = GTP_ECHO_RSP;
+	/* seq, npdu and next should be counted to the length of the GTP packet
+	 * that's why szie of gtp1_header should be subtracted,
+	 * not why szie of gtp1_header_long.
+	 */
+	gtp_pkt->gtp1u_h.length =
+		htons(sizeof(struct gtp1u_packet) - sizeof(struct gtp1_header));
+	/* 3GPP TS 29.281 5.1 - TEID has to be set to 0 */
+	gtp_pkt->gtp1u_h.tid = 0;
+
+	/* 3GPP TS 29.281 7.7.2 - The Restart Counter value in the
+	 * Recovery information element shall not be used, i.e. it shall
+	 * be set to zero by the sender and shall be ignored by the receiver.
+	 * The Recovery information element is mandatory due to backwards
+	 * compatibility reasons.
+	 */
+	gtp_pkt->ie.tag = GTPIE_RECOVERY;
+	gtp_pkt->ie.val = 0;
+
+	iph = ip_hdr(skb);
+
+	/* find route to the sender,
+	 * src address becomes dst address and vice versa.
+	 */
+	rt = ip4_route_output_gtp(&fl4, gtp->sk1u, iph->saddr, iph->daddr);
+	if (IS_ERR(rt)) {
+		netdev_dbg(gtp->dev, "no route for echo response from %pI4\n",
+			   &iph->saddr);
+		return -1;
+	}
+
+	udp_tunnel_xmit_skb(rt, gtp->sk1u, skb,
+			    fl4.saddr, fl4.daddr,
+			    iph->tos,
+			    ip4_dst_hoplimit(&rt->dst),
+			    0,
+			    htons(GTP1U_PORT), htons(GTP1U_PORT),
+			    !net_eq(sock_net(gtp->sk1u),
+				    dev_net(gtp->dev)),
+			    false);
+	return 0;
+}
+
 static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 {
 	unsigned int hdrlen = sizeof(struct udphdr) +
@@ -260,6 +437,13 @@ static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 	if ((gtp1->flags >> 5) != GTP_V1)
 		return 1;
 
+	/* If the sockets were created in kernel, it means that
+	 * there is no daemon running in userspace which would
+	 * handle echo request.
+	 */
+	if (gtp1->type == GTP_ECHO_REQ && gtp->sk_created)
+		return gtp1u_echo_resp(gtp, skb);
+
 	if (gtp1->type != GTP_TPDU)
 		return 1;
 
@@ -398,20 +582,6 @@ static void gtp_dev_uninit(struct net_device *dev)
 	free_percpu(dev->tstats);
 }
 
-static struct rtable *ip4_route_output_gtp(struct flowi4 *fl4,
-					   const struct sock *sk,
-					   __be32 daddr)
-{
-	memset(fl4, 0, sizeof(*fl4));
-	fl4->flowi4_oif		= sk->sk_bound_dev_if;
-	fl4->daddr		= daddr;
-	fl4->saddr		= inet_sk(sk)->inet_saddr;
-	fl4->flowi4_tos		= RT_CONN_FLAGS(sk);
-	fl4->flowi4_proto	= sk->sk_protocol;
-
-	return ip_route_output_key(sock_net(sk), fl4);
-}
-
 static inline void gtp0_push_header(struct sk_buff *skb, struct pdp_ctx *pctx)
 {
 	int payload_len = skb->len;
@@ -517,7 +687,8 @@ static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
 	}
 	netdev_dbg(dev, "found PDP context %p\n", pctx);
 
-	rt = ip4_route_output_gtp(&fl4, pctx->sk, pctx->peer_addr_ip4.s_addr);
+	rt = ip4_route_output_gtp(&fl4, pctx->sk, pctx->peer_addr_ip4.s_addr,
+				  inet_sk(pctx->sk)->inet_saddr);
 	if (IS_ERR(rt)) {
 		netdev_dbg(dev, "no route to SSGN %pI4\n",
 			   &pctx->peer_addr_ip4.s_addr);
@@ -684,6 +855,11 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
 			hashsize = 1024;
 	}
 
+	if (!data[IFLA_GTP_RESTART_COUNT])
+		gtp->restart_count = 0;
+	else
+		gtp->restart_count = nla_get_u8(data[IFLA_GTP_RESTART_COUNT]);
+
 	gtp->net = src_net;
 
 	err = gtp_hashtable_new(gtp, hashsize);
@@ -735,6 +911,7 @@ static const struct nla_policy gtp_policy[IFLA_GTP_MAX + 1] = {
 	[IFLA_GTP_FD1]			= { .type = NLA_U32 },
 	[IFLA_GTP_PDP_HASHSIZE]		= { .type = NLA_U32 },
 	[IFLA_GTP_ROLE]			= { .type = NLA_U32 },
+	[IFLA_GTP_RESTART_COUNT]	= { .type = NLA_U8 },
 };
 
 static int gtp_validate(struct nlattr *tb[], struct nlattr *data[],
@@ -749,7 +926,8 @@ static int gtp_validate(struct nlattr *tb[], struct nlattr *data[],
 static size_t gtp_get_size(const struct net_device *dev)
 {
 	return nla_total_size(sizeof(__u32)) + /* IFLA_GTP_PDP_HASHSIZE */
-		nla_total_size(sizeof(__u32)); /* IFLA_GTP_ROLE */
+		nla_total_size(sizeof(__u32)) + /* IFLA_GTP_ROLE */
+		nla_total_size(sizeof(__u8)); /* IFLA_GTP_RESTART_COUNT */
 }
 
 static int gtp_fill_info(struct sk_buff *skb, const struct net_device *dev)
@@ -760,6 +938,8 @@ static int gtp_fill_info(struct sk_buff *skb, const struct net_device *dev)
 		goto nla_put_failure;
 	if (nla_put_u32(skb, IFLA_GTP_ROLE, gtp->role))
 		goto nla_put_failure;
+	if (nla_put_u8(skb, IFLA_GTP_RESTART_COUNT, gtp->restart_count))
+		goto nla_put_failure;
 
 	return 0;
 
diff --git a/include/net/gtp.h b/include/net/gtp.h
index c78702e3d663..53a712f73b13 100644
--- a/include/net/gtp.h
+++ b/include/net/gtp.h
@@ -7,8 +7,13 @@
 #define GTP0_PORT	3386
 #define GTP1U_PORT	2152
 
+/* GTP messages types */
+#define GTP_ECHO_REQ	1	/* Echo Request */
+#define GTP_ECHO_RSP	2	/* Echo Response */
 #define GTP_TPDU	255
 
+#define GTPIE_RECOVERY	14
+
 struct gtp0_header {	/* According to GSM TS 09.60. */
 	__u8	flags;
 	__u8	type;
@@ -27,11 +32,37 @@ struct gtp1_header {	/* According to 3GPP TS 29.060. */
 	__be32	tid;
 } __attribute__ ((packed));
 
+struct gtp1_header_long {	/* According to 3GPP TS 29.060. */
+	__u8	flags;
+	__u8	type;
+	__be16	length;
+	__be32	tid;
+	__be16	seq;
+	__u8	npdu;
+	__u8	next;
+} __packed;
+
 struct gtp_pdu_session_info {	/* According to 3GPP TS 38.415. */
 	u8	pdu_type;
 	u8	qfi;
 };
 
+/* GTP Information Element */
+struct gtp_ie {
+	__u8	tag;
+	__u8	val;
+} __packed;
+
+struct gtp0_packet {
+	struct gtp0_header gtp0_h;
+	struct gtp_ie ie;
+} __packed;
+
+struct gtp1u_packet {
+	struct gtp1_header_long gtp1u_h;
+	struct gtp_ie ie;
+} __packed;
+
 static inline bool netif_is_gtp(const struct net_device *dev)
 {
 	return dev->rtnl_link_ops &&
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 6218f93f5c1a..2fc5a0371283 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -822,6 +822,7 @@ enum {
 	IFLA_GTP_FD1,
 	IFLA_GTP_PDP_HASHSIZE,
 	IFLA_GTP_ROLE,
+	IFLA_GTP_RESTART_COUNT,
 	__IFLA_GTP_MAX,
 };
 #define IFLA_GTP_MAX (__IFLA_GTP_MAX - 1)
-- 
2.31.1

