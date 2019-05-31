Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E36930BDF
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 11:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfEaJmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 05:42:42 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40247 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbfEaJmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 05:42:42 -0400
Received: by mail-pf1-f196.google.com with SMTP id u17so5869277pfn.7;
        Fri, 31 May 2019 02:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OvbZawIVIOw9CYIB+EjLedlu7feQ8aAD9o5KEagAico=;
        b=cWnnl6Dxv/I5A9osxhxTpDrRb0kd+FZYe3deQ7drqf/muvUqzyB3vrIQJbktIE6Wq0
         VlhjwXt6kYT2Iwba398lZe5mdKBvlL2x3OxduSMEa0fSeyYUVe5v/nwBIt2f1YDFnpUl
         ZUw7hFbOikDWYpbG4JUz9pujrSHGhwAV+yOAl4hO0jEoHYJrHGLNR7lN7Ah6oCHHZS86
         LfQ24sLB02PBdCehiSbV/dqxLrATgbgKhOspnERIlThmAUP/H0Q3Sv1slgmKvZo73VUp
         JOY7woUUHNlp4D3VzgGCCsp3jfOI2F41CL1XK3Mq5oCEKRRD7GLf3VxxbywtgkvlShj6
         pTRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OvbZawIVIOw9CYIB+EjLedlu7feQ8aAD9o5KEagAico=;
        b=rlH26GxYXsM63IUQTKgkS+BgpPE610dYHQVhnVYhxeYaXjPEhy79j8D6mB/uT9eHGr
         pifjWcDkK8Tt8QVkiK3tQFM9K5fv0+sKYv/YjQMu+TwqYuoYJmmcW2Vfym0OnjHwnEjE
         7Y4QiVO0jNt2paDlHtPWbgC4bZvZsIYkFy1l/metZab4+6IAN5hB2Qrd5dAycu80w0dt
         8/n3JUQ9FkOk2uulOxo7Mu0BJ2iJKYZf3fE6vC7eMDrxggv8xmoobN7rNA+/1buBy23E
         2CMpYxEnrdkNIQRC2gLYdehEsZbc71Ys3xOLKJeagqUdRAK81pJ7UQNgfh2PV/i8BTJf
         Z9JQ==
X-Gm-Message-State: APjAAAUKbkDJsgGV0JQXek/HxPoUJ7eCjNfZnUMaDgyV1WEz2aElyo9B
        7AaoRKyYwn7Ai0geJ/wyWQY=
X-Google-Smtp-Source: APXvYqxtCrSREqR1o+9tJeNndVvCQG8y+agK2uEy8YD+bJmHGWg73hkwodESF+d844JfHorYAQdx5w==
X-Received: by 2002:a63:fb05:: with SMTP id o5mr8161716pgh.203.1559295761316;
        Fri, 31 May 2019 02:42:41 -0700 (PDT)
Received: from btopel-mobl.isw.intel.com ([192.55.54.43])
        by smtp.gmail.com with ESMTPSA id e4sm4887936pgi.80.2019.05.31.02.42.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 02:42:40 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     toke@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, brouer@redhat.com, bpf@vger.kernel.org,
        jakub.kicinski@netronome.com, saeedm@mellanox.com
Subject: [PATCH bpf-next v2 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW} to netdev
Date:   Fri, 31 May 2019 11:42:14 +0200
Message-Id: <20190531094215.3729-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190531094215.3729-1-bjorn.topel@gmail.com>
References: <20190531094215.3729-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

All XDP capable drivers need to implement the XDP_QUERY_PROG{,_HW}
command of ndo_bpf. The query code is fairly generic. This commit
refactors the query code up from the drivers to the netdev level.

The struct net_device has gained two new members: xdp_prog_hw and
xdp_flags. The former is the offloaded XDP program, if any, and the
latter tracks the flags that the supplied when attaching the XDP
program. The flags only apply to SKB_MODE or DRV_MODE, not HW_MODE.

The xdp_prog member, previously only used for SKB_MODE, is shared with
DRV_MODE. This is OK, due to the fact that SKB_MODE and DRV_MODE are
mutually exclusive. To differentiate between the two modes, a new
internal flag is introduced as well.

