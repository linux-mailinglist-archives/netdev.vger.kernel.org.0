Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EFE40BC2E
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 01:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235929AbhINXbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 19:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbhINXbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 19:31:36 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5FFC061762
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 16:30:18 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id E60E5806AC;
        Wed, 15 Sep 2021 11:30:12 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1631662212;
        bh=RADbeFbJkIv7Big72n9qhNPRwU04jTokEdgTpQmNz9U=;
        h=From:To:Cc:Subject:Date;
        b=lF2Vj2Y/fx63oEGTRPUPZZakOUwp6k8LhQW33UBwsNjPPlZv6dn7ObMGxxyb7Evf5
         /cGFRkcrpZaXw/tU8V1A4lss2nP50EGEnVUMHGguSoqvtiht5D64flR1COMvje1jCP
         /d11eZa32d1gHVTuMIjXFcU/Dp1J4b9TM0kKht4PjM14WNksjJJu+R6+y+GUDNUahR
         cuCnLYBXJqokWkIaX89KNCvGJv7FOIldkWKqElqnY9OOwzV8dxxfdHKBVidvUOf/BW
         QH0aFOUnlKFzPMviRZPF+TKjj+q/G8vix05Qi6sCsUREH/0ypLcyL94noKtEGB5OQA
         5RAGzowFvVGZQ==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B614130840000>; Wed, 15 Sep 2021 11:30:12 +1200
Received: from coled-dl.ws.atlnz.lc (coled-dl.ws.atlnz.lc [10.33.25.26])
        by pat.atlnz.lc (Postfix) with ESMTP id B116A13EE3F;
        Wed, 15 Sep 2021 11:30:12 +1200 (NZST)
Received: by coled-dl.ws.atlnz.lc (Postfix, from userid 1801)
        id A9767240D70; Wed, 15 Sep 2021 11:30:12 +1200 (NZST)
From:   Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, shuah@kernel.org
Cc:     linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>,
        Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>,
        Scott Parlane <scott.parlane@alliedtelesis.co.nz>,
        Blair Steven <blair.steven@alliedtelesis.co.nz>
Subject: [PATCH net v3] net: netfilter: Fix port selection of FTP for NF_NAT_RANGE_PROTO_SPECIFIED
Date:   Wed, 15 Sep 2021 11:30:06 +1200
Message-Id: <20210914233006.8710-1-Cole.Dishington@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=fY/TNHYF c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=7QKq2e-ADPsA:10 a=oMNuOPhhpfK_yRezG5QA:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FTP port selection ignores specified port ranges (with iptables
masquerade --to-ports) when creating an expectation, based on
FTP commands PORT or PASV, for the data connection.

Co-developed-by: Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>
Signed-off-by: Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>
Co-developed-by: Scott Parlane <scott.parlane@alliedtelesis.co.nz>
Signed-off-by: Scott Parlane <scott.parlane@alliedtelesis.co.nz>
Co-developed-by: Blair Steven <blair.steven@alliedtelesis.co.nz>
Signed-off-by: Blair Steven <blair.steven@alliedtelesis.co.nz>
Signed-off-by: Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
---

Notes:
    Thanks for your time reviewing!
   =20
    Changes:
    - Removed check for port =3D=3D 0.
    - Added nf_nat_l4proto_unique_tuple() to include/net/netfilter/nf_nat=
.h.
    - Simplify htons/ntohs calls.
    - Move away from conditional call of nf_nat_l4proto_unique_tuple() to=
 applying full range to dst port
      if ftp active with PORT/ePORT is used.
    - Remove check for exp->master !=3D NULL.
   =20
    Comments:
    - dir is the direction of the ftp PORT/PASV request, so exp->dir is t=
he direction
      of the data connection. In nat helper, the range should be applied =
on !exp->dir
      source port since this is the connection from the client.

 include/net/netfilter/nf_nat.h | 11 ++++++++++
 net/netfilter/nf_nat_core.c    | 17 +++++++++++----
 net/netfilter/nf_nat_ftp.c     | 38 +++++++++++++++++++++++-----------
 net/netfilter/nf_nat_helper.c  | 10 +++++++++
 4 files changed, 60 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_na=
t.h
index 0d412dd63707..89796ed2aad3 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -27,12 +27,18 @@ union nf_conntrack_nat_help {
 #endif
 };
=20
+struct nf_conn_nat_range_info {
+	union nf_conntrack_man_proto    min_proto;
+	union nf_conntrack_man_proto    max_proto;
+};
+
 /* The structure embedded in the conntrack structure. */
 struct nf_conn_nat {
 	union nf_conntrack_nat_help help;
 #if IS_ENABLED(CONFIG_NF_NAT_MASQUERADE)
 	int masq_index;
 #endif
+	struct nf_conn_nat_range_info range_info;
 };
=20
 /* Set up the info structure to map into this range. */
@@ -40,6 +46,11 @@ unsigned int nf_nat_setup_info(struct nf_conn *ct,
 			       const struct nf_nat_range2 *range,
 			       enum nf_nat_manip_type maniptype);
