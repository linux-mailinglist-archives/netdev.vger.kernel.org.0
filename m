Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AFE2C125F
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 18:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388241AbgKWRtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 12:49:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:51422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732749AbgKWRtF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 12:49:05 -0500
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 999E4206B2;
        Mon, 23 Nov 2020 17:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606153745;
        bh=lPeL2t2c7MqTkpkccwBik2GqDzxCgH1vNbtxn9P3q+U=;
        h=From:To:Cc:Subject:Date:From;
        b=yayuS5UMvH4Telb1mW1xpqGtK9/jW7s5fGQ1QTIMpkojan4qiibkKc/mcSUqozmi0
         7wRgA/J8kCslzCFjkio9dJbrbK5HYk1yNbGoqNFUgF7zS8xqx08UJQS1tdFhLtexyY
         10zKUe8sdT+FH9Zucgjpb+hXRR4+M7NFKF7ykI3w=
From:   Antoine Tenart <atenart@kernel.org>
To:     kuba@kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, roopa@nvidia.com, nikolay@nvidia.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        sbrivio@redhat.com
Subject: [PATCH net-next] netfilter: bridge: reset skb->pkt_type after NF_INET_POST_ROUTING traversal
Date:   Mon, 23 Nov 2020 18:49:02 +0100
Message-Id: <20201123174902.622102-1-atenart@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Netfilter changes PACKET_OTHERHOST to PACKET_HOST before invoking the
hooks as, while it's an expected value for a bridge, routing expects
PACKET_HOST. The change is undone later on after hook traversal. This
can be seen with pairs of functions updating skb>pkt_type and then
reverting it to its original value:

For hook NF_INET_PRE_ROUTING:
  setup_pre_routing / br_nf_pre_routing_finish

For hook NF_INET_FORWARD:
  br_nf_forward_ip / br_nf_forward_finish

But the third case where netfilter does this, for hook
NF_INET_POST_ROUTING, the packet type is changed in br_nf_post_routing
but never reverted. A comment says:

  /* We assume any code from br_dev_queue_push_xmit onwards doesn't care
   * about the value of skb->pkt_type. */

But when having a tunnel (say vxlan) attached to a bridge we have the
following call trace:

  br_nf_pre_routing
  br_nf_pre_routing_ipv6
     br_nf_pre_routing_finish
  br_nf_forward_ip
     br_nf_forward_finish
  br_nf_post_routing           <- pkt_type is updated to PACKET_HOST
     br_nf_dev_queue_xmit      <- but not reverted to its original value
  vxlan_xmit
     vxlan_xmit_one
        skb_tunnel_check_pmtu  <- a check on pkt_type is performed

In this specific case, this creates issues such as when an ICMPv6 PTB
should be sent back. When CONFIG_BRIDGE_NETFILTER is enabled, the PTB
isn't sent (as skb_tunnel_check_pmtu checks if pkt_type is PACKET_HOST
and returns early).

If the comment is right and no one cares about the value of
skb->pkt_type after br_dev_queue_push_xmit (which isn't true), resetting
it to its original value should be safe.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/bridge/br_netfilter_hooks.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 04c3f9a82650..8edfb98ae1d5 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -735,6 +735,11 @@ static int br_nf_dev_queue_xmit(struct net *net, struct sock *sk, struct sk_buff
 	mtu_reserved = nf_bridge_mtu_reduction(skb);
 	mtu = skb->dev->mtu;
 
+	if (nf_bridge->pkt_otherhost) {
+		skb->pkt_type = PACKET_OTHERHOST;
+		nf_bridge->pkt_otherhost = false;
+	}
+
 	if (nf_bridge->frag_max_size && nf_bridge->frag_max_size < mtu)
 		mtu = nf_bridge->frag_max_size;
 
@@ -835,8 +840,6 @@ static unsigned int br_nf_post_routing(void *priv,
 	else
 		return NF_ACCEPT;
 
-	/* We assume any code from br_dev_queue_push_xmit onwards doesn't care
-	 * about the value of skb->pkt_type. */
 	if (skb->pkt_type == PACKET_OTHERHOST) {
 		skb->pkt_type = PACKET_HOST;
 		nf_bridge->pkt_otherhost = true;
-- 
2.28.0

