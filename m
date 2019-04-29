Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAAC9DBE6
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 08:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbfD2GQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 02:16:32 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35795 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfD2GQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 02:16:31 -0400
Received: by mail-ed1-f66.google.com with SMTP id y67so8095504ede.2;
        Sun, 28 Apr 2019 23:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6IPp7H/sLIOQs26JX8kJ90254qt0VaVBVXDg0mJFiEI=;
        b=HYPmUMZEas5cSbEo8cDy0I3z2AhrAykWDnBDGM0NUcAsUFMDVGO5gYs+Mj/ojjiZYX
         vqiG/kaW0ZzoqVh0RzYf6FhRL8PxeZRziADuYoBuFDbOI5pxyONBWLMfKO0ooG/MY1mJ
         bXhAMfkoBL5CBTua1huv8heqG8v0PtrZgec/8VjyfoNy6UZndoqQObG7HxBdaORvLJ2o
         KKSE76V397P+8ME/TwlbkGpnqBAmY881zQCFpS1XtwLp4m8BJhMPBky/O22xAxldvWUw
         Cejv8WPLAYqQ71i+zVeukSRk5Q1b6qVUd9JRAPXWk27Q3I+76ZzDeI90Ytcou36x9d8P
         NBVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6IPp7H/sLIOQs26JX8kJ90254qt0VaVBVXDg0mJFiEI=;
        b=f7lEV5YY2aJ8mBX1BHPyFOiohyI9Ap0jQdhGrK5qbgd8V8ouqf339H/BicBG27/FW6
         eavKxqJSvHA3sGdFqhNZ+0/K5x7hgfvsssJJTv9Ro8VtwnFglN76WqpxLNoFohVgBDor
         PoflRRKV9itL88PqKj8jK0VawdzvTCkb2oRNJvZWqRzg0Zgd6naIMwyNFp6xk/068+zp
         IVM9ukS7nfWrxIWUt//hQ5eTv39aYg1ZyS04nCGv+OcJcrUhIG5ZnYVaprDhdHio0rQr
         i9WKQ2AR/enYBsMuO/6ywkOG9zbuyzkpFDgne+F9pQ+8RpJ5+8LwgtqsSZjR9YektEMk
         jn3w==
X-Gm-Message-State: APjAAAVea1+2HHZ2FpY9hZJAIGF5TYcEtOcGsQLGgWGmTXpBiyhz64Ap
        eFKbuAm8XqCBanMkDZBExtEc5U28
X-Google-Smtp-Source: APXvYqyW3Ph2MRTnv01ny3JlX9pJp+xpozD+iqvrt7QyD/zeHryTpUsGINcBr4K8YC4WVxszyDRc8w==
X-Received: by 2002:a50:b68a:: with SMTP id d10mr14678192ede.79.1556518589711;
        Sun, 28 Apr 2019 23:16:29 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f7sm8951483edj.10.2019.04.28.23.16.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Apr 2019 23:16:29 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net] sctp: avoid running the sctp state machine recursively
Date:   Mon, 29 Apr 2019 14:16:19 +0800
Message-Id: <3a5d5e96521a5f53ed36ca85219294c34be7d0ef.1556518579.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ying triggered a call trace when doing an asconf testing:

  BUG: scheduling while atomic: swapper/12/0/0x10000100
  Call Trace:
   <IRQ>  [<ffffffffa4375904>] dump_stack+0x19/0x1b
   [<ffffffffa436fcaf>] __schedule_bug+0x64/0x72
   [<ffffffffa437b93a>] __schedule+0x9ba/0xa00
   [<ffffffffa3cd5326>] __cond_resched+0x26/0x30
   [<ffffffffa437bc4a>] _cond_resched+0x3a/0x50
   [<ffffffffa3e22be8>] kmem_cache_alloc_node+0x38/0x200
   [<ffffffffa423512d>] __alloc_skb+0x5d/0x2d0
   [<ffffffffc0995320>] sctp_packet_transmit+0x610/0xa20 [sctp]
   [<ffffffffc098510e>] sctp_outq_flush+0x2ce/0xc00 [sctp]
   [<ffffffffc098646c>] sctp_outq_uncork+0x1c/0x20 [sctp]
   [<ffffffffc0977338>] sctp_cmd_interpreter.isra.22+0xc8/0x1460 [sctp]
   [<ffffffffc0976ad1>] sctp_do_sm+0xe1/0x350 [sctp]
   [<ffffffffc099443d>] sctp_primitive_ASCONF+0x3d/0x50 [sctp]
   [<ffffffffc0977384>] sctp_cmd_interpreter.isra.22+0x114/0x1460 [sctp]
   [<ffffffffc0976ad1>] sctp_do_sm+0xe1/0x350 [sctp]
   [<ffffffffc097b3a4>] sctp_assoc_bh_rcv+0xf4/0x1b0 [sctp]
   [<ffffffffc09840f1>] sctp_inq_push+0x51/0x70 [sctp]
   [<ffffffffc099732b>] sctp_rcv+0xa8b/0xbd0 [sctp]

As it shows, the first sctp_do_sm() running under atomic context (NET_RX
softirq) invoked sctp_primitive_ASCONF() that uses GFP_KERNEL flag later,
and this flag is supposed to be used in non-atomic context only. Besides,
sctp_do_sm() was called recursively, which is not expected.

