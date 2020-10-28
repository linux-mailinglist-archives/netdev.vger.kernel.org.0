Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7899129DA98
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390361AbgJ1XZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387571AbgJ1XZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:25:54 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B53C0613CF;
        Wed, 28 Oct 2020 16:25:54 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q25so1388569ioh.4;
        Wed, 28 Oct 2020 16:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EldFY16BxtvGb7fdIx/6iAPYxXdUeuIFxuwoe4Wvm20=;
        b=Un01M6pTcPg2IQ37QqHcx4HvGjenSIcRcZf/MDO0H3x1cUi1d9LRajo2owOwlRSI2N
         ItnuwaqNPqFNkHa7CxUCHpcYEmNPWDAKKuYV+smsBYW6HgoenTxT4Qe6KrGKrYJ7njxm
         q7rrcjthGmokAlsUWE2Qm6KMVs3vbt9HwaN89Lv4SyqK+zKDlLHNr235pcUKKKGvtTXz
         3KsORgfCo7G/iisyJjrNVGfK1qiwBER0ahyx76HOJUs0xK7FAmm+TkDr2t7PQhWvEw7M
         ImWPFkwqa8SnVqGHr04KUrtHv0TwWf+QxQgX5OtHVwDTLLXYgrTw1mLcQDwsZWg4EVFl
         uRxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EldFY16BxtvGb7fdIx/6iAPYxXdUeuIFxuwoe4Wvm20=;
        b=lT0Z+80bShyb1+vEjVUNNX3KnrKFz2i6uOu70XuxBlrz/oB2jPWaDljd9DWKwhVflm
         dLqhoGhujVi0mzjxiVyhVjXH2C9KQMtdA+ESAvbTs4+qm+hQsShJ0NxI6Icp5OByNG16
         miWsCrgruBsl5hB8QXgMurPNtcWfzh0EPy/wtbMphPASO2kUTqkTcItFstHbcT81IL8H
         Hufs0z5PGsXttrSWVyOl7E0XGpfTtLaEmspphiyK6ZrkgND/0ZeBk7vbn7VrMgVRZpgs
         hq+41jQIALLWhbXtFenKz0Rre3VkW1peaxxPTB39fRanI8wPuLTXIl9z5eyTPADny4M9
         spkA==
X-Gm-Message-State: AOAM530g7BRt3okXWjKXeP22ItSuJp+VUD/Fcm8r1f0tyH7hKwJcRoAx
        yk3usPlcILLBG6XXA2UJZjxE3p4QXpyBz3pY
X-Google-Smtp-Source: ABdhPJy+S90MJjSHPYTZmqtsGVHrfsyandTfzipF3FoHF4WnOPbv3h+YZpedav1EFBmxNIjyaP6ayQ==
X-Received: by 2002:a63:530c:: with SMTP id h12mr6684388pgb.424.1603892109532;
        Wed, 28 Oct 2020 06:35:09 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id q14sm5935393pjp.43.2020.10.28.06.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 06:35:08 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, intel-wired-lan@lists.osuosl.org,
        jonathan.lemon@gmail.com
Subject: [RFC PATCH bpf-next 1/9] net: introduce biased busy-polling
Date:   Wed, 28 Oct 2020 14:34:29 +0100
Message-Id: <20201028133437.212503-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201028133437.212503-1-bjorn.topel@gmail.com>
References: <20201028133437.212503-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

This change adds a new NAPI mode, called biased busy-polling, which is
an extension to the existing busy-polling mode. The new mode is
enabled on the socket layer, where a socket setting this option
"promisies" to busy-poll the NAPI context via a system call. When this
mode is enabled, the NAPI context will operate in a mode with
interrupts disabled. The kernel monitors that the busy-polling promise
is fulfilled by an internal watchdog. If the socket fail/stop
performing the busy-polling, the mode will be disabled. The watchdog
is currently 200 ms.

Biased busy-polling follows the same mechanism as the existing
busy-poll; The napi_id is reported to the socket via the skbuff. Later
commits will extend napi_id reporting to XDP, in order to work
correctly with XDP sockets.

Let us walk through a flow of execution:

