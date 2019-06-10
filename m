Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9EC33B8D8
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403811AbfFJQDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:03:09 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45179 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389356AbfFJQDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:03:08 -0400
Received: by mail-pf1-f194.google.com with SMTP id s11so5550991pfm.12;
        Mon, 10 Jun 2019 09:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zKJWKv8khGodiuB3P5yULLDNXN6VlVvR1kwqoy2yf8U=;
        b=bP08qCLRjevaaBMzzsQsiisUHu0eDVQczD7VHdOkZKdCGNB/t3tnkaPzAul/+H/c2r
         Q9PvZYv4RmWOzF63vkbpo148OM5+vYYpen5eFzVfCfMgI+Rxo1BK3UipaOn8v/SvgfBz
         hPBwnUpRdPNPCTFkS0uCpt7RHT6QzAiV9GvtWXRPAi9nNmUsknYnDskUp530ua5a9CTa
         1dJAodXrrf8suIRQTRAlcFsvbXFaKgD8y+teFswLPW423iKbCb2yrCHyg0eB9do9uxJz
         Pfa8ulDnTRzhxIJkS7Dx8Kkx44kUb/wF5EqXa9vMHD1Zndn8Wtf9RBxmUJl2WSQ0aJWv
         CFgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zKJWKv8khGodiuB3P5yULLDNXN6VlVvR1kwqoy2yf8U=;
        b=cQTOsjHn5DnfZeBJPCQkE88DMY35HihXGLMf2DEL56f8aJMHJHdbM+xXTTcwTEm+fp
         yZx0X1tRUUi77ZoKLLfN6lOasCOMAiE5YteemY3JVMAiesjHa8/Tx0dSZTXWMIrc9EXE
         sPAR0UruYVa3/3hinOhhb4AuLq5xji3C78UNDoaUhuk46mLxzGQdgM8RPCPemgOW3xyf
         Tgc6sa/0bSGT6cC6cpmGKoNhn70BYjIYzQqzkHiO2/+dgKXw1m/bjQ+/37oOGJKPqkDs
         qC3ZFTz08XSIPDtzKfOQLnjh/8IMjoGeKdbrtCvDa0tjz84JkKohrvzUD8usndhCxv7Y
         QapQ==
X-Gm-Message-State: APjAAAUp2tlnW8mon/s2J2LncHkEIL06lKs9XjABOC3jyQfpxsQnRd0G
        FhM0jJ5dwGvd8hgYTHcpBLo=
X-Google-Smtp-Source: APXvYqwUdHM7NAv48qD/uYfMjB7tWJjZkJ8LfKXBVM9KXKN2PPfAnf2AaMyL46evPSfbImaEJXEt7Q==
X-Received: by 2002:a62:640e:: with SMTP id y14mr72580174pfb.109.1560182587996;
        Mon, 10 Jun 2019 09:03:07 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.44])
        by smtp.gmail.com with ESMTPSA id f5sm10574118pfn.161.2019.06.10.09.02.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 10 Jun 2019 09:03:07 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, toke@redhat.com, brouer@redhat.com,
        bpf@vger.kernel.org, jakub.kicinski@netronome.com,
        saeedm@mellanox.com
Subject: [PATCH bpf-next v3 1/5] net: xdp: refactor XDP_QUERY_PROG{,_HW} to netdev
Date:   Mon, 10 Jun 2019 18:02:30 +0200
Message-Id: <20190610160234.4070-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190610160234.4070-1-bjorn.topel@gmail.com>
References: <20190610160234.4070-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

All XDP capable drivers need to implement the XDP_QUERY_PROG{,_HW}
command of ndo_bpf. This commit refactors the query code up from the
drivers to the netdev level.

The xdp_prog member of the struct net_device has evolved into a struct
netdev_xdp. The new structure contains an array of XDP programs, which
are allocated at run time. Each entry represents an XDP program for a
certain mode (SKB, DRV or HW). Only netdevs that has announced support
for XDP offload, using the new dev_xdp_support_offload() function,
will allocate space for HW XDP programs. This means that that
offloading capability can be checked in the generic path as well.

For simplicity, SKB and DRV XDP programs populate different entries,
even though they cannot be enabled simultaneously.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/netdevice.h |  21 +++--
 net/core/dev.c            | 156 ++++++++++++++++++++++++++------------
 net/core/rtnetlink.c      |  31 +-------
 3 files changed, 126 insertions(+), 82 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 44b47e9df94a..fd2fae39218f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -903,6 +903,14 @@ struct netdev_bpf {
 	};
 };
 
