Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC152691CB
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbgINQj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:39:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21633 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726088AbgINPbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 11:31:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600097495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H3sn64PFkwgj9VKWMl1MWTgWES+M38mznU34Z/iwPWA=;
        b=UMctG+PBqwAOp/O38YIEfZSPadiJpxmPn1lq3wOSIAt9byR9rIcR7A0+fjLtDp4eG69oIB
        xpAu+DxafqaCdmhLM3r2mltUXMNqEqhXA57X4ZLrMOV8IuKIQx+vY4aViMSSNuOHFp3/qE
        iY56M66TlgIBeBs5JqC3w9EaziVln0w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-ogwroWsfOwm38V6S7Db61Q-1; Mon, 14 Sep 2020 11:31:29 -0400
X-MC-Unique: ogwroWsfOwm38V6S7Db61Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED80B80EDB0;
        Mon, 14 Sep 2020 15:31:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-6.rdu2.redhat.com [10.10.113.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CAA55D9DC;
        Mon, 14 Sep 2020 15:31:14 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 4/5] rxrpc: Fix conn bundle leak in net-namespace
 exit
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 14 Sep 2020 16:31:14 +0100
Message-ID: <160009747424.1014072.2463414249066927982.stgit@warthog.procyon.org.uk>
In-Reply-To: <160009744625.1014072.11957943055200732444.stgit@warthog.procyon.org.uk>
References: <160009744625.1014072.11957943055200732444.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the network namespace exits, rxrpc_clean_up_local_conns() needs to
unbundle each client connection it evicts.  Fix it to do this.

kernel BUG at net/rxrpc/conn_object.c:481!
RIP: 0010:rxrpc_destroy_all_connections.cold+0x11/0x13 net/rxrpc/conn_object.c:481
Call Trace:
 rxrpc_exit_net+0x1a4/0x2e0 net/rxrpc/net_ns.c:119
 ops_exit_list+0xb0/0x160 net/core/net_namespace.c:186
 cleanup_net+0x4ea/0xa00 net/core/net_namespace.c:603
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Fixes: 245500d853e9 ("rxrpc: Rewrite the client connection manager")
Reported-by: syzbot+52071f826a617b9c76ed@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/conn_client.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 180be4da8d26..0eb36ba52485 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -1112,6 +1112,7 @@ void rxrpc_clean_up_local_conns(struct rxrpc_local *local)
 		conn = list_entry(graveyard.next,
 				  struct rxrpc_connection, cache_link);
 		list_del_init(&conn->cache_link);
+		rxrpc_unbundle_conn(conn);
 		rxrpc_put_connection(conn);
 	}
 


