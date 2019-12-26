Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AABFD12A9C8
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 03:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfLZCdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 21:33:18 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40924 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbfLZCdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 21:33:17 -0500
Received: by mail-pj1-f65.google.com with SMTP id bg7so2845695pjb.5
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 18:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eQZehsgVa693D6Nd3eFaXq8MAJ0ys0UmtUCnNDAzaak=;
        b=NHLy6K1RwPCC4W/bmZqbQTEn/TARE7ht2cn4FX6eMglJuldmsMJ/1c5cjzHDD5JOd0
         NR2/izFx8Lvwym4JDdjhiRZR+GHA5OPz9LTYbr4zi/wEVMQrNHF6WESd95V5osOCxf8a
         JtyOrBLE5iPtH9asNTkPq74FeQ2+hi2Y8ZVsu98h5yQfPU+gt+t9qfI3JpymDGW0mwvx
         p1dBn5hiAvQC2WNuCTrs+LW7WwnRG9/4ntEwuD1gXjUxZfmyWMYP19Q7Pf3zCRp3qJ41
         OWEM3V8eJSew24+jMek6B3kiGNx4Aj3ogw+dKViFC7NKgKYFB5e9wrYnGACsRlv2tgHV
         5f9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eQZehsgVa693D6Nd3eFaXq8MAJ0ys0UmtUCnNDAzaak=;
        b=m8vw0YXZF33eji2Jvrln6MwMlf0Rl1NDhO1aqT2X7+w8hr/fbb6+WP8vNnbO4vEd4C
         VgmnvCsAa/PdrX42IuCWcOL5GUvwdX86GFiiIWUYN+bR1VCNHp8ooIZGKYSrmL/h4WeJ
         RU0l3fhU7vVpmzK31F0CDn4qf+aUHcj8dG3EQIR4ifN+FfNhw4aSQtUDV/Uk6K2MJkO5
         jdpAwJgYisjBIkbAcfd48hPfl4rytM7IncOY9QzfV6Lt4e1VxaFnagun8UbCoQNmcNZx
         jZqxxN9dnM359Lc8jFz7BhqJuOauHmTfeXniW6RHAsH61CT0ZeE10TyrfFAwU7nCJFS7
         H++Q==
X-Gm-Message-State: APjAAAWN34p+BSuTeyDJeYAxMCDwtL45IpWRm34Q4s7p6Pmdf+kOKJgV
        jH0WQMs7Zh9GHLfr09inY6A=
X-Google-Smtp-Source: APXvYqxlm5QZxohFMH7CrPRERPhN4Tk2zcD9hDz8D7JYukGU2u3GJPEkMMNGwRX0d6guMbuLCG+D1Q==
X-Received: by 2002:a17:902:b40a:: with SMTP id x10mr25471713plr.64.1577327596593;
        Wed, 25 Dec 2019 18:33:16 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id e6sm33865222pfh.32.2019.12.25.18.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 18:33:16 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     David Ahern <dahern@digitalocean.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        Prashant Bhole <prashantbhole.linux@gmail.com>
Subject: [RFC v2 net-next 01/12] net: introduce BPF_XDP_EGRESS attach type for XDP
Date:   Thu, 26 Dec 2019 11:31:49 +0900
Message-Id: <20191226023200.21389-2-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191226023200.21389-1-prashantbhole.linux@gmail.com>
References: <20191226023200.21389-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

There was a need to run XDP program in tx path such that it emulates
rx path XDP on the peer interface.

Possible use cases:
- virtio-net XDP offload, where virtio-net drivers implements offload
  feature such that it sends the XDP program to QEMU and then QEMU
  runs the XDP program in the tx path of tap device.

- Container networking, where veth pair links the host and the
  container. Host can set ACL by setting tx path XDP to the veth
  interface.

This patch introduces a new bpf attach type BPF_XDP_EGRESS. Programs
having this attach type will be allowed to run in the tx path. It is
because we need to prevent the programs from accessing rxq info when
they are running in tx path. Verifier can reject the programs those
have this attach type and trying to access rxq info.

Patch also introduces a new netlink attribute IFLA_XDP_TX which can
be used for setting XDP program in tx path and to get information of
such programs.

Drivers those want to support tx path XDP needs to handle
XDP_SETUP_PROG_TX and XDP_QUERY_PROG_TX cases in their ndo_bpf.

