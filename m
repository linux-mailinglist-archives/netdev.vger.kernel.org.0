Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA8D3D1B36
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 23:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731150AbfJIVv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 17:51:27 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:46723 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729161AbfJIVv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 17:51:27 -0400
Received: by mail-pg1-f202.google.com with SMTP id f11so2650899pgn.13
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 14:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=uMa/odRpJ/C5QcyPuUzdG6hJvfyPp/m5zJ+3H0QRbxk=;
        b=iT/hJlqVUoPU5ZYSe1YysGnbHnfOBM+bG4LtDFHlIn0v66Kfz03k/2+izvS+9S2zxS
         9FAae91M618W+BYJKIFWPMFNEOtWh8D3RdprXyTMV9p/MfUJ3rRsZCSVZToP6Ie9ixHz
         YDOpabX09qlJhkucEm4Atn7GJ2ql43t7iuNWR7P0qLOgZS+i2YH5ilZ+7fPwQ8Ot/EXW
         Hpxo3gU1eofzzP5vOhgeyPiVXnmT2y8oBlOH45BFtm6OxoMvG4FOOdz6VQUNHIsd+apZ
         xBW1Nixwq+UndDMbP9NzPyD8PQFnZM1DbgIKq0BZMKYwZh18HkPPneGNZmJJGmiWtdHm
         HBSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=uMa/odRpJ/C5QcyPuUzdG6hJvfyPp/m5zJ+3H0QRbxk=;
        b=oLUnS+jTJRbF/yTImUb4cKZKuwS8GCDNPc466slEmqnJkxvrkxr7CXcg/H1+5U9T2B
         ysHUBlZr7YUuFT5WA/8w2qnJcZHtz/nsWuixlJjUFvaADKQZPLRZm7l+gFLrt55wSJiM
         rN7rVDolXNSfDCQXl96B9PScGjY52jblH6/wBqsONBtF8PSHNfjNbM4376S6meIEstuB
         wcop7bVZyyLyRnKb1zORxor/wgmjMU5cUrVFL5uby+uESw1Uvpdo4MvZHZ8wZJLOAyPY
         wd3hUgQnELY2jr5fbtAqQS5kXrvWLiu5r6sme3HqofoAUE8xIW7fAPE8iZng7NKn3yHA
         M6tg==
X-Gm-Message-State: APjAAAWEE8CQfHPpbTmgSkwKSr1SnZHi5PlxvHWnY3yBQEPrl8LW74L8
        T6e1p3LkppqilVkhdBUe9XAeqv2Q4kLdhQ==
X-Google-Smtp-Source: APXvYqy4WanFwckJtA+zBGZ3Qf5qrD331CaEAWMmZdIBwqWY9wnpH58+OPCLw/+4i9QNRvZeguiOSwDaR9ozAQ==
X-Received: by 2002:a63:2484:: with SMTP id k126mr6534864pgk.331.1570657884642;
 Wed, 09 Oct 2019 14:51:24 -0700 (PDT)
Date:   Wed,  9 Oct 2019 14:51:20 -0700
Message-Id: <20191009215120.31264-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH net] net: add {READ|WRITE}_ONCE() annotations on ->rskq_accept_head
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

reqsk_queue_empty() is called from inet_csk_listen_poll() while
other cpus might write ->rskq_accept_head value.

Use {READ|WRITE}_ONCE() to avoid compiler tricks
and potential KCSAN splats.

Fixes: fff1f3001cc5 ("tcp: add a spinlock to protect struct request_sock_queue")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/xen/pvcalls-back.c      | 2 +-
 include/net/request_sock.h      | 4 ++--
 net/ipv4/inet_connection_sock.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/pvcalls-back.c b/drivers/xen/pvcalls-back.c
index 69a626b0e59420443b3972426c2d8be19714589c..c57c71b7d53dbab128c27bfdaadc4ac218469eb2 100644
--- a/drivers/xen/pvcalls-back.c
+++ b/drivers/xen/pvcalls-back.c
@@ -775,7 +775,7 @@ static int pvcalls_back_poll(struct xenbus_device *dev,
 	mappass->reqcopy = *req;
 	icsk = inet_csk(mappass->sock->sk);
 	queue = &icsk->icsk_accept_queue;
-	data = queue->rskq_accept_head != NULL;
+	data = READ_ONCE(queue->rskq_accept_head) != NULL;
 	if (data) {
 		mappass->reqcopy.cmd = 0;
 		ret = 0;
diff --git a/include/net/request_sock.h b/include/net/request_sock.h
index fd178d58fa84e7ae7abdeff5be2ba7b1ec790889..cf8b33213bbc283348fb7470c1ce8fd55cd9d508 100644
--- a/include/net/request_sock.h
+++ b/include/net/request_sock.h
@@ -185,7 +185,7 @@ void reqsk_fastopen_remove(struct sock *sk, struct request_sock *req,
 
 static inline bool reqsk_queue_empty(const struct request_sock_queue *queue)
 {
-	return queue->rskq_accept_head == NULL;
+	return READ_ONCE(queue->rskq_accept_head) == NULL;
 }
 
 static inline struct request_sock *reqsk_queue_remove(struct request_sock_queue *queue,
@@ -197,7 +197,7 @@ static inline struct request_sock *reqsk_queue_remove(struct request_sock_queue
 	req = queue->rskq_accept_head;
 	if (req) {
 		sk_acceptq_removed(parent);
-		queue->rskq_accept_head = req->dl_next;
+		WRITE_ONCE(queue->rskq_accept_head, req->dl_next);
 		if (queue->rskq_accept_head == NULL)
 			queue->rskq_accept_tail = NULL;
 	}
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index a9183543ca305e1723317a3dfd34af29087b605a..dbcf34ec8dd208d2144a590d40501c4eb82e5111 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -934,7 +934,7 @@ struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
 		req->sk = child;
 		req->dl_next = NULL;
 		if (queue->rskq_accept_head == NULL)
-			queue->rskq_accept_head = req;
+			WRITE_ONCE(queue->rskq_accept_head, req);
 		else
 			queue->rskq_accept_tail->dl_next = req;
 		queue->rskq_accept_tail = req;
-- 
2.23.0.581.g78d2f28ef7-goog

