Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3E3307675
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 13:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbhA1MxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 07:53:04 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15988 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbhA1Mvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 07:51:45 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6012b31f0001>; Thu, 28 Jan 2021 04:50:39 -0800
Received: from localhost.localdomain (172.20.145.6) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Jan
 2021 12:50:36 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 09/12] nexthop: Strongly-type context of rtm_dump_nexthop()
Date:   Thu, 28 Jan 2021 13:49:21 +0100
Message-ID: <540e18781f82a0f0b0482b10e7180a57369e8388.1611836479.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1611836479.git.petrm@nvidia.com>
References: <cover.1611836479.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL111.nvidia.com (172.20.187.18)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611838239; bh=8EH3BUufPpqWJ26HPs+KEmOTX5a+ROBs6kNxVSRTSpI=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=ir9r7F5m4lGdn7d4LpUlxsIvF1XGITErEGz/zl7qFOuuBZK8PQ69MgTKc8E+le82e
         HAlclJjriArMs+hiNkTbXFNR2qDb8XPDP68KFj1MtkOBMVPSMxq3s5lqTvdXpWZNFj
         G0meejFnEZ59LRv0Ae0Zul0EWFES7e+cNIRbBwgIFHwZa0mu6VmccE21X18F04af+w
         TvusiJ3bIEE61t4wskZ5fdpf2IfvfDD6SLyENa7SpLpyWDu+RLQ+cnFs0rK8zUxAzr
         3ZLpO8M5DkA5YVD2PkcrYtK0j1Ex0orrzc5bJcJDzQ1KqGGVpOGP7LYTBkPKC7Sp78
         ZR6ivR2k4CoCQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dump operations need to keep state from one invocation to another. A
scratch area is dedicated for this purpose in the passed-in argument, cb,
namely via two aliased arrays, struct netlink_callback.args and .ctx.

Dumping of buckets will end up having to iterate over next hops as well,
and it would be nice to be able to reuse the iteration logic with the NH
dumper. The fact that the logic currently relies on fixed index to the
.args array, and the indices would have to be coordinated between the two
dumpers, makes this somewhat awkward.

To make the access patters clearer, introduce a helper struct with a NH
index, and instead of using the .args array directly, use it through this
structure.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 1c4f10fe3b4e..7ae197efa5a9 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2066,9 +2066,23 @@ static int nh_valid_dump_req(const struct nlmsghdr *=
nlh,
 	return __nh_valid_dump_req(nlh, tb, filter, cb->extack);
 }
=20
+struct rtm_dump_nh_ctx {
+	u32 idx;
+};
+
+static struct rtm_dump_nh_ctx *
+rtm_dump_nh_ctx(struct netlink_callback *cb)
+{
+	struct rtm_dump_nh_ctx *ctx =3D (void *)cb->ctx;
+
+	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->ctx));
+	return ctx;
+}
+
 /* rtnl */
 static int rtm_dump_nexthop(struct sk_buff *skb, struct netlink_callback *=
cb)
 {
+	struct rtm_dump_nh_ctx *ctx =3D rtm_dump_nh_ctx(cb);
 	struct nhmsg *nhm =3D nlmsg_data(cb->nlh);
 	struct net *net =3D sock_net(skb->sk);
 	struct rb_root *root =3D &net->nexthop.rb_root;
@@ -2081,7 +2095,7 @@ static int rtm_dump_nexthop(struct sk_buff *skb, stru=
ct netlink_callback *cb)
 	if (err < 0)
 		return err;
=20
-	s_idx =3D cb->args[0];
+	s_idx =3D ctx->idx;
 	for (node =3D rb_first(root); node; node =3D rb_next(node)) {
 		struct nexthop *nh;
=20
@@ -2108,7 +2122,7 @@ static int rtm_dump_nexthop(struct sk_buff *skb, stru=
ct netlink_callback *cb)
 out:
 	err =3D skb->len;
 out_err:
-	cb->args[0] =3D idx;
+	ctx->idx =3D idx;
 	cb->seq =3D net->nexthop.seq;
 	nl_dump_check_consistent(cb, nlmsg_hdr(skb));
=20
--=20
2.26.2

