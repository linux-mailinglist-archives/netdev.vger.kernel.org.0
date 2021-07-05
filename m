Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25BB3BB617
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 06:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhGEEMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 00:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhGEEMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 00:12:13 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA75C061762
        for <netdev@vger.kernel.org>; Sun,  4 Jul 2021 21:09:37 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id B1ECF891B0;
        Mon,  5 Jul 2021 16:09:35 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1625458175;
        bh=bQ7C3I7eM6+Jn2WB0+WTXw7OPktAfKhWTZ5Y+gDOhYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=B7FoLa6kFI2LRvWih4NnP0egoR9fjfbvPeliGUMDWpgErckZBtle4WA7JEkMW2+CP
         0wJQsms/iZjbgrRlBXSjz2grp5yvb77J3CMs+k5+aH4hFJM1oR8DZr4k5k5zTfdmfD
         ojSXXE/WblT1F0S7Lw3nE+p075D1OyjsoEym2Gl0rqFxE6vVqXvyKP/vI6gLmyzs0E
         Jm2LHe+yLRCq390M3hdye0jbUzdU2zQ5w8fayEU9Dv4sa+g0GiqR2zRMHNMqgf+SZD
         34PAkKweC6grcyeIP3A7TGEsqAOc3dkwevl2o3DhZHLfV3hefGuqwUumXe05Tbc1DT
         gjMw24PNZsqMQ==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B60e285ff0000>; Mon, 05 Jul 2021 16:09:35 +1200
Received: from coled-dl.ws.atlnz.lc (coled-dl.ws.atlnz.lc [10.33.25.26])
        by pat.atlnz.lc (Postfix) with ESMTP id 324F413EE8E;
        Mon,  5 Jul 2021 16:09:35 +1200 (NZST)
Received: by coled-dl.ws.atlnz.lc (Postfix, from userid 1801)
        id 2E8C3240C05; Mon,  5 Jul 2021 16:09:35 +1200 (NZST)
From:   Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
To:     pablo@netfilter.org
Cc:     Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>,
        Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>,
        Scott Parlane <scott.parlane@alliedtelesis.co.nz>,
        Blair Steven <blair.steven@alliedtelesis.co.nz>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: netfilter: Add RFC-7597 Section 5.1 PSID support
Date:   Mon,  5 Jul 2021 16:08:55 +1200
Message-Id: <20210705040856.25191-3-Cole.Dishington@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210705040856.25191-1-Cole.Dishington@alliedtelesis.co.nz>
References: <20210630142049.GC18022@breakpoint.cc>
 <20210705040856.25191-1-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=IOh89TnG c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=e_q4qTt1xDgA:10 a=xOT0nC9th1TpZTiSAT0A:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds support for masquerading into a smaller subset of ports -
defined by the PSID values from RFC-7597 Section 5.1. This is part of
the support for MAP-E and Lightweight 4over6, which allows multiple
devices to share an IPv4 address by splitting the L4 port / id into
ranges.

Co-developed-by: Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>
Signed-off-by: Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>
Co-developed-by: Scott Parlane <scott.parlane@alliedtelesis.co.nz>
Signed-off-by: Scott Parlane <scott.parlane@alliedtelesis.co.nz>
Signed-off-by: Blair Steven <blair.steven@alliedtelesis.co.nz>
Signed-off-by: Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
---

