Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 564F4178FC8
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 12:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387881AbgCDLtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 06:49:50 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:48401 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387776AbgCDLtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 06:49:50 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 4 Mar 2020 13:49:43 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 024BnhYl021118;
        Wed, 4 Mar 2020 13:49:43 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net-next 2/2] net/sched: act_ct: Use pskb_network_may_pull()
Date:   Wed,  4 Mar 2020 13:49:39 +0200
Message-Id: <1583322579-11558-3-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1583322579-11558-1-git-send-email-paulb@mellanox.com>
References: <1583322579-11558-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To make the filler functions more generic, use network
relative skb pulling.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
---
 net/sched/act_ct.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index f434db7..23eba61 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -195,7 +195,7 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 	unsigned int thoff;
 	struct iphdr *iph;
 
-	if (!pskb_may_pull(skb, sizeof(*iph)))
+	if (!pskb_network_may_pull(skb, sizeof(*iph)))
 		return false;
 
 	iph = ip_hdr(skb);
@@ -212,9 +212,9 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 	if (iph->ttl <= 1)
 		return false;
 
-	if (!pskb_may_pull(skb, iph->protocol == IPPROTO_TCP ?
-			   thoff + sizeof(struct tcphdr) :
-			   thoff + sizeof(*ports)))
+	if (!pskb_network_may_pull(skb, iph->protocol == IPPROTO_TCP ?
+					thoff + sizeof(struct tcphdr) :
+					thoff + sizeof(*ports)))
 		return false;
 
 	iph = ip_hdr(skb);
@@ -241,7 +241,7 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 	struct ipv6hdr *ip6h;
 	unsigned int thoff;
 
-	if (!pskb_may_pull(skb, sizeof(*ip6h)))
+	if (!pskb_network_may_pull(skb, sizeof(*ip6h)))
 		return false;
 
 	ip6h = ipv6_hdr(skb);
@@ -254,9 +254,9 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 		return false;
 
 	thoff = sizeof(*ip6h);
-	if (!pskb_may_pull(skb, ip6h->nexthdr == IPPROTO_TCP ?
-			   thoff + sizeof(struct tcphdr) :
-			   thoff + sizeof(*ports)))
+	if (!pskb_network_may_pull(skb, ip6h->nexthdr == IPPROTO_TCP ?
+					thoff + sizeof(struct tcphdr) :
+					thoff + sizeof(*ports)))
 		return false;
 
 	ip6h = ipv6_hdr(skb);
-- 
1.8.3.1

