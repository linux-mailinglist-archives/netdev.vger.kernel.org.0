Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6507034F6CB
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 04:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbhCaCdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 22:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233413AbhCaCdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 22:33:01 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30984C061574;
        Tue, 30 Mar 2021 19:33:01 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id x2so18612004oiv.2;
        Tue, 30 Mar 2021 19:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f7W2njqz7r7ROv+AQD2dgc8rqwZ6i4LcPiSpnknm8TY=;
        b=rSrg2uf61pnTv5m8hOO5O2Oyt5+1TZltn6OIWVG3zBlm+nqHC5Mv/wqxGoYeTfIdFj
         dLGJxpgLX1scN6YAoN8qnVQJvqhXARb1UDGf8kLXCNpuED7+GUUN41JVsr8wcRNqzoTx
         Q55x+LcYLHcjsFfHUWj/2JM36y0+7yoaOxbcZLrW4QFoGxZKbXp9hZtAkWNvoPZtaoh0
         XDgqR0hvqfJRB+p8f99LhnWmbiQhQcgaQYTLgS74x4StMjXAMS6ou4XOlwsESCoPAHJP
         +abccmi5ufb/58hLKhQWShT/qa468H9orKgVAhrHmuan52cD1257ChrWI+up7SIBaPbH
         tZOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f7W2njqz7r7ROv+AQD2dgc8rqwZ6i4LcPiSpnknm8TY=;
        b=cgJW4ZcdR3CdyeXaRJANRfF5S8vYjjDukv/JanW1LfRs4ZQCZJTDCBaimOBSPw+ALy
         pXecThSS0rwMSTb/ep6Ic4I0/uftbUcuqeq1UoZG6NkshN1lGg0NYit+PB0syDp12IyL
         pNv3OYdno/YqVz/j1rkDVOF9xNJsLAjuWBnUSGPCs8JtTMVZD7SUswruS4EnTICt7afs
         0gd6EnCeRF07bP4BBRqlHldI4ydPZQ58N83OeTkrSgc6Mv9DlDbffnQtyC60A1spSyj1
         meNXDoifYWdgWgcBTjpEvb4haoE9H0TUUCd368Mpo/gLtqlYLmcjtpaptFEDWwNDC09X
         Xhag==
X-Gm-Message-State: AOAM5319pQC+8G1IaLDWrYW5C/bAd0DtgVSUmIfpCTan6eHS3iaNROqi
        Nyg187ecLMtq3MQMltnjSPnZsRQWnNz8ug==
X-Google-Smtp-Source: ABdhPJwa9fnTqiehNOlKoalrvl8FDYPo+ZGEBUOIcqt33hsmtd12TN/EsrA25ivBPXbyNpBYKlWpBw==
X-Received: by 2002:aca:741:: with SMTP id 62mr669201oih.104.1617157980493;
        Tue, 30 Mar 2021 19:33:00 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:a099:767b:2b62:48df])
        by smtp.gmail.com with ESMTPSA id 7sm188125ois.20.2021.03.30.19.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 19:33:00 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v8 11/16] udp: implement ->read_sock() for sockmap
Date:   Tue, 30 Mar 2021 19:32:32 -0700
Message-Id: <20210331023237.41094-12-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This is similar to tcp_read_sock(), except we do not need
to worry about connections, we just need to retrieve skb
from UDP receive queue.

Note, the return value of ->read_sock() is unused in
sk_psock_verdict_data_ready(), and UDP still does not
support splice() due to lack of ->splice_read(), so users
can not reach udp_read_sock() directly.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/net/udp.h   |  2 ++
 net/ipv4/af_inet.c  |  1 +
 net/ipv4/udp.c      | 29 +++++++++++++++++++++++++++++
 net/ipv6/af_inet6.c |  1 +
 4 files changed, 33 insertions(+)

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
index 38952aaee3a1..4d02f6839e38 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1782,6 +1782,35 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
 }
 EXPORT_SYMBOL(__skb_recv_udp);
 
+int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
+		  sk_read_actor_t recv_actor)
+{
+	int copied = 0;
+
+	while (1) {
+		struct sk_buff *skb;
+		int err, used;
+
+		skb = skb_recv_udp(sk, 0, 1, &err);
+		if (!skb)
+			return err;
+		used = recv_actor(desc, skb, 0, skb->len);
+		if (used <= 0) {
+			if (!copied)
+				copied = used;
+			break;
+		} else if (used <= skb->len) {
+			copied += used;
+		}
+
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

