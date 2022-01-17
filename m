Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339BE491139
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 22:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243198AbiAQVCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 16:02:00 -0500
Received: from [185.13.181.2] ([185.13.181.2]:55598 "EHLO
        smtpservice.6wind.com" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S235737AbiAQVCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 16:02:00 -0500
X-Greylist: delayed 343 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jan 2022 16:01:59 EST
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id 93916600C8;
        Mon, 17 Jan 2022 21:56:14 +0100 (CET)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1n9Z30-0006o2-Gl; Mon, 17 Jan 2022 21:56:14 +0100
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     fw@strlen.de, pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH nf-next] nfqueue: enable to get skb->priority
Date:   Mon, 17 Jan 2022 21:56:13 +0100
Message-Id: <20220117205613.26153-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This info could be useful to improve traffic analysis.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 include/uapi/linux/netfilter/nfnetlink_queue.h | 1 +
 net/netfilter/nfnetlink_queue.c                | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
index aed90c4df0c8..ef7c97f21a15 100644
--- a/include/uapi/linux/netfilter/nfnetlink_queue.h
+++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
@@ -61,6 +61,7 @@ enum nfqnl_attr_type {
 	NFQA_SECCTX,			/* security context string */
 	NFQA_VLAN,			/* nested attribute: packet vlan info */
 	NFQA_L2HDR,			/* full L2 header */
+	NFQA_PRIORITY,			/* skb->priority */
 
 	__NFQA_MAX
 };
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index ea2d9c2a44cf..48d7a59c6482 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -402,6 +402,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 		+ nla_total_size(sizeof(u_int32_t))	/* ifindex */
 #endif
 		+ nla_total_size(sizeof(u_int32_t))	/* mark */
+		+ nla_total_size(sizeof(u_int32_t))	/* priority */
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hw))
 		+ nla_total_size(sizeof(u_int32_t))	/* skbinfo */
 		+ nla_total_size(sizeof(u_int32_t));	/* cap_len */
@@ -559,6 +560,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	    nla_put_be32(skb, NFQA_MARK, htonl(entskb->mark)))
 		goto nla_put_failure;
 
+	if (entskb->priority &&
+	    nla_put_be32(skb, NFQA_PRIORITY, htonl(entskb->priority)))
+		goto nla_put_failure;
+
 	if (indev && entskb->dev &&
 	    skb_mac_header_was_set(entskb) &&
 	    skb_mac_header_len(entskb) != 0) {
-- 
2.33.0

