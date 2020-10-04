Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8621282D6C
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 21:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgJDTu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 15:50:29 -0400
Received: from correo.us.es ([193.147.175.20]:34948 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726572AbgJDTuN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Oct 2020 15:50:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6731EEF42A
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 21:50:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A3DBDA78E
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 21:50:11 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4F597DA78C; Sun,  4 Oct 2020 21:50:11 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 18415DA72F;
        Sun,  4 Oct 2020 21:50:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 04 Oct 2020 21:50:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id E3FAB42EF9E2;
        Sun,  4 Oct 2020 21:50:08 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 06/11] netfilter: nf_tables: add userdata attributes to nft_chain
Date:   Sun,  4 Oct 2020 21:49:35 +0200
Message-Id: <20201004194940.7368-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201004194940.7368-1-pablo@netfilter.org>
References: <20201004194940.7368-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jose M. Guisado Gomez" <guigom@riseup.net>

Enables storing userdata for nft_chain. Field udata points to user data
and udlen stores its length.

Adds new attribute flag NFTA_CHAIN_USERDATA.

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |  2 ++
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c            | 33 ++++++++++++++++++------
 3 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index c4c526507ddb..0bd2a081ae39 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -945,6 +945,8 @@ struct nft_chain {
 					bound:1,
 					genmask:2;
 	char				*name;
+	u16				udlen;
+	u8				*udata;
 
 	/* Only used during control plane commit phase: */
 	struct nft_rule			**rules_next;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 3c2469b43742..352ee51707a1 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -208,6 +208,7 @@ enum nft_chain_flags {
  * @NFTA_CHAIN_COUNTERS: counter specification of the chain (NLA_NESTED: nft_counter_attributes)
  * @NFTA_CHAIN_FLAGS: chain flags
  * @NFTA_CHAIN_ID: uniquely identifies a chain in a transaction (NLA_U32)
+ * @NFTA_CHAIN_USERDATA: user data (NLA_BINARY)
  */
 enum nft_chain_attributes {
 	NFTA_CHAIN_UNSPEC,
@@ -222,6 +223,7 @@ enum nft_chain_attributes {
 	NFTA_CHAIN_PAD,
 	NFTA_CHAIN_FLAGS,
 	NFTA_CHAIN_ID,
+	NFTA_CHAIN_USERDATA,
 	__NFTA_CHAIN_MAX
 };
 #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0473316aa392..3cfff31e4818 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1304,6 +1304,8 @@ static const struct nla_policy nft_chain_policy[NFTA_CHAIN_MAX + 1] = {
 	[NFTA_CHAIN_COUNTERS]	= { .type = NLA_NESTED },
 	[NFTA_CHAIN_FLAGS]	= { .type = NLA_U32 },
 	[NFTA_CHAIN_ID]		= { .type = NLA_U32 },
+	[NFTA_CHAIN_USERDATA]	= { .type = NLA_BINARY,
+				    .len = NFT_USERDATA_MAXLEN },
 };
 
 static const struct nla_policy nft_hook_policy[NFTA_HOOK_MAX + 1] = {
@@ -1445,6 +1447,10 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 	if (nla_put_be32(skb, NFTA_CHAIN_USE, htonl(chain->use)))
 		goto nla_put_failure;
 
+	if (chain->udata &&
+	    nla_put(skb, NFTA_CHAIN_USERDATA, chain->udlen, chain->udata))
+		goto nla_put_failure;
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
@@ -1682,9 +1688,11 @@ void nf_tables_chain_destroy(struct nft_ctx *ctx)
 			free_percpu(rcu_dereference_raw(basechain->stats));
 		}
 		kfree(chain->name);
+		kfree(chain->udata);
 		kfree(basechain);
 	} else {
 		kfree(chain->name);
+		kfree(chain->udata);
 		kfree(chain);
 	}
 }
@@ -2038,7 +2046,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	} else {
 		if (!(flags & NFT_CHAIN_BINDING)) {
 			err = -EINVAL;
-			goto err1;
+			goto err_destroy_chain;
 		}
 
 		snprintf(name, sizeof(name), "__chain%llu", ++chain_id);
@@ -2047,13 +2055,22 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 
 	if (!chain->name) {
 		err = -ENOMEM;
-		goto err1;
+		goto err_destroy_chain;
+	}
+
+	if (nla[NFTA_CHAIN_USERDATA]) {
+		chain->udata = nla_memdup(nla[NFTA_CHAIN_USERDATA], GFP_KERNEL);
+		if (chain->udata == NULL) {
+			err = -ENOMEM;
+			goto err_destroy_chain;
+		}
+		chain->udlen = nla_len(nla[NFTA_CHAIN_USERDATA]);
 	}
 
 	rules = nf_tables_chain_alloc_rules(chain, 0);
 	if (!rules) {
 		err = -ENOMEM;
-		goto err1;
+		goto err_destroy_chain;
 	}
 
 	*rules = NULL;
@@ -2062,12 +2079,12 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 
 	err = nf_tables_register_hook(net, table, chain);
 	if (err < 0)
-		goto err1;
+		goto err_destroy_chain;
 
 	trans = nft_trans_chain_add(ctx, NFT_MSG_NEWCHAIN);
 	if (IS_ERR(trans)) {
 		err = PTR_ERR(trans);
-		goto err2;
+		goto err_unregister_hook;
 	}
 
 	nft_trans_chain_policy(trans) = NFT_CHAIN_POLICY_UNSET;
@@ -2077,15 +2094,15 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	err = nft_chain_add(table, chain);
 	if (err < 0) {
 		nft_trans_destroy(trans);
-		goto err2;
+		goto err_unregister_hook;
 	}
 
 	table->use++;
 
 	return 0;
-err2:
+err_unregister_hook:
 	nf_tables_unregister_hook(net, table, chain);
-err1:
+err_destroy_chain:
 	nf_tables_chain_destroy(ctx);
 
 	return err;
-- 
2.20.1

