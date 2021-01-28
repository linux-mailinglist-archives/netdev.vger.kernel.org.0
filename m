Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C110A30766B
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 13:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbhA1Mvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 07:51:48 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15853 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbhA1Mu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 07:50:59 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6012b30a0002>; Thu, 28 Jan 2021 04:50:18 -0800
Received: from localhost.localdomain (172.20.145.6) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Jan
 2021 12:50:16 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 02/12] nexthop: Dispatch nexthop_select_path() by group type
Date:   Thu, 28 Jan 2021 13:49:14 +0100
Message-ID: <5c7bfb40a5aa8beacedefd9144d4e179db516569.1611836479.git.petrm@nvidia.com>
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
        t=1611838218; bh=QXfnuoDy4CKFQzAZ0Uu7LuUQoeOJWSSqW9f1PGYRoRA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=lc+h3/WqwfnzcRreLlkBlN/zqPfFLonX3P6Pxe79KI6uJdtNwqpMJqdnUo5gwUYvw
         f49Lz1RGo+OEUrUPU+euVcSylalGwQ+WYWqu7syWU6csPNK4goOCOBnNok84bRL2T/
         wRYIjHvlDCuRMj4p1OpDGEGn9wabQeZRF7smc8rYJhMXJr4WHJrGItPE6ZZCF9/l5q
         hIz686yvBc79OGUySBhrCnfptolFEbxXEK7YaGVZLsDBaYLEwWEvxFOWFOetG/mWl/
         hfwXQ+YlArPcjZSs359/+r5BsbpZnW5Z9Z8plbiJrsKT5xhAulGCBCdGz/Gu1xuUcW
         D4mHkInBUOesg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The logic for selecting path depends on the next-hop group type. Adapt the
nexthop_select_path() to dispatch according to the group type.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 1deb9e4df1de..43bb5f451343 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -680,16 +680,11 @@ static bool ipv4_good_nh(const struct fib_nh *nh)
 	return !!(state & NUD_VALID);
 }
=20
-struct nexthop *nexthop_select_path(struct nexthop *nh, int hash)
+static struct nexthop *nexthop_select_path_mp(struct nh_group *nhg, int ha=
sh)
 {
 	struct nexthop *rc =3D NULL;
-	struct nh_group *nhg;
 	int i;
=20
-	if (!nh->is_group)
-		return nh;
-
-	nhg =3D rcu_dereference(nh->nh_grp);
 	for (i =3D 0; i < nhg->num_nh; ++i) {
 		struct nh_grp_entry *nhge =3D &nhg->nh_entries[i];
 		struct nh_info *nhi;
@@ -721,6 +716,21 @@ struct nexthop *nexthop_select_path(struct nexthop *nh=
, int hash)
=20
 	return rc;
 }
+
+struct nexthop *nexthop_select_path(struct nexthop *nh, int hash)
+{
+	struct nh_group *nhg;
+
+	if (!nh->is_group)
+		return nh;
+
+	nhg =3D rcu_dereference(nh->nh_grp);
+	if (nhg->mpath)
+		return nexthop_select_path_mp(nhg, hash);
+
+	/* Unreachable. */
+	return NULL;
+}
 EXPORT_SYMBOL_GPL(nexthop_select_path);
=20
 int nexthop_for_each_fib6_nh(struct nexthop *nh,
--=20
2.26.2

