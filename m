Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B0D3BF62D
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 09:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbhGHHX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 03:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbhGHHX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 03:23:56 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C5DC061574
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 00:21:13 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id y4so4633182pfi.9
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 00:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aYZ1Esg6LL4MXcsKYsHTI0Y0sj4NcxzeTaLhpUOcyBM=;
        b=gR8fPbfDK0qJHbhA7Vkn8xbr2z1pGtWFz7KbDsJxf22mnkePl6zRaufD9pCm2FGFBT
         7B/c2db9y7W5zt1WPKmmzCrIkgGmKZN1Sbe1TJFrTN9KqZpJJGOmIodQAuu9zN/s8B8k
         65gmOIYkhEhwKg8ZTZWzVTmlB5fQI0HUjMJmEZVY9K9++yRQFgWLc8+qv/Difiup7uM8
         z3guSrjCx7DslzSSiiFCsc0mGZodCaoca78f5nDkbqbTtLrcQppbBqw8nj2lYYJVHNvw
         mK6TSLIOjUg4iXqkxbH9Umy4hivxwByyz7QxHv0w/o63t5lqSZCEp0rGK7VZYRgyX7ph
         caAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aYZ1Esg6LL4MXcsKYsHTI0Y0sj4NcxzeTaLhpUOcyBM=;
        b=WRDISI896J6uTySiP1sLhnZeqHAC7uVaPH9v6feX/wcmhpdqRb8D8/O/YIZ9RUWqjC
         26glCK7DDcMCpRlznRJecr3hxOcbz1a37EZM1fwt/w3gvWJ/oR3ebplB9c4wp6+dm3lh
         hdxBRld9afUBbXHl6KYmgZKUwqe0JqhPKF1NKnH+u/rC/K51Xsm0XnwyzdU48Ah34BFE
         +1srHapO9O2ewWIK2Ak/qS9PgpiiI901OrJXJEsDUJa3Mxflva9QkwhW58VkrC+ocuiX
         NsYSv17idq88r28sFkKE4TxbrLKGDBokJzhgSM6sAVwi7nHuf9bhlFoi5Kxp1jGd/tOH
         RDJg==
X-Gm-Message-State: AOAM530EvXyEfJKo+QESrdDPqeFPtNoskW5OHiMCZdTnhNn1XC52AkNo
        aFhsoSmC/bZTLqcWo1MwbhA=
X-Google-Smtp-Source: ABdhPJz91OiU3vbrNXv6W1uYWyB+bNSU5ZUdbWtLtk+nesAzhCUySgVudH7EDoEFmsaqfK+XQz8lkg==
X-Received: by 2002:a63:470d:: with SMTP id u13mr14698089pga.318.1625728873389;
        Thu, 08 Jul 2021 00:21:13 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:a581:46f:f9f9:dfe5])
        by smtp.gmail.com with ESMTPSA id u21sm1512835pfh.163.2021.07.08.00.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 00:21:12 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH v3 net] ipv6: tcp: drop silly ICMPv6 packet too big messages
Date:   Thu,  8 Jul 2021 00:21:09 -0700
Message-Id: <20210708072109.1241563-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

While TCP stack scales reasonably well, there is still one part that
can be used to DDOS it.

IPv6 Packet too big messages have to lookup/insert a new route,
and if abused by attackers, can easily put hosts under high stress,
with many cpus contending on a spinlock while one is stuck in fib6_run_gc()

ip6_protocol_deliver_rcu()
 icmpv6_rcv()
  icmpv6_notify()
   tcp_v6_err()
    tcp_v6_mtu_reduced()
     inet6_csk_update_pmtu()
      ip6_rt_update_pmtu()
       __ip6_rt_update_pmtu()
        ip6_rt_cache_alloc()
         ip6_dst_alloc()
          dst_alloc()
           ip6_dst_gc()
            fib6_run_gc()
             spin_lock_bh() ...

Some of our servers have been hit by malicious ICMPv6 packets
trying to _increase_ the MTU/MSS of TCP flows.

