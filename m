Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2532D367781
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 04:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbhDVCf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 22:35:59 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:52804 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhDVCf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 22:35:59 -0400
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 7D7F8806CB;
        Thu, 22 Apr 2021 14:35:22 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1619058922;
        bh=DL/UBWOxAtSCtMbPw60emaKmBVxBvcAtepOpozBePfI=;
        h=From:To:Cc:Subject:Date;
        b=N9IZQY7iksPVeErXXoO/q1/pXOjzjDrQoztZbt+ZURcQPg2yxIpO6rzkhdql4ZVin
         9w0woXeZx4jr7laMJt2wRPEZ/WEFl/gPO4gXk7wnxKXeVNFoPSs9pLNHcF5arFmXms
         D3vjC8094b6k2AukucWu6pvzd+J6U/nTUZXEsiD1+o5B9PmeDCDy5B80E/nyR2mkmA
         kJvfBjmPxOcIgDQbRUJPtwhAewKqJLg62cGgBmab1nUF7WNkQdtGbqvh0l8Llnrm/p
         Flb3jraiYvqVPPzcyjRWQcPC6Ebq0eSV67AqH2azBWK5KsEw7l/IsTgLktxmOGxje8
         5zHVunDmA1QJQ==
Received: from smtp (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6080e0ea0000>; Thu, 22 Apr 2021 14:35:22 +1200
Received: from coled-dl.ws.atlnz.lc (coled-dl.ws.atlnz.lc [10.33.25.26])
        by smtp (Postfix) with ESMTP id 41B3113EED4;
        Thu, 22 Apr 2021 14:35:44 +1200 (NZST)
Received: by coled-dl.ws.atlnz.lc (Postfix, from userid 1801)
        id 0DAA3242946; Thu, 22 Apr 2021 14:35:22 +1200 (NZST)
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
        netfilter-devel@vger.kernel.org (open list:NETFILTER),
        coreteam@netfilter.org (open list:NETFILTER),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] net: netfilter: Add RFC-7597 Section 5.1 PSID support
Date:   Thu, 22 Apr 2021 14:35:05 +1200
Message-Id: <20210422023506.4651-1-Cole.Dishington@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=B+jHL9lM c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=3YhXtTcJ-WEA:10 a=hliHO8vvrjb_GgMcktUA:9 a=vbNtKFaLgyoh1_7v:21 a=9_ocApIY7FPKfsiY:21
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for masquerading into a smaller subset of ports -
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
 include/net/netfilter/nf_conntrack.h          |   2 +
 .../netfilter/nf_conntrack_tuple_common.h     |   5 +
 include/uapi/linux/netfilter/nf_nat.h         |   3 +-
 net/netfilter/nf_nat_core.c                   | 101 ++++++++++++++++--
 net/netfilter/nf_nat_ftp.c                    |  23 ++--
 net/netfilter/nf_nat_helper.c                 |  15 ++-
 6 files changed, 120 insertions(+), 29 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter=
/nf_conntrack.h
index 439379ca9ffa..d63d38aa7188 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -92,6 +92,8 @@ struct nf_conn {
 	/* If we were expected by an expectation, this will be it */
 	struct nf_conn *master;
=20
+	struct nf_nat_range2 *range;
+
 #if defined(CONFIG_NF_CONNTRACK_MARK)
 	u_int32_t mark;
 #endif
diff --git a/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h b/i=
nclude/uapi/linux/netfilter/nf_conntrack_tuple_common.h
index 64390fac6f7e..36d16d47c2b0 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
@@ -39,6 +39,11 @@ union nf_conntrack_man_proto {
 	struct {
 		__be16 key;	/* GRE key is 32bit, PPtP only uses 16bit */
 	} gre;
+	struct {
+		unsigned char psid_length;
+		unsigned char offset;
+		__be16 psid;
+	} psid;
 };
=20
 #define CTINFO2DIR(ctinfo) ((ctinfo) >=3D IP_CT_IS_REPLY ? IP_CT_DIR_REP=
LY : IP_CT_DIR_ORIGINAL)
diff --git a/include/uapi/linux/netfilter/nf_nat.h b/include/uapi/linux/n=
etfilter/nf_nat.h
index a64586e77b24..660e53ffdb57 100644
--- a/include/uapi/linux/netfilter/nf_nat.h
+++ b/include/uapi/linux/netfilter/nf_nat.h
@@ -12,6 +12,7 @@
 #define NF_NAT_RANGE_PROTO_RANDOM_FULLY		(1 << 4)
 #define NF_NAT_RANGE_PROTO_OFFSET		(1 << 5)
 #define NF_NAT_RANGE_NETMAP			(1 << 6)
+#define NF_NAT_RANGE_PSID			(1 << 7)
=20
 #define NF_NAT_RANGE_PROTO_RANDOM_ALL		\
 	(NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PROTO_RANDOM_FULLY)
