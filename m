Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C95B1194E71
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 02:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgC0B2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 21:28:39 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36515 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727696AbgC0B2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 21:28:39 -0400
Received: by mail-pf1-f195.google.com with SMTP id i13so3709162pfe.3;
        Thu, 26 Mar 2020 18:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Wn2KMixsOvTxOcizpjpAsR4EdISJdwDYaV+po/VHdGM=;
        b=IQOxyx6gjjTtLnmSZW8H9ipDdwt8Zuh0/lds8DQEe6d5YRkKFJwDMfOqG2WszyY3az
         fp7ZWo8B4GoIBKoVIwiEhq9uF/DWeIEvxzDQn9HATvz20ICqfPgjoRcycALMxvQKGQPC
         BGoZ16ebyqHS7CokW09aByvxPJBKCA8gNt3vCgE8cHCp/4San8owBCNedPupf/LgvrD0
         efwK6X9ty1hdMUhGwpT+mak5LKx8xxjWbSN664AgQIJKrkOg3XmOKkyoeWDVolVoAZhI
         4NHVycZ/+dVfKVMiGdCZIcNW3wb6dkNIvy+LHiVCGefd9sIQmsvGHsUa0PBwYL1l0Eva
         6h3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Wn2KMixsOvTxOcizpjpAsR4EdISJdwDYaV+po/VHdGM=;
        b=K7M7tAcOkmiUGvS8q3IVAo8Jy6h4p7SAkA+EOOtc+pWy0F7fOvvnQd9K/VOZC2zSci
         QzGE4Cyl7jvWkr0RRDvZ9CXsWtXUKNJQwwuxRKEfXaKqHGqRmgonUyNAeEjV8f5O5aHO
         AQF9DPcNYw2hg6UzbFGJr1526WBDOmm+wtHw/rIpGEEPW5Do9WlSOCeI6uNmJ1a8MGsB
         WPYVRf8Hulr0zzw/2+OJdabxe2c4khbfN2SAceEXczSFN8hq09Msfxd2PCpi1e5aTkJl
         iXS3cTmFdgOHlmtrCw2LBEuwkIqtICxYPJqtlkLNl54ByBkeXG5q13QGR4YCMvZiE2BP
         59Sg==
X-Gm-Message-State: ANhLgQ2bATBqfBlVRfqXLMbm7hwDP9aE0/OjMhpql5fawZLZgL5Ho5uz
        Kw2Ca7AUfD8WfTc85/CKZIvHJ0y8Sm12wg==
X-Google-Smtp-Source: ADFU+vtyn40zf5zeoVM54s0yfTucJOPnrBMUG/bWNKfviQkdvoM05tKma3yvszFCNDp12OhRH8UEZw==
X-Received: by 2002:a05:6a00:9:: with SMTP id h9mr12329841pfk.78.1585272517673;
        Thu, 26 Mar 2020 18:28:37 -0700 (PDT)
Received: from localhost ([161.117.239.120])
        by smtp.gmail.com with ESMTPSA id j1sm2730313pfg.64.2020.03.26.18.28.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 26 Mar 2020 18:28:37 -0700 (PDT)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     marcelo.leitner@gmail.com, davem@davemloft.net
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, kuba@kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, anenbupt@gmail.com,
        Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH v5 RESEND] sctp: fix refcount bug in sctp_wfree
Date:   Fri, 27 Mar 2020 09:28:32 +0800
Message-Id: <20200327012832.19193-1-hqjagain@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should iterate over the datamsgs to modify
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

Reported-and-tested-by:syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
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
+		    cb(c);	\
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

