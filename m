Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9E5194F8A
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 04:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgC0DH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 23:07:59 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46902 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727446AbgC0DH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 23:07:59 -0400
Received: by mail-pf1-f195.google.com with SMTP id q3so3795798pff.13;
        Thu, 26 Mar 2020 20:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2DQUOCm1EaVk4TsyfJrUq1iAxjoNQGGgwCMFKg9aS9g=;
        b=XqGi/tiazfMdyxJUvUzP5R+WcHVs3t2gtjdaaJnkfxwd6AS3Dhon8D7T8Hvs3hezZG
         1SBMyLISonSsAIo+qkFafQXCCedhzx5827FvRafihFmoGdDD0P2Dth9Rii76GU/STTj8
         iwAWK+L7DT1iaDCn9gm7jpvOonVUh4lIgb1mFv+Yol0TnO46ESIqzlnPOVB0SE5wxiYD
         5blJOI8ZUwyhNynM8/bgpZJLcBujN614V8M5oUJ0N9Q2agFzM6ZMXLjXCTWpF2X2KemX
         gBIOxAOKF1u2jz9c2THj1okZcOfZFAG2C4CmiQYhW04bGMi/Xdw8H4kmlcM1sjQQzLPS
         qEnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2DQUOCm1EaVk4TsyfJrUq1iAxjoNQGGgwCMFKg9aS9g=;
        b=cdweE6YLI+wu/s+Guc4f8+JySQvJ0RIrhiwNzdfapops/AvDSEkcfptbASOLPU6K1N
         b2fQnZYK0yNDRo0/lhfxHw+jlQ/4pIySNs0ycLpINxvutUaO55MKVmVtpZR3eY+EPtNa
         vY08Sa+9xeRVYC34fwk9iE31tgv4/U1S63Y5yf2OkCdasHfAOziufZK0TyeHI+xQ5uMj
         FQ2OVrgiNI3i7Fr/6E72iynFsdGZIsSCpy2ZsMH88YFH1uV89NIcEAuLf0+uRq5BrYbK
         fMwFMnUzoDbzOKrObCvWUQ/IJr+VhRyava3icGJMTXnNDHgWs+C4cuTJGiGPGMKv3jNl
         9tlw==
X-Gm-Message-State: ANhLgQ14EZz+wy92G2NP1PVqmMVKPjSWYd0dXvHRshN8mdCzDMLsJXCt
        u4419REaslsv5jueKUKbJw7Go5ShIhrEVw==
X-Google-Smtp-Source: ADFU+vvzLjoiyk6aa4bXaqKb0l9qNEJQaMPG0FyhsOBZ2iDmDjYTF2pETniPQE5M1pJVBQjo7k0WlA==
X-Received: by 2002:a62:15cc:: with SMTP id 195mr12866413pfv.276.1585278478035;
        Thu, 26 Mar 2020 20:07:58 -0700 (PDT)
Received: from localhost ([161.117.239.120])
        by smtp.gmail.com with ESMTPSA id w31sm2750543pgl.84.2020.03.26.20.07.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 26 Mar 2020 20:07:57 -0700 (PDT)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     marcelo.leitner@gmail.com, davem@davemloft.net
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, kuba@kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, anenbupt@gmail.com,
        Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH v6] sctp: fix refcount bug in sctp_wfree
Date:   Fri, 27 Mar 2020 11:07:51 +0800
Message-Id: <20200327030751.19404-1-hqjagain@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should iterate over the datamsgs to move
all chunks(skbs) to newsk.

The following case cause the bug:
for the trouble SKB, it was in outq->transmitted list

sctp_outq_sack
        sctp_check_transmitted
                SKB was moved to outq->sacked list
        then throw away the sack queue
                SKB was deleted from outq->sacked
(but it was held by datamsg at sctp_datamsg_to_asoc
So, sctp_wfree was not called here)

then migrate happened

        sctp_for_each_tx_datachunk(
        sctp_clear_owner_w);
        sctp_assoc_migrate();
        sctp_for_each_tx_datachunk(
        sctp_set_owner_w);
SKB was not in the outq, and was not changed to newsk

finally

__sctp_outq_teardown
        sctp_chunk_put (for another skb)
                sctp_datamsg_put
                        __kfree_skb(msg->frag_list)
                                sctp_wfree (for SKB)
	SKB->sk was still oldsk (skb->sk != asoc->base.sk).

Reported-and-tested-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 net/sctp/socket.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 1b56fc440606..f68076713162 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -147,29 +147,44 @@ static void sctp_clear_owner_w(struct sctp_chunk *chunk)
 	skb_orphan(chunk->skb);
 }
 
+#define traverse_and_process()	\
+do {				\
+	msg = chunk->msg;	\
+	if (msg == prev_msg)	\
+		continue;	\
+	list_for_each_entry(c, &msg->chunks, frag_list) {	\
+		if ((clear && asoc->base.sk == c->skb->sk) ||	\
+		    (!clear && asoc->base.sk != c->skb->sk))	\
+			cb(c);	\
+	}			\
+	prev_msg = msg;		\
+} while (0)
+
 static void sctp_for_each_tx_datachunk(struct sctp_association *asoc,
+				       bool clear,
 				       void (*cb)(struct sctp_chunk *))
 
 {
+	struct sctp_datamsg *msg, *prev_msg = NULL;
 	struct sctp_outq *q = &asoc->outqueue;
+	struct sctp_chunk *chunk, *c;
 	struct sctp_transport *t;
-	struct sctp_chunk *chunk;
 
 	list_for_each_entry(t, &asoc->peer.transport_addr_list, transports)
 		list_for_each_entry(chunk, &t->transmitted, transmitted_list)
-			cb(chunk);
+			traverse_and_process();
 
 	list_for_each_entry(chunk, &q->retransmit, transmitted_list)
-		cb(chunk);
+		traverse_and_process();
 
 	list_for_each_entry(chunk, &q->sacked, transmitted_list)
-		cb(chunk);
+		traverse_and_process();
 
 	list_for_each_entry(chunk, &q->abandoned, transmitted_list)
-		cb(chunk);
+		traverse_and_process();
 
 	list_for_each_entry(chunk, &q->out_chunk_list, list)
-		cb(chunk);
+		traverse_and_process();
 }
 
 static void sctp_for_each_rx_skb(struct sctp_association *asoc, struct sock *sk,
@@ -9574,9 +9589,9 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 	 * paths won't try to lock it and then oldsk.
 	 */
 	lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
-	sctp_for_each_tx_datachunk(assoc, sctp_clear_owner_w);
+	sctp_for_each_tx_datachunk(assoc, true, sctp_clear_owner_w);
 	sctp_assoc_migrate(assoc, newsk);
-	sctp_for_each_tx_datachunk(assoc, sctp_set_owner_w);
+	sctp_for_each_tx_datachunk(assoc, false, sctp_set_owner_w);
 
 	/* If the association on the newsk is already closed before accept()
 	 * is called, set RCV_SHUTDOWN flag.
-- 
2.17.1

