Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8543D860F
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 05:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbhG1DVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 23:21:53 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:35614 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbhG1DVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 23:21:51 -0400
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 099AC806B5;
        Wed, 28 Jul 2021 15:21:47 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1627442507;
        bh=M/uPIgLF8tGUDD98okYzFS0J2waYirdjuMamUxcRp6E=;
        h=From:To:Cc:Subject:Date;
        b=ONzu72LUqpwksenWFVsO3wIbxCOyMM/hjKOAVDPE2Z5AUzReRX0+3H5Qa1YR7b+G2
         478Tn+Asr/9LcZJId2Fbntfq3/qUoa92tSqkDR3ZvleEepRPZU4C9k77XOMX8tHpz7
         PpioyciwIq4UupPxFmqdtFkDhVIHG+uI++LOs32S/YihB5/sR4cR+fmbhO8Jw7DKGi
         O5e6b5Xx8M/hpaiSWYIqALVIxvCGLABPUrDzuHuThVrykidB14sLFpiv/fkoB5dYrR
         XdfkVqXNO4efLeRmSBWGPhId1plFaJ+vKYPJis/blF3f+Oanei4gG5GiECdXmkWQT0
         wEsuGeCVWWmeg==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6100cd4a0000>; Wed, 28 Jul 2021 15:21:46 +1200
Received: from coled-dl.ws.atlnz.lc (coled-dl.ws.atlnz.lc [10.33.25.26])
        by pat.atlnz.lc (Postfix) with ESMTP id C311913EE48;
        Wed, 28 Jul 2021 15:21:46 +1200 (NZST)
Received: by coled-dl.ws.atlnz.lc (Postfix, from userid 1801)
        id BCC55241AD5; Wed, 28 Jul 2021 15:21:46 +1200 (NZST)
From:   Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
To:     pablo@netfilter.org
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, shuah@kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>,
        Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>,
        Scott Parlane <scott.parlane@alliedtelesis.co.nz>,
        Blair Steven <blair.steven@alliedtelesis.co.nz>
Subject: [PATCH] net: netfilter: Fix port selection of FTP for NF_NAT_RANGE_PROTO_SPECIFIED
Date:   Wed, 28 Jul 2021 15:21:34 +1200
Message-Id: <20210728032134.21983-1-Cole.Dishington@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=dvql9Go4 c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=e_q4qTt1xDgA:10 a=xOT0nC9th1TpZTiSAT0A:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
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
    Currently with iptables -t nat -j MASQUERADE -p tcp --to-ports 10000-=
10005,
    creating a passive ftp connection from a client will result in the co=
ntrol
    connection being within the specified port range but the data connect=
ion being
    outside of the range. This patch fixes this behaviour to have both co=
nnections
    be in the specified range.

 include/net/netfilter/nf_conntrack.h |  3 +++
 net/netfilter/nf_nat_core.c          | 10 ++++++----
 net/netfilter/nf_nat_ftp.c           | 26 ++++++++++++--------------
 net/netfilter/nf_nat_helper.c        | 12 ++++++++----
 4 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter=
/nf_conntrack.h
index cc663c68ddc4..b98d5d04c7ab 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -24,6 +24,8 @@
=20
 #include <net/netfilter/nf_conntrack_tuple.h>
=20
+#include <uapi/linux/netfilter/nf_nat.h>
+
 struct nf_ct_udp {
 	unsigned long	stream_ts;
 };
@@ -99,6 +101,7 @@ struct nf_conn {
=20
 #if IS_ENABLED(CONFIG_NF_NAT)
 	struct hlist_node	nat_bysource;
+	struct nf_nat_range2 range;
 #endif
 	/* all members below initialized via memset */
 	struct { } __nfct_init_offset;
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 7de595ead06a..4772c8457ef2 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -360,10 +360,10 @@ find_best_ips_proto(const struct nf_conntrack_zone =
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
@@ -586,6 +586,8 @@ nf_nat_setup_info(struct nf_conn *ct,
 			   &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
=20
 	get_unique_tuple(&new_tuple, &curr_tuple, range, ct, maniptype);
+	if (range)
+		ct->range =3D *range;
=20
 	if (!nf_ct_tuple_equal(&new_tuple, &curr_tuple)) {
 		struct nf_conntrack_tuple reply;
diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index aace6768a64e..6794aa77162b 100644
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
@@ -74,6 +78,7 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 	struct nf_conn *ct =3D exp->master;
 	char buffer[sizeof("|1||65535|") + INET6_ADDRSTRLEN];
 	unsigned int buflen;
+	int ret;
=20
 	pr_debug("type %i, off %u len %u\n", type, matchoff, matchlen);
=20
@@ -86,21 +91,14 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
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
+	/* Find a port that matches the NAT rule */
+	nf_nat_l4proto_unique_tuple(&exp->tuple, &ct->range,
+				    dir ? NF_NAT_MANIP_SRC : NF_NAT_MANIP_DST,
+				    ct);
+	port =3D ntohs(exp->tuple.dst.u.tcp.port);
+	ret =3D nf_ct_expect_related(exp, 0);
=20
-	if (port =3D=3D 0) {
+	if ((ret !=3D 0 && ret !=3D -EBUSY) || port =3D=3D 0) {
 		nf_ct_helper_log(skb, ct, "all ports in use");
 		return NF_DROP;
 	}
diff --git a/net/netfilter/nf_nat_helper.c b/net/netfilter/nf_nat_helper.=
c
index a263505455fc..912bf50be58a 100644
--- a/net/netfilter/nf_nat_helper.c
+++ b/net/netfilter/nf_nat_helper.c
@@ -184,10 +184,14 @@ void nf_nat_follow_master(struct nf_conn *ct,
 	/* This must be a fresh one. */
 	BUG_ON(ct->status & IPS_NAT_DONE_MASK);
=20
-	/* Change src to where master sends to */
-	range.flags =3D NF_NAT_RANGE_MAP_IPS;
-	range.min_addr =3D range.max_addr
-		=3D ct->master->tuplehash[!exp->dir].tuple.dst.u3;
+	if (exp->master && !exp->dir) {
+		range =3D exp->master->range;
+	} else {
+		/* Change src to where master sends to */
+		range.flags =3D NF_NAT_RANGE_MAP_IPS;
+		range.min_addr =3D ct->master->tuplehash[!exp->dir].tuple.dst.u3;
+		range.max_addr =3D ct->master->tuplehash[!exp->dir].tuple.dst.u3;
+	}
 	nf_nat_setup_info(ct, &range, NF_NAT_MANIP_SRC);
=20
 	/* For DST manip, map port here to where it's expected. */
--=20
2.32.0

