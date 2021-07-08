Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29F13BF5C9
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 08:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhGHGws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 02:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbhGHGws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 02:52:48 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFEC1C06175F
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 23:50:06 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso3171487pjp.2
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 23:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8bVCcTw/QB2d10ydbvKnOK0p7roiVSvewU7h0cG1QaI=;
        b=EIALYOsdQY6YtCiXvl3V9XZ1DagM8kk6f2hu9hPR58syUgXc0l2aqKTzl3Udh3r5Ib
         ixIxQkYBVXvLPevRwY1VbMA53LrCu7/AOlfDXZaJqeN0WMFBO0xOjdWM5jUsaSKUxXGa
         jBvRg5IVulsGWi4g5HG0qg3ZcNqIHy1KF1wh74hE4EhtK/I1hA/KzRDEJ8g5+foDD14Z
         J9P8gLMaN9Tmrj5OBT5et8kC47A72mm3TYvVQyHzhrO3H35wNvmIB9RGviMkUzErDe0I
         kc/ruu71oH50v31hN55e/JskTLLQo4FEQ/KUPRsKA0oALGk4OSod5ekLkNamI1WWYvFa
         v/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8bVCcTw/QB2d10ydbvKnOK0p7roiVSvewU7h0cG1QaI=;
        b=lYPkOQe7Zw+6OQeuq/eLuA6xGObwAHzmdcIRJIK5s+u1AoFm4szCvxFyyfHKZ/AClq
         p+No/gKPcCWMzHvDLWMTY97XZ0YaJYvw85keUyZJ8QUDSwJDcf7uJySr4MTqBqUAdxjF
         B9BXtL3d88TXN5BwGnVu8No7saUeHsQ0Zzs/raQTR1aHD27qvhL/EBYZAjb6jWNyBFEo
         WMCB5UzSJ04jxzHR6wZm8D1PExKREJ8myuZMGbiOjS0TwT+YpGoAGyVT+HPgaaYCITRs
         K4hrXe6UuUmyzwZ9n3n4gjgYEPcbscqYM+df67Y4l8rGb5HXxCtMYyLKraLCh5F54CIW
         leuQ==
X-Gm-Message-State: AOAM5318mUXfW09QdruLAothN29KI9LO8sRxTZs1qZgPAMZ76I0hJf8g
        pafYYTsSagb5eqqj7QrQHm4=
X-Google-Smtp-Source: ABdhPJxaqfvbzB8c9pZQ82zBWDEz7X0kEiSeDRAVnAwVzc9J/HrOI/a6KzPthwQxSn5h6mNQLZ5Kjw==
X-Received: by 2002:a17:903:1243:b029:107:eca4:d5bf with SMTP id u3-20020a1709031243b0290107eca4d5bfmr24386452plh.15.1625727006454;
        Wed, 07 Jul 2021 23:50:06 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:a581:46f:f9f9:dfe5])
        by smtp.gmail.com with ESMTPSA id t17sm1515847pgl.93.2021.07.07.23.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 23:50:05 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH v2 net] ipv6: tcp: drop silly ICMPv6 packet too big messages
Date:   Wed,  7 Jul 2021 23:50:01 -0700
Message-Id: <20210708065001.1150422-1-eric.dumazet@gmail.com>
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

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Maciej Żenczykowski <maze@google.com>
Cc: Martin KaFai Lau <kafai@fb.com>
---
v2: fix typo caught by Martin, thanks !

 net/ipv6/tcp_ipv6.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

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

