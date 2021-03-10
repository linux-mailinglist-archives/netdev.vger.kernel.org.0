Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD36D33355E
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 06:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbhCJFd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 00:33:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhCJFdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 00:33:03 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A551C061765;
        Tue,  9 Mar 2021 21:32:42 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id l7so3704383qtq.7;
        Tue, 09 Mar 2021 21:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=djZ+GsYdOix1zOIqZyqyLKK8y1Y9aew3XZCxsSgYn+g=;
        b=KXv/2qXw/50H/V+qkOpG+aQBwUWzUVHz3qiWsIQac2jI9I1R/uSJwDebQvACHcNkXk
         gYdTCVOHX84++8rVzEnXVU5erWV9hzrRqSCVikhauRyYJ/1cjHXcr84jjsNE4z850W9F
         ulA++OVjbll8v3YLJ1ylZaxNTwIII3C0uUxgGxq/yDgEDc0bZlpDD6tRmL8cDP84RKSp
         AiRCfo5HiNuV8KgcDZMrZHz9ggSeox3wA1vvwbpa7UZpp+ReOvmn7V4iPJeBnFkPwlQw
         KtuprUxQrVexkUXvGSY+vWaBbXA2UFGmAODnqokp187t4T/pMFAKw/+v/7Qgoy+L5X1u
         XZwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=djZ+GsYdOix1zOIqZyqyLKK8y1Y9aew3XZCxsSgYn+g=;
        b=Fm+1HM//wuFy+zSHLlAYFqZdN3u0//UXNKqBzW6IXiB2gYyglyDWkaXsPREtrvbyfM
         hO+6L3xs8BLSf3X7Iq3d7ZRv8NESHpa3BG3meVhIOyezCTNNWGj9ufyFnXrwYRhs/t4o
         y0Qc1ldWhbPE0dd02lmgNt3WhL639hyKv9lt4IP6bEMSL+1KvSsjrK+2cNlUBAVWmtRs
         ifgz4UduRCN3BPdk6CjsG4LxyVi7etx30l87cbV38wtEJFmOIXKMTMovuTIIvNTrgvK2
         o10oh17XcotyUlzr2Ghm2vr6vs+s6HDF7ZLxLjxJmApl8oYBrtq/A8FPFEODTjtsluuN
         wHQQ==
X-Gm-Message-State: AOAM530huI7KZ4B5y0jGaksXbsHOv29S8O/gEuhHyQjq2B8VmfCS9rsD
        lAIw92Fg971rrWWgqlJDucdMWh70qO24oA==
X-Google-Smtp-Source: ABdhPJzGb1eteR1aB8W45I5krGwTVmqI/zoGjDmLn2l1ITjqOevh78xc7KIq6GevetVTgW00PayFlg==
X-Received: by 2002:ac8:12c8:: with SMTP id b8mr1423822qtj.2.1615354361175;
        Tue, 09 Mar 2021 21:32:41 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:91f3:e7ef:7f61:a131])
        by smtp.gmail.com with ESMTPSA id g21sm12118739qkk.72.2021.03.09.21.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 21:32:40 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v4 07/11] udp: implement ->read_sock() for sockmap
Date:   Tue,  9 Mar 2021 21:32:18 -0800
Message-Id: <20210310053222.41371-8-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310053222.41371-1-xiyou.wangcong@gmail.com>
References: <20210310053222.41371-1-xiyou.wangcong@gmail.com>
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
index a02ce89b56b5..915001f8000b 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1071,6 +1071,7 @@ const struct proto_ops inet_dgram_ops = {
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
index 1fb75f01756c..63218b0bcdb1 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -715,6 +715,7 @@ const struct proto_ops inet6_dgram_ops = {
 	.getsockopt	   = sock_common_getsockopt,	/* ok		*/
 	.sendmsg	   = inet6_sendmsg,		/* retpoline's sake */
 	.recvmsg	   = inet6_recvmsg,		/* retpoline's sake */
+	.read_sock	   = udp_read_sock,
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = sock_no_sendpage,
 	.set_peek_off	   = sk_set_peek_off,
-- 
2.25.1

