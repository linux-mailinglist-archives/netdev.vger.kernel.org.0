Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEEF814607E
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 02:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgAWBmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 20:42:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:59580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728992AbgAWBmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 20:42:20 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 803E324684;
        Thu, 23 Jan 2020 01:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579743739;
        bh=cJuDIWB5atkqeoczLJM+0TyIfYtt+U+INwJEWV50d7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XjRzDjsZ/gjfFlBmsTekzUguETZmv11bVawDYo+ZX4Vyda9DvX1SyTdsscLlMuzL1
         6UGNjHctlJDj4uk9kEh/NLDZmMIn/neU3Zt+qwpFONGG+xWklC0+50ZBYG52I3RPWm
         60VRCbi9XJ/nNyxkdCy77uUiKLbM2n8X1T6/19Rs=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        jbrouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs in the egress path
Date:   Wed, 22 Jan 2020 18:42:01 -0700
Message-Id: <20200123014210.38412-4-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200123014210.38412-1-dsahern@kernel.org>
References: <20200123014210.38412-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

Add IFLA_XDP_EGRESS to if_link.h uapi to handle an XDP program attached
to the egress path of a device. Add rtnl_xdp_egress_fill and helpers as
the egress counterpart to the existing rtnl_xdp_fill. The expectation
is that going forward egress path will acquire the various levels of
attach - generic, driver and hardware.

Signed-off-by: David Ahern <dahern@digitalocean.com>
Co-developed-by: Prashant Bhole <prashantbhole.linux@gmail.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 include/uapi/linux/if_link.h       |   1 +
 net/core/dev.c                     |   6 ++
 net/core/rtnetlink.c               | 112 ++++++++++++++++++++++++++++-
 tools/include/uapi/linux/if_link.h |   1 +
 4 files changed, 119 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 1d69f637c5d6..c760aa54315c 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -170,6 +170,7 @@ enum {
 	IFLA_PROP_LIST,
 	IFLA_ALT_IFNAME, /* Alternative ifname */
 	IFLA_PERM_ADDRESS,
+	IFLA_XDP_EGRESS, /* nested attribute with 1 or more IFLA_XDP_ attrs */
 	__IFLA_MAX
 };
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 04cbcc930bc2..bf76dbee9d2a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8664,6 +8664,12 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 		if (IS_ERR(prog))
 			return PTR_ERR(prog);
 
+		if (egress && prog->expected_attach_type != BPF_XDP_EGRESS) {
+			NL_SET_ERR_MSG(extack, "XDP program in egress path must use BPF_XDP_EGRESS attach type");
+			bpf_prog_put(prog);
+			return -EINVAL;
+		}
+
 		if (!offload && bpf_prog_is_dev_bound(prog->aux)) {
 			NL_SET_ERR_MSG(extack, "using device-bound program without HW_MODE flag is not supported");
 			bpf_prog_put(prog);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index ed0c069ef187..2179de9350b2 100644
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
@@ -1395,6 +1395,36 @@ static int rtnl_fill_link_ifmap(struct sk_buff *skb, struct net_device *dev)
 	return 0;
 }
 
+static u32 rtnl_xdp_egress_prog_drv(struct net_device *dev)
+{
+	return __dev_xdp_query(dev, dev->netdev_ops->ndo_bpf,
+			       XDP_QUERY_PROG_EGRESS);
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
@@ -1486,6 +1516,41 @@ static int rtnl_xdp_fill(struct sk_buff *skb, struct net_device *dev)
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
+				     XDP_ATTACHED_DRV, IFLA_XDP_DRV_PROG_ID,
+				     rtnl_xdp_egress_prog_drv);
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
@@ -1743,6 +1808,9 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	if (rtnl_xdp_fill(skb, dev))
 		goto nla_put_failure;
 
+	if (rtnl_xdp_egress_fill(skb, dev))
+		goto nla_put_failure;
+
 	if (dev->rtnl_link_ops || rtnl_have_link_slave_info(dev)) {
 		if (rtnl_link_fill(skb, dev) < 0)
 			goto nla_put_failure;
@@ -1827,6 +1895,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_ALT_IFNAME]	= { .type = NLA_STRING,
 				    .len = ALTIFNAMSIZ - 1 },
 	[IFLA_PERM_ADDRESS]	= { .type = NLA_REJECT },
+	[IFLA_XDP_EGRESS]	= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -2808,6 +2877,47 @@ static int do_setlink(const struct sk_buff *skb,
 		}
 	}
 
+	if (tb[IFLA_XDP_EGRESS]) {
+		struct nlattr *xdp[IFLA_XDP_MAX + 1];
+		u32 xdp_flags = 0;
+
+		err = nla_parse_nested_deprecated(xdp, IFLA_XDP_MAX,
+						  tb[IFLA_XDP_EGRESS],
+						  ifla_xdp_policy, NULL);
+		if (err < 0)
+			goto errout;
+
+		if (xdp[IFLA_XDP_ATTACHED] || xdp[IFLA_XDP_PROG_ID]) {
+			err = -EINVAL;
+			goto errout;
+		}
+
+		if (xdp[IFLA_XDP_FLAGS]) {
+			xdp_flags = nla_get_u32(xdp[IFLA_XDP_FLAGS]);
+			if (xdp_flags & XDP_FLAGS_HW_MODE) {
+				err = -EINVAL;
+				goto errout;
+			}
+			if (xdp_flags & ~XDP_FLAGS_MASK) {
+				err = -EINVAL;
+				goto errout;
+			}
+			if (hweight32(xdp_flags & XDP_FLAGS_MODES) > 1) {
+				err = -EINVAL;
+				goto errout;
+			}
+		}
+
+		if (xdp[IFLA_XDP_FD]) {
+			err = dev_change_xdp_fd(dev, extack,
+						nla_get_s32(xdp[IFLA_XDP_FD]),
+						xdp_flags, true);
+			if (err)
+				goto errout;
+			status |= DO_SETLINK_NOTIFY;
+		}
+	}
+
 errout:
 	if (status & DO_SETLINK_MODIFIED) {
 		if ((status & DO_SETLINK_NOTIFY) == DO_SETLINK_NOTIFY)
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 1d69f637c5d6..c760aa54315c 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -170,6 +170,7 @@ enum {
 	IFLA_PROP_LIST,
 	IFLA_ALT_IFNAME, /* Alternative ifname */
 	IFLA_PERM_ADDRESS,
+	IFLA_XDP_EGRESS, /* nested attribute with 1 or more IFLA_XDP_ attrs */
 	__IFLA_MAX
 };
 
-- 
2.21.1 (Apple Git-122.3)

