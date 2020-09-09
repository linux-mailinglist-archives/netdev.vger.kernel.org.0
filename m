Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7676B262C28
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 11:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730083AbgIIJmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 05:42:46 -0400
Received: from correo.us.es ([193.147.175.20]:34950 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728709AbgIIJme (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 05:42:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 64A1E2EFEC8
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:42:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 51CC6DA84F
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:42:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 464DEDA840; Wed,  9 Sep 2020 11:42:28 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DDBACDA73D;
        Wed,  9 Sep 2020 11:42:25 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 09 Sep 2020 11:42:25 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id B3D9D4301DE1;
        Wed,  9 Sep 2020 11:42:25 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 03/13] netfilter: nf_tables: add userdata attributes to nft_table
Date:   Wed,  9 Sep 2020 11:42:09 +0200
Message-Id: <20200909094219.17732-4-pablo@netfilter.org>
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

Enables storing userdata for nft_table. Field udata points to user data
and udlen store its length.

Adds new attribute flag NFTA_TABLE_USERDATA

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |  2 ++
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c            | 22 +++++++++++++++++++++-
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index bf9491b77d16..97a7e147a59a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1080,6 +1080,8 @@ struct nft_table {
 					flags:8,
 					genmask:2;
 	char				*name;
+	u16				udlen;
+	u8				*udata;
 };
 
 void nft_register_chain_type(const struct nft_chain_type *);
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 42f351c1f5c5..aeb88cbd303e 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -172,6 +172,7 @@ enum nft_table_flags {
  * @NFTA_TABLE_NAME: name of the table (NLA_STRING)
  * @NFTA_TABLE_FLAGS: bitmask of enum nft_table_flags (NLA_U32)
  * @NFTA_TABLE_USE: number of chains in this table (NLA_U32)
+ * @NFTA_TABLE_USERDATA: user data (NLA_BINARY)
  */
 enum nft_table_attributes {
 	NFTA_TABLE_UNSPEC,
@@ -180,6 +181,7 @@ enum nft_table_attributes {
 	NFTA_TABLE_USE,
 	NFTA_TABLE_HANDLE,
 	NFTA_TABLE_PAD,
+	NFTA_TABLE_USERDATA,
 	__NFTA_TABLE_MAX
 };
 #define NFTA_TABLE_MAX		(__NFTA_TABLE_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fd814e514f94..6ccce2a2e715 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -650,6 +650,8 @@ static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
 				    .len = NFT_TABLE_MAXNAMELEN - 1 },
 	[NFTA_TABLE_FLAGS]	= { .type = NLA_U32 },
 	[NFTA_TABLE_HANDLE]	= { .type = NLA_U64 },
+	[NFTA_TABLE_USERDATA]	= { .type = NLA_BINARY,
+				    .len = NFT_USERDATA_MAXLEN }
 };
 
 static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
@@ -676,6 +678,11 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 			 NFTA_TABLE_PAD))
 		goto nla_put_failure;
 
+	if (table->udata) {
+		if (nla_put(skb, NFTA_TABLE_USERDATA, table->udlen, table->udata))
+			goto nla_put_failure;
+	}
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
@@ -977,8 +984,9 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	int family = nfmsg->nfgen_family;
 	const struct nlattr *attr;
 	struct nft_table *table;
-	u32 flags = 0;
 	struct nft_ctx ctx;
+	u32 flags = 0;
+	u16 udlen = 0;
 	int err;
 
 	lockdep_assert_held(&net->nft.commit_mutex);
@@ -1014,6 +1022,16 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 	if (table->name == NULL)
 		goto err_strdup;
 
+	if (nla[NFTA_TABLE_USERDATA]) {
+		udlen = nla_len(nla[NFTA_TABLE_USERDATA]);
+		table->udata = kzalloc(udlen, GFP_KERNEL);
+		if (table->udata == NULL)
+			goto err_table_udata;
+
+		nla_memcpy(table->udata, nla[NFTA_TABLE_USERDATA], udlen);
+		table->udlen = udlen;
+	}
+
 	err = rhltable_init(&table->chains_ht, &nft_chain_ht_params);
 	if (err)
 		goto err_chain_ht;
@@ -1036,6 +1054,8 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 err_trans:
 	rhltable_destroy(&table->chains_ht);
 err_chain_ht:
+	kfree(table->udata);
+err_table_udata:
 	kfree(table->name);
 err_strdup:
 	kfree(table);
-- 
2.20.1

