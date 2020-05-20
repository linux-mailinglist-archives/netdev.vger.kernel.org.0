Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63121DADC5
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 10:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgETImU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 04:42:20 -0400
Received: from novek.ru ([213.148.174.62]:52270 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgETImT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 04:42:19 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id CB262502976;
        Wed, 20 May 2020 11:42:14 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru CB262502976
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1589964135; bh=OMrVTKV8ndyhJ+06po5LR5h9pOs942Ga5brcCyon0Bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zO55wsSveBM6POwwBH2ZMbkiYDYD+JhD0PAmZlRZY/BU06hXYz5HJhceSjRprGCjn
         6qXLqG1wGd1XOkPhNxe3oeXb0JxNixsC5Gzh3/VtqgMXxmC8o8+B5PU92VOzQ/iDF9
         SOB2AMvDsjnSgm8AVy41mh2f8ykMn7T+uaBscYwE=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [net v3 2/2] net/tls: free record only on encryption error
Date:   Wed, 20 May 2020 11:41:44 +0300
Message-Id: <1589964104-9941-3-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589964104-9941-1-git-send-email-vfedorenko@novek.ru>
References: <1589964104-9941-1-git-send-email-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We cannot free record on any transient error because it leads to
losing previos data. Check socket error to know whether record must
be freed or not.

Fixes: d10523d0b3d7 ("net/tls: free the record on encryption error")
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 net/tls/tls_sw.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index e61c024..cb72abe 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -798,9 +798,10 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 	psock = sk_psock_get(sk);
 	if (!psock || !policy) {
 		err = tls_push_record(sk, flags, record_type);
-		if (err && err != -EINPROGRESS) {
+		if (err && sk->sk_err == EBADMSG) {
 			*copied -= sk_msg_free(sk, msg);
 			tls_free_open_rec(sk);
+			err = -sk->sk_err;
 		}
 		if (psock)
 			sk_psock_put(sk, psock);
@@ -826,9 +827,10 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 	switch (psock->eval) {
 	case __SK_PASS:
 		err = tls_push_record(sk, flags, record_type);
-		if (err && err != -EINPROGRESS) {
+		if (err && sk->sk_err == EBADMSG) {
 			*copied -= sk_msg_free(sk, msg);
 			tls_free_open_rec(sk);
+			err = -sk->sk_err;
 			goto out_err;
 		}
 		break;
-- 
1.8.3.1

