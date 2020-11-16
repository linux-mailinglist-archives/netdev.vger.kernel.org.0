Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA162B4034
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgKPJsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:48:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43540 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728656AbgKPJsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:48:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605520118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PJLf2Qyuon5v+VLVBGrfj3PTsUpehNZxadmQa/yaZF8=;
        b=MJOTsX8ABj5tfCa3gYWDh1fL9Vs3uJkJeoVmrnl59ssIt69/c/sCzvY5iKjTKczlS8/ob3
        UcEuT5w407Yoxgm17xWfhuqPemDddpDFY6onQ0qrC1NXV4/2dF+CIMHaeYvDKCtVS7n8up
        L0ci5Aaa+HKDY95zgZvdYmG6wDkDbhE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-aQw8QROTPr-SiocI639fzQ-1; Mon, 16 Nov 2020 04:48:34 -0500
X-MC-Unique: aQw8QROTPr-SiocI639fzQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73F6C80365F;
        Mon, 16 Nov 2020 09:48:33 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-64.ams2.redhat.com [10.36.114.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DC4B1002C1B;
        Mon, 16 Nov 2020 09:48:31 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 03/13] tcp: factor out __tcp_close() helper
Date:   Mon, 16 Nov 2020 10:48:04 +0100
Message-Id: <42f5d69c2eef1b2cd427f46813f7045909d62b96.1605458224.git.pabeni@redhat.com>
In-Reply-To: <cover.1605458224.git.pabeni@redhat.com>
References: <cover.1605458224.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
index 8aee43ef0578..d5d22c411918 100644
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
index a40981e347c0..b285b338a019 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2420,13 +2420,12 @@ bool tcp_check_oom(struct sock *sk, int shift)
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
@@ -2590,6 +2589,12 @@ void tcp_close(struct sock *sk, long timeout)
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