1. A socket sets the new SO_BIAS_BUSY_POLL socket option to true. The
   socket now shows an intent of doing busy-polling. No data has been
   received to the socket, so the napi_id of the socket is still 0
   (non-valid). As usual for busy-polling, the SO_BUSY_POLL option
   also has to be non-zero for biased busy-polling.

2. Data is received on the socket changing the napi_id to non-zero.

3. The socket does a system call that has the busy-polling logic wired
   up, e.g. recvfrom() for UDP sockets. The NAPI context is now marked
   as biased busy-poll. The kernel watchdog is armed. If the NAPI
   context is already running, it will try to finish as soon as
   possible and move to busy-polling. If the NAPI context is not
   running, it will execute the NAPI poll function for the
   corresponding napi_id.

4. Goto 3, or wait until the watchdog timeout.

Given the nature of busy-polling, this mode only make sense for
non-blocking sockets.

When the NAPI context is in biased busy-polling mode, it will not
allow a NAPI to be scheduled using the
napi_schedule_prep()/napi_scheduleXXX() combo.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 arch/alpha/include/uapi/asm/socket.h  |  2 +
 arch/mips/include/uapi/asm/socket.h   |  2 +
 arch/parisc/include/uapi/asm/socket.h |  2 +
 arch/sparc/include/uapi/asm/socket.h  |  2 +
 include/linux/netdevice.h             | 33 +++++-----
 include/net/busy_poll.h               | 17 ++++-
 include/net/sock.h                    |  3 +
 include/uapi/asm-generic/socket.h     |  2 +
 net/core/dev.c                        | 89 +++++++++++++++++++++++++--
 net/core/sock.c                       |  9 +++
 10 files changed, 140 insertions(+), 21 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
index de6c4df61082..0f776668fb09 100644
--- a/arch/alpha/include/uapi/asm/socket.h
+++ b/arch/alpha/include/uapi/asm/socket.h
@@ -124,6 +124,8 @@
 
 #define SO_DETACH_REUSEPORT_BPF 68
 
+#define SO_BIAS_BUSY_POLL	69
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
index d0a9ed2ca2d6..d23984731504 100644
--- a/arch/mips/include/uapi/asm/socket.h
+++ b/arch/mips/include/uapi/asm/socket.h
@@ -135,6 +135,8 @@
 
 #define SO_DETACH_REUSEPORT_BPF 68
 
+#define SO_BIAS_BUSY_POLL	69
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
index 10173c32195e..49469713ed2a 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -116,6 +116,8 @@
 
 #define SO_DETACH_REUSEPORT_BPF 0x4042
 
+#define SO_BIAS_BUSY_POLL	0x4043
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
index 8029b681fc7c..009aba6f7a54 100644
--- a/arch/sparc/include/uapi/asm/socket.h
+++ b/arch/sparc/include/uapi/asm/socket.h
@@ -117,6 +117,8 @@
 
 #define SO_DETACH_REUSEPORT_BPF  0x0047
 
