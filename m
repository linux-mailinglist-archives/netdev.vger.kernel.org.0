Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7F5F26411
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 14:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbfEVMyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 08:54:15 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43035 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728761AbfEVMyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 08:54:14 -0400
Received: by mail-pl1-f194.google.com with SMTP id gn7so1032314plb.10;
        Wed, 22 May 2019 05:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xVl3J9/WydUn2c7pRAewgjpdp1cbjzSQQdH2/2IJB+g=;
        b=Z6pj81rOx71+uoK7h1dGZXnombEN8PuPvi10LRIkx7nx9V9+IIqJaFZovbuBLGooGE
         BkKADwb4Xqd4ME3sCzae40rXXYqQrS+ivM3t3VFI5GPKwNdKMM0D+mkPmf5Szr0pe1N3
         sXhVddzzTYzOK1oV509qQi76uxU8ez3+uI4qRJg3aZqD8lTK+YA1KITWer3BP7JiZyet
         All00c+X3weY0siA/wKOomZBu7UFbYpFzU5ZJ5wrFUQXa4Pqb38SQoy0U33nm2c3MJPk
         fICTOTCIFe/55aiTw3KnZZx/vOZZg2eswh+6Wr0jNJjDpWhKS0jOhbTQz0Z4ZbASuk+a
         uRXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xVl3J9/WydUn2c7pRAewgjpdp1cbjzSQQdH2/2IJB+g=;
        b=mUpN8P3RZkpWET8Q++PJsUC0CBKITH9TzoNtqV6gaGsK8/ADoPYMqUE6/ZVYav1XsO
         LDIsUeRMfNzsxs5zp067FVQoo6XBJfLgHB/Ye9qh4PY0fDjC0T59ZXF01S6pjJh5+dxC
         l235BZAzRhcEzr3wJ9E2j7+iYEFzkOgDJG+SJv3RnYJXSfUJAcexnYIH5L7abxWKQapt
         70/X6CfSj+MYBmtZ4EXOM9KUrZ2cESikKXW4QlStBOs7qVavVP8ASd5nzY4igqVCiicu
         3CbHLQ2OwkZ/eCTukinTwVgqEaKf9TtsLbnI1MqSXcvmJSXHMcxGEjhFngN4D7qTPBEJ
         xDOQ==
X-Gm-Message-State: APjAAAX6vhNYmeoSGMd+ZiwIE7YVeFkGLQoIbLIaHKwCSPOdlIHBRCLK
        OiAXhLrFUIvF/dNz0ulnHaE=
X-Google-Smtp-Source: APXvYqxUb3+4GbygSOul91k9dQ7HbJDXLhPCW7T7ycejIaCHeIC0IZzbRDWkUnbidTjeUsmN8Yx2UA==
X-Received: by 2002:a17:902:56d:: with SMTP id 100mr89868710plf.246.1558529653513;
        Wed, 22 May 2019 05:54:13 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.43])
        by smtp.gmail.com with ESMTPSA id 127sm29671054pfc.159.2019.05.22.05.54.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 05:54:12 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     toke@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, brouer@redhat.com, bpf@vger.kernel.org,
        jakub.kicinski@netronome.com
Subject: [PATCH bpf-next 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW} to netdev
Date:   Wed, 22 May 2019 14:53:51 +0200
Message-Id: <20190522125353.6106-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522125353.6106-1-bjorn.topel@gmail.com>
References: <20190522125353.6106-1-bjorn.topel@gmail.com>
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

The struct net_device has gained four new members tracking the XDP
program, the corresponding program flags, and which programs
(SKB_MODE, DRV_MODE or HW_MODE) that are activated.

The xdp_prog member, previously only used for SKB_MODE, is shared with
DRV_MODE, since they are mutually exclusive.

The program query operations is all done under the rtnl lock. However,
the xdp_prog member is __rcu annotated, and used in a lock-less manner
for the SKB_MODE. This is because the xdp_prog member is shared from a
query program perspective (again, SKB and DRV are mutual exclusive),
RCU read and assignments functions are still used when altering
xdp_prog, even when only for queries in DRV_MODE. This is for
sparse/lockdep correctness.

A minor behavioral change was done during this refactorization; When
passing a negative file descriptor to a netdev to disable XDP, the
same program flag as the running program is required. An example.

The eth0 is DRV_DRV capable. Previously, this was OK, but confusing:

  # ip link set dev eth0 xdp obj foo.o sec main
  # ip link set dev eth0 xdpgeneric off

