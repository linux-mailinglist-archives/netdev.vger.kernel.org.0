Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5066033E6C7
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhCQCX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbhCQCXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:23:04 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A488EC06175F;
        Tue, 16 Mar 2021 19:22:53 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id l23-20020a05683004b7b02901b529d1a2fdso379246otd.8;
        Tue, 16 Mar 2021 19:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zmsF6HZla+BsIO3PjkzlLwlB0jrHAcknoqWo/eWzyt4=;
        b=l+DvoK2egq0g09dI9zBkwRgbDvrpBUy1F7o7CdAEEli8+WrwtXDtkWN5fxzmeNODj1
         1lTDsQcMBvTxG2WAldonbYFrVigiRPnqTBE4gZ1/CeXMlc3TgsosJavmHOEJL+ojFyvX
         jgFRca8VmvdTD1rgd/9VbyS8HvE4xrMpaKjdvEvpqn+mMeskQJUg5ySfX+yQSLoolMoh
         68G0vVab+SY8vYmH9oCRCiwLMYIDPb+YAXkW/30ZnGj/bg7aSi9WJAt9EbW1O622dIC/
         GNskfBntwfnA/h/J7Av4c+FLFkfk6526kevmDEMuRdFLoeL3klWQaO4dqFSZQrm6Dnhs
         baQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zmsF6HZla+BsIO3PjkzlLwlB0jrHAcknoqWo/eWzyt4=;
        b=Nqdn9qTM0bsMBCYfMsoj6GA1ThIOSqqEa2niAhGjWtvtxgnFFJKjIbg+ecqbBOblIS
         smRt4qt7yhYA/OycVwmZOiZ1hkQcUtG/4xUdCZWgVK7UFbmqZl6+r6aWIR80DIUSLUSV
         V8+7Kks3EG80UJGxCc4fvTZysK8F8GC1j+3uS8hn26TgeH0ysVk7w7xkwb+fBMBZjFEz
         oV2kL4b/+8MTiq6WQXUS2ACncRXBXQ940zMyAkAt/o6IP0kV3WNI2OMGg2n3L5La9Tj9
         Dwpc1rr0+4Z/srxwcetbuLugTyQCJxGVKPyuIHtgDlVkmbWmvqk57lPYwC9DFygoYQxz
         +aqQ==
X-Gm-Message-State: AOAM531CCOrIUJoBXI5tGfFQVqjB4/C4evzuTTXqjbYvTglPdfoWSe3e
        BXkHQqvlc1PwdYF9rh8P+4FIxLq1+uxo5Q==
X-Google-Smtp-Source: ABdhPJw21d9YfEkUaQAqZQwu+Y0Ms5Rvl9rhOg6Pf/YUqkshHhGo0XTfJSJanfkILzoER04NnUnFtQ==
X-Received: by 2002:a9d:4e1a:: with SMTP id p26mr1448301otf.202.1615947772922;
        Tue, 16 Mar 2021 19:22:52 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:517b:5634:5d8e:ff09])
        by smtp.gmail.com with ESMTPSA id i3sm8037858oov.2.2021.03.16.19.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 19:22:52 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v5 07/11] udp: implement ->read_sock() for sockmap
Date:   Tue, 16 Mar 2021 19:22:15 -0700
Message-Id: <20210317022219.24934-8-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317022219.24934-1-xiyou.wangcong@gmail.com>
References: <20210317022219.24934-1-xiyou.wangcong@gmail.com>
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

