Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E512024C9
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 17:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgFTPbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 11:31:18 -0400
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:54468 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726898AbgFTPbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 11:31:17 -0400
Received: from mxbackcorp1j.mail.yandex.net (mxbackcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::162])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 59AB82E1899;
        Sat, 20 Jun 2020 18:31:14 +0300 (MSK)
Received: from vla5-58875c36c028.qloud-c.yandex.net (vla5-58875c36c028.qloud-c.yandex.net [2a02:6b8:c18:340b:0:640:5887:5c36])
        by mxbackcorp1j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id UtDOhsYaCW-VCi4bqLb;
        Sat, 20 Jun 2020 18:31:14 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1592667074; bh=C3XcTqwUdOD+EQVTcItnwrEMwBtLg6gsJjEyIji5kcY=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=ma1K8XfV66TvovnYfdWsRfgr8+8heDf74IseIFPkXPqWZ4K0d4X5tfwoCch9PDTbT
         3bRK2Z+QBTu9etIJzGIud8c1niojT8QbFifTIzzJqpTERtnisx3veOs7/gViW9VXxK
         JjEfpk4hoirM9UMcE4h51fahzUqf4u3cX9QAv55E=
Authentication-Results: mxbackcorp1j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 178.154.161.3-vpn.dhcp.yndx.net (178.154.161.3-vpn.dhcp.yndx.net [178.154.161.3])
        by vla5-58875c36c028.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 92kUged0fz-VCkK1bO4;
        Sat, 20 Jun 2020 18:31:12 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     daniel@iogearbox.net, alexei.starovoitov@gmail.com
Cc:     davem@davemloft.net, brakmo@fb.com, eric.dumazet@gmail.com,
        kafai@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v5 2/3] tcp: expose tcp_sock_set_keepidle_locked
Date:   Sat, 20 Jun 2020 18:30:51 +0300
Message-Id: <20200620153052.9439-2-zeil@yandex-team.ru>
In-Reply-To: <20200620153052.9439-1-zeil@yandex-team.ru>
References: <20200620153052.9439-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is preparation for usage in bpf_setsockopt.

v2:
  - remove redundant EXPORT_SYMBOL (Alexei Starovoitov)

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
---
 include/linux/tcp.h | 1 +
 net/ipv4/tcp.c      | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 9aac824..3bdec31 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -499,6 +499,7 @@ int tcp_skb_shift(struct sk_buff *to, struct sk_buff *from, int pcount,
 
 void tcp_sock_set_cork(struct sock *sk, bool on);
 int tcp_sock_set_keepcnt(struct sock *sk, int val);
+int tcp_sock_set_keepidle_locked(struct sock *sk, int val);
 int tcp_sock_set_keepidle(struct sock *sk, int val);
 int tcp_sock_set_keepintvl(struct sock *sk, int val);
 void tcp_sock_set_nodelay(struct sock *sk);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 810cc16..de36c91 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2957,7 +2957,7 @@ void tcp_sock_set_user_timeout(struct sock *sk, u32 val)
 }
 EXPORT_SYMBOL(tcp_sock_set_user_timeout);
 
-static int __tcp_sock_set_keepidle(struct sock *sk, int val)
+int tcp_sock_set_keepidle_locked(struct sock *sk, int val)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
@@ -2984,7 +2984,7 @@ int tcp_sock_set_keepidle(struct sock *sk, int val)
 	int err;
 
 	lock_sock(sk);
-	err = __tcp_sock_set_keepidle(sk, val);
+	err = tcp_sock_set_keepidle_locked(sk, val);
 	release_sock(sk);
 	return err;
 }
@@ -3183,7 +3183,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		break;
 
 	case TCP_KEEPIDLE:
-		err = __tcp_sock_set_keepidle(sk, val);
+		err = tcp_sock_set_keepidle_locked(sk, val);
 		break;
 	case TCP_KEEPINTVL:
 		if (val < 1 || val > MAX_TCP_KEEPINTVL)
-- 
2.7.4

