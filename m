Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 867C5B1C36
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 13:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388166AbfIMLb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 07:31:27 -0400
Received: from correo.us.es ([193.147.175.20]:42632 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387712AbfIMLb1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 16B524FFE15
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0A1D9A7E1A
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:23 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F400DA7E19; Fri, 13 Sep 2019 13:31:22 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D6672A7E1A;
        Fri, 13 Sep 2019 13:31:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A72674265A5A;
        Fri, 13 Sep 2019 13:31:20 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 17/27] netfilter: synproxy: move code between headers.
Date:   Fri, 13 Sep 2019 13:30:52 +0200
Message-Id: <20190913113102.15776-18-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

There is some non-conntrack code in the nf_conntrack_synproxy.h header.
Move it to the nf_synproxy.h header.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_synproxy.h | 39 ---------------------------
 include/net/netfilter/nf_synproxy.h           | 38 ++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 39 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_synproxy.h b/include/net/netfilter/nf_conntrack_synproxy.h
index 2f0171d24997..c22f0c11cc82 100644
--- a/include/net/netfilter/nf_conntrack_synproxy.h
+++ b/include/net/netfilter/nf_conntrack_synproxy.h
@@ -43,43 +43,4 @@ static inline bool nf_ct_add_synproxy(struct nf_conn *ct,
 	return true;
 }
 
-struct synproxy_stats {
-	unsigned int			syn_received;
-	unsigned int			cookie_invalid;
-	unsigned int			cookie_valid;
-	unsigned int			cookie_retrans;
-	unsigned int			conn_reopened;
-};
-
-struct synproxy_net {
-	struct nf_conn			*tmpl;
-	struct synproxy_stats __percpu	*stats;
-	unsigned int			hook_ref4;
-	unsigned int			hook_ref6;
-};
-
-extern unsigned int synproxy_net_id;
-static inline struct synproxy_net *synproxy_pernet(struct net *net)
-{
-	return net_generic(net, synproxy_net_id);
-}
-
-struct synproxy_options {
-	u8				options;
-	u8				wscale;
-	u16				mss_option;
-	u16				mss_encode;
-	u32				tsval;
-	u32				tsecr;
-};
-
-struct tcphdr;
-struct nf_synproxy_info;
-bool synproxy_parse_options(const struct sk_buff *skb, unsigned int doff,
-			    const struct tcphdr *th,
-			    struct synproxy_options *opts);
-
-void synproxy_init_timestamp_cookie(const struct nf_synproxy_info *info,
-				    struct synproxy_options *opts);
-
 #endif /* _NF_CONNTRACK_SYNPROXY_H */
diff --git a/include/net/netfilter/nf_synproxy.h b/include/net/netfilter/nf_synproxy.h
index dc420b47e3aa..19d1af7a0348 100644
--- a/include/net/netfilter/nf_synproxy.h
+++ b/include/net/netfilter/nf_synproxy.h
@@ -11,6 +11,44 @@
 #include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netfilter/nf_conntrack_synproxy.h>
 
+struct synproxy_stats {
+	unsigned int			syn_received;
+	unsigned int			cookie_invalid;
+	unsigned int			cookie_valid;
+	unsigned int			cookie_retrans;
+	unsigned int			conn_reopened;
+};
+
+struct synproxy_net {
+	struct nf_conn			*tmpl;
+	struct synproxy_stats __percpu	*stats;
+	unsigned int			hook_ref4;
+	unsigned int			hook_ref6;
+};
+
+extern unsigned int synproxy_net_id;
+static inline struct synproxy_net *synproxy_pernet(struct net *net)
+{
+	return net_generic(net, synproxy_net_id);
+}
+
+struct synproxy_options {
+	u8				options;
+	u8				wscale;
+	u16				mss_option;
+	u16				mss_encode;
+	u32				tsval;
+	u32				tsecr;
+};
+
+struct nf_synproxy_info;
+bool synproxy_parse_options(const struct sk_buff *skb, unsigned int doff,
+			    const struct tcphdr *th,
+			    struct synproxy_options *opts);
+
+void synproxy_init_timestamp_cookie(const struct nf_synproxy_info *info,
+				    struct synproxy_options *opts);
+
 void synproxy_send_client_synack(struct net *net, const struct sk_buff *skb,
 				 const struct tcphdr *th,
 				 const struct synproxy_options *opts);
-- 
2.11.0

