Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646DA2024CB
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 17:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgFTPbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 11:31:22 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:33108 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725777AbgFTPbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 11:31:20 -0400
Received: from mxbackcorp1j.mail.yandex.net (mxbackcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::162])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id C9A622E14A5;
        Sat, 20 Jun 2020 18:31:15 +0300 (MSK)
Received: from vla5-58875c36c028.qloud-c.yandex.net (vla5-58875c36c028.qloud-c.yandex.net [2a02:6b8:c18:340b:0:640:5887:5c36])
        by mxbackcorp1j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id wNKa81Et9K-VEiqWprM;
        Sat, 20 Jun 2020 18:31:15 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1592667075; bh=sSp3Cjh5xIiN4Wl8lDKmCKq565XnwoV+CUq1oZCzkTw=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=h8ib4eP76R62SC6gc7t8/zyPrsM797mv0Axu/qmABOWADwJ0JEJssySLU4uSuHcxt
         cA3mQnqpk2VG+RHnki/ruml/54PX+JgsTIWgd80J2Cmx/Yq5qapRDjLQ5pGcIwFP83
         j+vSbUEI9j+egQutYEIqMUQlsClLcnT8DIq6+PmE=
Authentication-Results: mxbackcorp1j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 178.154.161.3-vpn.dhcp.yndx.net (178.154.161.3-vpn.dhcp.yndx.net [178.154.161.3])
        by vla5-58875c36c028.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 92kUged0fz-VEkKU89s;
        Sat, 20 Jun 2020 18:31:14 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     daniel@iogearbox.net, alexei.starovoitov@gmail.com
Cc:     davem@davemloft.net, brakmo@fb.com, eric.dumazet@gmail.com,
        kafai@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v5 3/3] bpf: add SO_KEEPALIVE and related options to bpf_setsockopt
Date:   Sat, 20 Jun 2020 18:30:52 +0300
Message-Id: <20200620153052.9439-3-zeil@yandex-team.ru>
In-Reply-To: <20200620153052.9439-1-zeil@yandex-team.ru>
References: <20200620153052.9439-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support of SO_KEEPALIVE flag and TCP related options
to bpf_setsockopt() routine. This is helpful if we want to enable or tune
TCP keepalive for applications which don't do it in the userspace code.

v3:
  - update kernel-doc in uapi (Nikita Vetoshkin <nekto0n@yandex-team.ru>)

v4:
  - update kernel-doc in tools too (Alexei Starovoitov)
  - add test to selftests (Alexei Starovoitov)

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 include/uapi/linux/bpf.h                          |  7 +++--
 net/core/filter.c                                 | 36 ++++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h                    |  7 +++--
 tools/testing/selftests/bpf/progs/connect4_prog.c | 27 +++++++++++++++++
 4 files changed, 72 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 1968481..1df0df1 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1621,10 +1621,13 @@ union bpf_attr {
  *
  * 		* **SOL_SOCKET**, which supports the following *optname*\ s:
  * 		  **SO_RCVBUF**, **SO_SNDBUF**, **SO_MAX_PACING_RATE**,
- * 		  **SO_PRIORITY**, **SO_RCVLOWAT**, **SO_MARK**.
+ * 		  **SO_PRIORITY**, **SO_RCVLOWAT**, **SO_MARK**,
+ * 		  **SO_BINDTODEVICE**, **SO_KEEPALIVE**.
  * 		* **IPPROTO_TCP**, which supports the following *optname*\ s:
  * 		  **TCP_CONGESTION**, **TCP_BPF_IW**,
- * 		  **TCP_BPF_SNDCWND_CLAMP**.
+ * 		  **TCP_BPF_SNDCWND_CLAMP**, **TCP_SAVE_SYN**,
+ * 		  **TCP_KEEPIDLE**, **TCP_KEEPINTVL**, **TCP_KEEPCNT**,
+ * 		  **TCP_SYNCNT**, **TCP_USER_TIMEOUT**.
  * 		* **IPPROTO_IP**, which supports *optname* **IP_TOS**.
  * 		* **IPPROTO_IPV6**, which supports *optname* **IPV6_TCLASS**.
  * 	Return
diff --git a/net/core/filter.c b/net/core/filter.c
index 7339538..c713b6b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4289,10 +4289,10 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 			   char *optval, int optlen, u32 flags)
 {
 	char devname[IFNAMSIZ];
+	int val, valbool;
 	struct net *net;
 	int ifindex;
 	int ret = 0;
-	int val;
 
 	if (!sk_fullsock(sk))
 		return -EINVAL;
@@ -4303,6 +4303,7 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 		if (optlen != sizeof(int) && optname != SO_BINDTODEVICE)
 			return -EINVAL;
 		val = *((int *)optval);
+		valbool = val ? 1 : 0;
 
 		/* Only some socketops are supported */
 		switch (optname) {
@@ -4361,6 +4362,11 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 			}
 			ret = sock_bindtoindex(sk, ifindex, false);
 			break;
+		case SO_KEEPALIVE:
+			if (sk->sk_prot->keepalive)
+				sk->sk_prot->keepalive(sk, valbool);
+			sock_valbool_flag(sk, SOCK_KEEPOPEN, valbool);
+			break;
 		default:
 			ret = -EINVAL;
 		}
