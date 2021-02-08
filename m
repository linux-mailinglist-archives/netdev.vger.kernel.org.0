Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19893140C7
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 21:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbhBHUo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 15:44:56 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13252 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbhBHUoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 15:44:20 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6021a26d0002>; Mon, 08 Feb 2021 12:43:25 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb
 2021 20:43:25 +0000
Received: from yaviefel.local (172.20.145.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb 2021
 20:43:22 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [RFC PATCH 01/13] nexthop: Pass nh_config to replace_nexthop()
Date:   Mon, 8 Feb 2021 21:42:44 +0100
Message-ID: <1470688a68d2ebe86243560e8aee2e7fa264506b.1612815058.git.petrm@nvidia.com>
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
        t=1612817005; bh=HHaIK+B3EWmPAEgiIBnZqANzE6bw/MWflTHTsXsOUcI=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=gLY26mrAbpsnntdfjHNQlbETxx5+7yaTCjXSMRh6sLPSYVLlrr1lWv245wyRT0fmo
         4fSz9H4U+qWbwf+eUQ7UOBE+w2OUJo+IlLsZfrFdeD853jwi0XwRJXhdWoDhNJX9vA
         GaT9eSKdoAKwZhmk17Y+D0WYH6jmN/WhLWkTO4uhVrUOglE0czyh5POJk9Q9yMpU8R
         ENg58AKx2FTCtlwr89IW6MFOYXEnaIqurs8wq1BAEkl08cmrBIHqNA6jgS/jMc1me+
         O+qRf8rWmiEKote+zTLaRZrkPIdTdjZNURvwUnBOZbUwve2L9Y198f40VLtwWeBfKn
         onh0RwlQEUd6A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, replace assumes that the new group that is given is a
fully-formed object. But mpath groups really only have one attribute, and
that is the constituent next hop configuration. This may not be universally
true. From the usability perspective, it is desirable to allow the replace
operation to adjust just the constituent next hop configuration and leave
the group attributes as such intact.

But the object that keeps track of whether an attribute was or was not
given is the nh_config object, not the next hop or next-hop group. To allow
(selective) attribute updates during NH group replacement, propagate `cfg'
to replace_nexthop() and further to replace_nexthop_grp().

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index f1c6cbdb9e43..5fc2ddc5d43c 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1107,7 +1107,7 @@ static void nh_rt_cache_flush(struct net *net, struct=
 nexthop *nh)
 }
=20
 static int replace_nexthop_grp(struct net *net, struct nexthop *old,
-			       struct nexthop *new,
+			       struct nexthop *new, const struct nh_config *cfg,
 			       struct netlink_ext_ack *extack)
 {
 	struct nh_group *oldg, *newg;
@@ -1276,7 +1276,8 @@ static void nexthop_replace_notify(struct net *net, s=
truct nexthop *nh,
 }
=20
 static int replace_nexthop(struct net *net, struct nexthop *old,
-			   struct nexthop *new, struct netlink_ext_ack *extack)
+			   struct nexthop *new, const struct nh_config *cfg,
+			   struct netlink_ext_ack *extack)
 {
 	bool new_is_reject =3D false;
 	struct nh_grp_entry *nhge;
@@ -1319,7 +1320,7 @@ static int replace_nexthop(struct net *net, struct ne=
xthop *old,
 	}
=20
 	if (old->is_group)
-		err =3D replace_nexthop_grp(net, old, new, extack);
+		err =3D replace_nexthop_grp(net, old, new, cfg, extack);
 	else
 		err =3D replace_nexthop_single(net, old, new, extack);
=20
@@ -1361,7 +1362,7 @@ static int insert_nexthop(struct net *net, struct nex=
thop *new_nh,
 		} else if (new_id > nh->id) {
 			pp =3D &next->rb_right;
 		} else if (replace) {
-			rc =3D replace_nexthop(net, nh, new_nh, extack);
+			rc =3D replace_nexthop(net, nh, new_nh, cfg, extack);
 			if (!rc) {
 				new_nh =3D nh; /* send notification with old nh */
 				replace_notify =3D 1;
--=20
2.26.2

