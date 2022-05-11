Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2452524117
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 01:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349385AbiEKXiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 19:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiEKXiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 19:38:06 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5CA62237
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:38:03 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id p8so3264812pfh.8
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h0IOGqevoL4tbD+Eqh27YIST+kiKHUWghSlTlLJdS0U=;
        b=nWtgYgZ6iiHcprYbGamzQnlWooBcaZ9PVlDl4gKbOJJ1En7aAawjwN1iZ2U172i6rk
         B7GyOvXZ7VCh3theVn/P6WUn5llGg0kJM0DeWarsou9fRCg/SJrGKyiH1Qc6TUJyQbK0
         obfUOs2+yD1TqETlklevVIH3n/+GLg0cGJcRyF8ENI2xNUj4lGwE/bcBZxpJmXmv1JFf
         G9fdpv57A7Zb0YGl9jbspiGv37DN59HfANJmvM02Giqwfrod0MA+KUEG4sJxq+2H/v4f
         vkbxzgigge3Gt0TQAE+mj3+nbJiFZqCEE4iJndQsIvxL6qyj49cBQOGDAsuszmHlOwyS
         zm1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h0IOGqevoL4tbD+Eqh27YIST+kiKHUWghSlTlLJdS0U=;
        b=VNcqFLmrHO55jkkCy9m5XVRtdLsff5sB2l5VSptuyPAOeBnuINUZKGTCqhQDZdtTxj
         +x+r4NLNy7g6fVGncb2/M+t18+FsReqe/7FNFLWkzdNjM32Xp1IxlkoLSh/IWL/Y7gRM
         SaJXRmU07jwKeg3DV7DlJ0+jViEmcWHxKhfSTY1PI/wOtfbyB0rVL4L6fQW1AvxkMYQA
         CAinvrEsQcIxPpT+/z2ZQZypWNAdYG7WMWlvtpBsjPhElHswmy/8O79mVGNdXeCJkUFm
         xQIR2vZrVIDaSXNzI3QkSkjnnqnBurly9pjrfeSL1yWBhrNK69+oJjzUWTwaXYCeOQ7E
         rS8g==
X-Gm-Message-State: AOAM532f5zWntI9hTzDdMldoVCsqywiue0r7fL9hKwBOh3m3vSgq039T
        +rG/fB18Q7f1hbM5tvwPVm4=
X-Google-Smtp-Source: ABdhPJz1J+BJVe0bD0T/5eEH2RLlVvKvPZDyzm9LacBWZB1jI5/LwtC0BWhsSbtaMbHHUD1xXmhXfA==
X-Received: by 2002:a05:6a00:8c2:b0:510:98ac:96c9 with SMTP id s2-20020a056a0008c200b0051098ac96c9mr20311229pfu.18.1652312283484;
        Wed, 11 May 2022 16:38:03 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4ded:7658:34ff:528e])
        by smtp.gmail.com with ESMTPSA id x6-20020a623106000000b0050dc76281acsm2308668pfx.134.2022.05.11.16.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 16:38:03 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net-next 01/10] net: annotate races around sk->sk_bound_dev_if
Date:   Wed, 11 May 2022 16:37:48 -0700
Message-Id: <20220511233757.2001218-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220511233757.2001218-1-eric.dumazet@gmail.com>
References: <20220511233757.2001218-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

UDP sendmsg() is lockless, and reads sk->sk_bound_dev_if while
this field can be changed by another thread.

Adds minimal annotations to avoid KCSAN splats for UDP.
Following patches will add more annotations to potential lockless readers.

BUG: KCSAN: data-race in __ip6_datagram_connect / udpv6_sendmsg

write to 0xffff888136d47a94 of 4 bytes by task 7681 on cpu 0:
 __ip6_datagram_connect+0x6e2/0x930 net/ipv6/datagram.c:221
 ip6_datagram_connect+0x2a/0x40 net/ipv6/datagram.c:272
 inet_dgram_connect+0x107/0x190 net/ipv4/af_inet.c:576
 __sys_connect_file net/socket.c:1900 [inline]
 __sys_connect+0x197/0x1b0 net/socket.c:1917
 __do_sys_connect net/socket.c:1927 [inline]
 __se_sys_connect net/socket.c:1924 [inline]
 __x64_sys_connect+0x3d/0x50 net/socket.c:1924
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x50 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff888136d47a94 of 4 bytes by task 7670 on cpu 1:
 udpv6_sendmsg+0xc60/0x16e0 net/ipv6/udp.c:1436
 inet6_sendmsg+0x5f/0x80 net/ipv6/af_inet6.c:652
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg net/socket.c:725 [inline]
 ____sys_sendmsg+0x39a/0x510 net/socket.c:2413
 ___sys_sendmsg net/socket.c:2467 [inline]
 __sys_sendmmsg+0x267/0x4c0 net/socket.c:2553
 __do_sys_sendmmsg net/socket.c:2582 [inline]
 __se_sys_sendmmsg net/socket.c:2579 [inline]
 __x64_sys_sendmmsg+0x53/0x60 net/socket.c:2579
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x50 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x00000000 -> 0xffffff9b

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 7670 Comm: syz-executor.3 Tainted: G        W         5.18.0-rc1-syzkaller-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

