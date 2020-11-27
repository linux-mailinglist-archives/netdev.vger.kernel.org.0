Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506BA2C6289
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 11:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgK0KKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 05:10:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29959 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725854AbgK0KKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 05:10:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606471848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TfdqAVYhzEvrCFECZLS/WUpqTUKd31Cq3Z5fIDccb/4=;
        b=SPdZl3UclC5SqmGKhfWwEVoDSHX1+9lxIaNsA7lQP5pXjDzWG9JUqSJCf7IAxzLuC48a/K
        Kvtxcq3xASZRCBiCVs4HQvsieFl6mDYYy7ewu0ZFZ0CGEXUkh3BPIzaVDJet9apzusBhrV
        m3FTWHV7h/dVNjXCo66EVBSuFNxWU6s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-pdWqnJg3PIudhyYpboTSFw-1; Fri, 27 Nov 2020 05:10:44 -0500
X-MC-Unique: pdWqnJg3PIudhyYpboTSFw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C739D805BFA;
        Fri, 27 Nov 2020 10:10:41 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-134.ams2.redhat.com [10.36.113.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F5CF1000320;
        Fri, 27 Nov 2020 10:10:40 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 1/6] mptcp: open code mptcp variant for lock_sock
Date:   Fri, 27 Nov 2020 11:10:22 +0100
Message-Id: <fd92953c74dde2aa43d34fcdb681392f1a481d1a.1606413118.git.pabeni@redhat.com>
In-Reply-To: <cover.1606413118.git.pabeni@redhat.com>
References: <cover.1606413118.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows invoking an additional callback under the
socket spin lock.

Will be used by the next patches to avoid additional
spin lock contention.

Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/sock.h   |  1 +
 net/core/sock.c      |  2 +-
 net/mptcp/protocol.h | 13 +++++++++++++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 80469c2c448d..f59764614e30 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1590,6 +1590,7 @@ static inline void lock_sock(struct sock *sk)
 	lock_sock_nested(sk, 0);
 }
 
+void __lock_sock(struct sock *sk);
 void __release_sock(struct sock *sk);
 void release_sock(struct sock *sk);
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 9badbe7bb4e4..f0f096852876 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2486,7 +2486,7 @@ bool sk_page_frag_refill(struct sock *sk, struct page_frag *pfrag)
 }
 EXPORT_SYMBOL(sk_page_frag_refill);
 
-static void __lock_sock(struct sock *sk)
+void __lock_sock(struct sock *sk)
 	__releases(&sk->sk_lock.slock)
 	__acquires(&sk->sk_lock.slock)
 {
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 82d5626323b1..6abac8238de3 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -253,6 +253,19 @@ struct mptcp_sock {
 	} rcvq_space;
 };
 
+#define mptcp_lock_sock(___sk, cb) do {					\
+	struct sock *__sk = (___sk); /* silence macro reuse warning */	\
+	might_sleep();							\
+	spin_lock_bh(&__sk->sk_lock.slock);				\
+	if (__sk->sk_lock.owned)					\
+		__lock_sock(__sk);					\
+	cb;								\
+	__sk->sk_lock.owned = 1;					\
+	spin_unlock(&__sk->sk_lock.slock);				\
+	mutex_acquire(&__sk->sk_lock.dep_map, 0, 0, _RET_IP_);		\
+	local_bh_enable();						\
+} while (0)
+
 #define mptcp_for_each_subflow(__msk, __subflow)			\
 	list_for_each_entry(__subflow, &((__msk)->conn_list), node)
 
-- 
2.26.2

