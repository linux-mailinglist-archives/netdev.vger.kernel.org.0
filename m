Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFED49F465
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 08:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346849AbiA1HeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 02:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346837AbiA1HeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 02:34:03 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80401C061714;
        Thu, 27 Jan 2022 23:34:03 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id d187so5374687pfa.10;
        Thu, 27 Jan 2022 23:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mOTKGJo2ptZmxhh20F6vP7nFZ10swZHTBsqufq2gJow=;
        b=kzwius+Joffqz2Xy6JtuZk2V+ZOZ0aW5vrxJY8Sgg2ovC/Bbc/1ec3ClZSBl0RI1UA
         N8yRgvMBENE8Q9DxgsQCfnBK5yPl1hplDWBI33STrj1XhUlwIflmc3cZb6/NLF8kKRLA
         Mq5iKwpVB4fvDIz7p58gxt9ijhUbNXyHFNF+hVwZpf6g+pEMIxRf5YSeRY9DUHMtUaxr
         pqoqrXHHnoP7eNumVL1H7/aqcSTobwi3LKYwB79TJXVdnaTBwcrfbuHvzIEt8g0OOYAL
         Y0QSQoPL6hDKAoMx+do/2TXSZYHX7rGASLqwl+xfjZWaDSmnERR/V2GG08kmtgdRPFwv
         sezg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mOTKGJo2ptZmxhh20F6vP7nFZ10swZHTBsqufq2gJow=;
        b=ut7Yj4eZVmBYodoGw+0IFJXvTjIe//Hgy+0GNkA2wZzW33jf5GdSB+RmPmRtz/1wgM
         3cGVKSaTyorSDbUnlMQrSmi0sZfWblObaJDDPMLWOEVkTbvJnTFVKlXeOQlP+bwYuNV9
         ldE0fRTFvKEiwZJoWnwps87qjhz+86QVejq59M5dSUvdzhUeIjFly6E+SAS5936VTAf2
         ZrF1UCaL+1h7BM6kdZl0B04Gl78fvm+tTjj+H1S3+/MAeA/YAhFLFGxLQbl0wWGLA0at
         NwQRhWj4S2fsN3MD0Fr+mzGWRFM+IBPz0TMuxTdoS3NxDQMuPjteFWZ2mf03vkUDTUt9
         oYIw==
X-Gm-Message-State: AOAM531X96Dsv4BSt9y67V8RFyCnWAUswQQJU3pRr5WQNt25fgjgEHB8
        fqwZ99LSpfCrP2s85umHW/A=
X-Google-Smtp-Source: ABdhPJztFBRkOdErwXtueSld+b1Ha9wpg+AmPCC6X4YvuwYN0POPKKW23rqX93/XTAdgN4aCnNBObw==
X-Received: by 2002:a63:2021:: with SMTP id g33mr5565011pgg.51.1643355243067;
        Thu, 27 Jan 2022 23:34:03 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id q17sm8548846pfu.160.2022.01.27.23.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 23:34:02 -0800 (PST)
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
Subject: [PATCH v3 net-next 3/7] net: ipv4: use kfree_skb_reason() in ip_rcv_core()
Date:   Fri, 28 Jan 2022 15:33:15 +0800
Message-Id: <20220128073319.1017084-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220128073319.1017084-1-imagedong@tencent.com>
References: <20220128073319.1017084-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() with kfree_skb_reason() in ip_rcv_core(). Three new
drop reasons are introduced:

SKB_DROP_REASON_OTHERHOST
SKB_DROP_REASON_IP_CSUM
SKB_DROP_REASON_IP_INHDR

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v3:
- add a path to SKB_DROP_REASON_PKT_TOO_SMALL

v2:
- remove unrelated cleanup
- add document for introduced drop reasons
---
 include/linux/skbuff.h     |  9 +++++++++
 include/trace/events/skb.h |  3 +++
 net/ipv4/ip_input.c        | 12 ++++++++++--
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 786ea2c2334e..2e87da91424f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -321,6 +321,15 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_SOCKET_FILTER,	/* dropped by socket filter */
 	SKB_DROP_REASON_UDP_CSUM,	/* UDP checksum error */
 	SKB_DROP_REASON_NETFILTER_DROP,	/* dropped by netfilter */
+	SKB_DROP_REASON_OTHERHOST,	/* packet don't belong to current
+					 * host (interface is in promisc
+					 * mode)
+					 */
+	SKB_DROP_REASON_IP_CSUM,	/* IP checksum error */
+	SKB_DROP_REASON_IP_INHDR,	/* there is something wrong with
+					 * IP header (see
+					 * IPSTATS_MIB_INHDRERRORS)
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 3d89f7b09a43..f2b1778485f0 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -17,6 +17,9 @@
 	EM(SKB_DROP_REASON_SOCKET_FILTER, SOCKET_FILTER)	\
 	EM(SKB_DROP_REASON_UDP_CSUM, UDP_CSUM)			\
 	EM(SKB_DROP_REASON_NETFILTER_DROP, NETFILTER_DROP)	\
+	EM(SKB_DROP_REASON_OTHERHOST, OTHERHOST)		\
+	EM(SKB_DROP_REASON_IP_CSUM, IP_CSUM)			\
+	EM(SKB_DROP_REASON_IP_INHDR, IP_INHDR)			\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 3a025c011971..627fad437593 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -436,13 +436,18 @@ static int ip_rcv_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
 static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 {
 	const struct iphdr *iph;
+	int drop_reason;
 	u32 len;
 
+	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
+
 	/* When the interface is in promisc. mode, drop all the crap
 	 * that it receives, do not try to analyse it.
 	 */
-	if (skb->pkt_type == PACKET_OTHERHOST)
+	if (skb->pkt_type == PACKET_OTHERHOST) {
+		drop_reason = SKB_DROP_REASON_OTHERHOST;
 		goto drop;
+	}
 
 	__IP_UPD_PO_STATS(net, IPSTATS_MIB_IN, skb->len);
 
@@ -488,6 +493,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 
 	len = ntohs(iph->tot_len);
 	if (skb->len < len) {
+		drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
 		__IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
 		goto drop;
 	} else if (len < (iph->ihl*4))
@@ -516,11 +522,13 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 	return skb;
 
 csum_error:
+	drop_reason = SKB_DROP_REASON_IP_CSUM;
 	__IP_INC_STATS(net, IPSTATS_MIB_CSUMERRORS);
 inhdr_error:
+	drop_reason = drop_reason ?: SKB_DROP_REASON_IP_INHDR;
 	__IP_INC_STATS(net, IPSTATS_MIB_INHDRERRORS);
 drop:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 out:
 	return NULL;
 }
-- 
2.34.1

