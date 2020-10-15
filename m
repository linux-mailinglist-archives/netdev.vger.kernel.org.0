Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F276C28F6CD
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 18:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390041AbgJOQbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 12:31:09 -0400
Received: from correo.us.es ([193.147.175.20]:47310 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389825AbgJOQaw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 12:30:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D3F46E2C52
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 18:30:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BE9DDDA78F
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 18:30:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B1C9CDA78D; Thu, 15 Oct 2020 18:30:50 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 98784DA704;
        Thu, 15 Oct 2020 18:30:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 15 Oct 2020 18:30:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 6899242EF4E3;
        Thu, 15 Oct 2020 18:30:48 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next,v2 6/9] netfilter: flowtable: use dev_fill_forward_path() to obtain egress device
Date:   Thu, 15 Oct 2020 18:30:35 +0200
Message-Id: <20201015163038.26992-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201015163038.26992-1-pablo@netfilter.org>
References: <20201015163038.26992-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The egress device in the tuple is obtained from route. Use
dev_fill_forward_path() instead to provide the real ingress device for
this flow whenever this is available.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 include/net/netfilter/nf_flow_table.h |  4 ++++
 net/netfilter/nf_flow_table_core.c    |  1 +
 net/netfilter/nf_flow_table_ip.c      | 25 +++++++++++++++++++++++--
 net/netfilter/nft_flow_offload.c      |  1 +
 4 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index ecb84d4358cc..fe225e881cc7 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -117,6 +117,7 @@ struct flow_offload_tuple {
 	u8				dir;
 	enum flow_offload_xmit_type	xmit_type:8;
 	u16				mtu;
+	u32				oifidx;
 
 	struct dst_entry		*dst_cache;
 };
@@ -164,6 +165,9 @@ struct nf_flow_route {
 		struct {
 			u32		ifindex;
 		} in;
+		struct {
+			u32		ifindex;
+		} out;
 		struct dst_entry	*dst;
 	} tuple[FLOW_OFFLOAD_DIR_MAX];
 };
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 66abc7f287a3..99f01f08c550 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -94,6 +94,7 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 	}
 
 	flow_tuple->iifidx = route->tuple[dir].in.ifindex;
+	flow_tuple->oifidx = route->tuple[dir].out.ifindex;
 
 	if (dst_xfrm(dst))
 		flow_tuple->xmit_type = FLOW_OFFLOAD_XMIT_XFRM;
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index e215c79e6777..92f444db8d9f 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -228,6 +228,15 @@ static int nf_flow_offload_dst_check(struct dst_entry *dst)
 	return 0;
 }
 
+static struct net_device *nf_flow_outdev_lookup(struct net *net, int oifidx,
+						struct net_device *dev)
+{
+	if (oifidx == dev->ifindex)
+		return dev;
+
+	return dev_get_by_index_rcu(net, oifidx);
+}
+
 static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 				      const struct nf_hook_state *state,
 				      struct dst_entry *dst)
@@ -267,7 +276,6 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 	rt = (struct rtable *)flow->tuplehash[dir].tuple.dst_cache;
-	outdev = rt->dst.dev;
 
 	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
 		return NF_ACCEPT;
@@ -286,6 +294,13 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 		return NF_ACCEPT;
 	}
 
+	outdev = nf_flow_outdev_lookup(state->net, tuplehash->tuple.oifidx,
+				       rt->dst.dev);
+	if (!outdev) {
+		flow_offload_teardown(flow);
+		return NF_ACCEPT;
+	}
+
 	if (nf_flow_nat_ip(flow, skb, thoff, dir) < 0)
 		return NF_DROP;
 
@@ -517,7 +532,6 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 	rt = (struct rt6_info *)flow->tuplehash[dir].tuple.dst_cache;
-	outdev = rt->dst.dev;
 
 	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
 		return NF_ACCEPT;
@@ -533,6 +547,13 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 		return NF_ACCEPT;
 	}
 
+	outdev = nf_flow_outdev_lookup(state->net, tuplehash->tuple.oifidx,
+				       rt->dst.dev);
+	if (!outdev) {
+		flow_offload_teardown(flow);
+		return NF_ACCEPT;
+	}
+
 	if (skb_try_make_writable(skb, sizeof(*ip6h)))
 		return NF_DROP;
 
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 4b476b0a3c88..6a6633e2ceeb 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -84,6 +84,7 @@ static int nft_dev_forward_path(struct nf_flow_route *route,
 	}
 
 	route->tuple[!dir].in.ifindex = info.iifindex;
+	route->tuple[dir].out.ifindex = info.iifindex;
 
 	return 0;
 }
-- 
2.20.1

