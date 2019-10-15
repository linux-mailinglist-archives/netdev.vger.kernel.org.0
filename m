Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1A70D7026
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 09:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727651AbfJOHc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 03:32:57 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:42110 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbfJOHc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 03:32:57 -0400
Received: from penelope.horms.nl (ip4dab7138.direct-adsl.nl [77.171.113.56])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 67E1225B701;
        Tue, 15 Oct 2019 18:32:54 +1100 (AEDT)
Received: by penelope.horms.nl (Postfix, from userid 7100)
        id 6EC99E202B4; Tue, 15 Oct 2019 09:32:52 +0200 (CEST)
From:   Simon Horman <horms@verge.net.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Wensong Zhang <wensong@linux-vs.org>,
        Julian Anastasov <ja@ssi.bg>, zhang kai <zhangkaiheb@126.com>,
        Simon Horman <horms@verge.net.au>
Subject: [PATCH 1/6] ipvs: no need to update skb route entry for local destination packets.
Date:   Tue, 15 Oct 2019 09:32:07 +0200
Message-Id: <20191015073212.19394-2-horms@verge.net.au>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191015073212.19394-1-horms@verge.net.au>
References: <20191015073212.19394-1-horms@verge.net.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhang kai <zhangkaiheb@126.com>

In the end of function __ip_vs_get_out_rt/__ip_vs_get_out_rt_v6,the
'local' variable is always zero.

Signed-off-by: zhang kai <zhangkaiheb@126.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 net/netfilter/ipvs/ip_vs_xmit.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 888d3068a492..b1e300f8881b 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -407,12 +407,9 @@ __ip_vs_get_out_rt(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 		goto err_put;
 
 	skb_dst_drop(skb);
-	if (noref) {
-		if (!local)
-			skb_dst_set_noref(skb, &rt->dst);
-		else
-			skb_dst_set(skb, dst_clone(&rt->dst));
-	} else
+	if (noref)
+		skb_dst_set_noref(skb, &rt->dst);
+	else
 		skb_dst_set(skb, &rt->dst);
 
 	return local;
@@ -574,12 +571,9 @@ __ip_vs_get_out_rt_v6(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 		goto err_put;
 
 	skb_dst_drop(skb);
-	if (noref) {
-		if (!local)
-			skb_dst_set_noref(skb, &rt->dst);
-		else
-			skb_dst_set(skb, dst_clone(&rt->dst));
-	} else
+	if (noref)
+		skb_dst_set_noref(skb, &rt->dst);
+	else
 		skb_dst_set(skb, &rt->dst);
 
 	return local;
-- 
2.11.0