Signed-off-by: David Ahern <dahern@digitalocean.com>
Co-developed-by: Prashant Bhole <prashantbhole.linux@gmail.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 include/linux/netdevice.h      |   4 +-
 include/uapi/linux/bpf.h       |   1 +
 include/uapi/linux/if_link.h   |   1 +
 net/core/dev.c                 |  34 +++++++---
 net/core/filter.c              |   8 +++
 net/core/rtnetlink.c           | 112 ++++++++++++++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h |   1 +
 7 files changed, 150 insertions(+), 11 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 469a297b58c0..ac3e88d86581 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -865,8 +865,10 @@ enum bpf_netdev_command {
 	 */
 	XDP_SETUP_PROG,
 	XDP_SETUP_PROG_HW,
+	XDP_SETUP_PROG_TX,
 	XDP_QUERY_PROG,
 	XDP_QUERY_PROG_HW,
+	XDP_QUERY_PROG_TX,
 	/* BPF program for offload callbacks, invoked at program load time. */
 	BPF_OFFLOAD_MAP_ALLOC,
 	BPF_OFFLOAD_MAP_FREE,
@@ -3725,7 +3727,7 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
-		      int fd, u32 flags);
+		      int fd, u32 flags, bool tx);
 u32 __dev_xdp_query(struct net_device *dev, bpf_op_t xdp_op,
 		    enum bpf_netdev_command cmd);
 int xdp_umem_query(struct net_device *dev, u16 queue_id);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index dbbcf0b02970..23c1841c8086 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -203,6 +203,7 @@ enum bpf_attach_type {
 	BPF_TRACE_RAW_TP,
 	BPF_TRACE_FENTRY,
 	BPF_TRACE_FEXIT,
+	BPF_XDP_EGRESS,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 1d69f637c5d6..be97c9787140 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -170,6 +170,7 @@ enum {
 	IFLA_PROP_LIST,
 	IFLA_ALT_IFNAME, /* Alternative ifname */
 	IFLA_PERM_ADDRESS,
+	IFLA_XDP_TX,
 	__IFLA_MAX
 };
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 0ad39c87b7fd..ae66fd791737 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8540,7 +8540,7 @@ u32 __dev_xdp_query(struct net_device *dev, bpf_op_t bpf_op,
 
 static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
 			   struct netlink_ext_ack *extack, u32 flags,
-			   struct bpf_prog *prog)
+			   struct bpf_prog *prog, bool tx)
 {
 	struct netdev_bpf xdp;
 
@@ -8548,7 +8548,8 @@ static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
 	if (flags & XDP_FLAGS_HW_MODE)
 		xdp.command = XDP_SETUP_PROG_HW;
 	else
-		xdp.command = XDP_SETUP_PROG;
+		xdp.command = tx ? XDP_SETUP_PROG_TX : XDP_SETUP_PROG;
+
 	xdp.extack = extack;
 	xdp.flags = flags;
 	xdp.prog = prog;
@@ -8562,7 +8563,8 @@ static void dev_xdp_uninstall(struct net_device *dev)
 	bpf_op_t ndo_bpf;
 
 	/* Remove generic XDP */
-	WARN_ON(dev_xdp_install(dev, generic_xdp_install, NULL, 0, NULL));
+	WARN_ON(dev_xdp_install(dev, generic_xdp_install, NULL, 0, NULL,
+				false));
 
 	/* Remove from the driver */
 	ndo_bpf = dev->netdev_ops->ndo_bpf;
@@ -8574,14 +8576,21 @@ static void dev_xdp_uninstall(struct net_device *dev)
 	WARN_ON(ndo_bpf(dev, &xdp));
 	if (xdp.prog_id)
 		WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flags,
-					NULL));
+					NULL, false));
 
 	/* Remove HW offload */
 	memset(&xdp, 0, sizeof(xdp));
 	xdp.command = XDP_QUERY_PROG_HW;
 	if (!ndo_bpf(dev, &xdp) && xdp.prog_id)
 		WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flags,
-					NULL));
+					NULL, false));
+
+	/* Remove HW offload */
+	memset(&xdp, 0, sizeof(xdp));
+	xdp.command = XDP_QUERY_PROG_TX;
+	if (!ndo_bpf(dev, &xdp) && xdp.prog_id)
+		WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flags,
+					NULL, true));
 }
 
 /**
@@ -8594,7 +8603,7 @@ static void dev_xdp_uninstall(struct net_device *dev)
  *	Set or clear a bpf program for a device
  */
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
-		      int fd, u32 flags)
+		      int fd, u32 flags, bool tx)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 	enum bpf_netdev_command query;
@@ -8606,7 +8615,10 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 	ASSERT_RTNL();
 
 	offload = flags & XDP_FLAGS_HW_MODE;
