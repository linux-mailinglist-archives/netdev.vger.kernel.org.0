Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228BF3E2D5A
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 17:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244040AbhHFPM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 11:12:29 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33830 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240199AbhHFPMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 11:12:21 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0145660060;
        Fri,  6 Aug 2021 17:11:25 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 7/9] netfilter: nfnetlink_hook: Use same family as request message
Date:   Fri,  6 Aug 2021 17:11:47 +0200
Message-Id: <20210806151149.6356-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210806151149.6356-1-pablo@netfilter.org>
References: <20210806151149.6356-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the same family as the request message, for consistency. The
netlink payload provides sufficient information to describe the hook
object, including the family.

This makes it easier to userspace to correlate the hooks are that
visited by the packets for a certain family.

Fixes: e2cf17d3774c ("netfilter: add new hook nfnl subsystem")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_hook.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index 7b0d4a317457..32eea785ae25 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -113,7 +113,7 @@ static int nfnl_hook_put_nft_chain_info(struct sk_buff *nlskb,
 static int nfnl_hook_dump_one(struct sk_buff *nlskb,
 			      const struct nfnl_dump_hook_data *ctx,
 			      const struct nf_hook_ops *ops,
-			      unsigned int seq)
+			      int family, unsigned int seq)
 {
 	u16 event = nfnl_msg_type(NFNL_SUBSYS_HOOK, NFNL_MSG_HOOK_GET);
 	unsigned int portid = NETLINK_CB(nlskb).portid;
@@ -124,7 +124,7 @@ static int nfnl_hook_dump_one(struct sk_buff *nlskb,
 	char *module_name;
 #endif
 	nlh = nfnl_msg_put(nlskb, portid, seq, event,
-			   NLM_F_MULTI, ops->pf, NFNETLINK_V0, 0);
+			   NLM_F_MULTI, family, NFNETLINK_V0, 0);
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -264,7 +264,7 @@ static int nfnl_hook_dump(struct sk_buff *nlskb,
 	ops = nf_hook_entries_get_hook_ops(e);
 
 	for (; i < e->num_hook_entries; i++) {
-		err = nfnl_hook_dump_one(nlskb, ctx, ops[i],
+		err = nfnl_hook_dump_one(nlskb, ctx, ops[i], family,
 					 cb->nlh->nlmsg_seq);
 		if (err)
 			break;
-- 
2.20.1

