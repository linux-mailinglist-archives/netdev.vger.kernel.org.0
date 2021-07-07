Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A148B3BEB36
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 17:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbhGGPt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 11:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbhGGPtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 11:49:16 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9B6C061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 08:46:35 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id v13so1283821ple.9
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 08:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c61PyTXrVoxk2rBTTaYH+xmkp9c5Oo/Hq2Tio/8V9Os=;
        b=YYe4bdevG2yPkiSxxlNLK43/wknnce2IYwxHboVzJOFVROR+fUXQUQb+GiTJ0i/kkw
         h0e4Eroh1TdVFJ/WUwCbu86VVWJ6g4X9SLhApXoX+IBH7GfLhO+2xN861PYGG0M1EZxc
         4hE6oBVSaLhtQh8R7H3+MR3mPGVSg+IAk9zzF3wdSIV3ngUdwN/DMvW2BIoIBHEWARlj
         L8v0Fe/Jb/kqWG4uGcMD2pABUyxItqcWi5mpzjEkhw0UyRLhFHJUP4H/fVGM/LQxe4Pi
         eQLnvjtyxi6l+JPtpy4MMcNzGdueuQufrbvdY/3oDu9dleuSJoac+E/AWSg+4qmfnuSu
         BnJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c61PyTXrVoxk2rBTTaYH+xmkp9c5Oo/Hq2Tio/8V9Os=;
        b=rM0wMEfFWOTuZrgW1NA1B4js9YmjYqB0rLPhFvH5uDru1df+3CT/RF5Oed1ITItZQ2
         BPzDe8a5geL0kR6iO9RT5B0XJ+hNs5q78GIle2wiEEvZEYENPNriKmMUhtLzFvKzVTGu
         Y9lgbn6Ck/rQEv27srNSqLKftK6yrkxxkXL2u8zj9lnMpuI/G+/KfHYhdibN8JHi9XR/
         P4WSJVsm/sSvipYp9UsPSeVPPCtFjvJkJAajap4FcHP/eYhL3eWsxEa/R980/7qSaHdp
         cBIAuBC0ZmJUa1CiA+M7th5vnvUX80nTXJY2jgG7awak2luRhbow/EfVdl3W44Ut/llm
         H+kg==
X-Gm-Message-State: AOAM532JRLP2JSAfaA9K4xTewxqWTdlOysGZpQZbfL330woNRA+J9nVS
        /H+Ae4BqPLTbPXfHDEgTg28=
X-Google-Smtp-Source: ABdhPJxuG5max2hYhKRyo7BDG8WbS3fSA8zIiOkWg+F7mfDUqs5YvM4NyD5OSINmEOAux53VtQV2Kg==
X-Received: by 2002:a17:902:e291:b029:129:c9cd:a3ce with SMTP id o17-20020a170902e291b0290129c9cda3cemr1904190plc.36.1625672794671;
        Wed, 07 Jul 2021 08:46:34 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:a581:46f:f9f9:dfe5])
        by smtp.gmail.com with ESMTPSA id y206sm6633285pfb.112.2021.07.07.08.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 08:46:33 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Subject: [PATCH net] ipv6: tcp: drop silly ICMPv6 packet too big messages
Date:   Wed,  7 Jul 2021 08:46:30 -0700
Message-Id: <20210707154630.583448-1-eric.dumazet@gmail.com>
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
Cc: Maciej Żenczykowski <maze@google.com>
---
 net/ipv6/tcp_ipv6.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 593c32fe57ed13a218492fd6056f2593e601ec79..bc334a6f24992c7b5b2c415eab4b6cf51bf36cb4 100644
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
+	if (tcp_mss_to_mtu(sk, mtu) >= tcp_sk(sk)->mss_cache)
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

