Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706D63B6BDA
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 02:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbhF2AvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 20:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhF2AvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 20:51:01 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38996C061760
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 17:48:34 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 09B1A806B6;
        Tue, 29 Jun 2021 12:48:28 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1624927708;
        bh=u2EMNyyJVZNzARjSvEVmmniuBo3AAdYapJjGP4BBgxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=q2XbocSlyKLVUUkokPWltMJDXUyK8xAAyovraIKHxGnD2oZP91UN2Jzk/c3DpSbql
         MqKKY3DcBR2P/rCmBfYZKtAfv/Bt9wKrU7meD5CNoF8GciEV0IyyXWjjjNkrqzN3oD
         OBmewiyJpYaqEn9oB45OFQEBgYznfRVamRGWg0ckzVToW4b21m8WqsbJp3A2T7DZqO
         hmcAO75Wrh7YwZdw/KlfDR77eZYLca6ARDNs4LOHH7sIoST0l97sQu0RvO9YF8/raB
         d+iQaeggPsMEp7PA1TZUrx2WRUh4UeGiShTGUQhrdRqHeVpn/fLvSz1VoeKXNRHxT9
         WGRnUTZ9O9ORQ==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B60da6ddb0000>; Tue, 29 Jun 2021 12:48:27 +1200
Received: from coled-dl.ws.atlnz.lc (coled-dl.ws.atlnz.lc [10.33.25.26])
        by pat.atlnz.lc (Postfix) with ESMTP id 9C71913EE58;
        Tue, 29 Jun 2021 12:48:27 +1200 (NZST)
Received: by coled-dl.ws.atlnz.lc (Postfix, from userid 1801)
        id 95AC1242927; Tue, 29 Jun 2021 12:48:27 +1200 (NZST)
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
Date:   Tue, 29 Jun 2021 12:48:18 +1200
Message-Id: <20210629004819.4750-1-Cole.Dishington@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210426122324.GA975@breakpoint.cc>
References: <20210426122324.GA975@breakpoint.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=IOh89TnG c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=r6YtysWOX24A:10 a=3HDBlxybAAAA:8 a=fFODNE8ERnhjF_FTNAEA:9 a=laEoCiVfU_Unz3mSdgXN:22
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

Notes:
    Thanks for your time reviewing. I have also submitted a patch to netf=
ilter iptables for these changes.
   =20
    Comments:
    Selecting the ports for psid needs to be in nf_nat_core since the PSI=
D ranges are not a single range. e.g. offset=3D1024, PSID=3D0, psid_lengt=
h=3D8 generates the ranges 1024-1027, 2048-2051, ..., 63488-63491, ... (e=
xample taken from RFC7597 B.2).
    This is why it is enough to set NF_NAT_RANGE_PROTO_SPECIFIED and init=
 upper/lower boundaries.
   =20
    Changes in v2:
    - Moved cached range2 from struct nf_conn to nf_conn_nat.
    - Moved psid fields out of union nf_conntrack_man_proto. Now using ra=
nge2 fields src, dst, and base to store psid parameters.
    - Readded removed error check for nf_ct_expect_related()
    - Added new version to masquerade iptables extension to use the range=
2 base field.

 include/net/netfilter/nf_nat.h        |  1 +
 include/uapi/linux/netfilter/nf_nat.h |  3 +-
 net/netfilter/nf_nat_core.c           | 69 +++++++++++++++++++++++----
 net/netfilter/nf_nat_ftp.c            | 29 ++++++-----
 net/netfilter/nf_nat_helper.c         | 16 +++++--
 net/netfilter/nf_nat_masquerade.c     | 13 +++--
 net/netfilter/xt_MASQUERADE.c         | 44 +++++++++++++++--
 7 files changed, 140 insertions(+), 35 deletions(-)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_na=
t.h
index 987111ae5240..67cc033f76bb 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -32,6 +32,7 @@ struct nf_conn_nat {
 	union nf_conntrack_nat_help help;
 #if IS_ENABLED(CONFIG_NF_NAT_MASQUERADE)
 	int masq_index;
+	struct nf_nat_range2 *range;
 #endif
 };
