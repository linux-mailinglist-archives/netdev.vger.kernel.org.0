Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A84269021
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 17:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgINPcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 11:32:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30175 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726348AbgINPbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 11:31:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600097490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5wD/L5mjZXfk+6pxJFnXBeqTK1xBuAPBxiA5Ca9uTUk=;
        b=bPEn04vIAmG9ErxWIpiBtB0s00PsspCtXLtkbW5obNkfh/Xzi6kEKwYvV957IEQf1vTHkw
        sgNuYK+EVFcAX1q5wXiNPEmfCdAFDvKFAxsJisLk1jw3kDDFv8JlhjiC9ztBIfdOivmCFK
        N7s4SkNOZgsz7Aljg1RA19asG5SJIPA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-4C4YTQPLMrWCAbs-YskdTw-1; Mon, 14 Sep 2020 11:31:28 -0400
X-MC-Unique: 4C4YTQPLMrWCAbs-YskdTw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD49D802B77;
        Mon, 14 Sep 2020 15:31:22 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-6.rdu2.redhat.com [10.10.113.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10B7575133;
        Mon, 14 Sep 2020 15:31:21 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 5/5] rxrpc: Fix an overget of the conn bundle when
 setting up a client conn
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 14 Sep 2020 16:31:21 +0100
Message-ID: <160009748120.1014072.10308681243643184204.stgit@warthog.procyon.org.uk>
In-Reply-To: <160009744625.1014072.11957943055200732444.stgit@warthog.procyon.org.uk>
References: <160009744625.1014072.11957943055200732444.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When setting up a client connection, a second ref is accidentally obtained
on the connection bundle (we get one when allocating the conn and a second
one when adding the conn to the bundle).

Fix it to only use the ref obtained by rxrpc_alloc_client_connection() and
not to add a second when adding the candidate conn to the bundle.

Fixes: 245500d853e9 ("rxrpc: Rewrite the client connection manager")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/conn_client.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
index 0eb36ba52485..78c845a4f1ad 100644
--- a/net/rxrpc/conn_client.c
+++ b/net/rxrpc/conn_client.c
@@ -433,7 +433,6 @@ static void rxrpc_add_conn_to_bundle(struct rxrpc_bundle *bundle, gfp_t gfp)
 		if (!rxrpc_may_reuse_conn(old)) {
 			if (old)
 				trace_rxrpc_client(old, -1, rxrpc_client_replace);
-			candidate->bundle = rxrpc_get_bundle(bundle);
 			candidate->bundle_shift = shift;
 			bundle->conns[i] = candidate;
 			for (j = 0; j < RXRPC_MAXCALLS; j++)


