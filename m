Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEC18C0AF
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbfHMShT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:37:19 -0400
Received: from correo.us.es ([193.147.175.20]:58752 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfHMShT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 14:37:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BC59CB6323
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:37:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AD68E519E5
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 20:37:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A3193DA704; Tue, 13 Aug 2019 20:37:16 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B9470D190F;
        Tue, 13 Aug 2019 20:37:13 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 20:37:13 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.218.116])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6D68A4265A2F;
        Tue, 13 Aug 2019 20:37:13 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 01/17] netfilter: synproxy: rename mss synproxy_options field
Date:   Tue, 13 Aug 2019 20:36:45 +0200
Message-Id: <20190813183701.4002-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190813183701.4002-1-pablo@netfilter.org>
References: <20190813183701.4002-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

After introduce "mss_encode" field in the synproxy_options struct the field
"mss" is a little confusing. It has been renamed to "mss_option".

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_synproxy.h | 2 +-
 net/ipv4/netfilter/ipt_SYNPROXY.c             | 4 ++--
 net/ipv6/netfilter/ip6t_SYNPROXY.c            | 4 ++--
 net/netfilter/nf_synproxy_core.c              | 8 ++++----
 net/netfilter/nft_synproxy.c                  | 4 ++--
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_synproxy.h b/include/net/netfilter/nf_conntrack_synproxy.h
index 44513b93bd55..2f0171d24997 100644
--- a/include/net/netfilter/nf_conntrack_synproxy.h
+++ b/include/net/netfilter/nf_conntrack_synproxy.h
@@ -67,7 +67,7 @@ static inline struct synproxy_net *synproxy_pernet(struct net *net)
 struct synproxy_options {
 	u8				options;
 	u8				wscale;
-	u16				mss;
+	u16				mss_option;
 	u16				mss_encode;
 	u32				tsval;
 	u32				tsecr;
diff --git a/net/ipv4/netfilter/ipt_SYNPROXY.c b/net/ipv4/netfilter/ipt_SYNPROXY.c
index 0e70f3f65f6f..748dc3ce58d3 100644
--- a/net/ipv4/netfilter/ipt_SYNPROXY.c
+++ b/net/ipv4/netfilter/ipt_SYNPROXY.c
@@ -36,8 +36,8 @@ synproxy_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 			opts.options |= XT_SYNPROXY_OPT_ECN;
 
 		opts.options &= info->options;
-		opts.mss_encode = opts.mss;
-		opts.mss = info->mss;
+		opts.mss_encode = opts.mss_option;
+		opts.mss_option = info->mss;
 		if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP)
 			synproxy_init_timestamp_cookie(info, &opts);
 		else
diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_SYNPROXY.c
index 5cdb4a69d277..fd1f52a21bf1 100644
--- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
+++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
@@ -36,8 +36,8 @@ synproxy_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 			opts.options |= XT_SYNPROXY_OPT_ECN;
 
 		opts.options &= info->options;
-		opts.mss_encode = opts.mss;
-		opts.mss = info->mss;
+		opts.mss_encode = opts.mss_option;
+		opts.mss_option = info->mss;
 		if (opts.options & XT_SYNPROXY_OPT_TIMESTAMP)
 			synproxy_init_timestamp_cookie(info, &opts);
 		else
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index c769462a839e..b0930d4aba22 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -56,7 +56,7 @@ synproxy_parse_options(const struct sk_buff *skb, unsigned int doff,
 			switch (opcode) {
 			case TCPOPT_MSS:
 				if (opsize == TCPOLEN_MSS) {
-					opts->mss = get_unaligned_be16(ptr);
+					opts->mss_option = get_unaligned_be16(ptr);
 					opts->options |= NF_SYNPROXY_OPT_MSS;
 				}
 				break;
@@ -115,7 +115,7 @@ synproxy_build_options(struct tcphdr *th, const struct synproxy_options *opts)
 	if (options & NF_SYNPROXY_OPT_MSS)
 		*ptr++ = htonl((TCPOPT_MSS << 24) |
 			       (TCPOLEN_MSS << 16) |
-			       opts->mss);
+			       opts->mss_option);
 
 	if (options & NF_SYNPROXY_OPT_TIMESTAMP) {
 		if (options & NF_SYNPROXY_OPT_SACK_PERM)
@@ -642,7 +642,7 @@ synproxy_recv_client_ack(struct net *net,
 	}
 
 	this_cpu_inc(snet->stats->cookie_valid);
-	opts->mss = mss;
+	opts->mss_option = mss;
 	opts->options |= NF_SYNPROXY_OPT_MSS;
 
 	if (opts->options & NF_SYNPROXY_OPT_TIMESTAMP)
@@ -1060,7 +1060,7 @@ synproxy_recv_client_ack_ipv6(struct net *net,
 	}
 
 	this_cpu_inc(snet->stats->cookie_valid);
-	opts->mss = mss;
+	opts->mss_option = mss;
 	opts->options |= NF_SYNPROXY_OPT_MSS;
 
 	if (opts->options & NF_SYNPROXY_OPT_TIMESTAMP)
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 928e661d1517..db4c23f5dfcb 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -31,8 +31,8 @@ static void nft_synproxy_tcp_options(struct synproxy_options *opts,
 		opts->options |= NF_SYNPROXY_OPT_ECN;
 
 	opts->options &= priv->info.options;
-	opts->mss_encode = opts->mss;
-	opts->mss = info->mss;
+	opts->mss_encode = opts->mss_option;
+	opts->mss_option = info->mss;
 	if (opts->options & NF_SYNPROXY_OPT_TIMESTAMP)
 		synproxy_init_timestamp_cookie(info, opts);
 	else
-- 
2.11.0


