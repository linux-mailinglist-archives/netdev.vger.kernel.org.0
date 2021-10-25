Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCCC439C0C
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 18:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234114AbhJYQvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 12:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234086AbhJYQvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 12:51:02 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC36C061348
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:48:40 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id n11-20020a17090a2bcb00b001a1e7a0a6a6so8216488pje.0
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UJz1lAu5C9MAqZ8KnyZ8z6mVntpBW4i3HKAaMu3gS2I=;
        b=njRZINMKN4HmIIQ/J68W9QM4fviQu+Jb+LxnjUVkyOmXiDznuaSdmLuMyoSOJAmFZJ
         m4Og5Re+MCSOnDGC9qpu3GwDh2SxLAuPwOcJmzFsc5K2lnVHsMzQsWAYHrxwb9wEK1G8
         WKUEMBdX3kanKrt8U87GjHa9p4eJMwkIG8VRSt+skT0lEZsDLdHAnE4fLgqkQrbWi9Jb
         baiGDIvPs0+huVkaYGQy6+SnqS9/Q7bdjmEY2cdb4OZeT8eenTv4vz3SDDLjqtsc4hZa
         5656rg/Fjz0wiRlsQqXn/WHNu912NdO/0FC7RTYml4vM0xJLEDkqVGubavbZzOYgLDTd
         B8nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UJz1lAu5C9MAqZ8KnyZ8z6mVntpBW4i3HKAaMu3gS2I=;
        b=OMsHmuScD/j0tkOxG/JC9JLRG1R+nWH1a9cB/DNEIEZaarRbLGFc31MWJ506F7KGFv
         wjj9lczh5s+On6dkA1YE8hYq96C5EhWqbD/pmTKpK++mx4hYCb+/w64oJ4s2tz6aQhc1
         DiITp107AvYz2mmQvPDRwkMHEveaVoZQ9oN2dvirszMEgMb46cDB2mPQgZw7SM+7eNu1
         KaSh0ieQLYvlEnnrXKk5F8znB5i7QCb87ADznhF+qZaskRju+fet8Fu7z7KklqAxRt6p
         eScT3fldB4Ef5fRVwpyQMPSZyM8bhw2QCDGW/Qj25E257EPElySl8G7FCv9HK9smJ7xQ
         yY+g==
X-Gm-Message-State: AOAM5324v8N3RZz5mhIUsd52nAx/P6GrZ8n2AYc4ioJnBVXbTRkkuUlj
        AFb0D/8aNy6iBMM7ZfG+OFU=
X-Google-Smtp-Source: ABdhPJz3FnQgzqPBX3W+RaBrkaWF88N2vIPdaJAS8wfKC0IR5X7L+W8bJX7ISvbMn5Oosn/6z8Czow==
X-Received: by 2002:a17:902:9a41:b0:140:4ca:761e with SMTP id x1-20020a1709029a4100b0014004ca761emr17295656plv.51.1635180519656;
        Mon, 25 Oct 2021 09:48:39 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b7cd:daa3:a144:1652])
        by smtp.gmail.com with ESMTPSA id b3sm17052582pfm.54.2021.10.25.09.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 09:48:39 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH v2 net-next 09/10] ipv4: guard IP_MINTTL with a static key
Date:   Mon, 25 Oct 2021 09:48:24 -0700
Message-Id: <20211025164825.259415-10-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211025164825.259415-1-eric.dumazet@gmail.com>
References: <20211025164825.259415-1-eric.dumazet@gmail.com>
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
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
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
index a9cbc8e6b796207f4880b2b32ff9289321080068..13d868c43284584ee0c58ddfd411bb52c8b0c830 100644
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
@@ -2070,10 +2072,12 @@ int tcp_v4_rcv(struct sk_buff *skb)
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

