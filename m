Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E32A0D634E
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 15:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730972AbfJNNEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 09:04:45 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:53322 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730619AbfJNNEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 09:04:44 -0400
Received: by mail-pl1-f202.google.com with SMTP id g13so10005861plq.20
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 06:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=W10+NXUDbM4IFRm+vJuQLn82UpfeS+SJMP8VKvRVeek=;
        b=QZlOgRaweCiO4umxjDlYTLH0kM9z98MoJSMdWArDYMhrAoGBxqySizNLpfwUbNBv20
         b8KGxUrN1eeJ/CwGEF2p84GYLrUw/qUJXnpbXDuWP6c7jSIFRfLgsC68C7qprk1WI5+4
         Qq+qhteQA3N+JKtb5p2LfA9m7PKtGsJyDLZxKd8fvSn3RzGBHwqnYtwohVDJdy7nHNKc
         g2L6zkZc/hvp9xwj5Z4OZWBbmCxokkW1U5VMwcFLv0VK7X/nTdQGs2KHoDY+x1IkkwY1
         iv6100WnZ+yb7nOipuW2yakkvozBG6QBkbjC+w8Fhn86NIXQiVc86cNOo8PGWBfKtzsC
         +oAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=W10+NXUDbM4IFRm+vJuQLn82UpfeS+SJMP8VKvRVeek=;
        b=qguBJApARzXBr9PLepk6nxDCULBsF/2H152vq4o0DjcB2zkmc+T+AceiVm6aTk/ERH
         S8p/OfzEIrt7TCn4uP0lWZVi764bkQvxy2YhB3BSjnnsbd2QKiHBnmKGDBmVg05zXeMJ
         IB2ZRdpGeKh7ptWbD8jwQFhNli/Baf3+kpULZTgu1/jGSV1EuvwUPircv8QrQjY5xbLA
         XxpSC/1AlouJdPAyL9Wvs/M/osDTqiy1Uh6f2sL8jIlkDaJas1YKJGPiY8uJrvcGMCB2
         8ClGKP2hW66RPqwPddS1rH15XTsvb1SXiB8baccaxo7rHum/PFUhxdnVGksykq34ckFK
         +jcA==
X-Gm-Message-State: APjAAAV2R1VvLxRrmr3lvO6lUnoxBSJBjGvTotGI7U2haQ1eRQr/5n1L
        foBLKPpiQzbyVoqZD7RxiKKCGKpOny0hSQ==
X-Google-Smtp-Source: APXvYqyjFX0v/AlnMDWPD90rksFWSuVF1Xs0cRlI+uW9dB8ck8sqKdz/1uMRrjlxzE7wr6hTRr9Ckt6X4Jy4AA==
X-Received: by 2002:a63:1904:: with SMTP id z4mr33362328pgl.413.1571058283608;
 Mon, 14 Oct 2019 06:04:43 -0700 (PDT)
Date:   Mon, 14 Oct 2019 06:04:38 -0700
Message-Id: <20191014130438.163688-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH net] rxrpc: use rcu protection while reading sk->sk_user_data
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to extend the rcu_read_lock() section in rxrpc_error_report()
and use rcu_dereference_sk_user_data() instead of plain access
to sk->sk_user_data to make sure all rules are respected.

The compiler wont reload sk->sk_user_data at will, and RCU rules
prevent memory beeing freed too soon.

Fixes: f0308fb07080 ("rxrpc: Fix possible NULL pointer access in ICMP handling")
Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Howells <dhowells@redhat.com>
---
 net/rxrpc/peer_event.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index 61451281d74a3247ed99b160c4983bbc4a76e429..48f67a9b1037ceb7b7a749a241bbb127a12a1f67 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -147,13 +147,16 @@ void rxrpc_error_report(struct sock *sk)
 {
 	struct sock_exterr_skb *serr;
 	struct sockaddr_rxrpc srx;
-	struct rxrpc_local *local = sk->sk_user_data;
+	struct rxrpc_local *local;
 	struct rxrpc_peer *peer;
 	struct sk_buff *skb;
 
-	if (unlikely(!local))
+	rcu_read_lock();
+	local = rcu_dereference_sk_user_data(sk);
+	if (unlikely(!local)) {
+		rcu_read_unlock();
 		return;
-
+	}
 	_enter("%p{%d}", sk, local->debug_id);
 
 	/* Clear the outstanding error value on the socket so that it doesn't
@@ -163,6 +166,7 @@ void rxrpc_error_report(struct sock *sk)
 
 	skb = sock_dequeue_err_skb(sk);
 	if (!skb) {
+		rcu_read_unlock();
 		_leave("UDP socket errqueue empty");
 		return;
 	}
@@ -170,11 +174,11 @@ void rxrpc_error_report(struct sock *sk)
 	serr = SKB_EXT_ERR(skb);
 	if (!skb->len && serr->ee.ee_origin == SO_EE_ORIGIN_TIMESTAMPING) {
 		_leave("UDP empty message");
+		rcu_read_unlock();
 		rxrpc_free_skb(skb, rxrpc_skb_freed);
 		return;
 	}
 
-	rcu_read_lock();
 	peer = rxrpc_lookup_peer_icmp_rcu(local, skb, &srx);
 	if (peer && !rxrpc_get_peer_maybe(peer))
 		peer = NULL;
-- 
2.23.0.700.g56cf767bdb-goog

