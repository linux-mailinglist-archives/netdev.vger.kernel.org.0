Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5964980D3
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 14:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243087AbiAXNQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 08:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243076AbiAXNQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 08:16:10 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B4CC06173B;
        Mon, 24 Jan 2022 05:16:10 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id i8so15311473pgt.13;
        Mon, 24 Jan 2022 05:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bbIwpa2HKtPGNZ5ti6tjdrZrFRI38QINO2+UYVbJdYQ=;
        b=gpbMAew2b+vep0adLFGdhSjoUwwNOu28ixF3C0IeCEeM5JPO6jrF2HDDOvEPFG7ZQf
         R+pU1pDKEiz5etn0ehviAZAOtOWOHQoA9XyxU3ifCHvhYpLJ6emkYe1NdgsVUcZxVRNn
         08hGdgYxJU7/5Sdz8U2XJWTE7QTDuGvaJ4zBT/rIUvtktNKGeX5HK4d/JzIr0YT9KZeA
         Lgj0APiQTTqjvTPXjya2RPtZh9dSP4GRiWAYYWhRlAR6BwUz83fiaeJr9aF56HnXorb3
         Nvb0tOiMJiLNcl+/igxrqHbj3wY1bRXl5x1hOxwSgbmLqo8G4P/T4XzC6euLzWDA0kUG
         Sl7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bbIwpa2HKtPGNZ5ti6tjdrZrFRI38QINO2+UYVbJdYQ=;
        b=o1yCYmjzPpWVJQX9+SJEkHvG4DWEbQzPZ87zDiEci7ch/jXsc2KvUSk7H/pRLwxdLe
         Zl547OpSIaUILF+pA8ozis00s3D4TXnfYz10sjOxPM1dvNBqAwBzowbuj5IFMz63HJUC
         ihpcKvExFZ/rpnbZZPG2LkSTi0AZJUzUTkxwumvA1EgfpLC639UYY4t58F8i4jgI7iBZ
         Mu22Hs1+V1YsaebQqxDBGiio/B9FfeZIYnu0L87tXuit9Vpq2PU2aY+r7FhsrBLL31cd
         5xFoY1e6pByFSBirvBTxmwhOLYGLOdimSe7qcbzt5mzRRs/hApNEP+xf3qNjYk3KxM/j
         EGjg==
X-Gm-Message-State: AOAM533IhHSPNnWloYUgxetzN5He5nxki9s60WnCbOfDVSEBYeyPEK6M
        s12DDD1ZMdrCjby2E8iVbC8=
X-Google-Smtp-Source: ABdhPJxwYGoYD4VqxA5ZquAvqI/k2yGTOIJwjnY+ZIkUmRPmEvxaSIGD1AV/cPHB1XHb4sTDP9ZRYQ==
X-Received: by 2002:a65:63c2:: with SMTP id n2mr11567070pgv.609.1643030170430;
        Mon, 24 Jan 2022 05:16:10 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id j11sm16508806pfu.55.2022.01.24.05.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 05:16:09 -0800 (PST)
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
Subject: [PATCH net-next 4/6] net: ipv4: use kfree_skb_reason() in ip_protocol_deliver_rcu()
Date:   Mon, 24 Jan 2022 21:15:36 +0800
Message-Id: <20220124131538.1453657-5-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220124131538.1453657-1-imagedong@tencent.com>
References: <20220124131538.1453657-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() with kfree_skb_reason() in ip_protocol_deliver_rcu().
Following new drop reasons are introduced:

SKB_DROP_REASON_XFRM_POLICY
SKB_DROP_REASON_IP_NOPROTO

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 2 ++
 include/trace/events/skb.h | 2 ++
 net/ipv4/ip_input.c        | 5 +++--
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 8942d32c0657..603f77ef2170 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -328,6 +328,8 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_IP_RPFILTER,
 	SKB_DROP_REASON_EARLY_DEMUX,
 	SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST,
+	SKB_DROP_REASON_XFRM_POLICY,
+	SKB_DROP_REASON_IP_NOPROTO,
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 1dcdcc92cf08..e8369b8e8430 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -25,6 +25,8 @@
 	EM(SKB_DROP_REASON_EARLY_DEMUX, EARLY_DEMUX)		\
 	EM(SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST,		\
 	   UNICAST_IN_L2_MULTICAST)				\
+	EM(SKB_DROP_REASON_XFRM_POLICY, XFRM_POLICY)		\
+	EM(SKB_DROP_REASON_IP_NOPROTO, IP_NOPROTO)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index a4afb367cf02..376c96cfd5d1 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -196,7 +196,8 @@ void ip_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int protocol)
 	if (ipprot) {
 		if (!ipprot->no_policy) {
 			if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb)) {
-				kfree_skb(skb);
+				kfree_skb_reason(skb,
+						 SKB_DROP_REASON_XFRM_POLICY);
 				return;
 			}
 			nf_reset_ct(skb);
@@ -215,7 +216,7 @@ void ip_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int protocol)
 				icmp_send(skb, ICMP_DEST_UNREACH,
 					  ICMP_PROT_UNREACH, 0);
 			}
-			kfree_skb(skb);
+			kfree_skb_reason(skb, SKB_DROP_REASON_IP_NOPROTO);
 		} else {
 			__IP_INC_STATS(net, IPSTATS_MIB_INDELIVERS);
 			consume_skb(skb);
-- 
2.34.1

