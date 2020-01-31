Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9A714ED3F
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 14:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbgAaN3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 08:29:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46009 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728642AbgAaN3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 08:29:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580477374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pCLKGSqMaV4qZrcygd/MqiNrWGKg5U4tuMzI7W//FPE=;
        b=WfAirpd1NceZZUVUTzGU3Ru6WOYZHUDFktNmNdzPaMxgidO6pxVgbrMooZWGGSg1qAdVEA
        mRcz6aaz7VuzN6keZbby8Ji/9VnQPO0tJ1LUhqf2yFMGAUFjvdVcaHWjSpaiv4akHjQgWb
        M5v0rzzLDsE9or+z/Vrlt7z8WDJ6yhw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-uRuAU9q3NxOQN0uRqdt1lQ-1; Fri, 31 Jan 2020 08:29:25 -0500
X-MC-Unique: uRuAU9q3NxOQN0uRqdt1lQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E64D18B5FA0;
        Fri, 31 Jan 2020 13:29:24 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-218.rdu2.redhat.com [10.10.120.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3B9F86CC2;
        Fri, 31 Jan 2020 13:29:23 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 1/4] rxrpc: Fix use-after-free in rxrpc_put_local()
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 31 Jan 2020 13:29:23 +0000
Message-ID: <158047736293.133127.4706435864450024685.stgit@warthog.procyon.org.uk>
In-Reply-To: <158047735578.133127.17728061182258449164.stgit@warthog.procyon.org.uk>
References: <158047735578.133127.17728061182258449164.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix rxrpc_put_local() to not access local->debug_id after calling
atomic_dec_return() as, unless that returned n==0, we no longer have the
right to access the object.

Fixes: 06d9532fa6b3 ("rxrpc: Fix read-after-free in rxrpc_queue_local()")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/local_object.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 36587260cabd..3aa179efcda4 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -364,11 +364,14 @@ void rxrpc_queue_local(struct rxrpc_local *local)
 void rxrpc_put_local(struct rxrpc_local *local)
 {
 	const void *here = __builtin_return_address(0);
+	unsigned int debug_id;
 	int n;
 
 	if (local) {
+		debug_id = local->debug_id;
+
 		n = atomic_dec_return(&local->usage);
-		trace_rxrpc_local(local->debug_id, rxrpc_local_put, n, here);
+		trace_rxrpc_local(debug_id, rxrpc_local_put, n, here);
 
 		if (n == 0)
 			call_rcu(&local->rcu, rxrpc_local_rcu);


