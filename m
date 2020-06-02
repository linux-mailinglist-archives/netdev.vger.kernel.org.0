Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E451EC323
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 21:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbgFBTwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 15:52:01 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:41810 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728589AbgFBTv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 15:51:57 -0400
Received: from mxbackcorp1g.mail.yandex.net (mxbackcorp1g.mail.yandex.net [IPv6:2a02:6b8:0:1402::301])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 851B92E14B9;
        Tue,  2 Jun 2020 22:51:55 +0300 (MSK)
Received: from vla1-81430ab5870b.qloud-c.yandex.net (vla1-81430ab5870b.qloud-c.yandex.net [2a02:6b8:c0d:35a1:0:640:8143:ab5])
        by mxbackcorp1g.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id DHuFiuagta-prIaBLlC;
        Tue, 02 Jun 2020 22:51:55 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1591127515; bh=0G5nloM8KgXqobAqOq2gJFUTn/Fn9VU2NJE26BprJps=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=KDpx1wCTasLG3BEtNVSnOg6K/zUv16A9JT50EP8/EHa3YmQFJeUoMRT1l5pF4XWk4
         8RC3KZkC+1iqjHgV6RPzKxHTQhI9kxdRlb3A4weGP98ar68kA3jl4ybk5uuro0pp9g
         i7I2WKXEH1pNQi8Kjt5fUd6x5UXA+9zExjaJs2JU=
Authentication-Results: mxbackcorp1g.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 178.154.178.227-vpn.dhcp.yndx.net (178.154.178.227-vpn.dhcp.yndx.net [178.154.178.227])
        by vla1-81430ab5870b.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 8r0TlSmqCc-prW8GFt5;
        Tue, 02 Jun 2020 22:51:53 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     alexei.starovoitov@gmail.com
Cc:     davem@davemloft.net, brakmo@fb.com, eric.dumazet@gmail.com,
        kafai@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 1/3] sock: move sock_valbool_flag to header
Date:   Tue,  2 Jun 2020 22:51:45 +0300
Message-Id: <20200602195147.56912-1-zeil@yandex-team.ru>
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

