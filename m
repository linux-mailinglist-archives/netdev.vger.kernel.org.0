Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F3F30D278
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbhBCETE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbhBCESY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 23:18:24 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B342C06178C;
        Tue,  2 Feb 2021 20:17:06 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id n7so25342892oic.11;
        Tue, 02 Feb 2021 20:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dupMR2pG+JHyTg89AqGH2oELASs9jaapVR219k48+YQ=;
        b=bCQeWjUUGeLZfuPLirC0xi27hLCVpiAaXsUPT+uIEPNfJtLDtYKsbzBX3crGj9eyq7
         gXIynuPA/nBuTKUbOQxIx0opQTrArAKOXbh3sakpMrZ2ycHuvD1XATkv8VVdGk/dgOht
         HyikSyn12SNmRQWLRg/MSWOTJrgKp/5n7+HV4xjYS5Y+yK3gJuW1U55llAnu3L/AFQAi
         VBM+s+ITlZUz3iDAzjNNA2RQpogUPAAZ/dWXD3lokxC8EO5F9cWFUYnTVVXPw7WffQtG
         T/syGi+5GGTGYJecAfgxBd1YxO7RJEkMZUId6xPJAvS2oALKTvHXzc/H1W7n0otUoh2y
         gPHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dupMR2pG+JHyTg89AqGH2oELASs9jaapVR219k48+YQ=;
        b=PQ+XEhLnrwqnmYaf6nhzwTBR0OViklt5CnYXecWEJl9RaQIyrzg7n/2yGR7XV1T/Vg
         PJDum57bbIoZ9kFMX3WgiucEt3ypXiLtcelavr9jKRIyRJs8x3UWzwOfr/VR6y1msZcS
         J910a+HYCoNcNDYt+QtqeXSQqApUrwmXRfVx4FOaOpPg/EY0hsBterCKwORZGkAQNVIB
         4tfMboRqvUHYPEs91OLpjGKQqsKdPMZxk9aY++h10I0Y4XYfCgmNXFXoQ5pDPpliWbK+
         2OaNhCCP6cZqfteVZveQ+GwmL4sckEmhR70GHqxriShan0JuUE8q5E092rqJGtqYzJgQ
         CKaw==
X-Gm-Message-State: AOAM531pIiFw4x31DekWuWNNKE35XVcFWeqySVjlI6v6cf89xo9qhfEK
        59iEYBhWDDkT8gqaBTk/j9P3zQJBDuMpBg==
X-Google-Smtp-Source: ABdhPJwPoE3QqiuZUR/2DI44BMHX9o+bWbyBSXRpMDOM8cnL7EnzaYnz4nExxPrTZMpBLQzg8DO2Bw==
X-Received: by 2002:a54:4e88:: with SMTP id c8mr786082oiy.148.1612325825505;
        Tue, 02 Feb 2021 20:17:05 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:90c4:ffea:6079:8a0c])
        by smtp.gmail.com with ESMTPSA id s10sm209978ool.35.2021.02.02.20.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 20:17:04 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next 08/19] udp: implement ->read_sock() for sockmap
Date:   Tue,  2 Feb 2021 20:16:25 -0800
Message-Id: <20210203041636.38555-9-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
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
index 13f9354dbd3e..b6b75cabf4e4 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -327,6 +327,8 @@ struct sock *__udp6_lib_lookup(struct net *net,
 			       struct sk_buff *skb);
 struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
 				 __be16 sport, __be16 dport);
+int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
+		  sk_read_actor_t recv_actor);
 
 /* UDP uses skb->dev_scratch to cache as much information as possible and avoid
  * possibly multiple cache miss on dequeue()
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index d184d9379a92..4a4c6d3d2786 100644
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
index 635e1e8b2968..6dffbcec0b51 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1792,6 +1792,40 @@ struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
 }
 EXPORT_SYMBOL(__skb_recv_udp);
 
+int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
+		  sk_read_actor_t recv_actor)
+{
+	struct sk_buff *skb;
+	int copied = 0, err;
+
+	while (1) {
+		int offset = 0;
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

