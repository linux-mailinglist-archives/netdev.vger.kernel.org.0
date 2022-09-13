Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE98A5B6B3F
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 11:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbiIMJ7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 05:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiIMJ7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 05:59:01 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E895A4DF07
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 02:58:57 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id h8so12921129wrf.3
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 02:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=MhcKjlBpFQJIG0VapYNHkFxu6wK74dJzcB9rw1R8D9A=;
        b=c2pubQGEklSwYHBZ9178aXKhuxeIHqezgWTeTkeIVYgnBGtW2BowtJrHlNNYVfeeOu
         ayaBjGxDp4TWXjYPv8Exg1OqBH1URA+5Jt9QpW/PsaJWBZ2mkmiwH2oKym+X3+thGXIQ
         RwMz6NZv9npCsLxHgyMNAy9+6H4XR32Yz1vYE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=MhcKjlBpFQJIG0VapYNHkFxu6wK74dJzcB9rw1R8D9A=;
        b=L0EwXSz4AhnGhRnOTClSV+J3vA8xUQEEEQIVIPB/q61hhTFDPngoaoxjilsZVCtcGq
         V2k82huQ1lSgMp0n7Tmj84SK0iqnQUKAtwFcGx+iBjzy7PeipIxfokkwSzDPNuNx8hFA
         5Vpp/CrFu3S1rkO6aT81CMmbgQbIfdD0GMSJ6N5k0FmP8Ygl9DjVpIgrOBWtWFjC0/gh
         GOrsDuGGwqg86bXZnQNZySkdTtvQR+N4hPDMii4y6WNf7E3+QbTjS7T+hES+Aj4xMepR
         dZqe1ZW+E40CdknKdL3qSZtB+51yDoB+XVLie76UOJOn7XXbHcGCG4JroEFfsgUfH0B/
         Z8tQ==
X-Gm-Message-State: ACgBeo0Mmn5odpWPrsNauAdvhDBXyLD/6kpQ/Q7J8E+BFmlQjFL3x9jO
        H/hvVIxgqdA5xpEDE1yBomU6PExhz2uimw==
X-Google-Smtp-Source: AA6agR6k3huskXJjwvv8YuzK9oJOnRHoGDAasMr4eseHVgThokqgGOhnhGxO8Ka+zsmMhrBLOEOPVA==
X-Received: by 2002:a5d:5504:0:b0:228:b90c:e5e0 with SMTP id b4-20020a5d5504000000b00228b90ce5e0mr17730487wrv.624.1663063136111;
        Tue, 13 Sep 2022 02:58:56 -0700 (PDT)
Received: from cloudflare.com ([185.122.133.20])
        by smtp.gmail.com with ESMTPSA id p16-20020a05600c359000b003b486027c8asm7559937wmq.20.2022.09.13.02.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 02:58:55 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com
Subject: [RFC net-next] udp: Auto-bind connected sockets to unique 4-tuple with port sharing
Date:   Tue, 13 Sep 2022 11:58:55 +0200
Message-Id: <20220913095855.99323-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an RFC patch accompanying an LPC 2022 talk [1].

Users of connected UDP sockets who want to delegate the free source port
search to the kernel, by leaving the port unspecified at bind() time, face
a limitation today.

If the delayed auto-bind flag, IP_BIND_ADDRESS_NO_PORT, is set on the
socket, the source (IP, port) actually will not be shared between two
connected UDP sockets:

    # if there is just one ephemeral port
    system("sysctl -w net.ipv4.ip_local_port_range='60000 60000'")

    s1 = socket(AF_INET, SOCK_DGRAM)
    s1.setsockopt(SOL_IP, IP_BIND_ADDRESS_NO_PORT, 1)
    s1.bind(("192.0.2.1", 0))
    s1.connect(("1.1.1.1", 53))
    s2 = socket(AF_INET, SOCK_DGRAM)
    s2.setsockopt(SOL_IP, IP_BIND_ADDRESS_NO_PORT, 1)
    s2.bind(("192.0.2.1", 0))
    s2.connect(("1.0.0.1", 53)) # -> EAGAIN

This leaves users in a situation where the number of connected UDP sockets
on given IP is limited to the number of ephemeral ports.

If the user would like to share the source port when the 4-tuple is unique,
they have to resort to user-space free port search implementation with
4-tuple conflict detection, which is non-trivial [2].

To address this limitation, implement a new protocol operation for finding
a free port but avoiding the 4-tuple conflicts. The new operation is
similar to ->get_port but applies stricter criteria for determining if a
port is busy. Destination IP and port of existing sockets is checked
against the address the user passed to connect(), in addition to what
->get_port checks today (netns, src addr, device).

There already happens to exist a proto operation that has a signature
matching our needs here, that is takes a socket reference and a destination
address as arguments - named ->bind_add(). It is currently used only by
SCTP code, so we can re-purpose it.

