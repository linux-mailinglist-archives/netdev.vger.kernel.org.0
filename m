Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB8D21D57A1
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgEORXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:23:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40916 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726513AbgEORXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 13:23:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589563398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hHttDLwaWWFiowglH3e/cqy6DsJP/qChFndDOTHVEvM=;
        b=Tz45k6FIxdn9Xo0QdSgo8eNT52z0/QL1zRWdTtkdM8ATsUe3uzxc70V7BGQx/bVxkbldVO
        08xuyjB6nwhGR2iEwFm4/AhmeeILfVfeIbMgfK6+Dxb9A2x92wtbzGZhG5anqRTOhFbFDA
        EAY6YcT5dmwrcvezal9SKorDa6Kjjhk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-K44b2-aRNyCL3jc99spxPA-1; Fri, 15 May 2020 13:23:15 -0400
X-MC-Unique: K44b2-aRNyCL3jc99spxPA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC2141005510;
        Fri, 15 May 2020 17:23:13 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-115-8.ams2.redhat.com [10.36.115.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 15E71600F5;
        Fri, 15 May 2020 17:23:11 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 2/3] inet_connection_sock: factor out destroy helper.
Date:   Fri, 15 May 2020 19:22:16 +0200
Message-Id: <9cb1cf2e8b9dc89510ab38c938e2ba102b207d2f.1589558049.git.pabeni@redhat.com>
In-Reply-To: <cover.1589558049.git.pabeni@redhat.com>
References: <cover.1589558049.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the steps to prepare an inet_connection_sock for
forced disposal inside a separate helper. No functional
changes inteded, this will just simplify the next patch.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Christoph Paasch <cpaasch@apple.com>
---
 include/net/inet_connection_sock.h | 8 ++++++++
 net/ipv4/inet_connection_sock.c    | 6 +-----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index a3f076befa4f..2f1f8c3efb26 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -287,6 +287,14 @@ static inline int inet_csk_reqsk_queue_is_full(const struct sock *sk)
 void inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req);
 void inet_csk_reqsk_queue_drop_and_put(struct sock *sk, struct request_sock *req);
 
+static inline void inet_csk_prepare_for_destroy_sock(struct sock *sk)
+{
+	/* The below has to be done to allow calling inet_csk_destroy_sock */
+	sock_set_flag(sk, SOCK_DEAD);
+	percpu_counter_inc(sk->sk_prot->orphan_count);
+	inet_sk(sk)->inet_num = 0;
+}
+
 void inet_csk_destroy_sock(struct sock *sk);
 void inet_csk_prepare_forced_close(struct sock *sk);
 
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 5f34eb951627..d6faf3702824 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -896,11 +896,7 @@ void inet_csk_prepare_forced_close(struct sock *sk)
 	/* sk_clone_lock locked the socket and set refcnt to 2 */
 	bh_unlock_sock(sk);
 	sock_put(sk);
-
-	/* The below has to be done to allow calling inet_csk_destroy_sock */
-	sock_set_flag(sk, SOCK_DEAD);
-	percpu_counter_inc(sk->sk_prot->orphan_count);
-	inet_sk(sk)->inet_num = 0;
+	inet_csk_prepare_for_destroy_sock(sk);
 }
 EXPORT_SYMBOL(inet_csk_prepare_forced_close);
 
-- 
2.21.3

