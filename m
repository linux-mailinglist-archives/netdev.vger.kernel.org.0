Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5414A97A3
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 11:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358255AbiBDKV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 05:21:57 -0500
Received: from [185.13.181.2] ([185.13.181.2]:34590 "EHLO
        smtpservice.6wind.com" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1358276AbiBDKVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 05:21:53 -0500
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id 4BD8C60063;
        Fri,  4 Feb 2022 11:21:52 +0100 (CET)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1nFviy-00012t-7H; Fri, 04 Feb 2022 11:21:52 +0100
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     pablo@netfilter.org
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH nf-next] nfqueue: enable to set skb->priority
Date:   Fri,  4 Feb 2022 11:21:43 +0100
Message-Id: <20220204102143.4010-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <Yfy2qiiYEeWLe8sI@salvia>
References: <Yfy2qiiYEeWLe8sI@salvia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow up of the previous patch that enables to get
skb->priority. It's now posssible to set it also.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
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
2.33.0

