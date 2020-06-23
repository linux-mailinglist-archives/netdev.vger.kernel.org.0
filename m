Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8566420677D
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388561AbgFWWrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388363AbgFWWr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 18:47:28 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47821C06179A
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 15:31:29 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s7so164210ybg.10
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 15:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QAGTYlOQftLXYS7/9CsPKC7rOAM5RHroAY5bDhFvm+A=;
        b=PMzaoMoMUxK5uSgL412lKAVSb7bpr3m1iuGvw633YMseUl1xeppLZKW8NB84TE3GVf
         cyuB6YELlgHTq7amo6tIlHbo5Awv6l4nVzO6tfUt9ocDd01vDXcxSAWFlKXdwb1qdHqG
         OEW5Omz57BS92kXHCUtigmrL/DCLKDXr6eZ9o7nQejlgM8qHp5Y6oMQCgguvD5QnTNvW
         wP0vZ6ZzxwAEanbC5FaEpo6uPlmgAveqa5C76QiFGAb6aQ3ZvAciye+CJNOK8QQbYJ/p
         1Xcw9hEegu3JjKhPN5+KD/F/i3jorHiw26vBc07Z8yDWo9hq8BqpZ7mUhy1LdVzGmBdH
         IsGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QAGTYlOQftLXYS7/9CsPKC7rOAM5RHroAY5bDhFvm+A=;
        b=OMiSlIT/SEUJhaaeXKzrv7fyuw3qYmzzDWza6aczA92etViF7V3cGz6rsHHUx48SV+
         4ePNH6hyB7kjDU5LF4FPV4sPF8nAXpypxkfzV+/ZQMdH3gAh1u8LjmauNWMRoSKC98aV
         7rsT9iwuBkxVui6kPY8yBSDVBkIhr8XU9g+o/AJECXECzXkZ97xq+c8ucnP+A2opFEVM
         MAwvXZfdmxF2llL73SwnHJAqqAIZIshooWiLETFapTiNBi/OTKT4uPe+3E9b6xZH6ucq
         LvOXni2go8RxQ8K3Hl+4BiknWWrmawNpv8n10QfQz8FDA96Xqoh8SUzqIUikcTFxmvpz
         XDJg==
X-Gm-Message-State: AOAM532tVsO/3tjmxXNgQjfz+pswrp2gvgUFH8N5N9G0QogK0P5JWcvB
        WkZWqY/jiGTDk3k9i9xE5IfAylpFCMGwyw==
X-Google-Smtp-Source: ABdhPJxYiVC3u7Eb9hbOIt6h31u4WkK8uNBeTJm2w9p4dGbpJ55Tev5XvMeYOP6bVq1drFv24nzX8oYLMMKSuA==
X-Received: by 2002:a25:f20d:: with SMTP id i13mr23812135ybe.366.1592951488368;
 Tue, 23 Jun 2020 15:31:28 -0700 (PDT)
Date:   Tue, 23 Jun 2020 15:31:14 -0700
In-Reply-To: <20200623223115.152832-1-edumazet@google.com>
Message-Id: <20200623223115.152832-5-edumazet@google.com>
Mime-Version: 1.0
References: <20200623223115.152832-1-edumazet@google.com>
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
Subject: [PATCH net-next 4/5] net: move tcp gro declarations to net/tcp.h
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes following (C=1 W=1) warnings for CONFIG_RETPOLINE=y :

net/ipv4/tcp_offload.c:306:16: warning: symbol 'tcp4_gro_receive' was not declared. Should it be static?
net/ipv4/tcp_offload.c:306:17: warning: no previous prototype for 'tcp4_gro_receive' [-Wmissing-prototypes]
net/ipv4/tcp_offload.c:319:29: warning: symbol 'tcp4_gro_complete' was not declared. Should it be static?
net/ipv4/tcp_offload.c:319:29: warning: no previous prototype for 'tcp4_gro_complete' [-Wmissing-prototypes]
  CHECK   net/ipv6/tcpv6_offload.c
net/ipv6/tcpv6_offload.c:16:16: warning: symbol 'tcp6_gro_receive' was not declared. Should it be static?
net/ipv6/tcpv6_offload.c:29:29: warning: symbol 'tcp6_gro_complete' was not declared. Should it be static?
  CC      net/ipv6/tcpv6_offload.o