I chose to not add Fixes: tag because race has minor consequences
and stable teams busy enough.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/net/ip.h    |  2 +-
 include/net/sock.h  |  5 +++--
 net/ipv6/datagram.c |  6 +++---
 net/ipv6/udp.c      | 11 ++++++-----
 4 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 3984f2c39c4ba8b4d2a4e4dab6d743f0c9faf798..8ad04f60b4132e163381b3a051c3f3d13e57c2ba 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -93,7 +93,7 @@ static inline void ipcm_init_sk(struct ipcm_cookie *ipcm,
 
 	ipcm->sockc.mark = inet->sk.sk_mark;
 	ipcm->sockc.tsflags = inet->sk.sk_tsflags;
-	ipcm->oif = inet->sk.sk_bound_dev_if;
+	ipcm->oif = READ_ONCE(inet->sk.sk_bound_dev_if);
 	ipcm->addr = inet->inet_saddr;
 }
 
diff --git a/include/net/sock.h b/include/net/sock.h
index 73063c88a2499b31c1e8d25dc157d21f93b02bf5..f6663e1d881d16014cc1439f7bb04f5d16b3db4f 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2878,13 +2878,14 @@ static inline void sk_pacing_shift_update(struct sock *sk, int val)
  */
 static inline bool sk_dev_equal_l3scope(struct sock *sk, int dif)
 {
+	int bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
 	int mdif;
 
-	if (!sk->sk_bound_dev_if || sk->sk_bound_dev_if == dif)
+	if (!bound_dev_if || bound_dev_if == dif)
 		return true;
 
 	mdif = l3mdev_master_ifindex_by_index(sock_net(sk), dif);
-	if (mdif && mdif == sk->sk_bound_dev_if)
+	if (mdif && mdif == bound_dev_if)
 		return true;
 
 	return false;
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 39b2327edc4e993d5a74a03eae8986a9152dea2b..df665d4e8f0f130f1d65e368f1b495fed794b70a 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -218,11 +218,11 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
 				err = -EINVAL;
 				goto out;
 			}
-			sk->sk_bound_dev_if = usin->sin6_scope_id;
+			WRITE_ONCE(sk->sk_bound_dev_if, usin->sin6_scope_id);
 		}
 
 		if (!sk->sk_bound_dev_if && (addr_type & IPV6_ADDR_MULTICAST))
-			sk->sk_bound_dev_if = np->mcast_oif;
+			WRITE_ONCE(sk->sk_bound_dev_if, np->mcast_oif);
 
 		/* Connect to link-local address requires an interface */
 		if (!sk->sk_bound_dev_if) {
@@ -798,7 +798,7 @@ int ip6_datagram_send_ctl(struct net *net, struct sock *sk,
 			if (src_idx) {
 				if (fl6->flowi6_oif &&
 				    src_idx != fl6->flowi6_oif &&
-				    (sk->sk_bound_dev_if != fl6->flowi6_oif ||
+				    (READ_ONCE(sk->sk_bound_dev_if) != fl6->flowi6_oif ||
 				     !sk_dev_equal_l3scope(sk, src_idx)))
 					return -EINVAL;
 				fl6->flowi6_oif = src_idx;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 3fc97d4621ac4a1f86de1f20375b33afffd0a2e6..960cfea820160614f3606ce4f407b7aa89fc70e1 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -105,7 +105,7 @@ static int compute_score(struct sock *sk, struct net *net,
 			 const struct in6_addr *daddr, unsigned short hnum,
 			 int dif, int sdif)
 {
-	int score;
+	int bound_dev_if, score;
 	struct inet_sock *inet;
 	bool dev_match;
 
@@ -132,10 +132,11 @@ static int compute_score(struct sock *sk, struct net *net,
 		score++;
 	}
 
-	dev_match = udp_sk_bound_dev_eq(net, sk->sk_bound_dev_if, dif, sdif);
+	bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
+	dev_match = udp_sk_bound_dev_eq(net, bound_dev_if, dif, sdif);
 	if (!dev_match)
 		return -1;
-	if (sk->sk_bound_dev_if)
+	if (bound_dev_if)
 		score++;
 
 	if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
@@ -789,7 +790,7 @@ static bool __udp_v6_is_mcast_sock(struct net *net, struct sock *sk,
 	    (inet->inet_dport && inet->inet_dport != rmt_port) ||
 	    (!ipv6_addr_any(&sk->sk_v6_daddr) &&
 		    !ipv6_addr_equal(&sk->sk_v6_daddr, rmt_addr)) ||
-	    !udp_sk_bound_dev_eq(net, sk->sk_bound_dev_if, dif, sdif) ||
+	    !udp_sk_bound_dev_eq(net, READ_ONCE(sk->sk_bound_dev_if), dif, sdif) ||
 	    (!ipv6_addr_any(&sk->sk_v6_rcv_saddr) &&
 		    !ipv6_addr_equal(&sk->sk_v6_rcv_saddr, loc_addr)))
 		return false;
@@ -1433,7 +1434,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	}
 
 	if (!fl6->flowi6_oif)
-		fl6->flowi6_oif = sk->sk_bound_dev_if;
+		fl6->flowi6_oif = READ_ONCE(sk->sk_bound_dev_if);
 
 	if (!fl6->flowi6_oif)
 		fl6->flowi6_oif = np->sticky_pktinfo.ipi6_ifindex;
-- 
2.36.0.512.ge40c2bad7a-goog

