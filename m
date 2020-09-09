Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E605262C2D
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 11:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730214AbgIIJnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 05:43:03 -0400
Received: from correo.us.es ([193.147.175.20]:35050 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729992AbgIIJmj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 05:42:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B1BC3303D03
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:42:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A152DDA78E
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:42:34 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 96F0DDA73F; Wed,  9 Sep 2020 11:42:34 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5C2F9DA72F;
        Wed,  9 Sep 2020 11:42:32 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 09 Sep 2020 11:42:32 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 31AAE4301DE3;
        Wed,  9 Sep 2020 11:42:32 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 13/13] netfilter: nf_tables: add userdata support for nft_object
Date:   Wed,  9 Sep 2020 11:42:19 +0200
Message-Id: <20200909094219.17732-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200909094219.17732-1-pablo@netfilter.org>
References: <20200909094219.17732-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jose M. Guisado Gomez" <guigom@riseup.net>

Enables storing userdata for nft_object. Initially this will store an
optional comment but can be extended in the future as needed.

Adds new attribute NFTA_OBJ_USERDATA to nft_object.

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |  2 ++
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c            | 35 ++++++++++++++++++------
 3 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 97a7e147a59a..99c1b3188b1e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1123,6 +1123,8 @@ struct nft_object {
 	u32				genmask:2,
 					use:30;
 	u64				handle;
+	u16				udlen;
+	u8				*udata;
 	/* runtime data below here */
 	const struct nft_object_ops	*ops ____cacheline_aligned;
 	unsigned char			data[]
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 543dc697b796..2a6e09dea1a0 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1559,6 +1559,7 @@ enum nft_ct_expectation_attributes {
  * @NFTA_OBJ_DATA: stateful object data (NLA_NESTED)
  * @NFTA_OBJ_USE: number of references to this expression (NLA_U32)
  * @NFTA_OBJ_HANDLE: object handle (NLA_U64)
+ * @NFTA_OBJ_USERDATA: user data (NLA_BINARY)
  */
 enum nft_object_attributes {
 	NFTA_OBJ_UNSPEC,
@@ -1569,6 +1570,7 @@ enum nft_object_attributes {
 	NFTA_OBJ_USE,
 	NFTA_OBJ_HANDLE,
 	NFTA_OBJ_PAD,
+	NFTA_OBJ_USERDATA,
 	__NFTA_OBJ_MAX
 };
 #define NFTA_OBJ_MAX		(__NFTA_OBJ_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6ccce2a2e715..e9b4848e9dd0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5755,6 +5755,8 @@ static const struct nla_policy nft_obj_policy[NFTA_OBJ_MAX + 1] = {
 	[NFTA_OBJ_TYPE]		= { .type = NLA_U32 },
 	[NFTA_OBJ_DATA]		= { .type = NLA_NESTED },
 	[NFTA_OBJ_HANDLE]	= { .type = NLA_U64},
+	[NFTA_OBJ_USERDATA]	= { .type = NLA_BINARY,
+				    .len = NFT_USERDATA_MAXLEN },
 };
 
 static struct nft_object *nft_obj_init(const struct nft_ctx *ctx,
@@ -5902,6 +5904,7 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 	struct nft_object *obj;
 	struct nft_ctx ctx;
 	u32 objtype;
+	u16 udlen;
 	int err;
 
 	if (!nla[NFTA_OBJ_TYPE] ||
@@ -5946,7 +5949,7 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 	obj = nft_obj_init(&ctx, type, nla[NFTA_OBJ_DATA]);
 	if (IS_ERR(obj)) {
 		err = PTR_ERR(obj);
-		goto err1;
+		goto err_init;
 	}
 	obj->key.table = table;
 	obj->handle = nf_tables_alloc_handle(table);
@@ -5954,32 +5957,44 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 	obj->key.name = nla_strdup(nla[NFTA_OBJ_NAME], GFP_KERNEL);
 	if (!obj->key.name) {
 		err = -ENOMEM;
-		goto err2;
+		goto err_strdup;
+	}
+
+	if (nla[NFTA_OBJ_USERDATA]) {
+		udlen = nla_len(nla[NFTA_OBJ_USERDATA]);
+		obj->udata = kzalloc(udlen, GFP_KERNEL);
+		if (obj->udata == NULL)
+			goto err_userdata;
+
+		nla_memcpy(obj->udata, nla[NFTA_OBJ_USERDATA], udlen);
+		obj->udlen = udlen;
 	}
 
 	err = nft_trans_obj_add(&ctx, NFT_MSG_NEWOBJ, obj);
 	if (err < 0)
-		goto err3;
+		goto err_trans;
 
 	err = rhltable_insert(&nft_objname_ht, &obj->rhlhead,
 			      nft_objname_ht_params);
 	if (err < 0)
-		goto err4;
+		goto err_obj_ht;
 
 	list_add_tail_rcu(&obj->list, &table->objects);
 	table->use++;
 	return 0;
-err4:
+err_obj_ht:
 	/* queued in transaction log */
 	INIT_LIST_HEAD(&obj->list);
 	return err;
-err3:
+err_trans:
 	kfree(obj->key.name);
-err2:
+err_userdata:
+	kfree(obj->udata);
+err_strdup:
 	if (obj->ops->destroy)
 		obj->ops->destroy(&ctx, obj);
 	kfree(obj);
-err1:
+err_init:
 	module_put(type->owner);
 	return err;
 }
@@ -6011,6 +6026,10 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
 			 NFTA_OBJ_PAD))
 		goto nla_put_failure;
 
+	if (obj->udata &&
+	    nla_put(skb, NFTA_OBJ_USERDATA, obj->udlen, obj->udata))
+		goto nla_put_failure;
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
-- 
2.20.1

