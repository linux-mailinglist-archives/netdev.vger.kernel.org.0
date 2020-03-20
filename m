Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC49518CF6E
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 14:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgCTNvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 09:51:43 -0400
Received: from correo.us.es ([193.147.175.20]:41516 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgCTNvm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 09:51:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 99527172C88
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 14:51:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 88F63DA7B6
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 14:51:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 881F1DA788; Fri, 20 Mar 2020 14:51:09 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B34F9DA3C3;
        Fri, 20 Mar 2020 14:51:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Mar 2020 14:51:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8483F42EE38E;
        Fri, 20 Mar 2020 14:51:07 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 2/4] netfilter: flowtable: reload ip{v6}h in nf_flow_tuple_ip{v6}
Date:   Fri, 20 Mar 2020 14:51:32 +0100
Message-Id: <20200320135134.436907-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200320135134.436907-1-pablo@netfilter.org>
References: <20200320135134.436907-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

Since pskb_may_pull may change skb->data, so we need to reload ip{v6}h at
the right place.

Fixes: a908fdec3dda ("netfilter: nf_flow_table: move ipv6 offload hook code to nf_flow_table")
Fixes: 7d2086871762 ("netfilter: nf_flow_table: move ipv4 offload hook code to nf_flow_table")
Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 22caab7bb755..ba775aecd89a 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -191,6 +191,7 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
 		return -1;
 
+	iph = ip_hdr(skb);
 	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
 
 	tuple->src_v4.s_addr	= iph->saddr;
@@ -463,6 +464,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
 		return -1;
 
+	ip6h = ipv6_hdr(skb);
 	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
 
 	tuple->src_v6		= ip6h->saddr;
-- 
2.11.0

