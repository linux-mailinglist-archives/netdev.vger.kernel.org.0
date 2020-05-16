Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40AA81D5FBF
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 10:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgEPIrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 04:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgEPIrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 04:47:09 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93872C061A0C
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 01:47:09 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jZsTM-0005sd-82; Sat, 16 May 2020 10:47:08 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     pabeni@redhat.com, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 2/7] mptcp: break and restart in case mptcp sndbuf is full
Date:   Sat, 16 May 2020 10:46:18 +0200
Message-Id: <20200516084623.28453-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200516084623.28453-1-fw@strlen.de>
References: <20200516084623.28453-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Its not enough to check for available tcp send space.

We also hold on to transmitted data for mptcp-level retransmits.
Right now we will send more and more data if the peer can ack data
at the tcp level fast enough, since that frees up tcp send buffer space.

But we also need to check that data was acked and reclaimed at the mptcp
level.

Therefore add needed check in mptcp_sendmsg, flush tcp data and
wait until more mptcp snd space becomes available if we are over the
limit.  Before we wait for more data, also make sure we start the
retransmit timer if we ran out of sndbuf space.

Otherwise there is a very small chance that we wait forever:

 * receiver is waiting for data
 * sender is blocked because mptcp socket buffer is full
 * at tcp level, all data was acked
 * mptcp-level snd_una was not updated, because last ack
   that acknowledged the last data packet carried an older
   MPTCP-ack.

Restarting the retransmit timer avoids this problem: if TCP
subflow is idle, data is retransmitted from the RTX queue.

New data will make the peer send a new, updated MPTCP-Ack.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 0413454fcdaf..75be8d662ac5 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -739,9 +739,23 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	mptcp_clean_una(sk);
 
+wait_for_sndbuf:
 	__mptcp_flush_join_list(msk);
 	ssk = mptcp_subflow_get_send(msk);
 	while (!sk_stream_memory_free(sk) || !ssk) {
+		if (ssk) {
+			/* make sure retransmit timer is
+			 * running before we wait for memory.
+			 *
+			 * The retransmit timer might be needed
+			 * to make the peer send an up-to-date
+			 * MPTCP Ack.
+			 */
+			mptcp_set_timeout(sk, ssk);
+			if (!mptcp_timer_pending(sk))
+				mptcp_reset_timer(sk);
+		}
+
 		ret = sk_stream_wait_memory(sk, &timeo);
 		if (ret)
 			goto out;
@@ -776,6 +790,28 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		}
 
 		copied += ret;
+
+		/* memory is charged to mptcp level socket as well, i.e.
+		 * if msg is very large, mptcp socket may run out of buffer
+		 * space.  mptcp_clean_una() will release data that has
+		 * been acked at mptcp level in the mean time, so there is
+		 * a good chance we can continue sending data right away.
+		 */
+		if (unlikely(!sk_stream_memory_free(sk))) {
+			tcp_push(ssk, msg->msg_flags, mss_now,
+				 tcp_sk(ssk)->nonagle, size_goal);
+			mptcp_clean_una(sk);
+			if (!sk_stream_memory_free(sk)) {
+				/* can't send more for now, need to wait for
+				 * MPTCP-level ACKs from peer.
+				 *
+				 * Wakeup will happen via mptcp_clean_una().
+				 */
+				mptcp_set_timeout(sk, ssk);
+				release_sock(ssk);
+				goto wait_for_sndbuf;
+			}
+		}
 	}
 
 	mptcp_set_timeout(sk, ssk);
-- 
2.26.2

