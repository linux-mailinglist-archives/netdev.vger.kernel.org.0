Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F2164DE7C
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 17:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiLOQWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 11:22:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiLOQVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 11:21:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E78A19C3B
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 08:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671121246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DF86rSgR/dRc7PKGJd14IVV3jKd8aO5w6wnfL8h5Kog=;
        b=HSUAseWK5arqjpvknhxMPM19ZCd4eErZyqFCpzqcrQ6mMV2m+GRg2CrD0WhGcC/B5Jw44E
        YnJWRu0MVmz4esSOgb6aCGwFurp/f1ynIvksTj0Hw/1+sNQ8brUD8W+Im1pYxK6zjaFUSH
        ObvBRvUtVbimq2zMwhHNHQxDtUzZb64=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-30-wAYdqCbsMmOh9WEy3iHy5A-1; Thu, 15 Dec 2022 11:20:42 -0500
X-MC-Unique: wAYdqCbsMmOh9WEy3iHy5A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF91318A6484;
        Thu, 15 Dec 2022 16:20:41 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10D7A400F58;
        Thu, 15 Dec 2022 16:20:40 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 7/9] rxrpc: Fix I/O thread stop
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Thu, 15 Dec 2022 16:20:38 +0000
Message-ID: <167112123846.152641.13678238089457654453.stgit@warthog.procyon.org.uk>
In-Reply-To: <167112117887.152641.6194213035340041732.stgit@warthog.procyon.org.uk>
References: <167112117887.152641.6194213035340041732.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rxrpc I/O thread checks to see if there's any work it needs to do, and
if not, checks kthread_should_stop() before scheduling, and if it should
stop, breaks out of the loop and tries to clean up and exit.

This can, however, race with socket destruction, wherein outstanding calls
are aborted and released from the socket and then the socket unuses the
local endpoint, causing kthread_stop() to be issued.  The abort is deferred
to the I/O thread and the event can by issued between the I/O thread
checking if there's any work to be done (such as processing call aborts)
and the stop being seen.

This results in the I/O thread stopping processing of events whilst call
cleanup events are still outstanding, leading to connections or other
objects still being around and uncleaned up, which can result in assertions
being triggered, e.g.:

    rxrpc: AF_RXRPC: Leaked client conn 00000000e8009865 {2}
    ------------[ cut here ]------------
    kernel BUG at net/rxrpc/conn_client.c:64!

Fix this by retrieving the kthread_should_stop() indication, then checking
to see if there's more work to do, and going back round the loop if there
is, and breaking out of the loop only if there wasn't.

This was triggered by a syzbot test that produced some other symptom[1].

Fixes: a275da62e8c1 ("rxrpc: Create a per-local endpoint receive queue and I/O thread")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/0000000000002b4a9f05ef2b616f@google.com/ [1]
---

 net/rxrpc/io_thread.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/io_thread.c b/net/rxrpc/io_thread.c
index e460e4151c16..e6b9f0ceae17 100644
--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -425,6 +425,7 @@ int rxrpc_io_thread(void *data)
 	struct rxrpc_local *local = data;
 	struct rxrpc_call *call;
 	struct sk_buff *skb;
+	bool should_stop;
 
 	complete(&local->io_thread_ready);
 
@@ -478,13 +479,14 @@ int rxrpc_io_thread(void *data)
 		}
 
 		set_current_state(TASK_INTERRUPTIBLE);
+		should_stop = kthread_should_stop();
 		if (!skb_queue_empty(&local->rx_queue) ||
 		    !list_empty(&local->call_attend_q)) {
 			__set_current_state(TASK_RUNNING);
 			continue;
 		}
 
-		if (kthread_should_stop())
+		if (should_stop)
 			break;
 		schedule();
 	}