@@ -20,7 +21,7 @@
 	(NF_NAT_RANGE_MAP_IPS | NF_NAT_RANGE_PROTO_SPECIFIED |	\
 	 NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PERSISTENT |	\
 	 NF_NAT_RANGE_PROTO_RANDOM_FULLY | NF_NAT_RANGE_PROTO_OFFSET | \
-	 NF_NAT_RANGE_NETMAP)
+	 NF_NAT_RANGE_NETMAP | NF_NAT_RANGE_PSID)
=20
 struct nf_nat_ipv4_range {
 	unsigned int			flags;
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index b7c3c902290f..7730ce4ca9a9 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -232,13 +232,33 @@ static bool nf_nat_inet_in_range(const struct nf_co=
nntrack_tuple *t,
 static bool l4proto_in_range(const struct nf_conntrack_tuple *tuple,
 			     enum nf_nat_manip_type maniptype,
 			     const union nf_conntrack_man_proto *min,
-			     const union nf_conntrack_man_proto *max)
+			     const union nf_conntrack_man_proto *max,
+			     bool is_psid)
 {
 	__be16 port;
=20
+	int m =3D 0;
+	u16 offset_mask =3D 0;
+	u16 psid_mask =3D 0;
+
+	/* In this case we are in PSID mode and the rules are all different */
+	if (is_psid) {
+		/* m =3D number of bits in each valid range */
+		m =3D 16 - min->psid.psid_length - min->psid.offset;
+		offset_mask =3D ((1 << min->psid.offset) - 1) <<
+				(16 - min->psid.offset);
+		psid_mask =3D ((1 << min->psid.psid_length) - 1) << m;
+	}
+
 	switch (tuple->dst.protonum) {
 	case IPPROTO_ICMP:
 	case IPPROTO_ICMPV6:
+		if (is_psid) {
+			return ((ntohs(tuple->src.u.icmp.id) & offset_mask) !=3D
+				0) &&
+				((ntohs(tuple->src.u.icmp.id) & psid_mask) =3D=3D
+				min->psid.psid);
+		}
 		return ntohs(tuple->src.u.icmp.id) >=3D ntohs(min->icmp.id) &&
 		       ntohs(tuple->src.u.icmp.id) <=3D ntohs(max->icmp.id);
 	case IPPROTO_GRE: /* all fall though */
@@ -252,6 +272,11 @@ static bool l4proto_in_range(const struct nf_conntra=
ck_tuple *tuple,
 		else
 			port =3D tuple->dst.u.all;
=20
+		if (is_psid) {
+			return ((ntohs(port) & offset_mask) !=3D 0) &&
+				(((ntohs(port) & psid_mask) >> m) =3D=3D
+				  min->psid.psid);
+		}
 		return ntohs(port) >=3D ntohs(min->all) &&
 		       ntohs(port) <=3D ntohs(max->all);
 	default:
@@ -274,9 +299,9 @@ static int in_range(const struct nf_conntrack_tuple *=
tuple,
=20
 	if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED))
 		return 1;
-
 	return l4proto_in_range(tuple, NF_NAT_MANIP_SRC,
-				&range->min_proto, &range->max_proto);
+				&range->min_proto, &range->max_proto,
+				range->flags & NF_NAT_RANGE_PSID);
 }
=20
 static inline int
@@ -397,10 +422,10 @@ find_best_ips_proto(const struct nf_conntrack_zone =
*zone,
  *
  * Per-protocol part of tuple is initialized to the incoming packet.
  */
-static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple=
,
-					const struct nf_nat_range2 *range,
-					enum nf_nat_manip_type maniptype,
-					const struct nf_conn *ct)
+void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
+				 const struct nf_nat_range2 *range,
+				 enum nf_nat_manip_type maniptype,
+				 const struct nf_conn *ct)
 {
 	unsigned int range_size, min, max, i, attempts;
 	__be16 *keyptr;
@@ -457,6 +482,50 @@ static void nf_nat_l4proto_unique_tuple(struct nf_co=
nntrack_tuple *tuple,
 		return;
 	}
=20
+	if (range->flags & NF_NAT_RANGE_PSID) {
+		/* Find the non-PSID parts of the port.
+		 * To do this we look for an unused port that is
+		 * comprised of [t_chunk|PSID|b_chunk]. The size of
+		 * these pieces is defined by the psid_length and
+		 * offset.
+		 */
+		int m =3D 16 - range->min_proto.psid.psid_length -
+		    range->min_proto.psid.offset;
+		int available;
+		int range_count =3D ((1 << range->min_proto.psid.offset) - 1);
+
+		/* Calculate the size of the bottom block */
+		range_size =3D (1 << m);
+
+		/* Calculate the total IDs to check */
+		available =3D range_size * range_count;
+		if (!available)
+			available =3D range_size;
+
+		off =3D ntohs(*keyptr);
+		for (i =3D 0;; ++off) {
+			int b_chunk =3D off % range_size;
+			int t_chunk =3D 0;
+
+			/* Move up to avoid the all-zeroes reserved chunk
+			 * (if there is one).
+			 */
+			if (range->min_proto.psid.offset > 0) {
+				t_chunk =3D (off >> m) % range_count;
+				++t_chunk;
+				t_chunk <<=3D (m +
+					     range->min_proto.psid.psid_length);
+			}
+
+			*keyptr =3D htons(t_chunk |
+					 (range->min_proto.psid.psid << m)
+					 | b_chunk);
+
+			if (++i >=3D available || !nf_nat_used_tuple(tuple, ct))
+				return;
+		}
+	}
+
 	/* If no range specified... */
 	if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)) {
 		/* If it's dst rewrite, can't change port */
@@ -566,11 +635,18 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
=20
 	/* Only bother mapping if it's not already in range and unique */
 	if (!(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
-		if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
+		/* Now that the PSID mode is present we always need to check
+		 * to see if the source ports are in range.
+		 */
+		if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED ||
+		    (range->flags & NF_NAT_RANGE_PSID &&
+		    !in_range(orig_tuple, range))) {
 			if (!(range->flags & NF_NAT_RANGE_PROTO_OFFSET) &&
 			    l4proto_in_range(tuple, maniptype,
-			          &range->min_proto,
-			          &range->max_proto) &&
+					     &range->min_proto,
+					     &range->max_proto,
+					     range->flags &
+					     NF_NAT_RANGE_PSID) &&
 			    (range->min_proto.all =3D=3D range->max_proto.all ||
 			     !nf_nat_used_tuple(tuple, ct)))
 				return;
@@ -623,6 +699,11 @@ nf_nat_setup_info(struct nf_conn *ct,
 			   &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
=20
 	get_unique_tuple(&new_tuple, &curr_tuple, range, ct, maniptype);
+	if (range) {
+		if (!ct->range)
+			ct->range =3D kmalloc(sizeof(*ct->range), 0);
+		memcpy(ct->range, range, sizeof(*ct->range));
+	}
=20
 	if (!nf_ct_tuple_equal(&new_tuple, &curr_tuple)) {
 		struct nf_conntrack_tuple reply;
diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index aace6768a64e..006b7e1836ff 100644
--- a/net/netfilter/nf_nat_ftp.c
+++ b/net/netfilter/nf_nat_ftp.c
@@ -17,6 +17,10 @@
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <linux/netfilter/nf_conntrack_ftp.h>
+void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
+				 const struct nf_nat_range2 *range,
+				 enum nf_nat_manip_type maniptype,
+				 const struct nf_conn *ct);
=20
 #define NAT_HELPER_NAME "ftp"
=20
@@ -86,19 +90,12 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 	 * this one. */
 	exp->expectfn =3D nf_nat_follow_master;
=20
-	/* Try to get same port: if not, try to change it. */
-	for (port =3D ntohs(exp->saved_proto.tcp.port); port !=3D 0; port++) {
-		int ret;
-
-		exp->tuple.dst.u.tcp.port =3D htons(port);
-		ret =3D nf_ct_expect_related(exp, 0);
-		if (ret =3D=3D 0)
-			break;
-		else if (ret !=3D -EBUSY) {
-			port =3D 0;
-			break;
-		}
-	}
+	/* Find a port that matches the MASQ rule. */
+	nf_nat_l4proto_unique_tuple(&exp->tuple, ct->range,
+				    dir ? NF_NAT_MANIP_SRC : NF_NAT_MANIP_DST,
+				    ct);
+	port =3D ntohs(exp->tuple.dst.u.tcp.port);
+	nf_ct_expect_related(exp, 0);
=20
 	if (port =3D=3D 0) {
 		nf_ct_helper_log(skb, ct, "all ports in use");
diff --git a/net/netfilter/nf_nat_helper.c b/net/netfilter/nf_nat_helper.=
c
index a263505455fc..090153475d4d 100644
--- a/net/netfilter/nf_nat_helper.c
+++ b/net/netfilter/nf_nat_helper.c
@@ -184,11 +184,16 @@ void nf_nat_follow_master(struct nf_conn *ct,
 	/* This must be a fresh one. */
 	BUG_ON(ct->status & IPS_NAT_DONE_MASK);
=20
-	/* Change src to where master sends to */
-	range.flags =3D NF_NAT_RANGE_MAP_IPS;
-	range.min_addr =3D range.max_addr
-		=3D ct->master->tuplehash[!exp->dir].tuple.dst.u3;
-	nf_nat_setup_info(ct, &range, NF_NAT_MANIP_SRC);
+	if (exp->master && exp->master->range && !exp->dir) {
+		range =3D *exp->master->range;
+		nf_nat_setup_info(ct, &range, NF_NAT_MANIP_SRC);
+	} else {
+		/* Change src to where master sends to */
+		range.flags =3D NF_NAT_RANGE_MAP_IPS;
+		range.min_addr =3D ct->master->tuplehash[!exp->dir].tuple.dst.u3;
+		range.max_addr =3D ct->master->tuplehash[!exp->dir].tuple.dst.u3;
+		nf_nat_setup_info(ct, &range, NF_NAT_MANIP_SRC);
+	}
=20
 	/* For DST manip, map port here to where it's expected. */
 	range.flags =3D (NF_NAT_RANGE_MAP_IPS | NF_NAT_RANGE_PROTO_SPECIFIED);
--=20
2.31.1

