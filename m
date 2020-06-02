Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9205A1EB874
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 11:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgFBJ1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 05:27:07 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:55948 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725958AbgFBJ1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 05:27:06 -0400
Received: from mxbackcorp1j.mail.yandex.net (mxbackcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::162])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id A55642E1529;
        Tue,  2 Jun 2020 12:27:03 +0300 (MSK)
Received: from iva8-88b7aa9dc799.qloud-c.yandex.net (iva8-88b7aa9dc799.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:88b7:aa9d])
        by mxbackcorp1j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id 7zQnJ9hQL9-R1e8iWCi;
        Tue, 02 Jun 2020 12:27:03 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1591090023; bh=PdsA0YfsO1ixoQS9PdSxMDa8RlAAn76WmabTi126AO4=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=zcsQMm5W8+f/Fz9EiAka+h5lI0qTRzzjQ0/QHrxKkfXlRg6CK3o2ZT8+BrM68Ifhy
         2T67XP15ZEKY7amfRNREisqeX0kBu11qwlAO4/ekDOqq8Bw7SMCvacC1x61iHe/JwI
         o2HAZijyinEQ3ohr+jrtxnwLjum2zpeDUGn9yPcs=
Authentication-Results: mxbackcorp1j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from unknown (unknown [178.154.185.106])
        by iva8-88b7aa9dc799.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id FNNM5B9k9b-R1WSuetn;
        Tue, 02 Jun 2020 12:27:01 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     alexei.starovoitov@gmail.com
Cc:     davem@davemloft.net, brakmo@fb.com, eric.dumazet@gmail.com,
        kafai@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 2/3] tcp: expose tcp_sock_set_keepidle_locked
Date:   Tue,  2 Jun 2020 12:26:47 +0300
Message-Id: <20200602092648.50440-2-zeil@yandex-team.ru>
In-Reply-To: <20200602092648.50440-1-zeil@yandex-team.ru>
References: <20200602092648.50440-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is preparation for usage in bpf_setsockopt.

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
---
 include/linux/tcp.h | 1 +
 net/ipv4/tcp.c      | 7 ++++---
 2 files changed, 5 insertions(+), 3 deletions(-)

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
index 15d47d5..0e29760 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2901,7 +2901,7 @@ void tcp_sock_set_user_timeout(struct sock *sk, u32 val)
 }
 EXPORT_SYMBOL(tcp_sock_set_user_timeout);
 
-static int __tcp_sock_set_keepidle(struct sock *sk, int val)
+int tcp_sock_set_keepidle_locked(struct sock *sk, int val)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
@@ -2922,13 +2922,14 @@ static int __tcp_sock_set_keepidle(struct sock *sk, int val)
 
 	return 0;
 }
+EXPORT_SYMBOL(tcp_sock_set_keepidle_locked);
 
 int tcp_sock_set_keepidle(struct sock *sk, int val)
 {
 	int err;
 
 	lock_sock(sk);
-	err = __tcp_sock_set_keepidle(sk, val);
+	err = tcp_sock_set_keepidle_locked(sk, val);
 	release_sock(sk);
 	return err;
 }
@@ -3127,7 +3128,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		break;
 
 	case TCP_KEEPIDLE:
-		err = __tcp_sock_set_keepidle(sk, val);
+		err = tcp_sock_set_keepidle_locked(sk, val);
 		break;
 	case TCP_KEEPINTVL:
 		if (val < 1 || val > MAX_TCP_KEEPINTVL)
-- 
2.7.4

