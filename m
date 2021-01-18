Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF2E2FA291
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 15:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392696AbhAROID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 09:08:03 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17380 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392649AbhAROGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 09:06:52 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600595d40000>; Mon, 18 Jan 2021 06:06:12 -0800
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 18 Jan
 2021 14:06:09 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 1/3] nexthop: Use a dedicated policy for nh_valid_get_del_req()
Date:   Mon, 18 Jan 2021 15:05:23 +0100
Message-ID: <ec93d227609126c98805e52ba3821b71f8bb338d.1610978306.git.petrm@nvidia.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1610978306.git.petrm@nvidia.org>
References: <cover.1610978306.git.petrm@nvidia.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610978772; bh=vIvwPAHHrGskJNAdcvPp2ctCzu+VlPO7uB8yWZfrQqY=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=SXvXQy1IMooG+I04MShd6tfHrWbLrzJ4le3NF5opMW1S879vYcu/ZHjqcC1WLUYzI
         2zsomzN1FRtUMtKjDY7+xUNNG92lZD5bHNIZlxD2nrAmDJPO5DPGdrZecbbJUfvPw1
         4cBCX0Xiyeu8f6IOOMI258VOhnNWBGlAlXUHSd00h5vp/mIFUHOR6Kv4U1+aXuiYHe
         tCBSlk9CgxjFxGOD+cqq5efMyz4iZCaNFuNs37Yu0YxA3fsiEJj35g953IVKbzvthF
         6BzdOnVknlbrqXQ2NjvexcdLLv8DFOPEAh15dUGc27TV1+wqfw7y0G4ID6fY3kVMvE
         A94RFgn9zEqog==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function uses the global nexthop policy only to then bounce all
arguments except for NHA_ID. Instead, just create a new policy that
only includes the one allowed attribute.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index e53e43aef785..d5d88f7c5c11 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -36,6 +36,10 @@ static const struct nla_policy rtm_nh_policy[NHA_MAX + 1=
] =3D {
 	[NHA_FDB]		=3D { .type =3D NLA_FLAG },
 };
=20
+static const struct nla_policy rtm_nh_policy_get[NHA_MAX + 1] =3D {
+	[NHA_ID]		=3D { .type =3D NLA_U32 },
+};
+
 static bool nexthop_notifiers_is_empty(struct net *net)
 {
 	return !net->nexthop.notifier_chain.head;
@@ -1843,27 +1847,14 @@ static int nh_valid_get_del_req(struct nlmsghdr *nl=
h, u32 *id,
 {
 	struct nhmsg *nhm =3D nlmsg_data(nlh);
 	struct nlattr *tb[NHA_MAX + 1];
-	int err, i;
+	int err;
=20
-	err =3D nlmsg_parse(nlh, sizeof(*nhm), tb, NHA_MAX, rtm_nh_policy,
+	err =3D nlmsg_parse(nlh, sizeof(*nhm), tb, NHA_MAX, rtm_nh_policy_get,
 			  extack);
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

