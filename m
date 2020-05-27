Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC3E1E46F8
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 17:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389625AbgE0PGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 11:06:12 -0400
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:35010 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389316AbgE0PGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 11:06:12 -0400
Received: from mxbackcorp2j.mail.yandex.net (mxbackcorp2j.mail.yandex.net [IPv6:2a02:6b8:0:1619::119])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id D9B8A2E1501;
        Wed, 27 May 2020 18:06:08 +0300 (MSK)
Received: from iva4-7c3d9abce76c.qloud-c.yandex.net (iva4-7c3d9abce76c.qloud-c.yandex.net [2a02:6b8:c0c:4e8e:0:640:7c3d:9abc])
        by mxbackcorp2j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id BQyCXjc3jy-67fGEFg2;
        Wed, 27 May 2020 18:06:08 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1590591968; bh=H/anpamXE9P/J2FChTs3lIbjRcSqGGJc+HlFYjPwdcE=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=MIQEi8eiCSxXA9S4+9eoo6mn7uusKHoPgmLgGr3RgXnGcyrPA7I61xR7nhz8X5n/a
         pech76ba5T2v+DloRGAboWJnQ4UkDRZsCpuZ2Pra0wPWXgqg1ZZVUBSEWnzO6X8Nci
         vhTafRerqfCz4XgwFvHyMzAFb1BPryAWDbypFy8I=
Authentication-Results: mxbackcorp2j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 93.158.159.82-iva.dhcp.yndx.net (93.158.159.82-iva.dhcp.yndx.net [93.158.159.82])
        by iva4-7c3d9abce76c.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id hTDJSlJkV6-67WmI2iD;
        Wed, 27 May 2020 18:06:07 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     davem@davemloft.net, brakmo@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next] bpf: add SO_KEEPALIVE and related options to bpf_setsockopt
Date:   Wed, 27 May 2020 18:05:43 +0300
Message-Id: <20200527150543.93335-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support of SO_KEEPALIVE flag and TCP related options
to bpf_setsockopt() routine. This is helpful if we want to enable or tune
TCP keepalive for applications which don't do it in the userspace code.
In order to avoid copy-paste, common code from classic setsockopt was moved
to auxiliary functions in the headers.

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
---
 include/net/sock.h |  9 +++++++++
 include/net/tcp.h  | 18 ++++++++++++++++++
 net/core/filter.c  | 39 ++++++++++++++++++++++++++++++++++++++-
 net/core/sock.c    |  9 ---------
 net/ipv4/tcp.c     | 15 ++-------------
 5 files changed, 67 insertions(+), 23 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 3e8c6d4..ee35dea 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -879,6 +879,15 @@ static inline void sock_reset_flag(struct sock *sk, enum sock_flags flag)
 	__clear_bit(flag, &sk->sk_flags);
 }
 
+static inline void sock_valbool_flag(struct sock *sk, enum sock_flags bit,
+				     int valbool)
+{
+	if (valbool)
+		sock_set_flag(sk, bit);
+	else
+		sock_reset_flag(sk, bit);
+}
+
 static inline bool sock_flag(const struct sock *sk, enum sock_flags flag)
 {
 	return test_bit(flag, &sk->sk_flags);
diff --git a/include/net/tcp.h b/include/net/tcp.h
index b681338..ae6a495 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1465,6 +1465,24 @@ static inline u32 keepalive_time_elapsed(const struct tcp_sock *tp)
 			  tcp_jiffies32 - tp->rcv_tstamp);
 }
 
