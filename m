Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34D3BB04AA
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 21:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbfIKTu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 15:50:59 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33184 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727581AbfIKTu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 15:50:59 -0400
Received: by mail-qk1-f196.google.com with SMTP id x134so22092293qkb.0
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 12:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oeClHo453ihI+LBpAjPESMb7zSBeoKaBbCG+JDeB8uw=;
        b=p7dszHhDgmkixYKyP11Ftl6kAl00lbT5Z3nnkb7Q+nuiuH7RV0MJ0KYAfjWGrdaDrP
         1hE+5Z/g+royeYqFRq/GzJ/2YUhMdnsp6eJT2D9vEGHKlBvxS1m6M7qeOA33nktUZLB5
         rpbJP0y4eG46fFJerAUk3uWxi+Lm83Rm18mn2P00LoKJKka1ILpae463Ze9dNKucm+rf
         8oVbTgPuelaQmcahgeFnc5gFt/dh/Zg8oBCSTpSCw9rXCocCeBsmaxkANQpdDQLnCIF7
         pBBkr1+amCFK7IH2Rgy1xgZ5aF4lPmhaVpQVuBmdNq27hEKZbJuF86+4dark0ypDEFKf
         C72Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oeClHo453ihI+LBpAjPESMb7zSBeoKaBbCG+JDeB8uw=;
        b=I4+S49wBthTBgsIheu1HzwvrkKYVuw33u8e0umbH2dZ0HVlVVcsyGNPIAej/sevUX9
         KywN3oiUHn6mWLHBsqPsvxG1gtQRjB3ckqnSNGFCN5Gw/Zo6Isg53zkNTb6xaGm2fYQC
         Oq4dfrbF2xjj4SkfqmuGQ/Gc6dgo4JjSnNu4otHflaYtOvs+zd+EGLodSblFotS5kiY0
         RSD2EgGvYcK1shLfNyg/8iOHbjdL+lhW5hUhH6Zv3Mo53ymr3zjt9fzMl/uVbiXGEdt9
         pa0NQmHGyoxDFh/WKcU/mONVNLSCl8I92ZFQN54XFykXkjnulVhbpwIOxEn8IOxEpKNk
         MVRQ==
X-Gm-Message-State: APjAAAUFYvDQqjMXYaV9lhVXsMdREa1G7J5sa4r7uqrZ0F355NYO6eaJ
        40ZGVEw9i60TxibpjA7BC8tkCl/L
X-Google-Smtp-Source: APXvYqz7rhR3GUjCHbLA/DafiNleh6iWNwEH9vOZQ3uZEpEKMbg4XCf76TzM7xS0/ENopI1pZjkDkQ==
X-Received: by 2002:a37:aa8b:: with SMTP id t133mr35088615qke.406.1568231457662;
        Wed, 11 Sep 2019 12:50:57 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:89db:8f93:8219:1619])
        by smtp.gmail.com with ESMTPSA id 44sm8902260qtt.13.2019.09.11.12.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 12:50:56 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next] ip: support SO_MARK cmsg
Date:   Wed, 11 Sep 2019 15:50:51 -0400
Message-Id: <20190911195051.166062-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.23.0.162.g0b9fbb3734-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Enable setting skb->mark for UDP and RAW sockets using cmsg.

This is analogous to existing support for TOS, TTL, txtime, etc.

Packet sockets already support this as of commit c7d39e32632e
("packet: support per-packet fwmark for af_packet sendmsg").

Similar to other fields, implement by
1. initialize the sockcm_cookie.mark from socket option sk_mark
2. optionally overwrite this in ip_cmsg_send/ip6_datagram_send_ctl
3. initialize inet_cork.mark from sockcm_cookie.mark
4. initialize each (usually just one) skb->mark from inet_cork.mark