Vlad tried to fix this recursive call in Commit c0786693404c ("sctp: Fix
oops when sending queued ASCONF chunks") by introducing a new command
SCTP_CMD_SEND_NEXT_ASCONF. But it didn't work as this command is still
used in the first sctp_do_sm() call, and sctp_primitive_ASCONF() will
be called in this command again.

To avoid calling sctp_do_sm() recursively, we send the next queued ASCONF
not by sctp_primitive_ASCONF(), but by sctp_sf_do_prm_asconf() in the 1st
sctp_do_sm() directly.

Reported-by: Ying Xu <yinxu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/command.h |  1 -
 net/sctp/sm_sideeffect.c   | 29 -----------------------------
 net/sctp/sm_statefuns.c    | 35 +++++++++++++++++++++++++++--------
 3 files changed, 27 insertions(+), 38 deletions(-)

diff --git a/include/net/sctp/command.h b/include/net/sctp/command.h
index 6640f84..6d5beac 100644
--- a/include/net/sctp/command.h
+++ b/include/net/sctp/command.h
@@ -105,7 +105,6 @@ enum sctp_verb {
 	SCTP_CMD_T1_RETRAN,	 /* Mark for retransmission after T1 timeout  */
 	SCTP_CMD_UPDATE_INITTAG, /* Update peer inittag */
 	SCTP_CMD_SEND_MSG,	 /* Send the whole use message */
-	SCTP_CMD_SEND_NEXT_ASCONF, /* Send the next ASCONF after ACK */
 	SCTP_CMD_PURGE_ASCONF_QUEUE, /* Purge all asconf queues.*/
 	SCTP_CMD_SET_ASOC,	 /* Restore association context */
 	SCTP_CMD_LAST
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 1d143bc..4aa0358 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1112,32 +1112,6 @@ static void sctp_cmd_send_msg(struct sctp_association *asoc,
 }
 
 
-/* Sent the next ASCONF packet currently stored in the association.
- * This happens after the ASCONF_ACK was succeffully processed.
- */
-static void sctp_cmd_send_asconf(struct sctp_association *asoc)
-{
-	struct net *net = sock_net(asoc->base.sk);
-
-	/* Send the next asconf chunk from the addip chunk
-	 * queue.
-	 */
-	if (!list_empty(&asoc->addip_chunk_list)) {
-		struct list_head *entry = asoc->addip_chunk_list.next;
-		struct sctp_chunk *asconf = list_entry(entry,
-						struct sctp_chunk, list);
-		list_del_init(entry);
-
-		/* Hold the chunk until an ASCONF_ACK is received. */
-		sctp_chunk_hold(asconf);
-		if (sctp_primitive_ASCONF(net, asoc, asconf))
-			sctp_chunk_free(asconf);
-		else
-			asoc->addip_last_asconf = asconf;
-	}
-}
-
-
 /* These three macros allow us to pull the debugging code out of the
  * main flow of sctp_do_sm() to keep attention focused on the real
  * functionality there.
@@ -1783,9 +1757,6 @@ static int sctp_cmd_interpreter(enum sctp_event_type event_type,
 			}
 			sctp_cmd_send_msg(asoc, cmd->obj.msg, gfp);
 			break;
-		case SCTP_CMD_SEND_NEXT_ASCONF:
-			sctp_cmd_send_asconf(asoc);
-			break;
 		case SCTP_CMD_PURGE_ASCONF_QUEUE:
 			sctp_asconf_queue_teardown(asoc);
 			break;
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index c9ae340..713a669 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3824,6 +3824,29 @@ enum sctp_disposition sctp_sf_do_asconf(struct net *net,
 	return SCTP_DISPOSITION_CONSUME;
 }
 
+static enum sctp_disposition sctp_send_next_asconf(
+					struct net *net,
+					const struct sctp_endpoint *ep,
+					struct sctp_association *asoc,
+					const union sctp_subtype type,
+					struct sctp_cmd_seq *commands)
+{
+	struct sctp_chunk *asconf;
+	struct list_head *entry;
+
+	if (list_empty(&asoc->addip_chunk_list))
+		return SCTP_DISPOSITION_CONSUME;
+
+	entry = asoc->addip_chunk_list.next;
+	asconf = list_entry(entry, struct sctp_chunk, list);
+
+	list_del_init(entry);
+	sctp_chunk_hold(asconf);
+	asoc->addip_last_asconf = asconf;
+
+	return sctp_sf_do_prm_asconf(net, ep, asoc, type, asconf, commands);
+}
+
 /*
  * ADDIP Section 4.3 General rules for address manipulation
  * When building TLV parameters for the ASCONF Chunk that will add or
@@ -3915,14 +3938,10 @@ enum sctp_disposition sctp_sf_do_asconf_ack(struct net *net,
 				SCTP_TO(SCTP_EVENT_TIMEOUT_T4_RTO));
 
 		if (!sctp_process_asconf_ack((struct sctp_association *)asoc,
-					     asconf_ack)) {
-			/* Successfully processed ASCONF_ACK.  We can
-			 * release the next asconf if we have one.
-			 */
-			sctp_add_cmd_sf(commands, SCTP_CMD_SEND_NEXT_ASCONF,
-					SCTP_NULL());
-			return SCTP_DISPOSITION_CONSUME;
-		}
+					     asconf_ack))
+			return sctp_send_next_asconf(net, ep,
+					(struct sctp_association *)asoc,
+							type, commands);
 
 		abort = sctp_make_abort(asoc, asconf_ack,
 					sizeof(struct sctp_errhdr));
-- 
2.1.0

