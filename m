Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614933B0FCC
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 00:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhFVWDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 18:03:15 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59292 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbhFVWDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 18:03:00 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id B63806427D;
        Tue, 22 Jun 2021 23:59:18 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 8/8] netfilter: nf_tables: do not allow to delete table with owner by handle
Date:   Wed, 23 Jun 2021 00:00:01 +0200
Message-Id: <20210622220001.198508-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210622220001.198508-1-pablo@netfilter.org>
References: <20210622220001.198508-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nft_table_lookup_byhandle() also needs to validate the netlink PortID
owner when deleting a table by handle.

Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1d62b1a83299..fcb15b8904e8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -583,7 +583,7 @@ static struct nft_table *nft_table_lookup(const struct net *net,
 
 static struct nft_table *nft_table_lookup_byhandle(const struct net *net,
 						   const struct nlattr *nla,
-						   u8 genmask)
+						   u8 genmask, u32 nlpid)
 {
 	struct nftables_pernet *nft_net;
 	struct nft_table *table;
@@ -591,8 +591,13 @@ static struct nft_table *nft_table_lookup_byhandle(const struct net *net,
 	nft_net = nft_pernet(net);
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (be64_to_cpu(nla_get_be64(nla)) == table->handle &&
-		    nft_active_genmask(table, genmask))
+		    nft_active_genmask(table, genmask)) {
+			if (nft_table_has_owner(table) &&
+			    nlpid && table->nlpid != nlpid)
+				return ERR_PTR(-EPERM);
+
 			return table;
+		}
 	}
 
 	return ERR_PTR(-ENOENT);
@@ -1279,7 +1284,8 @@ static int nf_tables_deltable(struct sk_buff *skb, const struct nfnl_info *info,
 
 	if (nla[NFTA_TABLE_HANDLE]) {
 		attr = nla[NFTA_TABLE_HANDLE];
-		table = nft_table_lookup_byhandle(net, attr, genmask);
+		table = nft_table_lookup_byhandle(net, attr, genmask,
+						  NETLINK_CB(skb).portid);
 	} else {
 		attr = nla[NFTA_TABLE_NAME];
 		table = nft_table_lookup(net, attr, family, genmask,
-- 
2.30.2

