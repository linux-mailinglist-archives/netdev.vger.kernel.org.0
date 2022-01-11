Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD0C48A4F4
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346254AbiAKBZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:25:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346266AbiAKBY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:24:58 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD29C06175B;
        Mon, 10 Jan 2022 17:24:52 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id s1so30124289wra.6;
        Mon, 10 Jan 2022 17:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GjvOLRey0Y2EctehLACcoBC0HbQUE5JRzwrEobDyrp8=;
        b=ZQtr0/tL2Htz+j4DEXszz4JyjiMKj5j38gnc3PX/AK1AUKbVqeH/m5rbEKDiB4ZLZ+
         zGHNjhZMUzPApIm7vjINd3YNGGiOoGj1bBnniv1JIysWlgnIH/LsUVFmNnCgllb1HCxl
         c3N/E2MOdSbA22/MdCm3EYcnORZXqcxiSGCMUVFpjWPflpAbpAAUK7t+qIe4sYIcxVlX
         pTA+5lL60iXuxGUxM5IAM4W0rw9DzIJ8DK6GYy4CqRbp8PzR7GF+MW4PET8fHcXNrk/G
         LtiVY66X46ti36+S8DTwO1M9msFPZtjasOUin8eqUn0mQL997SSeGkKDYyjGICwUpW2u
         7tsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GjvOLRey0Y2EctehLACcoBC0HbQUE5JRzwrEobDyrp8=;
        b=oPE/WcbMTWumBtew8ofZafPauJDQFTI9WgAY69wE+jXV0FIDVBo9arkb01Bw0Ueq7O
         8sDSmgBohOeixNUZnRWeFdMwxLENB//EVWFeheoVC2vylRzE9tqDDH8Ld6otKwxCHGO3
         InnoQw0h+xFJOLsER6ieQRfR3H6QsuGUmZ0ztSF0hx+g0LTAI/rMHfzJVlO8+fFhgpgM
         dL/Mwd+8MMl2tdwz6JK4PqZSagaYmuJ7JoC1A5hBRnkLxpzY+t7k3xFztfTSci5/c5p2
         20CyfKnoXs7rf746BBxrs94qMqKXkae3ESVLFYdmqjDMnT476TcBfnrsS5tlL0w5wdEH
         z77A==
X-Gm-Message-State: AOAM5332eGAMnLlikdyZAfvMU2t9tpI/xfanAbQEkhipp90uhmuo3irP
        EDbehzd0zlH1K0YpQ97iuWpWMMPKF3o=
X-Google-Smtp-Source: ABdhPJwGbRLtdO/NE1WoM31km4eQ75oFlxdFUWy0ZWjzYbuLFwKge2HxRNz3R+QYMIghHpSFK9bMsA==
X-Received: by 2002:a5d:59a7:: with SMTP id p7mr1760446wrr.258.1641864291205;
        Mon, 10 Jan 2022 17:24:51 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id i8sm709886wru.26.2022.01.10.17.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 17:24:50 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 08/14] ipv6/udp: don't make extra copies of iflow
Date:   Tue, 11 Jan 2022 01:21:40 +0000
Message-Id: <c881d18e649cd8bb0a96499c1e2fbffa0035158c.1641863490.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1641863490.git.asml.silence@gmail.com>
References: <cover.1641863490.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct flowi takes 88 bytes and copying it is relatively expensive.
Currenly, udpv6_sendmsg() first initialises an on-stack struct flowi6
and then copies it into cork. Instead, directly initialise a flow in an
on-stack cork, i.e. cork->fl, so corkless udp can avoid making an extra
copy.

Note: moving inet_cork_full instance shouldn't grow stack too much,
it replaces 88 bytes for iflow with 160.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/udp.c | 85 +++++++++++++++++++++++++-------------------------
 1 file changed, 42 insertions(+), 43 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 2580705431ea..eec83e34ae27 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1294,7 +1294,8 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct ipv6_txoptions *opt = NULL;
 	struct ipv6_txoptions *opt_to_free = NULL;
 	struct ip6_flowlabel *flowlabel = NULL;
-	struct flowi6 fl6;
+	struct inet_cork_full cork;
+	struct flowi6 *fl6 = &cork.fl.u.ip6;
 	struct dst_entry *dst;
 	struct ipcm6_cookie ipc6;
 	int addr_len = msg->msg_namelen;
@@ -1384,19 +1385,19 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	}
 	ulen += sizeof(struct udphdr);
 