=20
+void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
+				 const struct nf_nat_range2 *range,
+				 enum nf_nat_manip_type maniptype,
+				 const struct nf_conn *ct);
+
 extern unsigned int nf_nat_alloc_null_binding(struct nf_conn *ct,
 					      unsigned int hooknum);
=20
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index ea923f8cf9c4..edfd72524c38 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -397,10 +397,10 @@ find_best_ips_proto(const struct nf_conntrack_zone =
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
@@ -623,6 +623,15 @@ nf_nat_setup_info(struct nf_conn *ct,
 			   &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
=20
 	get_unique_tuple(&new_tuple, &curr_tuple, range, ct, maniptype);
+	if (range && (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)) {
+		struct nf_conn_nat *nat =3D nf_ct_nat_ext_add(ct);
+
+		if (WARN_ON_ONCE(!nat))
+			return NF_DROP;
+
+		nat->range_info.min_proto =3D range->min_proto;
+		nat->range_info.max_proto =3D range->max_proto;
+	}
=20
 	if (!nf_ct_tuple_equal(&new_tuple, &curr_tuple)) {
 		struct nf_conntrack_tuple reply;
diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index aace6768a64e..f14e53e8dc04 100644
--- a/net/netfilter/nf_nat_ftp.c
+++ b/net/netfilter/nf_nat_ftp.c
@@ -72,8 +72,14 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 	u_int16_t port;
 	int dir =3D CTINFO2DIR(ctinfo);
 	struct nf_conn *ct =3D exp->master;
+	struct nf_conn_nat *nat =3D nfct_nat(ct);
+	struct nf_nat_range2 range =3D {};
 	char buffer[sizeof("|1||65535|") + INET6_ADDRSTRLEN];
 	unsigned int buflen;
+	int ret;
+
+	if (WARN_ON_ONCE(!nat))
+		return NF_DROP;
=20
 	pr_debug("type %i, off %u len %u\n", type, matchoff, matchlen);
=20
@@ -86,21 +92,29 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 	 * this one. */
 	exp->expectfn =3D nf_nat_follow_master;
=20
-	/* Try to get same port: if not, try to change it. */
-	for (port =3D ntohs(exp->saved_proto.tcp.port); port !=3D 0; port++) {
-		int ret;
+	/* Avoid applying range to external ports */
+	if (!exp->dir || !nat->range_info.min_proto.all || !nat->range_info.max=
_proto.all) {
+		range.min_proto.all =3D htons(1);
+		range.max_proto.all =3D htons(65535);
+	} else {
+		range.min_proto     =3D nat->range_info.min_proto;
+		range.max_proto     =3D nat->range_info.max_proto;
+	}
+	range.flags                 =3D NF_NAT_RANGE_PROTO_SPECIFIED;
+
+	/* Try to get same port if it matches range */
+	ret =3D -1;
+	port =3D ntohs(exp->tuple.dst.u.tcp.port);
+	if (ntohs(range.min_proto.all) <=3D port && port <=3D ntohs(range.max_p=
roto.all))
+		ret =3D nf_ct_expect_related(exp, 0);
=20
-		exp->tuple.dst.u.tcp.port =3D htons(port);
+	/* Same port is not available, try to change it */
+	if (ret !=3D 0) {
+		nf_nat_l4proto_unique_tuple(&exp->tuple, &range, NF_NAT_MANIP_DST, ct)=
;
+		port =3D ntohs(exp->tuple.dst.u.tcp.port);
 		ret =3D nf_ct_expect_related(exp, 0);
-		if (ret =3D=3D 0)
-			break;
-		else if (ret !=3D -EBUSY) {
-			port =3D 0;
-			break;
-		}
 	}
-
-	if (port =3D=3D 0) {
+	if (ret !=3D 0) {
 		nf_ct_helper_log(skb, ct, "all ports in use");
 		return NF_DROP;
 	}
diff --git a/net/netfilter/nf_nat_helper.c b/net/netfilter/nf_nat_helper.=
c
index a263505455fc..718fc423bc44 100644
--- a/net/netfilter/nf_nat_helper.c
+++ b/net/netfilter/nf_nat_helper.c
@@ -188,6 +188,16 @@ void nf_nat_follow_master(struct nf_conn *ct,
 	range.flags =3D NF_NAT_RANGE_MAP_IPS;
 	range.min_addr =3D range.max_addr
 		=3D ct->master->tuplehash[!exp->dir].tuple.dst.u3;
+	if (!exp->dir) {
+		struct nf_conn_nat *nat =3D nfct_nat(exp->master);
+
+		if (nat && nat->range_info.min_proto.all &&
+		    nat->range_info.max_proto.all) {
+			range.min_proto =3D nat->range_info.min_proto;
+			range.max_proto =3D nat->range_info.max_proto;
+			range.flags |=3D NF_NAT_RANGE_PROTO_SPECIFIED;
+		}
+	}
 	nf_nat_setup_info(ct, &range, NF_NAT_MANIP_SRC);
=20
 	/* For DST manip, map port here to where it's expected. */
--=20
2.33.0

