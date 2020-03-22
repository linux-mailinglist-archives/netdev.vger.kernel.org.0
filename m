Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD46E18E7B6
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 10:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgCVJEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 05:04:32 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35806 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgCVJEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 05:04:32 -0400
Received: by mail-pl1-f194.google.com with SMTP id g6so4518752plt.2;
        Sun, 22 Mar 2020 02:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kOrH9obYAhAAUwDoWxwdeahbQ3EMm25sPBi4jccaRMc=;
        b=b1uHgD+jdr8UXfkUYkXDIjYA3jRFUdWw5/l0hKKavJOIBXbuc9y66BYBLEa5ZlbbDr
         4XTEgEroryedhvhz7lfcV1v17NWfVvJ8wpdQnsNtuzGh0s7ZDF7TKbo+fxeSG8AAmr+x
         fMRfI9N7PFCgdcSpaoJjzSez/75Ds0q4laPiuXQLHSE5FQE97GwUv6fpTiWWdIkLoz29
         L22f20CWYGAF/I1SRxesN6qZbOGe5fhzGZcn5NoBL319ZDDS3t61rf4GGfTBApHvwjVP
         StSqlzCvOO8GCTPVUmJf4VtEZM3vBZrn/H0b20n1/ZnlPp7rpZhX9x1xAs/orSzNCygw
         GZzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kOrH9obYAhAAUwDoWxwdeahbQ3EMm25sPBi4jccaRMc=;
        b=G55+hmRhVHAYAUj2MArHuIuO8bub52QjJJTUgKyq1lDFpPFQPcg61hiQ5iomvza59u
         6HCcxU9iIpO5t4I0BHluZLKaaJu8b5LivWXRvXbVfzAH5gcS+kJSIjwkVavPE71h7ALu
         eySK7GiIyJ6WoTaPi9Id6di/V1gWcazCmOa1Mezh9/wJbIFI5Ix0ni/sn3Sao1IB41Tb
         aT/4crARfph6KNqGsHctL6ILQoHbtPzT/csM9BR2DIJESAXymgLS/Mq2cIWjzYUKQCHE
         L8h5cOtnLKmqf7y4/R8xeCVk9q9JKZDDkwt5yB6/SiPWNFNkTYK1DsyplKoe5iIF/1oK
         DZzQ==
X-Gm-Message-State: ANhLgQ3X7Qj6KYCUzn4bRf65g1cXxTOHfqreGVCwXpmf2VA3o1Dfrkd6
        F714IEV0uplTVImt/ANUMi4=
X-Google-Smtp-Source: ADFU+vtAGBlHwd72iLAZq7XB4NlHgv1KiyK/Y2sA9AklismBOMr/rZecQtNXuJfnNAu+UEbOQsnF0g==
X-Received: by 2002:a17:90a:c392:: with SMTP id h18mr6937339pjt.89.1584867870863;
        Sun, 22 Mar 2020 02:04:30 -0700 (PDT)
Received: from localhost ([161.117.239.120])
        by smtp.gmail.com with ESMTPSA id y9sm5948074pfo.135.2020.03.22.02.04.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Mar 2020 02:04:30 -0700 (PDT)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     marcelo.leitner@gmail.com, davem@davemloft.net
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, kuba@kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, anenbupt@gmail.com,
        Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH v4] sctp: fix refcount bug in sctp_wfree
