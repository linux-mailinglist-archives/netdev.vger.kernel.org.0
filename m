Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06CB91EE8EF
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 18:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729925AbgFDQ4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 12:56:07 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31254 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729115AbgFDQ4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 12:56:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591289766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ic9chV3qlsicmKxZDeN+UQKJUnIq9nEV6lAatrjd5vU=;
        b=Yf48K6XOO/QWMl1pMjX0hRsUQHn/PSeQ2fPKW7iLI2bzOU0nTSyB1tX267g7bCpUuE6tBS
        q6giCjDDvdHrN3Mhv0yMAN7SyGIwdArszmjT0xH3McCnT4mjl3wxHetiVBmzbUX8X7eg6N
        rfJWYTKUZoz43dTezVpI8Yop010PcUc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-L-ome2JbOXqcRDANW5mYTQ-1; Thu, 04 Jun 2020 12:56:04 -0400
X-MC-Unique: L-ome2JbOXqcRDANW5mYTQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7BCD1902EA4;
        Thu,  4 Jun 2020 16:56:02 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.40.192.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7814110002A6;
        Thu,  4 Jun 2020 16:56:00 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Eric Dumazet <edumazet@google.com>,
        Christoph Paasch <cpaasch@apple.com>
Subject: [PATCH net] inet_connection_sock: clear inet_num out of destroy helper
Date:   Thu,  4 Jun 2020 18:55:45 +0200
Message-Id: <cc2adbd7dcc17c44e2858e550302906760b38a0b.1591289527.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clearing the 'inet_num' field is necessary and safe if and
only if the socket is not bound. The MPTCP protocol calls
the destroy helper on bound sockets, as tcp_v{4,6}_syn_recv_sock
completed successfully.

Move the clearing of such field out of the common code, otherwise
the MPTCP MP_JOIN error path will find the wrong 'inet_num' value
on socket disposal, __inet_put_port() will acquire the wrong lock
and bind_node removal could race with other modifiers possibly
corrupting the bind hash table.

Reported-and-tested-by: Christoph Paasch <cpaasch@apple.com>
Fixes: 729cd6436f35 ("mptcp: cope better with MP_JOIN failure")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/inet_connection_sock.h | 1 -
 net/ipv4/inet_connection_sock.c    | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 2f1f8c3efb26..e5b388f5fa20 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -292,7 +292,6 @@ static inline void inet_csk_prepare_for_destroy_sock(struct sock *sk)
 	/* The below has to be done to allow calling inet_csk_destroy_sock */
 	sock_set_flag(sk, SOCK_DEAD);
 	percpu_counter_inc(sk->sk_prot->orphan_count);
-	inet_sk(sk)->inet_num = 0;
 }
 
 void inet_csk_destroy_sock(struct sock *sk);
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index f40b1b72f979..afaf582a5aa9 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -902,6 +902,7 @@ void inet_csk_prepare_forced_close(struct sock *sk)
 	bh_unlock_sock(sk);
 	sock_put(sk);
 	inet_csk_prepare_for_destroy_sock(sk);
+	inet_sk(sk)->inet_num = 0;
 }
 EXPORT_SYMBOL(inet_csk_prepare_forced_close);
 
-- 
2.21.3

