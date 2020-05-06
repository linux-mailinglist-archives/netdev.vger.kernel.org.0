Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22B21C6953
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgEFGrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:47:41 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:21995 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727812AbgEFGrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:47:40 -0400
X-Greylist: delayed 914 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 May 2020 02:47:40 EDT
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 5 May 2020 23:32:29 -0700
Received: from localhost.localdomain (ashwinh-vm-1.vmware.com [10.110.19.225])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 7F1E0400A2;
        Tue,  5 May 2020 23:32:29 -0700 (PDT)
From:   ashwin-h <ashwinh@vmware.com>
To:     <vyasevich@gmail.com>, <nhorman@tuxdriver.com>
CC:     <davem@davemloft.net>, <linux-sctp@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <srivatsab@vmware.com>, <srivatsa@csail.mit.edu>,
        <rostedt@goodmis.org>, <srostedt@vmware.com>,
        <gregkh@linuxfoundation.org>, <ashwin.hiranniah@gmail.com>,
        Xin Long <lucien.xin@gmail.com>, Ashwin H <ashwinh@vmware.com>
Subject: [PATCH 2/2] sctp: implement memory accounting on rx path
Date:   Wed, 6 May 2020 19:50:54 +0530
Message-ID: <b2d9886afc672b4120f101eeb9217e68abb61471.1588242081.git.ashwinh@vmware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1588242081.git.ashwinh@vmware.com>
References: <cover.1588242081.git.ashwinh@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: ashwinh@vmware.com does not
 designate permitted sender hosts)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit 9dde27de3e5efa0d032f3c891a0ca833a0d31911 upstream.

sk_forward_alloc's updating is also done on rx path, but to be consistent
we change to use sk_mem_charge() in sctp_skb_set_owner_r().

In sctp_eat_data(), it's not enough to check sctp_memory_pressure only,
which doesn't work for mem_cgroup_sockets_enabled, so we change to use
sk_under_memory_pressure().

When it's under memory pressure, sk_mem_reclaim() and sk_rmem_schedule()
should be called on both RENEGE or CHUNK DELIVERY path exit the memory
pressure status as soon as possible.

Note that sk_rmem_schedule() is using datalen to make things easy there.

Reported-by: Matteo Croce <mcroce@redhat.com>
Tested-by: Matteo Croce <mcroce@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ashwin H <ashwinh@vmware.com>
---
 include/net/sctp/sctp.h |  2 +-
 net/sctp/sm_statefuns.c |  6 ++++--
 net/sctp/ulpevent.c     | 19 ++++++++-----------
 net/sctp/ulpqueue.c     |  3 ++-
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 2c6570e..fef8c33 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -421,7 +421,7 @@ static inline void sctp_skb_set_owner_r(struct sk_buff *skb, struct sock *sk)
 	/*
 	 * This mimics the behavior of skb_set_owner_r
 	 */
-	sk->sk_forward_alloc -= event->rmem_len;
+	sk_mem_charge(sk, event->rmem_len);
 }
 
 /* Tests if the list has one and only one entry. */
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 9f4d325..93cbf88 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -6444,13 +6444,15 @@ static int sctp_eat_data(const struct sctp_association *asoc,
 	 * in sctp_ulpevent_make_rcvmsg will drop the frame if we grow our
 	 * memory usage too much
 	 */
-	if (*sk->sk_prot_creator->memory_pressure) {
+	if (sk_under_memory_pressure(sk)) {
 		if (sctp_tsnmap_has_gap(map) &&
 		    (sctp_tsnmap_get_ctsn(map) + 1) == tsn) {
 			pr_debug("%s: under pressure, reneging for tsn:%u\n",
 				 __func__, tsn);
 			deliver = SCTP_CMD_RENEGE;
-		 }
+		} else {
+			sk_mem_reclaim(sk);
+		}
 	}
 
 	/*
diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
index 8cb7d98..c2a7478 100644
--- a/net/sctp/ulpevent.c
+++ b/net/sctp/ulpevent.c
@@ -634,8 +634,9 @@ struct sctp_ulpevent *sctp_ulpevent_make_rcvmsg(struct sctp_association *asoc,
 						gfp_t gfp)
 {
 	struct sctp_ulpevent *event = NULL;
-	struct sk_buff *skb;
-	size_t padding, len;
+	struct sk_buff *skb = chunk->skb;
+	struct sock *sk = asoc->base.sk;
+	size_t padding, datalen;
 	int rx_count;
 
 	/*
@@ -646,15 +647,12 @@ struct sctp_ulpevent *sctp_ulpevent_make_rcvmsg(struct sctp_association *asoc,
 	if (asoc->ep->rcvbuf_policy)
 		rx_count = atomic_read(&asoc->rmem_alloc);
 	else
-		rx_count = atomic_read(&asoc->base.sk->sk_rmem_alloc);
+		rx_count = atomic_read(&sk->sk_rmem_alloc);
 
-	if (rx_count >= asoc->base.sk->sk_rcvbuf) {
+	datalen = ntohs(chunk->chunk_hdr->length);
 
-		if ((asoc->base.sk->sk_userlocks & SOCK_RCVBUF_LOCK) ||
-		    (!sk_rmem_schedule(asoc->base.sk, chunk->skb,
-				       chunk->skb->truesize)))
-			goto fail;
-	}
+	if (rx_count >= sk->sk_rcvbuf || !sk_rmem_schedule(sk, skb, datalen))
+		goto fail;
 
 	/* Clone the original skb, sharing the data.  */
 	skb = skb_clone(chunk->skb, gfp);
@@ -681,8 +679,7 @@ struct sctp_ulpevent *sctp_ulpevent_make_rcvmsg(struct sctp_association *asoc,
 	 * The sender should never pad with more than 3 bytes.  The receiver
 	 * MUST ignore the padding bytes.
 	 */
-	len = ntohs(chunk->chunk_hdr->length);
-	padding = SCTP_PAD4(len) - len;
+	padding = SCTP_PAD4(datalen) - datalen;
 
 	/* Fixup cloned skb with just this chunks data.  */
 	skb_trim(skb, chunk->chunk_end - padding - skb->data);
diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
index 0b42710..7de9be3 100644
--- a/net/sctp/ulpqueue.c
+++ b/net/sctp/ulpqueue.c
@@ -1106,7 +1106,8 @@ void sctp_ulpq_renege(struct sctp_ulpq *ulpq, struct sctp_chunk *chunk,
 			freed += sctp_ulpq_renege_frags(ulpq, needed - freed);
 	}
 	/* If able to free enough room, accept this chunk. */
-	if (freed >= needed) {
+	if (sk_rmem_schedule(asoc->base.sk, chunk->skb, needed) &&
+	    freed >= needed) {
 		int retval = sctp_ulpq_tail_data(ulpq, chunk, gfp);
 		/*
 		 * Enter partial delivery if chunk has not been
-- 
2.7.4

