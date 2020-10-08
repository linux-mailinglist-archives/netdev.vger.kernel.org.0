Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80EE28731E
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 13:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729746AbgJHLIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 07:08:15 -0400
Received: from fourcot.fr ([217.70.191.14]:52502 "EHLO olfflo.fourcot.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729255AbgJHLIP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 07:08:15 -0400
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Oct 2020 07:08:14 EDT
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
To:     netdev@vger.kernel.org
Cc:     Florent Fourcot <florent.fourcot@wifirst.fr>
Subject: [PATCH net-next] neigh: add netlink filtering based on LLADDR for dump
Date:   Thu,  8 Oct 2020 12:59:11 +0200
Message-Id: <20201008105911.28350-1-florent.fourcot@wifirst.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

neighbours table dump supports today two filtering:
 * based on interface index
 * based on master index

This patch adds a new filtering, based on layer two address. That will
help to replace something like it:

 ip neigh show | grep aa:11:22:bb:ee:ff

by a better command:

 ip neigh show lladdr aa:11:22:bb:ee:ff

Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
---
 net/core/neighbour.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 8e39e28b0a8d..4b32bf49a005 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2542,9 +2542,25 @@ static bool neigh_ifindex_filtered(struct net_device *dev, int filter_idx)
 	return false;
 }
 
+static bool neigh_lladdr_filtered(struct neighbour *neigh, const u8 *lladdr)
+{
+	if (!lladdr)
+		return false;
+
+	/* Ignore all empty values when lladdr filtering is set */
+	if (!neigh->dev->addr_len)
+		return true;
+
+	if (memcmp(lladdr, neigh->ha, neigh->dev->addr_len) != 0)
+		return true;
+
+	return false;
+}
+
 struct neigh_dump_filter {
 	int master_idx;
 	int dev_idx;
+	void *lladdr;
 };
 
 static int neigh_dump_table(struct neigh_table *tbl, struct sk_buff *skb,
@@ -2558,7 +2574,7 @@ static int neigh_dump_table(struct neigh_table *tbl, struct sk_buff *skb,
 	struct neigh_hash_table *nht;
 	unsigned int flags = NLM_F_MULTI;
 
-	if (filter->dev_idx || filter->master_idx)
+	if (filter->dev_idx || filter->master_idx || filter->lladdr)
 		flags |= NLM_F_DUMP_FILTERED;
 
 	rcu_read_lock_bh();
@@ -2573,7 +2589,8 @@ static int neigh_dump_table(struct neigh_table *tbl, struct sk_buff *skb,
 			if (idx < s_idx || !net_eq(dev_net(n->dev), net))
 				goto next;
 			if (neigh_ifindex_filtered(n->dev, filter->dev_idx) ||
-			    neigh_master_filtered(n->dev, filter->master_idx))
+			    neigh_master_filtered(n->dev, filter->master_idx) ||
+			    neigh_lladdr_filtered(n, filter->lladdr))
 				goto next;
 			if (neigh_fill_info(skb, n, NETLINK_CB(cb->skb).portid,
 					    cb->nlh->nlmsg_seq,
@@ -2689,6 +2706,9 @@ static int neigh_valid_dump_req(const struct nlmsghdr *nlh,
 		case NDA_MASTER:
 			filter->master_idx = nla_get_u32(tb[i]);
 			break;
+		case NDA_LLADDR:
+			filter->lladdr = nla_data(tb[i]);
+			break;
 		default:
 			if (strict_check) {
 				NL_SET_ERR_MSG(extack, "Unsupported attribute in neighbor dump request");
-- 
2.20.1

