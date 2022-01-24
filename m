Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251D04980D8
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 14:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243103AbiAXNQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 08:16:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243095AbiAXNQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 08:16:16 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC98C06173D;
        Mon, 24 Jan 2022 05:16:16 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id j10so3215190pgc.6;
        Mon, 24 Jan 2022 05:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y79107MnbAk14rpj6xPrfrI/dwJH+6GIzGrPuGsa7dI=;
        b=aGLivlnEmsp5izTPw1TRX8a+9zEI51Gnea5ofIDL3nLHrZIj4s6aHunamdc/KC8gQL
         uup6S4n8sZsOuT0O/UknErGAeMbUgrbHWHzBkh/d/zI32ppqsgKzrZ6R6C+dtug/75gC
         RWw1dUwL72WcwZHoIj/aBCOSZKTTLv3/2jgSHuw6uN0ktHvkO/+8nB56R045uSdPdCT9
         YqIwyrbEK37ehh2tOPhgsT2fsrZMsz8YvFH0aylf8U8Qqt0zOLb6I8Lh58pvU91m7eWK
         158hjQwv5ymojVsRnFHgolKIXyCvPS068C3ZwXe3pn8yxPDo4r3JxcaLiRaEMdONZUQJ
         9W1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y79107MnbAk14rpj6xPrfrI/dwJH+6GIzGrPuGsa7dI=;
        b=EoPxPw/l5K+NfAjb02ZZeuoXhr9RQmptcFzgWaBkOSJCWCWya4vSRkw0B3hYXobN4V
         CpMYoDcxKID4GFHoFdJXuVGZ+KUjYtnwdpQlk1yPpKi3CVObOW6J2fSJn80kzMoS2tOZ
         b3sSKxyY2mG16j79J9DrSO9klmS9rDlZX6Fb2jHYtswD65ScLLlWOa39KtDlFg6JxeIp
         6c9GC/678bSs46i3kc/z0y6sMpTaGA2Lfo77MMIyMDGeFX+fRfbqazJZu1bHmnXQeToE
         syWbrqP+43vJH7Rus4gqmk++0XU3JkIBjYEdt3NZcDhPA4moNp6Ag8YI/UIKWRVZ4s8u
         DyHQ==
X-Gm-Message-State: AOAM531G5R/LFtZwE19kOFu43X44FXpwof9XrrShc6awbLkAA5zFO+PI
        WoiFn/u1BQsFUBk476zzCRapa+zmHXk=
X-Google-Smtp-Source: ABdhPJz0D3XJ5hP55ygW2RYxhk22jhdlt2cnuwbzC3FiUStqBv0CvvZz2KuVdT2zx+dM7ldZRQeo1A==
X-Received: by 2002:a63:f201:: with SMTP id v1mr3295910pgh.250.1643030175589;
        Mon, 24 Jan 2022 05:16:15 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id j11sm16508806pfu.55.2022.01.24.05.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 05:16:15 -0800 (PST)
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
Subject: [PATCH net-next 5/6] net: udp: use kfree_skb_reason() in udp_queue_rcv_one_skb()
Date:   Mon, 24 Jan 2022 21:15:37 +0800
Message-Id: <20220124131538.1453657-6-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220124131538.1453657-1-imagedong@tencent.com>
References: <20220124131538.1453657-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() with kfree_skb_reason() in udp_queue_rcv_one_skb().
Following new drop reasons are introduced:

SKB_DROP_REASON_UDP_FILTER

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     |  1 +
 include/trace/events/skb.h |  1 +
 net/ipv4/udp.c             | 12 +++++++++---
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 603f77ef2170..dd64a4f2ff1d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -330,6 +330,7 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST,
 	SKB_DROP_REASON_XFRM_POLICY,
 	SKB_DROP_REASON_IP_NOPROTO,
+	SKB_DROP_REASON_UDP_FILTER,
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index e8369b8e8430..6db61ce4d6f5 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -27,6 +27,7 @@
 	   UNICAST_IN_L2_MULTICAST)				\
 	EM(SKB_DROP_REASON_XFRM_POLICY, XFRM_POLICY)		\
 	EM(SKB_DROP_REASON_IP_NOPROTO, IP_NOPROTO)		\
+	EM(SKB_DROP_REASON_UDP_FILTER, UDP_FILTER)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 464590ea922e..57681e98e6bf 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2120,14 +2120,17 @@ static int __udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
  */
 static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 {
+	int drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	struct udp_sock *up = udp_sk(sk);
 	int is_udplite = IS_UDPLITE(sk);
 
 	/*
 	 *	Charge it to the socket, dropping if the queue is full.
 	 */
-	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
+	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb)) {
+		drop_reason = SKB_DROP_REASON_XFRM_POLICY;
 		goto drop;
+	}
 	nf_reset_ct(skb);
 
 	if (static_branch_unlikely(&udp_encap_needed_key) && up->encap_type) {
@@ -2204,8 +2207,10 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 	    udp_lib_checksum_complete(skb))
 			goto csum_error;
 
-	if (sk_filter_trim_cap(sk, skb, sizeof(struct udphdr)))
+	if (sk_filter_trim_cap(sk, skb, sizeof(struct udphdr))) {
+		drop_reason = SKB_DROP_REASON_UDP_FILTER;
 		goto drop;
+	}
 
 	udp_csum_pull_header(skb);
 
@@ -2213,11 +2218,12 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 	return __udp_queue_rcv_skb(sk, skb);
 
 csum_error:
+	drop_reason = SKB_DROP_REASON_UDP_CSUM;
 	__UDP_INC_STATS(sock_net(sk), UDP_MIB_CSUMERRORS, is_udplite);
 drop:
 	__UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
 	atomic_inc(&sk->sk_drops);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return -1;
 }
 
-- 
2.34.1

