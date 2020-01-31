Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 170DE14ED40
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 14:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgAaN3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 08:29:37 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50276 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728725AbgAaN3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 08:29:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580477376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=msjRtC1pX9Pk5JuskCNfQ4Q9BGD/mZ+2JEztPjK1Kes=;
        b=ievr0zzS9xxfzeC9UhBJeX+/fxI1jNyLAwqqBXjoGi+pzFepnHObVn+FksEntTaOtrmo0Q
        +zEh2dgmcuUAZ8M08zkVL/2Vsb+qhPVInwGXEuG5I7BcnHXE0ceh2wVhskwrlB0dLw8d72
        Wyz+QxYbYS/1qpxseki5lLjZuSWUIu4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-onSpNYe-PS6HmUncdvLtSA-1; Fri, 31 Jan 2020 08:29:32 -0500
X-MC-Unique: onSpNYe-PS6HmUncdvLtSA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BE5B107ACC5;
        Fri, 31 Jan 2020 13:29:31 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-218.rdu2.redhat.com [10.10.120.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF7B188858;
        Fri, 31 Jan 2020 13:29:30 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 2/4] rxrpc: Fix insufficient receive notification
 generation
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 31 Jan 2020 13:29:29 +0000
Message-ID: <158047736987.133127.18071443288095328152.stgit@warthog.procyon.org.uk>
In-Reply-To: <158047735578.133127.17728061182258449164.stgit@warthog.procyon.org.uk>
References: <158047735578.133127.17728061182258449164.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rxrpc_input_data(), rxrpc_notify_socket() is called if the base sequence
number of the packet is immediately following the hard-ack point at the end
of the function.  However, this isn't sufficient, since the recvmsg side
may have been advancing the window and then overrun the position in which
we're adding - at which point rx_hard_ack >= seq0 and no notification is
generated.

Fix this by always generating a notification at the end of the input
function.

Without this, a long call may stall, possibly indefinitely.

Fixes: 248f219cb8bc ("rxrpc: Rewrite the data and ack handling code")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/input.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 96d54e5bf7bc..ef10fbf71b15 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -599,10 +599,8 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 				  false, true,
 				  rxrpc_propose_ack_input_data);
 
-	if (seq0 == READ_ONCE(call->rx_hard_ack) + 1) {
-		trace_rxrpc_notify_socket(call->debug_id, serial);
-		rxrpc_notify_socket(call);
-	}
+	trace_rxrpc_notify_socket(call->debug_id, serial);
+	rxrpc_notify_socket(call);
 
 unlock:
 	spin_unlock(&call->input_lock);