-	memset(&fl6, 0, sizeof(fl6));
+	memset(fl6, 0, sizeof(*fl6));
 
 	if (sin6) {
 		if (sin6->sin6_port == 0)
 			return -EINVAL;
 
-		fl6.fl6_dport = sin6->sin6_port;
+		fl6->fl6_dport = sin6->sin6_port;
 		daddr = &sin6->sin6_addr;
 
 		if (np->sndflow) {
-			fl6.flowlabel = sin6->sin6_flowinfo&IPV6_FLOWINFO_MASK;
-			if (fl6.flowlabel&IPV6_FLOWLABEL_MASK) {
-				flowlabel = fl6_sock_lookup(sk, fl6.flowlabel);
+			fl6->flowlabel = sin6->sin6_flowinfo&IPV6_FLOWINFO_MASK;
+			if (fl6->flowlabel & IPV6_FLOWLABEL_MASK) {
+				flowlabel = fl6_sock_lookup(sk, fl6->flowlabel);
 				if (IS_ERR(flowlabel))
 					return -EINVAL;
 			}
@@ -1413,24 +1414,24 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		if (addr_len >= sizeof(struct sockaddr_in6) &&
 		    sin6->sin6_scope_id &&
 		    __ipv6_addr_needs_scope_id(__ipv6_addr_type(daddr)))
-			fl6.flowi6_oif = sin6->sin6_scope_id;
+			fl6->flowi6_oif = sin6->sin6_scope_id;
 	} else {
 		if (sk->sk_state != TCP_ESTABLISHED)
 			return -EDESTADDRREQ;
 
-		fl6.fl6_dport = inet->inet_dport;
+		fl6->fl6_dport = inet->inet_dport;
 		daddr = &sk->sk_v6_daddr;
-		fl6.flowlabel = np->flow_label;
+		fl6->flowlabel = np->flow_label;
 		connected = true;
 	}
 
-	if (!fl6.flowi6_oif)
-		fl6.flowi6_oif = sk->sk_bound_dev_if;
+	if (!fl6->flowi6_oif)
+		fl6->flowi6_oif = sk->sk_bound_dev_if;
 
-	if (!fl6.flowi6_oif)
-		fl6.flowi6_oif = np->sticky_pktinfo.ipi6_ifindex;
+	if (!fl6->flowi6_oif)
+		fl6->flowi6_oif = np->sticky_pktinfo.ipi6_ifindex;
 
-	fl6.flowi6_uid = sk->sk_uid;
+	fl6->flowi6_uid = sk->sk_uid;
 
 	if (msg->msg_controllen) {
 		opt = &opt_space;
@@ -1440,14 +1441,14 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 		err = udp_cmsg_send(sk, msg, &ipc6.gso_size);
 		if (err > 0)
-			err = ip6_datagram_send_ctl(sock_net(sk), sk, msg, &fl6,
+			err = ip6_datagram_send_ctl(sock_net(sk), sk, msg, fl6,
 						    &ipc6);
 		if (err < 0) {
 			fl6_sock_release(flowlabel);
 			return err;
 		}
-		if ((fl6.flowlabel&IPV6_FLOWLABEL_MASK) && !flowlabel) {
-			flowlabel = fl6_sock_lookup(sk, fl6.flowlabel);
+		if ((fl6->flowlabel&IPV6_FLOWLABEL_MASK) && !flowlabel) {
+			flowlabel = fl6_sock_lookup(sk, fl6->flowlabel);
 			if (IS_ERR(flowlabel))
 				return -EINVAL;
 		}
@@ -1464,16 +1465,17 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	opt = ipv6_fixup_options(&opt_space, opt);
 	ipc6.opt = opt;
 
-	fl6.flowi6_proto = sk->sk_protocol;
-	fl6.flowi6_mark = ipc6.sockc.mark;
-	fl6.daddr = *daddr;
-	if (ipv6_addr_any(&fl6.saddr) && !ipv6_addr_any(&np->saddr))
-		fl6.saddr = np->saddr;
-	fl6.fl6_sport = inet->inet_sport;
+	fl6->flowi6_proto = sk->sk_protocol;
+	fl6->flowi6_mark = ipc6.sockc.mark;
+	fl6->daddr = *daddr;
+	if (ipv6_addr_any(&fl6->saddr) && !ipv6_addr_any(&np->saddr))
+		fl6->saddr = np->saddr;
+	fl6->fl6_sport = inet->inet_sport;
 
 	if (cgroup_bpf_enabled(CGROUP_UDP6_SENDMSG) && !connected) {
 		err = BPF_CGROUP_RUN_PROG_UDP6_SENDMSG_LOCK(sk,
-					   (struct sockaddr *)sin6, &fl6.saddr);
+					   (struct sockaddr *)sin6,
+					   &fl6->saddr);
 		if (err)
 			goto out_no_dst;
 		if (sin6) {
@@ -1489,32 +1491,32 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 				err = -EINVAL;
 				goto out_no_dst;
 			}
-			fl6.fl6_dport = sin6->sin6_port;
-			fl6.daddr = sin6->sin6_addr;
+			fl6->fl6_dport = sin6->sin6_port;
+			fl6->daddr = sin6->sin6_addr;
 		}
 	}
 
-	if (ipv6_addr_any(&fl6.daddr))
-		fl6.daddr.s6_addr[15] = 0x1; /* :: means loopback (BSD'ism) */
+	if (ipv6_addr_any(&fl6->daddr))
+		fl6->daddr.s6_addr[15] = 0x1; /* :: means loopback (BSD'ism) */
 
-	final_p = fl6_update_dst(&fl6, opt, &final);
+	final_p = fl6_update_dst(fl6, opt, &final);
 	if (final_p)
 		connected = false;
 
-	if (!fl6.flowi6_oif && ipv6_addr_is_multicast(&fl6.daddr)) {
-		fl6.flowi6_oif = np->mcast_oif;
+	if (!fl6->flowi6_oif && ipv6_addr_is_multicast(&fl6->daddr)) {
+		fl6->flowi6_oif = np->mcast_oif;
 		connected = false;
-	} else if (!fl6.flowi6_oif)
-		fl6.flowi6_oif = np->ucast_oif;
+	} else if (!fl6->flowi6_oif)
+		fl6->flowi6_oif = np->ucast_oif;
 
-	security_sk_classify_flow(sk, flowi6_to_flowi_common(&fl6));
+	security_sk_classify_flow(sk, flowi6_to_flowi_common(fl6));
 
 	if (ipc6.tclass < 0)
 		ipc6.tclass = np->tclass;
 
-	fl6.flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6.flowlabel);
+	fl6->flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6->flowlabel);
 
-	dst = ip6_sk_dst_lookup_flow(sk, &fl6, final_p, connected);
+	dst = ip6_sk_dst_lookup_flow(sk, fl6, final_p, connected);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		dst = NULL;
@@ -1522,7 +1524,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	}
 
 	if (ipc6.hlimit < 0)
