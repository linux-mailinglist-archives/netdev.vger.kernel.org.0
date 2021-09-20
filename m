Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136ED412774
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 22:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235718AbhITUsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 16:48:15 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:40611 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbhITUqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 16:46:14 -0400
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 45AA183651;
        Tue, 21 Sep 2021 08:44:43 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1632170683;
        bh=5Dpx2kyLtsztDA5WSZjmj6Onx7HoL/rUbWRMnRjR2r8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=DQ7bWwFyztEbSiEADX/fa93IDL+bcVRC9Txh1QN8afVAXojA6PWeltZbMCncrP6ih
         ARFqALGJe60XmK2obiGJpNhCtKchYK5VOIwehj6Aubewn+tne1aao2lEdphb5HpXNy
         3zKXLssiYpfiCyOoRVHUshBl02toBn4yaFPrcnrxp/2SP7vyTEIQ/p3zdJRBRH/cH4
         j8BBKTF9cJsY+sIB6xklOdu4RCMcftMjBT7FQeIVn0ysktKqrwhibuejzL9tBm7iiw
         bbW4J8fyH+md0jXhoIrrSV2NwTUfgoaO5XpvaeWG6jJRta1QOBkeEGAXobTJdJrC5m
         rPAKvxhJ2Hwcg==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6148f2ba0002>; Tue, 21 Sep 2021 08:44:42 +1200
Received: from coled-dl.ws.atlnz.lc (coled-dl.ws.atlnz.lc [10.33.25.26])
        by pat.atlnz.lc (Postfix) with ESMTP id E240D13EEA7;
        Tue, 21 Sep 2021 08:44:42 +1200 (NZST)
Received: by coled-dl.ws.atlnz.lc (Postfix, from userid 1801)
        id DE640242827; Tue, 21 Sep 2021 08:44:42 +1200 (NZST)
From:   Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, shuah@kernel.org
Cc:     linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>,
        Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>,
        Scott Parlane <scott.parlane@alliedtelesis.co.nz>,
        Blair Steven <blair.steven@alliedtelesis.co.nz>
Subject: [PATCH net v6 2/2] net: netfilter: Fix port selection of FTP for NF_NAT_RANGE_PROTO_SPECIFIED
Date:   Tue, 21 Sep 2021 08:44:39 +1200
Message-Id: <20210920204439.13179-3-Cole.Dishington@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920204439.13179-1-Cole.Dishington@alliedtelesis.co.nz>
References: <20210920204439.13179-1-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=FtN7AFjq c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=7QKq2e-ADPsA:10 a=xOT0nC9th1TpZTiSAT0A:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FTP port selection ignores specified port ranges (with iptables
masquerade --to-ports) when creating an expectation, based on
FTP commands PORT or PASV, for the data connection.

For masquerading, this issue allows an FTP client to use unassigned
source ports for their data connection (in both the PORT and PASV
cases). This can cause problems in setups that allocate different
masquerade port ranges for each client.

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
Acked-by: Florian Westphal <fw@strlen.de>
---

Notes:
	Thanks for your time reviewing!

	Changes:
	- Add Acked-by: Florian Westphal <fw@strlen.de>

 include/net/netfilter/nf_nat.h |  6 ++++++
 net/netfilter/nf_nat_core.c    |  9 +++++++++
 net/netfilter/nf_nat_ftp.c     | 22 +++++++++++++++++++---
 net/netfilter/nf_nat_helper.c  | 10 ++++++++++
 4 files changed, 44 insertions(+), 3 deletions(-)

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
index b7c3c902290f..2acec7fd56bd 100644
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
index 2da29e5d4309..7af1519d7a89 100644
--- a/net/netfilter/nf_nat_ftp.c
+++ b/net/netfilter/nf_nat_ftp.c
@@ -72,12 +72,16 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 	u_int16_t port;
 	int dir =3D CTINFO2DIR(ctinfo);
 	struct nf_conn *ct =3D exp->master;
+	struct nf_conn_nat *nat =3D nfct_nat(ct);
 	unsigned int i, min, max, range_size;
 	static const unsigned int max_attempts =3D 128;
 	char buffer[sizeof("|1||65535|") + INET6_ADDRSTRLEN];
 	unsigned int buflen;
 	int ret;
=20
+	if (WARN_ON_ONCE(!nat))
+		return NF_DROP;
+
 	pr_debug("type %i, off %u len %u\n", type, matchoff, matchlen);
=20
 	/* Connection will come from wherever this packet goes, hence !dir */
@@ -89,11 +93,23 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 	 * this one. */
 	exp->expectfn =3D nf_nat_follow_master;
=20
-	min =3D ntohs(exp->saved_proto.tcp.port);
-	max =3D 65535;
+	/* Avoid applying nat->range to the reply direction */
+	if (!exp->dir || !nat->range_info.min_proto.all || !nat->range_info.max=
_proto.all) {
+		min =3D ntohs(exp->saved_proto.tcp.port);
+		max =3D 65535;
+	} else {
+		min =3D ntohs(nat->range_info.min_proto.all);
+		max =3D ntohs(nat->range_info.max_proto.all);
+		if (unlikely(max < min))
+			swap(max, min);
+	}
=20
 	/* Try to get same port */
-	ret =3D nf_ct_expect_related(exp, 0);
+	ret =3D -1;
+	port =3D ntohs(exp->saved_proto.tcp.port);
+	if (min < port && port < max) {
+		ret =3D nf_ct_expect_related(exp, 0);
+	}
=20
 	/* if same port is not in range or available, try to change it. */
 	if (ret !=3D 0) {
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