The program query operations is all done under the rtnl lock. However,
the xdp_prog member is __rcu annotated, and used in a lock-less manner
for the SKB_MODE. Now that xdp_prog member is shared from a query
program perspective, RCU read and assignments functions are still used
when altering xdp_prog, even when only for queries in DRV_MODE. This
is for sparse/lockdep correctness.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/netdevice.h |  15 +++--
 include/net/xdp.h         |   4 ++
 net/core/dev.c            | 138 ++++++++++++++++++++++++--------------
 net/core/rtnetlink.c      |  53 +++++++--------
 net/core/xdp.c            |  17 +++--
 5 files changed, 139 insertions(+), 88 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 44b47e9df94a..f3a875a52c6c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1940,6 +1940,9 @@ struct net_device {
 #endif
 	struct hlist_node	index_hlist;
 
+	struct bpf_prog		*xdp_prog_hw;
+	u32			xdp_flags;
+
 /*
  * Cache lines mostly used on transmit path
  */
@@ -2043,11 +2046,14 @@ struct net_device {
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
+/* Reusing the XDP flags space for kernel internal flag */
+#define XDP_FLAGS_KERN_GENERIC (1U << 4)
+static_assert(!(XDP_FLAGS_KERN_GENERIC & XDP_FLAGS_MASK));
+
 static inline bool netif_elide_gro(const struct net_device *dev)
 {
-	if (!(dev->features & NETIF_F_GRO) || dev->xdp_prog)
-		return true;
-	return false;
+	return !(dev->features & NETIF_F_GRO) ||
+		dev->xdp_flags & XDP_FLAGS_KERN_GENERIC;
 }
 
 #define	NETDEV_ALIGN		32
@@ -3684,8 +3690,7 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 		      int fd, u32 flags);
-u32 __dev_xdp_query(struct net_device *dev, bpf_op_t xdp_op,
-		    enum bpf_netdev_command cmd);
+u32 dev_xdp_query(struct net_device *dev, unsigned int mode);
 int xdp_umem_query(struct net_device *dev, u16 queue_id);
 
 int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 0f25b3675c5c..3691280c8fc1 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -51,6 +51,7 @@ struct xdp_mem_info {
 };
 
 struct page_pool;
+struct netlink_ext_ack;
 
 struct zero_copy_allocator {
 	void (*free)(struct zero_copy_allocator *zca, unsigned long handle);
@@ -166,4 +167,7 @@ bool xdp_attachment_flags_ok(struct xdp_attachment_info *info,
 void xdp_attachment_setup(struct xdp_attachment_info *info,
 			  struct netdev_bpf *bpf);
 
+bool xdp_prog_flags_ok(u32 old_flags, u32 new_flags,
+		       struct netlink_ext_ack *extack);
+
 #endif /* __LINUX_NET_XDP_H__ */
diff --git a/net/core/dev.c b/net/core/dev.c
index b6b8505cfb3e..1a9da508149a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8005,21 +8005,43 @@ int dev_change_proto_down_generic(struct net_device *dev, bool proto_down)
 }
 EXPORT_SYMBOL(dev_change_proto_down_generic);
 
-u32 __dev_xdp_query(struct net_device *dev, bpf_op_t bpf_op,
-		    enum bpf_netdev_command cmd)
+static u32 dev_xdp_query_generic(struct net_device *dev)
 {
-	struct netdev_bpf xdp;
+	struct bpf_prog *prog = rtnl_dereference(dev->xdp_prog);
 
-	if (!bpf_op)
-		return 0;
+	return prog && dev->xdp_flags & XDP_FLAGS_KERN_GENERIC ?
+		prog->aux->id : 0;
+}
 
-	memset(&xdp, 0, sizeof(xdp));
-	xdp.command = cmd;
+static u32 dev_xdp_query_drv(struct net_device *dev)
+{
+	struct bpf_prog *prog = rtnl_dereference(dev->xdp_prog);
+
+	return prog && !(dev->xdp_flags & XDP_FLAGS_KERN_GENERIC) ?
+		prog->aux->id : 0;
+}
+
+static u32 dev_xdp_current_mode(struct net_device *dev)
+{
+	struct bpf_prog *prog = rtnl_dereference(dev->xdp_prog);
 
-	/* Query must always succeed. */
-	WARN_ON(bpf_op(dev, &xdp) < 0 && cmd == XDP_QUERY_PROG);
+	if (prog)
+		return dev_xdp_query_generic(dev) ? XDP_FLAGS_SKB_MODE :
+			XDP_FLAGS_DRV_MODE;
+	return 0;
+}
 
-	return xdp.prog_id;
+u32 dev_xdp_query(struct net_device *dev, unsigned int mode)
+{
+	switch (mode) {
+	case XDP_FLAGS_DRV_MODE:
+		return dev_xdp_query_drv(dev);
+	case XDP_FLAGS_SKB_MODE:
+		return dev_xdp_query_generic(dev);
+	case XDP_FLAGS_HW_MODE:
+		return dev->xdp_prog_hw ? dev->xdp_prog_hw->aux->id : 0;
+	}
+	return 0;
 }
 
 static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
@@ -8027,45 +8049,47 @@ static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
 			   struct bpf_prog *prog)
 {
 	struct netdev_bpf xdp;
+	int err;
 
 	memset(&xdp, 0, sizeof(xdp));
-	if (flags & XDP_FLAGS_HW_MODE)
+	if (flags & XDP_FLAGS_HW_MODE) {
 		xdp.command = XDP_SETUP_PROG_HW;
-	else
+		xdp.flags = XDP_FLAGS_HW_MODE;
+	} else {
 		xdp.command = XDP_SETUP_PROG;
+		xdp.flags = flags;
+	}
 	xdp.extack = extack;
-	xdp.flags = flags;
 	xdp.prog = prog;
 
-	return bpf_op(dev, &xdp);
+	err = bpf_op(dev, &xdp);
+	if (err)
+		return err;
+
+	if (flags & XDP_FLAGS_HW_MODE) {
+		dev->xdp_prog_hw = prog;
+		return 0;
+	}
+
+	rcu_assign_pointer(dev->xdp_prog, prog);
+	dev->xdp_flags = prog ? flags : 0;
+	return 0;
 }
 
 static void dev_xdp_uninstall(struct net_device *dev)
 {
-	struct netdev_bpf xdp;
-	bpf_op_t ndo_bpf;
-
-	/* Remove generic XDP */
-	WARN_ON(dev_xdp_install(dev, generic_xdp_install, NULL, 0, NULL));
-
-	/* Remove from the driver */
-	ndo_bpf = dev->netdev_ops->ndo_bpf;
-	if (!ndo_bpf)
-		return;
-
-	memset(&xdp, 0, sizeof(xdp));
-	xdp.command = XDP_QUERY_PROG;
-	WARN_ON(ndo_bpf(dev, &xdp));
-	if (xdp.prog_id)
-		WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flags,
-					NULL));
+	struct bpf_prog *prog = rtnl_dereference(dev->xdp_prog);
+	bpf_op_t bpf_op;
 