+int dev_xdp_support_offload(struct net_device *dev);
+
+struct netdev_xdp {
+	struct bpf_prog __rcu **prog;
+	int num_progs;
+	bool explicit_mode;
+};
+
 #ifdef CONFIG_XFRM_OFFLOAD
 struct xfrmdev_ops {
 	int	(*xdo_dev_state_add) (struct xfrm_state *x);
@@ -1921,7 +1929,7 @@ struct net_device {
 	unsigned int		num_rx_queues;
 	unsigned int		real_num_rx_queues;
 
-	struct bpf_prog __rcu	*xdp_prog;
+	struct netdev_xdp	xdp;
 	unsigned long		gro_flush_timeout;
 	rx_handler_func_t __rcu	*rx_handler;
 	void __rcu		*rx_handler_data;
@@ -2045,9 +2053,8 @@ struct net_device {
 
 static inline bool netif_elide_gro(const struct net_device *dev)
 {
-	if (!(dev->features & NETIF_F_GRO) || dev->xdp_prog)
-		return true;
-	return false;
+	return !(dev->features & NETIF_F_GRO) ||
+		(dev->xdp.prog && dev->xdp.prog[0]);
 }
 
 #define	NETDEV_ALIGN		32
@@ -3682,10 +3689,12 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 				    struct netdev_queue *txq, int *ret);
 
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
+typedef u32 (*xdp_query_prog_t)(struct net_device *dev);
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 		      int fd, u32 flags);
-u32 __dev_xdp_query(struct net_device *dev, bpf_op_t xdp_op,
-		    enum bpf_netdev_command cmd);
+u32 dev_xdp_query_generic(struct net_device *dev);
+u32 dev_xdp_query_drv(struct net_device *dev);
+u32 dev_xdp_query_hw(struct net_device *dev);
 int xdp_umem_query(struct net_device *dev, u16 queue_id);
 
 int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
diff --git a/net/core/dev.c b/net/core/dev.c
index 66f7508825bd..d6ea5733986f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4813,6 +4813,11 @@ static inline int nf_ingress(struct sk_buff *skb, struct packet_type **pt_prev,
 	return 0;
 }
 
+static struct bpf_prog *dev_xdp_get_generic(struct net_device *dev)
+{
+	return dev->xdp.prog ? rcu_dereference(dev->xdp.prog[0]) : NULL;
+}
+
 static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 				    struct packet_type **ppt_prev)
 {
@@ -4845,7 +4850,7 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 		int ret2;
 
 		preempt_disable();
-		ret2 = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
+		ret2 = do_xdp_generic(dev_xdp_get_generic(skb->dev), skb);
 		preempt_enable();
 
 		if (ret2 != XDP_PASS)
@@ -5133,13 +5138,13 @@ static void __netif_receive_skb_list(struct list_head *head)
 
 static int generic_xdp_install(struct net_device *dev, struct netdev_bpf *xdp)
 {
-	struct bpf_prog *old = rtnl_dereference(dev->xdp_prog);
+	struct bpf_prog *old = rtnl_dereference(dev->xdp.prog[0]);
 	struct bpf_prog *new = xdp->prog;
 	int ret = 0;
 
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
-		rcu_assign_pointer(dev->xdp_prog, new);
+		rcu_assign_pointer(dev->xdp.prog[0], new);
 		if (old)
 			bpf_prog_put(old);
 
@@ -7971,67 +7976,93 @@ int dev_change_proto_down_generic(struct net_device *dev, bool proto_down)
 }
 EXPORT_SYMBOL(dev_change_proto_down_generic);
 
-u32 __dev_xdp_query(struct net_device *dev, bpf_op_t bpf_op,
-		    enum bpf_netdev_command cmd)
+static u32 __dev_xdp_query(struct net_device *dev, int mode)
 {
-	struct netdev_bpf xdp;
+	if (dev->xdp.prog && dev->xdp.num_progs > mode) {
+		struct bpf_prog *prog = rtnl_dereference(dev->xdp.prog[mode]);
 
-	if (!bpf_op)
-		return 0;
+		return prog ? prog->aux->id : 0;
+	}
+	return 0;
+}
 
-	memset(&xdp, 0, sizeof(xdp));
-	xdp.command = cmd;
+u32 dev_xdp_query_generic(struct net_device *dev)
+{
+	return __dev_xdp_query(dev, 0);
+}
 
-	/* Query must always succeed. */
-	WARN_ON(bpf_op(dev, &xdp) < 0 && cmd == XDP_QUERY_PROG);
+u32 dev_xdp_query_drv(struct net_device *dev)
+{
+	return __dev_xdp_query(dev, 1);
+}
 
-	return xdp.prog_id;
+u32 dev_xdp_query_hw(struct net_device *dev)
+{
+	return __dev_xdp_query(dev, 2);
+}
+
+static bool dev_xdp_support_hw(struct net_device *dev)
+{
+	return dev->xdp.num_progs > 2;
 }
 
 static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
 			   struct netlink_ext_ack *extack, u32 flags,
 			   struct bpf_prog *prog)
 {
-	struct netdev_bpf xdp;
+	struct netdev_bpf xdp = {};
+	struct bpf_prog **entry;
+	int err;
 
-	memset(&xdp, 0, sizeof(xdp));
-	if (flags & XDP_FLAGS_HW_MODE)
+	if (!dev->xdp.prog) {
+		dev->xdp.prog = kcalloc(dev->xdp.num_progs,
+					sizeof(dev->xdp.prog), GFP_KERNEL);
+		if (!dev->xdp.prog)
+			return -ENOMEM;
+	}
+
+	if (flags & XDP_FLAGS_HW_MODE) {
 		xdp.command = XDP_SETUP_PROG_HW;
-	else
+		entry = &dev->xdp.prog[2];
+	} else {
 		xdp.command = XDP_SETUP_PROG;
+		entry = bpf_op == generic_xdp_install ? &dev->xdp.prog[0] :
+			&dev->xdp.prog[1];
+	}
+
 	xdp.extack = extack;
 	xdp.flags = flags;
 	xdp.prog = prog;
 
-	return bpf_op(dev, &xdp);
+	err = bpf_op(dev, &xdp);
+	if (err)
+		return err;
+
+	rcu_assign_pointer(*entry, prog);
+	dev->xdp.explicit_mode =
+		prog ? flags & (XDP_FLAGS_SKB_MODE | XDP_FLAGS_DRV_MODE) : 0;
+	return 0;
 }
 
 static void dev_xdp_uninstall(struct net_device *dev)
 {
-	struct netdev_bpf xdp;
-	bpf_op_t ndo_bpf;
-
-	/* Remove generic XDP */
-	WARN_ON(dev_xdp_install(dev, generic_xdp_install, NULL, 0, NULL));
+	u32 flags;
 
-	/* Remove from the driver */
-	ndo_bpf = dev->netdev_ops->ndo_bpf;
-	if (!ndo_bpf)
-		return;
+	if (dev_xdp_query_generic(dev)) {
+		flags = dev->xdp.explicit_mode ? XDP_FLAGS_SKB_MODE : 0;
+		WARN_ON(dev_xdp_install(dev, generic_xdp_install, NULL,
+					flags, NULL));
+	}
 
-	memset(&xdp, 0, sizeof(xdp));
-	xdp.command = XDP_QUERY_PROG;
-	WARN_ON(ndo_bpf(dev, &xdp));
-	if (xdp.prog_id)
-		WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flags,
-					NULL));
+	if (dev_xdp_query_drv(dev)) {
+		flags = dev->xdp.explicit_mode ? XDP_FLAGS_DRV_MODE : 0;
+		WARN_ON(dev_xdp_install(dev, dev->netdev_ops->ndo_bpf, NULL,
+					flags, NULL));
+	}
 