Date:   Sun, 22 Mar 2020 17:04:25 +0800
Message-Id: <20200322090425.6253-1-hqjagain@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sctp_sock_migrate should iterate over the datamsgs to modify
all trunks(skbs) to newsk. For this, out_msg_list is added to
sctp_outq to maintain datamsgs list.

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
 include/net/sctp/structs.h |  5 +++++
 net/sctp/chunk.c           |  4 ++++
 net/sctp/outqueue.c        |  1 +
 net/sctp/sm_sideeffect.c   |  1 +
 net/sctp/socket.c          | 27 +++++++--------------------
 5 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 314a2fa21d6b..f72ba7418230 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -522,6 +522,8 @@ struct sctp_pf {
 struct sctp_datamsg {
 	/* Chunks waiting to be submitted to lower layer. */
 	struct list_head chunks;
+	/* List in outq. */
+	struct list_head list;
 	/* Reference counting. */
 	refcount_t refcnt;
 	/* When is this message no longer interesting to the peer? */
@@ -1063,6 +1065,9 @@ struct sctp_outq {
 	/* Data pending that has never been transmitted.  */
 	struct list_head out_chunk_list;
 
+	/* Data msg list. */
+	struct list_head out_msg_list;
+
 	/* Stream scheduler being used */
 	struct sctp_sched_ops *sched;
 
diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index ab6a997e222f..17b38e9a8a7b 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -41,6 +41,7 @@ static void sctp_datamsg_init(struct sctp_datamsg *msg)
 	msg->abandoned = 0;
 	msg->expires_at = 0;
 	INIT_LIST_HEAD(&msg->chunks);
+	INIT_LIST_HEAD(&msg->list);
 }
 
 /* Allocate and initialize datamsg. */
@@ -111,6 +112,9 @@ static void sctp_datamsg_destroy(struct sctp_datamsg *msg)
 		sctp_chunk_put(chunk);
 	}
 
+	if (!list_empty(&msg->list))
+		list_del_init(&msg->list);
+
 	SCTP_DBG_OBJCNT_DEC(datamsg);
 	kfree(msg);
 }
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 577e3bc4ee6f..3bbcb140c887 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -194,6 +194,7 @@ void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q)
 
 	q->asoc = asoc;
 	INIT_LIST_HEAD(&q->out_chunk_list);
+	INIT_LIST_HEAD(&q->out_msg_list);
 	INIT_LIST_HEAD(&q->control_chunk_list);
 	INIT_LIST_HEAD(&q->retransmit);
 	INIT_LIST_HEAD(&q->sacked);
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 2bc29463e1dc..93cc911256f6 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -1099,6 +1099,7 @@ static void sctp_cmd_send_msg(struct sctp_association *asoc,
 	list_for_each_entry(chunk, &msg->chunks, frag_list)
 		sctp_outq_tail(&asoc->outqueue, chunk, gfp);
 
+	list_add_tail(&msg->list, &asoc->outqueue.out_msg_list);
 	asoc->outqueue.sched->enqueue(&asoc->outqueue, msg);
 }
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 1b56fc440606..32f6111bccbf 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -147,29 +147,16 @@ static void sctp_clear_owner_w(struct sctp_chunk *chunk)
 	skb_orphan(chunk->skb);
 }
 
-static void sctp_for_each_tx_datachunk(struct sctp_association *asoc,
-				       void (*cb)(struct sctp_chunk *))
+static void sctp_for_each_tx_datamsg(struct sctp_association *asoc,
+				     void (*cb)(struct sctp_chunk *))
 
 {
-	struct sctp_outq *q = &asoc->outqueue;
-	struct sctp_transport *t;
 	struct sctp_chunk *chunk;
+	struct sctp_datamsg *msg;
 
-	list_for_each_entry(t, &asoc->peer.transport_addr_list, transports)
-		list_for_each_entry(chunk, &t->transmitted, transmitted_list)
+	list_for_each_entry(msg, &asoc->outqueue.out_msg_list, list)
+		list_for_each_entry(chunk, &msg->chunks, frag_list)
 			cb(chunk);
-
-	list_for_each_entry(chunk, &q->retransmit, transmitted_list)
-		cb(chunk);
-
-	list_for_each_entry(chunk, &q->sacked, transmitted_list)
-		cb(chunk);
-
-	list_for_each_entry(chunk, &q->abandoned, transmitted_list)
-		cb(chunk);
-
-	list_for_each_entry(chunk, &q->out_chunk_list, list)
-		cb(chunk);
 }
 
 static void sctp_for_each_rx_skb(struct sctp_association *asoc, struct sock *sk,
@@ -9574,9 +9561,9 @@ static int sctp_sock_migrate(struct sock *oldsk, struct sock *newsk,
 	 * paths won't try to lock it and then oldsk.
 	 */
 	lock_sock_nested(newsk, SINGLE_DEPTH_NESTING);
-	sctp_for_each_tx_datachunk(assoc, sctp_clear_owner_w);
+	sctp_for_each_tx_datamsg(assoc, sctp_clear_owner_w);
 	sctp_assoc_migrate(assoc, newsk);
-	sctp_for_each_tx_datachunk(assoc, sctp_set_owner_w);
+	sctp_for_each_tx_datamsg(assoc, sctp_set_owner_w);
 
 	/* If the association on the newsk is already closed before accept()
 	 * is called, set RCV_SHUTDOWN flag.
-- 
2.17.1

