Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE974D975D
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 10:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346463AbiCOJQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 05:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346268AbiCOJQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 05:16:33 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 408454D9D8;
        Tue, 15 Mar 2022 02:15:21 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3D08C63011;
        Tue, 15 Mar 2022 10:13:01 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 2/6] netfilter: nf_tables: Reject tables of unsupported family
Date:   Tue, 15 Mar 2022 10:15:09 +0100
Message-Id: <20220315091513.66544-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220315091513.66544-1-pablo@netfilter.org>
References: <20220315091513.66544-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

An nftables family is merely a hollow container, its family just a
number and such not reliant on compile-time options other than nftables
support itself. Add an artificial check so attempts at using a family
the kernel can't support fail as early as possible. This helps user
space detect kernels which lack e.g. NFPROTO_INET.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9cd1d7a62804..3168ad8cffd1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1072,6 +1072,30 @@ static int nft_objname_hash_cmp(struct rhashtable_compare_arg *arg,
 	return strcmp(obj->key.name, k->name);
 }
 
+static bool nft_supported_family(u8 family)
+{
+	return false
+#ifdef CONFIG_NF_TABLES_INET
+		|| family == NFPROTO_INET
+#endif
+#ifdef CONFIG_NF_TABLES_IPV4
+		|| family == NFPROTO_IPV4
+#endif
+#ifdef CONFIG_NF_TABLES_ARP
+		|| family == NFPROTO_ARP
+#endif
+#ifdef CONFIG_NF_TABLES_NETDEV
+		|| family == NFPROTO_NETDEV
+#endif
+#if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE)
+		|| family == NFPROTO_BRIDGE
+#endif
+#ifdef CONFIG_NF_TABLES_IPV6
+		|| family == NFPROTO_IPV6
+#endif
+		;
+}
+
 static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 			      const struct nlattr * const nla[])
 {
@@ -1086,6 +1110,9 @@ static int nf_tables_newtable(struct sk_buff *skb, const struct nfnl_info *info,
 	u32 flags = 0;
 	int err;
 
+	if (!nft_supported_family(family))
+		return -EOPNOTSUPP;
+
 	lockdep_assert_held(&nft_net->commit_mutex);
 	attr = nla[NFTA_TABLE_NAME];
 	table = nft_table_lookup(net, attr, family, genmask,
-- 
2.30.2

