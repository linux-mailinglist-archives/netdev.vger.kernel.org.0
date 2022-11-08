Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDE9621F06
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiKHWUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiKHWTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:19:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFD91FF91
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667945922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xb7af/5diUrFUl9ancNi6nQtbH8oUYUWmCJxixi9h7o=;
        b=gFpieqfqrnMGjbmgm71QVW2ghazYldcKrJuN4BSFyjeBQOShwiK3n0nTaP1NC1pFHPLqFu
        j4peLf9sZyDxohtNmdweKR6RsTYi6wITM9hR77upBER8taXedtNEqdYDg+/gnBlm7rjDBR
        tzTDKw4ingDGnBFfoKsa4KD2nznFQH4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-zhJAcVIoMnaSYmw_zaK4Cw-1; Tue, 08 Nov 2022 17:18:38 -0500
X-MC-Unique: zhJAcVIoMnaSYmw_zaK4Cw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 187B529A8AFB;
        Tue,  8 Nov 2022 22:18:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E84C112132E;
        Tue,  8 Nov 2022 22:18:37 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net-next 07/26] rxrpc: Record stats for why the REQUEST-ACK
 flag is being set
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Nov 2022 22:18:36 +0000
Message-ID: <166794591698.2389296.7059246656950884328.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Record stats for why the REQUEST-ACK flag is being set.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
---

 include/trace/events/rxrpc.h |    1 +
 net/rxrpc/ar-internal.h      |    2 ++
 net/rxrpc/output.c           |    1 +
 net/rxrpc/proc.c             |   14 ++++++++++++++
 4 files changed, 18 insertions(+)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index a72f04e3d264..794523d15321 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -250,6 +250,7 @@
 	EM(rxrpc_reqack_retrans,		"RETRANS   ")	\
 	EM(rxrpc_reqack_slow_start,		"SLOW-START")	\
 	E_(rxrpc_reqack_small_txwin,		"SMALL-TXWN")
+/* ---- Must update size of stat_why_req_ack[] if more are added! */
 
 /*
  * Generate enums for tracing information.
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 8ed707a11d43..436a1e8d0abd 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -107,6 +107,8 @@ struct rxrpc_net {
 	atomic_t		stat_tx_ack_skip;
 	atomic_t		stat_tx_acks[256];
 	atomic_t		stat_rx_acks[256];
+
+	atomic_t		stat_why_req_ack[8];
 };
 
 /*
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index f350d39e3a60..77ed46ab33c5 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -430,6 +430,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	else
 		goto dont_set_request_ack;
 
+	rxrpc_inc_stat(call->rxnet, stat_why_req_ack[why]);
 	trace_rxrpc_req_ack(call->debug_id, sp->hdr.seq, why);
 	if (why != rxrpc_reqack_no_srv_last)
 		whdr.flags |= RXRPC_REQUEST_ACK;
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index 488c403f1d33..9bd357f39c39 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -445,6 +445,18 @@ int rxrpc_stats_show(struct seq_file *seq, void *v)
 		   atomic_read(&rxnet->stat_rx_acks[RXRPC_ACK_PING_RESPONSE]),
 		   atomic_read(&rxnet->stat_rx_acks[RXRPC_ACK_DELAY]),
 		   atomic_read(&rxnet->stat_rx_acks[RXRPC_ACK_IDLE]));
+	seq_printf(seq,
+		   "Why-Req-A: acklost=%u already=%u mrtt=%u ortt=%u\n",
+		   atomic_read(&rxnet->stat_why_req_ack[rxrpc_reqack_ack_lost]),
+		   atomic_read(&rxnet->stat_why_req_ack[rxrpc_reqack_already_on]),
+		   atomic_read(&rxnet->stat_why_req_ack[rxrpc_reqack_more_rtt]),
+		   atomic_read(&rxnet->stat_why_req_ack[rxrpc_reqack_old_rtt]));
+	seq_printf(seq,
+		   "Why-Req-A: nolast=%u retx=%u slows=%u smtxw=%u\n",
+		   atomic_read(&rxnet->stat_why_req_ack[rxrpc_reqack_no_srv_last]),
+		   atomic_read(&rxnet->stat_why_req_ack[rxrpc_reqack_retrans]),
+		   atomic_read(&rxnet->stat_why_req_ack[rxrpc_reqack_slow_start]),
+		   atomic_read(&rxnet->stat_why_req_ack[rxrpc_reqack_small_txwin]));
 	seq_printf(seq,
 		   "Buffers  : txb=%u rxb=%u\n",
 		   atomic_read(&rxrpc_n_tx_skbs),
@@ -476,5 +488,7 @@ int rxrpc_stats_clear(struct file *file, char *buf, size_t size)
 	atomic_set(&rxnet->stat_tx_ack_skip, 0);
 	memset(&rxnet->stat_tx_acks, 0, sizeof(rxnet->stat_tx_acks));
 	memset(&rxnet->stat_rx_acks, 0, sizeof(rxnet->stat_rx_acks));
+
+	memset(&rxnet->stat_why_req_ack, 0, sizeof(rxnet->stat_why_req_ack));
 	return size;
 }


