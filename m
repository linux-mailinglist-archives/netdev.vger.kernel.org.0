Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108C949FD9E
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 17:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239775AbiA1QHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 11:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiA1QHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 11:07:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5622EC061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 08:07:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAE5B61EC4
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 16:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250F4C340E0;
        Fri, 28 Jan 2022 16:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643386024;
        bh=3Dt1tHzdKQA+cHDpI58JidXkWxE0sRS61B46CQDEOUQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Q4cMqa+dY5+euQkT3zzT+h7/5JF3uSa1QsRZTx2LbQBxC9uOGDyzbPDc2kwB30qVB
         NZx2O36CSkEfuO703WfHFsNSuR+qZNRMiftWzO4zFedMx3HFRzPJMrl9s0/KV+hTGi
         Q1s6Ee7DlDRr+Chm2GN0sf9vIdE0b9LHSCCi3nC6+/DQjHSUBqN7lbtcwy9J9dd7pv
         3E0PAAD3VKrwSaS1KaTEvZKQA97K5M0rqHfMCeCI7lRXBG30+R2v3zXng1cIIzl3r9
         6y+8BsQm+dZLcUHILUPxsQ/7RxisozGVmGGgyC0D3GxBlF/9dPUlzIjWBoz3+gw+iO
         kyl973sRtLnKA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] ipv4: drop fragmentation code from ip_options_build()
Date:   Fri, 28 Jan 2022 08:06:54 -0800
Message-Id: <20220128160654.1860428-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since v2.5.44 and addition of ip_options_fragment()
ip_options_build() does not render headers for fragments
directly. @is_frag is always 0.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/ip.h      |  2 +-
 net/ipv4/ip_options.c | 31 +++++++++----------------------
 net/ipv4/ip_output.c  |  6 +++---
 3 files changed, 13 insertions(+), 26 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index b51bae43b0dd..fdbab0c00fca 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -712,7 +712,7 @@ int ip_forward(struct sk_buff *skb);
  */
 
 void ip_options_build(struct sk_buff *skb, struct ip_options *opt,
-		      __be32 daddr, struct rtable *rt, int is_frag);
+		      __be32 daddr, struct rtable *rt);
 
 int __ip_options_echo(struct net *net, struct ip_options *dopt,
 		      struct sk_buff *skb, const struct ip_options *sopt);
diff --git a/net/ipv4/ip_options.c b/net/ipv4/ip_options.c
index da1b5038bdfd..a9e22a098872 100644
--- a/net/ipv4/ip_options.c
+++ b/net/ipv4/ip_options.c
@@ -42,7 +42,7 @@
  */
 
 void ip_options_build(struct sk_buff *skb, struct ip_options *opt,
-		      __be32 daddr, struct rtable *rt, int is_frag)
+		      __be32 daddr, struct rtable *rt)
 {
 	unsigned char *iph = skb_network_header(skb);
 
@@ -53,28 +53,15 @@ void ip_options_build(struct sk_buff *skb, struct ip_options *opt,
 	if (opt->srr)
 		memcpy(iph + opt->srr + iph[opt->srr + 1] - 4, &daddr, 4);
 
-	if (!is_frag) {
-		if (opt->rr_needaddr)
-			ip_rt_get_source(iph + opt->rr + iph[opt->rr + 2] - 5, skb, rt);
-		if (opt->ts_needaddr)
-			ip_rt_get_source(iph + opt->ts + iph[opt->ts + 2] - 9, skb, rt);
-		if (opt->ts_needtime) {
-			__be32 midtime;
+	if (opt->rr_needaddr)
+		ip_rt_get_source(iph + opt->rr + iph[opt->rr + 2] - 5, skb, rt);
+	if (opt->ts_needaddr)
+		ip_rt_get_source(iph + opt->ts + iph[opt->ts + 2] - 9, skb, rt);
+	if (opt->ts_needtime) {
+		__be32 midtime;
 
-			midtime = inet_current_timestamp();
-			memcpy(iph + opt->ts + iph[opt->ts + 2] - 5, &midtime, 4);
-		}
-		return;
-	}
-	if (opt->rr) {
-		memset(iph + opt->rr, IPOPT_NOP, iph[opt->rr + 1]);
-		opt->rr = 0;
-		opt->rr_needaddr = 0;
-	}
-	if (opt->ts) {
-		memset(iph + opt->ts, IPOPT_NOP, iph[opt->ts + 1]);
-		opt->ts = 0;
-		opt->ts_needaddr = opt->ts_needtime = 0;
+		midtime = inet_current_timestamp();
+		memcpy(iph + opt->ts + iph[opt->ts + 2] - 5, &midtime, 4);
 	}
 }
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 139cec29ed06..0c0574eb5f5b 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -179,7 +179,7 @@ int ip_build_and_send_pkt(struct sk_buff *skb, const struct sock *sk,
 
 	if (opt && opt->opt.optlen) {
 		iph->ihl += opt->opt.optlen>>2;
-		ip_options_build(skb, &opt->opt, daddr, rt, 0);
+		ip_options_build(skb, &opt->opt, daddr, rt);
 	}
 
 	skb->priority = sk->sk_priority;
@@ -519,7 +519,7 @@ int __ip_queue_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl,
 
 	if (inet_opt && inet_opt->opt.optlen) {
 		iph->ihl += inet_opt->opt.optlen >> 2;
-		ip_options_build(skb, &inet_opt->opt, inet->inet_daddr, rt, 0);
+		ip_options_build(skb, &inet_opt->opt, inet->inet_daddr, rt);
 	}
 
 	ip_select_ident_segs(net, skb, sk,
@@ -1541,7 +1541,7 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 
 	if (opt) {
 		iph->ihl += opt->optlen >> 2;
-		ip_options_build(skb, opt, cork->addr, rt, 0);
+		ip_options_build(skb, opt, cork->addr, rt);
 	}
 
 	skb->priority = (cork->tos != -1) ? cork->priority: sk->sk_priority;
-- 
2.34.1

