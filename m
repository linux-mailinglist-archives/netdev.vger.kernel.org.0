Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E603E3EB5
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 06:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhHIEL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 00:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbhHIELY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 00:11:24 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F19C0613CF
        for <netdev@vger.kernel.org>; Sun,  8 Aug 2021 21:11:04 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 57E22891B2;
        Mon,  9 Aug 2021 16:11:03 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1628482263;
        bh=YS7w3RbW7dwCd1MQH5g1Z9+eRWSd7gg2Lg0p8xCQqWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=sc3r1mlCr9rqIWOGpwHwaScDmO0UpEhyxGmUjzQIZrVi2rM8j4tFg7lc8ZOkiQWmo
         BmQo0pJmNxy/ZFcLlpiWthGzYMZyraArVS1a5z+aiEbt/UvTMfnHgL8r4+xYdgUnTW
         k8bu45VcvUtn9E+V28Uee0WdVkouxqMPhpQ8XmiASz29iyykYVr6vvymIZxEtxZYHj
         w4IaImbItjt7QaRv1SQrIew8yu83Elj0YGYq0ByFkpIGUrS+zEYKQfK6asHCQZ5uw/
         YrK/wC7Fcf1mooTaWI+2op6jEQ8ST5i/t+sMReDi6MogC3AeuuCZ215dHBzeSRDuWt
         vWy8NEz/S6sgA==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6110aad40002>; Mon, 09 Aug 2021 16:11:00 +1200
Received: from coled-dl.ws.atlnz.lc (coled-dl.ws.atlnz.lc [10.33.25.26])
        by pat.atlnz.lc (Postfix) with ESMTP id 8843B13EDC1;
        Mon,  9 Aug 2021 16:11:00 +1200 (NZST)
Received: by coled-dl.ws.atlnz.lc (Postfix, from userid 1801)
        id 847012428A0; Mon,  9 Aug 2021 16:11:00 +1200 (NZST)
From:   Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
To:     pablo@netfilter.org
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, shuah@kernel.org,
        Cole.Dishington@alliedtelesis.co.nz, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>,
        Scott Parlane <scott.parlane@alliedtelesis.co.nz>,
        Blair Steven <blair.steven@alliedtelesis.co.nz>
Subject: [PATCH net-next 2/3] net: netfilter: Add RFC-7597 Section 5.1 PSID support
Date:   Mon,  9 Aug 2021 16:10:36 +1200
Message-Id: <20210809041037.29969-3-Cole.Dishington@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809041037.29969-1-Cole.Dishington@alliedtelesis.co.nz>
References: <20210726143729.GN9904@breakpoint.cc>
 <20210809041037.29969-1-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=dvql9Go4 c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=MhDmnRu9jo8A:10 a=xOT0nC9th1TpZTiSAT0A:9
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
Reviewed-by: Florian Westphal <fw@strlen.de>
---

Notes:
    Changes:
    - Added Reviewed-by: Florian Westphal <fw@strlen.de>.

 net/netfilter/nf_nat_core.c       | 39 +++++++++++++++++++++++++++----
 net/netfilter/nf_nat_masquerade.c | 27 +++++++++++++++++++--
 2 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 7de595ead06a..f07a3473aab5 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -195,13 +195,36 @@ static bool nf_nat_inet_in_range(const struct nf_co=
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
+		u32 power_j =3D ntohs(max->all) - ntohs(min->all) + 1;
+		u32 offset =3D ntohs(base->all);
+		u16 power_a;
+
+		if (offset =3D=3D 0)
+			offset =3D 1 << 16;
+
+		power_a =3D (1 << 16) / offset;
+		offset_mask =3D (power_a - 1) * offset;
+		psid_mask =3D ((offset / power_j) << 1) - 1;
+		psid =3D ntohs(min->all) & psid_mask;
+	}
=20
 	switch (tuple->dst.protonum) {
 	case IPPROTO_ICMP:
 	case IPPROTO_ICMPV6:
+		if (is_psid) {
+			return (offset_mask =3D=3D 0 ||
+				(ntohs(tuple->src.u.icmp.id) & offset_mask) !=3D 0) &&
+				((ntohs(tuple->src.u.icmp.id) & psid_mask) =3D=3D psid);
+		}
 		return ntohs(tuple->src.u.icmp.id) >=3D ntohs(min->icmp.id) &&
 		       ntohs(tuple->src.u.icmp.id) <=3D ntohs(max->icmp.id);
 	case IPPROTO_GRE: /* all fall though */
@@ -215,6 +238,10 @@ static bool l4proto_in_range(const struct nf_conntra=
ck_tuple *tuple,
 		else
 			port =3D tuple->dst.u.all;
=20
+		if (is_psid) {
+			return (offset_mask =3D=3D 0 || (ntohs(port) & offset_mask) !=3D 0) &=
&
+				((ntohs(port) & psid_mask) =3D=3D psid);
+		}
 		return ntohs(port) >=3D ntohs(min->all) &&
 		       ntohs(port) <=3D ntohs(max->all);
 	default:
@@ -239,7 +266,8 @@ static int in_range(const struct nf_conntrack_tuple *=
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
@@ -532,8 +560,11 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
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
index 8e8a65d46345..19a4754cda76 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -55,8 +55,31 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned i=
nt hooknum,
 	newrange.flags       =3D range->flags | NF_NAT_RANGE_MAP_IPS;
 	newrange.min_addr.ip =3D newsrc;
 	newrange.max_addr.ip =3D newsrc;
-	newrange.min_proto   =3D range->min_proto;
-	newrange.max_proto   =3D range->max_proto;
+
+	if (range->flags & NF_NAT_RANGE_PSID) {
+		u16 base =3D ntohs(range->base_proto.all);
+		u16 min =3D  ntohs(range->min_proto.all);
+		u16 off =3D 0;
+
+		/* xtables should stop base > 2^15 by enforcement of
+		 * 0 <=3D offset_len < 16 argument, with offset_len=3D0
+		 * as a special case inwhich base=3D0.
+		 */
+		if (WARN_ON_ONCE(base > (1 << 15)))
+			return NF_DROP;
+
+		/* If offset=3D0, port range is in one contiguous block */
+		if (base)
+			off =3D prandom_u32_max(((1 << 16) / base) - 1);
+
+		newrange.min_proto.all   =3D htons(min + base * off);
+		newrange.max_proto.all   =3D htons(ntohs(newrange.min_proto.all) + nto=
hs(range->max_proto.all) - min);
+		newrange.base_proto      =3D range->base_proto;
+		newrange.flags           =3D newrange.flags | NF_NAT_RANGE_PROTO_SPECI=
FIED;
+	} else {
+		newrange.min_proto       =3D range->min_proto;
+		newrange.max_proto       =3D range->max_proto;
+	}
=20
 	/* Hand modified range to generic setup. */
 	return nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_SRC);
--=20
2.32.0

