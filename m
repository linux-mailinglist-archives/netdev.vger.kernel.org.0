Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39341E4EBC
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 22:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgE0UAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 16:00:05 -0400
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:36850 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727899AbgE0UAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 16:00:05 -0400
Received: from mxbackcorp1g.mail.yandex.net (mxbackcorp1g.mail.yandex.net [IPv6:2a02:6b8:0:1402::301])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 463012E160F;
        Wed, 27 May 2020 23:00:01 +0300 (MSK)
Received: from vla1-81430ab5870b.qloud-c.yandex.net (vla1-81430ab5870b.qloud-c.yandex.net [2a02:6b8:c0d:35a1:0:640:8143:ab5])
        by mxbackcorp1g.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id jiAA3dK2Ec-xxIOtfoJ;
        Wed, 27 May 2020 23:00:01 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1590609601; bh=TUULmxhaPYEc/15iBitUpC7t6Y0hGig3KgIzpnllxGc=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=iJd4eHX+iM5wAJzbNUpr1tjCpl5IYiPs+MMFbXJye404RXKb42T6ZB677egDaeVTe
         3QI5CuiOHk+M2BSX+MXvrcf6/coK9XLIJRkol9OfB4X5sEPOpvnZUdPTCsX4lqS4jA
         OanD1e8q+MLYHgP4szceRPM87HHwBN6Mis5DNF+c=
Authentication-Results: mxbackcorp1g.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 178.154.179.134-vpn.dhcp.yndx.net (178.154.179.134-vpn.dhcp.yndx.net [178.154.179.134])
        by vla1-81430ab5870b.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id p1CLlcPIkt-xxW0HvAO;
        Wed, 27 May 2020 22:59:59 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     davem@davemloft.net, brakmo@fb.com, eric.dumazet@gmail.com
Cc:     kafai@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 2/3] tcp: add keepalive_time_set helper
Date:   Wed, 27 May 2020 22:58:48 +0300
Message-Id: <20200527195849.97118-2-zeil@yandex-team.ru>
In-Reply-To: <20200527195849.97118-1-zeil@yandex-team.ru>
References: <20200527195849.97118-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is preparation for usage in bpf_setsockopt.

v2:
  - change first parameter type to struct sock (Eric Dumazet)

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 include/net/tcp.h | 18 ++++++++++++++++++
 net/ipv4/tcp.c    | 15 ++-------------
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index b681338..e0a815f 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1465,6 +1465,24 @@ static inline u32 keepalive_time_elapsed(const struct tcp_sock *tp)
 			  tcp_jiffies32 - tp->rcv_tstamp);
 }
 
+/* val must be validated at the top level function */
+static inline void keepalive_time_set(struct sock *sk, int val)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
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
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 9700649..a366ab7 100644
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
+			keepalive_time_set(sk, val);
 		break;
 	case TCP_KEEPINTVL:
 		if (val < 1 || val > MAX_TCP_KEEPINTVL)
-- 
2.7.4

