Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD6F518B2A7
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 12:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbgCSLxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 07:53:43 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:26840 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726765AbgCSLxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 07:53:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584618821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TlemZGMFPyLAz0o0WOTN34KwcHpNjrld/INiHzBFVb4=;
        b=NxHenBAfP6RtTrMEjeJ1LaKU1X4Sj6KwsifRE5TXgoFjjoyJSIv+P+G/uMbgbqC3Vt/sIM
        NnYuUKmlptMpIfUtdRTfVSUc4LzEYJFBWtHId0qt0iZeMBIqKPK4yYJ+f0bpMDk08wWeko
        TyV09ZyeVHy03LE1qWG+sjJ3EtbgSqI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-fNlxqQkgMyiDGUSArZS80A-1; Thu, 19 Mar 2020 07:53:39 -0400
X-MC-Unique: fNlxqQkgMyiDGUSArZS80A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C630E1902EA4;
        Thu, 19 Mar 2020 11:53:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-126.rdu2.redhat.com [10.10.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C2EB100164D;
        Thu, 19 Mar 2020 11:53:37 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net 1/6] rxrpc: Abstract out the calculation of whether
 there's Tx space
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 19 Mar 2020 11:53:36 +0000
Message-ID: <158461881648.3094720.6613599061371004433.stgit@warthog.procyon.org.uk>
In-Reply-To: <158461880968.3094720.5019510060910604912.stgit@warthog.procyon.org.uk>
References: <158461880968.3094720.5019510060910604912.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Abstract out the calculation of there being sufficient Tx buffer space.
This is reproduced several times in the rxrpc sendmsg code.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/sendmsg.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/net/rxrpc/sendmsg.c b/net/rxrpc/sendmsg.c
index 813fd6888142..a13051d38097 100644
--- a/net/rxrpc/sendmsg.c
+++ b/net/rxrpc/sendmsg.c
@@ -17,6 +17,21 @@
 #include <net/af_rxrpc.h>
 #include "ar-internal.h"
 
+/*
+ * Return true if there's sufficient Tx queue space.
+ */
+static bool rxrpc_check_tx_space(struct rxrpc_call *call, rxrpc_seq_t *_tx_win)
+{
+	unsigned int win_size =
+		min_t(unsigned int, call->tx_winsize,
+		      call->cong_cwnd + call->cong_extra);
+	rxrpc_seq_t tx_win = READ_ONCE(call->tx_hard_ack);
+
+	if (_tx_win)
+		*_tx_win = tx_win;
+	return call->tx_top - tx_win < win_size;
+}
+
 /*
  * Wait for space to appear in the Tx queue or a signal to occur.
  */
@@ -26,9 +41,7 @@ static int rxrpc_wait_for_tx_window_intr(struct rxrpc_sock *rx,
 {
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		if (call->tx_top - call->tx_hard_ack <
-		    min_t(unsigned int, call->tx_winsize,
-			  call->cong_cwnd + call->cong_extra))
+		if (rxrpc_check_tx_space(call, NULL))
 			return 0;
 
 		if (call->state >= RXRPC_CALL_COMPLETE)
@@ -68,9 +81,7 @@ static int rxrpc_wait_for_tx_window_nonintr(struct rxrpc_sock *rx,
 		set_current_state(TASK_UNINTERRUPTIBLE);
 
 		tx_win = READ_ONCE(call->tx_hard_ack);
-		if (call->tx_top - tx_win <
-		    min_t(unsigned int, call->tx_winsize,
-			  call->cong_cwnd + call->cong_extra))
+		if (rxrpc_check_tx_space(call, &tx_win))
 			return 0;
 
 		if (call->state >= RXRPC_CALL_COMPLETE)
@@ -302,9 +313,7 @@ static int rxrpc_send_data(struct rxrpc_sock *rx,
 
 			_debug("alloc");
 
-			if (call->tx_top - call->tx_hard_ack >=
-			    min_t(unsigned int, call->tx_winsize,
-				  call->cong_cwnd + call->cong_extra)) {
+			if (!rxrpc_check_tx_space(call, NULL)) {
 				ret = -EAGAIN;
 				if (msg->msg_flags & MSG_DONTWAIT)
 					goto maybe_error;


