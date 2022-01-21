Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F2F49681F
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 00:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiAUXNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 18:13:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41554 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbiAUXND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 18:13:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642806782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=38CLyOOFGNpsCH2Hm5Xzqz1LpA2MMoJHumLXa5e8yw0=;
        b=QnhfbvZqvJut7xASbRinIInUHhFgX5705sLsK/XbAUpXTXLGX1O0UbJ69ZZ7lQAoBf+Vvs
        xBLmLdN2cNjxpDaSkvgruP+5VXYgoqkodeBgchBDUpy0Mjx7kV51a8jy2RtULN90PkdCuD
        ERy7EXKTSAVEXC80oKfJ26fgBF78fTc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-PCfsLRkTMk60m92azzUROQ-1; Fri, 21 Jan 2022 18:13:01 -0500
X-MC-Unique: PCfsLRkTMk60m92azzUROQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97EAB8143E5;
        Fri, 21 Jan 2022 23:13:00 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 876F9108AD;
        Fri, 21 Jan 2022 23:12:59 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net] rxrpc: Adjust retransmission backoff
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 21 Jan 2022 23:12:58 +0000
Message-ID: <164280677857.1397447.9028458701099013997.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve retransmission backoff by only backing off when we retransmit data
packets rather than when we set the lost ack timer.

To this end:

 (1) In rxrpc_resend(), use rxrpc_get_rto_backoff() when setting the
     retransmission timer and only tell it that we are retransmitting if we
     actually have things to retransmit.

     Note that it's possible for the retransmission algorithm to race with
     the processing of a received ACK, so we may see no packets needing
     retransmission.

 (2) In rxrpc_send_data_packet(), don't bump the backoff when setting the
     ack_lost_at timer, as it may then get bumped twice.

With this, when looking at one particular packet, the retransmission
intervals were seen to be 1.5ms, 2ms, 3ms, 5ms, 9ms, 17ms, 33ms, 71ms,
136ms, 264ms, 544ms, 1.088s, 2.1s, 4.2s and 8.3s.

Fixes: c410bf01933e ("rxrpc: Fix the excessive initial retransmission timeout")
Suggested-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Tested-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/164138117069.2023386.17446904856843997127.stgit@warthog.procyon.org.uk/
---

 net/rxrpc/call_event.c |    8 +++-----
 net/rxrpc/output.c     |    2 +-
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index 6be2672a65ea..df864e692267 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -157,7 +157,7 @@ static void rxrpc_congestion_timeout(struct rxrpc_call *call)
 static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 {
 	struct sk_buff *skb;
-	unsigned long resend_at, rto_j;
+	unsigned long resend_at;
 	rxrpc_seq_t cursor, seq, top;
 	ktime_t now, max_age, oldest, ack_ts;
 	int ix;
@@ -165,10 +165,8 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 
 	_enter("{%d,%d}", call->tx_hard_ack, call->tx_top);
 
-	rto_j = call->peer->rto_j;
-
 	now = ktime_get_real();
-	max_age = ktime_sub(now, jiffies_to_usecs(rto_j));
+	max_age = ktime_sub(now, jiffies_to_usecs(call->peer->rto_j));
 
 	spin_lock_bh(&call->lock);
 
@@ -213,7 +211,7 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 	}
 
 	resend_at = nsecs_to_jiffies(ktime_to_ns(ktime_sub(now, oldest)));
-	resend_at += jiffies + rto_j;
+	resend_at += jiffies + rxrpc_get_rto_backoff(call->peer, retrans);
 	WRITE_ONCE(call->resend_at, resend_at);
 
 	if (unacked)
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 10f2bf2e9068..a45c83f22236 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -468,7 +468,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 			if (call->peer->rtt_count > 1) {
 				unsigned long nowj = jiffies, ack_lost_at;
 
-				ack_lost_at = rxrpc_get_rto_backoff(call->peer, retrans);
+				ack_lost_at = rxrpc_get_rto_backoff(call->peer, false);
 				ack_lost_at += nowj;
 				WRITE_ONCE(call->ack_lost_at, ack_lost_at);
 				rxrpc_reduce_call_timer(call, ack_lost_at, nowj,


