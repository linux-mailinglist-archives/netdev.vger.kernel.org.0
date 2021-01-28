Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460C530766A
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 13:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhA1Mvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 07:51:39 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10203 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbhA1MvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 07:51:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6012b3100000>; Thu, 28 Jan 2021 04:50:24 -0800
Received: from localhost.localdomain (172.20.145.6) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Jan
 2021 12:50:21 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 04/12] nexthop: Assert the invariant that a NH group is of only one type
Date:   Thu, 28 Jan 2021 13:49:16 +0100
Message-ID: <e73db0a825d62df59f2ba11f5582e5e21711102b.1611836479.git.petrm@nvidia.com>
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
        t=1611838224; bh=ytMwLuN+U91Wdu6V6nXe44wN0pUwWSX2bNh0iJNBcvA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=bLYWB8BJTFuJLeWjTmlq7QcZY3O+muiEM0uy+MmZcKm+6UI4ayHLYpHXf90SDOW8z
         31qSQsqOWNrD9073BwD7W2mGp74G7koW4HM2sEiSlZOsicqrHxXcEmXXdSitqkRBXK
         tW+7Loympv3il6F/a0lNv1mUGjilwR67XeTaqm+b5d37yrrmP44JBQpbXiuj3ajZLp
         CGPYRcKT7sTw809EgpNgn3xygK8VSuXy4MyPka7ckmxUuyTdlX3oi6Yt8W9/k1E2eF
         isKYussohrdR1aKB+n+AXhauwR9XhjPjeIhzLO9ubKrZ4RcfilDjj3I8sv+pgkmV5l
         CfQjuNpIqy2gQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of the code that deals with nexthop groups relies on the fact that the
group is of exactly one well-known type. Currently there is only one type,
"mpath", but as more next-hop group types come, it becomes desirable to
have a central place where the setting is validated. Introduce such place
into nexthop_create_group(), such that the check is done before the code
that relies on that invariant is invoked.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 7a30df5aea75..c09b8231f56a 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1466,10 +1466,13 @@ static struct nexthop *nexthop_create_group(struct =
net *net,
 		nhg->nh_entries[i].nh_parent =3D nh;
 	}
=20
-	if (cfg->nh_grp_type =3D=3D NEXTHOP_GRP_TYPE_MPATH) {
+	if (cfg->nh_grp_type =3D=3D NEXTHOP_GRP_TYPE_MPATH)
 		nhg->mpath =3D 1;
+
+	WARN_ON_ONCE(nhg->mpath !=3D 1);
+
+	if (nhg->mpath)
 		nh_group_rebalance(nhg);
-	}
=20
 	if (cfg->nh_fdb)
 		nhg->fdb_nh =3D 1;
--=20
2.26.2

