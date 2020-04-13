Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC8D1A6B36
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 19:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732672AbgDMRSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 13:18:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732650AbgDMRSa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 13:18:30 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 091382078B;
        Mon, 13 Apr 2020 17:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586798309;
        bh=yOAKTPvNcxrdg82/PWG5nFOaPvUQnam091KIZuHAswg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQuiIrDYJ9UBRXzcXIjnErlAcCjRfPNM3QI+fijSdoEN63rGOFjeu7Dr6bSb53MnU
         BeAbYp+FBNTAfnAT3ZEXLe3Q1+rrvugJYxWt/OIVXA6MQBFYbGtiQv2tBP3+/S7qFJ
         RxVD3InW1s50i8fcxstpI1suVI5aV0dDc+Dx+JdU=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH RFC-v5 bpf-next 04/12] net: Add IFLA_XDP_EGRESS for XDP programs in the egress path
Date:   Mon, 13 Apr 2020 11:17:53 -0600
Message-Id: <20200413171801.54406-5-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200413171801.54406-1-dsahern@kernel.org>
References: <20200413171801.54406-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

Running programs in the egress path, on skbs or xdp_frames, does not
require driver specific resources like Rx path. Accordingly, the
programs can be run in core code, so add xdp_egress_prog to net_device
to hold a reference to an attached program.

For UAPI, add IFLA_XDP_EGRESS to if_link.h to specify egress programs,
add a new attach flag, XDP_ATTACHED_EGRESS_CORE, to denote the
attach point is at the core level (as opposed to driver or hardware)
and add IFLA_XDP_EGRESS_CORE_PROG_ID for reporting the program id.

Add egress argument to do_setlink_xdp to denote processing of
IFLA_XDP_EGRESS versus IFLA_XDP, and add a check that none of the
existing modes (SKB, DRV or HW) are set since those modes are not
valid. The expectation is that XDP_FLAGS_HW_MODE will be used later
(e.g., offloading guest programs).

