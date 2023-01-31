Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8593683373
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 18:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbjAaRN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 12:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231919AbjAaRNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 12:13:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801A353E6C
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 09:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675185163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j1lXQHsaAbWcsJQO5nY7N03i/YDSxEw0AXdAKk8e3hQ=;
        b=IAXJEPwfRhzOtnuCoSbKstXaTNejC1yHtRKWBbFVBkMj2KLnoCXkEQ6RBTxXfh+D7pm2gd
        KxUJc+AFdqfomelzipXIoP6eTu/WUzevaY6No0Y+tIL55cvwRuTv+NIPfbHDce+FK4U7cF
        EL2wGt4Oj/sFkFfjFOO3Mx7dVWPL/6I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-207-MYvx5GMcPImWdouy3JYrLA-1; Tue, 31 Jan 2023 12:12:40 -0500
X-MC-Unique: MYvx5GMcPImWdouy3JYrLA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3A6C18ABFA5;
        Tue, 31 Jan 2023 17:12:32 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA87D1431C5B;
        Tue, 31 Jan 2023 17:12:31 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 01/13] rxrpc: Fix trace string
Date:   Tue, 31 Jan 2023 17:12:15 +0000
Message-Id: <20230131171227.3912130-2-dhowells@redhat.com>
In-Reply-To: <20230131171227.3912130-1-dhowells@redhat.com>
References: <20230131171227.3912130-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a trace string to indicate that it's discarding the local endpoint for
a preallocated peer, not a preallocated connection.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---
 include/trace/events/rxrpc.h | 2 +-
 net/rxrpc/call_accept.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 283db0ea3db4..31524d605319 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -163,7 +163,7 @@
 	EM(rxrpc_local_put_for_use,		"PUT for-use ") \
 	EM(rxrpc_local_put_kill_conn,		"PUT conn-kil") \
 	EM(rxrpc_local_put_peer,		"PUT peer    ") \
-	EM(rxrpc_local_put_prealloc_conn,	"PUT conn-pre") \
+	EM(rxrpc_local_put_prealloc_peer,	"PUT peer-pre") \
 	EM(rxrpc_local_put_release_sock,	"PUT rel-sock") \
 	EM(rxrpc_local_stop,			"STOP        ") \
 	EM(rxrpc_local_stopped,			"STOPPED     ") \
diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 3e8689fdc437..0f5a1d77b890 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -195,7 +195,7 @@ void rxrpc_discard_prealloc(struct rxrpc_sock *rx)
 	tail = b->peer_backlog_tail;
 	while (CIRC_CNT(head, tail, size) > 0) {
 		struct rxrpc_peer *peer = b->peer_backlog[tail];
-		rxrpc_put_local(peer->local, rxrpc_local_put_prealloc_conn);
+		rxrpc_put_local(peer->local, rxrpc_local_put_prealloc_peer);
 		kfree(peer);
 		tail = (tail + 1) & (size - 1);
 	}

