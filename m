Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FAC1FCBA6
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 13:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgFQLCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 07:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgFQLCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 07:02:45 -0400
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261C8C061573;
        Wed, 17 Jun 2020 04:02:45 -0700 (PDT)
Received: from mxbackcorp1j.mail.yandex.net (mxbackcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::162])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 76F032E1502;
        Wed, 17 Jun 2020 14:02:42 +0300 (MSK)
Received: from iva8-88b7aa9dc799.qloud-c.yandex.net (iva8-88b7aa9dc799.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:88b7:aa9d])
        by mxbackcorp1j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id 9Elz8S6ekL-2eiKrrLa;
        Wed, 17 Jun 2020 14:02:42 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1592391762; bh=xOQuytZWSwa238kUfui+ZoHaMS42DfZq5NAfzHI2Y34=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=o/p1aAfwEN2qyx2VDik1U2/qPxtcErEdwliEJ/8KW0CT7DzFqEfsdGfAv2WUK1RN/
         bYxAlYB10TYvnLsN88cnEVD4Ld0p+sL58ltu65Va5W1QqYXTlhG8XW1wMbBvayzIXf
         98qbo4zKPn57SjI7OV2EaKfLtCs8xlk9EalBd6eA=
Authentication-Results: mxbackcorp1j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 37.9.89.23-iva.dhcp.yndx.net (37.9.89.23-iva.dhcp.yndx.net [37.9.89.23])
        by iva8-88b7aa9dc799.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id XJqgFOjlJF-2ekiGnvr;
        Wed, 17 Jun 2020 14:02:40 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     daniel@iogearbox.net, alexei.starovoitov@gmail.com
Cc:     davem@davemloft.net, brakmo@fb.com, eric.dumazet@gmail.com,
        kafai@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 2/3] tcp: expose tcp_sock_set_keepidle_locked
Date:   Wed, 17 Jun 2020 14:02:16 +0300
Message-Id: <20200617110217.35669-2-zeil@yandex-team.ru>
In-Reply-To: <20200617110217.35669-1-zeil@yandex-team.ru>
References: <20200617110217.35669-1-zeil@yandex-team.ru>
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

