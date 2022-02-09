Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7804AF2E7
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234097AbiBINgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234142AbiBINg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:36:28 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6DBCFC05CB8A;
        Wed,  9 Feb 2022 05:36:31 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 017EA601D3;
        Wed,  9 Feb 2022 14:36:19 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 13/14] nfqueue: enable to set skb->priority
Date:   Wed,  9 Feb 2022 14:36:15 +0100
Message-Id: <20220209133616.165104-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220209133616.165104-1-pablo@netfilter.org>
References: <20220209133616.165104-1-pablo@netfilter.org>
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

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

This is a follow up of the previous patch that enables to get
skb->priority. It's now posssible to set it also.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Florian Westphal <fw@strlen.de>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_queue.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 48d7a59c6482..8c15978d9258 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1019,11 +1019,13 @@ static const struct nla_policy nfqa_verdict_policy[NFQA_MAX+1] = {
 	[NFQA_CT]		= { .type = NLA_UNSPEC },
 	[NFQA_EXP]		= { .type = NLA_UNSPEC },
 	[NFQA_VLAN]		= { .type = NLA_NESTED },
+	[NFQA_PRIORITY]		= { .type = NLA_U32 },
 };
 
 static const struct nla_policy nfqa_verdict_batch_policy[NFQA_MAX+1] = {
 	[NFQA_VERDICT_HDR]	= { .len = sizeof(struct nfqnl_msg_verdict_hdr) },
 	[NFQA_MARK]		= { .type = NLA_U32 },
+	[NFQA_PRIORITY]		= { .type = NLA_U32 },
 };
 
 static struct nfqnl_instance *
@@ -1104,6 +1106,9 @@ static int nfqnl_recv_verdict_batch(struct sk_buff *skb,
 		if (nfqa[NFQA_MARK])
 			entry->skb->mark = ntohl(nla_get_be32(nfqa[NFQA_MARK]));
 
+		if (nfqa[NFQA_PRIORITY])
+			entry->skb->priority = ntohl(nla_get_be32(nfqa[NFQA_PRIORITY]));
+
 		nfqnl_reinject(entry, verdict);
 	}
 	return 0;
@@ -1230,6 +1235,9 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 	if (nfqa[NFQA_MARK])
 		entry->skb->mark = ntohl(nla_get_be32(nfqa[NFQA_MARK]));
 
+	if (nfqa[NFQA_PRIORITY])
+		entry->skb->priority = ntohl(nla_get_be32(nfqa[NFQA_PRIORITY]));
+
 	nfqnl_reinject(entry, verdict);
 	return 0;
 }
-- 
2.30.2

