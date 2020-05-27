Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBB01E4EB9
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 21:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgE0T7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 15:59:55 -0400
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:36742 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727899AbgE0T7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 15:59:55 -0400
Received: from mxbackcorp1o.mail.yandex.net (mxbackcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::301])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id C94482E160A;
        Wed, 27 May 2020 22:59:48 +0300 (MSK)
Received: from vla1-81430ab5870b.qloud-c.yandex.net (vla1-81430ab5870b.qloud-c.yandex.net [2a02:6b8:c0d:35a1:0:640:8143:ab5])
        by mxbackcorp1o.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id 8zBMmgWx7e-xlxiwS7W;
        Wed, 27 May 2020 22:59:48 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1590609588; bh=vswpYIAeafOD5Bl+nSAB5l/t4CyzZVWmy3ZSF+immXc=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=m1PQ97eYgMXED5X/xp2bI0LnchRxSFgGunjzrBpBek3zgdLCG1A1RUjfYlSk9rOpp
         tSg1MD76e9Q4+ZSLEj3RMYkNG5Innoyj4V9NiWBRMEeAY3p5lSBhTzwnF4+xJFDYJQ
         9/+cAjoPxZLlrBIE/ul1zVZF6GZNKHdFMc6qqHFE=
Authentication-Results: mxbackcorp1o.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 178.154.179.134-vpn.dhcp.yndx.net (178.154.179.134-vpn.dhcp.yndx.net [178.154.179.134])
        by vla1-81430ab5870b.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id p1CLlcPIkt-xlW0FhCf;
        Wed, 27 May 2020 22:59:47 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     davem@davemloft.net, brakmo@fb.com, eric.dumazet@gmail.com
Cc:     kafai@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 1/3] sock: move sock_valbool_flag to header
Date:   Wed, 27 May 2020 22:58:47 +0300
Message-Id: <20200527195849.97118-1-zeil@yandex-team.ru>
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
-- 
2.7.4

