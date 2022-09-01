Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED405A8F76
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 09:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbiIAHNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 03:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233604AbiIAHM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 03:12:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61881E1936;
        Thu,  1 Sep 2022 00:12:57 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oTeNj-0000XB-T1; Thu, 01 Sep 2022 09:12:55 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, netfilter-devel@vger.kernel.org,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCH net 1/4] netfilter: remove nf_conntrack_helper sysctl and modparam toggles
Date:   Thu,  1 Sep 2022 09:12:35 +0200
Message-Id: <20220901071238.3044-2-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220901071238.3044-1-fw@strlen.de>
References: <20220901071238.3044-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,LOTS_OF_MONEY,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

__nf_ct_try_assign_helper() remains in place but it now requires a
template to configure the helper.

A toggle to disable automatic helper assignment was added by:

  a9006892643a ("netfilter: nf_ct_helper: allow to disable automatic helper assignment")

in 2012 to address the issues described in "Secure use of iptables and
connection tracking helpers". Automatic conntrack helper assignment was
disabled by:

  3bb398d925ec ("netfilter: nf_ct_helper: disable automatic helper assignment")

back in 2016.

This patch removes the sysctl and modparam toggles, users now have to
rely on explicit conntrack helper configuration via ruleset.

Update tools/testing/selftests/netfilter/nft_conntrack_helper.sh to
check that auto-assignment does not happen anymore.

Acked-by: Aaron Conole <aconole@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h          |  2 -
 include/net/netns/conntrack.h                 |  1 -
 net/netfilter/nf_conntrack_core.c             |  7 +-
 net/netfilter/nf_conntrack_helper.c           | 80 +++----------------
 net/netfilter/nf_conntrack_netlink.c          |  5 --
 net/netfilter/nf_conntrack_standalone.c       | 10 ---
 net/netfilter/nft_ct.c                        |  3 -
 .../netfilter/nft_conntrack_helper.sh         | 36 ++++++---
 8 files changed, 37 insertions(+), 107 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index a32be8aa7ed2..6a2019aaa464 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -53,8 +53,6 @@ struct nf_conntrack_net {
 	/* only used when new connection is allocated: */
 	atomic_t count;
 	unsigned int expect_count;
-	u8 sysctl_auto_assign_helper;
-	bool auto_assign_helper_warned;
 
 	/* only used from work queues, configuration plane, and so on: */
 	unsigned int users4;
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index c396a3862e80..e1290c159184 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -101,7 +101,6 @@ struct netns_ct {
 	u8			sysctl_log_invalid; /* Log invalid packets */
 	u8			sysctl_events;
 	u8			sysctl_acct;
-	u8			sysctl_auto_assign_helper;
 	u8			sysctl_tstamp;
 	u8			sysctl_checksum;
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 71c2f4f95d36..1357a2729a4b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1782,7 +1782,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 		}
 		spin_unlock_bh(&nf_conntrack_expect_lock);
 	}
