Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAC5D1972C4
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 05:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgC3DVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 23:21:00 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:4016 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728987AbgC3DVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 23:21:00 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.5]) by rmmx-syy-dmz-app09-12009 (RichMail) with SMTP id 2ee95e81658ecc9-03bf0; Mon, 30 Mar 2020 11:20:46 +0800 (CST)
X-RM-TRANSID: 2ee95e81658ecc9-03bf0
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost (unknown[223.105.0.241])
        by rmsmtp-syy-appsvr03-12003 (RichMail) with SMTP id 2ee35e81658d0c3-a4187;
        Mon, 30 Mar 2020 11:20:46 +0800 (CST)
X-RM-TRANSID: 2ee35e81658d0c3-a4187
From:   Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
To:     Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Subject: [PATCH nf-next] ipvs: fix uninitialized variable warning
Date:   Mon, 30 Mar 2020 11:20:15 +0800
Message-Id: <1585538415-27583-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If outer_proto is not set, GCC warning as following:

In file included from net/netfilter/ipvs/ip_vs_core.c:52:
net/netfilter/ipvs/ip_vs_core.c: In function 'ip_vs_in_icmp':
include/net/ip_vs.h:233:4: warning: 'outer_proto' may be used uninitialized in this function [-Wmaybe-uninitialized]
 233 |    printk(KERN_DEBUG pr_fmt(msg), ##__VA_ARGS__); \
     |    ^~~~~~
net/netfilter/ipvs/ip_vs_core.c:1666:8: note: 'outer_proto' was declared here
1666 |  char *outer_proto;
     |        ^~~~~~~~~~~

Fixes: 73348fed35d0 ("ipvs: optimize tunnel dumps for icmp errors")
Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
---
 net/netfilter/ipvs/ip_vs_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index d2ac530..aa6a603 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1663,7 +1663,7 @@ static int ipvs_gre_decap(struct netns_ipvs *ipvs, struct sk_buff *skb,
 	unsigned int offset, offset2, ihl, verdict;
 	bool tunnel, new_cp = false;
 	union nf_inet_addr *raddr;
-	char *outer_proto;
+	char *outer_proto = "IPIP";
 
 	*related = 1;
 
@@ -1723,7 +1723,6 @@ static int ipvs_gre_decap(struct netns_ipvs *ipvs, struct sk_buff *skb,
 		if (cih == NULL)
 			return NF_ACCEPT; /* The packet looks wrong, ignore */
 		tunnel = true;
-		outer_proto = "IPIP";
 	} else if ((cih->protocol == IPPROTO_UDP ||	/* Can be UDP encap */
 		    cih->protocol == IPPROTO_GRE) &&	/* Can be GRE encap */
 		   /* Error for our tunnel must arrive at LOCAL_IN */
-- 
1.8.3.1