Add rtnl_xdp_egress_fill and helpers as the egress counterpart to the
existing rtnl_xdp_fill.

Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 include/linux/netdevice.h          |  1 +
 include/uapi/linux/if_link.h       |  3 +
 net/core/rtnetlink.c               | 96 ++++++++++++++++++++++++++++--
 tools/include/uapi/linux/if_link.h |  3 +
 4 files changed, 99 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d0bb9e09660a..3133247681fd 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1995,6 +1995,7 @@ struct net_device {
 	unsigned int		real_num_rx_queues;
 
 	struct bpf_prog __rcu	*xdp_prog;
+	struct bpf_prog __rcu	*xdp_egress_prog;
 	unsigned long		gro_flush_timeout;
 	rx_handler_func_t __rcu	*rx_handler;
 	void __rcu		*rx_handler_data;
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 127c704eeba9..b3c6cb2f0f0a 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -170,6 +170,7 @@ enum {
 	IFLA_PROP_LIST,
 	IFLA_ALT_IFNAME, /* Alternative ifname */
 	IFLA_PERM_ADDRESS,
+	IFLA_XDP_EGRESS, /* nested attribute with 1 or more IFLA_XDP_ attrs */
 	__IFLA_MAX
 };
 
@@ -988,6 +989,7 @@ enum {
 	XDP_ATTACHED_SKB,
 	XDP_ATTACHED_HW,
 	XDP_ATTACHED_MULTI,
+	XDP_ATTACHED_EGRESS_CORE,
 };
 
 enum {
@@ -1000,6 +1002,7 @@ enum {
 	IFLA_XDP_SKB_PROG_ID,
 	IFLA_XDP_HW_PROG_ID,
 	IFLA_XDP_EXPECTED_FD,
+	IFLA_XDP_EGRESS_CORE_PROG_ID,
 	__IFLA_XDP_MAX,
 };
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index dc44af16226a..e9bc5cee06c8 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1030,7 +1030,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(MAX_PHYS_ITEM_ID_LEN) /* IFLA_PHYS_PORT_ID */
 	       + nla_total_size(MAX_PHYS_ITEM_ID_LEN) /* IFLA_PHYS_SWITCH_ID */
 	       + nla_total_size(IFNAMSIZ) /* IFLA_PHYS_PORT_NAME */
-	       + rtnl_xdp_size() /* IFLA_XDP */
+	       + rtnl_xdp_size() * 2 /* IFLA_XDP and IFLA_XDP_EGRESS */
 	       + nla_total_size(4)  /* IFLA_EVENT */
 	       + nla_total_size(4)  /* IFLA_NEW_NETNSID */
 	       + nla_total_size(4)  /* IFLA_NEW_IFINDEX */
@@ -1395,6 +1395,42 @@ static int rtnl_fill_link_ifmap(struct sk_buff *skb, struct net_device *dev)
 	return 0;
 }
 
+static u32 rtnl_xdp_egress_prog(struct net_device *dev)
+{
+	const struct bpf_prog *prog;
+
+	ASSERT_RTNL();
+
+	prog = rtnl_dereference(dev->xdp_egress_prog);
+	if (!prog)
+		return 0;
+	return prog->aux->id;
+}
+
+static int rtnl_xdp_egress_report(struct sk_buff *skb, struct net_device *dev,
+				  u32 *prog_id, u8 *mode, u8 tgt_mode, u32 attr,
+				  u32 (*get_prog_id)(struct net_device *dev))
+{
+	u32 curr_id;
+	int err;
+
+	curr_id = get_prog_id(dev);
+	if (!curr_id)
+		return 0;
+
+	*prog_id = curr_id;
+	err = nla_put_u32(skb, attr, curr_id);
+	if (err)
+		return err;
+
+	if (*mode != XDP_ATTACHED_NONE)
+		*mode = XDP_ATTACHED_MULTI;
+	else
+		*mode = tgt_mode;
+
+	return 0;
+}
+
 static u32 rtnl_xdp_prog_skb(struct net_device *dev)
 {
 	const struct bpf_prog *generic_xdp_prog;
@@ -1486,6 +1522,42 @@ static int rtnl_xdp_fill(struct sk_buff *skb, struct net_device *dev)
 	return err;
 }
 
+static int rtnl_xdp_egress_fill(struct sk_buff *skb, struct net_device *dev)
+{
+	u8 mode = XDP_ATTACHED_NONE;
+	struct nlattr *xdp;
+	u32 prog_id = 0;
+	int err;
+
+	xdp = nla_nest_start_noflag(skb, IFLA_XDP_EGRESS);
+	if (!xdp)
+		return -EMSGSIZE;
+
+	err = rtnl_xdp_egress_report(skb, dev, &prog_id, &mode,
+				     XDP_ATTACHED_EGRESS_CORE,
+				     IFLA_XDP_EGRESS_CORE_PROG_ID,
+				     rtnl_xdp_egress_prog);
+	if (err)
+		goto err_cancel;
+
+	err = nla_put_u8(skb, IFLA_XDP_ATTACHED, mode);
+	if (err)
+		goto err_cancel;
+
+	if (prog_id && mode != XDP_ATTACHED_MULTI) {
+		err = nla_put_u32(skb, IFLA_XDP_PROG_ID, prog_id);
+		if (err)
+			goto err_cancel;
+	}
+
+	nla_nest_end(skb, xdp);
+	return 0;
+
+err_cancel:
+	nla_nest_cancel(skb, xdp);
+	return err;
+}
+
 static u32 rtnl_get_event(unsigned long event)
 {
 	u32 rtnl_event_type = IFLA_EVENT_NONE;
@@ -1743,6 +1815,9 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	if (rtnl_xdp_fill(skb, dev))
 		goto nla_put_failure;
 
+	if (rtnl_xdp_egress_fill(skb, dev))
+		goto nla_put_failure;
+
 	if (dev->rtnl_link_ops || rtnl_have_link_slave_info(dev)) {
 		if (rtnl_link_fill(skb, dev) < 0)
 			goto nla_put_failure;
@@ -1827,6 +1902,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_ALT_IFNAME]	= { .type = NLA_STRING,
 				    .len = ALTIFNAMSIZ - 1 },
 	[IFLA_PERM_ADDRESS]	= { .type = NLA_REJECT },
+	[IFLA_XDP_EGRESS]	= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -2482,7 +2558,8 @@ static int do_set_master(struct net_device *dev, int ifindex,
 #define DO_SETLINK_NOTIFY	0x03
 
 static int do_setlink_xdp(struct net_device *dev, struct nlattr *tb,
-			  int *status, struct netlink_ext_ack *extack)
+			  int *status, bool egress,
+			  struct netlink_ext_ack *extack)
 {
 	struct nlattr *xdp[IFLA_XDP_MAX + 1];
 	u32 xdp_flags = 0;
@@ -2498,6 +2575,10 @@ static int do_setlink_xdp(struct net_device *dev, struct nlattr *tb,
 
 	if (xdp[IFLA_XDP_FLAGS]) {
 		xdp_flags = nla_get_u32(xdp[IFLA_XDP_FLAGS]);
+		if (egress && xdp_flags & XDP_FLAGS_MODES) {
+			NL_SET_ERR_MSG(extack, "XDP_FLAGS_MODES not valid for egress");
+			goto out_einval;
+		}
 		if (xdp_flags & ~XDP_FLAGS_MASK)
 			goto out_einval;
 		if (hweight32(xdp_flags & XDP_FLAGS_MODES) > 1)
@@ -2515,7 +2596,7 @@ static int do_setlink_xdp(struct net_device *dev, struct nlattr *tb,
 
 		err = dev_change_xdp_fd(dev, extack,
 					nla_get_s32(xdp[IFLA_XDP_FD]),
-					expected_fd, xdp_flags, false);
+					expected_fd, xdp_flags, egress);
 		if (err)
 			return err;
 
@@ -2821,7 +2902,14 @@ static int do_setlink(const struct sk_buff *skb,
 	}
 
 	if (tb[IFLA_XDP]) {
-		err = do_setlink_xdp(dev, tb[IFLA_XDP], &status, extack);
+		err = do_setlink_xdp(dev, tb[IFLA_XDP], &status, false, extack);
+		if (err)
+			goto errout;
+	}
+
+	if (tb[IFLA_XDP_EGRESS]) {
+		err = do_setlink_xdp(dev, tb[IFLA_XDP_EGRESS], &status, true,
+				     extack);
 		if (err)
 			goto errout;
 	}
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index ca6665ea758a..f9e665aa836a 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -170,6 +170,7 @@ enum {
 	IFLA_PROP_LIST,
 	IFLA_ALT_IFNAME, /* Alternative ifname */
 	IFLA_PERM_ADDRESS,
+	IFLA_XDP_EGRESS, /* nested attribute with 1 or more IFLA_XDP_ attrs */
 	__IFLA_MAX
 };
 
@@ -976,6 +977,7 @@ enum {
 	XDP_ATTACHED_SKB,
 	XDP_ATTACHED_HW,
 	XDP_ATTACHED_MULTI,
+	XDP_ATTACHED_EGRESS_CORE,
 };
 
 enum {
@@ -988,6 +990,7 @@ enum {
 	IFLA_XDP_SKB_PROG_ID,
 	IFLA_XDP_HW_PROG_ID,
 	IFLA_XDP_EXPECTED_FD,
+	IFLA_XDP_EGRESS_CORE_PROG_ID,
 	__IFLA_XDP_MAX,
 };
 
-- 
2.21.1 (Apple Git-122.3)

