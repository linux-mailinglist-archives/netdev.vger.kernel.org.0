Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4464B149198
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 00:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729433AbgAXXIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 18:08:12 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44626 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729182AbgAXXIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 18:08:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579907291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+pQMYieQNovVhRg3Nj/s2qkdJCjR5iAcrsF/1uR16VA=;
        b=jDbSAA0T8SbSMZbEoOrqoF3SLP4tGx5qIWEXYrSHw/irAlmUvnLgijN0DsnzD3kvmREYyP
        NHC9wgTQ6mzJDWMDSfjy73LOs5kivTrdiZ+skLJSgPQ4va43amEvcMpQks3WP81X3I9EnA
        4mUeSbJ/l0jlhbW81PkudncfYDOqE3Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-gAWFFvPeNi-kbmFD8NKbCw-1; Fri, 24 Jan 2020 18:08:07 -0500
X-MC-Unique: gAWFFvPeNi-kbmFD8NKbCw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA878107ACCD;
        Fri, 24 Jan 2020 23:08:05 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-49.rdu2.redhat.com [10.10.120.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F2D33CCA;
        Fri, 24 Jan 2020 23:08:05 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net] rxrpc: Fix use-after-free in rxrpc_receive_data()
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 24 Jan 2020 23:08:04 +0000
Message-ID: <157990728440.1173687.14473656600696398776.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The subpacket scanning loop in rxrpc_receive_data() references the
subpacket count in the private data part of the sk_buff in the loop
termination condition.  However, when the final subpacket is pasted into
the ring buffer, the function is no longer has a ref on the sk_buff and
should not be looking at sp->* any more.  This point is actually marked in
the code when skb is cleared (but sp is not - which is an error).

Fix this by caching sp->nr_subpackets in a local variable and using that
instead.

Also clear 'sp' to catch accesses after that point.

This can show up as an oops in rxrpc_get_skb() if sp->nr_subpackets gets
trashed by the sk_buff getting freed and reused in the meantime.

Fixes: e2de6c404898 ("rxrpc: Use info in skbuff instead of reparsing a jumbo packet")
Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/input.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 86bd133b4fa0..96d54e5bf7bc 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -413,7 +413,7 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
 	enum rxrpc_call_state state;
-	unsigned int j;
+	unsigned int j, nr_subpackets;
 	rxrpc_serial_t serial = sp->hdr.serial, ack_serial = 0;
 	rxrpc_seq_t seq0 = sp->hdr.seq, hard_ack;
 	bool immediate_ack = false, jumbo_bad = false;
@@ -457,7 +457,8 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 	call->ackr_prev_seq = seq0;
 	hard_ack = READ_ONCE(call->rx_hard_ack);
 
-	if (sp->nr_subpackets > 1) {
+	nr_subpackets = sp->nr_subpackets;
+	if (nr_subpackets > 1) {
 		if (call->nr_jumbo_bad > 3) {
 			ack = RXRPC_ACK_NOSPACE;
 			ack_serial = serial;
@@ -465,11 +466,11 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 		}
 	}
 
-	for (j = 0; j < sp->nr_subpackets; j++) {
+	for (j = 0; j < nr_subpackets; j++) {
 		rxrpc_serial_t serial = sp->hdr.serial + j;
 		rxrpc_seq_t seq = seq0 + j;
 		unsigned int ix = seq & RXRPC_RXTX_BUFF_MASK;
-		bool terminal = (j == sp->nr_subpackets - 1);
+		bool terminal = (j == nr_subpackets - 1);
 		bool last = terminal && (sp->rx_flags & RXRPC_SKB_INCL_LAST);
 		u8 flags, annotation = j;
 
@@ -506,7 +507,7 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 		}
 
 		if (call->rxtx_buffer[ix]) {
-			rxrpc_input_dup_data(call, seq, sp->nr_subpackets > 1,
+			rxrpc_input_dup_data(call, seq, nr_subpackets > 1,
 					     &jumbo_bad);
 			if (ack != RXRPC_ACK_DUPLICATE) {
 				ack = RXRPC_ACK_DUPLICATE;
@@ -564,6 +565,7 @@ static void rxrpc_input_data(struct rxrpc_call *call, struct sk_buff *skb)
 			 * ring.
 			 */
 			skb = NULL;
+			sp = NULL;
 		}
 
 		if (last) {