Now, the same commands give:

  # ip link set dev eth0 xdp obj foo.o sec main
  # ip link set dev eth0 xdpgeneric off
  Error: native and generic XDP can't be active at the same time.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/linux/netdevice.h |  13 +++--
 net/core/dev.c            | 120 ++++++++++++++++++++------------------
 net/core/rtnetlink.c      |  33 ++---------
 3 files changed, 76 insertions(+), 90 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 44b47e9df94a..bdcb20a3946c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1940,6 +1940,11 @@ struct net_device {
 #endif
 	struct hlist_node	index_hlist;
 
+	struct bpf_prog		*xdp_prog_hw;
+	unsigned int		xdp_flags;
+	u32			xdp_prog_flags;
+	u32			xdp_prog_hw_flags;
+
 /*
  * Cache lines mostly used on transmit path
  */
@@ -2045,9 +2050,8 @@ struct net_device {
 
 static inline bool netif_elide_gro(const struct net_device *dev)
 {
-	if (!(dev->features & NETIF_F_GRO) || dev->xdp_prog)
-		return true;
-	return false;
+	return !(dev->features & NETIF_F_GRO) ||
+		dev->xdp_flags & XDP_FLAGS_SKB_MODE;
 }
 
 #define	NETDEV_ALIGN		32
@@ -3684,8 +3688,7 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 		      int fd, u32 flags);
-u32 __dev_xdp_query(struct net_device *dev, bpf_op_t xdp_op,
-		    enum bpf_netdev_command cmd);
+u32 dev_xdp_query(struct net_device *dev, unsigned int flags);
 int xdp_umem_query(struct net_device *dev, u16 queue_id);
 
 int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
diff --git a/net/core/dev.c b/net/core/dev.c
index b6b8505cfb3e..ead16c3f955c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8005,31 +8005,31 @@ int dev_change_proto_down_generic(struct net_device *dev, bool proto_down)
 }
 EXPORT_SYMBOL(dev_change_proto_down_generic);
 
-u32 __dev_xdp_query(struct net_device *dev, bpf_op_t bpf_op,
-		    enum bpf_netdev_command cmd)
+u32 dev_xdp_query(struct net_device *dev, unsigned int flags)
 {
-	struct netdev_bpf xdp;
+	struct bpf_prog *prog = NULL;
 
-	if (!bpf_op)
+	if (hweight32(flags) != 1)
 		return 0;
 
-	memset(&xdp, 0, sizeof(xdp));
-	xdp.command = cmd;
-
-	/* Query must always succeed. */
-	WARN_ON(bpf_op(dev, &xdp) < 0 && cmd == XDP_QUERY_PROG);
+	if (flags & (XDP_FLAGS_SKB_MODE | XDP_FLAGS_DRV_MODE))
+		prog = rtnl_dereference(dev->xdp_prog);
+	else if (flags & XDP_FLAGS_HW_MODE)
+		prog = dev->xdp_prog_hw;
 
-	return xdp.prog_id;
+	return prog ? prog->aux->id : 0;
 }
 
