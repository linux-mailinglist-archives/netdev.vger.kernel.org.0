Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFB051877A8
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 03:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgCQCDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 22:03:38 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:9062 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgCQCDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 22:03:38 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.19]) by rmmx-syy-dmz-app12-12012 (RichMail) with SMTP id 2eec5e702fd7356-ec074; Tue, 17 Mar 2020 10:03:04 +0800 (CST)
X-RM-TRANSID: 2eec5e702fd7356-ec074
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost (unknown[223.105.0.241])
        by rmsmtp-syy-appsvr10-12010 (RichMail) with SMTP id 2eea5e702fd7558-f80c0;
        Tue, 17 Mar 2020 10:03:04 +0800 (CST)
X-RM-TRANSID: 2eea5e702fd7558-f80c0
From:   Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Subject: [PATCH v2 1/2] netfilter: nf_flow_table: reload ip{v6}h in nf_flow_nat_ip{v6}
Date:   Tue, 17 Mar 2020 10:02:52 +0800
Message-Id: <1584410573-6812-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since nf_flow_snat_port and nf_flow_snat_ip{v6} call pskb_may_pull()
which may change skb->data, so we need to reload ip{v6}h at the right
palce.

Fixes: a908fdec3dda ("netfilter: nf_flow_table: move ipv6 offload hook
code to nf_flow_table")
Fixes: 7d2086871762 ("netfilter: nf_flow_table: move ipv4 offload hook
code to nf_flow_table")
Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
---
v2: collapse the patches
---
 net/netfilter/nf_flow_table_ip.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 5272721..942bda5 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -146,11 +146,12 @@ static int nf_flow_nat_ip(const struct flow_offload *flow, struct sk_buff *skb,
 
 	if (test_bit(NF_FLOW_SNAT, &flow->flags) &&
 	    (nf_flow_snat_port(flow, skb, thoff, iph->protocol, dir) < 0 ||
-	     nf_flow_snat_ip(flow, skb, iph, thoff, dir) < 0))
+	     nf_flow_snat_ip(flow, skb, ip_hdr(skb), thoff, dir) < 0))
 		return -1;
+	iph = ip_hdr(skb);
 	if (test_bit(NF_FLOW_DNAT, &flow->flags) &&
 	    (nf_flow_dnat_port(flow, skb, thoff, iph->protocol, dir) < 0 ||
-	     nf_flow_dnat_ip(flow, skb, iph, thoff, dir) < 0))
+	     nf_flow_dnat_ip(flow, skb, ip_hdr(skb), thoff, dir) < 0))
 		return -1;
 
 	return 0;
@@ -417,11 +418,12 @@ static int nf_flow_nat_ipv6(const struct flow_offload *flow,
 
 	if (test_bit(NF_FLOW_SNAT, &flow->flags) &&
 	    (nf_flow_snat_port(flow, skb, thoff, ip6h->nexthdr, dir) < 0 ||
-	     nf_flow_snat_ipv6(flow, skb, ip6h, thoff, dir) < 0))
+	     nf_flow_snat_ipv6(flow, skb, ipv6_hdr(skb), thoff, dir) < 0))
 		return -1;
+	ip6h = ipv6_hdr(skb);
 	if (test_bit(NF_FLOW_DNAT, &flow->flags) &&
 	    (nf_flow_dnat_port(flow, skb, thoff, ip6h->nexthdr, dir) < 0 ||
-	     nf_flow_dnat_ipv6(flow, skb, ip6h, thoff, dir) < 0))
+	     nf_flow_dnat_ipv6(flow, skb, ipv6_hdr(skb), thoff, dir) < 0))
 		return -1;
 
 	return 0;
-- 
1.8.3.1



