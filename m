Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB90CB1C4E
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 13:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388227AbfIMLbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 07:31:50 -0400
Received: from correo.us.es ([193.147.175.20]:42602 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388145AbfIMLbZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9747B4FFE0D
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8955AA7E21
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:22 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7EC3AA7E18; Fri, 13 Sep 2019 13:31:22 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 53885A7E16;
        Fri, 13 Sep 2019 13:31:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1FF094265A5A;
        Fri, 13 Sep 2019 13:31:20 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 16/27] netfilter: move inline nf_ip6_ext_hdr() function to a more appropriate header.
Date:   Fri, 13 Sep 2019 13:30:51 +0200
Message-Id: <20190913113102.15776-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

There is an inline function in ip6_tables.h which is not specific to
ip6tables and is used elswhere in netfilter.  Move it into
netfilter_ipv6.h and update the callers.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter_ipv6.h            | 12 ++++++++++++
 include/linux/netfilter_ipv6/ip6_tables.h | 12 ------------
 net/ipv6/netfilter/ip6t_ipv6header.c      |  4 ++--
 net/ipv6/netfilter/nf_log_ipv6.c          |  4 ++--
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index a889e376d197..c1500209cfaf 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -10,6 +10,18 @@
 #include <uapi/linux/netfilter_ipv6.h>
 #include <net/tcp.h>
 
+/* Check for an extension */
+static inline int
+nf_ip6_ext_hdr(u8 nexthdr)
+{	return (nexthdr == IPPROTO_HOPOPTS) ||
+	       (nexthdr == IPPROTO_ROUTING) ||
+	       (nexthdr == IPPROTO_FRAGMENT) ||
+	       (nexthdr == IPPROTO_ESP) ||
+	       (nexthdr == IPPROTO_AH) ||
+	       (nexthdr == IPPROTO_NONE) ||
+	       (nexthdr == IPPROTO_DSTOPTS);
+}
+
 /* Extra routing may needed on local out, as the QUEUE target never returns
  * control to the table.
  */
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 666450c117bf..3a0a2bd054cc 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -36,18 +36,6 @@ extern unsigned int ip6t_do_table(struct sk_buff *skb,
 				  struct xt_table *table);
 #endif
 
-/* Check for an extension */
-static inline int
-ip6t_ext_hdr(u8 nexthdr)
-{	return (nexthdr == IPPROTO_HOPOPTS) ||
-	       (nexthdr == IPPROTO_ROUTING) ||
-	       (nexthdr == IPPROTO_FRAGMENT) ||
-	       (nexthdr == IPPROTO_ESP) ||
-	       (nexthdr == IPPROTO_AH) ||
-	       (nexthdr == IPPROTO_NONE) ||
-	       (nexthdr == IPPROTO_DSTOPTS);
-}
-
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
 
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index 0fc6326ef499..c52ff929c93b 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -16,7 +16,7 @@
 #include <net/ipv6.h>
 
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6.h>
 #include <linux/netfilter_ipv6/ip6t_ipv6header.h>
 
 MODULE_LICENSE("GPL");
@@ -42,7 +42,7 @@ ipv6header_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	len = skb->len - ptr;
 	temp = 0;
 
-	while (ip6t_ext_hdr(nexthdr)) {
+	while (nf_ip6_ext_hdr(nexthdr)) {
 		const struct ipv6_opt_hdr *hp;
 		struct ipv6_opt_hdr _hdr;
 		int hdrlen;
diff --git a/net/ipv6/netfilter/nf_log_ipv6.c b/net/ipv6/netfilter/nf_log_ipv6.c
index f53bd8f01219..22b80db6d882 100644
--- a/net/ipv6/netfilter/nf_log_ipv6.c
+++ b/net/ipv6/netfilter/nf_log_ipv6.c
@@ -18,7 +18,7 @@
 #include <net/route.h>
 
 #include <linux/netfilter.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6.h>
 #include <linux/netfilter/xt_LOG.h>
 #include <net/netfilter/nf_log.h>
 
@@ -70,7 +70,7 @@ static void dump_ipv6_packet(struct net *net, struct nf_log_buf *m,
 	fragment = 0;
 	ptr = ip6hoff + sizeof(struct ipv6hdr);
 	currenthdr = ih->nexthdr;
-	while (currenthdr != NEXTHDR_NONE && ip6t_ext_hdr(currenthdr)) {
+	while (currenthdr != NEXTHDR_NONE && nf_ip6_ext_hdr(currenthdr)) {
 		struct ipv6_opt_hdr _hdr;
 		const struct ipv6_opt_hdr *hp;
 
-- 
2.11.0

