Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C290B2024C7
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 17:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgFTPbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 11:31:16 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:52122 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725777AbgFTPbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 11:31:15 -0400
Received: from mxbackcorp1o.mail.yandex.net (mxbackcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::301])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 9394F2E14E1;
        Sat, 20 Jun 2020 18:31:12 +0300 (MSK)
Received: from vla5-58875c36c028.qloud-c.yandex.net (vla5-58875c36c028.qloud-c.yandex.net [2a02:6b8:c18:340b:0:640:5887:5c36])
        by mxbackcorp1o.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id 0AJBSJFPSk-VAa8WKXp;
        Sat, 20 Jun 2020 18:31:12 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1592667072; bh=0G5nloM8KgXqobAqOq2gJFUTn/Fn9VU2NJE26BprJps=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=ElB2ru/OGEjPvvauZjLdMGwJVXmPUcGoNEtfais56uaYoA5h1qfIJ/6mnSUyR8/tk
         uTnQ13dLHooQHGXhcfS6sUWXQs3POl6fTAucI8q9F12mXCzCErwokCneWV1qV/xnHR
         r9UeckodP4NYG7mmDxlZdEumOdCtA9NYSAcll7cg=
Authentication-Results: mxbackcorp1o.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 178.154.161.3-vpn.dhcp.yndx.net (178.154.161.3-vpn.dhcp.yndx.net [178.154.161.3])
        by vla5-58875c36c028.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 92kUged0fz-VAkKVMYc;
        Sat, 20 Jun 2020 18:31:10 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     daniel@iogearbox.net, alexei.starovoitov@gmail.com
Cc:     davem@davemloft.net, brakmo@fb.com, eric.dumazet@gmail.com,
        kafai@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v5 1/3] sock: move sock_valbool_flag to header
Date:   Sat, 20 Jun 2020 18:30:50 +0300
Message-Id: <20200620153052.9439-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is preparation for usage in bpf_setsockopt.

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 include/net/sock.h | 9 +++++++++
 net/core/sock.c    | 9 ---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index c53cc42..8ba438b 100644
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
diff --git a/net/core/sock.c b/net/core/sock.c
index 6c4acf1..5ba4753 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -695,15 +695,6 @@ static int sock_getbindtodevice(struct sock *sk, char __user *optval,
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
-- 
2.7.4

