Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50851B1679
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 22:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgDTUBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 16:01:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgDTUBA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 16:01:00 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4389920BED;
        Mon, 20 Apr 2020 20:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587412860;
        bh=a65bRsd48CG8Lbp1BubHx7XYJUmVV6BsKJ8Z6GL8x8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PPOv2nlQWoZjaSMBuHvX77qStw3eDbXoV6qmGyUTvr7Sv8R1O68kOo0UjH+tX2k/e
         npa+ohqY7GVstW3UzNKqUR/O02v3f+A+1OFQvPn0Nk/d6TdFIqqEevjd1LD4tbAIJA
         Abr7hL9bxX/NY7D46A5Avcal0cbL/NiO5Bmyxe00=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH bpf-next 02/16] net: Move handling of IFLA_XDP attribute out of do_setlink
Date:   Mon, 20 Apr 2020 14:00:41 -0600
Message-Id: <20200420200055.49033-3-dsahern@kernel.org>
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

Later patch re-uses XDP attributes. Move processing of IFLA_XDP
to a helper. Code move only; no functional change intended.

Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 net/core/rtnetlink.c | 94 +++++++++++++++++++++++---------------------
 1 file changed, 49 insertions(+), 45 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 709ebbf8ab5b..97e47c292333 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2480,6 +2480,53 @@ static int do_set_master(struct net_device *dev, int ifindex,
 #define DO_SETLINK_MODIFIED	0x01
 /* notify flag means notify + modified. */
 #define DO_SETLINK_NOTIFY	0x03
+
+static int do_setlink_xdp(struct net_device *dev, struct nlattr *tb,
+			  int *status, struct netlink_ext_ack *extack)
+{
+	struct nlattr *xdp[IFLA_XDP_MAX + 1];
+	u32 xdp_flags = 0;
+	int err;
+
+	err = nla_parse_nested_deprecated(xdp, IFLA_XDP_MAX, tb,
+					  ifla_xdp_policy, NULL);
+	if (err < 0)
+		return err;
+
+	if (xdp[IFLA_XDP_ATTACHED] || xdp[IFLA_XDP_PROG_ID])
+		goto out_einval;
+
+	if (xdp[IFLA_XDP_FLAGS]) {
+		xdp_flags = nla_get_u32(xdp[IFLA_XDP_FLAGS]);
+		if (xdp_flags & ~XDP_FLAGS_MASK)
+			goto out_einval;
+		if (hweight32(xdp_flags & XDP_FLAGS_MODES) > 1)
+			goto out_einval;
+	}
+
+	if (xdp[IFLA_XDP_FD]) {
+		int expected_fd = -1;
+
+		if (xdp_flags & XDP_FLAGS_REPLACE) {
+			if (!xdp[IFLA_XDP_EXPECTED_FD])
+				goto out_einval;
+			expected_fd = nla_get_s32(xdp[IFLA_XDP_EXPECTED_FD]);
+		}
+
+		err = dev_change_xdp_fd(dev, extack,
+					nla_get_s32(xdp[IFLA_XDP_FD]),
+					expected_fd, xdp_flags);
+		if (err)
+			return err;
+
+		*status |= DO_SETLINK_NOTIFY;
+	}
+
+	return 0;
+out_einval:
+	return -EINVAL;
+}
+
 static int do_setlink(const struct sk_buff *skb,
 		      struct net_device *dev, struct ifinfomsg *ifm,
 		      struct netlink_ext_ack *extack,
@@ -2774,52 +2821,9 @@ static int do_setlink(const struct sk_buff *skb,
 	}
 
 	if (tb[IFLA_XDP]) {
-		struct nlattr *xdp[IFLA_XDP_MAX + 1];
-		u32 xdp_flags = 0;
-
-		err = nla_parse_nested_deprecated(xdp, IFLA_XDP_MAX,
-						  tb[IFLA_XDP],
-						  ifla_xdp_policy, NULL);
-		if (err < 0)
-			goto errout;
-
-		if (xdp[IFLA_XDP_ATTACHED] || xdp[IFLA_XDP_PROG_ID]) {
-			err = -EINVAL;
+		err = do_setlink_xdp(dev, tb[IFLA_XDP], &status, extack);
+		if (err)
 			goto errout;
-		}
-
-		if (xdp[IFLA_XDP_FLAGS]) {
-			xdp_flags = nla_get_u32(xdp[IFLA_XDP_FLAGS]);
-			if (xdp_flags & ~XDP_FLAGS_MASK) {
-				err = -EINVAL;
-				goto errout;
-			}
-			if (hweight32(xdp_flags & XDP_FLAGS_MODES) > 1) {
-				err = -EINVAL;
-				goto errout;
-			}
-		}
-
-		if (xdp[IFLA_XDP_FD]) {
-			int expected_fd = -1;
-
-			if (xdp_flags & XDP_FLAGS_REPLACE) {
-				if (!xdp[IFLA_XDP_EXPECTED_FD]) {
-					err = -EINVAL;
-					goto errout;
-				}
-				expected_fd =
-					nla_get_s32(xdp[IFLA_XDP_EXPECTED_FD]);
-			}
-
-			err = dev_change_xdp_fd(dev, extack,
-						nla_get_s32(xdp[IFLA_XDP_FD]),
-						expected_fd,
-						xdp_flags);
-			if (err)
-				goto errout;
-			status |= DO_SETLINK_NOTIFY;
-		}
 	}
 
 errout:
-- 
2.21.1 (Apple Git-122.3)

