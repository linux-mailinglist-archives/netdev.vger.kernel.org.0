Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6B9AE2A10
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 07:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437585AbfJXFpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 01:45:09 -0400
Received: from mail-yb1-f202.google.com ([209.85.219.202]:47466 "EHLO
        mail-yb1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437581AbfJXFpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 01:45:09 -0400
Received: by mail-yb1-f202.google.com with SMTP id j2so16715935ybm.14
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 22:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=y8WsNXQSo0/fZy9YHbme5LKLTfMJiHamY8kJKF0n0Rc=;
        b=fS1skKeWXQzDjS2MzWSg3+Wcgr1SKfcqRBfosnIMoDVEhHfxp+gueuFh2mZJ7L16mj
         BStWxdhGtNgF5AuMHLKzwqqab/j4y91Wux4yJR923GjGkq+6MABjKZvMRhlZZ/YeZ9Lp
         AHgCa6FHk5s7ja37xJ71IAd247Y7eCbch8R7LxcMdv6ZFbRfnkU7ct4ZMdgXZa49xp0i
         4e3DRkfVmNBZaAyr3qGQ8G5vSfEzEOL3CBaQYM8J+Tt4vmSpvOA9JlcfrhjV+olC18dm
         1ABWWFm/eNESy7E+HtN2WTx2zcbJZ2R1qHjFne8GneCG4WFtn8nUCjTK4d953rgAsdjl
         mTbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=y8WsNXQSo0/fZy9YHbme5LKLTfMJiHamY8kJKF0n0Rc=;
        b=rq/6Kdx1Ny1LDCOyJFioktl0dmCEEmeNrieb1MQfVALR7cChJXu3SM0Q2J2dUscE7l
         io4xwwb01vadandmn363SQDVpzu44oNZK9+6KD4l7IG7UaJjI8a1XDvtPeG8GEKHyjhh
         nzQtJK64CtLc48sd6hQQ5NWB5EWkWBUo7oDIoguJLskXGz10w2oarOnkmy9ft9uBhdvM
         9XKquNlgwB9uP37EJuBOIYykxqepvYOoS5iFmSV5KMy3REAOSea8zI/u4at+OHT57EY3
         qFEIAm/UcJCWeltaBMv6hvPKe28VmTukVmh2yZwdCvJJ0/vwq37scd4DAMzfS7dln+7Y
         zxWQ==
X-Gm-Message-State: APjAAAXzT5P0XAmjCkhyD5e+uSXxDtjGpS61kRoR08yvf/fJAzvc7rf8
        EA4cLwMcE2l8VNpgZejLyBx3R7LZ6Op4VQ==
X-Google-Smtp-Source: APXvYqwkm7F3osXJZz7bAGl9QyZkqM8b+W1zomdsJQcScUMTMqd5T2Nl1qJaHquTOqp4deYziF/eerESk8+pRQ==
X-Received: by 2002:a81:93c7:: with SMTP id k190mr4971720ywg.213.1571895908066;
 Wed, 23 Oct 2019 22:45:08 -0700 (PDT)
Date:   Wed, 23 Oct 2019 22:44:51 -0700
In-Reply-To: <20191024054452.81661-1-edumazet@google.com>
Message-Id: <20191024054452.81661-5-edumazet@google.com>
Mime-Version: 1.0
References: <20191024054452.81661-1-edumazet@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH net 4/5] net: use skb_queue_empty_lockless() in busy poll contexts
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Busy polling usually runs without locks.
Let's use skb_queue_empty_lockless() instead of skb_queue_empty()

Also uses READ_ONCE() in __skb_try_recv_datagram() to address
a similar potential problem.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/crypto/chelsio/chtls/chtls_io.c | 2 +-
 drivers/nvme/host/tcp.c                 | 2 +-
 net/core/datagram.c                     | 2 +-
 net/core/sock.c                         | 2 +-
 net/ipv4/tcp.c                          | 2 +-
 net/sctp/socket.c                       | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/crypto/chelsio/chtls/chtls_io.c
index 0891ab829b1b6b1318353e945e6394fab29f7c1e..98bc5a4cd5e7014990f064a92777308ae98b13e4 100644
--- a/drivers/crypto/chelsio/chtls/chtls_io.c
+++ b/drivers/crypto/chelsio/chtls/chtls_io.c
@@ -1702,7 +1702,7 @@ int chtls_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		return peekmsg(sk, msg, len, nonblock, flags);
 
 	if (sk_can_busy_loop(sk) &&
-	    skb_queue_empty(&sk->sk_receive_queue) &&
+	    skb_queue_empty_lockless(&sk->sk_receive_queue) &&
 	    sk->sk_state == TCP_ESTABLISHED)
 		sk_busy_loop(sk, nonblock);
 
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 770dbcbc999e0bff81b8643644cab20599a0c2e3..7544be84ab3582e27ded19298b45960ce3460d96 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2219,7 +2219,7 @@ static int nvme_tcp_poll(struct blk_mq_hw_ctx *hctx)
 	struct nvme_tcp_queue *queue = hctx->driver_data;
 	struct sock *sk = queue->sock->sk;
 
-	if (sk_can_busy_loop(sk) && skb_queue_empty(&sk->sk_receive_queue))
+	if (sk_can_busy_loop(sk) && skb_queue_empty_lockless(&sk->sk_receive_queue))
 		sk_busy_loop(sk, true);
 	nvme_tcp_try_recv(queue);
 	return queue->nr_cqe;
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 5b685e110affab8f6d7cd3050ce88dfddb1357f5..03515e46a49ab60cdd5f643efb3459d16f6021e5 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -278,7 +278,7 @@ struct sk_buff *__skb_try_recv_datagram(struct sock *sk, unsigned int flags,
 			break;
 
 		sk_busy_loop(sk, flags & MSG_DONTWAIT);
-	} while (sk->sk_receive_queue.prev != *last);
+	} while (READ_ONCE(sk->sk_receive_queue.prev) != *last);
 
 	error = -EAGAIN;
 
diff --git a/net/core/sock.c b/net/core/sock.c
index a515392ba84b67b2bf5400e0cfb7c3454fa87af8..b8e758bcb6ad65c93e93fb64f70a61e353a5737e 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3600,7 +3600,7 @@ bool sk_busy_loop_end(void *p, unsigned long start_time)
 {
 	struct sock *sk = p;
 
-	return !skb_queue_empty(&sk->sk_receive_queue) ||
+	return !skb_queue_empty_lockless(&sk->sk_receive_queue) ||
 	       sk_busy_loop_timeout(sk, start_time);
 }
 EXPORT_SYMBOL(sk_busy_loop_end);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ffef502f52920170478d9fd000a507659e17de15..d8876f0e9672718b4e02bc7aaaac30ecfd4903cb 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1964,7 +1964,7 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
 
-	if (sk_can_busy_loop(sk) && skb_queue_empty(&sk->sk_receive_queue) &&
+	if (sk_can_busy_loop(sk) && skb_queue_empty_lockless(&sk->sk_receive_queue) &&
 	    (sk->sk_state == TCP_ESTABLISHED))
 		sk_busy_loop(sk, nonblock);
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index cfb25391b8b0fb66b77db995933103007113aa32..ca81e06df1651f16ab332cd9fc880c21b89a5c6d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8871,7 +8871,7 @@ struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags,
 		if (sk_can_busy_loop(sk)) {
 			sk_busy_loop(sk, noblock);
 
-			if (!skb_queue_empty(&sk->sk_receive_queue))
+			if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
 				continue;
 		}
 
-- 
2.23.0.866.gb869b98d4c-goog

