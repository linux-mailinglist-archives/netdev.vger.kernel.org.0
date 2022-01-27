Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B1F49DD8B
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238405AbiA0JOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:14:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiA0JOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 04:14:05 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A244C06173B;
        Thu, 27 Jan 2022 01:14:05 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id x11so1949194plg.6;
        Thu, 27 Jan 2022 01:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w3YfXYwf6leAIb9pOlV8H4EpsmXCP8MCeqEUbaPVjyc=;
        b=Nfx1InlJYov9ejrIoKHTeUElTm321Q+oj8Op1IO3QL4XVO/ejbSFs7Ap1IB9cVSwHy
         7Bsl++8888G0XZHlBplWHfT7ghJanVzEgeZn6DGB0CFqawTYaHiySuedQY9PXQs423gR
         967Clu4cRcMPBVKbxaqWKBtITKAaWyrDxIBJvRX/cDx+VJqtYgsIx072XKsVNnAKZ2HX
         RLoGnismV4pdjOd01xUtbYdB++gk7g6PEoo8u5zZpW+1yyG2phRymfpefa5TS0dNhqZl
         P0pKkkFk4LYpLvUO7FG65Vvv1lAxgKDNC8qqMDNA0VGZvTnCcrtUT+Dde6IZQ8qL47Ma
         V7rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w3YfXYwf6leAIb9pOlV8H4EpsmXCP8MCeqEUbaPVjyc=;
        b=J5FOjDEHWWayHrf7grqN07KLwZyQlFY2RME4riqHV49MvDlRXlzOoJdh7QqNJddXeq
         pc46HueQ2wK6v5l17f27SDwDOtFSjvMkvZvy6hmGNTkGsqQQNv9jybD5emljOx/RcKhy
         lCVFsEJHXPxdcXlmOGbTDrJktqf9KBADnRniNCSjimm/repl1DePB9RqgFXvOaVvAn5w
         fJM4gu7GdfHVed6VtXuKLUmFRtl/gpzsxuPkfejzDyhAvc0jd6wdIGzhNEpJ0aCPhbEI
         I8DFEc+T14vwNHoGb4jrAqeiU4SuZ+Xb972B6dkK+FxiQJVxczLMs38HVlIwZC28+gUF
         Tb7g==
X-Gm-Message-State: AOAM530dQJH6Ga6xdwzEu9Ymh1WUbw5LT+dtc9meUjkb2aKWGnFfZBiP
        dJuh77ODOVTlBu8ZZXbc5Pg=
X-Google-Smtp-Source: ABdhPJyWiAJ98iTWD8aNOHlUaj1FO5j2c1X66G6BCbP4ejaXIs8xRTuwx5dd9AZY47dPecpWgfmaEA==
X-Received: by 2002:a17:902:e788:: with SMTP id cp8mr2331391plb.172.1643274844984;
        Thu, 27 Jan 2022 01:14:04 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id j11sm2046338pjf.53.2022.01.27.01.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 01:14:04 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, edumazet@google.com, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, imagedong@tencent.com,
        alobakin@pm.me, pabeni@redhat.com, cong.wang@bytedance.com,
        talalahmad@google.com, haokexin@gmail.com, keescook@chromium.org,
        memxor@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, mengensun@tencent.com
Subject: [PATCH v2 net-next 5/8] net: ipv4: use kfree_skb_reason() in ip_rcv_finish_core()
Date:   Thu, 27 Jan 2022 17:13:05 +0800
Message-Id: <20220127091308.91401-6-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220127091308.91401-1-imagedong@tencent.com>
References: <20220127091308.91401-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() with kfree_skb_reason() in ip_rcv_finish_core(),
following drop reasons are introduced:

SKB_DROP_REASON_IP_RPFILTER
SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v2:
- remove SKB_DROP_REASON_EARLY_DEMUX and SKB_DROP_REASON_IP_ROUTE_INPUT
- add document for SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST and
  SKB_DROP_REASON_IP_RPFILTER
---
 include/linux/skbuff.h     |  9 +++++++++
 include/trace/events/skb.h |  3 +++
 net/ipv4/ip_input.c        | 14 ++++++++++----
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 2e87da91424f..2d712459d564 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -330,6 +330,15 @@ enum skb_drop_reason {
 					 * IP header (see
 					 * IPSTATS_MIB_INHDRERRORS)
 					 */
+	SKB_DROP_REASON_IP_RPFILTER,	/* IP rpfilter validate failed.
+					 * see the document for rp_filter
+					 * in ip-sysctl.rst for more
+					 * information
+					 */
+	SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST, /* destination address of L2
+						  * is multicast, but L3 is
+						  * unicast.
+						  */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index f2b1778485f0..485a1d3034a4 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -20,6 +20,9 @@
 	EM(SKB_DROP_REASON_OTHERHOST, OTHERHOST)		\
 	EM(SKB_DROP_REASON_IP_CSUM, IP_CSUM)			\
 	EM(SKB_DROP_REASON_IP_INHDR, IP_INHDR)			\
+	EM(SKB_DROP_REASON_IP_RPFILTER, IP_RPFILTER)		\
+	EM(SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST,		\
+	   UNICAST_IN_L2_MULTICAST)				\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 7f64c5432cba..184decb1c8eb 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -318,8 +318,10 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 {
 	const struct iphdr *iph = ip_hdr(skb);
 	int (*edemux)(struct sk_buff *skb);
+	int err, drop_reason;
 	struct rtable *rt;
-	int err;
+
+	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 
 	if (ip_can_use_hint(skb, iph, hint)) {
 		err = ip_route_use_hint(skb, iph->daddr, iph->saddr, iph->tos,
@@ -396,19 +398,23 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 		 * so-called "hole-196" attack) so do it for both.
 		 */
 		if (in_dev &&
-		    IN_DEV_ORCONF(in_dev, DROP_UNICAST_IN_L2_MULTICAST))
+		    IN_DEV_ORCONF(in_dev, DROP_UNICAST_IN_L2_MULTICAST)) {
+			drop_reason = SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST;
 			goto drop;
+		}
 	}
 
 	return NET_RX_SUCCESS;
 
 drop:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return NET_RX_DROP;
 
 drop_error:
-	if (err == -EXDEV)
+	if (err == -EXDEV) {
+		drop_reason = SKB_DROP_REASON_IP_RPFILTER;
 		__NET_INC_STATS(net, LINUX_MIB_IPRPFILTER);
+	}
 	goto drop;
 }
 
-- 
2.34.1

