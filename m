Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6E0A5B08D1
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiIGPlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiIGPls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:41:48 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F2DB08A9;
        Wed,  7 Sep 2022 08:41:46 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oVxBO-00068C-8O; Wed, 07 Sep 2022 17:41:42 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 7/8] netfilter: nat: move repetitive nat port reserve loop to a helper
Date:   Wed,  7 Sep 2022 17:41:09 +0200
Message-Id: <20220907154110.8898-8-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220907154110.8898-1-fw@strlen.de>
References: <20220907154110.8898-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Almost all nat helpers reserve an expecation port the same way:
Try the port inidcated by the peer, then move to next port if that
port is already in use.

We can squash this into a helper.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_nat_helper.h |  1 +
 net/ipv4/netfilter/nf_nat_h323.c      | 60 ++-------------------------
 net/netfilter/nf_nat_amanda.c         | 14 +------
 net/netfilter/nf_nat_ftp.c            | 17 +-------
 net/netfilter/nf_nat_helper.c         | 19 +++++++++
 net/netfilter/nf_nat_irc.c            | 16 +------
 net/netfilter/nf_nat_sip.c            | 14 +------
 7 files changed, 30 insertions(+), 111 deletions(-)

diff --git a/include/net/netfilter/nf_nat_helper.h b/include/net/netfilter/nf_nat_helper.h
index efae84646353..44c421b9be85 100644
--- a/include/net/netfilter/nf_nat_helper.h
+++ b/include/net/netfilter/nf_nat_helper.h
@@ -38,4 +38,5 @@ bool nf_nat_mangle_udp_packet(struct sk_buff *skb, struct nf_conn *ct,
  * to port ct->master->saved_proto. */
 void nf_nat_follow_master(struct nf_conn *ct, struct nf_conntrack_expect *this);
 
+u16 nf_nat_exp_find_port(struct nf_conntrack_expect *exp, u16 port);
 #endif
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index a334f0dcc2d0..faee20af4856 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -291,20 +291,7 @@ static int nat_t120(struct sk_buff *skb, struct nf_conn *ct,
 	exp->expectfn = nf_nat_follow_master;
 	exp->dir = !dir;
 
-	/* Try to get same port: if not, try to change it. */
-	for (; nated_port != 0; nated_port++) {
-		int ret;
-
-		exp->tuple.dst.u.tcp.port = htons(nated_port);
-		ret = nf_ct_expect_related(exp, 0);
-		if (ret == 0)
-			break;
-		else if (ret != -EBUSY) {
-			nated_port = 0;
-			break;
-		}
-	}
-
+	nated_port = nf_nat_exp_find_port(exp, nated_port);
 	if (nated_port == 0) {	/* No port available */
 		net_notice_ratelimited("nf_nat_h323: out of TCP ports\n");
 		return 0;
@@ -347,20 +334,7 @@ static int nat_h245(struct sk_buff *skb, struct nf_conn *ct,
 	if (info->sig_port[dir] == port)
 		nated_port = ntohs(info->sig_port[!dir]);
 
-	/* Try to get same port: if not, try to change it. */
-	for (; nated_port != 0; nated_port++) {
-		int ret;
-
-		exp->tuple.dst.u.tcp.port = htons(nated_port);
-		ret = nf_ct_expect_related(exp, 0);
-		if (ret == 0)
-			break;
-		else if (ret != -EBUSY) {
-			nated_port = 0;
-			break;
-		}
-	}
-
+	nated_port = nf_nat_exp_find_port(exp, nated_port);
 	if (nated_port == 0) {	/* No port available */
 		net_notice_ratelimited("nf_nat_q931: out of TCP ports\n");
 		return 0;
@@ -439,20 +413,7 @@ static int nat_q931(struct sk_buff *skb, struct nf_conn *ct,
 	if (info->sig_port[dir] == port)
 		nated_port = ntohs(info->sig_port[!dir]);
 
-	/* Try to get same port: if not, try to change it. */
-	for (; nated_port != 0; nated_port++) {
-		int ret;
-
-		exp->tuple.dst.u.tcp.port = htons(nated_port);
-		ret = nf_ct_expect_related(exp, 0);
-		if (ret == 0)
-			break;
-		else if (ret != -EBUSY) {
-			nated_port = 0;
-			break;
-		}
-	}
-
+	nated_port = nf_nat_exp_find_port(exp, nated_port);
 	if (nated_port == 0) {	/* No port available */
 		net_notice_ratelimited("nf_nat_ras: out of TCP ports\n");
 		return 0;
@@ -532,20 +493,7 @@ static int nat_callforwarding(struct sk_buff *skb, struct nf_conn *ct,
 	exp->expectfn = ip_nat_callforwarding_expect;
 	exp->dir = !dir;
 
-	/* Try to get same port: if not, try to change it. */
-	for (nated_port = ntohs(port); nated_port != 0; nated_port++) {
-		int ret;
-
-		exp->tuple.dst.u.tcp.port = htons(nated_port);
-		ret = nf_ct_expect_related(exp, 0);
-		if (ret == 0)
-			break;
-		else if (ret != -EBUSY) {
-			nated_port = 0;
-			break;
-		}
-	}
-
+	nated_port = nf_nat_exp_find_port(exp, ntohs(port));
 	if (nated_port == 0) {	/* No port available */
 		net_notice_ratelimited("nf_nat_q931: out of TCP ports\n");
 		return 0;
diff --git a/net/netfilter/nf_nat_amanda.c b/net/netfilter/nf_nat_amanda.c
index 3bc7e0854efe..98deef6cde69 100644
--- a/net/netfilter/nf_nat_amanda.c
+++ b/net/netfilter/nf_nat_amanda.c
@@ -44,19 +44,7 @@ static unsigned int help(struct sk_buff *skb,
 	exp->expectfn = nf_nat_follow_master;
 
 	/* Try to get same port: if not, try to change it. */
-	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
-		int res;
-
-		exp->tuple.dst.u.tcp.port = htons(port);
-		res = nf_ct_expect_related(exp, 0);
-		if (res == 0)
-			break;
-		else if (res != -EBUSY) {
-			port = 0;
-			break;
-		}
-	}
-
+	port = nf_nat_exp_find_port(exp, ntohs(exp->saved_proto.tcp.port));
 	if (port == 0) {
 		nf_ct_helper_log(skb, exp->master, "all ports in use");
 		return NF_DROP;
diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index aace6768a64e..c92a436d9c48 100644
--- a/net/netfilter/nf_nat_ftp.c
+++ b/net/netfilter/nf_nat_ftp.c
@@ -86,22 +86,9 @@ static unsigned int nf_nat_ftp(struct sk_buff *skb,
 	 * this one. */
 	exp->expectfn = nf_nat_follow_master;
 
-	/* Try to get same port: if not, try to change it. */
-	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
-		int ret;
-
-		exp->tuple.dst.u.tcp.port = htons(port);
-		ret = nf_ct_expect_related(exp, 0);
-		if (ret == 0)
-			break;
-		else if (ret != -EBUSY) {
-			port = 0;
-			break;
-		}
-	}
-
+	port = nf_nat_exp_find_port(exp, ntohs(exp->saved_proto.tcp.port));
 	if (port == 0) {
-		nf_ct_helper_log(skb, ct, "all ports in use");
+		nf_ct_helper_log(skb, exp->master, "all ports in use");
 		return NF_DROP;
 	}
 
diff --git a/net/netfilter/nf_nat_helper.c b/net/netfilter/nf_nat_helper.c
index a263505455fc..067d6d6f6b7d 100644
--- a/net/netfilter/nf_nat_helper.c
+++ b/net/netfilter/nf_nat_helper.c
@@ -198,3 +198,22 @@ void nf_nat_follow_master(struct nf_conn *ct,
 	nf_nat_setup_info(ct, &range, NF_NAT_MANIP_DST);
 }
 EXPORT_SYMBOL(nf_nat_follow_master);
+
+u16 nf_nat_exp_find_port(struct nf_conntrack_expect *exp, u16 port)
+{
+	/* Try to get same port: if not, try to change it. */
+	for (; port != 0; port++) {
+		int res;
+
+		exp->tuple.dst.u.tcp.port = htons(port);
+		res = nf_ct_expect_related(exp, 0);
+		if (res == 0)
+			return port;
+
+		if (res != -EBUSY)
+			break;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nf_nat_exp_find_port);
diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index c691ab8d234c..19c4fcc60c50 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -48,20 +48,8 @@ static unsigned int help(struct sk_buff *skb,
 	exp->dir = IP_CT_DIR_REPLY;
 	exp->expectfn = nf_nat_follow_master;
 
-	/* Try to get same port: if not, try to change it. */
-	for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
-		int ret;
-
-		exp->tuple.dst.u.tcp.port = htons(port);
-		ret = nf_ct_expect_related(exp, 0);
-		if (ret == 0)
-			break;
-		else if (ret != -EBUSY) {
-			port = 0;
-			break;
-		}
-	}
-
+	port = nf_nat_exp_find_port(exp,
+				    ntohs(exp->saved_proto.tcp.port));
 	if (port == 0) {
 		nf_ct_helper_log(skb, ct, "all ports in use");
 		return NF_DROP;
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index f0a735e86851..cf4aeb299bde 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -410,19 +410,7 @@ static unsigned int nf_nat_sip_expect(struct sk_buff *skb, unsigned int protoff,
 	exp->dir = !dir;
 	exp->expectfn = nf_nat_sip_expected;
 
-	for (; port != 0; port++) {
-		int ret;
-
-		exp->tuple.dst.u.udp.port = htons(port);
-		ret = nf_ct_expect_related(exp, NF_CT_EXP_F_SKIP_MASTER);
-		if (ret == 0)
-			break;
-		else if (ret != -EBUSY) {
-			port = 0;
-			break;
-		}
-	}
-
+	port = nf_nat_exp_find_port(exp, port);
 	if (port == 0) {
 		nf_ct_helper_log(skb, ct, "all ports in use for SIP");
 		return NF_DROP;
-- 
2.35.1