+#define SO_BIAS_BUSY_POLL	 0x0048
+
 #if !defined(__KERNEL__)
 
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 964b494b0e8d..9bdc84d3d6b8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -344,29 +344,32 @@ struct napi_struct {
 	struct list_head	rx_list; /* Pending GRO_NORMAL skbs */
 	int			rx_count; /* length of rx_list */
 	struct hrtimer		timer;
+	struct hrtimer		bp_watchdog;
 	struct list_head	dev_list;
 	struct hlist_node	napi_hash_node;
 	unsigned int		napi_id;
 };
 
 enum {
-	NAPI_STATE_SCHED,	/* Poll is scheduled */
-	NAPI_STATE_MISSED,	/* reschedule a napi */
-	NAPI_STATE_DISABLE,	/* Disable pending */
-	NAPI_STATE_NPSVC,	/* Netpoll - don't dequeue from poll_list */
-	NAPI_STATE_LISTED,	/* NAPI added to system lists */
-	NAPI_STATE_NO_BUSY_POLL,/* Do not add in napi_hash, no busy polling */
-	NAPI_STATE_IN_BUSY_POLL,/* sk_busy_loop() owns this NAPI */
+	NAPI_STATE_SCHED,		/* Poll is scheduled */
+	NAPI_STATE_MISSED,		/* reschedule a napi */
+	NAPI_STATE_DISABLE,		/* Disable pending */
+	NAPI_STATE_NPSVC,		/* Netpoll - don't dequeue from poll_list */
+	NAPI_STATE_LISTED,		/* NAPI added to system lists */
+	NAPI_STATE_NO_BUSY_POLL,	/* Do not add in napi_hash, no busy polling */
+	NAPI_STATE_IN_BUSY_POLL,	/* sk_busy_loop() owns this NAPI */
+	NAPI_STATE_BIAS_BUSY_POLL,	/* biased busy-polling */
 };
 
 enum {
-	NAPIF_STATE_SCHED	 = BIT(NAPI_STATE_SCHED),
-	NAPIF_STATE_MISSED	 = BIT(NAPI_STATE_MISSED),
-	NAPIF_STATE_DISABLE	 = BIT(NAPI_STATE_DISABLE),
-	NAPIF_STATE_NPSVC	 = BIT(NAPI_STATE_NPSVC),
-	NAPIF_STATE_LISTED	 = BIT(NAPI_STATE_LISTED),
-	NAPIF_STATE_NO_BUSY_POLL = BIT(NAPI_STATE_NO_BUSY_POLL),
-	NAPIF_STATE_IN_BUSY_POLL = BIT(NAPI_STATE_IN_BUSY_POLL),
+	NAPIF_STATE_SCHED	   = BIT(NAPI_STATE_SCHED),
+	NAPIF_STATE_MISSED	   = BIT(NAPI_STATE_MISSED),
+	NAPIF_STATE_DISABLE	   = BIT(NAPI_STATE_DISABLE),
+	NAPIF_STATE_NPSVC	   = BIT(NAPI_STATE_NPSVC),
+	NAPIF_STATE_LISTED	   = BIT(NAPI_STATE_LISTED),
+	NAPIF_STATE_NO_BUSY_POLL   = BIT(NAPI_STATE_NO_BUSY_POLL),
+	NAPIF_STATE_IN_BUSY_POLL   = BIT(NAPI_STATE_IN_BUSY_POLL),
+	NAPIF_STATE_BIAS_BUSY_POLL = BIT(NAPI_STATE_BIAS_BUSY_POLL),
 };
 
 enum gro_result {
@@ -555,6 +558,8 @@ static inline bool napi_if_scheduled_mark_missed(struct napi_struct *n)
 	return true;
 }
 
