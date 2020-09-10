Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775762639F0
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730475AbgIJCNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730715AbgIJCLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 22:11:43 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C4DC061370
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 17:51:27 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id b18so3039650qto.4
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 17:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=bevnLS6p2i/KUfO+B56/HYDMgMMRrNgD8ihrhRxCIaM=;
        b=IQAXT+ljhkmSUlT6cbgY+YKcphqXvrvAgzCYhP091xCR76D6mdX6C7Dd8Vux8PTVDy
         1XZ29FzYKpM54II8JIBXDSxhjz51lntB9aNcNE3P3kDE0yopLdy8JLQcW7S7qYCnme51
         9fnK60ZzlvacVAKFmGx7ps+vKZQ8gXoiF8g6mOo7TQ6ELAVT2SB56Tp2vOrEBB+C9wfN
         1UBI7lwmyFHLaG7W9zUGfKkT+g5zwpxO67KXr3yITFnF4aZjcurZmH8lh308mkynxsTr
         4XRAZFb1CuNMt19JuCcUmO/jFLK0/tSBUgEV9l1VGM8ueR7yT+u8s+t51GrWStXwg4ax
         jlMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bevnLS6p2i/KUfO+B56/HYDMgMMRrNgD8ihrhRxCIaM=;
        b=dVSRzxosxyNkXVUkFT2vHBUy1yZKFHHlRyvqqCBN5a1so4g36YEn+c3CkDKJqQ4Ydy
         RQ93J8kbcWTUJPpxwErnVTPaDRRQHBTzCmfosHtihXg5xVkkSyUOk2ig46hBHcXh3f80
         YgQAaVi5O+W3fiU3Zu4f32LRwI0zl19S9nGfjQCUBmf+ZCbPUcOFlsCeYUYvgMLyRwVw
         QSrf32VwpELGrFt5YqirjOPAoaLQ4Z8NOBnJxvnc/bT3eStNwG2sEf3VJ/G21q0hKyVW
         mmde2+uPJmE1OCOitzbu03gQ0hal3SP+Yj7eTRcm44lUOB3DW9hQu3bPHMmpJnzQdU3D
         WBAA==
X-Gm-Message-State: AOAM533RJydLJGv6Pb7Ihe0InJ2PMc3HTQ+UwFUSF9rpDTLj7N6eSwFw
        3igofwsNRdSXCawXJl8U205cxHVtLFU=
X-Google-Smtp-Source: ABdhPJyuGrfS+gUWcODccRXmVBD4fmtstIZvL5DRTGURaYiN1qj3kU06PyTjwQUedK9SkB8hBX9kVZDxWSE=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a0c:a063:: with SMTP id b90mr4132472qva.25.1599699085534;
 Wed, 09 Sep 2020 17:51:25 -0700 (PDT)
Date:   Wed,  9 Sep 2020 17:50:48 -0700
In-Reply-To: <20200910005048.4146399-1-weiwan@google.com>
Message-Id: <20200910005048.4146399-4-weiwan@google.com>
Mime-Version: 1.0
References: <20200910005048.4146399-1-weiwan@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH net-next 3/3] tcp: reflect tos value received in SYN to the socket
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds a new TCP feature to reflect the tos value received in
SYN, and send it out on the SYN-ACK, and eventually set the tos value of
the established socket with this reflected tos value. This provides a
way to set the traffic class/QoS level for all traffic in the same
connection to be the same as the incoming SYN request. It could be
useful in data centers to provide equivalent QoS according to the
incoming request.
This feature is guarded by /proc/sys/net/ipv4/tcp_reflect_tos, and is by
default turned off.

Signed-off-by: Wei Wang <weiwan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/ipv4.h   |  1 +
 net/ipv4/sysctl_net_ipv4.c |  9 +++++++++
 net/ipv4/tcp_ipv4.c        | 10 +++++++++-
 net/ipv6/tcp_ipv6.c        | 10 +++++++++-
 4 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 9e36738c1fe1..8e4fcac4df72 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -183,6 +183,7 @@ struct netns_ipv4 {
 	unsigned int sysctl_tcp_fastopen_blackhole_timeout;
 	atomic_t tfo_active_disable_times;
 	unsigned long tfo_active_disable_stamp;
+	int sysctl_tcp_reflect_tos;
 
 	int sysctl_udp_wmem_min;
 	int sysctl_udp_rmem_min;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 54023a46db04..3e5f4f2e705e 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1329,6 +1329,15 @@ static struct ctl_table ipv4_net_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &comp_sack_nr_max,
 	},
