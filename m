Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A556EE246
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 14:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbjDYM5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 08:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbjDYM5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 08:57:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7414D319
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 05:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682427403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=YARZYYD8kywX+uZX3azGfX2IIahTfzqdbDAK8+7O+cc=;
        b=XQYiezNKEkPqxgEUDVHhPPYHpCi1nhyYhdjgFlhR2z4+dnytgEK//WDZ9G+tbYt93x+TMp
        9cDN066kEMJPoLXXQuwID/MUCA+3yv6TLZFOlaLRfrHZ4R0RmEvcDRI6J3uXPkhxzLe/IZ
        8XKPtVg0xXpudpo2D93Z1cN/4t7g5XA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-adOwmTlRPaGPOM5R12Qxwg-1; Tue, 25 Apr 2023 08:56:40 -0400
X-MC-Unique: adOwmTlRPaGPOM5R12Qxwg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1C503801F5E;
        Tue, 25 Apr 2023 12:56:39 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AD402027043;
        Tue, 25 Apr 2023 12:56:36 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
cc:     dhowells@redhat.com,
        syzbot+ebc945fdb4acd72cba78@syzkaller.appspotmail.com,
        Marc Dionne <marc.dionne@auristor.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] rxrpc: Fix potential data race in rxrpc_wait_to_be_connected()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <508132.1682427395.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 25 Apr 2023 13:56:35 +0100
Message-ID: <508133.1682427395@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

    =

Inside the loop in rxrpc_wait_to_be_connected() it checks call->error to
see if it should exit the loop without first checking the call state.  Thi=
s
is probably safe as if call->error is set, the call is dead anyway, but we
should probably wait for the call state to have been set to completion
first, lest it cause surprise on the way out.

Fix this by only accessing call->error if the call is complete.  We don't
actually need to access the error inside the loop as we'll do that after.

This caused the following report:

    BUG: KCSAN: data-race in rxrpc_send_data / rxrpc_set_call_completion

    write to 0xffff888159cf3c50 of 4 bytes by task 25673 on cpu 1:
     rxrpc_set_call_completion+0x71/0x1c0 net/rxrpc/call_state.c:22
     rxrpc_send_data_packet+0xba9/0x1650 net/rxrpc/output.c:479
     rxrpc_transmit_one+0x1e/0x130 net/rxrpc/output.c:714
     rxrpc_decant_prepared_tx net/rxrpc/call_event.c:326 [inline]
     rxrpc_transmit_some_data+0x496/0x600 net/rxrpc/call_event.c:350
     rxrpc_input_call_event+0x564/0x1220 net/rxrpc/call_event.c:464
     rxrpc_io_thread+0x307/0x1d80 net/rxrpc/io_thread.c:461
     kthread+0x1ac/0x1e0 kernel/kthread.c:376
     ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

    read to 0xffff888159cf3c50 of 4 bytes by task 25672 on cpu 0:
     rxrpc_send_data+0x29e/0x1950 net/rxrpc/sendmsg.c:296
     rxrpc_do_sendmsg+0xb7a/0xc20 net/rxrpc/sendmsg.c:726
     rxrpc_sendmsg+0x413/0x520 net/rxrpc/af_rxrpc.c:565
     sock_sendmsg_nosec net/socket.c:724 [inline]
     sock_sendmsg net/socket.c:747 [inline]
     ____sys_sendmsg+0x375/0x4c0 net/socket.c:2501
     ___sys_sendmsg net/socket.c:2555 [inline]
     __sys_sendmmsg+0x263/0x500 net/socket.c:2641
     __do_sys_sendmmsg net/socket.c:2670 [inline]
     __se_sys_sendmmsg net/socket.c:2667 [inline]
     __x64_sys_sendmmsg+0x57/0x60 net/socket.c:2667
     do_syscall_x64 arch/x86/entry/common.c:50 [inline]
     do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
     entry_SYSCALL_64_after_hwframe+0x63/0xcd

    value changed: 0x00000000 -> 0xffffffea

Fixes: 9d35d880e0e4 ("rxrpc: Move client call connection to the I/O thread=
")
Reported-by: syzbot+ebc945fdb4acd72cba78@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/000000000000e7c6d205fa10a3cd@google.com/
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Dmitry Vyukov <dvyukov@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
cc: netdev@vger.kernel.org
---
 net/rxrpc/sendmsg.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index da49fcf1c456..6caa47d352ed 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -50,15 +50,11 @@ static int rxrpc_wait_to_be_connected(struct rxrpc_cal=
l *call, long *timeo)
 	_enter("%d", call->debug_id);
 =

 	if (rxrpc_call_state(call) !=3D RXRPC_CALL_CLIENT_AWAIT_CONN)
-		return call->error;
+		goto no_wait;
 =

 	add_wait_queue_exclusive(&call->waitq, &myself);
 =

 	for (;;) {
-		ret =3D call->error;
-		if (ret < 0)
-			break;
-
 		switch (call->interruptibility) {
 		case RXRPC_INTERRUPTIBLE:
 		case RXRPC_PREINTERRUPTIBLE:
@@ -69,10 +65,9 @@ static int rxrpc_wait_to_be_connected(struct rxrpc_call=
 *call, long *timeo)
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			break;
 		}
-		if (rxrpc_call_state(call) !=3D RXRPC_CALL_CLIENT_AWAIT_CONN) {
-			ret =3D call->error;
+
+		if (rxrpc_call_state(call) !=3D RXRPC_CALL_CLIENT_AWAIT_CONN)
 			break;
-		}
 		if ((call->interruptibility =3D=3D RXRPC_INTERRUPTIBLE ||
 		     call->interruptibility =3D=3D RXRPC_PREINTERRUPTIBLE) &&
 		    signal_pending(current)) {
@@ -85,6 +80,7 @@ static int rxrpc_wait_to_be_connected(struct rxrpc_call =
*call, long *timeo)
 	remove_wait_queue(&call->waitq, &myself);
 	__set_current_state(TASK_RUNNING);
 =

+no_wait:
 	if (ret =3D=3D 0 && rxrpc_call_is_complete(call))
 		ret =3D call->error;
 =

