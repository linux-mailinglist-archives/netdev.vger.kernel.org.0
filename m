Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06DF644EC8B
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 19:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235580AbhKLSXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 13:23:01 -0500
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:50100 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235570AbhKLSWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 13:22:50 -0500
Received: from sas1-4cbebe29391b.qloud-c.yandex.net (sas1-4cbebe29391b.qloud-c.yandex.net [IPv6:2a02:6b8:c08:789:0:640:4cbe:be29])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id A60242E102F;
        Fri, 12 Nov 2021 21:19:56 +0300 (MSK)
Received: from sas1-7470331623bb.qloud-c.yandex.net (sas1-7470331623bb.qloud-c.yandex.net [2a02:6b8:c08:bd1e:0:640:7470:3316])
        by sas1-4cbebe29391b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id z6hgVNbZnS-Jus0I3Qu;
        Fri, 12 Nov 2021 21:19:56 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1636741196; bh=88o6gEeTC9zrk7AMklPuyg0YL7GeLj3CNRB27zUdBEw=;
        h=References:Date:Subject:To:From:Message-Id:In-Reply-To:Cc;
        b=xigb+mnlHFd5bNR0TvQIrqTPx7/X/xtRhzbtIkp5O+z7wWhQUIhKrtZL9YWPo33eU
         a4j+4QkaeNJx1jVADfaNRLTOFAe+P2IjfgXTdoCAsKt/+Sm08DciJjTbqlIc3nOCS1
         FqHhU0lbYzHuVfRyZPI17xkEce0gWcc3nXxm6Jus=
Authentication-Results: sas1-4cbebe29391b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (vmhmukos.sas.yp-c.yandex.net [2a02:6b8:c07:895:0:696:abd4:0])
        by sas1-7470331623bb.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id vuM7zSALw5-JuxqjNUr;
        Fri, 12 Nov 2021 21:19:56 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     hmukos@yandex-team.ru
Cc:     eric.dumazet@gmail.com, mitradir@yandex-team.ru,
        netdev@vger.kernel.org, tom@herbertland.com, zeil@yandex-team.ru
Subject: [RFC PATCH v2 net-next 4/4] tcp: change SYN ACK retransmit behaviour to account for rehash
Date:   Fri, 12 Nov 2021 21:19:39 +0300
Message-Id: <20211112181939.11329-5-hmukos@yandex-team.ru>
In-Reply-To: <20211112181939.11329-1-hmukos@yandex-team.ru>
References: <20211025203521.13507-1-hmukos@yandex-team.ru>
 <20211112181939.11329-1-hmukos@yandex-team.ru>
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

