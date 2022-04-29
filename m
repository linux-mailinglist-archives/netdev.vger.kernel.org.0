Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52AF514087
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 04:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353703AbiD2CR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 22:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235150AbiD2CR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 22:17:26 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C146DC0D10;
        Thu, 28 Apr 2022 19:14:09 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 727FB1E80D76;
        Fri, 29 Apr 2022 10:10:31 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CcZscM8q0qGo; Fri, 29 Apr 2022 10:10:28 +0800 (CST)
Received: from ubuntu.localdomain (unknown [101.228.155.226])
        (Authenticated sender: yuzhe@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 246A11E80D6E;
        Fri, 29 Apr 2022 10:10:28 +0800 (CST)
From:   Yu Zhe <yuzhe@nfschina.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com, hukun@nfschina.com,
        Yu Zhe <yuzhe@nfschina.com>
Subject: [PATCH] ipv4: remove unnecessary type castings
Date:   Thu, 28 Apr 2022 19:14:04 -0700
Message-Id: <20220429021404.1648570-1-yuzhe@nfschina.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

remove unnecessary void* type castings.

Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
---
 net/ipv4/fib_frontend.c  | 4 ++--
 net/ipv4/fib_rules.c     | 2 +-
 net/ipv4/fib_trie.c      | 2 +-
 net/ipv4/icmp.c          | 2 +-
 net/ipv4/igmp.c          | 4 ++--
 net/ipv4/inet_fragment.c | 2 +-
 net/ipv4/ipmr.c          | 2 +-
 net/ipv4/ping.c          | 2 +-
 8 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index af8209f912ab..f361d3d56be2 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1384,7 +1384,7 @@ static void nl_fib_input(struct sk_buff *skb)
 		return;
 	nlh = nlmsg_hdr(skb);
 
-	frn = (struct fib_result_nl *) nlmsg_data(nlh);
+	frn = nlmsg_data(nlh);
 	nl_fib_lookup(net, frn);
 
 	portid = NETLINK_CB(skb).portid;      /* netlink portid */
@@ -1425,7 +1425,7 @@ static void fib_disable_ip(struct net_device *dev, unsigned long event,
 
 static int fib_inetaddr_event(struct notifier_block *this, unsigned long event, void *ptr)
 {
-	struct in_ifaddr *ifa = (struct in_ifaddr *)ptr;
+	struct in_ifaddr *ifa = ptr;
 	struct net_device *dev = ifa->ifa_dev->dev;
 	struct net *net = dev_net(dev);
 
diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
index 001fea394bde..513f475c6a53 100644
--- a/net/ipv4/fib_rules.c
+++ b/net/ipv4/fib_rules.c
@@ -145,7 +145,7 @@ INDIRECT_CALLABLE_SCOPE bool fib4_rule_suppress(struct fib_rule *rule,
 						int flags,
 						struct fib_lookup_arg *arg)
 {
-	struct fib_result *result = (struct fib_result *) arg->result;
+	struct fib_result *result = arg->result;
 	struct net_device *dev = NULL;
 
 	if (result->fi) {
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index fb0e49c36c2e..b8b016040b70 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2625,7 +2625,7 @@ static void fib_table_print(struct seq_file *seq, struct fib_table *tb)
 
 static int fib_triestat_seq_show(struct seq_file *seq, void *v)
 {
-	struct net *net = (struct net *)seq->private;
+	struct net *net = seq->private;
 	unsigned int h;
 
 	seq_printf(seq,
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 72a375c7f417..7457eeb809f0 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -342,7 +342,7 @@ void icmp_out_count(struct net *net, unsigned char type)
 static int icmp_glue_bits(void *from, char *to, int offset, int len, int odd,
 			  struct sk_buff *skb)
 {
-	struct icmp_bxm *icmp_param = (struct icmp_bxm *)from;
+	struct icmp_bxm *icmp_param = from;
 	__wsum csum;
 
 	csum = skb_copy_and_csum_bits(icmp_param->skb,
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 2ad3c7b42d6d..1ba8ebc439f3 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2836,7 +2836,7 @@ static int igmp_mc_seq_show(struct seq_file *seq, void *v)
 		seq_puts(seq,
 			 "Idx\tDevice    : Count Querier\tGroup    Users Timer\tReporter\n");
 	else {
-		struct ip_mc_list *im = (struct ip_mc_list *)v;
+		struct ip_mc_list *im = v;
 		struct igmp_mc_iter_state *state = igmp_mc_seq_private(seq);
 		char   *querier;
 		long delta;
@@ -2980,7 +2980,7 @@ static void igmp_mcf_seq_stop(struct seq_file *seq, void *v)
 
 static int igmp_mcf_seq_show(struct seq_file *seq, void *v)
 {
-	struct ip_sf_list *psf = (struct ip_sf_list *)v;
+	struct ip_sf_list *psf = v;
 	struct igmp_mcf_iter_state *state = igmp_mcf_seq_private(seq);
 
 	if (v == SEQ_START_TOKEN) {
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 63948f6aeca0..c9f9ac5013a7 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -510,7 +510,7 @@ EXPORT_SYMBOL(inet_frag_reasm_prepare);
 void inet_frag_reasm_finish(struct inet_frag_queue *q, struct sk_buff *head,
 			    void *reasm_data, bool try_coalesce)
 {
-	struct sk_buff **nextp = (struct sk_buff **)reasm_data;
+	struct sk_buff **nextp = reasm_data;
 	struct rb_node *rbn;
 	struct sk_buff *fp;
 	int sum_truesize;
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index c860519d57ee..13e6329784fb 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -356,7 +356,7 @@ static inline int ipmr_hash_cmp(struct rhashtable_compare_arg *arg,
 				const void *ptr)
 {
 	const struct mfc_cache_cmp_arg *cmparg = arg->key;
-	struct mfc_cache *c = (struct mfc_cache *)ptr;
+	const struct mfc_cache *c = ptr;
 
 	return cmparg->mfc_mcastgrp != c->mfc_mcastgrp ||
 	       cmparg->mfc_origin != c->mfc_origin;
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 3ee947557b88..db83577bd5ee 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -590,7 +590,7 @@ EXPORT_SYMBOL_GPL(ping_err);
 int ping_getfrag(void *from, char *to,
 		 int offset, int fraglen, int odd, struct sk_buff *skb)
 {
-	struct pingfakehdr *pfh = (struct pingfakehdr *)from;
+	struct pingfakehdr *pfh = from;
 
 	if (offset == 0) {
 		fraglen -= sizeof(struct icmphdr);
-- 
2.25.1

