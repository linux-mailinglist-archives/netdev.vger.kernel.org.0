Return-Path: <netdev+bounces-2719-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9314A70347D
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:49:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FC432810EA
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 16:49:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DD55FBEC;
	Mon, 15 May 2023 16:49:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540EADF5E;
	Mon, 15 May 2023 16:49:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69DCC4339B;
	Mon, 15 May 2023 16:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169349;
	bh=4jSls9SEgL+5agkw266mNjGCuZcNspC+bOyWIa1yb6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kk4VFaSRFyahPWxvKpax6/RILTBAey9EVY5YahJj82+jATZik1JejB/+aUEVco+er
	 WMXF2SulHockieY7uZTLLKKKvT6njq0gJ2AiCV0fjLKAeXJcSKFn82nQ5TOOa5+LtI
	 FTMbTWw0IPqSTXl/0zMC+3IVEKXji2x/D6A7mGv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ebc945fdb4acd72cba78@syzkaller.appspotmail.com,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	netdev@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 022/246] rxrpc: Fix potential data race in rxrpc_wait_to_be_connected()
Date: Mon, 15 May 2023 18:23:54 +0200
Message-Id: <20230515161723.275161336@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 2b5fdc0f5caa505afe34d608e2eefadadf2ee67a ]

Inside the loop in rxrpc_wait_to_be_connected() it checks call->error to
see if it should exit the loop without first checking the call state.  This
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

Fixes: 9d35d880e0e4 ("rxrpc: Move client call connection to the I/O thread")
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
Link: https://lore.kernel.org/r/508133.1682427395@warthog.procyon.org.uk
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/sendmsg.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index da49fcf1c4567..6caa47d352ed6 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -50,15 +50,11 @@ static int rxrpc_wait_to_be_connected(struct rxrpc_call *call, long *timeo)
 	_enter("%d", call->debug_id);
 
 	if (rxrpc_call_state(call) != RXRPC_CALL_CLIENT_AWAIT_CONN)
-		return call->error;
+		goto no_wait;
 
 	add_wait_queue_exclusive(&call->waitq, &myself);
 
 	for (;;) {
-		ret = call->error;
-		if (ret < 0)
-			break;
-
 		switch (call->interruptibility) {
 		case RXRPC_INTERRUPTIBLE:
 		case RXRPC_PREINTERRUPTIBLE:
@@ -69,10 +65,9 @@ static int rxrpc_wait_to_be_connected(struct rxrpc_call *call, long *timeo)
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			break;
 		}
-		if (rxrpc_call_state(call) != RXRPC_CALL_CLIENT_AWAIT_CONN) {
-			ret = call->error;
+
+		if (rxrpc_call_state(call) != RXRPC_CALL_CLIENT_AWAIT_CONN)
 			break;
-		}
 		if ((call->interruptibility == RXRPC_INTERRUPTIBLE ||
 		     call->interruptibility == RXRPC_PREINTERRUPTIBLE) &&
 		    signal_pending(current)) {
@@ -85,6 +80,7 @@ static int rxrpc_wait_to_be_connected(struct rxrpc_call *call, long *timeo)
 	remove_wait_queue(&call->waitq, &myself);
 	__set_current_state(TASK_RUNNING);
 
+no_wait:
 	if (ret == 0 && rxrpc_call_is_complete(call))
 		ret = call->error;
 
-- 
2.39.2




