Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F357B46A567
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 20:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347296AbhLFTPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 14:15:19 -0500
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:56370 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348283AbhLFTPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 14:15:17 -0500
Received: from sas1-3cba3404b018.qloud-c.yandex.net (sas1-3cba3404b018.qloud-c.yandex.net [IPv6:2a02:6b8:c08:bd26:0:640:3cba:3404])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id D25132E1F46;
        Mon,  6 Dec 2021 22:11:44 +0300 (MSK)
Received: from sas1-9d43635d01d6.qloud-c.yandex.net (sas1-9d43635d01d6.qloud-c.yandex.net [2a02:6b8:c08:793:0:640:9d43:635d])
        by sas1-3cba3404b018.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id jFhuRBjIFA-BiLmpKfY;
        Mon, 06 Dec 2021 22:11:44 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1638817904; bh=n9Iy/s4c06EaYnrBHxkCEZXzhE/AbXGdk3vSINfPqRc=;
        h=References:Date:Subject:To:From:Message-Id:In-Reply-To:Cc;
        b=bH202TSCX63E28zswiU8VxCoP72XZI95f+cMPpJlHUe1XHFZduKFKPg7uumqgKqUN
         atPTj3VPuu8FHiwH/VC+qZCp+7AFl2hshRdpCq5gRsYmnLwTlOCMzJi1CPJWml5v0b
         5TGiZtsiojODNqj0ibMU9BIf8+b4t+opPsuBEZBg=
Authentication-Results: sas1-3cba3404b018.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (vmhmukos.sas.yp-c.yandex.net [2a02:6b8:c07:895:0:696:abd4:0])
        by sas1-9d43635d01d6.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id U4ua9e2Xs9-BiPOYZQd;
        Mon, 06 Dec 2021 22:11:44 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     hmukos@yandex-team.ru, edumazet@google.com, eric.dumazet@gmail.com,
        mitradir@yandex-team.ru, tom@herbertland.com, zeil@yandex-team.ru
Subject: [RFC PATCH v3 net-next 4/4] tcp: change SYN ACK retransmit behaviour to account for rehash
Date:   Mon,  6 Dec 2021 22:11:11 +0300
Message-Id: <20211206191111.14376-5-hmukos@yandex-team.ru>
In-Reply-To: <20211206191111.14376-1-hmukos@yandex-team.ru>
References: <20211025203521.13507-1-hmukos@yandex-team.ru>
 <20211206191111.14376-1-hmukos@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disabling rehash behavior did not affect SYN ACK retransmits because hash
was forcefully changed bypassing the sk_rethink_hash function. This patch
adds a condition which checks for rehash mode before resetting hash.

Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
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

