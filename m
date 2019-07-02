Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE0C5D23A
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 16:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfGBO7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 10:59:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53531 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbfGBO7T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 10:59:19 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ED90585A03;
        Tue,  2 Jul 2019 14:59:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-219.rdu2.redhat.com [10.10.120.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D8AB7854B;
        Tue,  2 Jul 2019 14:59:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net] rxrpc: Fix send on a connected, but unbound socket
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     syzbot+7966f2a0b2c7da8939b4@syzkaller.appspotmail.com,
        Marc Dionne <marc.dionne@auristor.com>, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 02 Jul 2019 15:59:12 +0100
Message-ID: <156207955265.1655.13658692984261290810.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 02 Jul 2019 14:59:18 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If sendmsg() or sendmmsg() is called on a connected socket that hasn't had
bind() called on it, then an oops will occur when the kernel tries to
connect the call because no local endpoint has been allocated.

Fix this by implicitly binding the socket if it is in the
RXRPC_CLIENT_UNBOUND state, just like it does for the RXRPC_UNBOUND state.

Further, the state should be transitioned to RXRPC_CLIENT_BOUND after this
to prevent further attempts to bind it.

This can be tested with:

	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <sys/socket.h>
	#include <arpa/inet.h>
	#include <linux/rxrpc.h>
	static const unsigned char inet6_addr[16] = {
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0xac, 0x14, 0x14, 0xaa
	};
	int main(void)
	{
		struct sockaddr_rxrpc srx;
		struct cmsghdr *cm;
		struct msghdr msg;
		unsigned char control[16];
		int fd;
		memset(&srx, 0, sizeof(srx));
		srx.srx_family = 0x21;
		srx.srx_service = 0;
		srx.transport_type = AF_INET;
		srx.transport_len = 0x1c;
		srx.transport.sin6.sin6_family = AF_INET6;
		srx.transport.sin6.sin6_port = htons(0x4e22);
		srx.transport.sin6.sin6_flowinfo = htons(0x4e22);
		srx.transport.sin6.sin6_scope_id = htons(0xaa3b);
		memcpy(&srx.transport.sin6.sin6_addr, inet6_addr, 16);
		cm = (struct cmsghdr *)control;
		cm->cmsg_len	= CMSG_LEN(sizeof(unsigned long));
		cm->cmsg_level	= SOL_RXRPC;
		cm->cmsg_type	= RXRPC_USER_CALL_ID;
		*(unsigned long *)CMSG_DATA(cm) = 0;
		msg.msg_name = NULL;
		msg.msg_namelen = 0;
		msg.msg_iov = NULL;
		msg.msg_iovlen = 0;
		msg.msg_control = control;
		msg.msg_controllen = cm->cmsg_len;
		msg.msg_flags = 0;
		fd = socket(AF_RXRPC, SOCK_DGRAM, AF_INET);
		connect(fd, (struct sockaddr *)&srx, sizeof(srx));
		sendmsg(fd, &msg, 0);
		return 0;
	}


Leading to the following oops:

	BUG: kernel NULL pointer dereference, address: 0000000000000018
	#PF: supervisor read access in kernel mode
	#PF: error_code(0x0000) - not-present page
	...
	RIP: 0010:rxrpc_connect_call+0x42/0xa01
	...
	Call Trace:
	 ? mark_held_locks+0x47/0x59
	 ? __local_bh_enable_ip+0xb6/0xba
	 rxrpc_new_client_call+0x3b1/0x762
	 ? rxrpc_do_sendmsg+0x3c0/0x92e
	 rxrpc_do_sendmsg+0x3c0/0x92e
	 rxrpc_sendmsg+0x16b/0x1b5
	 sock_sendmsg+0x2d/0x39
	 ___sys_sendmsg+0x1a4/0x22a
	 ? release_sock+0x19/0x9e
	 ? reacquire_held_locks+0x136/0x160
	 ? release_sock+0x19/0x9e
	 ? find_held_lock+0x2b/0x6e
	 ? __lock_acquire+0x268/0xf73
	 ? rxrpc_connect+0xdd/0xe4
	 ? __local_bh_enable_ip+0xb6/0xba
	 __sys_sendmsg+0x5e/0x94
	 do_syscall_64+0x7d/0x1bf
	 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fixes: 2341e0775747 ("rxrpc: Simplify connect() implementation and simplify sendmsg() op")
Reported-by: syzbot+7966f2a0b2c7da8939b4@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
---

 net/rxrpc/af_rxrpc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index f9f4721cdfa7..d09eaf153544 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -545,6 +545,7 @@ static int rxrpc_sendmsg(struct socket *sock, struct msghdr *m, size_t len)
 
 	switch (rx->sk.sk_state) {
 	case RXRPC_UNBOUND:
+	case RXRPC_CLIENT_UNBOUND:
 		rx->srx.srx_family = AF_RXRPC;
 		rx->srx.srx_service = 0;
 		rx->srx.transport_type = SOCK_DGRAM;
@@ -569,10 +570,9 @@ static int rxrpc_sendmsg(struct socket *sock, struct msghdr *m, size_t len)
 		}
 
 		rx->local = local;
-		rx->sk.sk_state = RXRPC_CLIENT_UNBOUND;
+		rx->sk.sk_state = RXRPC_CLIENT_BOUND;
 		/* Fall through */
 
-	case RXRPC_CLIENT_UNBOUND:
 	case RXRPC_CLIENT_BOUND:
 		if (!m->msg_name &&
 		    test_bit(RXRPC_SOCK_CONNECTED, &rx->flags)) {