-	if (!exp)
+	if (!exp && tmpl)
 		__nf_ct_try_assign_helper(ct, tmpl, GFP_ATOMIC);
 
 	/* Other CPU might have obtained a pointer to this object before it was
@@ -2068,10 +2068,6 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 	ct->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
 	if (ct->master || (help && !hlist_empty(&help->expectations)))
 		return;
-
-	rcu_read_lock();
-	__nf_ct_try_assign_helper(ct, NULL, GFP_ATOMIC);
-	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_alter_reply);
 
@@ -2797,7 +2793,6 @@ int nf_conntrack_init_net(struct net *net)
 	nf_conntrack_acct_pernet_init(net);
 	nf_conntrack_tstamp_pernet_init(net);
 	nf_conntrack_ecache_pernet_init(net);
-	nf_conntrack_helper_pernet_init(net);
 	nf_conntrack_proto_pernet_init(net);
 
 	return 0;
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index e96b32221444..ff737a76052e 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -35,11 +35,6 @@ unsigned int nf_ct_helper_hsize __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_helper_hsize);
 static unsigned int nf_ct_helper_count __read_mostly;
 
-static bool nf_ct_auto_assign_helper __read_mostly = false;
-module_param_named(nf_conntrack_helper, nf_ct_auto_assign_helper, bool, 0644);
-MODULE_PARM_DESC(nf_conntrack_helper,
-		 "Enable automatic conntrack helper assignment (default 0)");
-
 static DEFINE_MUTEX(nf_ct_nat_helpers_mutex);
 static struct list_head nf_ct_nat_helpers __read_mostly;
 
@@ -51,24 +46,6 @@ static unsigned int helper_hash(const struct nf_conntrack_tuple *tuple)
 		(__force __u16)tuple->src.u.all) % nf_ct_helper_hsize;
 }
 
-static struct nf_conntrack_helper *
-__nf_ct_helper_find(const struct nf_conntrack_tuple *tuple)
-{
-	struct nf_conntrack_helper *helper;
-	struct nf_conntrack_tuple_mask mask = { .src.u.all = htons(0xFFFF) };
-	unsigned int h;
-
-	if (!nf_ct_helper_count)
-		return NULL;
-
-	h = helper_hash(tuple);
-	hlist_for_each_entry_rcu(helper, &nf_ct_helper_hash[h], hnode) {
-		if (nf_ct_tuple_src_mask_cmp(tuple, &helper->tuple, &mask))
-			return helper;
-	}
-	return NULL;
-}
-
 struct nf_conntrack_helper *
 __nf_conntrack_helper_find(const char *name, u16 l3num, u8 protonum)
 {
@@ -209,33 +186,11 @@ nf_ct_helper_ext_add(struct nf_conn *ct, gfp_t gfp)
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper_ext_add);
 
-static struct nf_conntrack_helper *
-nf_ct_lookup_helper(struct nf_conn *ct, struct net *net)
-{
-	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
-
-	if (!cnet->sysctl_auto_assign_helper) {
-		if (cnet->auto_assign_helper_warned)
-			return NULL;
-		if (!__nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple))
-			return NULL;
-		pr_info("nf_conntrack: default automatic helper assignment "
-			"has been turned off for security reasons and CT-based "
-			"firewall rule not found. Use the iptables CT target "
-			"to attach helpers instead.\n");
-		cnet->auto_assign_helper_warned = true;
-		return NULL;
-	}
-
-	return __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
-}
-
 int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 			      gfp_t flags)
 {
 	struct nf_conntrack_helper *helper = NULL;
 	struct nf_conn_help *help;
-	struct net *net = nf_ct_net(ct);
 
 	/* We already got a helper explicitly attached. The function
 	 * nf_conntrack_alter_reply - in case NAT is in use - asks for looking
@@ -246,23 +201,21 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 	if (test_bit(IPS_HELPER_BIT, &ct->status))
 		return 0;
 
-	if (tmpl != NULL) {
-		help = nfct_help(tmpl);
-		if (help != NULL) {
-			helper = rcu_dereference(help->helper);
-			set_bit(IPS_HELPER_BIT, &ct->status);
-		}
+	if (WARN_ON_ONCE(!tmpl))
+		return 0;
+
+	help = nfct_help(tmpl);
+	if (help != NULL) {
+		helper = rcu_dereference(help->helper);
+		set_bit(IPS_HELPER_BIT, &ct->status);
 	}
 
 	help = nfct_help(ct);
 
 	if (helper == NULL) {
-		helper = nf_ct_lookup_helper(ct, net);
-		if (helper == NULL) {
-			if (help)
-				RCU_INIT_POINTER(help->helper, NULL);
-			return 0;
-		}
+		if (help)
+			RCU_INIT_POINTER(help->helper, NULL);
+		return 0;
 	}
 
 	if (help == NULL) {
@@ -545,19 +498,6 @@ void nf_nat_helper_unregister(struct nf_conntrack_nat_helper *nat)
 }
 EXPORT_SYMBOL_GPL(nf_nat_helper_unregister);
 
-void nf_ct_set_auto_assign_helper_warned(struct net *net)
-{
-	nf_ct_pernet(net)->auto_assign_helper_warned = true;
-}
-EXPORT_SYMBOL_GPL(nf_ct_set_auto_assign_helper_warned);
-
-void nf_conntrack_helper_pernet_init(struct net *net)
-{
-	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
-
-	cnet->sysctl_auto_assign_helper = nf_ct_auto_assign_helper;
-}
-
 int nf_conntrack_helper_init(void)
 {
 	nf_ct_helper_hsize = 1; /* gets rounded up to use one page */
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 04169b54f2a2..7562b215b932 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2298,11 +2298,6 @@ ctnetlink_create_conntrack(struct net *net,
 			ct->status |= IPS_HELPER;
 			RCU_INIT_POINTER(help->helper, helper);
 		}
-	} else {
-		/* try an implicit helper assignation */
-		err = __nf_ct_try_assign_helper(ct, NULL, GFP_ATOMIC);
-		if (err < 0)
-			goto err2;
 	}
 
 	err = ctnetlink_setup_nat(ct, cda);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 05895878610c..4ffe84c5a82c 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -561,7 +561,6 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_LOG_INVALID,
 	NF_SYSCTL_CT_EXPECT_MAX,
 	NF_SYSCTL_CT_ACCT,
