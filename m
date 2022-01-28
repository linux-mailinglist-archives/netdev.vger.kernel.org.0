Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6520B49F468
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 08:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346786AbiA1HeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 02:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346790AbiA1HeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 02:34:10 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6384EC061747;
        Thu, 27 Jan 2022 23:34:10 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id i17so5357875pfq.13;
        Thu, 27 Jan 2022 23:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w3YfXYwf6leAIb9pOlV8H4EpsmXCP8MCeqEUbaPVjyc=;
        b=mdWPKm3PPciue7TUvewktVp3exqSTPPeDNPw+2pRa4TJjOmROeZK8lE8SIsn2IKT1a
         ARFyzZlS0Y3c7TfM+pynqFuDcEpCZViKjABznxaFO/pp+qStDMunMTkEC6a9/bq9hxCq
         57j8P7Fg0yqJkZdWkrUP4qpsfT2bQtuVsKs0Us91NqarEFR68/xIX8LKkWTyKIX8aNgR
         EA3jlpra1fEaEp1uNnKK+QVdFN40RMwZaqnIpAR/OAnkC8bHr63a3OP3i2lt0ufQTTjx
         2epUzReNtS/Gwa4KuRVi6KRuxp3pGGgtxlJRXkO09p9FrPWSCBDSU8y9f+jm0ktBlF0U
         ASgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w3YfXYwf6leAIb9pOlV8H4EpsmXCP8MCeqEUbaPVjyc=;
        b=Hjmj89DeTKriika/dGoxYeD0LVyQdci+9Su1M79hhCtiiL+FbgN5CadNcKptK8hx5j
         +9nsVzGbYvoMqR388wPJxIJdcQ4QjY11T2Scjc4yD0kCA+yiJMcLu0v2JRAUo57hU9Lr
         7eaiCCgyrBLb44T81iwH2jTm4yqvhRuQhJ1ipktDgUyjW4cB8gw1kLLpJ4Qz04hvVxYC
         ByU6LEIpErJsr3dKshrwEv/KQHs9P25rBc21lWbb3bmRwWJdlHhXxmVx5RbntUqaf0XQ
         8rLldgsQoceyOiPjQ7p5Z6tSFbquZfuAFOmMBtW9Csy/qlDm1pJ4D8IJh+D3EgdGXS/S
         sqIg==
X-Gm-Message-State: AOAM530ISzNoHFn5qQErGRBq0K/JtYOb2tVZcuvNBOo89V8WMBiQNUR2
        IBh2dvemlhiXt266/1k6HuI=
X-Google-Smtp-Source: ABdhPJxH9nVgQPXkPNkg28Ic0BZeAfAE6HJ28QzhhAbwHs8S4YRrwRwRgWrsgwQjvBAmXlhG6E3YbA==
X-Received: by 2002:a05:6a00:218b:: with SMTP id h11mr7147821pfi.29.1643355250002;
        Thu, 27 Jan 2022 23:34:10 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id q17sm8548846pfu.160.2022.01.27.23.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 23:34:09 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, imagedong@tencent.com, edumazet@google.com,
        alobakin@pm.me, paulb@nvidia.com, keescook@chromium.org,
        talalahmad@google.com, haokexin@gmail.com, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        cong.wang@bytedance.com, mengensun@tencent.com
Subject: [PATCH v3 net-next 4/7] net: ipv4: use kfree_skb_reason() in ip_rcv_finish_core()
Date:   Fri, 28 Jan 2022 15:33:16 +0800
Message-Id: <20220128073319.1017084-5-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220128073319.1017084-1-imagedong@tencent.com>
References: <20220128073319.1017084-1-imagedong@tencent.com>
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