We believe these ICMPv6 packets are a result of a bug in one ISP stack,
since they were blindly sent back for _every_ (small) packet sent to them.

These packets are for one TCP flow:
09:24:36.266491 IP6 Addr1 > Victim ICMP6, packet too big, mtu 1460, length 1240
09:24:36.266509 IP6 Addr1 > Victim ICMP6, packet too big, mtu 1460, length 1240
09:24:36.316688 IP6 Addr1 > Victim ICMP6, packet too big, mtu 1460, length 1240
09:24:36.316704 IP6 Addr1 > Victim ICMP6, packet too big, mtu 1460, length 1240
09:24:36.608151 IP6 Addr1 > Victim ICMP6, packet too big, mtu 1460, length 1240

TCP stack can filter some silly requests :

1) MTU below IPV6_MIN_MTU can be filtered early in tcp_v6_err()
2) tcp_v6_mtu_reduced() can drop requests trying to increase current MSS.

This tests happen before the IPv6 routing stack is entered, thus
removing the potential contention and route exhaustion.

Note that IPv6 stack was performing these checks, but too late
(ie : after the route has been added, and after the potential
garbage collect war)

v2: fix typo caught by Martin, thanks !
v3: exports tcp_mtu_to_mss(), caught by David, thanks !

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Maciej Żenczykowski <maze@google.com>
Cc: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv4/tcp_output.c |  1 +
 net/ipv6/tcp_ipv6.c   | 19 +++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index bde781f46b41a5dd9eb8db3fb65b45d73e592b4b..29553fce8502861087830b94cc4fbebfce6e60dc 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1732,6 +1732,7 @@ int tcp_mtu_to_mss(struct sock *sk, int pmtu)
 	return __tcp_mtu_to_mss(sk, pmtu) -
 	       (tcp_sk(sk)->tcp_header_len - sizeof(struct tcphdr));
 }
+EXPORT_SYMBOL(tcp_mtu_to_mss);
 
 /* Inverse of above */
 int tcp_mss_to_mtu(struct sock *sk, int mss)
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 593c32fe57ed13a218492fd6056f2593e601ec79..323989927a0a6a2274bcbc1cd0ac72e9d49b24ad 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -348,11 +348,20 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 static void tcp_v6_mtu_reduced(struct sock *sk)
 {
 	struct dst_entry *dst;
+	u32 mtu;
 
 	if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE))
 		return;
 
-	dst = inet6_csk_update_pmtu(sk, READ_ONCE(tcp_sk(sk)->mtu_info));
+	mtu = READ_ONCE(tcp_sk(sk)->mtu_info);
+
+	/* Drop requests trying to increase our current mss.
+	 * Check done in __ip6_rt_update_pmtu() is too late.
+	 */
+	if (tcp_mtu_to_mss(sk, mtu) >= tcp_sk(sk)->mss_cache)
+		return;
+
+	dst = inet6_csk_update_pmtu(sk, mtu);
 	if (!dst)
 		return;
 
@@ -433,6 +442,8 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	}
 
 	if (type == ICMPV6_PKT_TOOBIG) {
+		u32 mtu = ntohl(info);
+
 		/* We are not interested in TCP_LISTEN and open_requests
 		 * (SYN-ACKs send out by Linux are always <576bytes so
 		 * they should go through unfragmented).
@@ -443,7 +454,11 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 		if (!ip6_sk_accept_pmtu(sk))
 			goto out;
 
-		WRITE_ONCE(tp->mtu_info, ntohl(info));
+		if (mtu < IPV6_MIN_MTU)
+			goto out;
+
+		WRITE_ONCE(tp->mtu_info, mtu);
+
 		if (!sock_owned_by_user(sk))
 			tcp_v6_mtu_reduced(sk);
 		else if (!test_and_set_bit(TCP_MTU_REDUCED_DEFERRED,
-- 
2.32.0.93.g670b81a890-goog

