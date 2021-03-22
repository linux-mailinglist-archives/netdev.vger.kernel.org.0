Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20414345378
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhCVX5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:57:12 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58346 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbhCVX4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:56:48 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 69198630CA;
        Tue, 23 Mar 2021 00:56:34 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 06/10] netfilter: flowtable: move FLOW_OFFLOAD_DIR_MAX away from enumeration
Date:   Tue, 23 Mar 2021 00:56:24 +0100
Message-Id: <20210322235628.2204-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210322235628.2204-1-pablo@netfilter.org>
References: <20210322235628.2204-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows to remove the default case which should not ever happen and
that was added to avoid gcc warnings on unhandled FLOW_OFFLOAD_DIR_MAX
enumeration case.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 2 +-
 net/netfilter/nf_flow_table_core.c    | 4 ----
 net/netfilter/nf_flow_table_ip.c      | 8 --------
 3 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 54c4d5c908a5..ce507251b3d8 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -86,8 +86,8 @@ static inline bool nf_flowtable_hw_offload(struct nf_flowtable *flowtable)
 enum flow_offload_tuple_dir {
 	FLOW_OFFLOAD_DIR_ORIGINAL = IP_CT_DIR_ORIGINAL,
 	FLOW_OFFLOAD_DIR_REPLY = IP_CT_DIR_REPLY,
-	FLOW_OFFLOAD_DIR_MAX = IP_CT_DIR_MAX
 };
+#define FLOW_OFFLOAD_DIR_MAX	IP_CT_DIR_MAX
 
 struct flow_offload_tuple {
 	union {
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index ff5d94b644ac..3bdbd962a084 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -454,8 +454,6 @@ int nf_flow_snat_port(const struct flow_offload *flow,
 		new_port = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_port;
 		hdr->dest = new_port;
 		break;
-	default:
-		return -1;
 	}
 
 	return nf_flow_nat_port(skb, thoff, protocol, port, new_port);
@@ -482,8 +480,6 @@ int nf_flow_dnat_port(const struct flow_offload *flow,
 		new_port = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_port;
 		hdr->source = new_port;
 		break;
-	default:
-		return -1;
 	}
 
 	return nf_flow_nat_port(skb, thoff, protocol, port, new_port);
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 95adf74515ea..0579e15c4968 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -96,8 +96,6 @@ static int nf_flow_snat_ip(const struct flow_offload *flow, struct sk_buff *skb,
 		new_addr = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_v4.s_addr;
 		iph->daddr = new_addr;
 		break;
-	default:
-		return -1;
 	}
 	csum_replace4(&iph->check, addr, new_addr);
 
@@ -121,8 +119,6 @@ static int nf_flow_dnat_ip(const struct flow_offload *flow, struct sk_buff *skb,
 		new_addr = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_v4.s_addr;
 		iph->saddr = new_addr;
 		break;
-	default:
-		return -1;
 	}
 	csum_replace4(&iph->check, addr, new_addr);
 
@@ -371,8 +367,6 @@ static int nf_flow_snat_ipv6(const struct flow_offload *flow,
 		new_addr = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.src_v6;
 		ip6h->daddr = new_addr;
 		break;
-	default:
-		return -1;
 	}
 
 	return nf_flow_nat_ipv6_l4proto(skb, ip6h, thoff, &addr, &new_addr);
@@ -396,8 +390,6 @@ static int nf_flow_dnat_ipv6(const struct flow_offload *flow,
 		new_addr = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_v6;
 		ip6h->saddr = new_addr;
 		break;
-	default:
-		return -1;
 	}
 
 	return nf_flow_nat_ipv6_l4proto(skb, ip6h, thoff, &addr, &new_addr);
-- 
2.20.1

