Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B989307677
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 13:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbhA1Mxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 07:53:52 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10229 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbhA1Mv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 07:51:57 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6012b3270000>; Thu, 28 Jan 2021 04:50:47 -0800
Received: from localhost.localdomain (172.20.145.6) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Jan
 2021 12:50:45 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 12/12] nexthop: Extract a helper for validation of get/del RTNL requests
Date:   Thu, 28 Jan 2021 13:49:24 +0100
Message-ID: <69b7beb0f8ae239762f08b8385fe74640f3b3f64.1611836479.git.petrm@nvidia.com>
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
        t=1611838247; bh=xrdRKAldmEvAszH3e90YvRse9CsRUM5RiftNqnvflQw=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=fuQtOjbLKBuOSCyy5VKNdQ/xjeGnKmNY+RZCBZVCtSdsJqcjHnk3jx44szlsO8Yws
         XmBD74xLu9XTmBe1ZvoCLyVhpIsGosQz5Q+/0hC+LeTlT808JrRbrqr2mhdRZ2kdbv
         VFReyKVIzs+ivUCYWtNLLkWwkZaHKVShAcbX/rUc9KlucEXe9FYLWZ/jUyejCcEopI
         SGs6mdgkuol44qlwk22A2271/0Wk1svd0fege+vD5F26HUFRyHoBTcCx6Qym2ZcpJH
         hKULQXZVQ/PQWn3tQLBU5y7ieBM6JPfUHbfylvwoG412l6ucxXhUg2M4s5kSDhGpx5
         Jl+yX0fgQ1xTA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Validation of messages for get / del of a next hop is the same as will be
validation of messages for get of a resilient next hop group bucket. The
difference is that policy for resilient next hop group buckets is a
superset of that used for next-hop get.

It is therefore possible to reuse the code that validates the nhmsg fields,
extracts the next-hop ID, and validates that. To that end, extract from
nh_valid_get_del_req() a helper __nh_valid_get_del_req() that does just
that.

Make the nlh argument const so that the function can be called from the
dump context, which only has a const nlh. Propagate the constness to
nh_valid_get_del_req().

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 43 +++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 9536cf2f6aca..f1c6cbdb9e43 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1872,37 +1872,44 @@ static int rtm_new_nexthop(struct sk_buff *skb, str=
uct nlmsghdr *nlh,
 	return err;
 }
=20
-static int nh_valid_get_del_req(struct nlmsghdr *nlh, u32 *id,
-				struct netlink_ext_ack *extack)
+static int __nh_valid_get_del_req(const struct nlmsghdr *nlh,
+				  struct nlattr **tb, u32 *id,
+				  struct netlink_ext_ack *extack)
 {
 	struct nhmsg *nhm =3D nlmsg_data(nlh);
-	struct nlattr *tb[ARRAY_SIZE(rtm_nh_policy_get)];
-	int err;
-
-	err =3D nlmsg_parse(nlh, sizeof(*nhm), tb,
-			  ARRAY_SIZE(rtm_nh_policy_get) - 1,
-			  rtm_nh_policy_get, extack);
-	if (err < 0)
-		return err;
=20
-	err =3D -EINVAL;
 	if (nhm->nh_protocol || nhm->resvd || nhm->nh_scope || nhm->nh_flags) {
 		NL_SET_ERR_MSG(extack, "Invalid values in header");
-		goto out;
+		return -EINVAL;
 	}
=20
 	if (!tb[NHA_ID]) {
 		NL_SET_ERR_MSG(extack, "Nexthop id is missing");
-		goto out;
+		return -EINVAL;
 	}
=20
 	*id =3D nla_get_u32(tb[NHA_ID]);
-	if (!(*id))
+	if (!(*id)) {
 		NL_SET_ERR_MSG(extack, "Invalid nexthop id");
-	else
-		err =3D 0;
-out:
-	return err;
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int nh_valid_get_del_req(const struct nlmsghdr *nlh, u32 *id,
+				struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[ARRAY_SIZE(rtm_nh_policy_get)];
+	int err;
+
+	err =3D nlmsg_parse(nlh, sizeof(struct nhmsg), tb,
+			  ARRAY_SIZE(rtm_nh_policy_get) - 1,
+			  rtm_nh_policy_get, extack);
+	if (err < 0)
+		return err;
+
+	return __nh_valid_get_del_req(nlh, tb, id, extack);
 }
=20
 /* rtnl */
--=20
2.26.2

