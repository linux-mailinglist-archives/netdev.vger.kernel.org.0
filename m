Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AABA307676
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 13:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbhA1MxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 07:53:19 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10228 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbhA1Mvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 07:51:48 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6012b3240001>; Thu, 28 Jan 2021 04:50:44 -0800
Received: from localhost.localdomain (172.20.145.6) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Jan
 2021 12:50:42 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 11/12] nexthop: Add a callback parameter to rtm_dump_walk_nexthops()
Date:   Thu, 28 Jan 2021 13:49:23 +0100
Message-ID: <8f895fa4bb87f623226aaf681faec62da3ce0432.1611836479.git.petrm@nvidia.com>
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
        t=1611838244; bh=j6Y61xdGAcwfimeVlCpZgvoBFnPbB7UiNfGaIHs/5UY=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Y1RMLk8Cx1S/kgNHkkKOW261dmihhkNyBiM+BbY6gi3C38OpyEqN6xPrk43bxT8Pz
         xAHGBrm+zIkePkdSyy29rP05EG2UAFaGyo1cclwfpZMIIr6WswIisCg3lMZLb8sJOY
         XrZ/4x1TdUs9rK/6GRduA/CKYfNPlilxnA12yu/zyOcPFp9vYZGUFf7F1MPOOoftZg
         6bWN5KltvEKTGNG+RUCjW2JYHbDiCF849D5rPXp0G7J4oGGy1HMKkPIqclX13uDHLx
         D4Bj2ESJyZ/7X67ggz21vv1jwnyKxldoL2S/IiL6HHSJAQeRm+N2Z8JeBtQr1fdFVY
         T9dIbV6SB77bg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to allow different handling for next-hop tree dumper and for
bucket dumper, parameterize the next-hop tree walker with a callback. Add
rtm_dump_nexthop_cb() with just the bits relevant for next-hop tree
dumping.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index e5175f531ffb..9536cf2f6aca 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2083,9 +2083,11 @@ static int rtm_dump_walk_nexthops(struct sk_buff *sk=
b,
 				  struct netlink_callback *cb,
 				  struct rb_root *root,
 				  struct rtm_dump_nh_ctx *ctx,
-				  struct nh_dump_filter *filter)
+				  int (*nh_cb)(struct sk_buff *skb,
+					       struct netlink_callback *cb,
+					       struct nexthop *nh, void *data),
+				  void *data)
 {
-	struct nhmsg *nhm =3D nlmsg_data(cb->nlh);
 	struct rb_node *node;
 	int idx =3D 0, s_idx;
 	int err;
@@ -2098,14 +2100,9 @@ static int rtm_dump_walk_nexthops(struct sk_buff *sk=
b,
 			goto cont;
=20
 		nh =3D rb_entry(node, struct nexthop, rb_node);
-		if (nh_dump_filtered(nh, filter, nhm->nh_family))
-			goto cont;
-
 		ctx->idx =3D idx;
-		err =3D nh_fill_node(skb, nh, RTM_NEWNEXTHOP,
-				   NETLINK_CB(cb->skb).portid,
-				   cb->nlh->nlmsg_seq, NLM_F_MULTI);
-		if (err < 0)
+		err =3D nh_cb(skb, cb, nh, data);
+		if (err)
 			return err;
 cont:
 		idx++;
@@ -2115,6 +2112,20 @@ static int rtm_dump_walk_nexthops(struct sk_buff *sk=
b,
 	return 0;
 }
=20
+static int rtm_dump_nexthop_cb(struct sk_buff *skb, struct netlink_callbac=
k *cb,
+			       struct nexthop *nh, void *data)
+{
+	struct nhmsg *nhm =3D nlmsg_data(cb->nlh);
+	struct nh_dump_filter *filter =3D data;
+
+	if (nh_dump_filtered(nh, filter, nhm->nh_family))
+		return 0;
+
+	return nh_fill_node(skb, nh, RTM_NEWNEXTHOP,
+			    NETLINK_CB(cb->skb).portid,
+			    cb->nlh->nlmsg_seq, NLM_F_MULTI);
+}
+
 /* rtnl */
 static int rtm_dump_nexthop(struct sk_buff *skb, struct netlink_callback *=
cb)
 {
@@ -2128,7 +2139,8 @@ static int rtm_dump_nexthop(struct sk_buff *skb, stru=
ct netlink_callback *cb)
 	if (err < 0)
 		return err;
=20
-	err =3D rtm_dump_walk_nexthops(skb, cb, root, ctx, &filter);
+	err =3D rtm_dump_walk_nexthops(skb, cb, root, ctx,
+				     &rtm_dump_nexthop_cb, &filter);
 	if (err < 0) {
 		if (likely(skb->len))
 			goto out;
--=20
2.26.2

