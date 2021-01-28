Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307FA307671
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 13:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhA1MwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 07:52:19 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15899 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbhA1MvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 07:51:10 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6012b3160003>; Thu, 28 Jan 2021 04:50:30 -0800
Received: from localhost.localdomain (172.20.145.6) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Jan
 2021 12:50:27 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 06/12] nexthop: Dispatch notifier init()/fini() by group type
Date:   Thu, 28 Jan 2021 13:49:18 +0100
Message-ID: <f10e8da9c6d7fb8be97e25a26b40e2f2fb5470f3.1611836479.git.petrm@nvidia.com>
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
        t=1611838230; bh=9jGJ9NJrYCmCHdZzdQPqjwMACE7wN7WyvLYG/A7Vfx0=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Y06z0jXq+TIrRvJIGxqp5c2k05DvinigHy7rnmcK68xNC4dOk/LbBlYF8l112uUQX
         3my6UXDMmTJG9g2AYpOo/r8eiApNgGV8bCK2nKsOa+Zc9fOWHjYwlFQZa5HfX2mhuv
         OrJRAs7bJdlZRw0otUceLoFuM+dLHNjimNL8Tmm5g+NvIp9hI6yQKzUd3trVnI5SwU
         EgDtJJqe1ChKagCiwQDU86voawE9k+58snCTa48eM64t27EzEu0SfKs+qhlZYrpCrM
         +1SuXKzPa6Tr1inVOR1+z1ye3BiMumXyrnCqz3oHTnCm/b95i59iIOJElXs4ODMduf
         vbrRJyGhJndlA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After there are several next-hop group types, initialization and
finalization of notifier type needs to reflect the actual type. Transform
nh_notifier_grp_info_init() and _fini() to make extending them easier.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 12f812b9538d..7149b12c4703 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -86,10 +86,9 @@ static void nh_notifier_single_info_fini(struct nh_notif=
ier_info *info)
 	kfree(info->nh);
 }
=20
-static int nh_notifier_grp_info_init(struct nh_notifier_info *info,
-				     const struct nexthop *nh)
+static int nh_notifier_mp_info_init(struct nh_notifier_info *info,
+				    struct nh_group *nhg)
 {
-	struct nh_group *nhg =3D rtnl_dereference(nh->nh_grp);
 	u16 num_nh =3D nhg->num_nh;
 	int i;
=20
@@ -114,9 +113,23 @@ static int nh_notifier_grp_info_init(struct nh_notifie=
r_info *info,
 	return 0;
 }
=20
-static void nh_notifier_grp_info_fini(struct nh_notifier_info *info)
+static int nh_notifier_grp_info_init(struct nh_notifier_info *info,
+				     const struct nexthop *nh)
 {
-	kfree(info->nh_grp);
+	struct nh_group *nhg =3D rtnl_dereference(nh->nh_grp);
+
+	if (nhg->mpath)
+		return nh_notifier_mp_info_init(info, nhg);
+	return -EINVAL;
+}
+
+static void nh_notifier_grp_info_fini(struct nh_notifier_info *info,
+				      const struct nexthop *nh)
+{
+	struct nh_group *nhg =3D rtnl_dereference(nh->nh_grp);
+
+	if (nhg->mpath)
+		kfree(info->nh_grp);
 }
=20
 static int nh_notifier_info_init(struct nh_notifier_info *info,
@@ -134,7 +147,7 @@ static void nh_notifier_info_fini(struct nh_notifier_in=
fo *info,
 				  const struct nexthop *nh)
 {
 	if (nh->is_group)
-		nh_notifier_grp_info_fini(info);
+		nh_notifier_grp_info_fini(info, nh);
 	else
 		nh_notifier_single_info_fini(info);
 }
--=20
2.26.2

