Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A46C1A6B41
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 19:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732710AbgDMRTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 13:19:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732637AbgDMRS1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 13:18:27 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9968E20735;
        Mon, 13 Apr 2020 17:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586798306;
        bh=5+1Xa0FD36K0m/kxFeoFKPENVaCqW9g44NMe5nr88o0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NB6gqwt6knEB6FGZG+ulMu+7pfRjr+G+mvfhI3MNNbCdKxVn5N9hDaQrVZdXGu/LI
         +FdCczAhmEhiFOR3avYbMusY+FX1pJ6uhi+a3XERUxO6MbsMjJi+RH+C2Huh8sfOax
         qzUZn5AsSWnXJP+M6UYYmrg4cM8qxnwt9Xr4wDE4=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH RFC-v5 bpf-next 01/12] net: Add XDP setup and query commands for Tx programs
Date:   Mon, 13 Apr 2020 11:17:50 -0600
Message-Id: <20200413171801.54406-2-dsahern@kernel.org>
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
index 130a668049ab..d0bb9e09660a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -871,8 +871,10 @@ enum bpf_netdev_command {
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
@@ -3777,7 +3779,7 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
-		      int fd, int expected_fd, u32 flags);
+		      int fd, int expected_fd, u32 flags, bool egress);
 u32 __dev_xdp_query(struct net_device *dev, bpf_op_t xdp_op,
 		    enum bpf_netdev_command cmd);
 int xdp_umem_query(struct net_device *dev, u16 queue_id);
diff --git a/net/core/dev.c b/net/core/dev.c
index 3ebfecc7b112..06e0872ecdae 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8589,7 +8589,7 @@ u32 __dev_xdp_query(struct net_device *dev, bpf_op_t bpf_op,
 
 static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
 			   struct netlink_ext_ack *extack, u32 flags,
-			   struct bpf_prog *prog)
+			   struct bpf_prog *prog, bool egress)
 {
 	bool non_hw = !(flags & XDP_FLAGS_HW_MODE);
 	struct bpf_prog *prev_prog = NULL;
@@ -8597,8 +8597,10 @@ static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
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
@@ -8607,7 +8609,7 @@ static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
 	if (flags & XDP_FLAGS_HW_MODE)
 		xdp.command = XDP_SETUP_PROG_HW;
 	else
-		xdp.command = XDP_SETUP_PROG;
+		xdp.command = egress ? XDP_SETUP_PROG_EGRESS : XDP_SETUP_PROG;
 	xdp.extack = extack;
 	xdp.flags = flags;
 	xdp.prog = prog;
@@ -8628,7 +8630,12 @@ static void dev_xdp_uninstall(struct net_device *dev)
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
@@ -8640,14 +8647,14 @@ static void dev_xdp_uninstall(struct net_device *dev)
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
@@ -8661,7 +8668,7 @@ static void dev_xdp_uninstall(struct net_device *dev)
  *	Set or clear a bpf program for a device
  */
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
-		      int fd, int expected_fd, u32 flags)
+		      int fd, int expected_fd, u32 flags, bool egress)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 	enum bpf_netdev_command query;
@@ -8674,7 +8681,11 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
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
@@ -8704,7 +8715,8 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 		}
 	}
 	if (fd >= 0) {
-		if (!offload && __dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG)) {
+		if (!offload && !egress &&
+		    __dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG)) {
 			NL_SET_ERR_MSG(extack, "native and generic XDP can't be active at the same time");
 			return -EEXIST;
 		}
@@ -8736,7 +8748,7 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 		prog = NULL;
 	}
 
-	err = dev_xdp_install(dev, bpf_op, extack, flags, prog);
+	err = dev_xdp_install(dev, bpf_op, extack, flags, prog, egress);
 	if (err < 0 && prog)
 		bpf_prog_put(prog);
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 97e47c292333..dc44af16226a 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2515,7 +2515,7 @@ static int do_setlink_xdp(struct net_device *dev, struct nlattr *tb,
 
 		err = dev_change_xdp_fd(dev, extack,
 					nla_get_s32(xdp[IFLA_XDP_FD]),
-					expected_fd, xdp_flags);
+					expected_fd, xdp_flags, false);
 		if (err)
 			return err;
 
-- 
2.21.1 (Apple Git-122.3)

