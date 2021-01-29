Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C533090C9
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 00:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhA2XzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 18:55:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46853 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231199AbhA2XzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 18:55:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611964435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=q039E6qRHMWcEvS57m0H092hcBFMkfO15L+0InB6KMY=;
        b=a6BCdsudDJeI0hSzI/hdMhA2/W9kGU0SQUO97Vtg3BsxKJY6QqAc4zHZT+oH1oUT6QAuWb
        YbJ0GY/XBoUNmCEvEr9O+qjEmBL5Jnjp6y7Hn5B+9VhZaOGEEVDNoR+ro8PW76iJkAG7zJ
        1MoH1a1OSUC0YP48gP/1Ny5QJii4Fhg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-wQPqnrndOFmV70fhnBJ3Yg-1; Fri, 29 Jan 2021 18:53:53 -0500
X-MC-Unique: wQPqnrndOFmV70fhnBJ3Yg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BD4D10054FF;
        Fri, 29 Jan 2021 23:53:52 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-23.rdu2.redhat.com [10.10.115.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34E735D71B;
        Fri, 29 Jan 2021 23:53:50 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net] rxrpc: Fix deadlock around release of dst cached on udp
 tunnel
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     syzbot+df400f2f24a1677cd7e0@syzkaller.appspotmail.com,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Vadim Fedorenko <vfedorenko@novek.ru>, vfedorenko@novek.ru,
        dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 29 Jan 2021 23:53:50 +0000
Message-ID: <161196443016.3868642.5577440140646403533.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AF_RXRPC sockets use UDP ports in encap mode.  This causes socket and dst
from an incoming packet to get stolen and attached to the UDP socket from
whence it is leaked when that socket is closed.

When a network namespace is removed, the wait for dst records to be cleaned
up happens before the cleanup of the rxrpc and UDP socket, meaning that the
wait never finishes.

Fix this by moving the rxrpc (and, by dependence, the afs) private
per-network namespace registrations to the device group rather than subsys
group.  This allows cached rxrpc local endpoints to be cleared and their
UDP sockets closed before we try waiting for the dst records.

The symptom is that lines looking like the following:

	unregister_netdevice: waiting for lo to become free

get emitted at regular intervals after running something like the
referenced syzbot test.

Thanks to Vadim for tracking this down and work out the fix.

Reported-by: syzbot+df400f2f24a1677cd7e0@syzkaller.appspotmail.com
Reported-by: Vadim Fedorenko <vfedorenko@novek.ru>
Fixes: 5271953cad31 ("rxrpc: Use the UDP encap_rcv hook")
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Vadim Fedorenko <vfedorenko@novek.ru>
---

 fs/afs/main.c        |    6 +++---
 net/rxrpc/af_rxrpc.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/afs/main.c b/fs/afs/main.c
index accdd8970e7c..b2975256dadb 100644
--- a/fs/afs/main.c
+++ b/fs/afs/main.c
@@ -193,7 +193,7 @@ static int __init afs_init(void)
 		goto error_cache;
 #endif
 
-	ret = register_pernet_subsys(&afs_net_ops);
+	ret = register_pernet_device(&afs_net_ops);
 	if (ret < 0)
 		goto error_net;
 
@@ -213,7 +213,7 @@ static int __init afs_init(void)
 error_proc:
 	afs_fs_exit();
 error_fs:
-	unregister_pernet_subsys(&afs_net_ops);
+	unregister_pernet_device(&afs_net_ops);
 error_net:
 #ifdef CONFIG_AFS_FSCACHE
 	fscache_unregister_netfs(&afs_cache_netfs);
@@ -244,7 +244,7 @@ static void __exit afs_exit(void)
 
 	proc_remove(afs_proc_symlink);
 	afs_fs_exit();
-	unregister_pernet_subsys(&afs_net_ops);
+	unregister_pernet_device(&afs_net_ops);
 #ifdef CONFIG_AFS_FSCACHE
 	fscache_unregister_netfs(&afs_cache_netfs);
 #endif
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 0a2f4817ec6c..41671af6b33f 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -990,7 +990,7 @@ static int __init af_rxrpc_init(void)
 		goto error_security;
 	}
 
-	ret = register_pernet_subsys(&rxrpc_net_ops);
+	ret = register_pernet_device(&rxrpc_net_ops);
 	if (ret)
 		goto error_pernet;
 
@@ -1035,7 +1035,7 @@ static int __init af_rxrpc_init(void)
 error_sock:
 	proto_unregister(&rxrpc_proto);
 error_proto:
-	unregister_pernet_subsys(&rxrpc_net_ops);
+	unregister_pernet_device(&rxrpc_net_ops);
 error_pernet:
 	rxrpc_exit_security();
 error_security:
@@ -1057,7 +1057,7 @@ static void __exit af_rxrpc_exit(void)
 	unregister_key_type(&key_type_rxrpc);
 	sock_unregister(PF_RXRPC);
 	proto_unregister(&rxrpc_proto);
-	unregister_pernet_subsys(&rxrpc_net_ops);
+	unregister_pernet_device(&rxrpc_net_ops);
 	ASSERTCMP(atomic_read(&rxrpc_n_tx_skbs), ==, 0);
 	ASSERTCMP(atomic_read(&rxrpc_n_rx_skbs), ==, 0);
 


