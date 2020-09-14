Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF12B269009
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 17:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgINPeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 11:34:12 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52594 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726438AbgINPdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 11:33:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600097582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DHjreWUBqPVhQCuDlHLghJCXj4TprCUtbQO3T18RwAc=;
        b=ch8CSggNyh5nImkQqE3TMXRSqVbZLYa1hYB0pmwCMtkbbM3ei+ywFtJI8Vs3JQQMct7nAt
        WEKonS9ihPX4d5j3ULK2dsaL0jGKegIhuH/GfFhtZgpSExUU/5geHbL/rdAeG8Gl9eiP2B
        +KlBoZeR8dvSg7jW46n7QspbEh8MIgg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-W2XVQaOOPI-GjLDnz0zKgg-1; Mon, 14 Sep 2020 11:31:25 -0400
X-MC-Unique: W2XVQaOOPI-GjLDnz0zKgg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0727B18C9F4D;
        Mon, 14 Sep 2020 15:31:09 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-6.rdu2.redhat.com [10.10.113.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C68381F41;
        Mon, 14 Sep 2020 15:31:08 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 3/5] rxrpc: Fix rxrpc_bundle::alloc_error to be
 signed
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 14 Sep 2020 16:31:07 +0100
Message-ID: <160009746742.1014072.15836712415506346429.stgit@warthog.procyon.org.uk>
In-Reply-To: <160009744625.1014072.11957943055200732444.stgit@warthog.procyon.org.uk>
References: <160009744625.1014072.11957943055200732444.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The alloc_error field in the rxrpc_bundle struct should be signed as it has
negative error codes assigned to it.  Checks directly on it may then fail,
and may produce a warning like this:

	net/rxrpc/conn_client.c:662 rxrpc_wait_for_channel()
	warn: 'bundle->alloc_error' is unsigned

Fixes: 245500d853e9 ("rxrpc: Rewrite the client connection manager")
Reported-by Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index cd5a80b34738..19f714386654 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -395,7 +395,7 @@ struct rxrpc_bundle {
 	unsigned int		debug_id;
 	bool			try_upgrade;	/* True if the bundle is attempting upgrade */
 	bool			alloc_conn;	/* True if someone's getting a conn */
-	unsigned short		alloc_error;	/* Error from last conn allocation */
+	short			alloc_error;	/* Error from last conn allocation */
 	spinlock_t		channel_lock;
 	struct rb_node		local_node;	/* Node in local->client_conns */
 	struct list_head	waiting_calls;	/* Calls waiting for channels */


