Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C6C30741C
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 11:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhA1KuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 05:50:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34660 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231136AbhA1KuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 05:50:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611830922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=G4xP0TbwxS9wJ8k/dclQcOGAebS4EKugZ0baeO2h2DA=;
        b=F/XNMmOLkldWnb76qQM5b845hcq2duoNADLgBFQEhGSrxrsIri2EyB5U/oEHixyO98fJJm
        ywMuK1egZMlmczkkoXp7kDVqrYlcIQjSMVNxVKdC6fuex4E0W1N5oSB5M2ZzBpHdL6tJtV
        OkHZpXlLTIscbwwae78HLZ+ZUQg7zG0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-JbzL2-39NKWyF2aNsQz8zw-1; Thu, 28 Jan 2021 05:48:40 -0500
X-MC-Unique: JbzL2-39NKWyF2aNsQz8zw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09808107ACE6;
        Thu, 28 Jan 2021 10:48:39 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-23.rdu2.redhat.com [10.10.115.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D33A060C13;
        Thu, 28 Jan 2021 10:48:37 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net] rxrpc: Fix memory leak in rxrpc_lookup_local
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Takeshi Misawa <jeliantsurux@gmail.com>,
        syzbot+305326672fed51b205f7@syzkaller.appspotmail.com,
        dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 28 Jan 2021 10:48:36 +0000
Message-ID: <161183091692.3506637.3206605651502458810.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Takeshi Misawa <jeliantsurux@gmail.com>

Commit 9ebeddef58c4 ("rxrpc: rxrpc_peer needs to hold a ref on the rxrpc_local record")
Then release ref in __rxrpc_put_peer and rxrpc_put_peer_locked.

	struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *local, gfp_t gfp)
	-               peer->local = local;
	+               peer->local = rxrpc_get_local(local);

rxrpc_discard_prealloc also need ref release in discarding.

syzbot report:
BUG: memory leak
unreferenced object 0xffff8881080ddc00 (size 256):
  comm "syz-executor339", pid 8462, jiffies 4294942238 (age 12.350s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 0a 00 00 00 00 c0 00 08 81 88 ff ff  ................
  backtrace:
    [<000000002b6e495f>] kmalloc include/linux/slab.h:552 [inline]
    [<000000002b6e495f>] kzalloc include/linux/slab.h:682 [inline]
    [<000000002b6e495f>] rxrpc_alloc_local net/rxrpc/local_object.c:79 [inline]
    [<000000002b6e495f>] rxrpc_lookup_local+0x1c1/0x760 net/rxrpc/local_object.c:244
    [<000000006b43a77b>] rxrpc_bind+0x174/0x240 net/rxrpc/af_rxrpc.c:149
    [<00000000fd447a55>] afs_open_socket+0xdb/0x200 fs/afs/rxrpc.c:64
    [<000000007fd8867c>] afs_net_init+0x2b4/0x340 fs/afs/main.c:126
    [<0000000063d80ec1>] ops_init+0x4e/0x190 net/core/net_namespace.c:152
    [<00000000073c5efa>] setup_net+0xde/0x2d0 net/core/net_namespace.c:342
    [<00000000a6744d5b>] copy_net_ns+0x19f/0x3e0 net/core/net_namespace.c:483
    [<0000000017d3aec3>] create_new_namespaces+0x199/0x4f0 kernel/nsproxy.c:110
    [<00000000186271ef>] unshare_nsproxy_namespaces+0x9b/0x120 kernel/nsproxy.c:226
    [<000000002de7bac4>] ksys_unshare+0x2fe/0x5c0 kernel/fork.c:2957
    [<00000000349b12ba>] __do_sys_unshare kernel/fork.c:3025 [inline]
    [<00000000349b12ba>] __se_sys_unshare kernel/fork.c:3023 [inline]
    [<00000000349b12ba>] __x64_sys_unshare+0x12/0x20 kernel/fork.c:3023
    [<000000006d178ef7>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<00000000637076d4>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 9ebeddef58c4 ("rxrpc: rxrpc_peer needs to hold a ref on the rxrpc_local record")
Signed-off-by: Takeshi Misawa <jeliantsurux@gmail.com>
Reported-and-tested-by: syzbot+305326672fed51b205f7@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/call_accept.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 382add72c66f..1ae90fb97936 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -197,6 +197,7 @@ void rxrpc_discard_prealloc(struct rxrpc_sock *rx)
 	tail = b->peer_backlog_tail;
 	while (CIRC_CNT(head, tail, size) > 0) {
 		struct rxrpc_peer *peer = b->peer_backlog[tail];
+		rxrpc_put_local(peer->local);
 		kfree(peer);
 		tail = (tail + 1) & (size - 1);
 	}


