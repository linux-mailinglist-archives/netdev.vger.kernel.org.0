Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57DCB2FA28F
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 15:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404376AbhAROH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 09:07:28 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1517 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392683AbhAROG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 09:06:56 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600595d70000>; Mon, 18 Jan 2021 06:06:15 -0800
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 18 Jan
 2021 14:06:12 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 2/3] nexthop: Use a dedicated policy for nh_valid_dump_req()
Date:   Mon, 18 Jan 2021 15:05:24 +0100
Message-ID: <151e504b32f5005652c64cdde5186ef8f96303e5.1610978306.git.petrm@nvidia.org>
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
        t=1610978775; bh=1Q1LNcF6HzZkYyNOnUrhD/4GH3/QpqUf3smSiOXS4/Y=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=a/PrZmjE/A3/6boPUlmM34Jx5Cx5U/HeECbFQ04WuFRO/r3KXfTuxA2ihkqxvYXuW
         O2RKc3ZG4At7OSGN9XNmDAvVYkTYC9gXhMMt3wYO+Mj6tWsdSzITaihGQpOJHaRvWc
         IiKkyjvM/La2U3AOw6woiSAQLR+TyCaOOWdB/db6TxJ3/Rcheh6lsh3H5cmDh4KCit
         mPvOqqvZt5SRaggeFx+MQpHZgmy5veIY3TUmW8t9IohZXtYorKVZ5b5Ptb68AOjzIu
         IJAsx3/wmTRtKeVYvUlWaUFFpf+sKHU8LXFj4dqAnGMm2rJqep6Erfn4RXEO7OBFR0
         x02ngaT1ApXjg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function uses the global nexthop policy, but only accepts four
particular attributes. Create a new policy that only includes the four
supported attributes, and use it. Convert the loop to a series of ifs.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 57 +++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 31 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index d5d88f7c5c11..226d73cbc468 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -40,6 +40,13 @@ static const struct nla_policy rtm_nh_policy_get[NHA_MAX=
 + 1] =3D {
 	[NHA_ID]		=3D { .type =3D NLA_U32 },
 };
=20
+static const struct nla_policy rtm_nh_policy_dump[NHA_MAX + 1] =3D {
+	[NHA_OIF]		=3D { .type =3D NLA_U32 },
+	[NHA_GROUPS]		=3D { .type =3D NLA_FLAG },
+	[NHA_MASTER]		=3D { .type =3D NLA_U32 },
+	[NHA_FDB]		=3D { .type =3D NLA_FLAG },
+};
+
 static bool nexthop_notifiers_is_empty(struct net *net)
 {
 	return !net->nexthop.notifier_chain.head;
@@ -1984,46 +1991,34 @@ static int nh_valid_dump_req(const struct nlmsghdr =
*nlh, int *dev_idx,
 	struct netlink_ext_ack *extack =3D cb->extack;
 	struct nlattr *tb[NHA_MAX + 1];
 	struct nhmsg *nhm;
-	int err, i;
+	int err;
 	u32 idx;
=20
-	err =3D nlmsg_parse(nlh, sizeof(*nhm), tb, NHA_MAX, rtm_nh_policy,
+	err =3D nlmsg_parse(nlh, sizeof(*nhm), tb, NHA_MAX, rtm_nh_policy_dump,
 			  NULL);
 	if (err < 0)
 		return err;
=20
-	for (i =3D 0; i <=3D NHA_MAX; ++i) {
-		if (!tb[i])
-			continue;
-
-		switch (i) {
-		case NHA_OIF:
-			idx =3D nla_get_u32(tb[i]);
-			if (idx > INT_MAX) {
-				NL_SET_ERR_MSG(extack, "Invalid device index");
-				return -EINVAL;
-			}
-			*dev_idx =3D idx;
-			break;
-		case NHA_MASTER:
-			idx =3D nla_get_u32(tb[i]);
-			if (idx > INT_MAX) {
-				NL_SET_ERR_MSG(extack, "Invalid master device index");
-				return -EINVAL;
-			}
-			*master_idx =3D idx;
-			break;
-		case NHA_GROUPS:
-			*group_filter =3D true;
-			break;
-		case NHA_FDB:
-			*fdb_filter =3D true;
-			break;
-		default:
-			NL_SET_ERR_MSG(extack, "Unsupported attribute in dump request");
+	if (tb[NHA_OIF]) {
+		idx =3D nla_get_u32(tb[NHA_OIF]);
+		if (idx > INT_MAX) {
+			NL_SET_ERR_MSG(extack, "Invalid device index");
+			return -EINVAL;
+		}
+		*dev_idx =3D idx;
+	}
+	if (tb[NHA_MASTER]) {
+		idx =3D nla_get_u32(tb[NHA_MASTER]);
+		if (idx > INT_MAX) {
+			NL_SET_ERR_MSG(extack, "Invalid master device index");
 			return -EINVAL;
 		}
+		*master_idx =3D idx;
 	}
+	if (tb[NHA_GROUPS])
+		*group_filter =3D true;
+	if (tb[NHA_FDB])
+		*fdb_filter =3D true;
=20
 	nhm =3D nlmsg_data(nlh);
 	if (nhm->nh_protocol || nhm->resvd || nhm->nh_scope || nhm->nh_flags) {
--=20
2.26.2

