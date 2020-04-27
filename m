Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35F41BB198
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726344AbgD0Wqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726309AbgD0Wqk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:46:40 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EB2D21835;
        Mon, 27 Apr 2020 22:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588027599;
        bh=8b4+XTz2mLq34mnoxFs6xIkw/tB+P66T3si0vrPxh1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iKtMzQ7pfcsJcE7PcC2LJeBua2wMnZi6bV0ZNrlC767Fp6zmFWZ8g2UtgqQcIIbk5
         GIhVU+iXdVO+od/I7GDbmOiJkgTrLcQ+23jaAlCWzwEZ5yTZoT5LdOXZJ++MW1hEsJ
         30PJ+Ow1TkUdjcDek7UR41oGnCYZqi2k9aL1BU8w=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v4 bpf-next 03/15] net: Add XDP setup and query commands for Tx programs
Date:   Mon, 27 Apr 2020 16:46:21 -0600
Message-Id: <20200427224633.15627-4-dsahern@kernel.org>
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

Add new netdev commands, XDP_SETUP_PROG_EGRESS and
XDP_QUERY_PROG_EGRESS, to query and setup egress programs.

Update dev_change_xdp_fd and dev_xdp_install to check for egress mode
via XDP_FLAGS_EGRESS_MODE in the flags. If egress bool is set, then use
XDP_SETUP_PROG_EGRESS in dev_xdp_install and XDP_QUERY_PROG_EGRESS in
dev_change_xdp_fd.

Signed-off-by: David Ahern <dahern@digitalocean.com>
Co-developed-by: Prashant Bhole <prashantbhole.linux@gmail.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 20 +++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 594c13d4cd00..ee0cb73ca18a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -873,8 +873,10 @@ enum bpf_netdev_command {
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
diff --git a/net/core/dev.c b/net/core/dev.c
index afff16849c26..c0455e764f97 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8600,13 +8600,16 @@ static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
 			   struct bpf_prog *prog)
 {
 	bool non_hw = !(flags & XDP_FLAGS_HW_MODE);
+	bool egress = flags & XDP_FLAGS_EGRESS_MODE;
 	struct bpf_prog *prev_prog = NULL;
 	struct netdev_bpf xdp;
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
@@ -8615,7 +8618,7 @@ static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
 	if (flags & XDP_FLAGS_HW_MODE)
 		xdp.command = XDP_SETUP_PROG_HW;
 	else
-		xdp.command = XDP_SETUP_PROG;
+		xdp.command = egress ? XDP_SETUP_PROG_EGRESS : XDP_SETUP_PROG;
 	xdp.extack = extack;
 	xdp.flags = flags;
 	xdp.prog = prog;
@@ -8677,12 +8680,18 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 	bpf_op_t bpf_op, bpf_chk;
 	struct bpf_prog *prog;
 	bool offload;
+	bool egress;
 	int err;
 
 	ASSERT_RTNL();
 
 	offload = flags & XDP_FLAGS_HW_MODE;
-	query = offload ? XDP_QUERY_PROG_HW : XDP_QUERY_PROG;
+	egress = flags & XDP_FLAGS_EGRESS_MODE;
+	if (egress)
+		query = XDP_QUERY_PROG_EGRESS;
+	else
+		query = offload ? XDP_QUERY_PROG_HW : XDP_QUERY_PROG;
+
 
 	bpf_op = bpf_chk = ops->ndo_bpf;
 	if (!bpf_op && (flags & (XDP_FLAGS_DRV_MODE | XDP_FLAGS_HW_MODE))) {
@@ -8712,7 +8721,8 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 		}
 	}
 	if (fd >= 0) {
-		if (!offload && __dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG)) {
+		if (!offload && !egress &&
+		    __dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG)) {
 			NL_SET_ERR_MSG(extack, "native and generic XDP can't be active at the same time");
 			return -EEXIST;
 		}
-- 
2.21.1 (Apple Git-122.3)

