Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8AA152F9DB
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 09:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354834AbiEUHqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 03:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354856AbiEUHqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 03:46:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 66754DFD6
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 00:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653119158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zbihMZvF6i49xmhwwGzV9aEpJE5fX8yajKPGjYCvsNU=;
        b=USxDBekw36rTKKzpe9FXvBcJ8sMvzIvkJ1c1Apx96Rg51fIRsZAG8TM9fT7TU0p21RZ3kB
        K4hb6Z4utKGTLKOxGRMIcxBl3Zy/k1qaI/jxWRY1hw35QMn/u73R01DW+3IA1Xd4YG4tJp
        W1/N9EWlzOUqM7DXff/1pMxqi56gCwg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-phxv4N1OMkaU9cztLBt6vg-1; Sat, 21 May 2022 03:45:56 -0400
X-MC-Unique: phxv4N1OMkaU9cztLBt6vg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5BD0A3803505;
        Sat, 21 May 2022 07:45:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A450240E6A47;
        Sat, 21 May 2022 07:45:55 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 7/7] afs: Adjust ACK interpretation to try and cope
 with NAT
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Sat, 21 May 2022 08:45:55 +0100
Message-ID: <165311915499.245906.17834337602759412345.stgit@warthog.procyon.org.uk>
In-Reply-To: <165311910893.245906.4115532916417333325.stgit@warthog.procyon.org.uk>
References: <165311910893.245906.4115532916417333325.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a client's address changes, say if it is NAT'd, this can disrupt an in
progress operation.  For most operations, this is not much of a problem,
but StoreData can be different as some servers modify the target file as
the data comes in, so if a store request is disrupted, the file can get
corrupted on the server.

The problem is that the server doesn't recognise packets that come after
the change of address as belonging to the original client and will bounce
them, either by sending an OUT_OF_SEQUENCE ACK to the apparent new call if
the packet number falls within the initial sequence number window of a call
or by sending an EXCEEDS_WINDOW ACK if it falls outside and then aborting
it.  In both cases, firstPacket will be 1 and previousPacket will be 0 in
the ACK information.

Fix this by the following means:

 (1) If a client call receives an EXCEEDS_WINDOW ACK with firstPacket as 1
     and previousPacket as 0, assume this indicates that the server saw the
     incoming packets from a different peer and thus as a different call.
     Fail the call with error -ENETRESET.

 (2) Also fail the call if a similar OUT_OF_SEQUENCE ACK occurs if the
     first packet has been hard-ACK'd.  If it hasn't been hard-ACK'd, the
     ACK packet will cause it to get retransmitted, so the call will just
     be repeated.

 (3) Make afs_select_fileserver() treat -ENETRESET as a straight fail of
     the operation.

 (4) Prioritise the error code over things like -ECONNRESET as the server
     did actually respond.

 (5) Make writeback treat -ENETRESET as a retryable error and make it
     redirty all the pages involved in a write so that the VM will retry.

Note that there is still a circumstance that I can't easily deal with: if
the operation is fully received and processed by the server, but the reply
is lost due to address change.  There's no way to know if the op happened.
We can examine the server, but a conflicting change could have been made by
a third party - and we can't tell the difference.  In such a case, a
message like:

    kAFS: vnode modified {100058:146266} b7->b8 YFS.StoreData64 (op=2646a)

will be logged to dmesg on the next op to touch the file and the client
will reset the inode state, including invalidating clean parts of the
pagecache.

Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-afs@lists.infradead.org
Link: http://lists.infradead.org/pipermail/linux-afs/2021-December/004811.html # v1
---

 fs/afs/misc.c     |    5 ++++-
 fs/afs/rotate.c   |    4 ++++
 fs/afs/write.c    |    1 +
 net/rxrpc/input.c |   27 +++++++++++++++++++++++++++
 4 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/fs/afs/misc.c b/fs/afs/misc.c
index 1d1a8debe472..933e67fcdab1 100644
--- a/fs/afs/misc.c
+++ b/fs/afs/misc.c
@@ -163,8 +163,11 @@ void afs_prioritise_error(struct afs_error *e, int error, u32 abort_code)
 		return;
 
 	case -ECONNABORTED:
+		error = afs_abort_to_error(abort_code);
+		fallthrough;
+	case -ENETRESET: /* Responded, but we seem to have changed address */
 		e->responded = true;
-		e->error = afs_abort_to_error(abort_code);
+		e->error = error;
 		return;
 	}
 }
diff --git a/fs/afs/rotate.c b/fs/afs/rotate.c
index 79e1a5f6701b..a840c3588ebb 100644
--- a/fs/afs/rotate.c
+++ b/fs/afs/rotate.c
@@ -292,6 +292,10 @@ bool afs_select_fileserver(struct afs_operation *op)
 		op->error = error;
 		goto iterate_address;
 
+	case -ENETRESET:
+		pr_warn("kAFS: Peer reset %s (op=%x)\n",
+			op->type ? op->type->name : "???", op->debug_id);
+		fallthrough;
 	case -ECONNRESET:
 		_debug("call reset");
 		op->error = error;
diff --git a/fs/afs/write.c b/fs/afs/write.c
index 4763132ca57e..c1bc52ac7de1 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -636,6 +636,7 @@ static ssize_t afs_write_back_from_locked_folio(struct address_space *mapping,
 	case -EKEYEXPIRED:
 	case -EKEYREJECTED:
 	case -EKEYREVOKED:
+	case -ENETRESET:
 		afs_redirty_pages(wbc, mapping, start, len);
 		mapping_set_error(mapping, ret);
 		break;
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 853b869b026a..16c0af41c202 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -903,6 +903,33 @@ static void rxrpc_input_ack(struct rxrpc_call *call, struct sk_buff *skb)
 				  rxrpc_propose_ack_respond_to_ack);
 	}
 
+	/* If we get an EXCEEDS_WINDOW ACK from the server, it probably
+	 * indicates that the client address changed due to NAT.  The server
+	 * lost the call because it switched to a different peer.
+	 */
+	if (unlikely(buf.ack.reason == RXRPC_ACK_EXCEEDS_WINDOW) &&
+	    first_soft_ack == 1 &&
+	    prev_pkt == 0 &&
+	    rxrpc_is_client_call(call)) {
+		rxrpc_set_call_completion(call, RXRPC_CALL_REMOTELY_ABORTED,
+					  0, -ENETRESET);
+		return;
+	}
+
+	/* If we get an OUT_OF_SEQUENCE ACK from the server, that can also
+	 * indicate a change of address.  However, we can retransmit the call
+	 * if we still have it buffered to the beginning.
+	 */
+	if (unlikely(buf.ack.reason == RXRPC_ACK_OUT_OF_SEQUENCE) &&
+	    first_soft_ack == 1 &&
+	    prev_pkt == 0 &&
+	    call->tx_hard_ack == 0 &&
+	    rxrpc_is_client_call(call)) {
+		rxrpc_set_call_completion(call, RXRPC_CALL_REMOTELY_ABORTED,
+					  0, -ENETRESET);
+		return;
+	}
+
 	/* Discard any out-of-order or duplicate ACKs (outside lock). */
 	if (!rxrpc_is_ack_valid(call, first_soft_ack, prev_pkt)) {
 		trace_rxrpc_rx_discard_ack(call->debug_id, ack_serial,


