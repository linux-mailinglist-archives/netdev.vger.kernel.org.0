Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4FAB28C75
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 23:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388386AbfEWVgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 17:36:11 -0400
Received: from mail.us.es ([193.147.175.20]:46982 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388293AbfEWVgB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 17:36:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ACB26C1A75
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 23:35:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9D10DDA702
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 23:35:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 928F7DA701; Thu, 23 May 2019 23:35:58 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 998F4DA702;
        Thu, 23 May 2019 23:35:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 23 May 2019 23:35:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 66F104265A32;
        Thu, 23 May 2019 23:35:56 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 07/11] netfilter: nf_flow_table: ignore DF bit setting
Date:   Thu, 23 May 2019 23:35:43 +0200
Message-Id: <20190523213547.15523-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190523213547.15523-1-pablo@netfilter.org>
References: <20190523213547.15523-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Its irrelevant if the DF bit is set or not, we must pass packet to
stack in either case.

If the DF bit is set, we must pass it to stack so the appropriate
ICMP error can be generated.

If the DF is not set, we must pass it to stack for fragmentation.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 0d603e20b519..bfd44db9f214 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -243,8 +243,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	rt = (struct rtable *)flow->tuplehash[dir].tuple.dst_cache;
 	outdev = rt->dst.dev;
 
-	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)) &&
-	    (ip_hdr(skb)->frag_off & htons(IP_DF)) != 0)
+	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
 		return NF_ACCEPT;
 
 	if (skb_try_make_writable(skb, sizeof(*iph)))
-- 
2.11.0

