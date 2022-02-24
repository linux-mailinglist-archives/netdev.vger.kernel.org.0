Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C1D4C352F
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 19:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbiBXS4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 13:56:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233130AbiBXS4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 13:56:03 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA298251E4C
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 10:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645728931; x=1677264931;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AdMUYQl+HdC3ug2pla7sVu6pXcubxY5AmBq1sUSGKdE=;
  b=MCCaBAxGLLfAdVR2LGotlI3kdEYABlJhsBZV3T9nudVcDQJ8ypf4mv1W
   SGMPL1KoYdvdtk/Yz2iFh2iJBHHOxtg0Qg8R+4SfPg3tbtXSd+Fnz8cZc
   eDIiwY0L7qNS9j8UJvaHz6r4s7SE5PbrKYv1sigGmdi9Buef+JhH5iT5X
   xhTBS8XR++YTIndiCsp7oZW2kn4OBWZKS3ben73k9duls84dBZj45o7tU
   qYh2TweBCmaHDWi+ctlCQU3zN7STog2sGiVaxN4FytgL9g8FBaji2ndlk
   O0rkAizZypIZ0mxeS0fSCa9tsPesYGtke4ROaLtF5Sobh9ad9JmDbYLhK
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="235829793"
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="235829793"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 10:55:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,134,1643702400"; 
   d="scan'208";a="592192780"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga008.fm.intel.com with ESMTP; 24 Feb 2022 10:55:14 -0800
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 21OIt5Z0018029;
        Thu, 24 Feb 2022 18:55:13 GMT
From:   Marcin Szycik <marcin.szycik@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, jiri@resnulli.us,
        osmocom-net-gprs@lists.osmocom.org,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next v9 3/7] gtp: Implement GTP echo request
Date:   Thu, 24 Feb 2022 19:54:56 +0100
Message-Id: <20220224185500.18384-4-marcin.szycik@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224185500.18384-1-marcin.szycik@linux.intel.com>
References: <20220224185500.18384-1-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

Adding GTP device through ip link creates the situation where
GTP instance is not able to send GTP echo requests.
Echo requests are used to check if GTP peer is still alive.
With this patch, gtp_genl_ops are extended by new cmd (GTP_CMD_ECHOREQ)
which allows to send echo request in the given version of GTP
protocol (v0 or v1), from the given ms address to he given
peer. TID is not inclued because in all path management
messages it should be equal to 0.

When GTP echo response is detected, multicast message is
send to everyone in the gtp_genl_family. Message contains
GTP version, ms address and peer address.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Suggested-by: Harald Welte <laforge@gnumonks.org>
---
v8: Handling of GTP Echo Response removed
v9: Implement sending multicast message when echo response
    is detected
---
 drivers/net/gtp.c        | 290 ++++++++++++++++++++++++++++++++++-----
 include/uapi/linux/gtp.h |   1 +
 2 files changed, 254 insertions(+), 37 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 5ed24fa9d5b2..5caf5cfa91a4 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -79,6 +79,12 @@ struct gtp_dev {
 	u8			restart_count;
 };
 
