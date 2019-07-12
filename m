Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABE2D673EC
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 19:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfGLRCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 13:02:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49412 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726993AbfGLRCb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jul 2019 13:02:31 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 825F8307D986;
        Fri, 12 Jul 2019 17:02:31 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.32.181.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A811F60C6D;
        Fri, 12 Jul 2019 17:02:30 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2-next] tunnel: factorize printout of GRE key and flags
Date:   Fri, 12 Jul 2019 19:02:14 +0200
Message-Id: <547473b8fbab9114f78c1cfe405ccb5f50b0a66b.1562950715.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 12 Jul 2019 17:02:31 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

print_tunnel() functions in ip6tunnel.c and iptunnel.c contains
the same code to print out GRE key and flags

This commit factorize the code in a helper function in tunnel.c

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 ip/ip6tunnel.c | 22 ++--------------------
 ip/iptunnel.c  | 19 ++-----------------
 ip/tunnel.c    | 26 ++++++++++++++++++++++++++
 ip/tunnel.h    |  3 +++
 4 files changed, 33 insertions(+), 37 deletions(-)

diff --git a/ip/ip6tunnel.c b/ip/ip6tunnel.c
index 2e0f099cd7ced..d7684a673fdc4 100644
--- a/ip/ip6tunnel.c
+++ b/ip/ip6tunnel.c
@@ -120,26 +120,8 @@ static void print_tunnel(const void *t)
 	if (p->flags & IP6_TNL_F_ALLOW_LOCAL_REMOTE)
 		printf(" allow-localremote");
 
-	if ((p->i_flags & GRE_KEY) && (p->o_flags & GRE_KEY) &&
-	    p->o_key == p->i_key)
-		printf(" key %u", ntohl(p->i_key));
-	else {
-		if (p->i_flags & GRE_KEY)
-			printf(" ikey %u", ntohl(p->i_key));
-		if (p->o_flags & GRE_KEY)
-			printf(" okey %u", ntohl(p->o_key));
-	}
-
-	if (p->proto == IPPROTO_GRE) {
-		if (p->i_flags & GRE_SEQ)
-			printf("%s  Drop packets out of sequence.", _SL_);
-		if (p->i_flags & GRE_CSUM)
-			printf("%s  Checksum in received packet is required.", _SL_);
-		if (p->o_flags & GRE_SEQ)
-			printf("%s  Sequence packets on output.", _SL_);
-		if (p->o_flags & GRE_CSUM)
-			printf("%s  Checksum output packets.", _SL_);
-	}
+	tnl_print_gre_flags(p->proto, p->i_flags, p->o_flags,
+			    p->i_key, p->o_key);
 }
 
 static int parse_args(int argc, char **argv, int cmd, struct ip6_tnl_parm2 *p)
diff --git a/ip/iptunnel.c b/ip/iptunnel.c
index 92a5cb923b6b0..66929e75c7448 100644
--- a/ip/iptunnel.c
+++ b/ip/iptunnel.c
@@ -354,23 +354,8 @@ static void print_tunnel(const void *t)
 		}
 	}
 
-	if ((p->i_flags & GRE_KEY) && (p->o_flags & GRE_KEY) && p->o_key == p->i_key)
-		printf(" key %u", ntohl(p->i_key));
-	else if ((p->i_flags | p->o_flags) & GRE_KEY) {
-		if (p->i_flags & GRE_KEY)
-			printf(" ikey %u", ntohl(p->i_key));
-		if (p->o_flags & GRE_KEY)
-			printf(" okey %u", ntohl(p->o_key));
-	}
-
-	if (p->i_flags & GRE_SEQ)
-		printf("%s  Drop packets out of sequence.", _SL_);
-	if (p->i_flags & GRE_CSUM)
-		printf("%s  Checksum in received packet is required.", _SL_);
-	if (p->o_flags & GRE_SEQ)
-		printf("%s  Sequence packets on output.", _SL_);
-	if (p->o_flags & GRE_CSUM)
-		printf("%s  Checksum output packets.", _SL_);
+	tnl_print_gre_flags(p->iph.protocol, p->i_flags, p->o_flags,
+			    p->i_key, p->o_key);
 }
 
 
diff --git a/ip/tunnel.c b/ip/tunnel.c
index d0d55f37169e9..41b0ef3165fdc 100644
--- a/ip/tunnel.c
+++ b/ip/tunnel.c
@@ -308,6 +308,32 @@ void tnl_print_endpoint(const char *name, const struct rtattr *rta, int family)
 	}
 }
 
+void tnl_print_gre_flags(__u8 proto,
+			 __be16 i_flags, __be16 o_flags,
+			 __be32 i_key, __be32 o_key)
+{
+	if ((i_flags & GRE_KEY) && (o_flags & GRE_KEY) &&
+	    o_key == i_key) {
+		printf(" key %u", ntohl(i_key));
+	} else {
+		if (i_flags & GRE_KEY)
+			printf(" ikey %u", ntohl(i_key));
+		if (o_flags & GRE_KEY)
+			printf(" okey %u", ntohl(o_key));
+	}
+
+	if (proto == IPPROTO_GRE) {
+		if (i_flags & GRE_SEQ)
+			printf("%s  Drop packets out of sequence.", _SL_);
+		if (i_flags & GRE_CSUM)
+			printf("%s  Checksum in received packet is required.", _SL_);
+		if (o_flags & GRE_SEQ)
+			printf("%s  Sequence packets on output.", _SL_);
+		if (o_flags & GRE_CSUM)
+			printf("%s  Checksum output packets.", _SL_);
+	}
+}
+
 static void tnl_print_stats(const struct rtnl_link_stats64 *s)
 {
 	printf("%s", _SL_);
diff --git a/ip/tunnel.h b/ip/tunnel.h
index e530d07cbf6a2..604f8cbfd6db2 100644
--- a/ip/tunnel.h
+++ b/ip/tunnel.h
@@ -55,5 +55,8 @@ void tnl_print_encap(struct rtattr *tb[],
 		     int encap_sport, int encap_dport);
 void tnl_print_endpoint(const char *name,
 			const struct rtattr *rta, int family);
+void tnl_print_gre_flags(__u8 proto,
+			 __be16 i_flags, __be16 o_flags,
+			 __be32 i_key, __be32 o_key);
 
 #endif
-- 
2.20.1

