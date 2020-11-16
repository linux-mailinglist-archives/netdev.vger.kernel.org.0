Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91EB2B413C
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 11:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgKPKhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 05:37:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60373 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728881AbgKPKhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 05:37:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605523026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ah0fpG4PWNvzFpMdpbWnri6JpzL+gQo7D8V3E1P+olY=;
        b=iFSLUkEfuPfP2RWaG2XZxmcMv9n6N/0DdEwg1yu+pWNhX4N/izW0b1IWbg19u6E71UIb4v
        ppJcJmrFTNt+ocBm3O396WyS5EX9Bea+s6LASvxfT2jMz3O4sjtt213t8/7jiM4zPC+cMJ
        Ko0QLmc51yhjxsVueynTjNj2Jg0T1IQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-Ac7rkxrNPLmHhBOCFv0S5A-1; Mon, 16 Nov 2020 05:37:04 -0500
X-MC-Unique: Ac7rkxrNPLmHhBOCFv0S5A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A69F1186840E;
        Mon, 16 Nov 2020 10:37:03 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-64.ams2.redhat.com [10.36.114.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5BDD0100239A;
        Mon, 16 Nov 2020 10:37:02 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-sparse@vger.kernel.org
Subject: [PATCH net-next] net: add annotation for sock_{lock,unlock}_fast
Date:   Mon, 16 Nov 2020 11:36:39 +0100
Message-Id: <95cf587fe96127884e555f695fe519d50e63cc17.1605522868.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The static checker is fooled by the non-static locking scheme
implemented by the mentioned helpers.
Let's make its life easier adding some unconditional annotation
so that the helpers are now interpreted as a plain spinlock from
sparse.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/sock.h | 9 ++++++---
 net/core/sock.c    | 3 ++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 1d29aeae74fd..60d321c6b5a5 100644
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
@@ -1606,10 +1607,12 @@ bool lock_sock_fast(struct sock *sk);
  */
 static inline void unlock_sock_fast(struct sock *sk, bool slow)
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

