Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E50911D0478
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 03:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732035AbgEMBqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 21:46:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731910AbgEMBqN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 21:46:13 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E2B223127;
        Wed, 13 May 2020 01:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589334372;
        bh=c7FAwZ008IMM11Xea34xQoPuCX2npLLlhNRter2L0vA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KeQC/ym3+pX1iEK2GHnRy2jvF17eQa7TcbPC6UGKqA/jrM8u/ON6GCb8d76h/gq9u
         cI2A39j8TWYxdhrgbdWZ2FTBz6L5N2ll4iz5QwbZwn1snQoFhB7nf/i9gTS0SZQgz3
         6i7sF4gqPmj3mvLYrmhbu8s2CSRgi7MOZ9o0pL6M=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com, toke@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v5 bpf-next 02/11] net: uapi for XDP programs in the egress path
Date:   Tue, 12 May 2020 19:45:58 -0600
Message-Id: <20200513014607.40418-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200513014607.40418-1-dsahern@kernel.org>
References: <20200513014607.40418-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

Running programs in the egress path, on skbs or xdp_frames, does not
require driver specific resources like Rx path. Accordingly, the
programs can be run in core code, so add xdp_egress_prog to net_device
to hold a reference to an attached program.

For UAPI, add XDP_FLAGS_EGRESS_MODE to specify attach is at egress, add
a new attach flag, XDP_ATTACHED_EGRESS_CORE, for reporting the attach
point at the core, egress level and add IFLA_XDP_EGRESS_PROG_ID
for reporting the program id. Add rtnl_xdp_prog_egress to fill in
link message with egress data.

Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 include/linux/netdevice.h          |  1 +
 include/uapi/linux/if_link.h       |  6 +++++-
 net/core/rtnetlink.c               | 23 +++++++++++++++++++++--
 tools/include/uapi/linux/if_link.h |  6 +++++-
 4 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5a8d40f1ffe2..594c13d4cd00 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1995,6 +1995,7 @@ struct net_device {
 	unsigned int		real_num_rx_queues;
 
 	struct bpf_prog __rcu	*xdp_prog;
+	struct bpf_prog __rcu	*xdp_egress_prog;
 	unsigned long		gro_flush_timeout;
 	int			napi_defer_hard_irqs;
 	rx_handler_func_t __rcu	*rx_handler;
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index a009365ad67b..de32a9e94d74 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -976,9 +976,11 @@ enum {
 #define XDP_FLAGS_DRV_MODE		(1U << 2)
 #define XDP_FLAGS_HW_MODE		(1U << 3)
 #define XDP_FLAGS_REPLACE		(1U << 4)
+#define XDP_FLAGS_EGRESS_MODE		(1U << 5)
 #define XDP_FLAGS_MODES			(XDP_FLAGS_SKB_MODE | \
 					 XDP_FLAGS_DRV_MODE | \
-					 XDP_FLAGS_HW_MODE)
+					 XDP_FLAGS_HW_MODE | \
+					 XDP_FLAGS_EGRESS_MODE)
 #define XDP_FLAGS_MASK			(XDP_FLAGS_UPDATE_IF_NOEXIST | \
 					 XDP_FLAGS_MODES | XDP_FLAGS_REPLACE)
 
@@ -989,6 +991,7 @@ enum {
 	XDP_ATTACHED_SKB,
 	XDP_ATTACHED_HW,
 	XDP_ATTACHED_MULTI,
+	XDP_ATTACHED_EGRESS_CORE,
 };
 
 enum {
@@ -1001,6 +1004,7 @@ enum {
 	IFLA_XDP_SKB_PROG_ID,
 	IFLA_XDP_HW_PROG_ID,
 	IFLA_XDP_EXPECTED_FD,
+	IFLA_XDP_EGRESS_PROG_ID,
 	__IFLA_XDP_MAX,
 };
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 2269199c5891..9084dfebc699 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -982,7 +982,7 @@ static size_t rtnl_xdp_size(void)
 	size_t xdp_size = nla_total_size(0) +	/* nest IFLA_XDP */
 			  nla_total_size(1) +	/* XDP_ATTACHED */
 			  nla_total_size(4) +	/* XDP_PROG_ID (or 1st mode) */
-			  nla_total_size(4);	/* XDP_<mode>_PROG_ID */
+			  nla_total_size(4) * 2; /* XDP_<mode>_PROG_ID */
 
 	return xdp_size;
 }
