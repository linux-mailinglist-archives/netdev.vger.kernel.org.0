Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B50FD88545
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 23:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729381AbfHIVrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 17:47:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53960 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728576AbfHIVrt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 17:47:49 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0364FB2CD;
        Fri,  9 Aug 2019 21:47:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-255.rdu2.redhat.com [10.10.120.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5BA060BF3;
        Fri,  9 Aug 2019 21:47:47 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net] rxrpc: Fix local refcounting
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, jaltman@auristor.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 09 Aug 2019 22:47:47 +0100
Message-ID: <156538726702.16201.13552536596121161945.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 09 Aug 2019 21:47:49 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix rxrpc_unuse_local() to handle a NULL local pointer as it can be called
on an unbound socket on which rx->local is not yet set.

The following reproduced (includes omitted):

	int main(void)
	{
		socket(AF_RXRPC, SOCK_DGRAM, AF_INET);
		return 0;
	}

causes the following oops to occur:

	BUG: kernel NULL pointer dereference, address: 0000000000000010
	...
	RIP: 0010:rxrpc_unuse_local+0x8/0x1b
	...
	Call Trace:
	 rxrpc_release+0x2b5/0x338
	 __sock_release+0x37/0xa1
	 sock_close+0x14/0x17
	 __fput+0x115/0x1e9
	 task_work_run+0x72/0x98
	 do_exit+0x51b/0xa7a
	 ? __context_tracking_exit+0x4e/0x10e
	 do_group_exit+0xab/0xab
	 __x64_sys_exit_group+0x14/0x17
	 do_syscall_64+0x89/0x1d4
	 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Reported-by: syzbot+20dee719a2e090427b5f@syzkaller.appspotmail.com
Fixes: 730c5fd42c1e ("rxrpc: Fix local endpoint refcounting")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jeffrey Altman <jaltman@auristor.com>
---

 net/rxrpc/local_object.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 9798159ee65f..c9db3e762d8d 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -402,11 +402,13 @@ void rxrpc_unuse_local(struct rxrpc_local *local)
 {
 	unsigned int au;
 
-	au = atomic_dec_return(&local->active_users);
-	if (au == 0)
-		rxrpc_queue_local(local);
-	else
-		rxrpc_put_local(local);
+	if (local) {
+		au = atomic_dec_return(&local->active_users);
+		if (au == 0)
+			rxrpc_queue_local(local);
+		else
+			rxrpc_put_local(local);
+	}
 }
 
 /*

