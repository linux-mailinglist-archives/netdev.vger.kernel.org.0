Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B76C232DF56
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 02:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhCEB5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 20:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbhCEB5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 20:57:11 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E19C061574;
        Thu,  4 Mar 2021 17:57:11 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id v12so296398ott.10;
        Thu, 04 Mar 2021 17:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s1GzOzweTwmrvvMSvdXGNYdi6EOSR3K6HzD5+wNMVgQ=;
        b=QP2rryxtZy0yIJRoKIjB9zV1so3Kpmbt9yC+2n/xMKTHurfbkJO+I67XDxaRasUZI4
         jYEfBGAnBKcqTZWUf23sHTwMInKT30VNisy7dySBKR7/gQPYyI69B4HuRqsb3F31RdKb
         jdQuW7xnYyoMFlQ+nDoebQId+YPj4ryj4yz/hWMReaoh3BMMRlV+pkOk+1YhUzkqB/XX
         qobGfAxkcNxM8/vmpNH2lgbpOu4UIjcQigQRQn73XF1ce0o04ah0SI7Yl/hxnyLsQETv
         pLZHNG1iGf/pLB/IUsNYaS4Qq71T1Yeri7PXPcElvI7bnlZfJ84FM0a9/2bQi2xwR4Q9
         +64Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s1GzOzweTwmrvvMSvdXGNYdi6EOSR3K6HzD5+wNMVgQ=;
        b=oDz5ssxn7GfwNBcxPkSrO1Sy4Eg13O2wnxS/AM205OjjOw7KTRRWLZtu4XflgyZXWb
         t0u4Akkb5bJ3fe2xN7DknwWzwEfxJycyrMRCJMAE4RWmiJgBDDfB7VKhT4xfCKwfuP7k
         qjfuSfpQ9RDQpcdyFw2GLW7dmjvh0/sr0i2T/cZqItJ9lQM1GRJqovaOZY7LOWagP2Si
         2COs7fGTT64l3yLCN/rXoLWkFXx72y8KtAhDgZ0xYQ1Um542WRSMwipJF/ZjZnkkM2iR
         Z7g881f9jc0AV+nta/6AwumDcbFEPQZkpYbvk+RbRkCYFUefi121FGB5fGzRHmxtGqwN
         Xogg==
X-Gm-Message-State: AOAM533+vpCSbzvaFcGLB+on7whM/ETkX5Y6Ad1Ka6gwnRWf/oYLUuLs
        bplN3EMABzSa7RJSBeRdVJLYO49IVGQNaQ==
X-Google-Smtp-Source: ABdhPJwEhRD/7NflMm34pkr8bkfN6yhLBwP+EfwcRYBdn1aVM4fgdcNzAJf6yRsgqsT+WcB8nihtmw==
X-Received: by 2002:a05:6830:1bc2:: with SMTP id v2mr532390ota.245.1614909430569;
        Thu, 04 Mar 2021 17:57:10 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:95de:1d5:1b36:946a])
        by smtp.gmail.com with ESMTPSA id r3sm224126oif.5.2021.03.04.17.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 17:57:10 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v3 4/9] udp: implement ->read_sock() for sockmap
Date:   Thu,  4 Mar 2021 17:56:50 -0800
Message-Id: <20210305015655.14249-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210305015655.14249-1-xiyou.wangcong@gmail.com>
References: <20210305015655.14249-1-xiyou.wangcong@gmail.com>
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
 include/net/udp.h  |  2 ++
 net/ipv4/af_inet.c |  1 +
 net/ipv4/udp.c     | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/include/net/udp.h b/include/net/udp.h
index 5264ba1439f9..44a94cfc63b5 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -330,6 +330,8 @@ struct sock *__udp6_lib_lookup(struct net *net,
 			       struct sk_buff *skb);
 struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
 				 __be16 sport, __be16 dport);
+int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
+		  sk_read_actor_t recv_actor);
 
 /* UDP uses skb->dev_scratch to cache as much information as possible and avoid
  * possibly multiple cache miss on dequeue()
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index d8c73a848c53..df8e8e238756 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1072,6 +1072,7 @@ const struct proto_ops inet_dgram_ops = {
 	.getsockopt	   = sock_common_getsockopt,
 	.sendmsg	   = inet_sendmsg,
 	.sendmsg_locked    = udp_sendmsg_locked,
+	.read_sock	   = udp_read_sock,
 	.recvmsg	   = inet_recvmsg,
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = inet_sendpage,
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 424231e910a9..fd8f27ee5b4e 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1798,6 +1798,40 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
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
+
 /*
  * 	This should be easy, if there is something there we
  * 	return it, otherwise we block.
-- 
2.25.1

