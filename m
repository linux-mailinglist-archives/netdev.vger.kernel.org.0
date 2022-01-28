Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E3D49FCA6
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245109AbiA1PRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241916AbiA1PRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:17:06 -0500
Received: from forwardcorp1j.mail.yandex.net (forwardcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BDEC061748;
        Fri, 28 Jan 2022 07:17:05 -0800 (PST)
Received: from sas1-3cba3404b018.qloud-c.yandex.net (sas1-3cba3404b018.qloud-c.yandex.net [IPv6:2a02:6b8:c08:bd26:0:640:3cba:3404])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id D60292E1A69;
        Fri, 28 Jan 2022 18:17:01 +0300 (MSK)
Received: from sas1-9d43635d01d6.qloud-c.yandex.net (sas1-9d43635d01d6.qloud-c.yandex.net [2a02:6b8:c08:793:0:640:9d43:635d])
        by sas1-3cba3404b018.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id ljOzTYQ8O7-H0HOhus1;
        Fri, 28 Jan 2022 18:17:01 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1643383021; bh=FWQQJ1CS8kN3BNfiGBdo3evVK+EsZWzjUX2G+F6vTOs=;
        h=References:Date:Subject:To:From:Message-Id:In-Reply-To:Cc;
        b=A2fjl6Stc9V31TPs+YsC9WlctDxMBybwFW9yd2QXUI50vT40P49qpIrxDgzWA3FY5
         dx1o8cAv6Sgpqr2eruUfb5H8J5izu9A+Jjb7UH+rxbNMJtXQvoIKR6majuZ1fn056T
         FnJia2B8aBK/+OshYg/mJQaos+OYuqpcEdkT1bL8=
Authentication-Results: sas1-3cba3404b018.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (vmhmukos.sas.yp-c.yandex.net [2a02:6b8:c10:288:0:696:6af:0])
        by sas1-9d43635d01d6.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id IrjHL3bpzz-H0IO9rR8;
        Fri, 28 Jan 2022 18:17:00 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        eric.dumazet@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, tom@herbertland.com,
        hmukos@yandex-team.ru, zeil@yandex-team.ru, mitradir@yandex-team.ru
Subject: [PATCH net-next v3 4/4] tcp: change SYN ACK retransmit behaviour to account for rehash
Date:   Fri, 28 Jan 2022 18:16:02 +0300
Message-Id: <20220128151602.2748-5-hmukos@yandex-team.ru>
In-Reply-To: <20220128151602.2748-1-hmukos@yandex-team.ru>
References: <20220128151602.2748-1-hmukos@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disabling rehash behavior did not affect SYN ACK retransmits because hash
was forcefully changed bypassing the sk_rethink_hash function. This patch
adds a condition which checks for rehash mode before resetting hash.

Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/core/sock.c       | 3 ++-
 net/ipv4/tcp_output.c | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index daace0d10156..f2515f657974 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1372,7 +1372,8 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 			ret = -EINVAL;
 			break;
 		}
-		sk->sk_txrehash = (u8)val;
+		/* Paired with READ_ONCE() in tcp_rtx_synack() */
+		WRITE_ONCE(sk->sk_txrehash, (u8)val);
 		break;
 
 	default:
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6d72f3ea48c4..bbb5f68b947a 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4108,7 +4108,9 @@ int tcp_rtx_synack(const struct sock *sk, struct request_sock *req)
 	struct flowi fl;
 	int res;
 
-	tcp_rsk(req)->txhash = net_tx_rndhash();
+	/* Paired with WRITE_ONCE() in sock_setsockopt() */
+	if (READ_ONCE(sk->sk_txrehash) == SOCK_TXREHASH_ENABLED)
+		tcp_rsk(req)->txhash = net_tx_rndhash();
 	res = af_ops->send_synack(sk, NULL, &fl, req, NULL, TCP_SYNACK_NORMAL,
 				  NULL);
 	if (!res) {
-- 
2.17.1

