Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76AE4980D0
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 14:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243071AbiAXNQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 08:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243077AbiAXNQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 08:16:05 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87CFC061744;
        Mon, 24 Jan 2022 05:16:05 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id e28so11494990pfj.5;
        Mon, 24 Jan 2022 05:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I7Kfl0iYEEcM6De3k82IV85ORzkWhJdyfX79ePAXbNo=;
        b=kGDtXpI8RbYEDb+NHf6rtqjvtmFsukYaLBorp7pjuiAXcSmEHKmrw/KgIEjLKTqP2u
         qT7ObAsmIcoXOyRDR+rjc7vt31IJjAzkLJ1Awc8n/exe5AKxBYeHTQo/gcHrOBuYVIpM
         EOmGslV84c53mxEk01PMVModJD7hyl9AMiEBLTcbVf5HxutvQxal+/CEjcRNcVs+Ujp5
         yIAfw/yzd39FpS0mhelve7f45MIu+ZzEM63eoExYd1hxbuyjusDCFX61khl/1SnTSQ3P
         PTOyTxHthq/zfyXNhfGxXARqRCz7wegYxGxqBixvaz+zrr5IVveNpfFy7G79pH9cehWA
         xBVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I7Kfl0iYEEcM6De3k82IV85ORzkWhJdyfX79ePAXbNo=;
        b=uvp67VFAAzdmeCgmAaAU6YZs5EEA84RdQUry+Rrm8qcxLxsoUF5Y4OmTeQvTSrsaUi
         RSQnd68uYphEXtoZR4BiLZfeAKITtqWGG96TPZP+09Ph1bxETaE6lDtMjdMv1eVt3jHN
         /GKfKvtomOxggv1GmOEg9vz/4xbpRAgHgDRfk6/eY+tflwMS175xvoAwrYzR1ignlWgd
         0NmIGa9qWHby1EUf94uV7PPrN+yIWsDH4FPP7z//xOuSmppZEmU5oWzX8j4TFmZIGazD
         SVylqPJyyQoReSf2jfnJqcfFRxBnjE+SLUNAstN5NksfSjLQCns47/Zm12YeMFv7YLL1
         7+2w==
X-Gm-Message-State: AOAM532fIkZSspr+MWD6h2EpaioBIDGYcHQxqoIWA/XvksEGhmxjjoJl
        FNgpg+Zuo/E8S09XLaB4BJo=
X-Google-Smtp-Source: ABdhPJz9l+WWbd/wMeFWF+h29wP+FL0PAU6CxZG08MSVJK+QSdJjw1dUg3JFNIYSDYXv3mek2jAEsg==
X-Received: by 2002:a63:d312:: with SMTP id b18mr11952028pgg.198.1643030165340;
        Mon, 24 Jan 2022 05:16:05 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id j11sm16508806pfu.55.2022.01.24.05.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 05:16:04 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, imagedong@tencent.com,
        edumazet@google.com, alobakin@pm.me, paulb@nvidia.com,
        pabeni@redhat.com, talalahmad@google.com, haokexin@gmail.com,
        keescook@chromium.org, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        cong.wang@bytedance.com
Subject: [PATCH net-next 3/6] net: ipv4: use kfree_skb_reason() in ip_rcv_finish_core()
Date:   Mon, 24 Jan 2022 21:15:35 +0800
Message-Id: <20220124131538.1453657-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220124131538.1453657-1-imagedong@tencent.com>
References: <20220124131538.1453657-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() with kfree_skb_reason() in ip_rcv_finish_core(),
following drop reasons are introduced:

SKB_DROP_REASON_IP_ROUTE_INPUT
SKB_DROP_REASON_IP_RPFILTER
SKB_DROP_REASON_EARLY_DEMUX
SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     |  4 ++++
 include/trace/events/skb.h |  5 +++++
 net/ipv4/ip_input.c        | 22 ++++++++++++++++------
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f3028028b83e..8942d32c0657 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -324,6 +324,10 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_OTHERHOST,
 	SKB_DROP_REASON_IP_CSUM,
 	SKB_DROP_REASON_IP_INHDR,
+	SKB_DROP_REASON_IP_ROUTE_INPUT,
+	SKB_DROP_REASON_IP_RPFILTER,
+	SKB_DROP_REASON_EARLY_DEMUX,
+	SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST,
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index d1b0d9690e62..1dcdcc92cf08 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -20,6 +20,11 @@
 	EM(SKB_DROP_REASON_OTHERHOST, OTHERHOST)		\
 	EM(SKB_DROP_REASON_IP_CSUM, IP_CSUM)			\
 	EM(SKB_DROP_REASON_IP_INHDR, IP_INHDR)			\
+	EM(SKB_DROP_REASON_IP_ROUTE_INPUT, IP_ROUTE_INPUT)	\
+	EM(SKB_DROP_REASON_IP_RPFILTER, IP_RPFILTER)		\
+	EM(SKB_DROP_REASON_EARLY_DEMUX, EARLY_DEMUX)		\
+	EM(SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST,		\
+	   UNICAST_IN_L2_MULTICAST)				\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index ab9bee4bbf0a..77bb9ddc441b 100644
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
@@ -339,8 +341,10 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 		if (ipprot && (edemux = READ_ONCE(ipprot->early_demux))) {
 			err = INDIRECT_CALL_2(edemux, tcp_v4_early_demux,
 					      udp_v4_early_demux, skb);
-			if (unlikely(err))
+			if (unlikely(err)) {
+				drop_reason = SKB_DROP_REASON_EARLY_DEMUX;
 				goto drop_error;
+			}
 			/* must reload iph, skb->head might have changed */
 			iph = ip_hdr(skb);
 		}
@@ -353,8 +357,10 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 	if (!skb_valid_dst(skb)) {
 		err = ip_route_input_noref(skb, iph->daddr, iph->saddr,
 					   iph->tos, dev);
-		if (unlikely(err))
+		if (unlikely(err)) {
+			drop_reason = SKB_DROP_REASON_IP_ROUTE_INPUT;
 			goto drop_error;
+		}
 	}
 
 #ifdef CONFIG_IP_ROUTE_CLASSID
@@ -396,19 +402,23 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
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

