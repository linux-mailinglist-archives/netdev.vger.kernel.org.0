Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0B47185D75
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 15:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgCOOPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 10:15:36 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:4864 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgCOOPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 10:15:36 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.15]) by rmmx-syy-dmz-app10-12010 (RichMail) with SMTP id 2eea5e6e38750a0-cade5; Sun, 15 Mar 2020 22:15:19 +0800 (CST)
X-RM-TRANSID: 2eea5e6e38750a0-cade5
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost (unknown[223.105.0.241])
        by rmsmtp-syy-appsvr08-12008 (RichMail) with SMTP id 2ee85e6e386fc0d-23340;
        Sun, 15 Mar 2020 22:15:19 +0800 (CST)
X-RM-TRANSID: 2ee85e6e386fc0d-23340
From:   Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Subject: [PATCH 1/4] netfilter: nf_flow_table: reload ipv6h in nf_flow_nat_ipv6
Date:   Sun, 15 Mar 2020 22:15:02 +0800
Message-Id: <1584281705-26228-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since nf_flow_snat_port and nf_flow_snat_ipv6 call pskb_may_pull()
which may change skb->data, so we need to reload ipv6h at the right
palce.

Fixes: a908fdec3dda ("netfilter: nf_flow_table: move ipv6 offload hook
code to nf_flow_table")
Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
---
 net/netfilter/nf_flow_table_ip.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 5272721..2e6ebbe 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -417,11 +417,12 @@ static int nf_flow_nat_ipv6(const struct flow_offload *flow,
 
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



