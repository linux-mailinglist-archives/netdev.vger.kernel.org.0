Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E921EC325
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 21:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgFBTwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 15:52:04 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:41836 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728604AbgFBTv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 15:51:59 -0400
Received: from mxbackcorp2j.mail.yandex.net (mxbackcorp2j.mail.yandex.net [IPv6:2a02:6b8:0:1619::119])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 5055E2E1503;
        Tue,  2 Jun 2020 22:51:57 +0300 (MSK)
Received: from vla1-81430ab5870b.qloud-c.yandex.net (vla1-81430ab5870b.qloud-c.yandex.net [2a02:6b8:c0d:35a1:0:640:8143:ab5])
        by mxbackcorp2j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id Nx3Ki1DFGw-ptf8jq8s;
        Tue, 02 Jun 2020 22:51:57 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1591127517; bh=xOQuytZWSwa238kUfui+ZoHaMS42DfZq5NAfzHI2Y34=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=WHj/EwWC1RJVre7Fdk7Xyya3rqOujFepgk3sjtjpGqixYOpPd0e16f+UsXBfhjcAj
         7Xr4Itt4OcW9Bwah4tFqa1q7P2BeiqZ9vCG16JvuZDTHTN2Lo3lB2fdrYf7TwUIYJe
         6q5jdeGmfs3qBijj5NFMnO544Qu+sqA6GpiVvoDo=
Authentication-Results: mxbackcorp2j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 178.154.178.227-vpn.dhcp.yndx.net (178.154.178.227-vpn.dhcp.yndx.net [178.154.178.227])
        by vla1-81430ab5870b.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 8r0TlSmqCc-ptW8itjv;
        Tue, 02 Jun 2020 22:51:55 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     alexei.starovoitov@gmail.com
Cc:     davem@davemloft.net, brakmo@fb.com, eric.dumazet@gmail.com,
        kafai@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 2/3] tcp: expose tcp_sock_set_keepidle_locked
Date:   Tue,  2 Jun 2020 22:51:46 +0300
Message-Id: <20200602195147.56912-2-zeil@yandex-team.ru>
In-Reply-To: <20200602195147.56912-1-zeil@yandex-team.ru>
References: <20200602195147.56912-1-zeil@yandex-team.ru>
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
index 15d47d5..18f8d54 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2901,7 +2901,7 @@ void tcp_sock_set_user_timeout(struct sock *sk, u32 val)
 }
 EXPORT_SYMBOL(tcp_sock_set_user_timeout);
 
-static int __tcp_sock_set_keepidle(struct sock *sk, int val)
+int tcp_sock_set_keepidle_locked(struct sock *sk, int val)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
@@ -2928,7 +2928,7 @@ int tcp_sock_set_keepidle(struct sock *sk, int val)
 	int err;
 
 	lock_sock(sk);
-	err = __tcp_sock_set_keepidle(sk, val);
+	err = tcp_sock_set_keepidle_locked(sk, val);
 	release_sock(sk);
 	return err;
 }
@@ -3127,7 +3127,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		break;
 
 	case TCP_KEEPIDLE:
-		err = __tcp_sock_set_keepidle(sk, val);
+		err = tcp_sock_set_keepidle_locked(sk, val);
 		break;
 	case TCP_KEEPINTVL:
 		if (val < 1 || val > MAX_TCP_KEEPINTVL)
-- 
2.7.4

