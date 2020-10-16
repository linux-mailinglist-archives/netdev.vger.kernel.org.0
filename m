Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63598290383
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 12:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395522AbgJPKwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 06:52:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56773 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2395512AbgJPKwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 06:52:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602845526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PLYJBaVYGMCV4hEs4gCCgV8mFPC7FwkSwGclMvvORi0=;
        b=FrJ7gBW9zAqh38QD0DYDlPEavmvTRNyOe9fiey+GhGvAEdIdNMvgBqRN0/M4AThxmT9vZQ
        6qk1BNQDxBuY7yNY0ApXPiaO9jvVR1CkyuCqVGnEenW4p/qqYgcfvSa+7cCVbBhA6cUjr3
        63qEiQnQid3kQSJ25mGscZvL1JwTK2Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-d3p3vNsEP1Sfj-OTkDueUA-1; Fri, 16 Oct 2020 06:52:02 -0400
X-MC-Unique: d3p3vNsEP1Sfj-OTkDueUA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BDC2100746E;
        Fri, 16 Oct 2020 10:52:01 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-168.ams2.redhat.com [10.36.112.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 933E960C11;
        Fri, 16 Oct 2020 10:52:00 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [RFC PATCH 2/2] tcp: factor out __tcp_close() helper
Date:   Fri, 16 Oct 2020 12:51:08 +0200
Message-Id: <223fbbe119ad993d10b3be9012f60cfd8ed58651.1602840570.git.pabeni@redhat.com>
In-Reply-To: <cover.1602840570.git.pabeni@redhat.com>
References: <cover.1602840570.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

unlocked version of protocol level close, will be used by
MPTCP to allow decouple orphaning and subflow level close.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/tcp.h | 1 +
 net/ipv4/tcp.c    | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index e41569e55d97..75c5ee45aaa8 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -395,6 +395,7 @@ void tcp_update_metrics(struct sock *sk);
 void tcp_init_metrics(struct sock *sk);
 void tcp_metrics_init(void);
 bool tcp_peer_is_proven(struct request_sock *req, struct dst_entry *dst);
+void __tcp_close(struct sock *sk, long timeout);
 void tcp_close(struct sock *sk, long timeout);
 void tcp_init_sock(struct sock *sk);
 void tcp_init_transfer(struct sock *sk, int bpf_op, struct sk_buff *skb);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 259dca2bd3dd..046ac30bb041 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2418,13 +2418,12 @@ bool tcp_check_oom(struct sock *sk, int shift)
 	return too_many_orphans || out_of_socket_memory;
 }
 
-void tcp_close(struct sock *sk, long timeout)
+void __tcp_close(struct sock *sk, long timeout)
 {
 	struct sk_buff *skb;
 	int data_was_unread = 0;
 	int state;
 
-	lock_sock(sk);
 	sk->sk_shutdown = SHUTDOWN_MASK;
 
 	if (sk->sk_state == TCP_LISTEN) {
@@ -2588,6 +2587,12 @@ void tcp_close(struct sock *sk, long timeout)
 out:
 	bh_unlock_sock(sk);
 	local_bh_enable();
+}
+
+void tcp_close(struct sock *sk, long timeout)
+{
+	lock_sock(sk);
+	__tcp_close(sk, timeout);
 	release_sock(sk);
 	sock_put(sk);
 }
-- 
2.26.2

