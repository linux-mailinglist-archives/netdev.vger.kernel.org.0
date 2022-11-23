Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621B6635A26
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237569AbiKWKfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237012AbiKWKdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:33:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC09725E0
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 02:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669198589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M0DiMhtLSHWYPLXYhyuFlQZzFe4JPvLomQsSKVHbCQw=;
        b=WhsidCFD20D7FdF1yvDhlrbv/Fdfv5xMyiJd0WSZnEk7JljsdLbGeQbFygWNoE+xyEuWzg
        ZsEzdM9QaivWzwYAgsHLFdHozOMkhFEK7mXaLJ7Kv7mmjiI+500niWpjMo2p9Nckgd/u99
        Y/SdcwAPK0PvwJ0WDMCz23AjQYLOBaQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-GeIq5uliMrSnQEnTIqr9tQ-1; Wed, 23 Nov 2022 05:16:27 -0500
X-MC-Unique: GeIq5uliMrSnQEnTIqr9tQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 59EFE185A794;
        Wed, 23 Nov 2022 10:16:27 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B58272024CBE;
        Wed, 23 Nov 2022 10:16:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 15/17] rxrpc: Fold __rxrpc_unuse_local() into
 rxrpc_unuse_local()
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 23 Nov 2022 10:16:24 +0000
Message-ID: <166919858402.1258552.9409411788284818415.stgit@warthog.procyon.org.uk>
In-Reply-To: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
References: <166919846440.1258552.9618708344491052554.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fold __rxrpc_unuse_local() into rxrpc_unuse_local() as the latter is now
the only user of the former.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/ar-internal.h  |   12 ------------
 net/rxrpc/local_object.c |   12 ++++++++++--
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 070635174b1c..aaa57bc7817b 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -1007,18 +1007,6 @@ void rxrpc_unuse_local(struct rxrpc_local *, enum rxrpc_local_trace);
 void rxrpc_destroy_local(struct rxrpc_local *local);
 void rxrpc_destroy_all_locals(struct rxrpc_net *);
 
-static inline bool __rxrpc_unuse_local(struct rxrpc_local *local,
-				       enum rxrpc_local_trace why)
-{
-	unsigned int debug_id = local->debug_id;
-	int r, u;
-
-	r = refcount_read(&local->ref);
-	u = atomic_dec_return(&local->active_users);
-	trace_rxrpc_local(debug_id, why, r, u);
-	return u == 0;
-}
-
 static inline bool __rxrpc_use_local(struct rxrpc_local *local,
 				     enum rxrpc_local_trace why)
 {
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index c73a5a1bc088..1e994a83db2b 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -359,8 +359,16 @@ struct rxrpc_local *rxrpc_use_local(struct rxrpc_local *local,
  */
 void rxrpc_unuse_local(struct rxrpc_local *local, enum rxrpc_local_trace why)
 {
-	if (local && __rxrpc_unuse_local(local, why))
-		kthread_stop(local->io_thread);
+	unsigned int debug_id = local->debug_id;
+	int r, u;
+
+	if (local) {
+		r = refcount_read(&local->ref);
+		u = atomic_dec_return(&local->active_users);
+		trace_rxrpc_local(debug_id, why, r, u);
+		if (u == 0)
+			kthread_stop(local->io_thread);
+	}
 }
 
 /*


