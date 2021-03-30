Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2164A34EE21
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 18:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhC3Qo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 12:44:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29878 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231636AbhC3QoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 12:44:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617122644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4revyhyegNj49VxeZ0UKo6N3VAEkQeHdS4R643b/9ck=;
        b=Rhi/284pSCFZvEXktn7IHPRquKWlhx+77Q4d47CjT5RK7+hUNt1uBffzwUXbTtgFzLg5Bd
        Nt/WuB1ByUdp6N3J21taMmgUbi72jEbidGgDnlO8XYvsRnPZIb47JHykXvpskLkfP38GzQ
        VunLcFvFtaPIzp1z5ZJKSAydd7JGQmA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-wp3pNQLxPTy72919bWyWhA-1; Tue, 30 Mar 2021 12:44:02 -0400
X-MC-Unique: wp3pNQLxPTy72919bWyWhA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF20E83DD28;
        Tue, 30 Mar 2021 16:44:00 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-56.ams2.redhat.com [10.36.115.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A06161349A;
        Tue, 30 Mar 2021 16:43:59 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2] net: let skb_orphan_partial wake-up waiters.
Date:   Tue, 30 Mar 2021 18:43:54 +0200
Message-Id: <532014d8a99966da5fbcee528abe56356899f04a.1617121851.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the mentioned helper can end-up freeing the socket wmem
without waking-up any processes waiting for more write memory.

If the partially orphaned skb is attached to an UDP (or raw) socket,
the lack of wake-up can hang the user-space.

Even for TCP sockets not calling the sk destructor could have bad
effects on TSQ.

Address the issue using skb_orphan to release the sk wmem before
setting the new sock_efree destructor. Additionally bundle the
whole ownership update in a new helper, so that later other
potential users could avoid duplicate code.

v1 -> v2:
 - use skb_orphan() instead of sort of open coding it (Eric)
 - provide an helper for the ownership change (Eric)

Fixes: f6ba8d33cfbb ("netem: fix skb_orphan_partial()")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/sock.h |  9 +++++++++
 net/core/sock.c    | 12 +++---------
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 636810ddcd9ba..4a1c3f53630b3 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2221,6 +2221,15 @@ static inline void skb_set_owner_r(struct sk_buff *skb, struct sock *sk)
 	sk_mem_charge(sk, skb->truesize);
 }
 
+static inline void skb_set_owner_sk_safe(struct sk_buff *skb, struct sock *sk)
+{
+	if (sk && refcount_inc_not_zero(&sk->sk_refcnt)) {
+		skb_orphan(skb);
+		skb->destructor = sock_efree;
+		skb->sk = sk;
+	}
+}
+
 void sk_reset_timer(struct sock *sk, struct timer_list *timer,
 		    unsigned long expires);
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 0ed98f20448a2..7092e3b3076ee 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2132,16 +2132,10 @@ void skb_orphan_partial(struct sk_buff *skb)
 	if (skb_is_tcp_pure_ack(skb))
 		return;
 
-	if (can_skb_orphan_partial(skb)) {
-		struct sock *sk = skb->sk;
-
-		if (refcount_inc_not_zero(&sk->sk_refcnt)) {
-			WARN_ON(refcount_sub_and_test(skb->truesize, &sk->sk_wmem_alloc));
-			skb->destructor = sock_efree;
-		}
-	} else {
+	if (can_skb_orphan_partial(skb))
+		skb_set_owner_sk_safe(skb, skb->sk);
+	else
 		skb_orphan(skb);
-	}
 }
 EXPORT_SYMBOL(skb_orphan_partial);
 
-- 
2.26.2

