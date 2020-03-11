Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A714181B6F
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 15:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbgCKOgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 10:36:02 -0400
Received: from correo.us.es ([193.147.175.20]:43730 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729541AbgCKOgB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 10:36:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D7F17FB36C
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 15:35:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C7DEBDA3A4
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 15:35:37 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BDA60DA3A1; Wed, 11 Mar 2020 15:35:37 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E6D97DA736;
        Wed, 11 Mar 2020 15:35:35 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Mar 2020 15:35:35 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C3E0442EF42B;
        Wed, 11 Mar 2020 15:35:35 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH nft 2/2] src: support for restoring element counters
Date:   Wed, 11 Mar 2020 15:35:53 +0100
Message-Id: <20200311143553.4698-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200311143553.4698-1-pablo@netfilter.org>
References: <20200311143553.4698-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows you to restore counters in dynamic sets:

 table ip test {
        set test {
                type ipv4_addr
                size 65535
                flags dynamic,timeout
                timeout 30d
                gc-interval 1d
                elements = { 192.168.10.13 expires 19d23h52m27s576ms counter packets 51 bytes 17265 }
        }
        chain output {
                type filter hook output priority 0;
                update @test { ip saddr }
        }
 }

You can also add counters to elements from the control place, ie.

 table ip test {
        set test {
                type ipv4_addr
                size 65535
                elements = { 192.168.2.1 counter packets 75 bytes 19043 }
        }

        chain output {
                type filter hook output priority filter; policy accept;
                ip daddr @test
        }
 }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/netlink.h       |  1 +
 src/netlink.c           |  3 +++
 src/netlink_linearize.c |  2 +-
 src/parser_bison.y      | 36 +++++++++++++++++++++++++++++++++++-
 4 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index c2eb89498d72..0a5fde3cf08c 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -113,6 +113,7 @@ extern void netlink_gen_data(const struct expr *expr,
 extern void netlink_gen_raw_data(const mpz_t value, enum byteorder byteorder,
 				 unsigned int len,
 				 struct nft_data_linearize *data);
+extern struct nftnl_expr *netlink_gen_stmt_stateful(const struct stmt *stmt);
 
 extern struct expr *netlink_alloc_value(const struct location *loc,
 				        const struct nft_data_delinearize *nld);
diff --git a/src/netlink.c b/src/netlink.c
index 671923f3eeba..e10af564bcac 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -138,6 +138,9 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 	if (elem->expiration)
 		nftnl_set_elem_set_u64(nlse, NFTNL_SET_ELEM_EXPIRATION,
 				       elem->expiration);
+	if (elem->stmt)
+		nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_EXPR,
+				   netlink_gen_stmt_stateful(elem->stmt), 0);
 	if (elem->comment || expr->elem_flags) {
 		udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
 		if (!udbuf)
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 5b3c43c6c641..e70e63b336cd 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -880,7 +880,7 @@ static struct nftnl_expr *netlink_gen_quota_stmt(const struct stmt *stmt)
 	return nle;
 }
 
-static struct nftnl_expr *netlink_gen_stmt_stateful(const struct stmt *stmt)
+struct nftnl_expr *netlink_gen_stmt_stateful(const struct stmt *stmt)
 {
 	switch (stmt->ops->type) {
 	case STMT_CONNLIMIT:
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 26ce4e089e1e..3d65d20816d6 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3671,7 +3671,7 @@ meter_key_expr_alloc	:	concat_expr
 			;
 
 set_elem_expr		:	set_elem_expr_alloc
-			|	set_elem_expr_alloc		set_elem_options
+			|	set_elem_expr_alloc		set_elem_expr_options
 			;
 
 set_elem_expr_alloc	:	set_lhs_expr
@@ -3701,6 +3701,40 @@ set_elem_option		:	TIMEOUT			time_spec
 			}
 			;
 
+set_elem_expr_options	:	set_elem_expr_option
+			{
+				$<expr>$	= $<expr>0;
+			}
+			|	set_elem_expr_options	set_elem_expr_option
+			;
+
+set_elem_expr_option	:	TIMEOUT			time_spec
+			{
+				$<expr>0->timeout = $2;
+			}
+			|	EXPIRES		time_spec
+			{
+				$<expr>0->expiration = $2;
+			}
+			|	COUNTER
+			{
+				$<expr>0->stmt = counter_stmt_alloc(&@$);
+			}
+			|	COUNTER	PACKETS	NUM	BYTES	NUM
+			{
+				struct stmt *stmt;
+
+				stmt = counter_stmt_alloc(&@$);
+				stmt->counter.packets = $3;
+				stmt->counter.bytes = $5;
+				$<expr>0->stmt = stmt;
+			}
+			|	comment_spec
+			{
+				$<expr>0->comment = $1;
+			}
+			;
+
 set_lhs_expr		:	concat_rhs_expr
 			|	wildcard_expr
 			;
-- 
2.11.0

