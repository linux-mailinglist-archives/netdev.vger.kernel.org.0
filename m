Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99BD452063F
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 22:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiEIVBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 17:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiEIVBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 17:01:00 -0400
Received: from olfflo.fourcot.fr (fourcot.fr [217.70.191.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC012B8268
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 13:57:03 -0700 (PDT)
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Florent Fourcot <florent.fourcot@wifirst.fr>
Subject: [PATCH v2 net-next] net: neigh: add netlink filtering based on LLADDR for dump
Date:   Mon,  9 May 2022 22:56:46 +0200
Message-Id: <20220509205646.20814-1-florent.fourcot@wifirst.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

Changes in v2:
  * Check NDA_LLADDR length

Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
---
 net/core/neighbour.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 47b6c1f0fdbb..913b9dbcd276 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2641,9 +2641,25 @@ static bool neigh_ifindex_filtered(struct net_device *dev, int filter_idx)
 	return false;
 }
 
+static bool neigh_lladdr_filtered(struct neighbour *neigh, const u8 *lladdr,
+				  u32 lladdr_len)
+{
+	if (!lladdr)
+		return false;
+
+	if (lladdr_len != neigh->dev->addr_len)
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
+	struct nlattr *nla_lladdr;
 };
 
 static int neigh_dump_table(struct neigh_table *tbl, struct sk_buff *skb,
@@ -2656,13 +2672,20 @@ static int neigh_dump_table(struct neigh_table *tbl, struct sk_buff *skb,
 	int idx, s_idx = idx = cb->args[2];
 	struct neigh_hash_table *nht;
 	unsigned int flags = NLM_F_MULTI;
+	u8 *lladdr = NULL;
+	u32 lladdr_len;
 
-	if (filter->dev_idx || filter->master_idx)
+	if (filter->dev_idx || filter->master_idx || filter->nla_lladdr)
 		flags |= NLM_F_DUMP_FILTERED;
 
 	rcu_read_lock_bh();
 	nht = rcu_dereference_bh(tbl->nht);
 
+	if (filter->nla_lladdr) {
+		lladdr_len = nla_len(filter->nla_lladdr);
+		lladdr = nla_data(filter->nla_lladdr);
+	}
+
 	for (h = s_h; h < (1 << nht->hash_shift); h++) {
 		if (h > s_h)
 			s_idx = 0;
@@ -2672,7 +2695,8 @@ static int neigh_dump_table(struct neigh_table *tbl, struct sk_buff *skb,
 			if (idx < s_idx || !net_eq(dev_net(n->dev), net))
 				goto next;
 			if (neigh_ifindex_filtered(n->dev, filter->dev_idx) ||
-			    neigh_master_filtered(n->dev, filter->master_idx))
+			    neigh_master_filtered(n->dev, filter->master_idx) ||
+			    neigh_lladdr_filtered(n, lladdr, lladdr_len))
 				goto next;
 			if (neigh_fill_info(skb, n, NETLINK_CB(cb->skb).portid,
 					    cb->nlh->nlmsg_seq,
@@ -2788,6 +2812,13 @@ static int neigh_valid_dump_req(const struct nlmsghdr *nlh,
 		case NDA_MASTER:
 			filter->master_idx = nla_get_u32(tb[i]);
 			break;
+		case NDA_LLADDR:
+			if (!nla_len(tb[i])) {
+				NL_SET_ERR_MSG(extack, "Invalid link address");
+				return -EINVAL;
+			}
+			filter->nla_lladdr = tb[i];
+			break;
 		default:
 			if (strict_check) {
 				NL_SET_ERR_MSG(extack, "Unsupported attribute in neighbor dump request");
-- 
2.30.2