@@ -4421,6 +4427,7 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 			ret = tcp_set_congestion_control(sk, name, false,
 							 reinit, true);
 		} else {
+			struct inet_connection_sock *icsk = inet_csk(sk);
 			struct tcp_sock *tp = tcp_sk(sk);
 
 			if (optlen != sizeof(int))
@@ -4449,6 +4456,33 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 				else
 					tp->save_syn = val;
 				break;
+			case TCP_KEEPIDLE:
+				ret = tcp_sock_set_keepidle_locked(sk, val);
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
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 1968481..1df0df1 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1621,10 +1621,13 @@ union bpf_attr {
  *
  * 		* **SOL_SOCKET**, which supports the following *optname*\ s:
  * 		  **SO_RCVBUF**, **SO_SNDBUF**, **SO_MAX_PACING_RATE**,
- * 		  **SO_PRIORITY**, **SO_RCVLOWAT**, **SO_MARK**.
+ * 		  **SO_PRIORITY**, **SO_RCVLOWAT**, **SO_MARK**,
+ * 		  **SO_BINDTODEVICE**, **SO_KEEPALIVE**.
  * 		* **IPPROTO_TCP**, which supports the following *optname*\ s:
  * 		  **TCP_CONGESTION**, **TCP_BPF_IW**,
- * 		  **TCP_BPF_SNDCWND_CLAMP**.
+ * 		  **TCP_BPF_SNDCWND_CLAMP**, **TCP_SAVE_SYN**,
+ * 		  **TCP_KEEPIDLE**, **TCP_KEEPINTVL**, **TCP_KEEPCNT**,
+ * 		  **TCP_SYNCNT**, **TCP_USER_TIMEOUT**.
  * 		* **IPPROTO_IP**, which supports *optname* **IP_TOS**.
  * 		* **IPPROTO_IPV6**, which supports *optname* **IPV6_TCLASS**.
  * 	Return
diff --git a/tools/testing/selftests/bpf/progs/connect4_prog.c b/tools/testing/selftests/bpf/progs/connect4_prog.c
index 1ab2c5e..b1b2773 100644
--- a/tools/testing/selftests/bpf/progs/connect4_prog.c
+++ b/tools/testing/selftests/bpf/progs/connect4_prog.c
@@ -104,6 +104,30 @@ static __inline int bind_to_device(struct bpf_sock_addr *ctx)
 	return 0;
 }
 
+static __inline int set_keepalive(struct bpf_sock_addr *ctx)
+{
+	int zero = 0, one = 1;
+
+	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_KEEPALIVE, &one, sizeof(one)))
+		return 1;
+	if (ctx->type == SOCK_STREAM) {
+		if (bpf_setsockopt(ctx, SOL_TCP, TCP_KEEPIDLE, &one, sizeof(one)))
+			return 1;
+		if (bpf_setsockopt(ctx, SOL_TCP, TCP_KEEPINTVL, &one, sizeof(one)))
+			return 1;
+		if (bpf_setsockopt(ctx, SOL_TCP, TCP_KEEPCNT, &one, sizeof(one)))
+			return 1;
+		if (bpf_setsockopt(ctx, SOL_TCP, TCP_SYNCNT, &one, sizeof(one)))
+			return 1;
+		if (bpf_setsockopt(ctx, SOL_TCP, TCP_USER_TIMEOUT, &one, sizeof(one)))
+			return 1;
+	}
+	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_KEEPALIVE, &zero, sizeof(zero)))
+		return 1;
+
+	return 0;
+}
+
 SEC("cgroup/connect4")
 int connect_v4_prog(struct bpf_sock_addr *ctx)
 {
@@ -121,6 +145,9 @@ int connect_v4_prog(struct bpf_sock_addr *ctx)
 	if (bind_to_device(ctx))
 		return 0;
 
+	if (set_keepalive(ctx))
+		return 0;
+
 	if (ctx->type != SOCK_STREAM && ctx->type != SOCK_DGRAM)
 		return 0;
 	else if (ctx->type == SOCK_STREAM)
-- 
2.7.4

