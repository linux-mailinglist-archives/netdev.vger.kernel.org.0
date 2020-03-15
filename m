Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90B3A185D78
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 15:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgCOOPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 10:15:43 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:3358 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgCOOPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 10:15:43 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.17]) by rmmx-syy-dmz-app02-12002 (RichMail) with SMTP id 2ee25e6e3882121-caef4; Sun, 15 Mar 2020 22:15:31 +0800 (CST)
X-RM-TRANSID: 2ee25e6e3882121-caef4
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost (unknown[223.105.0.241])
        by rmsmtp-syy-appsvr09-12009 (RichMail) with SMTP id 2ee95e6e387bd82-25633;
        Sun, 15 Mar 2020 22:15:30 +0800 (CST)
X-RM-TRANSID: 2ee95e6e387bd82-25633
From:   Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Subject: [PATCH 2/4] netfilter: nf_flow_table: reload iph in nf_flow_nat_ip
Date:   Sun, 15 Mar 2020 22:15:03 +0800
Message-Id: <1584281705-26228-2-git-send-email-yanhaishuang@cmss.chinamobile.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584281705-26228-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
References: <1584281705-26228-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since nf_flow_snat_port and nf_flow_snat_ip call pskb_may_pull()
which may change skb->data, so we need to reload iph at the right
place.

Fixes: 7d2086871762 ("netfilter: nf_flow_table: move ipv4 offload hook
code to nf_flow_table")
Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
---
 net/netfilter/nf_flow_table_ip.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 2e6ebbe..942bda5 100644
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
-- 
1.8.3.1



