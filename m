Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750FB6359A5
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236683AbiKWKWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236503AbiKWKU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:20:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92579132F4F
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 02:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669198044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RWE246jOHYV/PB81lSut/TryVZE+bm1/17r8oeSbAPg=;
        b=gPoqrD64hujyVdskf36eScGX10BLICSxsU2WbifNlGItNIimeBoE9w9vvCEmf4OCGHVwF7
        w87FwlwIm1s0hpLO50DhX/gVGA9WhKoC2BCZfckal10X0MvRZwSHW24P3ralKZTN2umKU8
        Jv38TrPo+0KjVT3LfqzS+JV4GTNpK2M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-nOEgfGcCNwKVSiG1SsR9XA-1; Wed, 23 Nov 2022 05:07:21 -0500
X-MC-Unique: nOEgfGcCNwKVSiG1SsR9XA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38413185A78B;
        Wed, 23 Nov 2022 10:07:21 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9314E2166B26;
        Wed, 23 Nov 2022 10:07:20 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 07/13] rxrpc: Extract the code from a received ABORT
 packet much earlier
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 23 Nov 2022 10:07:18 +0000
Message-ID: <166919803803.1256245.9937954471719575504.stgit@warthog.procyon.org.uk>
In-Reply-To: <166919798040.1256245.11495568684139066955.stgit@warthog.procyon.org.uk>
References: <166919798040.1256245.11495568684139066955.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract the code from a received rx ABORT packet much earlier and in a
single place and harmonise the responses to malformed ABORT packets.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 net/rxrpc/conn_event.c |   12 +-----------
 net/rxrpc/input.c      |   31 +++++++++++++++++++------------
 2 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 71ed6b9dc63a..f890a30c4df6 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -282,8 +282,6 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
 			       u32 *_abort_code)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-	__be32 wtmp;
-	u32 abort_code;
 	int loop, ret;
 
 	if (conn->state >= RXRPC_CONN_REMOTELY_ABORTED) {
@@ -305,16 +303,8 @@ static int rxrpc_process_event(struct rxrpc_connection *conn,
 		return 0;
 
 	case RXRPC_PACKET_TYPE_ABORT:
-		if (skb_copy_bits(skb, sizeof(struct rxrpc_wire_header),
-				  &wtmp, sizeof(wtmp)) < 0) {
-			trace_rxrpc_rx_eproto(NULL, sp->hdr.serial,
-					      tracepoint_string("bad_abort"));
-			return -EPROTO;
-		}
-		abort_code = ntohl(wtmp);
-
 		conn->error = -ECONNABORTED;
-		conn->abort_code = abort_code;
+		conn->abort_code = skb->priority;
 		conn->state = RXRPC_CONN_REMOTELY_ABORTED;
 		set_bit(RXRPC_CONN_DONT_REUSE, &conn->flags);
 		rxrpc_abort_calls(conn, RXRPC_CALL_REMOTELY_ABORTED, sp->hdr.serial);
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 44caf88e04b8..42c8257158f7 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -1019,20 +1019,11 @@ static void rxrpc_input_ackall(struct rxrpc_call *call, struct sk_buff *skb)
 static void rxrpc_input_abort(struct rxrpc_call *call, struct sk_buff *skb)
 {
 	struct rxrpc_skb_priv *sp = rxrpc_skb(skb);
-	__be32 wtmp;
-	u32 abort_code = RX_CALL_DEAD;
-
-	_enter("");
-
-	if (skb->len >= 4 &&
-	    skb_copy_bits(skb, sizeof(struct rxrpc_wire_header),
-			  &wtmp, sizeof(wtmp)) >= 0)
-		abort_code = ntohl(wtmp);
 
-	trace_rxrpc_rx_abort(call, sp->hdr.serial, abort_code);
+	trace_rxrpc_rx_abort(call, sp->hdr.serial, skb->priority);
 
 	rxrpc_set_call_completion(call, RXRPC_CALL_REMOTELY_ABORTED,
-				  abort_code, -ECONNABORTED);
+				  skb->priority, -ECONNABORTED);
 }
 
 /*
@@ -1193,6 +1184,20 @@ int rxrpc_extract_header(struct rxrpc_skb_priv *sp, struct sk_buff *skb)
 	return 0;
 }
 
+/*
+ * Extract the abort code from an ABORT packet and stash it in skb->priority.
+ */
+static bool rxrpc_extract_abort(struct sk_buff *skb)
+{
+	__be32 wtmp;
+
+	if (skb_copy_bits(skb, sizeof(struct rxrpc_wire_header),
+			  &wtmp, sizeof(wtmp)) < 0)
+		return false;
+	skb->priority = ntohl(wtmp);
+	return true;
+}
+
 /*
  * handle data received on the local endpoint
  * - may be called in interrupt context
@@ -1264,8 +1269,10 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 	case RXRPC_PACKET_TYPE_ACKALL:
 		if (sp->hdr.callNumber == 0)
 			goto bad_message;
-		fallthrough;
+		break;
 	case RXRPC_PACKET_TYPE_ABORT:
+		if (!rxrpc_extract_abort(skb))
+			return true; /* Just discard if malformed */
 		break;
 
 	case RXRPC_PACKET_TYPE_DATA:


