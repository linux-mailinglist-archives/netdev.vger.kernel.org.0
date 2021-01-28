Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D183307673
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 13:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbhA1Mws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 07:52:48 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:4126 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbhA1MvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 07:51:22 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6012b3210002>; Thu, 28 Jan 2021 04:50:41 -0800
Received: from localhost.localdomain (172.20.145.6) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Jan
 2021 12:50:39 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 10/12] nexthop: Extract a helper for walking the next-hop tree
Date:   Thu, 28 Jan 2021 13:49:22 +0100
Message-ID: <2537ad1b469601766024e2eb66c135ee2e82e8d0.1611836479.git.petrm@nvidia.com>
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
        t=1611838242; bh=hVBSeUUH/0E70ID0YkRhLTSPOsjMsO3zoElGixA3Coo=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=sNh3FSSPrvIihl3ZuPP/BIAt2FGqrEWHdhmzjkSSzTJZs1Vr/Ehdk25KLe5TmaG4q
         9+euKh1eQvZAyX0cUqnzhfOHoqV+0JFxhcSYA1+takOKRatVRS1FEnfRTPXhQLXumy
         gaX2RAZ/ButBsVcxTzzDNQySqQExcZQcCg3jWHZYDqAw/F1o5vYpkUgXD8//SRxQx8
         NDhStHJFfAV3zfkHPVmbUcToszkRZG2EOLV52hQJv+s16/QbPwb8NP56jSTb4YfUkA
         d6QPWv1bjLOVYmIfvDq6HZ7Ptmw+9Slz6hiqINV6Byb44yRXfEWC0l+GXFOrziMvHs
         tG+fpPjWGVtOQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract from rtm_dump_nexthop() a helper to walk the next hop tree. A
separate function for this will be reusable from the bucket dumper.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 52 +++++++++++++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 19 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 7ae197efa5a9..e5175f531ffb 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2079,22 +2079,17 @@ rtm_dump_nh_ctx(struct netlink_callback *cb)
 	return ctx;
 }
=20
-/* rtnl */
-static int rtm_dump_nexthop(struct sk_buff *skb, struct netlink_callback *=
cb)
+static int rtm_dump_walk_nexthops(struct sk_buff *skb,
+				  struct netlink_callback *cb,
+				  struct rb_root *root,
+				  struct rtm_dump_nh_ctx *ctx,
+				  struct nh_dump_filter *filter)
 {
-	struct rtm_dump_nh_ctx *ctx =3D rtm_dump_nh_ctx(cb);
 	struct nhmsg *nhm =3D nlmsg_data(cb->nlh);
-	struct net *net =3D sock_net(skb->sk);
-	struct rb_root *root =3D &net->nexthop.rb_root;
-	struct nh_dump_filter filter =3D {};
 	struct rb_node *node;
 	int idx =3D 0, s_idx;
 	int err;
=20
-	err =3D nh_valid_dump_req(cb->nlh, &filter, cb);
-	if (err < 0)
-		return err;
-
 	s_idx =3D ctx->idx;
 	for (node =3D rb_first(root); node; node =3D rb_next(node)) {
 		struct nexthop *nh;
@@ -2103,29 +2098,48 @@ static int rtm_dump_nexthop(struct sk_buff *skb, st=
ruct netlink_callback *cb)
 			goto cont;
=20
 		nh =3D rb_entry(node, struct nexthop, rb_node);
-		if (nh_dump_filtered(nh, &filter, nhm->nh_family))
+		if (nh_dump_filtered(nh, filter, nhm->nh_family))
 			goto cont;
=20
+		ctx->idx =3D idx;
 		err =3D nh_fill_node(skb, nh, RTM_NEWNEXTHOP,
 				   NETLINK_CB(cb->skb).portid,
 				   cb->nlh->nlmsg_seq, NLM_F_MULTI);
-		if (err < 0) {
-			if (likely(skb->len))
-				goto out;
-
-			goto out_err;
-		}
+		if (err < 0)
+			return err;
 cont:
 		idx++;
 	}
=20
+	ctx->idx =3D idx;
+	return 0;
+}
+
+/* rtnl */
+static int rtm_dump_nexthop(struct sk_buff *skb, struct netlink_callback *=
cb)
+{
+	struct rtm_dump_nh_ctx *ctx =3D rtm_dump_nh_ctx(cb);
+	struct net *net =3D sock_net(skb->sk);
+	struct rb_root *root =3D &net->nexthop.rb_root;
+	struct nh_dump_filter filter =3D {};
+	int err;
+
+	err =3D nh_valid_dump_req(cb->nlh, &filter, cb);
+	if (err < 0)
+		return err;
+
+	err =3D rtm_dump_walk_nexthops(skb, cb, root, ctx, &filter);
+	if (err < 0) {
+		if (likely(skb->len))
+			goto out;
+		goto out_err;
+	}
+
 out:
 	err =3D skb->len;
 out_err:
-	ctx->idx =3D idx;
 	cb->seq =3D net->nexthop.seq;
 	nl_dump_check_consistent(cb, nlmsg_hdr(skb));
-
 	return err;
 }
=20
--=20
2.26.2

