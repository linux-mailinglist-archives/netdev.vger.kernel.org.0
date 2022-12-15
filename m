Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E9F64DE72
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 17:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiLOQVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 11:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiLOQU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 11:20:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FD931DE4
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 08:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671121220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4DbYOpVKGqZ5scXWg56uxXk7BwnWmrowQWZvgmfyqEk=;
        b=Lz8YjAo9vmPU5zadB10mTmc/EKi5YdtTy973vSp/aHdf3VyUAFY36fVDNMgkqZFK/oj+1I
        /yxkPcOtiHnc0+Qwueeu+5MB0AdFkWdcYDxqvzFs68OdQnoqZg/gPBLZziAuzqcaS+hkYD
        zk6JE8E32OQCWw7n2oTjWsPhW+ocZ9Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-PvLxAIjDOXScJCB7g925bg-1; Thu, 15 Dec 2022 11:20:17 -0500
X-MC-Unique: PvLxAIjDOXScJCB7g925bg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82E828030DD;
        Thu, 15 Dec 2022 16:20:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9517B4085720;
        Thu, 15 Dec 2022 16:20:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 4/9] rxrpc: Fix I/O thread startup getting skipped
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     syzbot+3538a6a72efa8b059c38@syzkaller.appspotmail.com,
        Marc Dionne <marc.dionne@auristor.com>,
        Hillf Danton <hdanton@sina.com>, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Thu, 15 Dec 2022 16:20:13 +0000
Message-ID: <167112121304.152641.6427798169346167745.stgit@warthog.procyon.org.uk>
In-Reply-To: <167112117887.152641.6194213035340041732.stgit@warthog.procyon.org.uk>
References: <167112117887.152641.6194213035340041732.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When starting a kthread, the __kthread_create_on_node() function, as called
from kthread_run(), waits for a completion to indicate that the task_struct
(or failure state) of the new kernel thread is available before continuing.

This does not wait, however, for the thread function to be invoked and,
indeed, will skip it if kthread_stop() gets called before it gets there.

If this happens, though, kthread_run() will have returned successfully,
indicating that the thread was started and returning the task_struct
pointer.  The actual error indication is returned by kthread_stop().

Note that this is ambiguous, as the caller cannot tell whether the -EINTR
error code came from kthread() or from the thread function.

This was encountered in the new rxrpc I/O thread, where if the system is
being pounded hard by, say, syzbot, the check of KTHREAD_SHOULD_STOP can be
delayed long enough for kthread_stop() to get called when rxrpc releases a
socket - and this causes an oops because the I/O thread function doesn't
get started and thus doesn't remove the rxrpc_local struct from the
local_endpoints list.

Fix this by using a completion to wait for the thread to actually enter
rxrpc_io_thread().  This makes sure the thread can't be prematurely
stopped and makes sure the relied-upon cleanup is done.

Fixes: a275da62e8c1 ("rxrpc: Create a per-local endpoint receive queue and I/O thread")
Reported-by: syzbot+3538a6a72efa8b059c38@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Hillf Danton <hdanton@sina.com>
Link: https://lore.kernel.org/r/000000000000229f1505ef2b6159@google.com/
---

 net/rxrpc/ar-internal.h  |    1 +
 net/rxrpc/io_thread.c    |    2 ++
 net/rxrpc/local_object.c |    2 ++
 3 files changed, 5 insertions(+)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index e7dccab7b741..37f3aec784cc 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -287,6 +287,7 @@ struct rxrpc_local {
 	struct hlist_node	link;
 	struct socket		*socket;	/* my UDP socket */
 	struct task_struct	*io_thread;
+	struct completion	io_thread_ready; /* Indication that the I/O thread started */
 	struct rxrpc_sock __rcu	*service;	/* Service(s) listening on this endpoint */
 	struct rw_semaphore	defrag_sem;	/* control re-enablement of IP DF bit */
 	struct sk_buff_head	rx_queue;	/* Received packets */
diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index d83ae3193032..e460e4151c16 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -426,6 +426,8 @@ int rxrpc_io_thread(void *data)
 	struct rxrpc_call *call;
 	struct sk_buff *skb;
 
+	complete(&local->io_thread_ready);
+
 	skb_queue_head_init(&rx_queue);
 
 	set_user_nice(current, MIN_NICE);
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 24ee585d9aaf..270b63d8f37a 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -97,6 +97,7 @@ static struct rxrpc_local *rxrpc_alloc_local(struct rxrpc_net *rxnet,
 		local->rxnet = rxnet;
 		INIT_HLIST_NODE(&local->link);
 		init_rwsem(&local->defrag_sem);
+		init_completion(&local->io_thread_ready);
 		skb_queue_head_init(&local->rx_queue);
 		INIT_LIST_HEAD(&local->call_attend_q);
 		local->client_bundles = RB_ROOT;
@@ -189,6 +190,7 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 		goto error_sock;
 	}
 
+	wait_for_completion(&local->io_thread_ready);
 	local->io_thread = io_thread;
 	_leave(" = 0");
 	return 0;


