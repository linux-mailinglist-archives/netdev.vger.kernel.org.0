Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6898F18B2B2
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 12:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbgCSLyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 07:54:06 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:51466 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727026AbgCSLyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 07:54:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584618843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DOgyuILY5jTsbaJ39lZihdKRVPX6aPdJZnDhJBfsmH0=;
        b=R0yi70bhjG4JM6F0FlkJakbjb9NnfXvFsfIuUcloBLWltZR087IepdXTMTrHRjDgjvfFXq
        o4Y8ayjpiJ1FsRkFZjMyu8QJ++MIZxUSkgBchrQyounsoyrC3ZDTyFBW22mTbzfTE4ybna
        h8VdpWZxGGuNAtwkErOnCz6Mo5qCGSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-X4unecJhNrywxKQaALOJ2w-1; Thu, 19 Mar 2020 07:54:00 -0400
X-MC-Unique: X4unecJhNrywxKQaALOJ2w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 443428010C4;
        Thu, 19 Mar 2020 11:53:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-126.rdu2.redhat.com [10.10.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75A3891285;
        Thu, 19 Mar 2020 11:53:58 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 4/6] afs: Fix some tracing details
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 19 Mar 2020 11:53:57 +0000
Message-ID: <158461883772.3094720.8491121830607569447.stgit@warthog.procyon.org.uk>
In-Reply-To: <158461880968.3094720.5019510060910604912.stgit@warthog.procyon.org.uk>
References: <158461880968.3094720.5019510060910604912.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a couple of tracelines to indicate the usage count after the atomic op,
not the usage count before it to be consistent with other afs and rxrpc
trace lines.

Change the wording of the afs_call_trace_work trace ID label from "WORK" to
"QUEUE" to reflect the fact that it's queueing work, not doing work.

Fixes: 341f741f04be ("afs: Refcount the afs_call struct")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/rxrpc.c             |    4 ++--
 include/trace/events/afs.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 4c28712bb7f6..907d5948564a 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -169,7 +169,7 @@ void afs_put_call(struct afs_call *call)
 	int n = atomic_dec_return(&call->usage);
 	int o = atomic_read(&net->nr_outstanding_calls);
 
-	trace_afs_call(call, afs_call_trace_put, n + 1, o,
+	trace_afs_call(call, afs_call_trace_put, n, o,
 		       __builtin_return_address(0));
 
 	ASSERTCMP(n, >=, 0);
@@ -736,7 +736,7 @@ static void afs_wake_up_async_call(struct sock *sk, struct rxrpc_call *rxcall,
 
 	u = atomic_fetch_add_unless(&call->usage, 1, 0);
 	if (u != 0) {
-		trace_afs_call(call, afs_call_trace_wake, u,
+		trace_afs_call(call, afs_call_trace_wake, u + 1,
 			       atomic_read(&call->net->nr_outstanding_calls),
 			       __builtin_return_address(0));
 
diff --git a/include/trace/events/afs.h b/include/trace/events/afs.h
index 564ba1b5cf57..c612cabbc378 100644
--- a/include/trace/events/afs.h
+++ b/include/trace/events/afs.h
@@ -233,7 +233,7 @@ enum afs_cb_break_reason {
 	EM(afs_call_trace_get,			"GET  ") \
 	EM(afs_call_trace_put,			"PUT  ") \
 	EM(afs_call_trace_wake,			"WAKE ") \
-	E_(afs_call_trace_work,			"WORK ")
+	E_(afs_call_trace_work,			"QUEUE")
 
 #define afs_server_traces \
 	EM(afs_server_trace_alloc,		"ALLOC    ") \


