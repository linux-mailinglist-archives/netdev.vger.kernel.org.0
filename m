Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D66D14607C
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 02:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgAWBmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 20:42:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:59496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgAWBmS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 20:42:18 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DBE22467B;
        Thu, 23 Jan 2020 01:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579743737;
        bh=znLBSqw9+cSX6XcPP1MvcJsyIPN/8tqNnU7L+Poj94Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bTGqLKoXqQVlAqix7U/VDR7gcLygMXK2aLB0eGN0xL+gKIuYBUk058rp2wf7pr2VI
         dfXE2gIsRsDH/OHkeVwxk8mVVWyDWCKT051HggBfNVi+9Iap4ujmRrSsvfHDAwtBwi
         50wbt0cZoj1IVE5w9QQy8mqbbxZk8SuOUOJRaATs=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        jbrouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH bpf-next 01/12] net: Add new XDP setup and query commands
Date:   Wed, 22 Jan 2020 18:41:59 -0700
Message-Id: <20200123014210.38412-2-dsahern@kernel.org>
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

Add new netdev commands, XDP_SETUP_PROG_EGRESS and
XDP_QUERY_PROG_EGRESS.

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
 net/core/dev.c            | 30 +++++++++++++++++++++---------
 net/core/rtnetlink.c      |  2 +-
 3 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5ec3537fbdb1..e9cc326086f4 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -865,8 +865,10 @@ enum bpf_netdev_command {
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
@@ -3729,7 +3731,7 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
-		      int fd, u32 flags);
+		      int fd, u32 flags, bool egress);
 u32 __dev_xdp_query(struct net_device *dev, bpf_op_t xdp_op,
 		    enum bpf_netdev_command cmd);
 int xdp_umem_query(struct net_device *dev, u16 queue_id);
diff --git a/net/core/dev.c b/net/core/dev.c
index e7802a41ae7f..04cbcc930bc2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8538,7 +8538,7 @@ u32 __dev_xdp_query(struct net_device *dev, bpf_op_t bpf_op,
 
 static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
 			   struct netlink_ext_ack *extack, u32 flags,
-			   struct bpf_prog *prog)
+			   struct bpf_prog *prog, bool egress)
 {
 	bool non_hw = !(flags & XDP_FLAGS_HW_MODE);
 	struct bpf_prog *prev_prog = NULL;
@@ -8556,7 +8556,7 @@ static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
 	if (flags & XDP_FLAGS_HW_MODE)
 		xdp.command = XDP_SETUP_PROG_HW;
 	else
-		xdp.command = XDP_SETUP_PROG;
+		xdp.command = egress ? XDP_SETUP_PROG_EGRESS : XDP_SETUP_PROG;
 	xdp.extack = extack;
 	xdp.flags = flags;
 	xdp.prog = prog;
@@ -8577,7 +8577,8 @@ static void dev_xdp_uninstall(struct net_device *dev)
 	bpf_op_t ndo_bpf;
 
 	/* Remove generic XDP */
-	WARN_ON(dev_xdp_install(dev, generic_xdp_install, NULL, 0, NULL));
+	WARN_ON(dev_xdp_install(dev, generic_xdp_install, NULL, 0, NULL,
+				false));
 
 	/* Remove from the driver */
 	ndo_bpf = dev->netdev_ops->ndo_bpf;
@@ -8589,14 +8590,20 @@ static void dev_xdp_uninstall(struct net_device *dev)
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
+	/* Remove egress program */
+	memset(&xdp, 0, sizeof(xdp));
+	xdp.command = XDP_QUERY_PROG_EGRESS;
+	if (!ndo_bpf(dev, &xdp) && xdp.prog_id)
+		WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flags,
+					NULL, true));
 }
 
 /**
@@ -8609,7 +8616,7 @@ static void dev_xdp_uninstall(struct net_device *dev)
  *	Set or clear a bpf program for a device
  */
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
-		      int fd, u32 flags)
+		      int fd, u32 flags, bool egress)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 	enum bpf_netdev_command query;
@@ -8621,7 +8628,11 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
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
@@ -8636,7 +8647,8 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 	if (fd >= 0) {
 		u32 prog_id;
 
-		if (!offload && __dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG)) {
+		if (!offload && !egress &&
+		    __dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG)) {
 			NL_SET_ERR_MSG(extack, "native and generic XDP can't be active at the same time");
 			return -EEXIST;
 		}
@@ -8668,7 +8680,7 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 			return 0;
 	}
 
-	err = dev_xdp_install(dev, bpf_op, extack, flags, prog);
+	err = dev_xdp_install(dev, bpf_op, extack, flags, prog, egress);
 	if (err < 0 && prog)
 		bpf_prog_put(prog);
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 20bc406f3871..ed0c069ef187 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2801,7 +2801,7 @@ static int do_setlink(const struct sk_buff *skb,
 		if (xdp[IFLA_XDP_FD]) {
 			err = dev_change_xdp_fd(dev, extack,
 						nla_get_s32(xdp[IFLA_XDP_FD]),
-						xdp_flags);
+						xdp_flags, false);
 			if (err)
 				goto errout;
 			status |= DO_SETLINK_NOTIFY;
-- 
2.21.1 (Apple Git-122.3)

