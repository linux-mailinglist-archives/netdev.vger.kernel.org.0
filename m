Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE7C836B7AE
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbhDZRMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:12:00 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51518 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235574AbhDZRLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:11:50 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5135863E81;
        Mon, 26 Apr 2021 19:10:31 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 06/22] netfilter: x_tables: add xt_find_table
Date:   Mon, 26 Apr 2021 19:10:40 +0200
Message-Id: <20210426171056.345271-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426171056.345271-1-pablo@netfilter.org>
References: <20210426171056.345271-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This will be used to obtain the xt_table struct given address family and
table name.

Followup patches will reduce the number of direct accesses to the xt_table
structures via net->ipv{4,6}.ip(6)table_{nat,mangle,...} pointers, then
remove them.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/x_tables.h |  1 +
 net/netfilter/x_tables.c           | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 8ec48466410a..b2eec7de5280 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -322,6 +322,7 @@ struct xt_target *xt_request_find_target(u8 af, const char *name, u8 revision);
 int xt_find_revision(u8 af, const char *name, u8 revision, int target,
 		     int *err);
 
+struct xt_table *xt_find_table(struct net *net, u8 af, const char *name);
 struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 				    const char *name);
 struct xt_table *xt_request_find_table_lock(struct net *net, u_int8_t af,
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index b7f8d2ed3cc2..1caba9507228 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1199,6 +1199,23 @@ void xt_free_table_info(struct xt_table_info *info)
 }
 EXPORT_SYMBOL(xt_free_table_info);
 
+struct xt_table *xt_find_table(struct net *net, u8 af, const char *name)
+{
+	struct xt_pernet *xt_net = net_generic(net, xt_pernet_id);
+	struct xt_table *t;
+
+	mutex_lock(&xt[af].mutex);
+	list_for_each_entry(t, &xt_net->tables[af], list) {
+		if (strcmp(t->name, name) == 0) {
+			mutex_unlock(&xt[af].mutex);
+			return t;
+		}
+	}
+	mutex_unlock(&xt[af].mutex);
+	return NULL;
+}
+EXPORT_SYMBOL(xt_find_table);
+
 /* Find table by name, grabs mutex & ref.  Returns ERR_PTR on error. */
 struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 				    const char *name)
-- 
2.30.2

