Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3841CF68A
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 16:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730223AbgELOLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 10:11:22 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43878 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728283AbgELOLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 10:11:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589292680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3PnIE5yuH0naGGdUGb4X+BjeY7YJAi1txy2hj5ptIo8=;
        b=dWcoclZs6RBkVEasxBRsDg7haitZudst5BR/rsap/YxVsmBtGT86T3itazbDGXciIqwZhT
        fRFtM0ueENT7d1Z4F07Cdex9rwGNZ238mmh+Zk+MqeR5Q6lL/XdX3TFSSmJnAH4lr368uc
        49gVCP+FWhYmGAiLW2m70FM4RDczEKw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-MD027jbFNZSFeDlAQXJSfg-1; Tue, 12 May 2020 10:11:16 -0400
X-MC-Unique: MD027jbFNZSFeDlAQXJSfg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CB95107ACF6;
        Tue, 12 May 2020 14:11:15 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-115-10.ams2.redhat.com [10.36.115.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 61D6A5D9DD;
        Tue, 12 May 2020 14:11:14 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>
Subject: [RFC PATCH 2/3] inet_connection_sock: factor out destroy helper.
Date:   Tue, 12 May 2020 16:08:09 +0200
Message-Id: <41f11822c22deb9f9a766e01982c3507b80a3296.1589280857.git.pabeni@redhat.com>
In-Reply-To: <cover.1589280857.git.pabeni@redhat.com>
References: <cover.1589280857.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the steps to prepare an inet_connection_sock for
forced disposal inside a separate helper. No functional
changes inteded, this will just simplify the next patch.

Suggested-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
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

