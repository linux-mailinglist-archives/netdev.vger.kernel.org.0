Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36852B34B7
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 12:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgKOLn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 06:43:59 -0500
Received: from novek.ru ([213.148.174.62]:40566 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbgKOLn7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Nov 2020 06:43:59 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 9D21E500702;
        Sun, 15 Nov 2020 14:44:04 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 9D21E500702
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1605440645; bh=hXoBJjoAl8LCZ82WBkmGt5c5QyI0HQQbdnfFQJaB+CE=;
        h=From:To:Cc:Subject:Date:From;
        b=onf2I65ywxxLdKQT3NnFE24JS814RBMW1vQIDTuYXbVP+wiRJC1aDbQ8qeqbzEger
         k5Yrx28chN8Jz1JKiF2OzWBZk8Tyvwir6Cpq1PJAUo1faunT8XrH49h//w1rlYs+nu
         AOlY8aWY5LCpLfLoc8zX5sKAjiCY1dB/90I7Mjf4=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org
Subject: [net] net/tls: missing received data after fast remote close
Date:   Sun, 15 Nov 2020 14:43:48 +0300
Message-Id: <1605440628-1283-1-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case when tcp socket received FIN after some data and the
parser haven't started before reading data caller will receive
an empty buffer. This behavior differs from plain TCP socket and
leads to special treating in user-space. Patch unpauses parser
directly if we have unparsed data in tcp receive queue.

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 net/tls/tls_sw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 2fe9e2c..4db6943 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1289,6 +1289,9 @@ static struct sk_buff *tls_wait_data(struct sock *sk, struct sk_psock *psock,
 	struct sk_buff *skb;
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 
+	if (!ctx->recv_pkt && skb_queue_empty(&sk->sk_receive_queue))
+		__strp_unpause(&ctx->strp);
+
 	while (!(skb = ctx->recv_pkt) && sk_psock_queue_empty(psock)) {
 		if (sk->sk_err) {
 			*err = sock_error(sk);
-- 
1.8.3.1

