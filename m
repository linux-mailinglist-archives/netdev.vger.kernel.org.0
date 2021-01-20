Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6595B2FD703
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 18:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbhATRZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 12:25:58 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:12383 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387443AbhATPpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 10:45:31 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60084fed0000>; Wed, 20 Jan 2021 07:44:45 -0800
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 20 Jan
 2021 15:44:42 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next v2 1/3] nexthop: Use a dedicated policy for nh_valid_get_del_req()
Date:   Wed, 20 Jan 2021 16:44:10 +0100
Message-ID: <4b1e5d244476e8c442e1b42ac5e25667f26af30d.1611156111.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1611156111.git.petrm@nvidia.com>
References: <cover.1611156111.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611157485; bh=I5XUrL4je36XXaLb45T+/RD0lJkyxXaLIGGP9HejwpU=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=aHOktaCGF3Tg9jGustAqRwqeezYIupt3G01NUVTgh+1sXspR2PL7BVIzcBlyiP/ml
         HPZjIwR6AHXOYBQtamRVp+8OIWDGhHMpT7KiE08hyo5AACUfHquBimCjn6zn9s7jeB
         MWLJSJgknigYk39En4H/d6h2Y0eGkZlt5lI/292yuKJwo7gbNROHx/fS9rOVbunRKb
         R616dpEldK+KJXYImwgfmmLejCdPaWPCM8gRzEwWBvC5S6kLAt/4M+6cari8a4LRmg
         gRUKaNu7mam9o+8VF1tpvo4Msh1xC3CcQmf9xLwmP6MOfsiAvrffon+3FelZevzZ3k
         r0uPtOecLM2/w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function uses the global nexthop policy only to then bounce all
arguments except for NHA_ID. Instead, just create a new policy that
only includes the one allowed attribute.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---

Notes:
    v2:
    - Do not specify size of the policy array. Use ARRAY_SIZE instead
      of NHA_MAX

 net/ipv4/nexthop.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index e53e43aef785..391079ff1bb5 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -36,6 +36,10 @@ static const struct nla_policy rtm_nh_policy[NHA_MAX + 1=
] =3D {
 	[NHA_FDB]		=3D { .type =3D NLA_FLAG },
 };
=20
+static const struct nla_policy rtm_nh_policy_get[] =3D {
+	[NHA_ID]		=3D { .type =3D NLA_U32 },
+};
+
 static bool nexthop_notifiers_is_empty(struct net *net)
 {
 	return !net->nexthop.notifier_chain.head;
@@ -1842,28 +1846,16 @@ static int nh_valid_get_del_req(struct nlmsghdr *nl=
h, u32 *id,
 				struct netlink_ext_ack *extack)
 {
 	struct nhmsg *nhm =3D nlmsg_data(nlh);
-	struct nlattr *tb[NHA_MAX + 1];
-	int err, i;
+	struct nlattr *tb[ARRAY_SIZE(rtm_nh_policy_get)];
+	int err;
=20
-	err =3D nlmsg_parse(nlh, sizeof(*nhm), tb, NHA_MAX, rtm_nh_policy,
-			  extack);
+	err =3D nlmsg_parse(nlh, sizeof(*nhm), tb,
+			  ARRAY_SIZE(rtm_nh_policy_get) - 1,
+			  rtm_nh_policy_get, extack);
 	if (err < 0)
 		return err;
=20
 	err =3D -EINVAL;
-	for (i =3D 0; i < __NHA_MAX; ++i) {
-		if (!tb[i])
-			continue;
-
-		switch (i) {
-		case NHA_ID:
-			break;
-		default:
-			NL_SET_ERR_MSG_ATTR(extack, tb[i],
-					    "Unexpected attribute in request");
-			goto out;
-		}
-	}
 	if (nhm->nh_protocol || nhm->resvd || nhm->nh_scope || nhm->nh_flags) {
 		NL_SET_ERR_MSG(extack, "Invalid values in header");
 		goto out;
--=20
2.26.2

