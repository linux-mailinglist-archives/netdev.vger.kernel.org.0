Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F37C1D1974
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 17:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389107AbgEMPb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 11:31:27 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21981 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729483AbgEMPb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 11:31:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589383885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HEj2v8ZB5+pK9c0u1+QvQA8vmdGbq3olv+4jLy19lz8=;
        b=FIsv4C2j6s4t+2oKfwbBna4tPHoh/gRmEwUdDIy/zOpHq4EzCefk1xhRiOnWP4CY9Pdmmc
        tX8oKaYKl4NNTAm8y7mJwYVQdEd2yctFbrauVnKrcSjNBVoQr4X/u+7xFaUlFDT+Yj+Fl1
        ZuSxHi8P0ctKP07fo5zIxohfgKF9s6c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-jd-6JDHfPUeIETLxBqxGpQ-1; Wed, 13 May 2020 11:31:19 -0400
X-MC-Unique: jd-6JDHfPUeIETLxBqxGpQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C0D6108BD0D;
        Wed, 13 May 2020 15:31:18 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-113-27.ams2.redhat.com [10.36.113.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 553C410013BD;
        Wed, 13 May 2020 15:31:17 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>
Subject: [PATCH net-next 2/3] inet_connection_sock: factor out destroy helper.
Date:   Wed, 13 May 2020 17:31:03 +0200
Message-Id: <d615b4c810b22a78923078eecadd12bfc4a07eb4.1589383730.git.pabeni@redhat.com>
In-Reply-To: <cover.1589383730.git.pabeni@redhat.com>
References: <cover.1589383730.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the steps to prepare an inet_connection_sock for
forced disposal inside a separate helper. No functional
changes inteded, this will just simplify the next patch.

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