+	{
+		.procname       = "tcp_reflect_tos",
+		.data           = &init_net.ipv4.sysctl_tcp_reflect_tos,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = SYSCTL_ZERO,
+		.extra2         = SYSCTL_ONE,
+	},
 	{
 		.procname	= "udp_rmem_min",
 		.data		= &init_net.ipv4.sysctl_udp_rmem_min,
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index c4c7ad4c8b5a..ace48b2790ff 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -972,6 +972,7 @@ static int tcp_v4_send_synack(const struct sock *sk, struct dst_entry *dst,
 	struct flowi4 fl4;
 	int err = -1;
 	struct sk_buff *skb;
+	u8 tos;
 
 	/* First, grab a route. */
 	if (!dst && (dst = inet_csk_route_req(sk, &fl4, req)) == NULL)
@@ -979,6 +980,9 @@ static int tcp_v4_send_synack(const struct sock *sk, struct dst_entry *dst,
 
 	skb = tcp_make_synack(sk, dst, req, foc, synack_type, syn_skb);
 
+	tos = sock_net(sk)->ipv4.sysctl_tcp_reflect_tos ?
+			tcp_rsk(req)->syn_tos : inet_sk(sk)->tos;
+
 	if (skb) {
 		__tcp_v4_send_check(skb, ireq->ir_loc_addr, ireq->ir_rmt_addr);
 
@@ -986,7 +990,7 @@ static int tcp_v4_send_synack(const struct sock *sk, struct dst_entry *dst,
 		err = ip_build_and_send_pkt(skb, sk, ireq->ir_loc_addr,
 					    ireq->ir_rmt_addr,
 					    rcu_dereference(ireq->ireq_opt),
-					    inet_sk(sk)->tos);
+					    tos & ~INET_ECN_MASK);
 		rcu_read_unlock();
 		err = net_xmit_eval(err);
 	}
@@ -1531,6 +1535,10 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 		inet_csk(newsk)->icsk_ext_hdr_len = inet_opt->opt.optlen;
 	newinet->inet_id = prandom_u32();
 
+	/* Set ToS of the new socket based upon the value of incoming SYN. */
+	if (sock_net(sk)->ipv4.sysctl_tcp_reflect_tos)
+		newinet->tos = tcp_rsk(req)->syn_tos & ~INET_ECN_MASK;
+
 	if (!dst) {
 		dst = inet_csk_route_child_sock(sk, newsk, req);
 		if (!dst)
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 04efa3ee80ef..862058dce6d0 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -510,6 +510,7 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
 	struct flowi6 *fl6 = &fl->u.ip6;
 	struct sk_buff *skb;
 	int err = -ENOMEM;
+	u8 tclass;
 
 	/* First, grab a route. */
 	if (!dst && (dst = inet6_csk_route_req(sk, fl6, req,
@@ -528,9 +529,12 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
 
 		rcu_read_lock();
 		opt = ireq->ipv6_opt;
+		tclass = sock_net(sk)->ipv4.sysctl_tcp_reflect_tos ?
+				tcp_rsk(req)->syn_tos : np->tclass;
 		if (!opt)
 			opt = rcu_dereference(np->opt);
-		err = ip6_xmit(sk, skb, fl6, sk->sk_mark, opt, np->tclass,
+		err = ip6_xmit(sk, skb, fl6, sk->sk_mark, opt,
+			       tclass & ~INET_ECN_MASK,
 			       sk->sk_priority);
 		rcu_read_unlock();
 		err = net_xmit_eval(err);
@@ -1310,6 +1314,10 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	if (np->repflow)
 		newnp->flow_label = ip6_flowlabel(ipv6_hdr(skb));
 
+	/* Set ToS of the new socket based upon the value of incoming SYN. */
+	if (sock_net(sk)->ipv4.sysctl_tcp_reflect_tos)
+		newnp->tclass = tcp_rsk(req)->syn_tos & ~INET_ECN_MASK;
+
 	/* Clone native IPv6 options from listening socket (if any)
 
 	   Yes, keeping reference count would be much more clever,
-- 
2.28.0.618.gf4bc123cb7-goog