-		ipc6.hlimit = ip6_sk_dst_hoplimit(np, &fl6, dst);
+		ipc6.hlimit = ip6_sk_dst_hoplimit(np, fl6, dst);
 
 	if (msg->msg_flags&MSG_CONFIRM)
 		goto do_confirm;
@@ -1530,18 +1532,15 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	/* Lockless fast path for the non-corking case */
 	if (!corkreq) {
-		struct inet_cork_full cork;
 		struct sk_buff *skb;
 
-		cork.fl.u.ip6 = fl6;
-
 		skb = ip6_make_skb(sk, getfrag, msg, ulen,
 				   sizeof(struct udphdr), &ipc6,
 				   (struct rt6_info *)dst,
 				   msg->msg_flags, &cork);
 		err = PTR_ERR(skb);
 		if (!IS_ERR_OR_NULL(skb))
-			err = udp_v6_send_skb(skb, &fl6, &cork.base);
+			err = udp_v6_send_skb(skb, fl6, &cork.base);
 		goto out;
 	}
 
@@ -1563,7 +1562,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		ipc6.dontfrag = np->dontfrag;
 	up->len += ulen;
 	err = ip6_append_data(sk, getfrag, msg, ulen, sizeof(struct udphdr),
-			      &ipc6, &fl6, (struct rt6_info *)dst,
+			      &ipc6, fl6, (struct rt6_info *)dst,
 			      corkreq ? msg->msg_flags|MSG_MORE : msg->msg_flags);
 	if (err)
 		udp_v6_flush_pending_frames(sk);
@@ -1598,7 +1597,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 do_confirm:
 	if (msg->msg_flags & MSG_PROBE)
-		dst_confirm_neigh(dst, &fl6.daddr);
+		dst_confirm_neigh(dst, &fl6->daddr);
 	if (!(msg->msg_flags&MSG_PROBE) || len)
 		goto back_from_confirm;
 	err = 0;
-- 
2.34.1

