Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211A630D589
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 09:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbhBCIte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 03:49:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59065 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232863AbhBCIta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 03:49:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612342083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=UV1mOlb0sZPvzlG9rQctRNEJYv8z9raqJ6JgD1LMKwk=;
        b=EUtcSBbut5NvtwMg5geaLQWREpKpToAxVH+BO3yrZl32oPigCNRGEXtb9agaOLfKZtu9je
        iUAXwH2uezdJ0HLNjGNj1qX5L4BEwGNiv02yTNx8voWg4vmYeI1F+SmnCwqdHf2mJWCAWw
        fGcRn4A9oxed4lCSKZ3DsW7q8nYyGm4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-5xy14DUgOiuhr2TvWxlV9g-1; Wed, 03 Feb 2021 03:47:59 -0500
X-MC-Unique: 5xy14DUgOiuhr2TvWxlV9g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 580E99CC03;
        Wed,  3 Feb 2021 08:47:58 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-23.rdu2.redhat.com [10.10.115.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F348871C85;
        Wed,  3 Feb 2021 08:47:56 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net] rxrpc: Fix clearance of Tx/Rx ring when releasing a call
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     syzbot+174de899852504e4a74a@syzkaller.appspotmail.com,
        syzbot+3d1c772efafd3c38d007@syzkaller.appspotmail.com,
        Hillf Danton <hdanton@sina.com>, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 03 Feb 2021 08:47:56 +0000
Message-ID: <161234207610.653119.5287360098400436976.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the end of rxrpc_release_call(), rxrpc_cleanup_ring() is called to clear
the Rx/Tx skbuff ring, but this doesn't lock the ring whilst it's accessing
it.  Unfortunately, rxrpc_resend() might be trying to retransmit a packet
concurrently with this - and whilst it does lock the ring, this isn't
protection against rxrpc_cleanup_call().

Fix this by removing the call to rxrpc_cleanup_ring() from
rxrpc_release_call().  rxrpc_cleanup_ring() will be called again anyway
from rxrpc_cleanup_call().  The earlier call is just an optimisation to
recycle skbuffs more quickly.

Alternative solutions include rxrpc_release_call() could try to cancel the
work item or wait for it to complete or rxrpc_cleanup_ring() could lock
when accessing the ring (which would require a bh lock).

This can produce a report like the following:

  BUG: KASAN: use-after-free in rxrpc_send_data_packet+0x19b4/0x1e70 net/rxrpc/output.c:372
  Read of size 4 at addr ffff888011606e04 by task kworker/0:0/5
  ...
  Workqueue: krxrpcd rxrpc_process_call
  Call Trace:
   ...
   kasan_report.cold+0x79/0xd5 mm/kasan/report.c:413
   rxrpc_send_data_packet+0x19b4/0x1e70 net/rxrpc/output.c:372
   rxrpc_resend net/rxrpc/call_event.c:266 [inline]
   rxrpc_process_call+0x1634/0x1f60 net/rxrpc/call_event.c:412
   process_one_work+0x98d/0x15f0 kernel/workqueue.c:2275
   ...

  Allocated by task 2318:
   ...
   sock_alloc_send_pskb+0x793/0x920 net/core/sock.c:2348
   rxrpc_send_data+0xb51/0x2bf0 net/rxrpc/sendmsg.c:358
   rxrpc_do_sendmsg+0xc03/0x1350 net/rxrpc/sendmsg.c:744
   rxrpc_sendmsg+0x420/0x630 net/rxrpc/af_rxrpc.c:560
   ...

  Freed by task 2318:
   ...
   kfree_skb+0x140/0x3f0 net/core/skbuff.c:704
   rxrpc_free_skb+0x11d/0x150 net/rxrpc/skbuff.c:78
   rxrpc_cleanup_ring net/rxrpc/call_object.c:485 [inline]
   rxrpc_release_call+0x5dd/0x860 net/rxrpc/call_object.c:552
   rxrpc_release_calls_on_socket+0x21c/0x300 net/rxrpc/call_object.c:579
   rxrpc_release_sock net/rxrpc/af_rxrpc.c:885 [inline]
   rxrpc_release+0x263/0x5a0 net/rxrpc/af_rxrpc.c:916
   __sock_release+0xcd/0x280 net/socket.c:597
   ...

  The buggy address belongs to the object at ffff888011606dc0
   which belongs to the cache skbuff_head_cache of size 232

Fixes: 248f219cb8bc ("rxrpc: Rewrite the data and ack handling code")
Reported-by: syzbot+174de899852504e4a74a@syzkaller.appspotmail.com
Reported-by: syzbot+3d1c772efafd3c38d007@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Hillf Danton <hdanton@sina.com>
---

 net/rxrpc/call_object.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index c845594b663f..4eb91d958a48 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -548,8 +548,6 @@ void rxrpc_release_call(struct rxrpc_sock *rx, struct rxrpc_call *call)
 		rxrpc_disconnect_call(call);
 	if (call->security)
 		call->security->free_call_crypto(call);
-
-	rxrpc_cleanup_ring(call);
 	_leave("");
 }
 


