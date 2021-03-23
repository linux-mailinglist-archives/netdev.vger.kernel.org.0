Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582A9345406
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 01:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbhCWAjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 20:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbhCWAi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 20:38:29 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA29DC061574;
        Mon, 22 Mar 2021 17:38:28 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id cx5so9631113qvb.10;
        Mon, 22 Mar 2021 17:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zmsF6HZla+BsIO3PjkzlLwlB0jrHAcknoqWo/eWzyt4=;
        b=VYNiboCQhsOBPVKdBz6NnL2Hq5xSi19uZWxGqvqvdh6iKb5k9+jef8Uwo+uXhh+Vfk
         E6tLGxYGADJdhg5A9zbkpqHkF7+UJ9uerVD7aSDNtLsWvCsf3SOdf05H/buG/nsYTMg0
         PMAW8p2SrFbFge+0jCzJnASihl/ZN6Qkf8v+CINiUXp2SFr/e8JoTnamsfuo0H4ETOqQ
         foLzCBAwNKO4j+GYsBbS7ZRcyo9MhT9wbwDfCwQqR01sz+gGjDN95KSu9uBdM5x8iUIO
         IPX4Mjecc1z+3s26MJ3TKqJpGDGX/jnPxaiagSjvWYWH9PLlqkrPSCnt/6nze32p+J5O
         VjqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zmsF6HZla+BsIO3PjkzlLwlB0jrHAcknoqWo/eWzyt4=;
        b=FzUQt/6NDozrT5JWg6y3nCNAjLyXrHJymRNKbTDYcNC4SgiF7m4lLJEWwO2+4oBVH+
         4Kyc436007tPx+5vy5bRW1BeGUwScYtOTpEn4BAMBozqAA+46zSi8wOgvzSToecDCnUJ
         Q6RgMDzcbXzdIoJNrLsNx6fWjyULPg922DkPttlNZEI/U/Qa2kZmWutOFO9giK461nfp
         GWATH19lkxviVS+J2c5AnZfRmvBMqbPrJWXzNBxPX9dNw11+ALOJlvi/7aP/QB9VMM6K
         U8WuJL/DC2qFPytQZLS5NU6nRdMz/iGZIu2P9NNOkx4xfRfIcWaoYNrnKsKbN/bIbfgm
         6O6g==
X-Gm-Message-State: AOAM5311Ebmy/VfGbGmcLYf+qJbO0oakAP+SPNZCFHnXuw22ecaTkf01
        OrVtdA1MryJf155uH/Q4kAz2aHPGxO9AsA==
X-Google-Smtp-Source: ABdhPJzIeQ9nHRMtRteYhdvCnWBcK0pB4GMncQhBxK8M0GGuqzJf0JMNDpXf0Kn6LxJxeBIjLtp2Kw==
X-Received: by 2002:ad4:4692:: with SMTP id bq18mr2864203qvb.0.1616459907952;
        Mon, 22 Mar 2021 17:38:27 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:fda6:6522:f108:7bd8])
        by smtp.gmail.com with ESMTPSA id 184sm12356403qki.97.2021.03.22.17.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 17:38:27 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v6 08/12] udp: implement ->read_sock() for sockmap
Date:   Mon, 22 Mar 2021 17:38:04 -0700
Message-Id: <20210323003808.16074-9-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
References: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This is similar to tcp_read_sock(), except we do not need
to worry about connections, we just need to retrieve skb
from UDP receive queue.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/net/udp.h   |  2 ++
 net/ipv4/af_inet.c  |  1 +
 net/ipv4/udp.c      | 35 +++++++++++++++++++++++++++++++++++
 net/ipv6/af_inet6.c |  1 +
 4 files changed, 39 insertions(+)

diff --git a/include/net/udp.h b/include/net/udp.h
index df7cc1edc200..347b62a753c3 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -329,6 +329,8 @@ struct sock *__udp6_lib_lookup(struct net *net,
 			       struct sk_buff *skb);
 struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
 				 __be16 sport, __be16 dport);
+int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
+		  sk_read_actor_t recv_actor);
 
 /* UDP uses skb->dev_scratch to cache as much information as possible and avoid
  * possibly multiple cache miss on dequeue()
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 1355e6c0d567..f17870ee558b 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1070,6 +1070,7 @@ const struct proto_ops inet_dgram_ops = {
 	.setsockopt	   = sock_common_setsockopt,
 	.getsockopt	   = sock_common_getsockopt,
 	.sendmsg	   = inet_sendmsg,
+	.read_sock	   = udp_read_sock,
 	.recvmsg	   = inet_recvmsg,
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = inet_sendpage,
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 38952aaee3a1..a0adee3b1af4 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1782,6 +1782,41 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
 }
 EXPORT_SYMBOL(__skb_recv_udp);
 
+int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
+		  sk_read_actor_t recv_actor)
+{
+	int copied = 0;
+
+	while (1) {
+		int offset = 0, err;
+		struct sk_buff *skb;
+
+		skb = __skb_recv_udp(sk, 0, 1, &offset, &err);
+		if (!skb)
+			break;
+		if (offset < skb->len) {
+			int used;
+			size_t len;
+
+			len = skb->len - offset;
+			used = recv_actor(desc, skb, offset, len);
+			if (used <= 0) {
+				if (!copied)
+					copied = used;
+				break;
+			} else if (used <= len) {
+				copied += used;
+				offset += used;
+			}
+		}
+		if (!desc->count)
+			break;
+	}
+
+	return copied;
+}
+EXPORT_SYMBOL(udp_read_sock);
+
 /*
  * 	This should be easy, if there is something there we
  * 	return it, otherwise we block.
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 802f5111805a..71de739b4a9e 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -714,6 +714,7 @@ const struct proto_ops inet6_dgram_ops = {
 	.getsockopt	   = sock_common_getsockopt,	/* ok		*/
 	.sendmsg	   = inet6_sendmsg,		/* retpoline's sake */
 	.recvmsg	   = inet6_recvmsg,		/* retpoline's sake */
+	.read_sock	   = udp_read_sock,
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = sock_no_sendpage,
 	.set_peek_off	   = sk_set_peek_off,
-- 
2.25.1

