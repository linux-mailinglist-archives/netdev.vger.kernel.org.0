Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEF6CAA7E7
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 18:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390768AbfIEQEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 12:04:13 -0400
Received: from correo.us.es ([193.147.175.20]:53090 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390807AbfIEQEM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 12:04:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 63E0E1228C4
        for <netdev@vger.kernel.org>; Thu,  5 Sep 2019 18:04:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 55C71B8014
        for <netdev@vger.kernel.org>; Thu,  5 Sep 2019 18:04:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4B4A3B8007; Thu,  5 Sep 2019 18:04:08 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2A13DDA4CA;
        Thu,  5 Sep 2019 18:04:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 05 Sep 2019 18:04:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id F2EB442EE38E;
        Thu,  5 Sep 2019 18:04:05 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 6/8] netfilter: nf_tables: Introduce stateful object update operation
Date:   Thu,  5 Sep 2019 18:03:58 +0200
Message-Id: <20190905160400.25399-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190905160400.25399-1-pablo@netfilter.org>
References: <20190905160400.25399-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

This patch adds the infrastructure needed for the stateful object update
support.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  9 +++++
 net/netfilter/nf_tables_api.c     | 78 +++++++++++++++++++++++++++++++++++----
 2 files changed, 80 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 498665158ee0..3d9e66aa0139 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1127,6 +1127,7 @@ struct nft_object_type {
  *	@init: initialize object from netlink attributes
  *	@destroy: release existing stateful object
  *	@dump: netlink dump stateful object
+ *	@update: update stateful object
  */
 struct nft_object_ops {
 	void				(*eval)(struct nft_object *obj,
@@ -1141,6 +1142,8 @@ struct nft_object_ops {
 	int				(*dump)(struct sk_buff *skb,
 						struct nft_object *obj,
 						bool reset);
+	void				(*update)(struct nft_object *obj,
+						  struct nft_object *newobj);
 	const struct nft_object_type	*type;
 };
 
@@ -1429,10 +1432,16 @@ struct nft_trans_elem {
 
 struct nft_trans_obj {
 	struct nft_object		*obj;
+	struct nft_object		*newobj;
+	bool				update;
 };
 
 #define nft_trans_obj(trans)	\
 	(((struct nft_trans_obj *)trans->data)->obj)
+#define nft_trans_obj_newobj(trans) \
+	(((struct nft_trans_obj *)trans->data)->newobj)
+#define nft_trans_obj_update(trans)	\
+	(((struct nft_trans_obj *)trans->data)->update)
 
 struct nft_trans_flowtable {
 	struct nft_flowtable		*flowtable;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6d00bef023c4..cf767bc58e18 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5131,6 +5131,38 @@ nft_obj_type_get(struct net *net, u32 objtype)
 	return ERR_PTR(-ENOENT);
 }
 
+static int nf_tables_updobj(const struct nft_ctx *ctx,
+			    const struct nft_object_type *type,
+			    const struct nlattr *attr,
+			    struct nft_object *obj)
+{
+	struct nft_object *newobj;
+	struct nft_trans *trans;
+	int err;
+
+	trans = nft_trans_alloc(ctx, NFT_MSG_NEWOBJ,
+				sizeof(struct nft_trans_obj));
+	if (!trans)
+		return -ENOMEM;
+
+	newobj = nft_obj_init(ctx, type, attr);
+	if (IS_ERR(newobj)) {
+		err = PTR_ERR(newobj);
+		goto err1;
+	}
+
+	nft_trans_obj(trans) = obj;
+	nft_trans_obj_update(trans) = true;
+	nft_trans_obj_newobj(trans) = newobj;
+	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+
+	return 0;
+err1:
+	kfree(trans);
+	kfree(newobj);
+	return err;
+}
+
 static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 			    struct sk_buff *skb, const struct nlmsghdr *nlh,
 			    const struct nlattr * const nla[],
@@ -5170,7 +5202,13 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 			NL_SET_BAD_ATTR(extack, nla[NFTA_OBJ_NAME]);
 			return -EEXIST;
 		}
-		return 0;
+		if (nlh->nlmsg_flags & NLM_F_REPLACE)
+			return -EOPNOTSUPP;
+
+		type = nft_obj_type_get(net, objtype);
+		nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
+
+		return nf_tables_updobj(&ctx, type, nla[NFTA_OBJ_DATA], obj);
 	}
 
 	nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
@@ -6431,6 +6469,19 @@ static void nft_chain_commit_update(struct nft_trans *trans)
 	}
 }
 
+static void nft_obj_commit_update(struct nft_trans *trans)
+{
+	struct nft_object *newobj;
+	struct nft_object *obj;
+
+	obj = nft_trans_obj(trans);
+	newobj = nft_trans_obj_newobj(trans);
+
+	obj->ops->update(obj, newobj);
+
+	kfree(newobj);
+}
+
 static void nft_commit_release(struct nft_trans *trans)
 {
 	switch (trans->msg_type) {
@@ -6795,10 +6846,18 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			te->set->ndeact--;
 			break;
 		case NFT_MSG_NEWOBJ:
-			nft_clear(net, nft_trans_obj(trans));
-			nf_tables_obj_notify(&trans->ctx, nft_trans_obj(trans),
-					     NFT_MSG_NEWOBJ);
-			nft_trans_destroy(trans);
+			if (nft_trans_obj_update(trans)) {
+				nft_obj_commit_update(trans);
+				nf_tables_obj_notify(&trans->ctx,
+						     nft_trans_obj(trans),
+						     NFT_MSG_NEWOBJ);
+			} else {
+				nft_clear(net, nft_trans_obj(trans));
+				nf_tables_obj_notify(&trans->ctx,
+						     nft_trans_obj(trans),
+						     NFT_MSG_NEWOBJ);
+				nft_trans_destroy(trans);
+			}
 			break;
 		case NFT_MSG_DELOBJ:
 			nft_obj_del(nft_trans_obj(trans));
@@ -6945,8 +7004,13 @@ static int __nf_tables_abort(struct net *net)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWOBJ:
-			trans->ctx.table->use--;
-			nft_obj_del(nft_trans_obj(trans));
+			if (nft_trans_obj_update(trans)) {
+				kfree(nft_trans_obj_newobj(trans));
+				nft_trans_destroy(trans);
+			} else {
+				trans->ctx.table->use--;
+				nft_obj_del(nft_trans_obj(trans));
+			}
 			break;
 		case NFT_MSG_DELOBJ:
 			trans->ctx.table->use++;
-- 
2.11.0

