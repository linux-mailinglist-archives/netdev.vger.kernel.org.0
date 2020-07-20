Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B61B225D98
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 13:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgGTLly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 07:41:54 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58638 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727887AbgGTLly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 07:41:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595245312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9BjEoccwDObYkvGGdqWSZpoF9EidBez5eJ1httHSghI=;
        b=KHoe2U7WeG0i68RMn0BigyME2r9w7lFBMgbn3e8sFlcpYWsSAMLAEDOBmd/eQw3UfVZPUE
        SBCbiKuKsijqXjb+dvHorDMJBuMFtgL5NPb5q99+KuVLO5D5F4Ht31vGkVgBMOuI0FLFtx
        ZCr9UpYjmFwWVGtPlqrOqSExteGfjNM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-ku6p1qM-NbSF5QOiH-mibQ-1; Mon, 20 Jul 2020 07:41:50 -0400
X-MC-Unique: ku6p1qM-NbSF5QOiH-mibQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95D641085;
        Mon, 20 Jul 2020 11:41:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-32.rdu2.redhat.com [10.10.112.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A641A87313;
        Mon, 20 Jul 2020 11:41:47 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net] rxrpc: Fix sendmsg() returning EPIPE due to recvmsg()
 returning ENODATA
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 20 Jul 2020 12:41:46 +0100
Message-ID: <159524530669.329784.1191492556041235335.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rxrpc_sendmsg() returns EPIPE if there's an outstanding error, such as if
rxrpc_recvmsg() indicating ENODATA if there's nothing for it to read.

Change rxrpc_recvmsg() to return EAGAIN instead if there's nothing to read
as this particular error doesn't get stored in ->sk_err by the networking
core.

Also change rxrpc_sendmsg() so that it doesn't fail with delayed receive
errors (there's no way for it to report which call, if any, the error was
caused by).

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/recvmsg.c |    2 +-
 net/rxrpc/sendmsg.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index 2989742a4aa1..490b1927215c 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -543,7 +543,7 @@ int rxrpc_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	    list_empty(&rx->recvmsg_q) &&
 	    rx->sk.sk_state != RXRPC_SERVER_LISTENING) {
 		release_sock(&rx->sk);
-		return -ENODATA;
+		return -EAGAIN;
 	}
 
 	if (list_empty(&rx->recvmsg_q)) {
diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 1304b8608f56..03a30d014bb6 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -304,7 +304,7 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 	/* this should be in poll */
 	sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
 
-	if (sk->sk_err || (sk->sk_shutdown & SEND_SHUTDOWN))
+	if (sk->sk_shutdown & SEND_SHUTDOWN)
 		return -EPIPE;
 
 	more = msg->msg_flags & MSG_MORE;