Notes:
    Changes in v3:
    - Select pseudo random port range (for a given psid) to search in
    nf_nat_l4proto_unique_tuple(), rather than exhausive search of all
    port ranges (for a given psid).
    - Remove extra check in get_unique_tuple for psid, it is not needed
    if NF_NAT_RANGE_PROTO_SPECIFIED is set.

 net/netfilter/nf_nat_core.c       | 33 +++++++++++++++++++++++++++----
 net/netfilter/nf_nat_masquerade.c | 17 ++++++++++++++--
 2 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 7de595ead06a..1fbf98cade41 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -195,13 +195,30 @@ static bool nf_nat_inet_in_range(const struct nf_co=
nntrack_tuple *t,
 static bool l4proto_in_range(const struct nf_conntrack_tuple *tuple,
 			     enum nf_nat_manip_type maniptype,
 			     const union nf_conntrack_man_proto *min,
-			     const union nf_conntrack_man_proto *max)
+			     const union nf_conntrack_man_proto *max,
+			     const union nf_conntrack_man_proto *base,
+			     bool is_psid)
 {
 	__be16 port;
+	u16 psid, psid_mask, offset_mask;
+
+	/* In this case we are in PSID mode, avoid checking all ranges by compu=
ting bitmasks */
+	if (is_psid) {
+		u16 j =3D ntohs(max->all) - ntohs(min->all) + 1;
+		u16 a =3D (1 << 16) / ntohs(base->all);
+
+		offset_mask =3D (a - 1) * ntohs(base->all);
+		psid_mask =3D ((ntohs(base->all) / j) << 1) - 1;
+		psid =3D ntohs(min->all) & psid_mask;
+	}
=20
 	switch (tuple->dst.protonum) {
 	case IPPROTO_ICMP:
 	case IPPROTO_ICMPV6:
+		if (is_psid) {
+			return ((ntohs(tuple->src.u.icmp.id) & offset_mask) !=3D 0) &&
+				((ntohs(tuple->src.u.icmp.id) & psid_mask) =3D=3D psid);
+		}
 		return ntohs(tuple->src.u.icmp.id) >=3D ntohs(min->icmp.id) &&
 		       ntohs(tuple->src.u.icmp.id) <=3D ntohs(max->icmp.id);
 	case IPPROTO_GRE: /* all fall though */
@@ -215,6 +232,10 @@ static bool l4proto_in_range(const struct nf_conntra=
ck_tuple *tuple,
 		else
 			port =3D tuple->dst.u.all;
=20
+		if (is_psid) {
+			return ((ntohs(port) & offset_mask) !=3D 0) &&
+				((ntohs(port) & psid_mask) =3D=3D psid);
+		}
 		return ntohs(port) >=3D ntohs(min->all) &&
 		       ntohs(port) <=3D ntohs(max->all);
 	default:
@@ -239,7 +260,8 @@ static int in_range(const struct nf_conntrack_tuple *=
tuple,
 		return 1;
=20
 	return l4proto_in_range(tuple, NF_NAT_MANIP_SRC,
-				&range->min_proto, &range->max_proto);
+				&range->min_proto, &range->max_proto, &range->base_proto,
+				range->flags & NF_NAT_RANGE_PSID);
 }
=20
 static inline int
@@ -532,8 +554,11 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 		if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
 			if (!(range->flags & NF_NAT_RANGE_PROTO_OFFSET) &&
 			    l4proto_in_range(tuple, maniptype,
-			          &range->min_proto,
-			          &range->max_proto) &&
+				  &range->min_proto,
+				  &range->max_proto,
+				  &range->base_proto,
+				  range->flags &
+				  NF_NAT_RANGE_PSID) &&
 			    (range->min_proto.all =3D=3D range->max_proto.all ||
 			     !nf_nat_used_tuple(tuple, ct)))
 				return;
diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_mas=
querade.c
index 8e8a65d46345..423b3774e65c 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -55,8 +55,21 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned i=
nt hooknum,
 	newrange.flags       =3D range->flags | NF_NAT_RANGE_MAP_IPS;
 	newrange.min_addr.ip =3D newsrc;
 	newrange.max_addr.ip =3D newsrc;
-	newrange.min_proto   =3D range->min_proto;
-	newrange.max_proto   =3D range->max_proto;
+
+	if (range->flags & NF_NAT_RANGE_PSID) {
+		u16 off =3D prandom_u32();
+		u16 base =3D ntohs(range->base_proto.all);
+		u16 min =3D  ntohs(range->min_proto.all);
+		u16 max_off =3D ((1 << 16) / base) - 1;
+
+		newrange.flags           =3D newrange.flags | NF_NAT_RANGE_PROTO_SPECI=
FIED;
+		newrange.min_proto.all   =3D htons(min + base * (off % max_off));
+		newrange.max_proto.all   =3D htons(ntohs(newrange.min_proto.all) + nto=
hs(range->max_proto.all) - min);
+		newrange.base_proto      =3D range->base_proto;
+	} else {
+		newrange.min_proto       =3D range->min_proto;
+		newrange.max_proto       =3D range->max_proto;
+	}
=20
 	/* Hand modified range to generic setup. */
 	return nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_SRC);
--=20
2.32.0

