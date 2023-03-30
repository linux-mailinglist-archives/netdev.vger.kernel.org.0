Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86996D0FFF
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 22:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjC3U3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 16:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjC3U3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 16:29:45 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F1519A;
        Thu, 30 Mar 2023 13:29:44 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1phytw-0000gy-Aj; Thu, 30 Mar 2023 22:29:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>, Eric Sage <eric_sage@apple.com>
Subject: [PATCH net-next 2/4] netfilter: nfnetlink_queue: enable classid socket info retrieval
Date:   Thu, 30 Mar 2023 22:29:26 +0200
Message-Id: <20230330202928.28705-3-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230330202928.28705-1-fw@strlen.de>
References: <20230330202928.28705-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Sage <eric_sage@apple.com>

This enables associating a socket with a v1 net_cls cgroup. Useful for
applying a per-cgroup policy when processing packets in userspace.

Signed-off-by: Eric Sage <eric_sage@apple.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../uapi/linux/netfilter/nfnetlink_queue.h    |  1 +
 net/netfilter/nfnetlink_queue.c               | 20 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
index ef7c97f21a15..efcb7c044a74 100644
--- a/include/uapi/linux/netfilter/nfnetlink_queue.h
+++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
@@ -62,6 +62,7 @@ enum nfqnl_attr_type {
 	NFQA_VLAN,			/* nested attribute: packet vlan info */
 	NFQA_L2HDR,			/* full L2 header */
 	NFQA_PRIORITY,			/* skb->priority */
+	NFQA_CGROUP_CLASSID,		/* __u32 cgroup classid */
 
 	__NFQA_MAX
 };
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 87a9009d5234..e311462f6d98 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -29,6 +29,7 @@
 #include <linux/netfilter/nfnetlink_queue.h>
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/list.h>
+#include <linux/cgroup-defs.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <net/netfilter/nf_queue.h>
@@ -301,6 +302,19 @@ static int nfqnl_put_sk_uidgid(struct sk_buff *skb, struct sock *sk)
 	return -1;
 }
 
+static int nfqnl_put_sk_classid(struct sk_buff *skb, struct sock *sk)
+{
+#if IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)
+	if (sk && sk_fullsock(sk)) {
+		u32 classid = sock_cgroup_classid(&sk->sk_cgrp_data);
+
+		if (classid && nla_put_be32(skb, NFQA_CGROUP_CLASSID, htonl(classid)))
+			return -1;
+	}
+#endif
+	return 0;
+}
+
 static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
 {
 	u32 seclen = 0;
@@ -406,6 +420,9 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 		+ nla_total_size(sizeof(u_int32_t))	/* priority */
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hw))
 		+ nla_total_size(sizeof(u_int32_t))	/* skbinfo */
+#if IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)
+		+ nla_total_size(sizeof(u_int32_t))	/* classid */
+#endif
 		+ nla_total_size(sizeof(u_int32_t));	/* cap_len */
 
 	tstamp = skb_tstamp_cond(entskb, false);
@@ -599,6 +616,9 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
 		goto nla_put_failure;
 
+	if (nfqnl_put_sk_classid(skb, entskb->sk) < 0)
+		goto nla_put_failure;
+
 	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
 		goto nla_put_failure;
 
-- 
2.39.2

