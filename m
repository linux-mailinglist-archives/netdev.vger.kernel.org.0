Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A403140D0
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhBHUqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:46:32 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:16103 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbhBHUoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 15:44:30 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6021a2710000>; Mon, 08 Feb 2021 12:43:29 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb
 2021 20:43:28 +0000
Received: from yaviefel.local (172.20.145.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb 2021
 20:43:25 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [RFC PATCH 02/13] nexthop: __nh_notifier_single_info_init(): Make nh_info an argument
Date:   Mon, 8 Feb 2021 21:42:45 +0100
Message-ID: <40b63a0000dd57478ac108defe59198b64075c61.1612815058.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1612815057.git.petrm@nvidia.com>
References: <cover.1612815057.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612817009; bh=bwZzl9VJc2fL5kN0dfh+NGDqzaxyhgSsrfa3JN87AHY=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Mn0qCxK4uTVd4aTjeUIp3vrEFSdBYNIr5qxCpabe8BypRI3WSO7ikL1Nqc/Iwnqxg
         5LNSjHyat88Lois1RH82ERWtWfmm89XRz3cJUG95uR7Q//gKF6IMbFDy86XIMBVhdV
         0K5qLKWo85E+hlJq6zwnsU3UP74/ro9T4vG2PDnweY4hVxI4HVUlCvu+VkthuwX8t2
         b/57246Qm8APLs31l3QKwm6+5dKKmEgMCrOyJSajCsbxqK88C72r+WloYT1ffsnjw/
         tJnX6FFtwwjVOZL+OikAYAPA/8YF8geEemMVOs+G1XYTqWyYIljxrbldlH9XJZvxOn
         4h1UtnfGScQaw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cited function currently uses rtnl_dereference() to get nh_info from a
handed-in nexthop. However, under the resilient hashing scheme, this
function will not always be called under RTNL, sometimes the mutual
exclusion will be achieved differently. Therefore move the nh_info
extraction from the function to its callers to make it possible to use a
different synchronization guarantee.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 5fc2ddc5d43c..7b687bca0b87 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -52,10 +52,8 @@ static bool nexthop_notifiers_is_empty(struct net *net)
=20
 static void
 __nh_notifier_single_info_init(struct nh_notifier_single_info *nh_info,
-			       const struct nexthop *nh)
+			       const struct nh_info *nhi)
 {
-	struct nh_info *nhi =3D rtnl_dereference(nh->nh_info);
-
 	nh_info->dev =3D nhi->fib_nhc.nhc_dev;
 	nh_info->gw_family =3D nhi->fib_nhc.nhc_gw_family;
 	if (nh_info->gw_family =3D=3D AF_INET)
@@ -71,12 +69,14 @@ __nh_notifier_single_info_init(struct nh_notifier_singl=
e_info *nh_info,
 static int nh_notifier_single_info_init(struct nh_notifier_info *info,
 					const struct nexthop *nh)
 {
+	struct nh_info *nhi =3D rtnl_dereference(nh->nh_info);
+
 	info->type =3D NH_NOTIFIER_INFO_TYPE_SINGLE;
 	info->nh =3D kzalloc(sizeof(*info->nh), GFP_KERNEL);
 	if (!info->nh)
 		return -ENOMEM;
=20
-	__nh_notifier_single_info_init(info->nh, nh);
+	__nh_notifier_single_info_init(info->nh, nhi);
=20
 	return 0;
 }
@@ -103,11 +103,13 @@ static int nh_notifier_mp_info_init(struct nh_notifie=
r_info *info,
=20
 	for (i =3D 0; i < num_nh; i++) {
 		struct nh_grp_entry *nhge =3D &nhg->nh_entries[i];
+		struct nh_info *nhi;
=20
+		nhi =3D rtnl_dereference(nhge->nh->nh_info);
 		info->nh_grp->nh_entries[i].id =3D nhge->nh->id;
 		info->nh_grp->nh_entries[i].weight =3D nhge->weight;
 		__nh_notifier_single_info_init(&info->nh_grp->nh_entries[i].nh,
-					       nhge->nh);
+					       nhi);
 	}
=20
 	return 0;
--=20
2.26.2

