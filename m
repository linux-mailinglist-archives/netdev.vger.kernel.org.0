Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11EDA4766B7
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 00:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbhLOXt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 18:49:28 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56632 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbhLOXt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 18:49:26 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9D99C607E0;
        Thu, 16 Dec 2021 00:46:55 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 6/7] netfilter: bridge: add support for pppoe filtering
Date:   Thu, 16 Dec 2021 00:49:10 +0100
Message-Id: <20211215234911.170741-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211215234911.170741-1-pablo@netfilter.org>
References: <20211215234911.170741-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This makes 'bridge-nf-filter-pppoe-tagged' sysctl work for
bridged traffic.

Looking at the original commit it doesn't appear this ever worked:

 static unsigned int br_nf_post_routing(unsigned int hook, struct sk_buff **pskb,
[..]
        if (skb->protocol == htons(ETH_P_8021Q)) {
                skb_pull(skb, VLAN_HLEN);
                skb->network_header += VLAN_HLEN;
+       } else if (skb->protocol == htons(ETH_P_PPP_SES)) {
+               skb_pull(skb, PPPOE_SES_HLEN);
+               skb->network_header += PPPOE_SES_HLEN;
        }
 [..]
	NF_HOOK(... POST_ROUTING, ...)

... but the adjusted offsets are never restored.

The alternative would be to rip this code out for good,
but otoh we'd have to keep this anyway for the vlan handling
(which works because vlan tag info is in the skb, not the packet
 payload).

Reported-and-tested-by: Amish Chana <amish@3g.co.za>
Fixes: 516299d2f5b6f97 ("[NETFILTER]: bridge-nf: filter bridged IPv4/IPv6 encapsulated in pppoe traffic")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/br_netfilter_hooks.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index b5af68c105a8..4fd882686b04 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -743,6 +743,9 @@ static int br_nf_dev_queue_xmit(struct net *net, struct sock *sk, struct sk_buff
 	if (nf_bridge->frag_max_size && nf_bridge->frag_max_size < mtu)
 		mtu = nf_bridge->frag_max_size;
 
+	nf_bridge_update_protocol(skb);
+	nf_bridge_push_encap_header(skb);
+
 	if (skb_is_gso(skb) || skb->len + mtu_reserved <= mtu) {
 		nf_bridge_info_free(skb);
 		return br_dev_queue_push_xmit(net, sk, skb);
@@ -760,8 +763,6 @@ static int br_nf_dev_queue_xmit(struct net *net, struct sock *sk, struct sk_buff
 
 		IPCB(skb)->frag_max_size = nf_bridge->frag_max_size;
 
-		nf_bridge_update_protocol(skb);
-
 		data = this_cpu_ptr(&brnf_frag_data_storage);
 
 		if (skb_vlan_tag_present(skb)) {
@@ -789,8 +790,6 @@ static int br_nf_dev_queue_xmit(struct net *net, struct sock *sk, struct sk_buff
 
 		IP6CB(skb)->frag_max_size = nf_bridge->frag_max_size;
 
-		nf_bridge_update_protocol(skb);
-
 		data = this_cpu_ptr(&brnf_frag_data_storage);
 		data->encap_size = nf_bridge_encap_header_len(skb);
 		data->size = ETH_HLEN + data->encap_size;
-- 
2.30.2

