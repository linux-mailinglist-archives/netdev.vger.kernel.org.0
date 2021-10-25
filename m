Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840EB43A4CE
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbhJYUkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbhJYUkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 16:40:02 -0400
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCA1C061767
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 13:37:39 -0700 (PDT)
Received: from sas1-3cba3404b018.qloud-c.yandex.net (sas1-3cba3404b018.qloud-c.yandex.net [IPv6:2a02:6b8:c08:bd26:0:640:3cba:3404])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 0DB0C2E0AB3;
        Mon, 25 Oct 2021 23:36:03 +0300 (MSK)
Received: from sas1-db2fca0e44c8.qloud-c.yandex.net (2a02:6b8:c14:6696:0:640:db2f:ca0e [2a02:6b8:c14:6696:0:640:db2f:ca0e])
        by sas1-3cba3404b018.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id 70A6B8GDWU-a2ui0VaV;
        Mon, 25 Oct 2021 23:36:02 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1635194162; bh=88o6gEeTC9zrk7AMklPuyg0YL7GeLj3CNRB27zUdBEw=;
        h=References:Date:Subject:To:From:Message-Id:In-Reply-To:Cc;
        b=Cja0QhPhCSAp8rRVa6F7IwzAr8to0Sq1km3zpSQ+HrNeKY+ah3C6m51+7bFD2O6Gb
         T8kBRgx5qCieioyUBDzdvF5/FN1RQyw4WD76M7EvnHhm1zsvT3+kFRM7l4Iep1XsPj
         r4AMVv3YZ6tjEItQinr6qW6pyuvFwle0zFhrFXOQ=
Authentication-Results: sas1-3cba3404b018.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from vmhmukos.sas.yp-c.yandex.net (2a02:6b8:c07:895:0:696:abd4:0 [2a02:6b8:c07:895:0:696:abd4:0])
        by sas1-db2fca0e44c8.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id mklMLk28bQ-a20aA9gL;
        Mon, 25 Oct 2021 23:36:02 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     eric.dumazet@gmail.com, tom@herbertland.com,
        mitradir@yandex-team.ru, zeil@yandex-team.ru, hmukos@yandex-team.ru
Subject: [RFC PATCH net-next 4/4] tcp: change SYN ACK retransmit behaviour to account for rehash
Date:   Mon, 25 Oct 2021 23:35:21 +0300
Message-Id: <20211025203521.13507-5-hmukos@yandex-team.ru>
In-Reply-To: <20211025203521.13507-1-hmukos@yandex-team.ru>
References: <20211025203521.13507-1-hmukos@yandex-team.ru>
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

