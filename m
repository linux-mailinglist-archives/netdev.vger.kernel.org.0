Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59572B6DA4
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 19:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgKQSoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 13:44:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24356 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726579AbgKQSoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 13:44:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605638640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lGq5kCPtIOhdBf9qopiL98GXQjU4TKit31m1KspptsU=;
        b=A7rbxMr7tk2Bslk7ysOG8XfPQ4ALHxILSuBqGt9Qf1S0MzDWasgOt+GofuYhfNi1RPBDcf
        xCm/quweAImEUW8iw20HXA9UFt6B7NVCVWs8YFLpWlNQhpneVwuJtB8fqxfeYooQP9W55J
        +z42lgdpiqFz1VhkDruqLhwR+R+VIJE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-0GER-hQxMxS8KxvHiffQZQ-1; Tue, 17 Nov 2020 13:43:58 -0500
X-MC-Unique: 0GER-hQxMxS8KxvHiffQZQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 361421009443;
        Tue, 17 Nov 2020 18:43:57 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-19.ams2.redhat.com [10.36.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 778B15D9E8;
        Tue, 17 Nov 2020 18:43:55 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        linux-sparse@vger.kernel.org
Subject: [PATCH net-next v2] net: add annotation for sock_{lock,unlock}_fast
Date:   Tue, 17 Nov 2020 19:43:49 +0100
Message-Id: <6ed7ae627d8271fb7f20e0a9c6750fbba1ac2635.1605634911.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The static checker is fooled by the non-static locking scheme
implemented by the mentioned helpers.
Let's make its life easier adding some unconditional annotation
so that the helpers are now interpreted as a plain spinlock from
sparse.

v1 -> v2:
 - add __releases() annotation to unlock_sock_fast()

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/sock.h | 10 +++++++---
 net/core/sock.c    |  3 ++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 1d29aeae74fd..093b51719c69 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1595,7 +1595,8 @@ void release_sock(struct sock *sk);
 				SINGLE_DEPTH_NESTING)
 #define bh_unlock_sock(__sk)	spin_unlock(&((__sk)->sk_lock.slock))
 
-bool lock_sock_fast(struct sock *sk);
+bool lock_sock_fast(struct sock *sk) __acquires(&sk->sk_lock.slock);
+
 /**
  * unlock_sock_fast - complement of lock_sock_fast
  * @sk: socket
@@ -1605,11 +1606,14 @@ bool lock_sock_fast(struct sock *sk);
  * If slow mode is on, we call regular release_sock()
  */
 static inline void unlock_sock_fast(struct sock *sk, bool slow)
+	__releases(&sk->sk_lock.slock)
 {
-	if (slow)
+	if (slow) {
 		release_sock(sk);
-	else
+		__release(&sk->sk_lock.slock);
+	} else {
 		spin_unlock_bh(&sk->sk_lock.slock);
+	}
 }
 
 /* Used by processes to "lock" a socket state, so that
diff --git a/net/core/sock.c b/net/core/sock.c
index 727ea1cc633c..9badbe7bb4e4 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3078,7 +3078,7 @@ EXPORT_SYMBOL(release_sock);
  *
  *   sk_lock.slock unlocked, owned = 1, BH enabled
  */
-bool lock_sock_fast(struct sock *sk)
+bool lock_sock_fast(struct sock *sk) __acquires(&sk->sk_lock.slock)
 {
 	might_sleep();
 	spin_lock_bh(&sk->sk_lock.slock);
@@ -3096,6 +3096,7 @@ bool lock_sock_fast(struct sock *sk)
 	 * The sk_lock has mutex_lock() semantics here:
 	 */
 	mutex_acquire(&sk->sk_lock.dep_map, 0, 0, _RET_IP_);
+	__acquire(&sk->sk_lock.slock);
 	local_bh_enable();
 	return true;
 }
-- 
2.26.2