+struct echo_info {
+	struct in_addr		ms_addr_ip4;
+	struct in_addr		peer_addr_ip4;
+	u8			gtp_version;
+};
+
 static unsigned int gtp_net_id __read_mostly;
 
 struct gtp_net {
@@ -87,6 +93,16 @@ struct gtp_net {
 
 static u32 gtp_h_initval;
 
+static struct genl_family gtp_genl_family;
+
+enum gtp_multicast_groups {
+	GTP_GENL_MCGRP,
+};
+
+static const struct genl_multicast_group gtp_genl_mcgrps[] = {
+	[GTP_GENL_MCGRP] = { .name = GTP_GENL_MCGRP_NAME },
+};
+
 static void pdp_context_delete(struct pdp_ctx *pctx);
 
 static inline u32 gtp0_hashfn(u64 tid)
@@ -243,12 +259,34 @@ static struct rtable *ip4_route_output_gtp(struct flowi4 *fl4,
  *   by the receiver
  * Returns true if the echo req was correct, false otherwise.
  */
-static bool gtp0_validate_echo_req(struct gtp0_header *gtp0)
+static bool gtp0_validate_echo_hdr(struct gtp0_header *gtp0)
 {
 	return !(gtp0->tid || (gtp0->flags ^ 0x1e) ||
 		gtp0->number != 0xff || gtp0->flow);
 }
 
+/* msg_type has to be GTP_ECHO_REQ or GTP_ECHO_RSP */
+static void gtp0_build_echo_msg(struct gtp0_header *hdr, __u8 msg_type)
+{
+	hdr->flags = 0x1e; /* v0, GTP-non-prime. */
+	hdr->type = msg_type;
+	/* GSM TS 09.60. 7.3 In all Path Management Flow Label and TID
+	 * are not used and shall be set to 0.
+	 */
+	hdr->flow = 0;
+	hdr->tid = 0;
+	hdr->number = 0xff;
+	hdr->spare[0] = 0xff;
+	hdr->spare[1] = 0xff;
+	hdr->spare[2] = 0xff;
+
+	if (msg_type == GTP_ECHO_RSP)
+		hdr->length =
+			htons(sizeof(struct gtp0_packet) - sizeof(struct gtp0_header));
+	else
+		hdr->length = 0;
+}
+
 static int gtp0_send_echo_resp(struct gtp_dev *gtp, struct sk_buff *skb)
 {
 	struct gtp0_packet *gtp_pkt;
@@ -260,7 +298,7 @@ static int gtp0_send_echo_resp(struct gtp_dev *gtp, struct sk_buff *skb)
 
 	gtp0 = (struct gtp0_header *)(skb->data + sizeof(struct udphdr));
 
-	if (!gtp0_validate_echo_req(gtp0))
+	if (!gtp0_validate_echo_hdr(gtp0))
 		return -1;
 
 	seq = gtp0->seq;
@@ -271,10 +309,7 @@ static int gtp0_send_echo_resp(struct gtp_dev *gtp, struct sk_buff *skb)
 	gtp_pkt = skb_push(skb, sizeof(struct gtp0_packet));
 	memset(gtp_pkt, 0, sizeof(struct gtp0_packet));
 
-	gtp_pkt->gtp0_h.flags = 0x1e; /* v0, GTP-non-prime. */
-	gtp_pkt->gtp0_h.type = GTP_ECHO_RSP;
-	gtp_pkt->gtp0_h.length =
-		htons(sizeof(struct gtp0_packet) - sizeof(struct gtp0_header));
+	gtp0_build_echo_msg(&gtp_pkt->gtp0_h, GTP_ECHO_RSP);
 
 	/* GSM TS 09.60. 7.3 The Sequence Number in a signalling response
 	 * message shall be copied from the signalling request message
@@ -282,16 +317,6 @@ static int gtp0_send_echo_resp(struct gtp_dev *gtp, struct sk_buff *skb)
 	 */
 	gtp_pkt->gtp0_h.seq = seq;
 
-	/* GSM TS 09.60. 7.3 In all Path Management Flow Label and TID
-	 * are not used and shall be set to 0.
-	 */
-	gtp_pkt->gtp0_h.flow = 0;
-	gtp_pkt->gtp0_h.tid = 0;
-	gtp_pkt->gtp0_h.number = 0xff;
-	gtp_pkt->gtp0_h.spare[0] = 0xff;
-	gtp_pkt->gtp0_h.spare[1] = 0xff;
-	gtp_pkt->gtp0_h.spare[2] = 0xff;
-
 	gtp_pkt->ie.tag = GTPIE_RECOVERY;
 	gtp_pkt->ie.val = gtp->restart_count;
 
@@ -319,6 +344,61 @@ static int gtp0_send_echo_resp(struct gtp_dev *gtp, struct sk_buff *skb)
 	return 0;
 }
 
+static int gtp_genl_fill_echo(struct sk_buff *skb, u32 snd_portid, u32 snd_seq,
+			      int flags, u32 type, struct echo_info echo)
+{
+	void *genlh;
+
+	genlh = genlmsg_put(skb, snd_portid, snd_seq, &gtp_genl_family, flags,
+			    type);
+	if (!genlh)
+		goto failure;
+
+	if (nla_put_u32(skb, GTPA_VERSION, echo.gtp_version) ||
+	    nla_put_be32(skb, GTPA_PEER_ADDRESS, echo.peer_addr_ip4.s_addr) ||
+	    nla_put_be32(skb, GTPA_MS_ADDRESS, echo.ms_addr_ip4.s_addr))
+		goto failure;
+
+	genlmsg_end(skb, genlh);
+	return 0;
+
+failure:
+	genlmsg_cancel(skb, genlh);
+	return -EMSGSIZE;
+}
+
+static int gtp0_handle_echo_resp(struct gtp_dev *gtp, struct sk_buff *skb)
+{
+	struct gtp0_header *gtp0;
+	struct echo_info echo;
+	struct sk_buff *msg;
+	struct iphdr *iph;
+	int ret;
+
+	gtp0 = (struct gtp0_header *)(skb->data + sizeof(struct udphdr));
+
+	if (!gtp0_validate_echo_hdr(gtp0))
+		return -1;
+
+	iph = ip_hdr(skb);
+	echo.ms_addr_ip4.s_addr = iph->daddr;
+	echo.peer_addr_ip4.s_addr = iph->saddr;
+	echo.gtp_version = GTP_V0;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!msg)
+		return -ENOMEM;
+
+	ret = gtp_genl_fill_echo(msg, 0, 0, 0, GTP_CMD_ECHOREQ, echo);
+	if (ret < 0) {
+		nlmsg_free(msg);
+		return ret;
+	}
+
+	return genlmsg_multicast_netns(&gtp_genl_family, dev_net(gtp->dev),
+				       msg, 0, GTP_GENL_MCGRP, GFP_ATOMIC);
+}
+
 /* 1 means pass up to the stack, -1 means drop and 0 means decapsulated. */
 static int gtp0_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 {
@@ -342,6 +422,9 @@ static int gtp0_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 	if (gtp0->type == GTP_ECHO_REQ && gtp->sk_created)
 		return gtp0_send_echo_resp(gtp, skb);
 
+	if (gtp0->type == GTP_ECHO_RSP && gtp->sk_created)
+		return gtp0_handle_echo_resp(gtp, skb);
+
 	if (gtp0->type != GTP_TPDU)
 		return 1;
 
@@ -354,6 +437,27 @@ static int gtp0_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 	return gtp_rx(pctx, skb, hdrlen, gtp->role);
 }
 
+/* msg_type has to be GTP_ECHO_REQ or GTP_ECHO_RSP */
+static void gtp1u_build_echo_msg(struct gtp1_header_long *hdr, __u8 msg_type)
+{
+	/* S flag must be set to 1 */
+	hdr->flags = 0x32; /* v1, GTP-non-prime. */
+	hdr->type = msg_type;
+	/* 3GPP TS 29.281 5.1 - TEID has to be set to 0 */
+	hdr->tid = 0;
+
+	/* seq, npdu and next should be counted to the length of the GTP packet
+	 * that's why szie of gtp1_header should be subtracted,
+	 * not size of gtp1_header_long.
+	 */
+	if (msg_type == GTP_ECHO_RSP)
+		hdr->length =
+			htons(sizeof(struct gtp1u_packet) - sizeof(struct gtp1_header));
+	else
+		hdr->length =
+			htons(sizeof(struct gtp1_header_long) - sizeof(struct gtp1_header));
+}
+
 static int gtp1u_send_echo_resp(struct gtp_dev *gtp, struct sk_buff *skb)
 {
 	struct gtp1_header_long *gtp1u;
@@ -377,17 +481,7 @@ static int gtp1u_send_echo_resp(struct gtp_dev *gtp, struct sk_buff *skb)
 	gtp_pkt = skb_push(skb, sizeof(struct gtp1u_packet));
 	memset(gtp_pkt, 0, sizeof(struct gtp1u_packet));
 
-	/* S flag must be set to 1 */
-	gtp_pkt->gtp1u_h.flags = 0x32;
-	gtp_pkt->gtp1u_h.type = GTP_ECHO_RSP;
-	/* seq, npdu and next should be counted to the length of the GTP packet
-	 * that's why szie of gtp1_header should be subtracted,
-	 * not why szie of gtp1_header_long.
-	 */
-	gtp_pkt->gtp1u_h.length =
-		htons(sizeof(struct gtp1u_packet) - sizeof(struct gtp1_header));
-	/* 3GPP TS 29.281 5.1 - TEID has to be set to 0 */
-	gtp_pkt->gtp1u_h.tid = 0;
+	gtp1u_build_echo_msg(&gtp_pkt->gtp1u_h, GTP_ECHO_RSP);
 
 	/* 3GPP TS 29.281 7.7.2 - The Restart Counter value in the
 	 * Recovery information element shall not be used, i.e. it shall
@@ -422,6 +516,42 @@ static int gtp1u_send_echo_resp(struct gtp_dev *gtp, struct sk_buff *skb)
 	return 0;
 }
 
+static int gtp1u_handle_echo_resp(struct gtp_dev *gtp, struct sk_buff *skb)
+{
+	struct gtp1_header_long *gtp1u;
+	struct echo_info echo;
+	struct sk_buff *msg;
+	struct iphdr *iph;
+	int ret;
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
+	iph = ip_hdr(skb);
+	echo.ms_addr_ip4.s_addr = iph->daddr;
+	echo.peer_addr_ip4.s_addr = iph->saddr;
+	echo.gtp_version = GTP_V1;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!msg)
+		return -ENOMEM;
+
+	ret = gtp_genl_fill_echo(msg, 0, 0, 0, GTP_CMD_ECHOREQ, echo);
+	if (ret < 0) {
+		nlmsg_free(msg);
+		return ret;
+	}
+
+	return genlmsg_multicast_netns(&gtp_genl_family, dev_net(gtp->dev),
+				       msg, 0, GTP_GENL_MCGRP, GFP_ATOMIC);
+}
+
 static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 {
 	unsigned int hdrlen = sizeof(struct udphdr) +
@@ -444,6 +574,9 @@ static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
 	if (gtp1->type == GTP_ECHO_REQ && gtp->sk_created)
 		return gtp1u_send_echo_resp(gtp, skb);
 
+	if (gtp1->type == GTP_ECHO_RSP && gtp->sk_created)
+		return gtp1u_handle_echo_resp(gtp, skb);
+
 	if (gtp1->type != GTP_TPDU)
 		return 1;
 
@@ -1430,16 +1563,6 @@ static int gtp_genl_del_pdp(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
-static struct genl_family gtp_genl_family;
-
-enum gtp_multicast_groups {
-	GTP_GENL_MCGRP,
-};
-
-static const struct genl_multicast_group gtp_genl_mcgrps[] = {
-	[GTP_GENL_MCGRP] = { .name = GTP_GENL_MCGRP_NAME },
-};
-
 static int gtp_genl_fill_info(struct sk_buff *skb, u32 snd_portid, u32 snd_seq,
 			      int flags, u32 type, struct pdp_ctx *pctx)
 {
@@ -1583,6 +1706,93 @@ static int gtp_genl_dump_pdp(struct sk_buff *skb,
 	return skb->len;
 }
 
+static int gtp_genl_send_echo_req(struct sk_buff *skb, struct genl_info *info)
+{
+	struct sk_buff *skb_to_send;
+	__be32 src_ip, dst_ip;
+	unsigned int version;
+	struct gtp_dev *gtp;
+	struct flowi4 fl4;
+	struct rtable *rt;
+	struct sock *sk;
+	__be16 port;
+	int len;
+
+	if (!info->attrs[GTPA_VERSION] ||
+	    !info->attrs[GTPA_LINK] ||
+	    !info->attrs[GTPA_PEER_ADDRESS] ||
+	    !info->attrs[GTPA_MS_ADDRESS])
+		return -EINVAL;
+
+	version = nla_get_u32(info->attrs[GTPA_VERSION]);
+	dst_ip = nla_get_be32(info->attrs[GTPA_PEER_ADDRESS]);
+	src_ip = nla_get_be32(info->attrs[GTPA_MS_ADDRESS]);
+
+	gtp = gtp_find_dev(sock_net(skb->sk), info->attrs);
+	if (!gtp)
+		return -ENODEV;
+
+	if (!gtp->sk_created)
+		return -EOPNOTSUPP;
+	if (!(gtp->dev->flags & IFF_UP))
+		return -ENETDOWN;
+
+	if (version == GTP_V0) {
+		struct gtp0_header *gtp0_h;
+
+		len = LL_RESERVED_SPACE(gtp->dev) + sizeof(struct gtp0_header) +
+			sizeof(struct iphdr) + sizeof(struct udphdr);
+
+		skb_to_send = netdev_alloc_skb_ip_align(gtp->dev, len);
+		if (!skb_to_send)
+			return -ENOMEM;
+
+		sk = gtp->sk0;
+		port = htons(GTP0_PORT);
+
+		gtp0_h = skb_push(skb_to_send, sizeof(struct gtp0_header));
+		memset(gtp0_h, 0, sizeof(struct gtp0_header));
+		gtp0_build_echo_msg(gtp0_h, GTP_ECHO_REQ);
+	} else if (version == GTP_V1) {
+		struct gtp1_header_long *gtp1u_h;
+
+		len = LL_RESERVED_SPACE(gtp->dev) + sizeof(struct gtp1_header_long) +
+			sizeof(struct iphdr) + sizeof(struct udphdr);
+
+		skb_to_send = netdev_alloc_skb_ip_align(gtp->dev, len);
+		if (!skb_to_send)
+			return -ENOMEM;
+
+		sk = gtp->sk1u;
+		port = htons(GTP1U_PORT);
+
+		gtp1u_h = skb_push(skb_to_send, sizeof(struct gtp1_header_long));
+		memset(gtp1u_h, 0, sizeof(struct gtp1_header_long));
+		gtp1u_build_echo_msg(gtp1u_h, GTP_ECHO_REQ);
+	} else {
+		return -ENODEV;
+	}
+
+	rt = ip4_route_output_gtp(&fl4, sk, dst_ip, src_ip);
+	if (IS_ERR(rt)) {
+		netdev_dbg(gtp->dev, "no route for echo request to %pI4\n",
+			   &dst_ip);
+			   kfree_skb(skb_to_send);
+		return -ENODEV;
+	}
+
+	udp_tunnel_xmit_skb(rt, sk, skb_to_send,
+			    fl4.saddr, fl4.daddr,
+			    fl4.flowi4_tos,
+			    ip4_dst_hoplimit(&rt->dst),
+			    0,
+			    port, port,
+			    !net_eq(sock_net(sk),
+				    dev_net(gtp->dev)),
+			    false);
+	return 0;
+}
+
 static const struct nla_policy gtp_genl_policy[GTPA_MAX + 1] = {
 	[GTPA_LINK]		= { .type = NLA_U32, },
 	[GTPA_VERSION]		= { .type = NLA_U32, },
@@ -1615,6 +1825,12 @@ static const struct genl_small_ops gtp_genl_ops[] = {
 		.dumpit = gtp_genl_dump_pdp,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = GTP_CMD_ECHOREQ,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = gtp_genl_send_echo_req,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 static struct genl_family gtp_genl_family __ro_after_init = {
diff --git a/include/uapi/linux/gtp.h b/include/uapi/linux/gtp.h
index 79f9191bbb24..2f61298a7b77 100644
--- a/include/uapi/linux/gtp.h
+++ b/include/uapi/linux/gtp.h
@@ -8,6 +8,7 @@ enum gtp_genl_cmds {
 	GTP_CMD_NEWPDP,
 	GTP_CMD_DELPDP,
 	GTP_CMD_GETPDP,
+	GTP_CMD_ECHOREQ,
 
 	GTP_CMD_MAX,
 };
-- 
2.35.1