Step 1 is handled in one location for most protocols by ipcm_init_sk
as of commit 351782067b6b ("ipv4: ipcm_cookie initializers").

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 include/net/inet_sock.h | 1 +
 include/net/ip.h        | 1 +
 net/ipv4/ip_output.c    | 3 ++-
 net/ipv4/ping.c         | 2 +-
 net/ipv4/raw.c          | 4 ++--
 net/ipv4/udp.c          | 2 +-
 net/ipv6/ip6_output.c   | 3 ++-
 net/ipv6/raw.c          | 4 +++-
 net/ipv6/udp.c          | 3 ++-
 9 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 7769c9b36d75..34c4436fd18f 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -160,6 +160,7 @@ struct inet_cork {
 	char			priority;
 	__u16			gso_size;
 	u64			transmit_time;
+	u32			mark;
 };
 
 struct inet_cork_full {
diff --git a/include/net/ip.h b/include/net/ip.h
index 29d89de39822..95bb77f95bcc 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -88,6 +88,7 @@ static inline void ipcm_init_sk(struct ipcm_cookie *ipcm,
 {
 	ipcm_init(ipcm);
 
+	ipcm->sockc.mark = inet->sk.sk_mark;
 	ipcm->sockc.tsflags = inet->sk.sk_tsflags;
 	ipcm->oif = inet->sk.sk_bound_dev_if;
 	ipcm->addr = inet->inet_saddr;
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index cc7ef0d05bbd..5eb73775c3f7 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1266,6 +1266,7 @@ static int ip_setup_cork(struct sock *sk, struct inet_cork *cork,
 	cork->length = 0;
 	cork->ttl = ipc->ttl;
 	cork->tos = ipc->tos;
+	cork->mark = ipc->sockc.mark;
 	cork->priority = ipc->priority;
 	cork->transmit_time = ipc->sockc.transmit_time;
 	cork->tx_flags = 0;
@@ -1529,7 +1530,7 @@ struct sk_buff *__ip_make_skb(struct sock *sk,
 	}
 
 	skb->priority = (cork->tos != -1) ? cork->priority: sk->sk_priority;
-	skb->mark = sk->sk_mark;
+	skb->mark = cork->mark;
 	skb->tstamp = cork->transmit_time;
 	/*
 	 * Steal rt from cork.dst to avoid a pair of atomic_inc/atomic_dec
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 9d24ef5c5d8f..535427292194 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -781,7 +781,7 @@ static int ping_v4_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	} else if (!ipc.oif)
 		ipc.oif = inet->uc_index;
 
-	flowi4_init_output(&fl4, ipc.oif, sk->sk_mark, tos,
+	flowi4_init_output(&fl4, ipc.oif, ipc.sockc.mark, tos,
 			   RT_SCOPE_UNIVERSE, sk->sk_protocol,
 			   inet_sk_flowi_flags(sk), faddr, saddr, 0, 0,
 			   sk->sk_uid);
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 40a6abbc9cf6..80da5a66d5d7 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -375,7 +375,7 @@ static int raw_send_hdrinc(struct sock *sk, struct flowi4 *fl4,
 	skb_reserve(skb, hlen);
 
 	skb->priority = sk->sk_priority;
-	skb->mark = sk->sk_mark;
+	skb->mark = sockc->mark;
 	skb->tstamp = sockc->transmit_time;
 	skb_dst_set(skb, &rt->dst);
 	*rtp = NULL;
@@ -623,7 +623,7 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		}
 	}
 
-	flowi4_init_output(&fl4, ipc.oif, sk->sk_mark, tos,
+	flowi4_init_output(&fl4, ipc.oif, ipc.sockc.mark, tos,
 			   RT_SCOPE_UNIVERSE,
 			   hdrincl ? IPPROTO_RAW : sk->sk_protocol,
 			   inet_sk_flowi_flags(sk) |
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index d88821c794fb..fbcd9be3a470 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1130,7 +1130,7 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 		fl4 = &fl4_stack;
 
-		flowi4_init_output(fl4, ipc.oif, sk->sk_mark, tos,
+		flowi4_init_output(fl4, ipc.oif, ipc.sockc.mark, tos,
 				   RT_SCOPE_UNIVERSE, sk->sk_protocol,
 				   flow_flags,
 				   faddr, saddr, dport, inet->inet_sport,
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 8e49fd62eea9..89a4c7c2e25d 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1294,6 +1294,7 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 	cork->base.fragsize = mtu;
 	cork->base.gso_size = ipc6->gso_size;
 	cork->base.tx_flags = 0;
+	cork->base.mark = ipc6->sockc.mark;
 	sock_tx_timestamp(sk, ipc6->sockc.tsflags, &cork->base.tx_flags);
 
 	if (dst_allfrag(xfrm_dst_path(&rt->dst)))
@@ -1764,7 +1765,7 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 	hdr->daddr = *final_dst;
 
 	skb->priority = sk->sk_priority;
-	skb->mark = sk->sk_mark;
+	skb->mark = cork->base.mark;
 
 	skb->tstamp = cork->base.transmit_time;
 
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 8a6131991e38..6e1888ee4036 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -646,7 +646,7 @@ static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *msg, int length,
 
 	skb->protocol = htons(ETH_P_IPV6);
 	skb->priority = sk->sk_priority;
-	skb->mark = sk->sk_mark;
+	skb->mark = sockc->mark;
 	skb->tstamp = sockc->transmit_time;
 
 	skb_put(skb, length);
@@ -810,6 +810,7 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	ipcm6_init(&ipc6);
 	ipc6.sockc.tsflags = sk->sk_tsflags;
+	ipc6.sockc.mark = sk->sk_mark;
 
 	if (sin6) {
 		if (addr_len < SIN6_LEN_RFC2133)
@@ -891,6 +892,7 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	opt = ipv6_fixup_options(&opt_space, opt);
 
 	fl6.flowi6_proto = proto;
+	fl6.flowi6_mark = ipc6.sockc.mark;
 
 	if (!hdrincl) {
 		rfv.msg = msg;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 827fe7385078..2c8beb3896d1 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1230,6 +1230,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	ipcm6_init(&ipc6);
 	ipc6.gso_size = up->gso_size;
 	ipc6.sockc.tsflags = sk->sk_tsflags;
+	ipc6.sockc.mark = sk->sk_mark;
 
 	/* destination address check */
 	if (sin6) {
@@ -1352,7 +1353,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (!fl6.flowi6_oif)
 		fl6.flowi6_oif = np->sticky_pktinfo.ipi6_ifindex;
 
-	fl6.flowi6_mark = sk->sk_mark;
+	fl6.flowi6_mark = ipc6.sockc.mark;
 	fl6.flowi6_uid = sk->sk_uid;
 
 	if (msg->msg_controllen) {
-- 
2.23.0.162.g0b9fbb3734-goog

