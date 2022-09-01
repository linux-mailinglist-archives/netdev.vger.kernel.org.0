Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 470315A91A7
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 10:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbiIAIIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 04:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbiIAIIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 04:08:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2489131DE0
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 01:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662019685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MtBvpfJ3eckvnTYUYrSyrfDCiwUxakoF/uzzXmwmvN4=;
        b=A3OLWCHNrRwJ8ltimoggKRCASpDkK6Bm+4XC6tuQwiD72KNdeTO+XyBXYbuiiii7s4Ug53
        6lcMkIzXgGE7QoLPrs7aqzEPw1TyqMM95G8fE1WwWrL+uDK1GN0W23vKBmonJn9qwybu4y
        Bp5xOgo5uEIhX5YZ4sdTed8vBi5ay6s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-546-IwNecOPUMPC7_hj96FnhHg-1; Thu, 01 Sep 2022 04:07:58 -0400
X-MC-Unique: IwNecOPUMPC7_hj96FnhHg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19D653800C31;
        Thu,  1 Sep 2022 08:07:58 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F2E1492C3B;
        Thu,  1 Sep 2022 08:07:57 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 5/6] afs: Use the operation issue time instead of the
 reply time for callbacks
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jeffrey E Altman <jaltman@auristor.com>, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Thu, 01 Sep 2022 09:07:56 +0100
Message-ID: <166201967675.3817988.12466707656540614005.stgit@warthog.procyon.org.uk>
In-Reply-To: <166201964443.3817988.12088441548413332725.stgit@warthog.procyon.org.uk>
References: <166201964443.3817988.12088441548413332725.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rxrpc and kafs between them try to use the receive timestamp on the first
data packet (ie. the one with sequence number 1) as a base from which to
calculate the time at which callback promise and lock expiration occurs.

However, we don't know how long it took for the server to send us the reply
from it having completed the basic part of the operation - it might then,
for instance, have to send a bunch of a callback breaks, depending on the
particular operation.

Fix this by using the time at which the operation is issued on the client
as a base instead.  That should never be longer than the server's idea of
the expiry time.

Fixes: 781070551c26 ("afs: Fix calculation of callback expiry time")
Fixes: 2070a3e44962 ("rxrpc: Allow the reply time to be obtained on a client call")
Suggested-by: Jeffrey E Altman <jaltman@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/flock.c     |    2 +-
 fs/afs/fsclient.c  |    2 +-
 fs/afs/internal.h  |    3 +--
 fs/afs/rxrpc.c     |    7 +------
 fs/afs/yfsclient.c |    3 +--
 5 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/afs/flock.c b/fs/afs/flock.c
index c4210a3964d8..bbcc5afd1576 100644
--- a/fs/afs/flock.c
+++ b/fs/afs/flock.c
@@ -76,7 +76,7 @@ void afs_lock_op_done(struct afs_call *call)
 	if (call->error == 0) {
 		spin_lock(&vnode->lock);
 		trace_afs_flock_ev(vnode, NULL, afs_flock_timestamp, 0);
-		vnode->locked_at = call->reply_time;
+		vnode->locked_at = call->issue_time;
 		afs_schedule_lock_extension(vnode);
 		spin_unlock(&vnode->lock);
 	}
diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index 4943413d9c5f..7d37f63ef0f0 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -131,7 +131,7 @@ static void xdr_decode_AFSFetchStatus(const __be32 **_bp,
 
 static time64_t xdr_decode_expiry(struct afs_call *call, u32 expiry)
 {
-	return ktime_divns(call->reply_time, NSEC_PER_SEC) + expiry;
+	return ktime_divns(call->issue_time, NSEC_PER_SEC) + expiry;
 }
 
 static void xdr_decode_AFSCallBack(const __be32 **_bp,
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 64ad55494349..723d162078a3 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -137,7 +137,6 @@ struct afs_call {
 	bool			need_attention;	/* T if RxRPC poked us */
 	bool			async;		/* T if asynchronous */
 	bool			upgrade;	/* T to request service upgrade */
-	bool			have_reply_time; /* T if have got reply_time */
 	bool			intr;		/* T if interruptible */
 	bool			unmarshalling_error; /* T if an unmarshalling error occurred */
 	u16			service_id;	/* Actual service ID (after upgrade) */
@@ -151,7 +150,7 @@ struct afs_call {
 		} __attribute__((packed));
 		__be64		tmp64;
 	};
-	ktime_t			reply_time;	/* Time of first reply packet */
+	ktime_t			issue_time;	/* Time of issue of operation */
 };
 
 struct afs_call_type {
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index d5c4785c862d..eccc3cd0cb70 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -351,6 +351,7 @@ void afs_make_call(struct afs_addr_cursor *ac, struct afs_call *call, gfp_t gfp)
 	if (call->max_lifespan)
 		rxrpc_kernel_set_max_life(call->net->socket, rxcall,
 					  call->max_lifespan);
+	call->issue_time = ktime_get_real();
 
 	/* send the request */
 	iov[0].iov_base	= call->request;
@@ -501,12 +502,6 @@ static void afs_deliver_to_call(struct afs_call *call)
 			return;
 		}
 
-		if (!call->have_reply_time &&
-		    rxrpc_kernel_get_reply_time(call->net->socket,
-						call->rxcall,
-						&call->reply_time))
-			call->have_reply_time = true;
-
 		ret = call->type->deliver(call);
 		state = READ_ONCE(call->state);
 		if (ret == 0 && call->unmarshalling_error)
diff --git a/fs/afs/yfsclient.c b/fs/afs/yfsclient.c
index fdc7d675b4b0..11571cca86c1 100644
--- a/fs/afs/yfsclient.c
+++ b/fs/afs/yfsclient.c
@@ -232,8 +232,7 @@ static void xdr_decode_YFSCallBack(const __be32 **_bp,
 	struct afs_callback *cb = &scb->callback;
 	ktime_t cb_expiry;
 
-	cb_expiry = call->reply_time;
-	cb_expiry = ktime_add(cb_expiry, xdr_to_u64(x->expiration_time) * 100);
+	cb_expiry = ktime_add(call->issue_time, xdr_to_u64(x->expiration_time) * 100);
 	cb->expires_at	= ktime_divns(cb_expiry, NSEC_PER_SEC);
 	scb->have_cb	= true;
 	*_bp += xdr_size(x);