@@ -1402,6 +1402,18 @@ static int rtnl_fill_link_ifmap(struct sk_buff *skb, struct net_device *dev)
 	return 0;
 }
 
+static u32 rtnl_xdp_prog_egress(struct net_device *dev)
+{
+	const struct bpf_prog *prog;
+
+	ASSERT_RTNL();
+
+	prog = rtnl_dereference(dev->xdp_egress_prog);
+	if (!prog)
+		return 0;
+	return prog->aux->id;
+}
+
 static u32 rtnl_xdp_prog_skb(struct net_device *dev)
 {
 	const struct bpf_prog *generic_xdp_prog;
@@ -1474,6 +1486,12 @@ static int rtnl_xdp_fill(struct sk_buff *skb, struct net_device *dev)
 				  IFLA_XDP_HW_PROG_ID, rtnl_xdp_prog_hw);
 	if (err)
 		goto err_cancel;
+	err = rtnl_xdp_report_one(skb, dev, &prog_id, &mode,
+				  XDP_ATTACHED_EGRESS_CORE,
+				  IFLA_XDP_EGRESS_PROG_ID,
+				  rtnl_xdp_prog_egress);
+	if (err)
+		goto err_cancel;
 
 	err = nla_put_u8(skb, IFLA_XDP_ATTACHED, mode);
 	if (err)
@@ -2790,7 +2808,8 @@ static int do_setlink(const struct sk_buff *skb,
 		if (err < 0)
 			goto errout;
 
-		if (xdp[IFLA_XDP_ATTACHED] || xdp[IFLA_XDP_PROG_ID]) {
+		if (xdp[IFLA_XDP_ATTACHED] || xdp[IFLA_XDP_PROG_ID] ||
+		    xdp[IFLA_XDP_EGRESS_PROG_ID]) {
 			err = -EINVAL;
 			goto errout;
 		}
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index cafedbbfefbe..1d61cb46a77c 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -964,9 +964,11 @@ enum {
 #define XDP_FLAGS_DRV_MODE		(1U << 2)
 #define XDP_FLAGS_HW_MODE		(1U << 3)
 #define XDP_FLAGS_REPLACE		(1U << 4)
+#define XDP_FLAGS_EGRESS_MODE		(1U << 5)
 #define XDP_FLAGS_MODES			(XDP_FLAGS_SKB_MODE | \
 					 XDP_FLAGS_DRV_MODE | \
-					 XDP_FLAGS_HW_MODE)
+					 XDP_FLAGS_HW_MODE | \
+					 XDP_FLAGS_EGRESS_MODE)
 #define XDP_FLAGS_MASK			(XDP_FLAGS_UPDATE_IF_NOEXIST | \
 					 XDP_FLAGS_MODES | XDP_FLAGS_REPLACE)
 
@@ -977,6 +979,7 @@ enum {
 	XDP_ATTACHED_SKB,
 	XDP_ATTACHED_HW,
 	XDP_ATTACHED_MULTI,
+	XDP_ATTACHED_EGRESS_CORE,
 };
 
 enum {
@@ -989,6 +992,7 @@ enum {
 	IFLA_XDP_SKB_PROG_ID,
 	IFLA_XDP_HW_PROG_ID,
 	IFLA_XDP_EXPECTED_FD,
+	IFLA_XDP_EGRESS_PROG_ID,
 	__IFLA_XDP_MAX,
 };
 
-- 
2.21.1 (Apple Git-122.3)

