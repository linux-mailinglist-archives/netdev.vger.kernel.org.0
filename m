Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6252B27BC47
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 07:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgI2FEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 01:04:24 -0400
Received: from mail-m973.mail.163.com ([123.126.97.3]:60498 "EHLO
        mail-m973.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgI2FEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 01:04:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=6uKgF
        uXFSap/EdUsAgj497IozAnPWYkZEiXqqo30dV4=; b=TDuUmUecsCWlsrrmVse8P
        PNPgB0PgbMi63CXLyukIN/JcSXL02GseHhw0sIeKlqkeIX4yVgAd8jEl1cyXglHu
        7IFpeIkM0iUMOUqoSg08Oq52phT47DWZ7avEKsqV/VMH0pCjt2MZFQ57u2bqvkT4
        v2nGnMN7Sl8e1kHqAFs5KA=
Received: from localhost.localdomain (unknown [111.202.93.98])
        by smtp3 (Coremail) with SMTP id G9xpCgAHEcIUwHJfwCOTEg--.1476S2;
        Tue, 29 Sep 2020 13:03:16 +0800 (CST)
From:   "longguang.yue" <bigclouds@163.com>
Cc:     yuelongguang@gmail.com, "longguang.yue" <bigclouds@163.com>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:IPVS),
        lvs-devel@vger.kernel.org (open list:IPVS),
        netfilter-devel@vger.kernel.org (open list:NETFILTER),
        coreteam@netfilter.org (open list:NETFILTER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] ipvs: Add traffic statistic up even it is VS/DR or VS/TUN mode
Date:   Tue, 29 Sep 2020 13:03:02 +0800
Message-Id: <20200929050302.28105-1-bigclouds@163.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: G9xpCgAHEcIUwHJfwCOTEg--.1476S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZw1UAF45Wr13Kr17tF1fWFg_yoWfXwcEy3
        yvgFy3Wr4rZ3yDKa17XF4xWFyDt3y8JF1fGryIvFWjy347C34Yy3sagr97Cr1fGa9xZFyU
        JrZ7tryIqw1jgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0SzuJUUUUU==
X-Originating-IP: [111.202.93.98]
X-CM-SenderInfo: peljuzprxg2qqrwthudrp/xtbBZxSuQ1et0VA85gAAs-
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's ipvs's duty to do traffic statistic if packets get hit,
no matter what mode it is.

Signed-off-by: longguang.yue <bigclouds@163.com>
---
 net/netfilter/ipvs/ip_vs_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index e3668a6e54e4..ed523057f07f 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1413,8 +1413,11 @@ ip_vs_out(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, in
 			     ipvs, af, skb, &iph);
 
 	if (likely(cp)) {
-		if (IP_VS_FWD_METHOD(cp) != IP_VS_CONN_F_MASQ)
+		if (IP_VS_FWD_METHOD(cp) != IP_VS_CONN_F_MASQ){
+			ip_vs_out_stats(cp, skb);
+			skb->ipvs_property = 1;
 			goto ignore_cp;
+		}
 		return handle_response(af, skb, pd, cp, &iph, hooknum);
 	}
 
-- 
2.20.1 (Apple Git-117)

