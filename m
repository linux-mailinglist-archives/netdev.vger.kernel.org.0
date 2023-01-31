Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C49683381
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 18:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbjAaROV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 12:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbjAaROD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 12:14:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F68810437
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 09:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675185181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MaE7vmOlfTK/lO4pfaUlUsuSka8DjgNldE6WfemMW2w=;
        b=TcZp2ert1g89cfYOpMBg03Q6l/7jfrj5spPUkMZUwXdviRrxQaXWOW+6BbdKvMm+SATHl0
        XEIgdCkSeazE6BnHZEFlqJKDmpku3O+Ioq8LEOzg9JIyoYyeAPi9kXv0SgU00pLJJoriHG
        LvM5Fd4O+Ou9owohrcHTV61zxmXdNXQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-dHiIOzJnN1qhtlNmnTnv_Q-1; Tue, 31 Jan 2023 12:12:55 -0500
X-MC-Unique: dHiIOzJnN1qhtlNmnTnv_Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F6FB811E6E;
        Tue, 31 Jan 2023 17:12:55 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1494740C1073;
        Tue, 31 Jan 2023 17:12:53 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 13/13] rxrpc: Kill service bundle
Date:   Tue, 31 Jan 2023 17:12:27 +0000
Message-Id: <20230131171227.3912130-14-dhowells@redhat.com>
In-Reply-To: <20230131171227.3912130-1-dhowells@redhat.com>
References: <20230131171227.3912130-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

Now that the bundle->channel_lock has been eliminated, we don't need the
dummy service bundle anymore.  It's purpose was purely to provide the
channel_lock for service connections.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---
 net/rxrpc/conn_service.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/net/rxrpc/conn_service.c b/net/rxrpc/conn_service.c
index f30323de82bd..89ac05a711a4 100644
--- a/net/rxrpc/conn_service.c
+++ b/net/rxrpc/conn_service.c
@@ -8,11 +8,6 @@
 #include <linux/slab.h>
 #include "ar-internal.h"
 
-static struct rxrpc_bundle rxrpc_service_dummy_bundle = {
-	.ref		= REFCOUNT_INIT(1),
-	.debug_id	= UINT_MAX,
-};
-
 /*
  * Find a service connection under RCU conditions.
  *
@@ -132,8 +127,6 @@ struct rxrpc_connection *rxrpc_prealloc_service_connection(struct rxrpc_net *rxn
 		 */
 		conn->state = RXRPC_CONN_SERVICE_PREALLOC;
 		refcount_set(&conn->ref, 2);
-		conn->bundle = rxrpc_get_bundle(&rxrpc_service_dummy_bundle,
-						rxrpc_bundle_get_service_conn);
 
 		atomic_inc(&rxnet->nr_conns);
 		write_lock(&rxnet->conn_lock);

