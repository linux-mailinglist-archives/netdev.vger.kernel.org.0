Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279BE1BB19C
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgD0Wqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:46:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726378AbgD0Wqp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:46:45 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F030921974;
        Mon, 27 Apr 2020 22:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588027604;
        bh=MIV5Gf4ovOe8mpnafd9volB6feu0H3KJg8e6ERaVn/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YEhIvcsTlbp+6gNLA0Lk3ilFviWqkDhUzxaRKyZleIJ+F2O23ZCxsiWofhF1jdLk/
         mimuyx7uUlnuKDACsgcfHnfjyvKyZxBGpLLwNJmwHN/IfTdJYy0zuo6eFjzWz56hla
         INSghXSWrJWjnDtJ/kXksmjh5F1cdUbbuMOIgvzg=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v4 bpf-next 08/15] net: set XDP egress program on netdevice
Date:   Mon, 27 Apr 2020 16:46:26 -0600
Message-Id: <20200427224633.15627-9-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200427224633.15627-1-dsahern@kernel.org>
References: <20200427224633.15627-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

This patch handles the plumbing for installing an XDP egress
program on a net_device by handling XDP_SETUP_PROG_EGRESS and
XDP_QUERY_PROG_EGRESS in generic_xdp_install handler. New static
key is added to signal when an egress program has been installed.

Update dev_xdp_uninstall to remove egress programs.

Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 48 +++++++++++++++++++++++++++------------
 2 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f4d24d9ea4f9..2b552c29e188 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -752,6 +752,8 @@ struct netdev_rx_queue {
 #endif
 } ____cacheline_aligned_in_smp;
 
+extern struct static_key_false xdp_egress_needed_key;
+
 /*
  * RX queue sysfs structures and functions.
  */
diff --git a/net/core/dev.c b/net/core/dev.c
index 5bbdbc0c0a92..14ce8e25e3d3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4620,6 +4620,7 @@ void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog)
 }
 
 static DEFINE_STATIC_KEY_FALSE(generic_xdp_needed_key);
+DEFINE_STATIC_KEY_FALSE(xdp_egress_needed_key);
 
 int do_xdp_generic_rx(struct bpf_prog *xdp_prog, struct sk_buff *skb)
 {
@@ -5335,12 +5336,12 @@ static void __netif_receive_skb_list(struct list_head *head)
 
 static int generic_xdp_install(struct net_device *dev, struct netdev_bpf *xdp)
 {
-	struct bpf_prog *old = rtnl_dereference(dev->xdp_prog);
-	struct bpf_prog *new = xdp->prog;
+	struct bpf_prog *old, *new = xdp->prog;
 	int ret = 0;
 
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
+		old = rtnl_dereference(dev->xdp_prog);
 		rcu_assign_pointer(dev->xdp_prog, new);
 		if (old)
 			bpf_prog_put(old);
@@ -5353,11 +5354,25 @@ static int generic_xdp_install(struct net_device *dev, struct netdev_bpf *xdp)
 			dev_disable_gro_hw(dev);
 		}
 		break;
+	case XDP_SETUP_PROG_EGRESS:
+		old = rtnl_dereference(dev->xdp_egress_prog);
+		rcu_assign_pointer(dev->xdp_egress_prog, new);
+		if (old)
+			bpf_prog_put(old);
 
+		if (old && !new)
+			static_branch_dec(&xdp_egress_needed_key);
+		else if (new && !old)
+			static_branch_inc(&xdp_egress_needed_key);
+		break;
 	case XDP_QUERY_PROG:
+		old = rtnl_dereference(dev->xdp_prog);
+		xdp->prog_id = old ? old->aux->id : 0;
+		break;
+	case XDP_QUERY_PROG_EGRESS:
+		old = rtnl_dereference(dev->xdp_egress_prog);
 		xdp->prog_id = old ? old->aux->id : 0;
 		break;
-
 	default:
 		ret = -EINVAL;
 		break;
@@ -8640,6 +8655,10 @@ static void dev_xdp_uninstall(struct net_device *dev)
 	/* Remove generic XDP */
 	WARN_ON(dev_xdp_install(dev, generic_xdp_install, NULL, 0, NULL));
 
+	/* Remove XDP egress */
+	WARN_ON(dev_xdp_install(dev, generic_xdp_install, NULL,
+				XDP_FLAGS_EGRESS_MODE, NULL));
+
 	/* Remove from the driver */
 	ndo_bpf = dev->netdev_ops->ndo_bpf;
 	if (!ndo_bpf)
@@ -8686,21 +8705,22 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 
 	offload = flags & XDP_FLAGS_HW_MODE;
 	egress = flags & XDP_FLAGS_EGRESS_MODE;
-	if (egress)
+	if (egress) {
 		query = XDP_QUERY_PROG_EGRESS;
-	else
+		bpf_op = bpf_chk = generic_xdp_install;
+	} else {
 		query = offload ? XDP_QUERY_PROG_HW : XDP_QUERY_PROG;
 
-
-	bpf_op = bpf_chk = ops->ndo_bpf;
-	if (!bpf_op && (flags & (XDP_FLAGS_DRV_MODE | XDP_FLAGS_HW_MODE))) {
-		NL_SET_ERR_MSG(extack, "underlying driver does not support XDP in native mode");
-		return -EOPNOTSUPP;
+		bpf_op = bpf_chk = ops->ndo_bpf;
+		if (!bpf_op && (flags & (XDP_FLAGS_DRV_MODE | XDP_FLAGS_HW_MODE))) {
+			NL_SET_ERR_MSG(extack, "underlying driver does not support XDP in native mode");
+			return -EOPNOTSUPP;
+		}
+		if (!bpf_op || (flags & XDP_FLAGS_SKB_MODE))
+			bpf_op = generic_xdp_install;
+		if (bpf_op == bpf_chk)
+			bpf_chk = generic_xdp_install;
 	}
-	if (!bpf_op || (flags & XDP_FLAGS_SKB_MODE))
-		bpf_op = generic_xdp_install;
-	if (bpf_op == bpf_chk)
-		bpf_chk = generic_xdp_install;
 
 	prog_id = __dev_xdp_query(dev, bpf_op, query);
 	if (flags & XDP_FLAGS_REPLACE) {
-- 
2.21.1 (Apple Git-122.3)

