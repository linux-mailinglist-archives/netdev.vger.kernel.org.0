Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8FB1D6518
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 03:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbgEQBxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 21:53:23 -0400
Received: from novek.ru ([213.148.174.62]:51484 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbgEQBxW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 May 2020 21:53:22 -0400
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 May 2020 21:53:21 EDT
Received: by novek.ru (Postfix, from userid 0)
        id 954F05026DE; Sun, 17 May 2020 04:44:51 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 954F05026DE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1589679891; bh=uvEV2jLB3i1iF8rifO8qkPfYBU8NFMrh6z/eHaW/KGA=;
        h=From:Date:Subject:To:Cc:From;
        b=l6DdMZIolCMpvkgIxMUqskmlXgN2acnKrSmsAC/Oy+z45n4B2+WH37YjeZxKAtnXq
         gZ7IKc83YQeh7/qAtfFbaOePUJsPb69h6EC1OdLkFEUOjXr8wwrTlxjNtUF4Zo7Q4+
         hD1wokzPn18tBQ+6Al4kb1NrG1YiSYgfR1ORK0UM=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Date:   Sun, 17 May 2020 02:48:39 +0300
Subject: [PATCH] net/tls: fix encryption error checking
To:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>
Message-Id: <20200517014451.954F05026DE@novek.ru>
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tls_push_record can return -EAGAIN because of tcp layer. In that
case open_rec is already in the tx_record list and should not be
freed.
Also the record size can be more than the size requested to write
in tls_sw_do_sendpage(). That leads to overflow of copied variable
and wrong return code.

Fixes: d10523d0b3d7 ("net/tls: free the record on encryption error")
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 net/tls/tls_sw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index e23f94a..d4acbd1 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -796,7 +796,7 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 	psock = sk_psock_get(sk);
 	if (!psock || !policy) {
 		err = tls_push_record(sk, flags, record_type);
-		if (err && err != -EINPROGRESS) {
+		if (err && err != -EINPROGRESS && err != -EAGAIN) {
 			*copied -= sk_msg_free(sk, msg);
 			tls_free_open_rec(sk);
 		}
@@ -824,7 +824,7 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 	switch (psock->eval) {
 	case __SK_PASS:
 		err = tls_push_record(sk, flags, record_type);
-		if (err && err != -EINPROGRESS) {
+		if (err && err != -EINPROGRESS && err != -EAGAIN) {
 			*copied -= sk_msg_free(sk, msg);
 			tls_free_open_rec(sk);
 			goto out_err;
@@ -1132,7 +1132,7 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 	struct sk_msg *msg_pl;
 	struct tls_rec *rec;
 	int num_async = 0;
-	size_t copied = 0;
+	ssize_t copied = 0;
 	bool full_record;
 	int record_room;
 	int ret = 0;
@@ -1234,7 +1234,7 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 	}
 sendpage_end:
 	ret = sk_stream_error(sk, flags, ret);
-	return copied ? copied : ret;
+	return (copied > 0) ? copied : ret;
 }
 
 int tls_sw_sendpage_locked(struct sock *sk, struct page *page,
-- 
1.8.3.1