To remain backward compatible, we call into ->bind_add at connect() time to
find a free port only if the user:

 1. has specified the local source IP but left port unspecified, and
 2. enabled IP_BIND_ADDRESS_NO_PORT, and
 3. enabled port sharing with SO_REUSEADDR.

If the above condition is met, we will try to find a local port that can be
shared with other existing sockets as long as the 4-tuple is unique. Or
fail with EAGAIN if we are out of local ports.

Rationale here is that today when source address sharing with REUSEADDR is
enabled for a UDP socket, setting BIND_ADDRESS_NO_PORT has no effect on
port selection and conflict detection. It merely delays the auto-bind from
bind() to connect()/sendmsg() time.

At the same time, users are unlikely to run into EAGAIN errors from
connect() calling into ->bind_add(), if for some reason they are setting
both REUSEADDR and BIND_ADDRESS_NO_PORT on their connected UDP sockets
already. For that to happen, we would have to encounter a 4-tuple conflict
with another existing connected UDP socket and completely run out of
ephemeral ports.

As this is an RFC submission and there are still a few things left to do:
- get rid of duplicated code between ->get_port and ->bind_add
- UDP-Lite and UDPv6 support is missing
- split code into patches
- add support for IPv6 sockets
- add selftests/net
- add man page docs

[1] https://lpc.events/event/16/contributions/1349/
[2] https://github.com/cloudflare/cloudflare-blog/blob/232b432c1d57/2022-02-connectx/connectx.py#L116

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/ipv4/af_inet.c  | 39 +++++++++++++++++++-
 net/ipv4/datagram.c | 11 +++++-
 net/ipv4/udp.c      | 89 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 136 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index d3ab1ae32ef5..de2918c9e9e2 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -187,6 +187,42 @@ static int inet_autobind(struct sock *sk)
 	return 0;
 }
 
+static int inet_autobind_reuse(struct sock *sk, struct sockaddr *uaddr, int addr_len)
+{
+	const struct sockaddr_in *usin = (struct sockaddr_in *)uaddr;
+	const struct proto *prot = READ_ONCE(sk->sk_prot);
+	struct inet_sock *inet = inet_sk(sk);
+	int err = -EAGAIN;
+
+	if (addr_len < sizeof(*usin))
+		return -EINVAL;
+	if (usin->sin_family != AF_INET)
+		return -EAFNOSUPPORT;
+
+	lock_sock(sk);
+	if (inet->inet_num)
+		goto ok;
+
+	if (sk->sk_reuse && !sk->sk_reuseport && prot->bind_add &&
+	    inet->inet_rcv_saddr && inet->inet_saddr) {
+		if (prot->bind_add(sk, uaddr, addr_len))
+			goto fail;
+		inet->inet_sport = htons(inet->inet_num);
+		inet->inet_daddr = usin->sin_addr.s_addr;
+		inet->inet_dport = usin->sin_port;
+		sk->sk_state = TCP_ESTABLISHED;
+	} else {
+		if (prot->get_port(sk, 0))
+			goto fail;
+		inet->inet_sport = htons(inet->inet_num);
+	}
+ok:
+	err = 0;
+fail:
+	release_sock(sk);
+	return err;
+}
+
 /*
  *	Move a socket into listening state.
  */
@@ -571,8 +607,9 @@ int inet_dgram_connect(struct socket *sock, struct sockaddr *uaddr,
 			return err;
 	}
 
-	if (data_race(!inet_sk(sk)->inet_num) && inet_autobind(sk))
+	if (data_race(!inet_sk(sk)->inet_num) && inet_autobind_reuse(sk, uaddr, addr_len))
 		return -EAGAIN;
+
 	return sk->sk_prot->connect(sk, uaddr, addr_len);
 }
 EXPORT_SYMBOL(inet_dgram_connect);
diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index 405a8c2aea64..18ba2403fc0e 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -68,8 +68,10 @@ int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len
 		if (sk->sk_prot->rehash)
 			sk->sk_prot->rehash(sk);
 	}
-	inet->inet_daddr = fl4->daddr;
-	inet->inet_dport = usin->sin_port;
+	if (!inet->inet_daddr)
+		inet->inet_daddr = fl4->daddr;
+	if (!inet->inet_dport)
+		inet->inet_dport = usin->sin_port;
 	reuseport_has_conns(sk, true);
 	sk->sk_state = TCP_ESTABLISHED;
 	sk_set_txhash(sk);
@@ -78,6 +80,11 @@ int __ip4_datagram_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len
 	sk_dst_set(sk, &rt->dst);
 	err = 0;
 out:
+	if (err) {
+		/* Dissolve any destination association auto-bind might have created */
+		inet->inet_daddr = 0;
+		inet->inet_dport = 0;
+	}
 	return err;
 }
 EXPORT_SYMBOL(__ip4_datagram_connect);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index cd72158e953a..38b73b7df30f 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -163,6 +163,28 @@ static int udp_lib_lport_inuse(struct net *net, __u16 num,
 	return 0;
 }
 
