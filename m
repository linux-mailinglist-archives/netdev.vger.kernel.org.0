Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D73D2691CE
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgINQlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:41:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46607 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726359AbgINPb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 11:31:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600097484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6pc/y1maJ9IHvoW69SYfOowBC5QUpE9zOTjocXoBw68=;
        b=OhUR83BqcQTR1VqfKwE1z34qfdwpae1QksHp+NKG/6LuLnzA8sJ41gR9I8G72Mh73E6rNV
        S/HCqOkMywiJ0Zemgwpi/DURxvch+GfvcM92osnPSqrlnOPQAaSI7I8VacqdnKIrDMpTgk
        4Ad6r7UCKLKbCwI7BGtdeI5sNt9LYGw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-tsjcqdaNO2eDJf41yz0e8A-1; Mon, 14 Sep 2020 11:31:22 -0400
X-MC-Unique: tsjcqdaNO2eDJf41yz0e8A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3312B8914FA;
        Mon, 14 Sep 2020 15:31:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-6.rdu2.redhat.com [10.10.113.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65C2175120;
        Mon, 14 Sep 2020 15:31:01 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 2/5] rxrpc: Fix a missing NULL-pointer check in a
 trace
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 14 Sep 2020 16:31:00 +0100
Message-ID: <160009746059.1014072.11451831292156673294.stgit@warthog.procyon.org.uk>
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

Fix the rxrpc_client tracepoint to not dereference conn to get the cid if
conn is NULL, as it does for other fields.

	RIP: 0010:trace_event_raw_event_rxrpc_client+0x7e/0xe0 [rxrpc]
	Call Trace:
	 rxrpc_activate_channels+0x62/0xb0 [rxrpc]
	 rxrpc_connect_call+0x481/0x650 [rxrpc]
	 ? wake_up_q+0xa0/0xa0
	 ? rxrpc_kernel_begin_call+0x12a/0x1b0 [rxrpc]
	 rxrpc_new_client_call+0x2a5/0x5e0 [rxrpc]

Fixes: 245500d853e9 ("rxrpc: Rewrite the client connection manager")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Marc Dionne <marc.dionne@auristor.com>
---

 include/trace/events/rxrpc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 3b67d5981224..e70c90116eda 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -579,7 +579,7 @@ TRACE_EVENT(rxrpc_client,
 		    __entry->channel = channel;
 		    __entry->usage = conn ? atomic_read(&conn->usage) : -2;
 		    __entry->op = op;
-		    __entry->cid = conn->proto.cid;
+		    __entry->cid = conn ? conn->proto.cid : 0;
 			   ),
 
 	    TP_printk("C=%08x h=%2d %s i=%08x u=%d",