=20
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
index 7de595ead06a..7307bb28ece2 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -195,13 +195,32 @@ static bool nf_nat_inet_in_range(const struct nf_co=
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
+	u16 offset_mask =3D 0;
+	u16 psid_mask =3D 0;
+	u16 psid =3D 0;
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
@@ -215,6 +234,10 @@ static bool l4proto_in_range(const struct nf_conntra=
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
@@ -239,7 +262,8 @@ static int in_range(const struct nf_conntrack_tuple *=
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
@@ -360,10 +384,10 @@ find_best_ips_proto(const struct nf_conntrack_zone =
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
@@ -420,6 +444,25 @@ static void nf_nat_l4proto_unique_tuple(struct nf_co=
nntrack_tuple *tuple,
 		return;
 	}
=20
+	if (range->flags & NF_NAT_RANGE_PSID) {
+		/* PSID defines a group of port ranges, per PSID. PSID
+		 * is already contained in min and max.
+		 */
+		unsigned int min_to_max, base;
+
+		min =3D ntohs(range->min_proto.all);
+		max =3D ntohs(range->max_proto.all);
+		base =3D ntohs(range->base_proto.all);
+		min_to_max =3D max - min;
+		for (; max <=3D (1 << 16) - 1; min +=3D base, max =3D min + min_to_max=
) {
+			for (off =3D 0; off <=3D min_to_max; off++) {
+				*keyptr =3D htons(min + off);
+				if (!nf_nat_used_tuple(tuple, ct))
+					return;
+			}
+		}
+	}
+
 	/* If no range specified... */
 	if (!(range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)) {
 		/* If it's dst rewrite, can't change port */
@@ -529,11 +572,19 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
=20
 	/* Only bother mapping if it's not already in range and unique */
 	if (!(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
-		if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED) {
+		/* PSID mode is present always needs to check
+		 * to see if the source ports are in range.
+		 */
+		if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED ||
+		    (range->flags & NF_NAT_RANGE_PSID &&
+		     !in_range(orig_tuple, range))) {
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
diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index aace6768a64e..f65163278db0 100644
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
@@ -72,8 +76,13 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 	u_int16_t port;
 	int dir =3D CTINFO2DIR(ctinfo);
 	struct nf_conn *ct =3D exp->master;
+	struct nf_conn_nat *nat =3D nfct_nat(ct);
 	char buffer[sizeof("|1||65535|") + INET6_ADDRSTRLEN];
 	unsigned int buflen;
+	int ret;
+
+	if (WARN_ON_ONCE(!nat))
+		return NF_DROP;
=20
 	pr_debug("type %i, off %u len %u\n", type, matchoff, matchlen);
=20
@@ -86,18 +95,14 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
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
+	/* Find a port that matches the MASQ rule. */
+	nf_nat_l4proto_unique_tuple(&exp->tuple, nat->range,
+				    dir ? NF_NAT_MANIP_SRC : NF_NAT_MANIP_DST,
+				    ct);
+	ret =3D nf_ct_expect_related(exp, 0);
+	port =3D ntohs(exp->tuple.dst.u.tcp.port);
+	if (ret !=3D 0 && ret !=3D -EBUSY) {
+		port =3D 0;
 	}
=20
 	if (port =3D=3D 0) {
diff --git a/net/netfilter/nf_nat_helper.c b/net/netfilter/nf_nat_helper.=
c
index a263505455fc..2d105e4eb8f8 100644
--- a/net/netfilter/nf_nat_helper.c
+++ b/net/netfilter/nf_nat_helper.c
@@ -179,15 +179,23 @@ EXPORT_SYMBOL(nf_nat_mangle_udp_packet);
 void nf_nat_follow_master(struct nf_conn *ct,
 			  struct nf_conntrack_expect *exp)
 {
+	struct nf_conn_nat *nat =3D NULL;
 	struct nf_nat_range2 range;
=20
 	/* This must be a fresh one. */
 	BUG_ON(ct->status & IPS_NAT_DONE_MASK);
=20
-	/* Change src to where master sends to */
-	range.flags =3D NF_NAT_RANGE_MAP_IPS;
-	range.min_addr =3D range.max_addr
-		=3D ct->master->tuplehash[!exp->dir].tuple.dst.u3;
+	if (exp->master && !exp->dir) {
+		nat =3D nfct_nat(exp->master);
+		if (nat)
+			range =3D *nat->range;
+	}
+	if (!nat) {
+		/* Change src to where master sends to */
+		range.flags =3D NF_NAT_RANGE_MAP_IPS;
+		range.min_addr =3D ct->master->tuplehash[!exp->dir].tuple.dst.u3;
+		range.max_addr =3D ct->master->tuplehash[!exp->dir].tuple.dst.u3;
+	}
 	nf_nat_setup_info(ct, &range, NF_NAT_MANIP_SRC);
=20
 	/* For DST manip, map port here to where it's expected. */
diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_mas=
querade.c
index 8e8a65d46345..d83cd3d8ad3f 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -45,10 +45,6 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned i=
nt hooknum,
 		return NF_DROP;
 	}
=20
-	nat =3D nf_ct_nat_ext_add(ct);
-	if (nat)
-		nat->masq_index =3D out->ifindex;
-
 	/* Transfer from original range. */
 	memset(&newrange.min_addr, 0, sizeof(newrange.min_addr));
 	memset(&newrange.max_addr, 0, sizeof(newrange.max_addr));
@@ -57,6 +53,15 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned i=
nt hooknum,
 	newrange.max_addr.ip =3D newsrc;
 	newrange.min_proto   =3D range->min_proto;
 	newrange.max_proto   =3D range->max_proto;
+	newrange.base_proto  =3D range->base_proto;
+
+	nat =3D nf_ct_nat_ext_add(ct);
+	if (nat) {
+		nat->masq_index =3D out->ifindex;
+		if (!nat->range)
+			nat->range =3D kmalloc(sizeof(*nat->range), 0);
+		memcpy(nat->range, &newrange, sizeof(*nat->range));
+	}
=20
 	/* Hand modified range to generic setup. */
 	return nf_nat_setup_info(ct, &newrange, NF_NAT_MANIP_SRC);
diff --git a/net/netfilter/xt_MASQUERADE.c b/net/netfilter/xt_MASQUERADE.=
c
index eae05c178336..dc6870ca2b71 100644
--- a/net/netfilter/xt_MASQUERADE.c
+++ b/net/netfilter/xt_MASQUERADE.c
@@ -16,7 +16,7 @@ MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.=
org>");
 MODULE_DESCRIPTION("Xtables: automatic-address SNAT");
=20
 /* FIXME: Multiple targets. --RR */
-static int masquerade_tg_check(const struct xt_tgchk_param *par)
+static int masquerade_tg_check_v0(const struct xt_tgchk_param *par)
 {
 	const struct nf_nat_ipv4_multi_range_compat *mr =3D par->targinfo;
=20
@@ -31,8 +31,19 @@ static int masquerade_tg_check(const struct xt_tgchk_p=
aram *par)
 	return nf_ct_netns_get(par->net, par->family);
 }
=20
+static int masquerade_tg_check_v1(const struct xt_tgchk_param *par)
+{
+	const struct nf_nat_range2 *range =3D par->targinfo;
+
+	if (range->flags & NF_NAT_RANGE_MAP_IPS) {
+		pr_debug("bad MAP_IPS.\n");
+		return -EINVAL;
+	}
+	return nf_ct_netns_get(par->net, par->family);
+}
+
 static unsigned int
-masquerade_tg(struct sk_buff *skb, const struct xt_action_param *par)
+masquerade_tg_v0(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	struct nf_nat_range2 range;
 	const struct nf_nat_ipv4_multi_range_compat *mr;
@@ -46,6 +57,15 @@ masquerade_tg(struct sk_buff *skb, const struct xt_act=
ion_param *par)
 				      xt_out(par));
 }
=20
+static unsigned int
+masquerade_tg_v1(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct nf_nat_range2 *range =3D par->targinfo;
+
+	return nf_nat_masquerade_ipv4(skb, xt_hooknum(par), range,
+				      xt_out(par));
+}
+
 static void masquerade_tg_destroy(const struct xt_tgdtor_param *par)
 {
 	nf_ct_netns_put(par->net, par->family);
@@ -73,6 +93,7 @@ static struct xt_target masquerade_tg_reg[] __read_most=
ly =3D {
 	{
 #if IS_ENABLED(CONFIG_IPV6)
 		.name		=3D "MASQUERADE",
+		.revision	=3D 0,
 		.family		=3D NFPROTO_IPV6,
 		.target		=3D masquerade_tg6,
 		.targetsize	=3D sizeof(struct nf_nat_range),
@@ -84,15 +105,28 @@ static struct xt_target masquerade_tg_reg[] __read_m=
ostly =3D {
 	}, {
 #endif
 		.name		=3D "MASQUERADE",
+		.revision	=3D 0,
 		.family		=3D NFPROTO_IPV4,
-		.target		=3D masquerade_tg,
+		.target		=3D masquerade_tg_v0,
 		.targetsize	=3D sizeof(struct nf_nat_ipv4_multi_range_compat),
 		.table		=3D "nat",
 		.hooks		=3D 1 << NF_INET_POST_ROUTING,
-		.checkentry	=3D masquerade_tg_check,
+		.checkentry	=3D masquerade_tg_check_v0,
 		.destroy	=3D masquerade_tg_destroy,
 		.me		=3D THIS_MODULE,
-	}
+	},
+	{
+		.name		=3D "MASQUERADE",
+		.revision	=3D 1,
+		.family		=3D NFPROTO_IPV4,
+		.target		=3D masquerade_tg_v1,
+		.targetsize	=3D sizeof(struct nf_nat_range2),
+		.table		=3D "nat",
+		.hooks		=3D 1 << NF_INET_POST_ROUTING,
+		.checkentry	=3D masquerade_tg_check_v1,
+		.destroy	=3D masquerade_tg_destroy,
+		.me		=3D THIS_MODULE,
+	},
 };
=20
 static int __init masquerade_tg_init(void)
--=20
2.32.0

