Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5154B2A1949
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbgJaSOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:14:55 -0400
Received: from correo.us.es ([193.147.175.20]:48038 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728247AbgJaSOw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 14:14:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 326467B565
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 19:14:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 26084DA78E
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 19:14:50 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1B9B3DA78D; Sat, 31 Oct 2020 19:14:50 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C9E7BDA722;
        Sat, 31 Oct 2020 19:14:47 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 31 Oct 2020 19:14:47 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id A521E42EF42B;
        Sat, 31 Oct 2020 19:14:47 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH net 4/5] netfilter: nf_tables: missing validation from the abort path
Date:   Sat, 31 Oct 2020 19:14:36 +0100
Message-Id: <20201031181437.12472-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201031181437.12472-1-pablo@netfilter.org>
References: <20201031181437.12472-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If userspace does not include the trailing end of batch message, then
nfnetlink aborts the transaction. This allows to check that ruleset
updates trigger no errors.

After this patch, invoking this command from the prerouting chain:

 # nft -c add rule x y fib saddr . oif type local

fails since oif is not supported there.

This patch fixes the lack of rule validation from the abort/check path
to catch configuration errors such as the one above.

Fixes: a654de8fdc18 ("netfilter: nf_tables: fix chain dependency validation")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink.h |  9 ++++++++-
 net/netfilter/nf_tables_api.c       | 15 ++++++++++-----
 net/netfilter/nfnetlink.c           | 22 ++++++++++++++++++----
 3 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 89016d08f6a2..f6267e2883f2 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -24,6 +24,12 @@ struct nfnl_callback {
 	const u_int16_t attr_count;		/* number of nlattr's */
 };
 
+enum nfnl_abort_action {
+	NFNL_ABORT_NONE		= 0,
+	NFNL_ABORT_AUTOLOAD,
+	NFNL_ABORT_VALIDATE,
+};
+
 struct nfnetlink_subsystem {
 	const char *name;
 	__u8 subsys_id;			/* nfnetlink subsystem ID */
@@ -31,7 +37,8 @@ struct nfnetlink_subsystem {
 	const struct nfnl_callback *cb;	/* callback for individual types */
 	struct module *owner;
 	int (*commit)(struct net *net, struct sk_buff *skb);
-	int (*abort)(struct net *net, struct sk_buff *skb, bool autoload);
+	int (*abort)(struct net *net, struct sk_buff *skb,
+		     enum nfnl_abort_action action);
 	void (*cleanup)(struct net *net);
 	bool (*valid_genid)(struct net *net, u32 genid);
 };
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9b70e136fb5d..0f58e98542be 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8053,12 +8053,16 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 	kfree(trans);
 }
 
-static int __nf_tables_abort(struct net *net, bool autoload)
+static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 {
 	struct nft_trans *trans, *next;
 	struct nft_trans_elem *te;
 	struct nft_hook *hook;
 
+	if (action == NFNL_ABORT_VALIDATE &&
+	    nf_tables_validate(net) < 0)
+		return -EAGAIN;
+
 	list_for_each_entry_safe_reverse(trans, next, &net->nft.commit_list,
 					 list) {
 		switch (trans->msg_type) {
@@ -8190,7 +8194,7 @@ static int __nf_tables_abort(struct net *net, bool autoload)
 		nf_tables_abort_release(trans);
 	}
 
-	if (autoload)
+	if (action == NFNL_ABORT_AUTOLOAD)
 		nf_tables_module_autoload(net);
 	else
 		nf_tables_module_autoload_cleanup(net);
@@ -8203,9 +8207,10 @@ static void nf_tables_cleanup(struct net *net)
 	nft_validate_state_update(net, NFT_VALIDATE_SKIP);
 }
 
-static int nf_tables_abort(struct net *net, struct sk_buff *skb, bool autoload)
+static int nf_tables_abort(struct net *net, struct sk_buff *skb,
+			   enum nfnl_abort_action action)
 {
-	int ret = __nf_tables_abort(net, autoload);
+	int ret = __nf_tables_abort(net, action);
 
 	mutex_unlock(&net->nft.commit_mutex);
 
@@ -8836,7 +8841,7 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 {
 	mutex_lock(&net->nft.commit_mutex);
 	if (!list_empty(&net->nft.commit_list))
-		__nf_tables_abort(net, false);
+		__nf_tables_abort(net, NFNL_ABORT_NONE);
 	__nft_release_tables(net);
 	mutex_unlock(&net->nft.commit_mutex);
 	WARN_ON_ONCE(!list_empty(&net->nft.tables));
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 2daa1f6ae344..d3df66a39b5e 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -333,7 +333,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return netlink_ack(skb, nlh, -EINVAL, NULL);
 replay:
 	status = 0;
-
+replay_abort:
 	skb = netlink_skb_clone(oskb, GFP_KERNEL);
 	if (!skb)
 		return netlink_ack(oskb, nlh, -ENOMEM, NULL);
@@ -499,7 +499,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 done:
 	if (status & NFNL_BATCH_REPLAY) {
-		ss->abort(net, oskb, true);
+		ss->abort(net, oskb, NFNL_ABORT_AUTOLOAD);
 		nfnl_err_reset(&err_list);
 		kfree_skb(skb);
 		module_put(ss->owner);
@@ -510,11 +510,25 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 			status |= NFNL_BATCH_REPLAY;
 			goto done;
 		} else if (err) {
-			ss->abort(net, oskb, false);
+			ss->abort(net, oskb, NFNL_ABORT_NONE);
 			netlink_ack(oskb, nlmsg_hdr(oskb), err, NULL);
 		}
 	} else {
-		ss->abort(net, oskb, false);
+		enum nfnl_abort_action abort_action;
+
+		if (status & NFNL_BATCH_FAILURE)
+			abort_action = NFNL_ABORT_NONE;
+		else
+			abort_action = NFNL_ABORT_VALIDATE;
+
+		err = ss->abort(net, oskb, abort_action);
+		if (err == -EAGAIN) {
+			nfnl_err_reset(&err_list);
+			kfree_skb(skb);
+			module_put(ss->owner);
+			status |= NFNL_BATCH_FAILURE;
+			goto replay_abort;
+		}
 	}
 	if (ss->cleanup)
 		ss->cleanup(net);
-- 
2.20.1

