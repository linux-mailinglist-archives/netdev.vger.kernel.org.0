Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7791466884
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 17:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359573AbhLBQol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 11:44:41 -0500
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:58294 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1359565AbhLBQog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 11:44:36 -0500
Received: from sas1-3cba3404b018.qloud-c.yandex.net (sas1-3cba3404b018.qloud-c.yandex.net [IPv6:2a02:6b8:c08:bd26:0:640:3cba:3404])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 3D0132E0AE9;
        Thu,  2 Dec 2021 19:41:08 +0300 (MSK)
Received: from sas1-9d43635d01d6.qloud-c.yandex.net (sas1-9d43635d01d6.qloud-c.yandex.net [2a02:6b8:c08:793:0:640:9d43:635d])
        by sas1-3cba3404b018.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id Dh7S2BMSZT-f6LaCeUE;
        Thu, 02 Dec 2021 19:41:08 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1638463268; bh=88o6gEeTC9zrk7AMklPuyg0YL7GeLj3CNRB27zUdBEw=;
        h=References:Date:Subject:To:From:Message-Id:In-Reply-To:Cc;
        b=P/jJ5MSc9jlONPpVw6+U5Ymh1//PlaU6Q9HS9DMJJ6RkXplygJstqsW4Gfa2FycmW
         MVcFwD/u/WP0IlpI3RZsZQI5OdjJ8zSnP1RMAAorblfULizbu782t9eQ99j7xIRhEJ
         RNtclRXCIok1gnJDghYvnrLK8r5YdsgtWchqw58s=
Authentication-Results: sas1-3cba3404b018.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (vmhmukos.sas.yp-c.yandex.net [2a02:6b8:c07:895:0:696:abd4:0])
        by sas1-9d43635d01d6.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id gTxR2E9Wq2-f6Pi3w3E;
        Thu, 02 Dec 2021 19:41:06 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     edumazet@google.com
Cc:     eric.dumazet@gmail.com, mitradir@yandex-team.ru,
        netdev@vger.kernel.org, tom@herbertland.com, zeil@yandex-team.ru,
        hmukos@yandex-team.ru
Subject: [RFC PATCH v2 net-next 4/4] tcp: change SYN ACK retransmit behaviour to account for rehash
Date:   Thu,  2 Dec 2021 19:40:31 +0300
Message-Id: <20211202164031.18134-5-hmukos@yandex-team.ru>
In-Reply-To: <20211202164031.18134-1-hmukos@yandex-team.ru>
References: <5c7100d2-8327-1e5d-d04b-3db1bb86227a@gmail.com>
 <20211202164031.18134-1-hmukos@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disabling rehash behavior did not affect SYN ACK retransmits because hash
was forcefully changed bypassing the sk_rethink_hash function. This patch
adds a condition which checks for rehash mode before resetting hash.

Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
---
 net/ipv4/tcp_output.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6d72f3ea48c4..7d54bbe00cde 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4108,7 +4108,8 @@ int tcp_rtx_synack(const struct sock *sk, struct request_sock *req)
 	struct flowi fl;
 	int res;
 
-	tcp_rsk(req)->txhash = net_tx_rndhash();
+	if (sk->sk_txrehash == SOCK_TXREHASH_ENABLED)
+		tcp_rsk(req)->txhash = net_tx_rndhash();
 	res = af_ops->send_synack(sk, NULL, &fl, req, NULL, TCP_SYNACK_NORMAL,
 				  NULL);
 	if (!res) {
-- 
2.17.1

