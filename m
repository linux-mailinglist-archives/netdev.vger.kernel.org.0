Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8445A47868E
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 09:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbhLQIxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 03:53:19 -0500
Received: from mail.netfilter.org ([217.70.188.207]:60498 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233947AbhLQIxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 03:53:18 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E1C31625C9;
        Fri, 17 Dec 2021 09:50:47 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/3] netfilter: ctnetlink: remove expired entries first
Date:   Fri, 17 Dec 2021 09:53:03 +0100
Message-Id: <20211217085303.363401-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211217085303.363401-1-pablo@netfilter.org>
References: <20211217085303.363401-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

When dumping conntrack table to userspace via ctnetlink, check if the ct has
already expired before doing any of the 'skip' checks.

This expires dead entries faster.
/proc handler also removes outdated entries first.

Reported-by: Vitaly Zuevsky <vzuevsky@ns1.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 81d03acf68d4..ec4164c32d27 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1195,8 +1195,6 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 		}
 		hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[cb->args[0]],
 					   hnnode) {
-			if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
-				continue;
 			ct = nf_ct_tuplehash_to_ctrack(h);
 			if (nf_ct_is_expired(ct)) {
 				if (i < ARRAY_SIZE(nf_ct_evict) &&
@@ -1208,6 +1206,9 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 			if (!net_eq(net, nf_ct_net(ct)))
 				continue;
 
+			if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
+				continue;
+
 			if (cb->args[1]) {
 				if (ct != last)
 					continue;
-- 
2.30.2

