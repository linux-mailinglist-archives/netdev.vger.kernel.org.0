Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4BB4980CD
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 14:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243049AbiAXNQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 08:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243069AbiAXNQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 08:16:00 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6719DC061748;
        Mon, 24 Jan 2022 05:16:00 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id y17so5061049plg.7;
        Mon, 24 Jan 2022 05:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O88eKXAZyfDbUImGdIOspl+p31sKA6IRKKmfTf5yIqs=;
        b=E8W5K8vRb2LRLnX2+E+Ey1GWeDfcRPgBRijAMK7lGIH8dVCG/exxweu6oRR4+YFZIV
         haLSlmPafJFAw2h6C57D62+k7hmXE3VSSfjkIuqz8QIOqB4nn8YAO8j+Xmykcmcgmf/N
         rDpsaEHpwSnLDiAzRaFb9aRt8YHodLT02g1G0BkdNJjLEd6YBEbf31CqWQ5QMQIWRQ1T
         SPtBLfXgwfWvRK1Lb9feotDT3z+pUQ8RwKzOtgvpQ2AwsQHWx/czvIWIg7eJkySpXKnZ
         HFODSbaYvC0oxmunYN2rNIi1pReWeHepWZ2bGGqBIBJjsuPMWoH9FlbtQaRNpD+8QM1b
         NzbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O88eKXAZyfDbUImGdIOspl+p31sKA6IRKKmfTf5yIqs=;
        b=F8v3/BV57UzYb+ferEKEzcFl62/5TrKYznojHQRuSisH2Ez/FlHPRYCHFdkZHti2ij
         DZKAvBrueps/jactx4rhI7t84/ua56TQPP+nfGSQw6y8c3f169tEDnZSGXEFyrtL4Adl
         7mzgXlLqGA6rr11+n7L9lvlzgvQRILGItUQfbzGZFmbWsESa9qr/Q5C+lKvzBAUMw91x
         7SEXQOUdvex/8RLtfqJNsz6/kZUW9wkZ9ApneYqno/yxJW0QHdxrFPtkNVvIdyNS7vw+
         7PQLOl6JoTgb/VRkE0wCHGuzYckZ+qn5SZEJQddogffnEqBqyjRnRVu9Xy2Z2fXsUIlg
         NblA==
X-Gm-Message-State: AOAM531pYJj3S26ykMhcT1CrBVog7fqiomDJOeeNTV9SgEuVsIS6Am6U
        k3+VXidloqFuqgs0ZdM3rGPxrg38Wm4=
X-Google-Smtp-Source: ABdhPJyiiBSyVCynkgf6WjIlGDCIr1R5ShoYM9FU/heOFrIbh6hpwRJKPCslWeqbawLDdjWcTeWERA==
X-Received: by 2002:a17:90b:1801:: with SMTP id lw1mr1811740pjb.215.1643030160025;
        Mon, 24 Jan 2022 05:16:00 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id j11sm16508806pfu.55.2022.01.24.05.15.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 05:15:59 -0800 (PST)
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
Subject: [PATCH net-next 2/6] net: ipv4: use kfree_skb_reason() in ip_rcv_core()
Date:   Mon, 24 Jan 2022 21:15:34 +0800
Message-Id: <20220124131538.1453657-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220124131538.1453657-1-imagedong@tencent.com>
References: <20220124131538.1453657-1-imagedong@tencent.com>
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
 include/linux/skbuff.h     |  3 +++
 include/trace/events/skb.h |  3 +++
 net/ipv4/ip_input.c        | 15 +++++++++++----
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 1bcd690b8ae1..f3028028b83e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -321,6 +321,9 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_TCP_FILTER,
 	SKB_DROP_REASON_UDP_CSUM,
 	SKB_DROP_REASON_NETFILTER_DROP,
+	SKB_DROP_REASON_OTHERHOST,
+	SKB_DROP_REASON_IP_CSUM,
+	SKB_DROP_REASON_IP_INHDR,
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index beed7bb2bc0e..d1b0d9690e62 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -17,6 +17,9 @@
 	EM(SKB_DROP_REASON_TCP_FILTER, TCP_FILTER)		\
 	EM(SKB_DROP_REASON_UDP_CSUM, UDP_CSUM)			\
 	EM(SKB_DROP_REASON_NETFILTER_DROP, NETFILTER_DROP)	\
+	EM(SKB_DROP_REASON_OTHERHOST, OTHERHOST)		\
+	EM(SKB_DROP_REASON_IP_CSUM, IP_CSUM)			\
+	EM(SKB_DROP_REASON_IP_INHDR, IP_INHDR)			\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 3a025c011971..ab9bee4bbf0a 100644
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
 
@@ -478,7 +483,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 		       IPSTATS_MIB_NOECTPKTS + (iph->tos & INET_ECN_MASK),
 		       max_t(unsigned short, 1, skb_shinfo(skb)->gso_segs));
 
-	if (!pskb_may_pull(skb, iph->ihl*4))
+	if (!pskb_may_pull(skb, iph->ihl * 4))
 		goto inhdr_error;
 
 	iph = ip_hdr(skb);
@@ -490,7 +495,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 	if (skb->len < len) {
 		__IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
 		goto drop;
-	} else if (len < (iph->ihl*4))
+	} else if (len < (iph->ihl * 4))
 		goto inhdr_error;
 
 	/* Our transport medium may have padded the buffer out. Now we know it
@@ -516,11 +521,13 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
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

