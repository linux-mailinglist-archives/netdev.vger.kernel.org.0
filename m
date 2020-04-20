Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603841B167E
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 22:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgDTUBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 16:01:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgDTUBI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 16:01:08 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B55FE20857;
        Mon, 20 Apr 2020 20:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587412867;
        bh=uSl2ULXXuP5naexZnw8Jp7+A70HtuloXKaeTluFZAzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FAZ25s9tN9ZtzcUfjnEcrwgrCG7oMXRJArB5jdDjpCIKcxUU1nA2PYiE2AWkrKQ1s
         twXML98i8KWovNJLuPhmMf8U9n6UEdnIhErjlfkGSiTKEGPJduU9vGruNC9nj4Pc5u
         f2tePR8leC9kgjvIVUu3QZo8Py6/1GXxTzYaDXOU=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH bpf-next 09/16] net: set XDP egress program on netdevice
Date:   Mon, 20 Apr 2020 14:00:48 -0600
Message-Id: <20200420200055.49033-10-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200420200055.49033-1-dsahern@kernel.org>
References: <20200420200055.49033-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

This patch adds a way to set tx path XDP program on a net_device
by handling XDP_SETUP_PROG_EGRESS and XDP_QUERY_PROG_EGRESS in
generic_xdp_install handler. New static key is added to signal
when an egress program has been installed.

Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 44 ++++++++++++++++++++++++++-------------
 2 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 2649f2b36858..0c89996a6bec 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -750,6 +750,8 @@ struct netdev_rx_queue {
 #endif
 } ____cacheline_aligned_in_smp;
 
+extern struct static_key_false xdp_egress_needed_key;
+
 /*
  * RX queue sysfs structures and functions.
  */
diff --git a/net/core/dev.c b/net/core/dev.c
index 046455c54b03..6718048c3448 100644
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
@@ -8681,21 +8696,22 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 	ASSERT_RTNL();
 
 	offload = flags & XDP_FLAGS_HW_MODE;
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

