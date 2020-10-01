Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137512801CA
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732605AbgJAO53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:57:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52731 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732572AbgJAO5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:57:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601564243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zJbpakuHgD3JsKt9EUNvBPMetVb9AD7Xn6YaH4IxeBc=;
        b=LTfj5tjnaDSAYqHmeMCgVV3tvvuvLemcBtKfkv2plDSH23E0lZazUBWHMg/tzoqeDeITg4
        V8tPLP584wEKdPqd/RZKo39mQ/q7MpArkSx9MYHVWLXnnbVAUucy12gEq0Wy4tVXKIX51o
        Zqb6IB7MTY5tVRhxfMlX109/nCsDQRQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-HdJOj6UANcq25QIcRmkLaA-1; Thu, 01 Oct 2020 10:57:20 -0400
X-MC-Unique: HdJOj6UANcq25QIcRmkLaA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6BD581084C97;
        Thu,  1 Oct 2020 14:57:19 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB88C19C78;
        Thu,  1 Oct 2020 14:57:18 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 05/23] rxrpc: Fix some missing _bh annotations on
 locking conn->state_lock
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 01 Oct 2020 15:57:17 +0100
Message-ID: <160156423795.1728886.3034574197517613504.stgit@warthog.procyon.org.uk>
In-Reply-To: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
References: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

conn->state_lock may be taken in softirq mode, but a previous patch
replaced an outer lock in the response-packet event handling code, and lost
the _bh from that when doing so.

Fix this by applying the _bh annotation to the state_lock locking.

Fixes: a1399f8bb033 ("rxrpc: Call channels should have separate call number spaces")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/conn_event.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 0628dad2bdea..bba5d7906df6 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -342,18 +342,18 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
 			return ret;
 
 		spin_lock(&conn->bundle->channel_lock);
-		spin_lock(&conn->state_lock);
+		spin_lock_bh(&conn->state_lock);
 
 		if (conn->state == RXRPC_CONN_SERVICE_CHALLENGING) {
 			conn->state = RXRPC_CONN_SERVICE;
-			spin_unlock(&conn->state_lock);
+			spin_unlock_bh(&conn->state_lock);
 			for (loop = 0; loop < RXRPC_MAXCALLS; loop++)
 				rxrpc_call_is_secure(
 					rcu_dereference_protected(
 						conn->channels[loop].call,
 						lockdep_is_held(&conn->bundle->channel_lock)));
 		} else {
-			spin_unlock(&conn->state_lock);
+			spin_unlock_bh(&conn->state_lock);
 		}
 
 		spin_unlock(&conn->bundle->channel_lock);


