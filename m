Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1641B6B17
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 04:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgDXCL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 22:11:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbgDXCLz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 22:11:55 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E107021655;
        Fri, 24 Apr 2020 02:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587694314;
        bh=cw1OvB5bjfmz4ISgzkV8Bh/aCkK9wGEOhV6W78g9uUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CNCju+zVN9v5bIrbDddLEerAx4ZVx9wf7KHi/MMm4EDjw9HlSvPzlMGS/I6RpCPod
         +Ae8wUJYaoyz6AvEpi63+5wjxObUrRzmL/t3xliWLHNxkVHrITxsd9E7jIgBnFxLvI
         3LfPldJ/pfPXak9L/Pn4zipVXq4w62Itx3IAiAJo=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v2 bpf-next 03/17] net: Add XDP setup and query commands for Tx programs
Date:   Thu, 23 Apr 2020 20:11:34 -0600
Message-Id: <20200424021148.83015-4-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200424021148.83015-1-dsahern@kernel.org>
References: <20200424021148.83015-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

Add new netdev commands, XDP_SETUP_PROG_EGRESS and
XDP_QUERY_PROG_EGRESS, to query and setup egress programs.

Update dev_change_xdp_fd and dev_xdp_install to take an egress argument.
If egress bool is set, then use XDP_SETUP_PROG_EGRESS in dev_xdp_install
and XDP_QUERY_PROG_EGRESS in dev_change_xdp_fd.

Update dev_xdp_uninstall to query for XDP_QUERY_PROG_EGRESS and if a
program is installed call dev_xdp_install with the egress argument set
to true.

This enables existing infrastructure to be used for XDP programs in
the egress path.

Signed-off-by: David Ahern <dahern@digitalocean.com>
Co-developed-by: Prashant Bhole <prashantbhole.linux@gmail.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 include/linux/netdevice.h |  4 +++-
 net/core/dev.c            | 34 +++++++++++++++++++++++-----------
 net/core/rtnetlink.c      |  2 +-
 3 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0750b54b3765..a416c838b0ec 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -872,8 +872,10 @@ enum bpf_netdev_command {
 	 */
 	XDP_SETUP_PROG,
 	XDP_SETUP_PROG_HW,
+	XDP_SETUP_PROG_EGRESS,
 	XDP_QUERY_PROG,
 	XDP_QUERY_PROG_HW,
+	XDP_QUERY_PROG_EGRESS,
 	/* BPF program for offload callbacks, invoked at program load time. */
 	BPF_OFFLOAD_MAP_ALLOC,
 	BPF_OFFLOAD_MAP_FREE,
@@ -3778,7 +3780,7 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
-		      int fd, int expected_fd, u32 flags);
+		      int fd, int expected_fd, u32 flags, bool egress);
 u32 __dev_xdp_query(struct net_device *dev, bpf_op_t xdp_op,
 		    enum bpf_netdev_command cmd);
 int xdp_umem_query(struct net_device *dev, u16 queue_id);
diff --git a/net/core/dev.c b/net/core/dev.c
index fb61522b1ce1..1d0142c1bfb3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8590,7 +8590,7 @@ u32 __dev_xdp_query(struct net_device *dev, bpf_op_t bpf_op,
 
 static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
 			   struct netlink_ext_ack *extack, u32 flags,
-			   struct bpf_prog *prog)
+			   struct bpf_prog *prog, bool egress)
 {
 	bool non_hw = !(flags & XDP_FLAGS_HW_MODE);
 	struct bpf_prog *prev_prog = NULL;
@@ -8598,8 +8598,10 @@ static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
 	int err;
 
 	if (non_hw) {
-		prev_prog = bpf_prog_by_id(__dev_xdp_query(dev, bpf_op,
-							   XDP_QUERY_PROG));
+		enum bpf_netdev_command cmd;
+
+		cmd = egress ? XDP_QUERY_PROG_EGRESS : XDP_QUERY_PROG;
+		prev_prog = bpf_prog_by_id(__dev_xdp_query(dev, bpf_op, cmd));
 		if (IS_ERR(prev_prog))
 			prev_prog = NULL;
 	}
@@ -8608,7 +8610,7 @@ static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
 	if (flags & XDP_FLAGS_HW_MODE)
 		xdp.command = XDP_SETUP_PROG_HW;
 	else
-		xdp.command = XDP_SETUP_PROG;
+		xdp.command = egress ? XDP_SETUP_PROG_EGRESS : XDP_SETUP_PROG;
 	xdp.extack = extack;
 	xdp.flags = flags;
 	xdp.prog = prog;
@@ -8629,7 +8631,12 @@ static void dev_xdp_uninstall(struct net_device *dev)
 	bpf_op_t ndo_bpf;
 
 	/* Remove generic XDP */
-	WARN_ON(dev_xdp_install(dev, generic_xdp_install, NULL, 0, NULL));
+	WARN_ON(dev_xdp_install(dev, generic_xdp_install, NULL, 0, NULL,
+				false));
+
+	/* Remove XDP egress */
+	WARN_ON(dev_xdp_install(dev, generic_xdp_install, NULL, 0, NULL,
+				true));
 
 	/* Remove from the driver */
 	ndo_bpf = dev->netdev_ops->ndo_bpf;
@@ -8641,14 +8648,14 @@ static void dev_xdp_uninstall(struct net_device *dev)
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
 }
 
 /**
@@ -8662,7 +8669,7 @@ static void dev_xdp_uninstall(struct net_device *dev)
  *	Set or clear a bpf program for a device
  */
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
-		      int fd, int expected_fd, u32 flags)
+		      int fd, int expected_fd, u32 flags, bool egress)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 	enum bpf_netdev_command query;
@@ -8675,7 +8682,11 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 	ASSERT_RTNL();
 
 	offload = flags & XDP_FLAGS_HW_MODE;
-	query = offload ? XDP_QUERY_PROG_HW : XDP_QUERY_PROG;
+	if (egress)
+		query = XDP_QUERY_PROG_EGRESS;
+	else
+		query = offload ? XDP_QUERY_PROG_HW : XDP_QUERY_PROG;
+
 
 	bpf_op = bpf_chk = ops->ndo_bpf;
 	if (!bpf_op && (flags & (XDP_FLAGS_DRV_MODE | XDP_FLAGS_HW_MODE))) {
@@ -8705,7 +8716,8 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 		}
 	}
 	if (fd >= 0) {
-		if (!offload && __dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG)) {
+		if (!offload && !egress &&
+		    __dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG)) {
 			NL_SET_ERR_MSG(extack, "native and generic XDP can't be active at the same time");
 			return -EEXIST;
 		}
@@ -8737,7 +8749,7 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 		prog = NULL;
 	}
 
-	err = dev_xdp_install(dev, bpf_op, extack, flags, prog);
+	err = dev_xdp_install(dev, bpf_op, extack, flags, prog, egress);
 	if (err < 0 && prog)
 		bpf_prog_put(prog);
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 193da2bb908a..4a3e85413688 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2522,7 +2522,7 @@ static int do_setlink_xdp(struct net_device *dev, struct nlattr *tb,
 
 		err = dev_change_xdp_fd(dev, extack,
 					nla_get_s32(xdp[IFLA_XDP_FD]),
-					expected_fd, xdp_flags);
+					expected_fd, xdp_flags, false);
 		if (err)
 			return err;
 
-- 
2.21.1 (Apple Git-122.3)

