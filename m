Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCBB436798
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 18:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbhJUQZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 12:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbhJUQZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 12:25:29 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8520CC061225
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:23:13 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id f21so790660plb.3
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FQLSQHvYU3ir45py5qySQ0fLYWleklAkyTTP8P9C2zE=;
        b=EaXYoOtNQ44K5bKS/S3+csn+l5V3dceGl65VuYRXu8zsYqIMbcplo96FP4qK287XGo
         xVHn8QGzOEEeUYR6faVuLxAYxufkmEnXQ38gTDvfgBHsa1EtNoI1CFX9rrosd0xtcESo
         3TV70M+4I13UklqRkoxmpt7i6UEZAs3einvUuHiC4XggBiELOwjpngQL6xDpIuyNsr49
         DWOQOFmBBSS0jL00/sYDZIXw/4RRg9ywajQr6yz8KySDpY5K5vMYfpKKPzfxRWcpBM2z
         xQgeztl9nKZaQACcfdf7dLqW7MUkF/QesmUmoBgwCxIuJNwbytSN+tmoQ65Jq2D+lYW3
         WI8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FQLSQHvYU3ir45py5qySQ0fLYWleklAkyTTP8P9C2zE=;
        b=HGtzyQy5vLm/ZEUAFCwDmUv4Up0/GW6G6mRoyPvBjj+TOxPxrFYTenHTYYEV1S2pxG
         yz6dbSrBzNMMOZdx+8lXHgKktiCZ82QPVKCydrHeUliDQlzVFRQ63fn3hyHOAOf+HlIv
         Csdmr8+ubv7Dr9vhFIzY5QPNbe2gWQNdFvt8LMkC7Bg39a+aqhTxTYeFeJJX9AI80q7b
         Vg0peoRS1HZJrTm3r0fLrB6t2Hh7d3MAlvMYs1RemJz885yGxbfe6k/SpR78ToGoDfB8
         jDNr82lRjB7dMFZhc/eTe0qAAiHgLSAR3ve3/dgIa4EDuF380NacQV2KGZ04LaCQtUxP
         cPaw==
X-Gm-Message-State: AOAM530C+dfmFer8wlWoCVDoAX6idmGlXvKN21m0KipoqcXXSmlP98jV
        y/l2w9f5ScNJIX+JLC9ajno=
X-Google-Smtp-Source: ABdhPJxvvBdqHSGsBeeezrYcWoSAUCCqivlgPVeE2gDiYW03MVJYrDPmgRaqjN/nnHo0PoKkDFEVXg==
X-Received: by 2002:a17:90a:d582:: with SMTP id v2mr7710146pju.46.1634833393083;
        Thu, 21 Oct 2021 09:23:13 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c17a:20ce:f4d9:d04c])
        by smtp.gmail.com with ESMTPSA id n22sm6719291pfo.15.2021.10.21.09.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 09:23:12 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH net-next 8/9] ipv4: guard IP_MINTTL with a static key
Date:   Thu, 21 Oct 2021 09:22:52 -0700
Message-Id: <20211021162253.333616-11-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211021162253.333616-1-eric.dumazet@gmail.com>
References: <20211021162253.333616-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

RFC 5082 IP_MINTTL option is rarely used on hosts.

Add a static key to remove from TCP fast path useless code,
and potential cache line miss to fetch inet_sk(sk)->min_ttl

Note that once ip4_min_ttl static key has been enabled,
it stays enabled until next boot.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ip.h       |  2 ++
 net/ipv4/ip_sockglue.c |  6 ++++++
 net/ipv4/tcp_ipv4.c    | 20 ++++++++++++--------
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index cf229a53119428307da898af4b0dc23e1cecc053..b71e88507c4a0907011c41e1ed0148eb873b5186 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -24,6 +24,7 @@
 #include <linux/skbuff.h>
 #include <linux/jhash.h>
 #include <linux/sockptr.h>
+#include <linux/static_key.h>
 
 #include <net/inet_sock.h>
 #include <net/route.h>
@@ -750,6 +751,7 @@ void ip_cmsg_recv_offset(struct msghdr *msg, struct sock *sk,
 			 struct sk_buff *skb, int tlen, int offset);
 int ip_cmsg_send(struct sock *sk, struct msghdr *msg,
 		 struct ipcm_cookie *ipc, bool allow_ipv6);
+DECLARE_STATIC_KEY_FALSE(ip4_min_ttl);
 int ip_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
 		  unsigned int optlen);
 int ip_getsockopt(struct sock *sk, int level, int optname, char __user *optval,
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index d5487c8580674a01df8c7d8ce88f97c9add846b6..38d29b175ca6646c280e0626e8e935b348f00f08 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -886,6 +886,8 @@ static int compat_ip_mcast_join_leave(struct sock *sk, int optname,
 	return ip_mc_leave_group(sk, &mreq);
 }
 
+DEFINE_STATIC_KEY_FALSE(ip4_min_ttl);
+
 static int do_ip_setsockopt(struct sock *sk, int level, int optname,
 		sockptr_t optval, unsigned int optlen)
 {
@@ -1352,6 +1354,10 @@ static int do_ip_setsockopt(struct sock *sk, int level, int optname,
 			goto e_inval;
 		if (val < 0 || val > 255)
 			goto e_inval;
+
+		if (val)
+			static_branch_enable(&ip4_min_ttl);
+
 		/* tcp_v4_err() and tcp_v4_rcv() might read min_ttl
 		 * while we are changint it.
 		 */
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 97b8acf726d0cdcb6b87b6ef45e366591d997a2b..8e9f05d9c54c316e6f6d0603ad786399f9c6345c 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -508,10 +508,12 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 	if (sk->sk_state == TCP_CLOSE)
 		goto out;
 
-	/* min_ttl can be changed concurrently from do_ip_setsockopt() */
-	if (unlikely(iph->ttl < READ_ONCE(inet_sk(sk)->min_ttl))) {
-		__NET_INC_STATS(net, LINUX_MIB_TCPMINTTLDROP);
-		goto out;
+	if (static_branch_unlikely(&ip4_min_ttl)) {
+		/* min_ttl can be changed concurrently from do_ip_setsockopt() */
+		if (unlikely(iph->ttl < READ_ONCE(inet_sk(sk)->min_ttl))) {
+			__NET_INC_STATS(net, LINUX_MIB_TCPMINTTLDROP);
+			goto out;
+		}
 	}
 
 	tp = tcp_sk(sk);
@@ -2051,10 +2053,12 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		}
 	}
 
-	/* min_ttl can be changed concurrently from do_ip_setsockopt() */
-	if (unlikely(iph->ttl < READ_ONCE(inet_sk(sk)->min_ttl))) {
-		__NET_INC_STATS(net, LINUX_MIB_TCPMINTTLDROP);
-		goto discard_and_relse;
+	if (static_branch_unlikely(&ip4_min_ttl)) {
+		/* min_ttl can be changed concurrently from do_ip_setsockopt() */
+		if (unlikely(iph->ttl < READ_ONCE(inet_sk(sk)->min_ttl))) {
+			__NET_INC_STATS(net, LINUX_MIB_TCPMINTTLDROP);
+			goto discard_and_relse;
+		}
 	}
 
 	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
-- 
2.33.0.1079.g6e70778dc9-goog

