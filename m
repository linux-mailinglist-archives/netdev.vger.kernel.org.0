Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551DE1BB197
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgD0Wqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbgD0Wqi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:46:38 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4099520B80;
        Mon, 27 Apr 2020 22:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588027598;
        bh=NcyCtuoaObv57uMN0+uBp4D8b7GDjHcIPUrS7fK49EI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KhoS/MCUFqIwCEHgrujnwXK7PL9GucaBxMbyuoVmfb60fWbW4SuBIn83QsKP5KhFJ
         RFT7AFDT5zWbKYnIU1QdP/UYjlUL+cAGJE2UoXuuMoSLIjCtg9mHNEL6Bk2roLVxKE
         WwoaB2CcvxnkuG1RYBxcSMrgRBbEVrcSIG3972tA=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v4 bpf-next 02/15] net: uapi for XDP programs in the egress path
Date:   Mon, 27 Apr 2020 16:46:20 -0600
Message-Id: <20200427224633.15627-3-dsahern@kernel.org>
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
index 127c704eeba9..4a33ff26ef62 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -975,9 +975,11 @@ enum {
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
 
@@ -988,6 +990,7 @@ enum {
 	XDP_ATTACHED_SKB,
 	XDP_ATTACHED_HW,
 	XDP_ATTACHED_MULTI,
+	XDP_ATTACHED_EGRESS_CORE,
 };
 
 enum {
@@ -1000,6 +1003,7 @@ enum {
 	IFLA_XDP_SKB_PROG_ID,
 	IFLA_XDP_HW_PROG_ID,
 	IFLA_XDP_EXPECTED_FD,
+	IFLA_XDP_EGRESS_PROG_ID,
 	__IFLA_XDP_MAX,
 };
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index d6f4f4a9e8ba..c8f6cc67a070 100644
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
index ca6665ea758a..41b1c5ff4875 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -963,9 +963,11 @@ enum {
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
 
@@ -976,6 +978,7 @@ enum {
 	XDP_ATTACHED_SKB,
 	XDP_ATTACHED_HW,
 	XDP_ATTACHED_MULTI,
+	XDP_ATTACHED_EGRESS_CORE,
 };
 
 enum {
@@ -988,6 +991,7 @@ enum {
 	IFLA_XDP_SKB_PROG_ID,
 	IFLA_XDP_HW_PROG_ID,
 	IFLA_XDP_EXPECTED_FD,
+	IFLA_XDP_EGRESS_PROG_ID,
 	__IFLA_XDP_MAX,
 };
 
-- 
2.21.1 (Apple Git-122.3)

