Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3FF11592
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 10:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbfEBIjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 04:39:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:64457 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbfEBIjo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 04:39:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 01:39:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="296322386"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO VM.isw.intel.com) ([10.103.211.43])
  by orsmga004.jf.intel.com with ESMTP; 02 May 2019 01:39:40 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, brouer@redhat.com
Cc:     bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com, jakub.kicinski@netronome.com,
        xiaolong.ye@intel.com, qi.z.zhang@intel.com, maximmi@mellanox.com,
        sridhar.samudrala@intel.com, kevin.laatz@intel.com
Subject: [RFC bpf-next 1/7] net: fs: make busy poll budget configurable in napi_busy_loop
Date:   Thu,  2 May 2019 10:39:17 +0200
Message-Id: <1556786363-28743-2-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
References: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the possibility to set the busy poll budget to
something else than 8 in napi_busy_loop. All the current users of
napi_busy_loop will still have a budget of 8, but the for the XDP
socket busy poll support, we need to have a configurable budget that
is usually larger since each packet requires less processing than with
an AF_INET socket.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 fs/eventpoll.c          |  5 ++++-
 include/net/busy_poll.h |  7 +++++--
 net/core/dev.c          | 21 ++++++++++-----------
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 4a0e98d..0fbbc35 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -394,6 +394,8 @@ static bool ep_busy_loop_end(void *p, unsigned long start_time)
 	return ep_events_available(ep) || busy_loop_timeout(start_time);
 }
 
+#define BUSY_POLL_BUDGET 8
+
 /*
  * Busy poll if globally on and supporting sockets found && no events,
  * busy loop will return if need_resched or ep_events_available.
@@ -405,7 +407,8 @@ static void ep_busy_loop(struct eventpoll *ep, int nonblock)
 	unsigned int napi_id = READ_ONCE(ep->napi_id);
 
 	if ((napi_id >= MIN_NAPI_ID) && net_busy_loop_on())
-		napi_busy_loop(napi_id, nonblock ? NULL : ep_busy_loop_end, ep);
+		napi_busy_loop(napi_id, nonblock ? NULL : ep_busy_loop_end, ep,
+			       BUSY_POLL_BUDGET);
 }
 
 static inline void ep_reset_busy_poll_napi_id(struct eventpoll *ep)
diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index ba61cdd..94817e8 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -55,7 +55,7 @@ bool sk_busy_loop_end(void *p, unsigned long start_time);
 
 void napi_busy_loop(unsigned int napi_id,
 		    bool (*loop_end)(void *, unsigned long),
-		    void *loop_end_arg);
+		    void *loop_end_arg, int budget);
 
 #else /* CONFIG_NET_RX_BUSY_POLL */
 static inline unsigned long net_busy_loop_on(void)
@@ -111,13 +111,16 @@ static inline bool sk_busy_loop_timeout(struct sock *sk,
 	return true;
 }
 
+#define BUSY_POLL_BUDGET 8
+
 static inline void sk_busy_loop(struct sock *sk, int nonblock)
 {
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	unsigned int napi_id = READ_ONCE(sk->sk_napi_id);
 
 	if (napi_id >= MIN_NAPI_ID)
-		napi_busy_loop(napi_id, nonblock ? NULL : sk_busy_loop_end, sk);
+		napi_busy_loop(napi_id, nonblock ? NULL : sk_busy_loop_end, sk,
+			       BUSY_POLL_BUDGET);
 #endif
 }
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 22f2640..e82fc44 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6108,9 +6108,8 @@ static struct napi_struct *napi_by_id(unsigned int napi_id)
 
 #if defined(CONFIG_NET_RX_BUSY_POLL)
 
-#define BUSY_POLL_BUDGET 8
-
-static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock)
+static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock,
+			   int budget)
 {
 	int rc;
 
@@ -6131,17 +6130,17 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock)
 	/* All we really want here is to re-enable device interrupts.
 	 * Ideally, a new ndo_busy_poll_stop() could avoid another round.
 	 */
-	rc = napi->poll(napi, BUSY_POLL_BUDGET);
-	trace_napi_poll(napi, rc, BUSY_POLL_BUDGET);
+	rc = napi->poll(napi, budget);
+	trace_napi_poll(napi, rc, budget);
 	netpoll_poll_unlock(have_poll_lock);
-	if (rc == BUSY_POLL_BUDGET)
+	if (rc == budget)
 		__napi_schedule(napi);
 	local_bh_enable();
 }
 
 void napi_busy_loop(unsigned int napi_id,
 		    bool (*loop_end)(void *, unsigned long),
-		    void *loop_end_arg)
+		    void *loop_end_arg, int budget)
 {
 	unsigned long start_time = loop_end ? busy_loop_current_time() : 0;
 	int (*napi_poll)(struct napi_struct *napi, int budget);
@@ -6178,8 +6177,8 @@ void napi_busy_loop(unsigned int napi_id,
 			have_poll_lock = netpoll_poll_lock(napi);
 			napi_poll = napi->poll;
 		}
-		work = napi_poll(napi, BUSY_POLL_BUDGET);
-		trace_napi_poll(napi, work, BUSY_POLL_BUDGET);
+		work = napi_poll(napi, budget);
+		trace_napi_poll(napi, work, budget);
 count:
 		if (work > 0)
 			__NET_ADD_STATS(dev_net(napi->dev),
@@ -6191,7 +6190,7 @@ void napi_busy_loop(unsigned int napi_id,
 
 		if (unlikely(need_resched())) {
 			if (napi_poll)
-				busy_poll_stop(napi, have_poll_lock);
+				busy_poll_stop(napi, have_poll_lock, budget);
 			preempt_enable();
 			rcu_read_unlock();
 			cond_resched();
@@ -6202,7 +6201,7 @@ void napi_busy_loop(unsigned int napi_id,
 		cpu_relax();
 	}
 	if (napi_poll)
-		busy_poll_stop(napi, have_poll_lock);
+		busy_poll_stop(napi, have_poll_lock, budget);
 	preempt_enable();
 out:
 	rcu_read_unlock();
-- 
2.7.4

