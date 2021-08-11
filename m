Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385013E8C69
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 10:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236499AbhHKItu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 04:49:50 -0400
Received: from mail.netfilter.org ([217.70.188.207]:44078 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236242AbhHKItp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 04:49:45 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7CF496006E;
        Wed, 11 Aug 2021 10:48:38 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 07/10] netfilter: ctnetlink: add and use a helper for mark parsing
Date:   Wed, 11 Aug 2021 10:49:05 +0200
Message-Id: <20210811084908.14744-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210811084908.14744-1-pablo@netfilter.org>
References: <20210811084908.14744-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

ctnetlink dumps can be filtered based on the connmark.

Prepare for status bit filtering by using a named structure and by
moving the mark parsing code to a helper.

Else ctnetlink_alloc_filter size grows a bit too big for my taste
when status handling is added.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 42 ++++++++++++++++++----------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index e81af33b233b..e8368e66b0f5 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -852,6 +852,11 @@ static int ctnetlink_done(struct netlink_callback *cb)
 	return 0;
 }
 
+struct ctnetlink_filter_u32 {
+	u32 val;
+	u32 mask;
+};
+
 struct ctnetlink_filter {
 	u8 family;
 
@@ -862,10 +867,7 @@ struct ctnetlink_filter {
 	struct nf_conntrack_tuple reply;
 	struct nf_conntrack_zone zone;
 
-	struct {
-		u_int32_t val;
-		u_int32_t mask;
-	} mark;
+	struct ctnetlink_filter_u32 mark;
 };
 
 static const struct nla_policy cta_filter_nla_policy[CTA_FILTER_MAX + 1] = {
@@ -907,6 +909,24 @@ static int ctnetlink_parse_tuple_filter(const struct nlattr * const cda[],
 					 struct nf_conntrack_zone *zone,
 					 u_int32_t flags);
 
+static int ctnetlink_filter_parse_mark(struct ctnetlink_filter_u32 *mark,
+				       const struct nlattr * const cda[])
+{
+#ifdef CONFIG_NF_CONNTRACK_MARK
+	if (cda[CTA_MARK]) {
+		mark->val = ntohl(nla_get_be32(cda[CTA_MARK]));
+
+		if (cda[CTA_MARK_MASK])
+			mark->mask = ntohl(nla_get_be32(cda[CTA_MARK_MASK]));
+		else
+			mark->mask = 0xffffffff;
+	} else if (cda[CTA_MARK_MASK]) {
+		return -EINVAL;
+	}
+#endif
+	return 0;
+}
+
 static struct ctnetlink_filter *
 ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 {
@@ -924,18 +944,10 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 
 	filter->family = family;
 
-#ifdef CONFIG_NF_CONNTRACK_MARK
-	if (cda[CTA_MARK]) {
-		filter->mark.val = ntohl(nla_get_be32(cda[CTA_MARK]));
-		if (cda[CTA_MARK_MASK])
-			filter->mark.mask = ntohl(nla_get_be32(cda[CTA_MARK_MASK]));
-		else
-			filter->mark.mask = 0xffffffff;
-	} else if (cda[CTA_MARK_MASK]) {
-		err = -EINVAL;
+	err = ctnetlink_filter_parse_mark(&filter->mark, cda);
+	if (err)
 		goto err_filter;
-	}
-#endif
+
 	if (!cda[CTA_FILTER])
 		return filter;
 
-- 
2.20.1