-	/* Remove HW offload */
-	memset(&xdp, 0, sizeof(xdp));
-	xdp.command = XDP_QUERY_PROG_HW;
-	if (!ndo_bpf(dev, &xdp) && xdp.prog_id)
-		WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flags,
+	if (prog) {
+		bpf_op = dev_xdp_query_generic(dev) ?
+			 generic_xdp_install : dev->netdev_ops->ndo_bpf;
+		WARN_ON(dev_xdp_install(dev, bpf_op, NULL, dev->xdp_flags,
 					NULL));
+	}
+	if (dev_xdp_query(dev, XDP_FLAGS_HW_MODE))
+		WARN_ON(dev_xdp_install(dev, dev->netdev_ops->ndo_bpf,
+					NULL, XDP_FLAGS_HW_MODE, NULL));
 }
 
 /**
@@ -8080,41 +8104,49 @@ static void dev_xdp_uninstall(struct net_device *dev)
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 		      int fd, u32 flags)
 {
-	const struct net_device_ops *ops = dev->netdev_ops;
-	enum bpf_netdev_command query;
 	struct bpf_prog *prog = NULL;
-	bpf_op_t bpf_op, bpf_chk;
+	u32 mode, curr_mode;
+	bpf_op_t bpf_op;
 	bool offload;
 	int err;
 
 	ASSERT_RTNL();
 
 	offload = flags & XDP_FLAGS_HW_MODE;
-	query = offload ? XDP_QUERY_PROG_HW : XDP_QUERY_PROG;
+	mode = offload ? XDP_FLAGS_HW_MODE : XDP_FLAGS_DRV_MODE;
 
-	bpf_op = bpf_chk = ops->ndo_bpf;
+	bpf_op = dev->netdev_ops->ndo_bpf;
 	if (!bpf_op && (flags & (XDP_FLAGS_DRV_MODE | XDP_FLAGS_HW_MODE))) {
 		NL_SET_ERR_MSG(extack, "underlying driver does not support XDP in native mode");
 		return -EOPNOTSUPP;
 	}
-	if (!bpf_op || (flags & XDP_FLAGS_SKB_MODE))
-		bpf_op = generic_xdp_install;
-	if (bpf_op == bpf_chk)
-		bpf_chk = generic_xdp_install;
 
-	if (fd >= 0) {
-		if (!offload && __dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG)) {
+	if (!bpf_op || flags & XDP_FLAGS_SKB_MODE)
+		mode = XDP_FLAGS_SKB_MODE;
+
+	curr_mode = dev_xdp_current_mode(dev);
+
+	if (!offload && curr_mode && (mode ^ curr_mode) &
+	    (XDP_FLAGS_DRV_MODE | XDP_FLAGS_SKB_MODE)) {
+		if (fd >= 0) {
 			NL_SET_ERR_MSG(extack, "native and generic XDP can't be active at the same time");
 			return -EEXIST;
 		}
-		if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) &&
-		    __dev_xdp_query(dev, bpf_op, query)) {
+		return 0;
+	}
+
+	if (!offload && dev_xdp_query(dev, mode) &&
+	    !xdp_prog_flags_ok(dev->xdp_flags, flags, extack))
+		return -EBUSY;
+
+	if (fd >= 0) {
+		if (flags & XDP_FLAGS_UPDATE_IF_NOEXIST &&
+		    dev_xdp_query(dev, mode)) {
 			NL_SET_ERR_MSG(extack, "XDP program already attached");
 			return -EBUSY;
 		}
 
-		prog = bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP,
-					     bpf_op == ops->ndo_bpf);
+		prog = bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP, !!bpf_op);
 		if (IS_ERR(prog))
 			return PTR_ERR(prog);
 
@@ -8125,6 +8157,10 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 		}
 	}
 
+	if (mode == XDP_FLAGS_SKB_MODE) {
+		bpf_op = generic_xdp_install;
+		flags |= XDP_FLAGS_KERN_GENERIC;
+	}
 	err = dev_xdp_install(dev, bpf_op, extack, flags, prog);
 	if (err < 0 && prog)
 		bpf_prog_put(prog);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index adcc045952c2..5e396fd01d8b 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1360,42 +1360,44 @@ static int rtnl_fill_link_ifmap(struct sk_buff *skb, struct net_device *dev)
 	return 0;
 }
 
-static u32 rtnl_xdp_prog_skb(struct net_device *dev)
+static unsigned int rtnl_xdp_mode_to_flag(u8 tgt_mode)
 {
-	const struct bpf_prog *generic_xdp_prog;
-
-	ASSERT_RTNL();
-
-	generic_xdp_prog = rtnl_dereference(dev->xdp_prog);
-	if (!generic_xdp_prog)
-		return 0;
-	return generic_xdp_prog->aux->id;
-}
-
-static u32 rtnl_xdp_prog_drv(struct net_device *dev)
-{
-	return __dev_xdp_query(dev, dev->netdev_ops->ndo_bpf, XDP_QUERY_PROG);
+	switch (tgt_mode) {
+	case XDP_ATTACHED_DRV:
+		return XDP_FLAGS_DRV_MODE;
+	case XDP_ATTACHED_SKB:
+		return XDP_FLAGS_SKB_MODE;
+	case XDP_ATTACHED_HW:
+		return XDP_FLAGS_HW_MODE;
+	}
+	return 0;
 }
 
-static u32 rtnl_xdp_prog_hw(struct net_device *dev)
+static u32 rtnl_xdp_mode_to_attr(u8 tgt_mode)
 {
-	return __dev_xdp_query(dev, dev->netdev_ops->ndo_bpf,
-			       XDP_QUERY_PROG_HW);
+	switch (tgt_mode) {
+	case XDP_ATTACHED_DRV:
+		return IFLA_XDP_DRV_PROG_ID;
+	case XDP_ATTACHED_SKB:
+		return IFLA_XDP_SKB_PROG_ID;
+	case XDP_ATTACHED_HW:
+		return IFLA_XDP_HW_PROG_ID;
+	}
+	return 0;
 }
 
 static int rtnl_xdp_report_one(struct sk_buff *skb, struct net_device *dev,
-			       u32 *prog_id, u8 *mode, u8 tgt_mode, u32 attr,
-			       u32 (*get_prog_id)(struct net_device *dev))
+			       u32 *prog_id, u8 *mode, u8 tgt_mode)
 {
 	u32 curr_id;
 	int err;
 
-	curr_id = get_prog_id(dev);
+	curr_id = dev_xdp_query(dev, rtnl_xdp_mode_to_flag(tgt_mode));
 	if (!curr_id)
 		return 0;
 
 	*prog_id = curr_id;
-	err = nla_put_u32(skb, attr, curr_id);
+	err = nla_put_u32(skb, rtnl_xdp_mode_to_attr(tgt_mode), curr_id);
 	if (err)
 		return err;
 
@@ -1420,16 +1422,13 @@ static int rtnl_xdp_fill(struct sk_buff *skb, struct net_device *dev)
 
 	prog_id = 0;
 	mode = XDP_ATTACHED_NONE;
-	err = rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_SKB,
-				  IFLA_XDP_SKB_PROG_ID, rtnl_xdp_prog_skb);
+	err = rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_SKB);
 	if (err)
 		goto err_cancel;
-	err = rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_DRV,
-				  IFLA_XDP_DRV_PROG_ID, rtnl_xdp_prog_drv);
+	err = rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_DRV);
 	if (err)
 		goto err_cancel;
-	err = rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_HW,
-				  IFLA_XDP_HW_PROG_ID, rtnl_xdp_prog_hw);
+	err = rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_HW);
 	if (err)
 		goto err_cancel;
 
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 4b2b194f4f1f..af92c04a58d8 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -388,16 +388,23 @@ int xdp_attachment_query(struct xdp_attachment_info *info,
 }
 EXPORT_SYMBOL_GPL(xdp_attachment_query);
 
-bool xdp_attachment_flags_ok(struct xdp_attachment_info *info,
-			     struct netdev_bpf *bpf)
+bool xdp_prog_flags_ok(u32 old_flags, u32 new_flags,
+		       struct netlink_ext_ack *extack)
 {
-	if (info->prog && (bpf->flags ^ info->flags) & XDP_FLAGS_MODES) {
-		NL_SET_ERR_MSG(bpf->extack,
-			       "program loaded with different flags");
+	if ((new_flags ^ old_flags) & XDP_FLAGS_MODES) {
+		NL_SET_ERR_MSG(extack, "program loaded with different flags");
 		return false;
 	}
 	return true;
 }
+
+bool xdp_attachment_flags_ok(struct xdp_attachment_info *info,
+			     struct netdev_bpf *bpf)
+{
+	if (info->prog)
+		return xdp_prog_flags_ok(bpf->flags, info->flags, bpf->extack);
+	return true;
+}
 EXPORT_SYMBOL_GPL(xdp_attachment_flags_ok);
 
 void xdp_attachment_setup(struct xdp_attachment_info *info,
-- 
2.20.1