+void napi_bias_busy_poll(unsigned int napi_id);
+
 enum netdev_queue_state_t {
 	__QUEUE_STATE_DRV_XOFF,
 	__QUEUE_STATE_STACK_XOFF,
diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index b001fa91c14e..9738923ed17b 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -23,6 +23,9 @@
  */
 #define MIN_NAPI_ID ((unsigned int)(NR_CPUS + 1))
 
+/* Biased busy-poll watchdog timeout in ms */
+#define BIASED_BUSY_POLL_TIMEOUT 200
+
 #ifdef CONFIG_NET_RX_BUSY_POLL
 
 struct napi_struct;
@@ -99,13 +102,25 @@ static inline bool sk_busy_loop_timeout(struct sock *sk,
 	return true;
 }
 
+#ifdef CONFIG_NET_RX_BUSY_POLL
+static inline void __sk_bias_busy_poll(struct sock *sk, unsigned int napi_id)
+{
+	if (likely(!READ_ONCE(sk->sk_bias_busy_poll)))
+		return;
+
+	napi_bias_busy_poll(napi_id);
+}
+#endif
+
 static inline void sk_busy_loop(struct sock *sk, int nonblock)
 {
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	unsigned int napi_id = READ_ONCE(sk->sk_napi_id);
 
-	if (napi_id >= MIN_NAPI_ID)
+	if (napi_id >= MIN_NAPI_ID) {
+		__sk_bias_busy_poll(sk, napi_id);
 		napi_busy_loop(napi_id, nonblock ? NULL : sk_busy_loop_end, sk);
+	}
 #endif
 }
 
diff --git a/include/net/sock.h b/include/net/sock.h
index a5c6ae78df77..cf71834fb601 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -479,6 +479,9 @@ struct sock {
 	u32			sk_ack_backlog;
 	u32			sk_max_ack_backlog;
 	kuid_t			sk_uid;
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	u8			sk_bias_busy_poll;
+#endif
 	struct pid		*sk_peer_pid;
 	const struct cred	*sk_peer_cred;
 	long			sk_rcvtimeo;
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index 77f7c1638eb1..8a2b37ccd9d5 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -119,6 +119,8 @@
 
 #define SO_DETACH_REUSEPORT_BPF 68
 
+#define SO_BIAS_BUSY_POLL	69
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
diff --git a/net/core/dev.c b/net/core/dev.c
index 9499a414d67e..a29e4c4a35f6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6378,6 +6378,9 @@ bool napi_schedule_prep(struct napi_struct *n)
 		val = READ_ONCE(n->state);
 		if (unlikely(val & NAPIF_STATE_DISABLE))
 			return false;
+		if (unlikely(val & NAPIF_STATE_BIAS_BUSY_POLL))
+			return false;
+
 		new = val | NAPIF_STATE_SCHED;
 
 		/* Sets STATE_MISSED bit if STATE_SCHED was already set
@@ -6458,12 +6461,14 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 
 		/* If STATE_MISSED was set, leave STATE_SCHED set,
 		 * because we will call napi->poll() one more time.
-		 * This C code was suggested by Alexander Duyck to help gcc.
 		 */
-		new |= (val & NAPIF_STATE_MISSED) / NAPIF_STATE_MISSED *
-						    NAPIF_STATE_SCHED;
+		if (val & NAPIF_STATE_MISSED && !(val & NAPIF_STATE_BIAS_BUSY_POLL))
+			new |= NAPIF_STATE_SCHED;
 	} while (cmpxchg(&n->state, val, new) != val);
 
+	if (unlikely(val & NAPIF_STATE_BIAS_BUSY_POLL))
+		return false;
+
 	if (unlikely(val & NAPIF_STATE_MISSED)) {
 		__napi_schedule(n);
 		return false;
@@ -6497,6 +6502,20 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock)
 {
 	int rc;
 
+	clear_bit(NAPI_STATE_IN_BUSY_POLL, &napi->state);
+
+	local_bh_disable();
+	/* If we're biased towards busy poll, clear the sched flags,
+	 * so that we can enter again.
+	 */
+	if (READ_ONCE(napi->state) & NAPIF_STATE_BIAS_BUSY_POLL) {
+		netpoll_poll_unlock(have_poll_lock);
+		napi_complete(napi);
+		__kfree_skb_flush();
+		local_bh_enable();
+		return;
+	}
+
 	/* Busy polling means there is a high chance device driver hard irq
 	 * could not grab NAPI_STATE_SCHED, and that NAPI_STATE_MISSED was
 	 * set in napi_schedule_prep().
@@ -6507,9 +6526,6 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock)
 	 * to perform these two clear_bit()
 	 */
 	clear_bit(NAPI_STATE_MISSED, &napi->state);
-	clear_bit(NAPI_STATE_IN_BUSY_POLL, &napi->state);
-
-	local_bh_disable();
 
 	/* All we really want here is to re-enable device interrupts.
 	 * Ideally, a new ndo_busy_poll_stop() could avoid another round.
@@ -6569,6 +6585,11 @@ void napi_busy_loop(unsigned int napi_id,
 				goto count;
 			have_poll_lock = netpoll_poll_lock(napi);
 			napi_poll = napi->poll;
+			if (val & NAPIF_STATE_BIAS_BUSY_POLL) {
+				hrtimer_start(&napi->bp_watchdog,
+					      ms_to_ktime(BIASED_BUSY_POLL_TIMEOUT),
+					      HRTIMER_MODE_REL_PINNED);
+			}
 		}
 		work = napi_poll(napi, BUSY_POLL_BUDGET);
 		trace_napi_poll(napi, work, BUSY_POLL_BUDGET);
@@ -6652,6 +6673,53 @@ static enum hrtimer_restart napi_watchdog(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
+static enum hrtimer_restart napi_biased_busy_poll_watchdog(struct hrtimer *timer)
+{
+	struct napi_struct *napi;
+	unsigned long val, new;
+
+	napi = container_of(timer, struct napi_struct, bp_watchdog);
+
+	do {
+		val = READ_ONCE(napi->state);
+		if (WARN_ON_ONCE(!(val & NAPIF_STATE_BIAS_BUSY_POLL)))
+			return HRTIMER_NORESTART;
+
+		new = val & ~NAPIF_STATE_BIAS_BUSY_POLL;
+	} while (cmpxchg(&napi->state, val, new) != val);
+
+	if (!napi_disable_pending(napi) &&
+	    !test_and_set_bit(NAPI_STATE_SCHED, &napi->state))
+		__napi_schedule_irqoff(napi);
+
+	return HRTIMER_NORESTART;
+}
+
+void napi_bias_busy_poll(unsigned int napi_id)
+{
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	struct napi_struct *napi;
+	unsigned long val, new;
+
+	napi = napi_by_id(napi_id);
+	if (!napi)
+		return;
+
+	do {
+		val = READ_ONCE(napi->state);
+		if (val & NAPIF_STATE_BIAS_BUSY_POLL)
+			return;
+
+		new = val | NAPIF_STATE_BIAS_BUSY_POLL;
+	} while (cmpxchg(&napi->state, val, new) != val);
+
+	hrtimer_start(&napi->bp_watchdog, ms_to_ktime(BIASED_BUSY_POLL_TIMEOUT),
+		      HRTIMER_MODE_REL_PINNED);
+#endif
+}
+EXPORT_SYMBOL(napi_bias_busy_poll);
+
+
 static void init_gro_hash(struct napi_struct *napi)
 {
 	int i;
@@ -6673,6 +6741,8 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 	INIT_HLIST_NODE(&napi->napi_hash_node);
 	hrtimer_init(&napi->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
 	napi->timer.function = napi_watchdog;
+	hrtimer_init(&napi->bp_watchdog, CLOCK_MONOTONIC, HRTIMER_MODE_REL_PINNED);
+	napi->bp_watchdog.function = napi_biased_busy_poll_watchdog;
 	init_gro_hash(napi);
 	napi->skb = NULL;
 	INIT_LIST_HEAD(&napi->rx_list);
@@ -6704,7 +6774,9 @@ void napi_disable(struct napi_struct *n)
 		msleep(1);
 
 	hrtimer_cancel(&n->timer);
+	hrtimer_cancel(&n->bp_watchdog);
 
+	clear_bit(NAPI_STATE_BIAS_BUSY_POLL, &n->state);
 	clear_bit(NAPI_STATE_DISABLE, &n->state);
 }
 EXPORT_SYMBOL(napi_disable);
@@ -6767,6 +6839,11 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 	if (likely(work < weight))
 		goto out_unlock;
 
+	if (unlikely(n->state & NAPIF_STATE_BIAS_BUSY_POLL)) {
+		napi_complete(n);
+		goto out_unlock;
+	}
+
 	/* Drivers must not modify the NAPI state if they
 	 * consume the entire weight.  In such cases this code
 	 * still "owns" the NAPI instance and therefore can
diff --git a/net/core/sock.c b/net/core/sock.c
index 727ea1cc633c..686eb5549b79 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1159,6 +1159,12 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 				sk->sk_ll_usec = val;
 		}
 		break;
+	case SO_BIAS_BUSY_POLL:
+		if (valbool && !capable(CAP_NET_ADMIN))
+			ret = -EPERM;
+		else
+			sk->sk_bias_busy_poll = valbool;
+		break;
 #endif
 
 	case SO_MAX_PACING_RATE:
@@ -1523,6 +1529,9 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 	case SO_BUSY_POLL:
 		v.val = sk->sk_ll_usec;
 		break;
+	case SO_BIAS_BUSY_POLL:
+		v.val = sk->sk_bias_busy_poll;
+		break;
 #endif
 
 	case SO_MAX_PACING_RATE:
-- 
2.27.0