-	/* Remove HW offload */
-	memset(&xdp, 0, sizeof(xdp));
-	xdp.command = XDP_QUERY_PROG_HW;
-	if (!ndo_bpf(dev, &xdp) && xdp.prog_id)
-		WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flags,
-					NULL));
+	if (dev_xdp_query_hw(dev))
+		WARN_ON(dev_xdp_install(dev, dev->netdev_ops->ndo_bpf, NULL,
+					XDP_FLAGS_HW_MODE, NULL));
 }
 
 /**
@@ -8047,34 +8078,41 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 		      int fd, u32 flags)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
-	enum bpf_netdev_command query;
+	xdp_query_prog_t query, check;
 	struct bpf_prog *prog = NULL;
-	bpf_op_t bpf_op, bpf_chk;
+	bpf_op_t bpf_op;
 	bool offload;
 	int err;
 
 	ASSERT_RTNL();
 
 	offload = flags & XDP_FLAGS_HW_MODE;
-	query = offload ? XDP_QUERY_PROG_HW : XDP_QUERY_PROG;
 
-	bpf_op = bpf_chk = ops->ndo_bpf;
+	if (offload && !dev_xdp_support_hw(dev)) {
+		NL_SET_ERR_MSG(extack, "underlying driver does not support XDP offload");
+		return -EOPNOTSUPP;
+	}
+
+	bpf_op = ops->ndo_bpf;
+	query = offload ? dev_xdp_query_hw : dev_xdp_query_drv;
+	check = dev_xdp_query_generic;
 	if (!bpf_op && (flags & (XDP_FLAGS_DRV_MODE | XDP_FLAGS_HW_MODE))) {
 		NL_SET_ERR_MSG(extack, "underlying driver does not support XDP in native mode");
 		return -EOPNOTSUPP;
 	}
-	if (!bpf_op || (flags & XDP_FLAGS_SKB_MODE))
+	if (!bpf_op || (flags & XDP_FLAGS_SKB_MODE)) {
 		bpf_op = generic_xdp_install;
-	if (bpf_op == bpf_chk)
-		bpf_chk = generic_xdp_install;
+		query = dev_xdp_query_generic;
+	}
+	if (bpf_op == generic_xdp_install)
+		check = dev_xdp_query_drv;
 
 	if (fd >= 0) {
-		if (!offload && __dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG)) {
+		if (!offload && check(dev)) {
 			NL_SET_ERR_MSG(extack, "native and generic XDP can't be active at the same time");
 			return -EEXIST;
 		}
-		if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) &&
-		    __dev_xdp_query(dev, bpf_op, query)) {
+		if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) && query(dev)) {
 			NL_SET_ERR_MSG(extack, "XDP program already attached");
 			return -EBUSY;
 		}
@@ -8098,6 +8136,24 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 	return err;
 }
 
+/**
+ *	dev_xdp_support_offload	- announce XDP offload support
+ *	@dev: device
+ *
+ *	Announce that the netdev has support for XDP offloading.
+ */
+int dev_xdp_support_offload(struct net_device *dev)
+{
+	if (dev->xdp.prog) {
+		netdev_WARN(dev, "announcing XDP offloading support too late!\n");
+		return -EINVAL;
+	}
+
+	dev->xdp.num_progs = 3;
+	return 0;
+}
+EXPORT_SYMBOL(dev_xdp_support_offload);
+
 /**
  *	dev_new_index	-	allocate an ifindex
  *	@net: the applicable net namespace
@@ -9175,6 +9231,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 		dev->ethtool_ops = &default_ethtool_ops;
 
 	nf_hook_ingress_init(dev);
+	dev->xdp.num_progs = 2;
 
 	return dev;
 
@@ -9206,6 +9263,7 @@ void free_netdev(struct net_device *dev)
 	might_sleep();
 	netif_free_tx_queues(dev);
 	netif_free_rx_queues(dev);
+	kfree(dev->xdp.prog);
 
 	kfree(rcu_dereference_protected(dev->ingress_queue, 1));
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index adcc045952c2..aac7c71ca163 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1360,32 +1360,9 @@ static int rtnl_fill_link_ifmap(struct sk_buff *skb, struct net_device *dev)
 	return 0;
 }
 
-static u32 rtnl_xdp_prog_skb(struct net_device *dev)
-{
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
-}
-
-static u32 rtnl_xdp_prog_hw(struct net_device *dev)
-{
-	return __dev_xdp_query(dev, dev->netdev_ops->ndo_bpf,
-			       XDP_QUERY_PROG_HW);
-}
-
 static int rtnl_xdp_report_one(struct sk_buff *skb, struct net_device *dev,
 			       u32 *prog_id, u8 *mode, u8 tgt_mode, u32 attr,
-			       u32 (*get_prog_id)(struct net_device *dev))
+			       xdp_query_prog_t get_prog_id)
 {
 	u32 curr_id;
 	int err;
@@ -1421,15 +1398,15 @@ static int rtnl_xdp_fill(struct sk_buff *skb, struct net_device *dev)
 	prog_id = 0;
 	mode = XDP_ATTACHED_NONE;
 	err = rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_SKB,
-				  IFLA_XDP_SKB_PROG_ID, rtnl_xdp_prog_skb);
+				  IFLA_XDP_SKB_PROG_ID, dev_xdp_query_generic);
 	if (err)
 		goto err_cancel;
 	err = rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_DRV,
-				  IFLA_XDP_DRV_PROG_ID, rtnl_xdp_prog_drv);
+				  IFLA_XDP_DRV_PROG_ID, dev_xdp_query_drv);
 	if (err)
 		goto err_cancel;
 	err = rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_HW,
-				  IFLA_XDP_HW_PROG_ID, rtnl_xdp_prog_hw);
+				  IFLA_XDP_HW_PROG_ID, dev_xdp_query_hw);
 	if (err)
 		goto err_cancel;
 
-- 
2.20.1

