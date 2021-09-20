Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040D3410E1A
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 03:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhITBB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 21:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbhITBBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 21:01:25 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C13C061760
        for <netdev@vger.kernel.org>; Sun, 19 Sep 2021 17:59:59 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id ACE7684488;
        Mon, 20 Sep 2021 12:59:57 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1632099597;
        bh=ZMRRyNAMrbwT1Uu/DqqvMPAkB9YifPxe8X5sh3HkTNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=eaJiTXxx2jDJQeXX25B8QKH0Vy8LKnrGCvHlbtbhUv51MOchFiatOa1EU2ng2FvrG
         yYYM+oXTcEXlbKFevN6/VicZdJnYj3BFWsnz2896JzubS1rl0eUagwTIrK+wti/u/2
         kFWcVSlOITnbSsbKPudcA094d9DfryvHaj3OUWwevdIvrla06U5cBG9uZKy9F9GuI4
         smE9gdtZxiIAQW8j3nrhvHprtQYF5Q6+Tcb73pgBd8uukDRkwQmR/IvDtQTcGFK6Ty
         xhKTMMxYnGSXGh2G0QjrWiWQrKgMAR72clQGlldxchxnx7Avnn1A2dp6zFIdM5cHgE
         vO/qmwkZ/4z2Q==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6147dd180000>; Mon, 20 Sep 2021 13:00:08 +1200
Received: from coled-dl.ws.atlnz.lc (coled-dl.ws.atlnz.lc [10.33.25.26])
        by pat.atlnz.lc (Postfix) with ESMTP id 76BAC13EE58;
        Mon, 20 Sep 2021 12:59:57 +1200 (NZST)
Received: by coled-dl.ws.atlnz.lc (Postfix, from userid 1801)
        id 72FAD24285E; Mon, 20 Sep 2021 12:59:57 +1200 (NZST)
From:   Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, shuah@kernel.org
Cc:     linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>,
        Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>,
        Scott Parlane <scott.parlane@alliedtelesis.co.nz>,
        Blair Steven <blair.steven@alliedtelesis.co.nz>
Subject: [PATCH net v5 1/2] net: netfilter: Limit the number of ftp helper port attempts
Date:   Mon, 20 Sep 2021 12:59:04 +1200
Message-Id: <20210920005905.9583-2-Cole.Dishington@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920005905.9583-1-Cole.Dishington@alliedtelesis.co.nz>
References: <20210920005905.9583-1-Cole.Dishington@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=FtN7AFjq c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=7QKq2e-ADPsA:10 a=v0C0h8vM-w728WOTjeQA:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of fixing the port selection of ftp helper when using
NF_NAT_RANGE_PROTO_SPECIFIED, limit the number of ftp helper port
attempts to 128.

Looping a large port range takes too long. Instead select a random
offset within [ntohs(exp->saved_proto.tcp.port), 65535] and try 128
ports.

Co-developed-by: Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>
Signed-off-by: Anthony Lineham <anthony.lineham@alliedtelesis.co.nz>
Co-developed-by: Scott Parlane <scott.parlane@alliedtelesis.co.nz>
Signed-off-by: Scott Parlane <scott.parlane@alliedtelesis.co.nz>
Co-developed-by: Blair Steven <blair.steven@alliedtelesis.co.nz>
Signed-off-by: Blair Steven <blair.steven@alliedtelesis.co.nz>
Signed-off-by: Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
---
 net/netfilter/nf_nat_ftp.c | 39 +++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index aace6768a64e..7dcb4f179ac9 100644
--- a/net/netfilter/nf_nat_ftp.c
+++ b/net/netfilter/nf_nat_ftp.c
@@ -72,8 +72,11 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 	u_int16_t port;
 	int dir =3D CTINFO2DIR(ctinfo);
 	struct nf_conn *ct =3D exp->master;
+	unsigned int i, min, max, range_size;
+	static const unsigned int max_attempts =3D 128;
 	char buffer[sizeof("|1||65535|") + INET6_ADDRSTRLEN];
 	unsigned int buflen;
+	int ret;
=20
 	pr_debug("type %i, off %u len %u\n", type, matchoff, matchlen);
=20
@@ -86,22 +89,32 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
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
+	min =3D ntohs(exp->saved_proto.tcp.port);
+	max =3D 65535;
+
+	/* Try to get same port */
+	ret =3D nf_ct_expect_related(exp, 0);
+
+	/* if same port is not in range or available, try to change it. */
+	if (ret !=3D 0) {
+		range_size =3D max - min + 1;
+		if (range_size > max_attempts)
+			range_size =3D max_attempts;
+
+		port =3D min + prandom_u32_max(max - min);
+		for (i =3D 0; i < range_size; i++) {
+			exp->tuple.dst.u.tcp.port =3D htons(port);
+			ret =3D nf_ct_expect_related(exp, 0);
+			if (ret !=3D -EBUSY)
+				break;
+			port++;
+			if (port > max)
+				port =3D min;
 		}
 	}
=20
-	if (port =3D=3D 0) {
-		nf_ct_helper_log(skb, ct, "all ports in use");
+	if (ret !=3D 0) {
+		nf_ct_helper_log(skb, ct, "tried %u ports, all were in use");
 		return NF_DROP;
 	}
=20
--=20
2.33.0