+/* val must be validated at the top level function */
+static inline void keepalive_time_set(struct tcp_sock *tp, int val)
+{
+	struct sock *sk = (struct sock *)tp;
+
+	tp->keepalive_time = val * HZ;
+	if (sock_flag(sk, SOCK_KEEPOPEN) &&
+	    !((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN))) {
+		u32 elapsed = keepalive_time_elapsed(tp);
+
+		if (tp->keepalive_time > elapsed)
+			elapsed = tp->keepalive_time - elapsed;
+		else
+			elapsed = 0;
+		inet_csk_reset_keepalive_timer(sk, elapsed);
+	}
+}
+
 static inline int tcp_fin_time(const struct sock *sk)
 {
 	int fin_timeout = tcp_sk(sk)->linger2 ? : sock_net(sk)->ipv4.sysctl_tcp_fin_timeout;
diff --git a/net/core/filter.c b/net/core/filter.c
index a6fc234..1035e43 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4248,8 +4248,8 @@ static const struct bpf_func_proto bpf_get_socket_uid_proto = {
 static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 			   char *optval, int optlen, u32 flags)
 {
+	int val, valbool;
 	int ret = 0;
-	int val;
 
 	if (!sk_fullsock(sk))
 		return -EINVAL;
@@ -4260,6 +4260,7 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 		if (optlen != sizeof(int))
 			return -EINVAL;
 		val = *((int *)optval);
+		valbool = val ? 1 : 0;
 
 		/* Only some socketops are supported */
 		switch (optname) {
@@ -4298,6 +4299,11 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 				sk_dst_reset(sk);
 			}
 			break;
+		case SO_KEEPALIVE:
+			if (sk->sk_prot->keepalive)
+				sk->sk_prot->keepalive(sk, valbool);
+			sock_valbool_flag(sk, SOCK_KEEPOPEN, valbool);
+			break;
 		default:
 			ret = -EINVAL;
 		}
@@ -4358,6 +4364,7 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 			ret = tcp_set_congestion_control(sk, name, false,
 							 reinit, true);
 		} else {
+			struct inet_connection_sock *icsk = inet_csk(sk);
 			struct tcp_sock *tp = tcp_sk(sk);
 
 			if (optlen != sizeof(int))
@@ -4386,6 +4393,36 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 				else
 					tp->save_syn = val;
 				break;
+			case TCP_KEEPIDLE:
+				if (val < 1 || val > MAX_TCP_KEEPIDLE)
+					ret = -EINVAL;
+				else
+					keepalive_time_set(tp, val);
+				break;
+			case TCP_KEEPINTVL:
+				if (val < 1 || val > MAX_TCP_KEEPINTVL)
+					ret = -EINVAL;
+				else
+					tp->keepalive_intvl = val * HZ;
+				break;
+			case TCP_KEEPCNT:
+				if (val < 1 || val > MAX_TCP_KEEPCNT)
+					ret = -EINVAL;
+				else
+					tp->keepalive_probes = val;
+				break;
+			case TCP_SYNCNT:
+				if (val < 1 || val > MAX_TCP_SYNCNT)
+					ret = -EINVAL;
+				else
+					icsk->icsk_syn_retries = val;
+				break;
+			case TCP_USER_TIMEOUT:
+				if (val < 0)
+					ret = -EINVAL;
+				else
+					icsk->icsk_user_timeout = val;
+				break;
 			default:
 				ret = -EINVAL;
 			}
diff --git a/net/core/sock.c b/net/core/sock.c
index fd85e65..9836b01 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -684,15 +684,6 @@ static int sock_getbindtodevice(struct sock *sk, char __user *optval,
 	return ret;
 }
 
-static inline void sock_valbool_flag(struct sock *sk, enum sock_flags bit,
-				     int valbool)
-{
-	if (valbool)
-		sock_set_flag(sk, bit);
-	else
-		sock_reset_flag(sk, bit);
-}
-
 bool sk_mc_loop(struct sock *sk)
 {
 	if (dev_recursion_level())
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 9700649..7b239e8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3003,19 +3003,8 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 	case TCP_KEEPIDLE:
 		if (val < 1 || val > MAX_TCP_KEEPIDLE)
 			err = -EINVAL;
-		else {
-			tp->keepalive_time = val * HZ;
-			if (sock_flag(sk, SOCK_KEEPOPEN) &&
-			    !((1 << sk->sk_state) &
-			      (TCPF_CLOSE | TCPF_LISTEN))) {
-				u32 elapsed = keepalive_time_elapsed(tp);
-				if (tp->keepalive_time > elapsed)
-					elapsed = tp->keepalive_time - elapsed;
-				else
-					elapsed = 0;
-				inet_csk_reset_keepalive_timer(sk, elapsed);
-			}
-		}
+		else
+			keepalive_time_set(tp, val);
 		break;
 	case TCP_KEEPINTVL:
 		if (val < 1 || val > MAX_TCP_KEEPINTVL)
-- 
2.7.4

