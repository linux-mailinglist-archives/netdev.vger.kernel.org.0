Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C0832A301
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377942AbhCBIpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:45:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443989AbhCBCim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 21:38:42 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD8FC061794;
        Mon,  1 Mar 2021 18:38:00 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id v12so17502035ott.10;
        Mon, 01 Mar 2021 18:38:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GiB0NEAUfxf9GywTLDDCuaFjXeli5Cn9ox8fpeP4HHI=;
        b=WblbCjmTRubjTckCQ7GDNDx90zL0hklQRWqJhEtl1TlQe4ESx831lDFHR701MC1wBy
         Ii7Uzq2Rq+6MQbYC65UJsVzRp9nr9ogf9TtkShKZrK1KxjpSXP6dPQ9nJMrIDKWJQxR8
         NQo2s5AgcEVBP0mqD6ESBG6S4bjqdCQLsn0HY81LVcv3YXnhwZr6uHbmw2xUjFbRSLB6
         PgsnwMJMG/BqXojWEKH+FKlMf4eLU266gFgTf3/y1W+KRccaXaUPBkAAAsREPMbWEtdI
         7u5aAGVf6UXK7RWUUXiBPktbqT9Ssau/t/BtJNYFq2e2HbM5YcmQDsSwRfCKlTRe11ZU
         3lbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GiB0NEAUfxf9GywTLDDCuaFjXeli5Cn9ox8fpeP4HHI=;
        b=kM3zw2lLb/Jqmt6e4cPw6ytcwJYSUVGDDgoxg3oCPbAHmZXbUINXhp+SIPG2X0WJrE
         2oPmgj0VyewE+6IoT0l+GZuEADoATk7Hj0lpy6qF9hx5hVz/Ujs9CZEX0fQ1KPOZpUGs
         ebKsXN+JECb8zZsn7TFZDqWg+iATC77A+EgUvTSoOAXISJUi18jUYo/PJyEkX12OFmaG
         +lJphcfMl1JBKYam9by/dTwewj2D/idDZPx/xLRTvCgCJhMaJzZxj2ZewvCZUNeTMtjr
         Nm80a5E0b7y3zPOj/XKy6VaTnEZLB4MOlx4/hNhGbYdhT87zmbrBUeOASBpclMGHbjee
         5fpg==
X-Gm-Message-State: AOAM533GyGvQsQAt5o5Qc2qaDrFi1ygNl2QT53UjvrGDCFcXlIsCHkzV
        BWktRPaZHoOmmL7ermvhNVJUzCe26Twrrg==
X-Google-Smtp-Source: ABdhPJxtpkUitb0hkxcYiK7vaF8MpDkNE11YfGGPXUZwMGLLjg6JsbMhop2W7PTssiu8mNRXS5BnAQ==
X-Received: by 2002:a9d:340b:: with SMTP id v11mr14334996otb.284.1614652679217;
        Mon, 01 Mar 2021 18:37:59 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1bb:8d29:39ef:5fe5])
        by smtp.gmail.com with ESMTPSA id a30sm100058oiy.42.2021.03.01.18.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 18:37:58 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v2 4/9] udp: implement ->read_sock() for sockmap
Date:   Mon,  1 Mar 2021 18:37:38 -0800
Message-Id: <20210302023743.24123-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

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
index 93db853601d7..54f24b1d4f65 100644
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