-	query = offload ? XDP_QUERY_PROG_HW : XDP_QUERY_PROG;
+	if (tx)
+		query = XDP_QUERY_PROG_TX;
+	else
+		query = offload ? XDP_QUERY_PROG_HW : XDP_QUERY_PROG;
 
 	bpf_op = bpf_chk = ops->ndo_bpf;
 	if (!bpf_op && (flags & (XDP_FLAGS_DRV_MODE | XDP_FLAGS_HW_MODE))) {
@@ -8621,7 +8633,8 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 	if (fd >= 0) {
 		u32 prog_id;
 
-		if (!offload && __dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG)) {
+		if (!offload && !tx &&
+		    __dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG)) {
 			NL_SET_ERR_MSG(extack, "native and generic XDP can't be active at the same time");
 			return -EEXIST;
 		}
@@ -8637,6 +8650,9 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 		if (IS_ERR(prog))
 			return PTR_ERR(prog);
 
+		if (tx && prog->expected_attach_type != BPF_XDP_EGRESS)
+			return -EINVAL;
+
 		if (!offload && bpf_prog_is_dev_bound(prog->aux)) {
 			NL_SET_ERR_MSG(extack, "using device-bound program without HW_MODE flag is not supported");
 			bpf_prog_put(prog);
@@ -8653,7 +8669,7 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 			return 0;
 	}
 
-	err = dev_xdp_install(dev, bpf_op, extack, flags, prog);
+	err = dev_xdp_install(dev, bpf_op, extack, flags, prog, tx);
 	if (err < 0 && prog)
 		bpf_prog_put(prog);
 
diff --git a/net/core/filter.c b/net/core/filter.c
index 28b3c258188c..aaf04ff297c7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6896,6 +6896,14 @@ static bool xdp_is_valid_access(int off, int size,
 		return false;
 	}
 
+	if (prog->expected_attach_type == BPF_XDP_EGRESS) {
+		switch (off) {
+		case offsetof(struct xdp_md, rx_queue_index):
+		case offsetof(struct xdp_md, ingress_ifindex):
+			return false;
+		}
+	}
+
 	switch (off) {
 	case offsetof(struct xdp_md, data):
 		info->reg_type = PTR_TO_PACKET;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 20bc406f3871..9dc4b2547f62 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1395,6 +1395,36 @@ static int rtnl_fill_link_ifmap(struct sk_buff *skb, struct net_device *dev)
 	return 0;
 }
 
+static u32 rtnl_xdp_tx_prog_drv(struct net_device *dev)
+{
+	return __dev_xdp_query(dev, dev->netdev_ops->ndo_bpf,
+			       XDP_QUERY_PROG_TX);
+}
+
+static int rtnl_xdp_tx_report_one(struct sk_buff *skb, struct net_device *dev,
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
 
+static int rtnl_xdp_tx_fill(struct sk_buff *skb, struct net_device *dev)
+{
+	u8 mode = XDP_ATTACHED_NONE;
+	struct nlattr *xdp;
+	u32 prog_id = 0;
+	int err;
+
+	xdp = nla_nest_start_noflag(skb, IFLA_XDP_TX);
+	if (!xdp)
+		return -EMSGSIZE;
+
+	err = rtnl_xdp_tx_report_one(skb, dev, &prog_id, &mode,
+				     XDP_ATTACHED_DRV, IFLA_XDP_DRV_PROG_ID,
+				     rtnl_xdp_tx_prog_drv);
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
 
+	if (rtnl_xdp_tx_fill(skb, dev))
+		goto nla_put_failure;
+
 	if (dev->rtnl_link_ops || rtnl_have_link_slave_info(dev)) {
 		if (rtnl_link_fill(skb, dev) < 0)
 			goto nla_put_failure;
@@ -1827,6 +1895,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_ALT_IFNAME]	= { .type = NLA_STRING,
 				    .len = ALTIFNAMSIZ - 1 },
 	[IFLA_PERM_ADDRESS]	= { .type = NLA_REJECT },
+	[IFLA_XDP_TX]		= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -2801,7 +2870,48 @@ static int do_setlink(const struct sk_buff *skb,
 		if (xdp[IFLA_XDP_FD]) {
 			err = dev_change_xdp_fd(dev, extack,
 						nla_get_s32(xdp[IFLA_XDP_FD]),
-						xdp_flags);
+						xdp_flags, false);
+			if (err)
+				goto errout;
+			status |= DO_SETLINK_NOTIFY;
+		}
+	}
+
+	if (tb[IFLA_XDP_TX]) {
+		struct nlattr *xdp[IFLA_XDP_MAX + 1];
+		u32 xdp_flags = 0;
+
+		err = nla_parse_nested_deprecated(xdp, IFLA_XDP_MAX,
+						  tb[IFLA_XDP_TX],
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
 			if (err)
 				goto errout;
 			status |= DO_SETLINK_NOTIFY;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index dbbcf0b02970..23c1841c8086 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -203,6 +203,7 @@ enum bpf_attach_type {
 	BPF_TRACE_RAW_TP,
 	BPF_TRACE_FENTRY,
 	BPF_TRACE_FEXIT,
+	BPF_XDP_EGRESS,
 	__MAX_BPF_ATTACH_TYPE
 };
 
-- 
2.21.0

