Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 154D449D6D9
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbiA0Ag4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234061AbiA0Agr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:36:47 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FDCC061755;
        Wed, 26 Jan 2022 16:36:46 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id a8so2085043ejc.8;
        Wed, 26 Jan 2022 16:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FrxWZOLdX8kzfbgGNePsf48Jt9sSElrC1nnUoAy2AoA=;
        b=qRVi1tV3qc4J+oggyap7jLI53x0g5mclcHCmXWQJ6YRhtQ1QuRxZduobIJ2Xs4/Dyg
         gTvxE0fRxkqGCAVr8nV7Nh6xU6zXiEBoGB8TAvz8X02rSLPRxHOrg2mo838CFf1ztWUj
         d8WjxBonx9K548UCm3bQvozJ62oKomGKv8CYd5XuoI40FvSn1Jm76lPnXgAT8JQBEkH2
         debcEhiq0TflGDh4tnofJb3TQaxj4xHiRHeW73vNbCu2cwu16RNWMAK5hzrQ0VQWr2Dw
         Vpdw7rFZxS7rEQYDV7bBNn7Ch6qKWGLEGO8qm+w9bNjz8ftW8LKbCno2bmlTsoTxMaUY
         YJmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FrxWZOLdX8kzfbgGNePsf48Jt9sSElrC1nnUoAy2AoA=;
        b=q8pq9kZqN2FKYmSCr5e4FFz+t+Izb0oApF5KH/gGuWRuquz+xRFkhZv9kqeKHvJ6dL
         19ZQqQl/LOik+w25sRJGBbnB/Dn7BUOnCl4huuxJKr0dZmnYBeKKKy3a8di6XFMaeip0
         X9CzzN228s5XrlxBibRyxhc/uCi7+2GBT8Jd0sD8dsZeubZXY3T4/d9xwjkIHLzdHfj6
         YLvR0hrkFTMd3MuPxf5nXTmTajLw2DjnspdYajB/Y5yid+tc39ZAIkgx6NvaQI6v28aa
         5acha0biabJMYaZVupQfNqjIcH8LQeSQ8YNmCmzmvC2HJEgYNckqJadJBbe8xDI0kLnr
         JwWQ==
X-Gm-Message-State: AOAM5310Hmtxpe4f5x77tjc5Iap8iERbxTVIckDv6DQiwaAhH9FmuCv1
        xATixnQWttjC5iG1JdMnfwdWJuxzbDc=
X-Google-Smtp-Source: ABdhPJzqHYg2qgHRxJB2Pco/QXkWa/FVGiLU+gGBZihqlCnglWCVfgmZoSjXNAqMnq6Yf/5NYPuL2w==
X-Received: by 2002:a17:906:7948:: with SMTP id l8mr1016303ejo.636.1643243804758;
        Wed, 26 Jan 2022 16:36:44 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.234.222])
        by smtp.gmail.com with ESMTPSA id op27sm8039235ejb.103.2022.01.26.16.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 16:36:44 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v2 08/10] udp6: don't make extra copies of iflow
Date:   Thu, 27 Jan 2022 00:36:29 +0000
Message-Id: <46cf12d281bede877a156d4ac224c21809ee3764.1643243773.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1643243772.git.asml.silence@gmail.com>
References: <cover.1643243772.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

udpv6_sendmsg() first initialises an on-stack 88B struct flowi6 and then
copies it into cork, which is expensive. Avoid the copy in corkless case
by initialising on-stack cork->fl directly.

The main part is a couple of lines under !corkreq check. The rest
converts fl6 variable to be a pointer.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/udp.c | 85 +++++++++++++++++++++++++-------------------------
 1 file changed, 42 insertions(+), 43 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 44b7ca9bd78e..cfcf08c3df4d 100644
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

