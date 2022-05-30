Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 116F253818D
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240770AbiE3OUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 10:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240829AbiE3OQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 10:16:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048319A981;
        Mon, 30 May 2022 06:44:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0EDBB80DC2;
        Mon, 30 May 2022 13:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFEBC3411A;
        Mon, 30 May 2022 13:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918233;
        bh=wVJOIouwpjt0F5qJWzZespttPe32/0Khj9xgQVTw0xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BS3DiaP3r391FBs8+r977u+1GHGVHBrKAWTHa/GMZjIY8hN4AQ5an3mBHuokpQ+Fm
         F7NNtQLcI+L+CrC4peLtO+y+/HTUDKA+1OYo76ffJ9SzdxKmVg1PFfUl/UwRrrGhNV
         XS127yuQc7h7OlOluBzuITZ8YTIxc5JY0dYWQSGMBs47lYH56q/oJ1VWlooNMzXfqx
         gtb91UWdJjIiD7YBdz1scSomzJMuFAqJb3Fy299PqpvYuIYvUJFgyLk6XFrqKappTc
         e/BgfyQtLgzYFqcnzCq9tSPiraKrD/SoFbcfPSG7RnduFANoVxwjlmV8Pm+TrCY0ML
         VTzNMur9muy6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 105/109] afs: Adjust ACK interpretation to try and cope with NAT
Date:   Mon, 30 May 2022 09:38:21 -0400
Message-Id: <20220530133825.1933431-105-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit adc9613ff66c26ebaff9814973181ac178beb90b ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/misc.c     |  5 ++++-
 fs/afs/rotate.c   |  4 ++++
 fs/afs/write.c    |  1 +
 net/rxrpc/input.c | 27 +++++++++++++++++++++++++++
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
index f24370f5c774..a75c4742062a 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -626,6 +626,7 @@ static ssize_t afs_write_back_from_locked_page(struct address_space *mapping,
 	case -EKEYEXPIRED:
 	case -EKEYREJECTED:
 	case -EKEYREVOKED:
+	case -ENETRESET:
 		afs_redirty_pages(wbc, mapping, start, len);
 		mapping_set_error(mapping, ret);
 		break;
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index dc201363f2c4..67d3eba60dc7 100644
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
-- 
2.35.1