-static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
+static int dev_xdp_install(struct net_device *dev, unsigned int target,
 			   struct netlink_ext_ack *extack, u32 flags,
 			   struct bpf_prog *prog)
 {
+	bpf_op_t bpf_op = dev->netdev_ops->ndo_bpf;
 	struct netdev_bpf xdp;
+	int err;
 
 	memset(&xdp, 0, sizeof(xdp));
-	if (flags & XDP_FLAGS_HW_MODE)
+	if (target == XDP_FLAGS_HW_MODE)
 		xdp.command = XDP_SETUP_PROG_HW;
 	else
 		xdp.command = XDP_SETUP_PROG;
@@ -8037,35 +8037,41 @@ static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
 	xdp.flags = flags;
 	xdp.prog = prog;
 
-	return bpf_op(dev, &xdp);
+	err = (target == XDP_FLAGS_SKB_MODE) ?
+	      generic_xdp_install(dev, &xdp) :
+	      bpf_op(dev, &xdp);
+	if (!err) {
+		if (prog)
+			dev->xdp_flags |= target;
+		else
+			dev->xdp_flags &= ~target;
+
+		if (target == XDP_FLAGS_HW_MODE) {
+			dev->xdp_prog_hw = prog;
+			dev->xdp_prog_hw_flags = flags;
+		} else if (target == XDP_FLAGS_DRV_MODE) {
+			rcu_assign_pointer(dev->xdp_prog, prog);
+			dev->xdp_prog_flags = flags;
+		}
+	}
+
+	return err;
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
-
-	/* Remove HW offload */
-	memset(&xdp, 0, sizeof(xdp));
-	xdp.command = XDP_QUERY_PROG_HW;
-	if (!ndo_bpf(dev, &xdp) && xdp.prog_id)
-		WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flags,
-					NULL));
+	if (dev->xdp_flags & XDP_FLAGS_SKB_MODE) {
+		WARN_ON(dev_xdp_install(dev, XDP_FLAGS_SKB_MODE,
+					NULL, 0, NULL));
+	}
+	if (dev->xdp_flags & XDP_FLAGS_DRV_MODE) {
+		WARN_ON(dev_xdp_install(dev, XDP_FLAGS_DRV_MODE,
+					NULL, dev->xdp_prog_flags, NULL));
+	}
+	if (dev->xdp_flags & XDP_FLAGS_HW_MODE) {
+		WARN_ON(dev_xdp_install(dev, XDP_FLAGS_HW_MODE,
+					NULL, dev->xdp_prog_hw_flags, NULL));
+	}
 }
 
 /**
@@ -8080,41 +8086,41 @@ static void dev_xdp_uninstall(struct net_device *dev)
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 		      int fd, u32 flags)
 {
-	const struct net_device_ops *ops = dev->netdev_ops;
-	enum bpf_netdev_command query;
+	bool offload, drv_supp = !!dev->netdev_ops->ndo_bpf;
 	struct bpf_prog *prog = NULL;
-	bpf_op_t bpf_op, bpf_chk;
-	bool offload;
+	unsigned int target;
 	int err;
 
 	ASSERT_RTNL();
 
 	offload = flags & XDP_FLAGS_HW_MODE;
-	query = offload ? XDP_QUERY_PROG_HW : XDP_QUERY_PROG;
+	target = offload ? XDP_FLAGS_HW_MODE : XDP_FLAGS_DRV_MODE;
 
-	bpf_op = bpf_chk = ops->ndo_bpf;
-	if (!bpf_op && (flags & (XDP_FLAGS_DRV_MODE | XDP_FLAGS_HW_MODE))) {
+	if (!drv_supp && (flags & (XDP_FLAGS_DRV_MODE | XDP_FLAGS_HW_MODE))) {
 		NL_SET_ERR_MSG(extack, "underlying driver does not support XDP in native mode");
 		return -EOPNOTSUPP;
 	}
-	if (!bpf_op || (flags & XDP_FLAGS_SKB_MODE))
-		bpf_op = generic_xdp_install;
-	if (bpf_op == bpf_chk)
-		bpf_chk = generic_xdp_install;
+
+	if (!drv_supp || (flags & XDP_FLAGS_SKB_MODE))
+		target = XDP_FLAGS_SKB_MODE;
+
+	if ((target == XDP_FLAGS_SKB_MODE &&
+	     dev->xdp_flags & XDP_FLAGS_DRV_MODE) ||
+	    (target == XDP_FLAGS_DRV_MODE &&
+	     dev->xdp_flags & XDP_FLAGS_SKB_MODE)) {
+		NL_SET_ERR_MSG(extack, "native and generic XDP can't be active at the same time");
+		return -EEXIST;
+	}
 
 	if (fd >= 0) {
-		if (!offload && __dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG)) {
-			NL_SET_ERR_MSG(extack, "native and generic XDP can't be active at the same time");
-			return -EEXIST;
-		}
-		if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) &&
-		    __dev_xdp_query(dev, bpf_op, query)) {
+		if (flags & XDP_FLAGS_UPDATE_IF_NOEXIST &&
+		    dev_xdp_query(dev, target)) {
 			NL_SET_ERR_MSG(extack, "XDP program already attached");
 			return -EBUSY;
 		}
 
-		prog = bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP,
-					     bpf_op == ops->ndo_bpf);
+		prog = bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP, drv_supp);
+
 		if (IS_ERR(prog))
 			return PTR_ERR(prog);
 
@@ -8125,7 +8131,7 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 		}
 	}
 
-	err = dev_xdp_install(dev, bpf_op, extack, flags, prog);
+	err = dev_xdp_install(dev, target, extack, flags, prog);
 	if (err < 0 && prog)
 		bpf_prog_put(prog);
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index adcc045952c2..99ca58db297f 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1360,37 +1360,14 @@ static int rtnl_fill_link_ifmap(struct sk_buff *skb, struct net_device *dev)
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
+			       unsigned int tgt_flags)
 {
 	u32 curr_id;
 	int err;
 
-	curr_id = get_prog_id(dev);
+	curr_id = dev_xdp_query(dev, tgt_flags);
 	if (!curr_id)
 		return 0;
 
@@ -1421,15 +1398,15 @@ static int rtnl_xdp_fill(struct sk_buff *skb, struct net_device *dev)
 	prog_id = 0;
 	mode = XDP_ATTACHED_NONE;
 	err = rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_SKB,
-				  IFLA_XDP_SKB_PROG_ID, rtnl_xdp_prog_skb);
+				  IFLA_XDP_SKB_PROG_ID, XDP_FLAGS_SKB_MODE);
 	if (err)
 		goto err_cancel;
 	err = rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_DRV,
-				  IFLA_XDP_DRV_PROG_ID, rtnl_xdp_prog_drv);
+				  IFLA_XDP_DRV_PROG_ID, XDP_FLAGS_DRV_MODE);
 	if (err)
 		goto err_cancel;
 	err = rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_HW,
-				  IFLA_XDP_HW_PROG_ID, rtnl_xdp_prog_hw);
+				  IFLA_XDP_HW_PROG_ID, XDP_FLAGS_HW_MODE);
 	if (err)
 		goto err_cancel;
 
-- 
2.20.1