+static void udp_v4_lport_reuse_inuse(const struct net *net,
+				     const struct udp_hslot *hslot,
+				     unsigned long *bitmap,
+				     struct sock *sk, unsigned int log,
+				     __be32 daddr, __be16 dport)
+{
+	struct sock *sk2;
+
+	sk_for_each(sk2, &hslot->head) {
+		if (net_eq(sock_net(sk2), net) &&
+		    (!sk2->sk_bound_dev_if || !sk->sk_bound_dev_if ||
+		     sk2->sk_bound_dev_if == sk->sk_bound_dev_if) &&
+		    ((!sk2->sk_reuse &&
+		      inet_rcv_saddr_equal(sk, sk2, true)) ||
+		     (sk2->sk_reuse &&
+		      inet_rcv_saddr_equal(sk, sk2, false) &&
+		      inet_sk(sk2)->inet_daddr == daddr &&
+		      inet_sk(sk2)->inet_dport == dport)))
+			__set_bit(udp_sk(sk2)->udp_port_hash >> log, bitmap);
+	}
+}
+
 /*
  * Note: we still hold spinlock of primary hash chain, so no other writer
  * can insert/delete a socket with local_port == num
@@ -356,6 +378,72 @@ int udp_v4_get_port(struct sock *sk, unsigned short snum)
 	return udp_lib_get_port(sk, snum, hash2_nulladdr);
 }
 
+static int udp_v4_bind_add(struct sock *sk, struct sockaddr *uaddr, int addr_len)
+{
+	const struct sockaddr_in *usin = (struct sockaddr_in *)uaddr;
+	const struct proto *prot = READ_ONCE(sk->sk_prot);
+	struct udp_table *udptable = prot->h.udp_table;
+	DECLARE_BITMAP(bitmap, PORTS_PER_CHAIN);
+	struct udp_hslot *hslot, *hslot2;
+	struct net *net = sock_net(sk);
+	int low, high, remaining;
+	u16 first, last, snum;
+	u32 rand;
+
+	inet_sk_get_local_port_range(sk, &low, &high);
+	remaining = (high - low) + 1;
+
+	rand = prandom_u32();
+	first = reciprocal_scale(rand, remaining) + low;
+	last = first + udptable->mask + 1;
+	/* force rand to be an odd multiple of UDP_HTABLE_SIZE */
+	rand = (rand | 1) * (udptable->mask + 1);
+
+	do {
+		bitmap_zero(bitmap, PORTS_PER_CHAIN);
+
+		hslot = udp_hashslot(udptable, net, first);
+		spin_lock(&hslot->lock);
+
+		udp_v4_lport_reuse_inuse(net, hslot, bitmap, sk, udptable->log,
+					 usin->sin_addr.s_addr, usin->sin_port);
+
+		snum = first;
+		do {
+			if (low <= snum && snum <= high &&
+			    !test_bit(snum >> udptable->log, bitmap) &&
+			    !inet_is_local_reserved_port(net, snum))
+				goto found;
+			snum += rand;
+		} while (snum != first);
+
+		spin_unlock(&hslot->lock);
+		cond_resched();
+	} while (++first != last);
+
+	return 1;
+found:
+	inet_sk(sk)->inet_num = snum;
+	udp_sk(sk)->udp_port_hash = snum;
+	udp_sk(sk)->udp_portaddr_hash =
+		ipv4_portaddr_hash(sock_net(sk), inet_sk(sk)->inet_rcv_saddr, snum);
+
+	sk_add_node_rcu(sk, &hslot->head);
+	hslot->count++;
+	sock_prot_inuse_add(net, prot, 1);
+
+	hslot2 = udp_hashslot2(udptable, udp_sk(sk)->udp_portaddr_hash);
+	spin_lock(&hslot2->lock);
+	hlist_add_head_rcu(&udp_sk(sk)->udp_portaddr_node, &hslot2->head);
+	hslot2->count++;
+	spin_unlock(&hslot2->lock);
+
+	sock_set_flag(sk, SOCK_RCU_FREE);
+	spin_unlock(&hslot->lock);
+
+	return 0;
+}
+
 static int compute_score(struct sock *sk, struct net *net,
 			 __be32 saddr, __be16 sport,
 			 __be32 daddr, unsigned short hnum,
@@ -2939,6 +3027,7 @@ struct proto udp_prot = {
 	.sendmsg		= udp_sendmsg,
 	.recvmsg		= udp_recvmsg,
 	.sendpage		= udp_sendpage,
+	.bind_add		= udp_v4_bind_add,
 	.release_cb		= ip4_datagram_release_cb,
 	.hash			= udp_lib_hash,
 	.unhash			= udp_lib_unhash,
-- 
2.37.2

