Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FFC49DD91
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234920AbiA0JOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238395AbiA0JOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 04:14:23 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F8BC061751;
        Thu, 27 Jan 2022 01:14:16 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id y27so2124410pfa.0;
        Thu, 27 Jan 2022 01:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QEz/fR/kaAPRecC/ASB8IHjUXrfH/nHr4967v0vTry4=;
        b=qOKNWf3XPVA5hxAcMezK7dPhltayrcKLuGWtagwk6w9hCsyid4OSwYEH6w9CNPLJkM
         ODfjgXo0iXZ8R1op4pVvhWEdYD/7UG0HFAHuBqYhOZyQHRYnFbHtUg7yEw5eLZFGOg88
         HKvdWxvWRdvip8hWjYgaTPlIVeyBS0A4sxAA9DZjyCIZkdyQWt46AA2igPORyyQs0kXk
         g0rDNARNhsFubx+0Me8CydxHCbb3LmTiR1m7+GZztxnm1bZECEDuZueZKUq/ywbz3+0g
         7khRgLeYVw0kauxXL8sdzh8zY8jY/YqfYEZDvfS1SGPHxZlPqURR/cf/CsPkcy/uY9XC
         aIcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QEz/fR/kaAPRecC/ASB8IHjUXrfH/nHr4967v0vTry4=;
        b=J2hbZMN4aEDnhZNlXnVppxtRofs6AapNLbDGHZ40fMlfiBUkbflrPbaAAOTBiL19I7
         cWw6wv2p0IoLYqkcKmT7DtohL1/e9e7WEGwSSoixjj8Dj1uabQRIDJwgeVfxXJZqQ06+
         oSzt15eQ1YNsfRTkIEFsd53UVLKL9M1c8AV1JYDC8iT0jB/VX9mnhAWLU/suAe0VgCHR
         +95eZmKAbvKMBWdC8WqtYWoXm4KONBor+lFqum+AWWtLmYq6Trgm5yaIpe2AZ77X3HlU
         kZZjSfh05L2OxYMREYPUcapOuv1q6BQS3DnxA+kq5xosbHKlypKH+udp0Z46wTWBxruO
         NAgQ==
X-Gm-Message-State: AOAM531jRShL+B8m611Y2N47JSIJK81JkW437lMHNmWPyIlb6PhXGdS5
        bx1eCMpr1mRXTP0ZJuAk/6o=
X-Google-Smtp-Source: ABdhPJwM512I435kxZZ4I9wHGYjKH2gGEohoDvYjvOFaUftM2C372qnT+oqxBeeg5vpm9iaVmJ+2UQ==
X-Received: by 2002:a63:2ac2:: with SMTP id q185mr2057294pgq.578.1643274855819;
        Thu, 27 Jan 2022 01:14:15 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id j11sm2046338pjf.53.2022.01.27.01.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 01:14:15 -0800 (PST)
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
Subject: [PATCH v2 net-next 7/8] net: udp: use kfree_skb_reason() in udp_queue_rcv_one_skb()
Date:   Thu, 27 Jan 2022 17:13:07 +0800
Message-Id: <20220127091308.91401-8-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220127091308.91401-1-imagedong@tencent.com>
References: <20220127091308.91401-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() with kfree_skb_reason() in udp_queue_rcv_one_skb().

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v2:
- use SKB_DROP_REASON_SOCKET_FILTER instead of
  SKB_DROP_REASON_UDP_FILTER
---
 net/ipv4/udp.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 464590ea922e..9e28e76e95b8 100644
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
+		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
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

