Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6279F1EB878
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 11:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgFBJ1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 05:27:11 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:53608 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726420AbgFBJ1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 05:27:09 -0400
Received: from mxbackcorp1o.mail.yandex.net (mxbackcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::301])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id AD08A2E14BC;
        Tue,  2 Jun 2020 12:27:01 +0300 (MSK)
Received: from iva8-88b7aa9dc799.qloud-c.yandex.net (iva8-88b7aa9dc799.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:88b7:aa9d])
        by mxbackcorp1o.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id edDYk8em9E-QvxK1c7p;
        Tue, 02 Jun 2020 12:27:01 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1591090021; bh=0G5nloM8KgXqobAqOq2gJFUTn/Fn9VU2NJE26BprJps=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=bCumFq7AMfrQ0NTTcAVUzCHbls5s5Jiuv9S9jxn/+WsAcZMAbfcWhdXs0PXSgZeyh
         hYpBP+YzrVh3XuS2cnYhONuHYrS9/B66mr2jti2d0GJSLnnRhJb2lxwtEN7epjnOID
         JIy7d2EarhNf7TXZVZBuRA+SK7j9aQeKYOgJ4SBI=
Authentication-Results: mxbackcorp1o.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from unknown (unknown [178.154.185.106])
        by iva8-88b7aa9dc799.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id FNNM5B9k9b-QvWS7PsO;
        Tue, 02 Jun 2020 12:26:57 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     alexei.starovoitov@gmail.com
Cc:     davem@davemloft.net, brakmo@fb.com, eric.dumazet@gmail.com,
        kafai@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 1/3] sock: move sock_valbool_flag to header
Date:   Tue,  2 Jun 2020 12:26:46 +0300
Message-Id: <20200602092648.50440-1-zeil@yandex-team.ru>
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

