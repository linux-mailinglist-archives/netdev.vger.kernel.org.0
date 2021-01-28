Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C1C307672
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 13:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbhA1Mwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 07:52:35 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10218 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231761AbhA1MvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 07:51:17 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6012b31c0000>; Thu, 28 Jan 2021 04:50:36 -0800
Received: from localhost.localdomain (172.20.145.6) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Jan
 2021 12:50:33 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 08/12] nexthop: Extract a common helper for parsing dump attributes
Date:   Thu, 28 Jan 2021 13:49:20 +0100
Message-ID: <abc4e50cfa17069b15644755da69bf7c1f47855d.1611836479.git.petrm@nvidia.com>
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
        t=1611838236; bh=AffndRR15KqtQXSofIUWjPFT73TCyqYmlIBZii6/WjI=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=WXzK29gOc2yBud+8f4FqcfNCNZFKvBL0oyKLyVkfJQ7EJCRN6KeNO9NEUgt0V7Asa
         Dm/bT4e8Shw3JQLzMYWiO8f8goGJjyPcHMCIvaM6UFSc5JN0rAMPdlSpVc2ccbwVlZ
         imCjs4yKKzLd4mX9ykm2UZKopjsNfQ4CzWjD12PZYOsaeHETsrc83VW8TRC1SoXMlV
         dAey+3SFcIthdtq0k/cOnsCpXwc0rn6y0xVTrP75Qh1Mo+Zx6dJx9qaA0Odwo+Ra7D
         kkSxapu2+N3nz/gcoHIVjSPBxvMNwh4zCKevBkCgnRQ35Uxg4kn3qFUCew4bJZexME
         mrS10jGITrSCg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Requests to dump nexthops have many attributes in common with those that
requests to dump buckets of resilient NH groups will have. However, they
have different policies. To allow reuse of this code, extract a
policy-agnostic wrapper out of nh_valid_dump_req(), and convert this
function into a thin wrapper around it.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index ad48e5d71bf9..1c4f10fe3b4e 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2015,22 +2015,13 @@ static bool nh_dump_filtered(struct nexthop *nh,
 	return false;
 }
=20
-static int nh_valid_dump_req(const struct nlmsghdr *nlh,
-			     struct nh_dump_filter *filter,
-			     struct netlink_callback *cb)
+static int __nh_valid_dump_req(const struct nlmsghdr *nlh, struct nlattr *=
*tb,
+			       struct nh_dump_filter *filter,
+			       struct netlink_ext_ack *extack)
 {
-	struct netlink_ext_ack *extack =3D cb->extack;
-	struct nlattr *tb[ARRAY_SIZE(rtm_nh_policy_dump)];
 	struct nhmsg *nhm;
-	int err;
 	u32 idx;
=20
-	err =3D nlmsg_parse(nlh, sizeof(*nhm), tb,
-			  ARRAY_SIZE(rtm_nh_policy_dump) - 1,
-			  rtm_nh_policy_dump, NULL);
-	if (err < 0)
-		return err;
-
 	if (tb[NHA_OIF]) {
 		idx =3D nla_get_u32(tb[NHA_OIF]);
 		if (idx > INT_MAX) {
@@ -2059,6 +2050,22 @@ static int nh_valid_dump_req(const struct nlmsghdr *=
nlh,
 	return 0;
 }
=20
+static int nh_valid_dump_req(const struct nlmsghdr *nlh,
+			     struct nh_dump_filter *filter,
+			     struct netlink_callback *cb)
+{
+	struct nlattr *tb[ARRAY_SIZE(rtm_nh_policy_dump)];
+	int err;
+
+	err =3D nlmsg_parse(nlh, sizeof(struct nhmsg), tb,
+			  ARRAY_SIZE(rtm_nh_policy_dump) - 1,
+			  rtm_nh_policy_dump, cb->extack);
+	if (err < 0)
+		return err;
+
+	return __nh_valid_dump_req(nlh, tb, filter, cb->extack);
+}
+
 /* rtnl */
 static int rtm_dump_nexthop(struct sk_buff *skb, struct netlink_callback *=
cb)
 {
--=20
2.26.2

