Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF05307669
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 13:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbhA1MvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 07:51:25 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10199 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbhA1MvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 07:51:02 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6012b30d0000>; Thu, 28 Jan 2021 04:50:21 -0800
Received: from localhost.localdomain (172.20.145.6) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Jan
 2021 12:50:19 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 03/12] nexthop: Introduce to struct nh_grp_entry a per-type union
Date:   Thu, 28 Jan 2021 13:49:15 +0100
Message-ID: <96736e8f9767633e73dacd59c0836547824d0ff8.1611836479.git.petrm@nvidia.com>
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
        t=1611838221; bh=Hlr7VD83c12xPjed7e0j4HsacUYtv+gCCon+r9CBSlE=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=DP8gfjDgT0wGMHn21hgpOPK3ja/gQbMYgil4NhLgvpiiZeN6Sl73Wh9pQ6CQDSXM4
         B8xx1bgsUTGOy4Kttam5kWoIU9Wqt2eA7zYUoddDJA/yWCKkZMlX5hBz+FBKv/TBHV
         dLhXBOp7zjSvgiCbJ2d25WudRfdEJw9VuNjvOmfUGdI3w3tTdurX9sObg4Y29g8T9I
         qcv5jnwEnDGZT4buZn4yoO+2vO4yKnmPVMTHT2Kx6so0NGuqAszxtauWnZ0oZJrl81
         ZF5RdR+3NJ5ROr2VdHKnFkyhjKQSDwvNFADneqWxrcDdZu4nGCex/4SL3hKw6lkCAf
         0PBSNCvUH6v/Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The values that a next-hop group needs to keep track of depend on the group
type. Introduce a union to separate fields specific to the mpath groups
from fields specific to other group types.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 include/net/nexthop.h | 7 ++++++-
 net/ipv4/nexthop.c    | 4 ++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 226930d66b63..d0e245b0635d 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -66,7 +66,12 @@ struct nh_info {
 struct nh_grp_entry {
 	struct nexthop	*nh;
 	u8		weight;
-	atomic_t	upper_bound;
+
+	union {
+		struct {
+			atomic_t	upper_bound;
+		} mpath;
+	};
=20
 	struct list_head nh_list;
 	struct nexthop	*nh_parent;  /* nexthop of group with this entry */
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 43bb5f451343..7a30df5aea75 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -689,7 +689,7 @@ static struct nexthop *nexthop_select_path_mp(struct nh=
_group *nhg, int hash)
 		struct nh_grp_entry *nhge =3D &nhg->nh_entries[i];
 		struct nh_info *nhi;
=20
-		if (hash > atomic_read(&nhge->upper_bound))
+		if (hash > atomic_read(&nhge->mpath.upper_bound))
 			continue;
=20
 		nhi =3D rcu_dereference(nhge->nh->nh_info);
@@ -924,7 +924,7 @@ static void nh_group_rebalance(struct nh_group *nhg)
=20
 		w +=3D nhge->weight;
 		upper_bound =3D DIV_ROUND_CLOSEST_ULL((u64)w << 31, total) - 1;
-		atomic_set(&nhge->upper_bound, upper_bound);
+		atomic_set(&nhge->mpath.upper_bound, upper_bound);
 	}
 }
=20
--=20
2.26.2

