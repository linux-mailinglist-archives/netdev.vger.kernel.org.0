Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E511283C48
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 18:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbgJEQTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 12:19:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53545 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728815AbgJEQTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 12:19:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601914753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QbeuYECUWBtTBQtjfe+2IriqkB7i+erqV/uhhJTMK50=;
        b=B3qqTjFd9vLBSPzopWyETHgOeO3VJNrrH5GZj8ykdgnVcERJvHtnGnXxIzqKGljliRM+Tp
        jqWfGRUtwBIL4i/19/+vvHG/s9D7+24Myx2LH/3MmZzaj2I+lKNGldUh/JeEoRwD1oNLpD
        3bu19SJ2spaRX3/vn/11IKnRV8MlBgY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-mJMqayMJNZOb3xwxH5eLeA-1; Mon, 05 Oct 2020 12:19:11 -0400
X-MC-Unique: mJMqayMJNZOb3xwxH5eLeA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B55B58030A1;
        Mon,  5 Oct 2020 16:19:10 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-116-196.rdu2.redhat.com [10.10.116.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E8C1A1002C1F;
        Mon,  5 Oct 2020 16:19:05 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 3/6] rxrpc: Fix some missing _bh annotations on locking
 conn->state_lock
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 05 Oct 2020 17:19:05 +0100
Message-ID: <160191474530.3050642.17824630460111913419.stgit@warthog.procyon.org.uk>
In-Reply-To: <160191472433.3050642.12600839710302704718.stgit@warthog.procyon.org.uk>
References: <160191472433.3050642.12600839710302704718.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
index 447f55ca6886..6e972b4823ef 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -340,18 +340,18 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
 			return ret;
 
 		spin_lock(&conn->channel_lock);
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
 						lockdep_is_held(&conn->channel_lock)));
 		} else {
-			spin_unlock(&conn->state_lock);
+			spin_unlock_bh(&conn->state_lock);
 		}
 
 		spin_unlock(&conn->channel_lock);