-	NF_SYSCTL_CT_HELPER,
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	NF_SYSCTL_CT_EVENTS,
 #endif
@@ -680,14 +679,6 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.extra1 	= SYSCTL_ZERO,
 		.extra2 	= SYSCTL_ONE,
 	},
-	[NF_SYSCTL_CT_HELPER] = {
-		.procname	= "nf_conntrack_helper",
-		.maxlen		= sizeof(u8),
-		.mode		= 0644,
-		.proc_handler	= proc_dou8vec_minmax,
-		.extra1 	= SYSCTL_ZERO,
-		.extra2 	= SYSCTL_ONE,
-	},
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	[NF_SYSCTL_CT_EVENTS] = {
 		.procname	= "nf_conntrack_events",
@@ -1100,7 +1091,6 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	table[NF_SYSCTL_CT_CHECKSUM].data = &net->ct.sysctl_checksum;
 	table[NF_SYSCTL_CT_LOG_INVALID].data = &net->ct.sysctl_log_invalid;
 	table[NF_SYSCTL_CT_ACCT].data = &net->ct.sysctl_acct;
-	table[NF_SYSCTL_CT_HELPER].data = &cnet->sysctl_auto_assign_helper;
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	table[NF_SYSCTL_CT_EVENTS].data = &net->ct.sysctl_events;
 #endif
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index b04995c3e17f..a3f01f209a53 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1089,9 +1089,6 @@ static int nft_ct_helper_obj_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		goto err_put_helper;
 
-	/* Avoid the bogus warning, helper will be assigned after CT init */
-	nf_ct_set_auto_assign_helper_warned(ctx->net);
-
 	return 0;
 
 err_put_helper:
diff --git a/tools/testing/selftests/netfilter/nft_conntrack_helper.sh b/tools/testing/selftests/netfilter/nft_conntrack_helper.sh
index bf6b9626c7dd..faa7778d7bd1 100755
--- a/tools/testing/selftests/netfilter/nft_conntrack_helper.sh
+++ b/tools/testing/selftests/netfilter/nft_conntrack_helper.sh
@@ -102,26 +102,42 @@ check_for_helper()
 
 	ip netns exec ${netns} conntrack -L -f $family -p tcp --dport $port 2> /dev/null |grep -q 'helper=ftp'
 	if [ $? -ne 0 ] ; then
-		echo "FAIL: ${netns} did not show attached helper $message" 1>&2
-		ret=1
+		if [ $autoassign -eq 0 ] ;then
+			echo "FAIL: ${netns} did not show attached helper $message" 1>&2
+			ret=1
+		else
+			echo "PASS: ${netns} did not show attached helper $message" 1>&2
+		fi
+	else
+		if [ $autoassign -eq 0 ] ;then
+			echo "PASS: ${netns} connection on port $port has ftp helper attached" 1>&2
+		else
+			echo "FAIL: ${netns} connection on port $port has ftp helper attached" 1>&2
+			ret=1
+		fi
 	fi
 
-	echo "PASS: ${netns} connection on port $port has ftp helper attached" 1>&2
 	return 0
 }
 
 test_helper()
 {
 	local port=$1
-	local msg=$2
+	local autoassign=$2
+
+	if [ $autoassign -eq 0 ] ;then
+		msg="set via ruleset"
+	else
+		msg="auto-assign"
+	fi
 
 	sleep 3 | ip netns exec ${ns2} nc -w 2 -l -p $port > /dev/null &
 
 	sleep 1 | ip netns exec ${ns1} nc -w 2 10.0.1.2 $port > /dev/null &
 	sleep 1
 
-	check_for_helper "$ns1" "ip $msg" $port
-	check_for_helper "$ns2" "ip $msg" $port
+	check_for_helper "$ns1" "ip $msg" $port $autoassign
+	check_for_helper "$ns2" "ip $msg" $port $autoassign
 
 	wait
 
@@ -173,9 +189,9 @@ if [ $? -ne 0 ];then
 	fi
 fi
 
-test_helper 2121 "set via ruleset"
-ip netns exec ${ns1} sysctl -q 'net.netfilter.nf_conntrack_helper=1'
-ip netns exec ${ns2} sysctl -q 'net.netfilter.nf_conntrack_helper=1'
-test_helper 21 "auto-assign"
+test_helper 2121 0
+ip netns exec ${ns1} sysctl -qe 'net.netfilter.nf_conntrack_helper=1'
+ip netns exec ${ns2} sysctl -qe 'net.netfilter.nf_conntrack_helper=1'
+test_helper 21 1
 
 exit $ret
-- 
2.35.1

