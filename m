Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5D940D23B
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 06:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbhIPEMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 00:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbhIPEMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 00:12:31 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F45C061764
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 21:11:10 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 36FC1806A8;
        Thu, 16 Sep 2021 16:11:06 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1631765466;
        bh=xzFoaghB6J50a9Z3r8Mfbhqg3yDoiQQCqdhnRGIjaIo=;
        h=From:To:Cc:Subject:Date;
        b=hluijJ9qmc0De+wXQjuFTPAKO0qurTKIKiPHotnV6JaLQndMqlJUAu33dx2W8ebTP
         DsORN+UW6/NC7c35gAxMA1vlUenwVSVtsY+uENgfHdNuAOdnLlH9hqbK6egSrx6m8O
         TINSk+rDssUSBeFmnScey/grDjMr0yVwQSfRPJfP4lCQKE3fLlu4xEqT6gs2kJLSzK
         hngBnIse3w3YLe5hPIb7rvK3dRXNTPWChxcEG8p7VUrSFFnMrV+8k7xw/wnl318cKE
         jGVMWg9zyCHGI9dMiF0IGvUTpgFlAEFcs5zENty1hR0oT9iZBy/afSsPhvkX/EYVQd
         9/DUHIqepBp5A==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6142c3d90000>; Thu, 16 Sep 2021 16:11:05 +1200
Received: from coled-dl.ws.atlnz.lc (coled-dl.ws.atlnz.lc [10.33.25.26])
        by pat.atlnz.lc (Postfix) with ESMTP id EA44113ED4A;
        Thu, 16 Sep 2021 16:11:05 +1200 (NZST)
Received: by coled-dl.ws.atlnz.lc (Postfix, from userid 1801)
        id E38802428CC; Thu, 16 Sep 2021 16:11:05 +1200 (NZST)
From:   Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, shuah@kernel.org
Cc:     linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>,
        Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>,
        Scott Parlane <scott.parlane@alliedtelesis.co.nz>,
        Blair Steven <blair.steven@alliedtelesis.co.nz>
Subject: [PATCH net v4] net: netfilter: Fix port selection of FTP for NF_NAT_RANGE_PROTO_SPECIFIED
Date:   Thu, 16 Sep 2021 16:10:57 +1200
Message-Id: <20210916041057.459-1-Cole.Dishington@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=fY/TNHYF c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=7QKq2e-ADPsA:10 a=xOT0nC9th1TpZTiSAT0A:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FTP port selection ignores specified port ranges (with iptables
masquerade --to-ports) when creating an expectation, based on
FTP commands PORT or PASV, for the data connection.

For masquerading, this issue allows an FTP client to use unassigned sourc=
e ports
for their data connection (in both the PORT and PASV cases). This can
cause problems in setups that allocate different masquerade port ranges f=
or each
client.

The proposed fix involves storing a port range (on nf_conn_nat) to:
- Fix FTP PORT data connections using the stored port range to select a
  port number in nf_conntrack_ftp.
- Fix FTP PASV data connections using the stored port range to specify a
  port range on source port in nf_nat_helper if the FTP PORT/PASV packet
  comes from the client.

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
    - Avoid allocating same port to ftp data connection expectation as us=
ed for ftp control.
      - Changed ftp port selection back to a for loop with expectation ch=
ecking.
      - Iterate over a range of ports rather than exp dst port to max por=
t.
    - Added further description to commit message to detail the problem t=
his patch is fixing.

 include/net/netfilter/nf_nat.h |  6 ++++++
 net/netfilter/nf_nat_core.c    |  9 +++++++++
 net/netfilter/nf_nat_ftp.c     | 29 +++++++++++++++++++++--------
 net/netfilter/nf_nat_helper.c  | 10 ++++++++++
 4 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_na=
t.h
index 0d412dd63707..231cffc16722 100644
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
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index ea923f8cf9c4..5ae27cf7e808 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -623,6 +623,15 @@ nf_nat_setup_info(struct nf_conn *ct,
 			   &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
=20
 	get_unique_tuple(&new_tuple, &curr_tuple, range, ct, maniptype);
+	if (range && (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)) {
+		struct nf_conn_nat *nat =3D nf_ct_nat_ext_add(ct);
+
+		if (!nat)
+			return NF_DROP;
+
+		nat->range_info.min_proto =3D range->min_proto;
+		nat->range_info.max_proto =3D range->max_proto;
+	}
=20
 	if (!nf_ct_tuple_equal(&new_tuple, &curr_tuple)) {
 		struct nf_conntrack_tuple reply;
diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index aace6768a64e..499798ade988 100644
--- a/net/netfilter/nf_nat_ftp.c
+++ b/net/netfilter/nf_nat_ftp.c
@@ -72,8 +72,14 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 	u_int16_t port;
 	int dir =3D CTINFO2DIR(ctinfo);
 	struct nf_conn *ct =3D exp->master;
+	struct nf_conn_nat *nat =3D nfct_nat(ct);
+	unsigned int i, first_port, min, range_size;
 	char buffer[sizeof("|1||65535|") + INET6_ADDRSTRLEN];
 	unsigned int buflen;
+	int ret;
+
+	if (WARN_ON_ONCE(!nat))
+		return NF_DROP;
=20
 	pr_debug("type %i, off %u len %u\n", type, matchoff, matchlen);
=20
@@ -86,21 +92,28 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 	 * this one. */
 	exp->expectfn =3D nf_nat_follow_master;
=20
+	/* Avoid applying nat->range to the reply direction */
+	if (!exp->dir || !nat->range_info.min_proto.all || !nat->range_info.max=
_proto.all) {
+		min =3D ntohs(exp->saved_proto.tcp.port);
+		range_size =3D 65535 - min + 1;
+	} else {
+		min =3D ntohs(nat->range_info.min_proto.all);
+		range_size =3D ntohs(nat->range_info.max_proto.all) - min + 1;
+	}
+
 	/* Try to get same port: if not, try to change it. */
-	for (port =3D ntohs(exp->saved_proto.tcp.port); port !=3D 0; port++) {
-		int ret;
+	first_port =3D ntohs(exp->saved_proto.tcp.port);
+	if (min > first_port || first_port > (min + range_size - 1))
+		first_port =3D min;
=20
+	for (i =3D 0, port =3D first_port; i < range_size; i++, port =3D (port =
- first_port + i) % range_size) {
 		exp->tuple.dst.u.tcp.port =3D htons(port);
 		ret =3D nf_ct_expect_related(exp, 0);
-		if (ret =3D=3D 0)
-			break;
-		else if (ret !=3D -EBUSY) {
-			port =3D 0;
+		if (ret !=3D -EBUSY)
 			break;
-		}
 	}
=20
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