net/ipv6/tcpv6_offload.c:16:17: warning: no previous prototype for 'tcp6_gro_receive' [-Wmissing-prototypes]
   16 | struct sk_buff *tcp6_gro_receive(struct list_head *head, struct sk_buff *skb)
      |                 ^~~~~~~~~~~~~~~~
net/ipv6/tcpv6_offload.c:29:29: warning: no previous prototype for 'tcp6_gro_complete' [-Wmissing-prototypes]
   29 | INDIRECT_CALLABLE_SCOPE int tcp6_gro_complete(struct sk_buff *skb, int thoff)
      |                             ^~~~~~~~~~~~~~~~~

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h      | 4 ++++
 net/ipv4/af_inet.c     | 3 ---
 net/ipv6/ip6_offload.c | 4 +---
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index b0f0f93c681c1744560fd229569b59edb1eb20ee..27f848ab39951c9ee5b5d81d7f96d09a4c03e3d6 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1957,6 +1957,10 @@ void tcp_v4_destroy_sock(struct sock *sk);
 struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 				netdev_features_t features);
 struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb);
+INDIRECT_CALLABLE_DECLARE(int tcp4_gro_complete(struct sk_buff *skb, int thoff));
+INDIRECT_CALLABLE_DECLARE(struct sk_buff *tcp4_gro_receive(struct list_head *head, struct sk_buff *skb));
+INDIRECT_CALLABLE_DECLARE(int tcp6_gro_complete(struct sk_buff *skb, int thoff));
+INDIRECT_CALLABLE_DECLARE(struct sk_buff *tcp6_gro_receive(struct list_head *head, struct sk_buff *skb));
 int tcp_gro_complete(struct sk_buff *skb);
 
 void __tcp_v4_send_check(struct sk_buff *skb, __be32 saddr, __be32 daddr);
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 02aa5cb3a4fd15fa219831283dea2992b053c6a8..d8dbff1dd1fa155171b45a2dbf3034563db22db5 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1432,8 +1432,6 @@ static struct sk_buff *ipip_gso_segment(struct sk_buff *skb,
 	return inet_gso_segment(skb, features);
 }
 
-INDIRECT_CALLABLE_DECLARE(struct sk_buff *tcp4_gro_receive(struct list_head *,
-							   struct sk_buff *));
 INDIRECT_CALLABLE_DECLARE(struct sk_buff *udp4_gro_receive(struct list_head *,
 							   struct sk_buff *));
 struct sk_buff *inet_gro_receive(struct list_head *head, struct sk_buff *skb)
@@ -1608,7 +1606,6 @@ int inet_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
 	return -EINVAL;
 }
 
-INDIRECT_CALLABLE_DECLARE(int tcp4_gro_complete(struct sk_buff *, int));
 INDIRECT_CALLABLE_DECLARE(int udp4_gro_complete(struct sk_buff *, int));
 int inet_gro_complete(struct sk_buff *skb, int nhoff)
 {
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index 7fbb44736a34b143baf147d8c5b0331799647738..78eec5b423856c853b6a59adab425dbe29a2c4fc 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -13,6 +13,7 @@
 #include <net/protocol.h>
 #include <net/ipv6.h>
 #include <net/inet_common.h>
+#include <net/tcp.h>
 
 #include "ip6_offload.h"
 
@@ -177,8 +178,6 @@ static int ipv6_exthdrs_len(struct ipv6hdr *iph,
 	return len;
 }
 
-INDIRECT_CALLABLE_DECLARE(struct sk_buff *tcp6_gro_receive(struct list_head *,
-							   struct sk_buff *));
 INDIRECT_CALLABLE_DECLARE(struct sk_buff *udp6_gro_receive(struct list_head *,
 							   struct sk_buff *));
 INDIRECT_CALLABLE_SCOPE struct sk_buff *ipv6_gro_receive(struct list_head *head,
@@ -319,7 +318,6 @@ static struct sk_buff *ip4ip6_gro_receive(struct list_head *head,
 	return inet_gro_receive(head, skb);
 }
 
-INDIRECT_CALLABLE_DECLARE(int tcp6_gro_complete(struct sk_buff *, int));
 INDIRECT_CALLABLE_DECLARE(int udp6_gro_complete(struct sk_buff *, int));
 INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb, int nhoff)
 {
-- 
2.27.0.111.gc72c7da667-goog

