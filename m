Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76C49185D80
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 15:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgCOOQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 10:16:20 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:3134 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgCOOQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 10:16:20 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.7]) by rmmx-syy-dmz-app04-12004 (RichMail) with SMTP id 2ee45e6e38a5144-caed9; Sun, 15 Mar 2020 22:16:07 +0800 (CST)
X-RM-TRANSID: 2ee45e6e38a5144-caed9
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost (unknown[223.105.0.241])
        by rmsmtp-syy-appsvr04-12004 (RichMail) with SMTP id 2ee45e6e38a0e85-2436e;
        Sun, 15 Mar 2020 22:16:07 +0800 (CST)
X-RM-TRANSID: 2ee45e6e38a0e85-2436e
From:   Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Subject: [PATCH 4/4] netfilter: nf_flow_table: reload iph in nf_flow_tuple_ip
Date:   Sun, 15 Mar 2020 22:15:05 +0800
Message-Id: <1584281705-26228-4-git-send-email-yanhaishuang@cmss.chinamobile.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584281705-26228-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
References: <1584281705-26228-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since pskb_may_pull may change skb->data, so we need to reload iph at
the right place.

Fixes: 7d2086871762 ("netfilter: nf_flow_table: move ipv4 offload hook
code to nf_flow_table")
Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
---
 net/netfilter/nf_flow_table_ip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 954737f..610c60a 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -190,6 +190,7 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
 		return -1;
 
+	iph = ip_hdr(skb);
 	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
 
 	tuple->src_v4.s_addr	= iph->saddr;
-- 
1.8.3.1



