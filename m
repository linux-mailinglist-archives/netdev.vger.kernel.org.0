Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7C12B041F
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgKLLnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728003AbgKLLlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:41:21 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907F5C061A04;
        Thu, 12 Nov 2020 03:41:13 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id y7so4256368pfq.11;
        Thu, 12 Nov 2020 03:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0S/pJoSQbdzJexH57xOvPa6elOsgcCpZwFRQdMcEx4o=;
        b=OkcH9o1YJ2N7tXWIcrPLcp3IgaLZlap+R9kbNLbcm1TpTaYt19PB8QWTSCRJfQX8LI
         tCQ0Slp1JzhY7W7Y7VQCKrSM9IsP6U/2mzuQzzGYM+ryJNyW/efH+B0WlbBneMW1kDdU
         JqaTXD1QETUlZLeIHvX+EwMpSrEsxF9R9Hvo0daQCa+d2UI7zAgtgjxTjCyJGdnWcpSP
         C5ucZrUB143oz88DEwzJvUm5Xrznbyz9PLix/Js8YDtoiBFcCuiJ4OHbsoT7qoXZl4NJ
         ANXVlNRHdk8M2N94AeZ+Oa+hr6YxNr6E2H1CWQmvTCmEkn6PTzAbPET7gwRx8npzy0Dg
         Qjxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0S/pJoSQbdzJexH57xOvPa6elOsgcCpZwFRQdMcEx4o=;
        b=BOiwonE57Ula1PKSn8/LMIe7P3ivfqAwCWpraZu4E/4HNQNot3tjCo9Nn8OhIxVyv5
         T/0dfdMurPgDwGtNDcVMDPkIcudRZYOIY6iGM+x3HHihVuIJysLfAVOQ+poWzspFfI/Z
         p1WkPAfhw5ohW+JPYSmnNF4pPxg8OBbVq1s6bMkSU0tqCfmF6b2QvX30F6NcUCth5J/V
         dfDi6Wg0Z8HcnfNbhTERFiTkZggCvI7ZJe/+go5ViwsgUhNi/Z/uiEMFQmW+KjhO2wpM
         tQO6Vrz1N0LypRF0rh2G6pkCZl9ub3lp7Gj5fd821Gj9LcUavFovQ4cghskj3Q3hnA7L
         U+FA==
X-Gm-Message-State: AOAM531VrVM3VDOXUNM0PtMUgCFRQQy+aoHwomx9kRRSZDUuXefhReZ0
        jfM9Kc7CJIMLB1AOAYVwCxvfhK/0kXFdgg==
X-Google-Smtp-Source: ABdhPJw119kCbiue6a72GRpRnypK9sES8eVvP5n4Ah6A8I4wphBKyy5y/xp9DDD6bD/slFR/WIhH3Q==
X-Received: by 2002:a63:c644:: with SMTP id x4mr26400231pgg.421.1605181272302;
        Thu, 12 Nov 2020 03:41:12 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id y8sm6161629pfe.33.2020.11.12.03.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 03:41:11 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next 1/9] net: introduce preferred busy-polling
Date:   Thu, 12 Nov 2020 12:40:33 +0100
Message-Id: <20201112114041.131998-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201112114041.131998-1-bjorn.topel@gmail.com>
References: <20201112114041.131998-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The existing busy-polling mode, enabled by the SO_BUSY_POLL socket
option or system-wide using the /proc/sys/net/core/busy_read knob, is
an opportunistic. That means that if the NAPI context is not
scheduled, it will poll it. If, after busy-polling, the budget is
exceeded the busy-polling logic will schedule the NAPI onto the
regular softirq handling.

One implication of the behavior above is that a busy/heavy loaded NAPI
context will never enter/allow for busy-polling. Some applications
prefer that most NAPI processing would be done by busy-polling.

This series adds a new socket option, SO_PREFER_BUSY_POLL, that works
in concert with the napi_defer_hard_irqs and gro_flush_timeout
knobs. The napi_defer_hard_irqs and gro_flush_timeout knobs were
introduced in commit 6f8b12d661d0 ("net: napi: add hard irqs deferral
feature"), and allows for a user to defer interrupts to be enabled and
instead schedule the NAPI context from a watchdog timer. When a user
enables the SO_PREFER_BUSY_POLL, again with the other knobs enabled,
and the NAPI context is being processed by a softirq, the softirq NAPI
processing will exit early to allow the busy-polling to be performed.

If the application stops performing busy-polling via a system call,
the watchdog timer defined by gro_flush_timeout will timeout, and
regular softirq handling will resume.

In summary; Heavy traffic applications that prefer busy-polling over
softirq processing should use this option.

Example usage:

  $ echo 2 | sudo tee /sys/class/net/ens785f1/napi_defer_hard_irqs
  $ echo 200000 | sudo tee /sys/class/net/ens785f1/gro_flush_timeout

Note that the timeout should be larger than the userspace processing
window, otherwise the watchdog will timeout and fall back to regular
softirq processing.

Enable the SO_BUSY_POLL/SO_PREFER_BUSY_POLL options on your socket.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 arch/alpha/include/uapi/asm/socket.h  |  2 +
 arch/mips/include/uapi/asm/socket.h   |  2 +
 arch/parisc/include/uapi/asm/socket.h |  2 +
 arch/sparc/include/uapi/asm/socket.h  |  2 +
 fs/eventpoll.c                        |  2 +-
 include/linux/netdevice.h             | 35 +++++++-----
 include/net/busy_poll.h               |  5 +-
 include/net/sock.h                    |  3 ++
 include/uapi/asm-generic/socket.h     |  2 +
 net/core/dev.c                        | 78 +++++++++++++++++++++------
 net/core/sock.c                       |  9 ++++
 11 files changed, 110 insertions(+), 32 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
index de6c4df61082..538359642554 100644
--- a/arch/alpha/include/uapi/asm/socket.h
+++ b/arch/alpha/include/uapi/asm/socket.h
@@ -124,6 +124,8 @@
 
 #define SO_DETACH_REUSEPORT_BPF 68
 
+#define SO_PREFER_BUSY_POLL	69
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
index d0a9ed2ca2d6..e406e73b5e6e 100644
--- a/arch/mips/include/uapi/asm/socket.h
+++ b/arch/mips/include/uapi/asm/socket.h
@@ -135,6 +135,8 @@
 
 #define SO_DETACH_REUSEPORT_BPF 68
 
+#define SO_PREFER_BUSY_POLL	69
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
index 10173c32195e..1bc46200889d 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -116,6 +116,8 @@
 
 #define SO_DETACH_REUSEPORT_BPF 0x4042
 
+#define SO_PREFER_BUSY_POLL	0x4043
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
index 8029b681fc7c..99688cf673a4 100644
--- a/arch/sparc/include/uapi/asm/socket.h
+++ b/arch/sparc/include/uapi/asm/socket.h
@@ -117,6 +117,8 @@
 
 #define SO_DETACH_REUSEPORT_BPF  0x0047
 
+#define SO_PREFER_BUSY_POLL	 0x0048
+
 #if !defined(__KERNEL__)
 
 
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 4df61129566d..e11fab3a0b9e 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -397,7 +397,7 @@ static void ep_busy_loop(struct eventpoll *ep, int nonblock)
 	unsigned int napi_id = READ_ONCE(ep->napi_id);
 
 	if ((napi_id >= MIN_NAPI_ID) && net_busy_loop_on())
-		napi_busy_loop(napi_id, nonblock ? NULL : ep_busy_loop_end, ep);
+		napi_busy_loop(napi_id, nonblock ? NULL : ep_busy_loop_end, ep, false);
 }
 
 static inline void ep_reset_busy_poll_napi_id(struct eventpoll *ep)
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 964b494b0e8d..84dca3efdd05 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -350,23 +350,25 @@ struct napi_struct {
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
+	NAPI_STATE_PREFER_BUSY_POLL,	/* prefer busy-polling over softirq processing*/
 };
 
 enum {
-	NAPIF_STATE_SCHED	 = BIT(NAPI_STATE_SCHED),
-	NAPIF_STATE_MISSED	 = BIT(NAPI_STATE_MISSED),
-	NAPIF_STATE_DISABLE	 = BIT(NAPI_STATE_DISABLE),
-	NAPIF_STATE_NPSVC	 = BIT(NAPI_STATE_NPSVC),
-	NAPIF_STATE_LISTED	 = BIT(NAPI_STATE_LISTED),
-	NAPIF_STATE_NO_BUSY_POLL = BIT(NAPI_STATE_NO_BUSY_POLL),
-	NAPIF_STATE_IN_BUSY_POLL = BIT(NAPI_STATE_IN_BUSY_POLL),
+	NAPIF_STATE_SCHED		= BIT(NAPI_STATE_SCHED),
+	NAPIF_STATE_MISSED		= BIT(NAPI_STATE_MISSED),
+	NAPIF_STATE_DISABLE		= BIT(NAPI_STATE_DISABLE),
+	NAPIF_STATE_NPSVC		= BIT(NAPI_STATE_NPSVC),
+	NAPIF_STATE_LISTED		= BIT(NAPI_STATE_LISTED),
+	NAPIF_STATE_NO_BUSY_POLL	= BIT(NAPI_STATE_NO_BUSY_POLL),
+	NAPIF_STATE_IN_BUSY_POLL	= BIT(NAPI_STATE_IN_BUSY_POLL),
+	NAPIF_STATE_PREFER_BUSY_POLL	= BIT(NAPI_STATE_PREFER_BUSY_POLL),
 };
 
 enum gro_result {
@@ -437,6 +439,11 @@ static inline bool napi_disable_pending(struct napi_struct *n)
 	return test_bit(NAPI_STATE_DISABLE, &n->state);
 }
 
+static inline bool napi_prefer_busy_poll(struct napi_struct *n)
+{
+	return test_bit(NAPI_STATE_PREFER_BUSY_POLL, &n->state);
+}
+
 bool napi_schedule_prep(struct napi_struct *n);
 
 /**
diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index b001fa91c14e..0292b8353d7e 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -43,7 +43,7 @@ bool sk_busy_loop_end(void *p, unsigned long start_time);
 
 void napi_busy_loop(unsigned int napi_id,
 		    bool (*loop_end)(void *, unsigned long),
-		    void *loop_end_arg);
+		    void *loop_end_arg, bool prefer_busy_poll);
 
 #else /* CONFIG_NET_RX_BUSY_POLL */
 static inline unsigned long net_busy_loop_on(void)
@@ -105,7 +105,8 @@ static inline void sk_busy_loop(struct sock *sk, int nonblock)
 	unsigned int napi_id = READ_ONCE(sk->sk_napi_id);
 
 	if (napi_id >= MIN_NAPI_ID)
-		napi_busy_loop(napi_id, nonblock ? NULL : sk_busy_loop_end, sk);
+		napi_busy_loop(napi_id, nonblock ? NULL : sk_busy_loop_end, sk,
+			       READ_ONCE(sk->sk_prefer_busy_poll));
 #endif
 }
 
diff --git a/include/net/sock.h b/include/net/sock.h
index a5c6ae78df77..716960a15e83 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -479,6 +479,9 @@ struct sock {
 	u32			sk_ack_backlog;
 	u32			sk_max_ack_backlog;
 	kuid_t			sk_uid;
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	u8			sk_prefer_busy_poll;
+#endif
 	struct pid		*sk_peer_pid;
 	const struct cred	*sk_peer_cred;
 	long			sk_rcvtimeo;
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index 77f7c1638eb1..7dd02408b7ce 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -119,6 +119,8 @@
 
 #define SO_DETACH_REUSEPORT_BPF 68
 
+#define SO_PREFER_BUSY_POLL	69
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
diff --git a/net/core/dev.c b/net/core/dev.c
index 9499a414d67e..49015b059549 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6454,7 +6454,8 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 
 		WARN_ON_ONCE(!(val & NAPIF_STATE_SCHED));
 
-		new = val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED);
+		new = val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED |
+			      NAPIF_STATE_PREFER_BUSY_POLL);
 
 		/* If STATE_MISSED was set, leave STATE_SCHED set,
 		 * because we will call napi->poll() one more time.
@@ -6493,8 +6494,29 @@ static struct napi_struct *napi_by_id(unsigned int napi_id)
 
 #define BUSY_POLL_BUDGET 8
 
-static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock)
+static void __busy_poll_stop(struct napi_struct *napi, bool skip_schedule)
 {
+	if (!skip_schedule) {
+		gro_normal_list(napi);
+		__napi_schedule(napi);
+		return;
+	}
+
+	if (napi->gro_bitmask) {
+		/* flush too old packets
+		 * If HZ < 1000, flush all packets.
+		 */
+		napi_gro_flush(napi, HZ >= 1000);
+	}
+
+	gro_normal_list(napi);
+	clear_bit(NAPI_STATE_SCHED, &napi->state);
+}
+
+static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock, bool prefer_busy_poll)
+{
+	bool skip_schedule = false;
+	unsigned long timeout;
 	int rc;
 
 	/* Busy polling means there is a high chance device driver hard irq
@@ -6511,6 +6533,15 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock)
 
 	local_bh_disable();
 
+	if (prefer_busy_poll) {
+		napi->defer_hard_irqs_count = READ_ONCE(napi->dev->napi_defer_hard_irqs);
+		timeout = READ_ONCE(napi->dev->gro_flush_timeout);
+		if (napi->defer_hard_irqs_count && timeout) {
+			hrtimer_start(&napi->timer, ns_to_ktime(timeout), HRTIMER_MODE_REL_PINNED);
+			skip_schedule = true;
+		}
+	}
+
 	/* All we really want here is to re-enable device interrupts.
 	 * Ideally, a new ndo_busy_poll_stop() could avoid another round.
 	 */
@@ -6521,19 +6552,14 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock)
 	 */
 	trace_napi_poll(napi, rc, BUSY_POLL_BUDGET);
 	netpoll_poll_unlock(have_poll_lock);
-	if (rc == BUSY_POLL_BUDGET) {
-		/* As the whole budget was spent, we still own the napi so can
-		 * safely handle the rx_list.
-		 */
-		gro_normal_list(napi);
-		__napi_schedule(napi);
-	}
+	if (rc == BUSY_POLL_BUDGET)
+		__busy_poll_stop(napi, skip_schedule);
 	local_bh_enable();
 }
 
 void napi_busy_loop(unsigned int napi_id,
 		    bool (*loop_end)(void *, unsigned long),
-		    void *loop_end_arg)
+		    void *loop_end_arg, bool prefer_busy_poll)
 {
 	unsigned long start_time = loop_end ? busy_loop_current_time() : 0;
 	int (*napi_poll)(struct napi_struct *napi, int budget);
@@ -6561,12 +6587,18 @@ void napi_busy_loop(unsigned int napi_id,
 			 * we avoid dirtying napi->state as much as we can.
 			 */
 			if (val & (NAPIF_STATE_DISABLE | NAPIF_STATE_SCHED |
-				   NAPIF_STATE_IN_BUSY_POLL))
+				   NAPIF_STATE_IN_BUSY_POLL)) {
+				if (prefer_busy_poll)
+					set_bit(NAPI_STATE_PREFER_BUSY_POLL, &napi->state);
 				goto count;
+			}
 			if (cmpxchg(&napi->state, val,
 				    val | NAPIF_STATE_IN_BUSY_POLL |
-					  NAPIF_STATE_SCHED) != val)
+					  NAPIF_STATE_SCHED) != val) {
+				if (prefer_busy_poll)
+					set_bit(NAPI_STATE_PREFER_BUSY_POLL, &napi->state);
 				goto count;
+			}
 			have_poll_lock = netpoll_poll_lock(napi);
 			napi_poll = napi->poll;
 		}
@@ -6584,7 +6616,7 @@ void napi_busy_loop(unsigned int napi_id,
 
 		if (unlikely(need_resched())) {
 			if (napi_poll)
-				busy_poll_stop(napi, have_poll_lock);
+				busy_poll_stop(napi, have_poll_lock, prefer_busy_poll);
 			preempt_enable();
 			rcu_read_unlock();
 			cond_resched();
@@ -6595,7 +6627,7 @@ void napi_busy_loop(unsigned int napi_id,
 		cpu_relax();
 	}
 	if (napi_poll)
-		busy_poll_stop(napi, have_poll_lock);
+		busy_poll_stop(napi, have_poll_lock, prefer_busy_poll);
 	preempt_enable();
 out:
 	rcu_read_unlock();
@@ -6646,8 +6678,10 @@ static enum hrtimer_restart napi_watchdog(struct hrtimer *timer)
 	 * NAPI_STATE_MISSED, since we do not react to a device IRQ.
 	 */
 	if (!napi_disable_pending(napi) &&
-	    !test_and_set_bit(NAPI_STATE_SCHED, &napi->state))
+	    !test_and_set_bit(NAPI_STATE_SCHED, &napi->state)) {
+		clear_bit(NAPI_STATE_PREFER_BUSY_POLL, &napi->state);
 		__napi_schedule_irqoff(napi);
+	}
 
 	return HRTIMER_NORESTART;
 }
@@ -6705,6 +6739,7 @@ void napi_disable(struct napi_struct *n)
 
 	hrtimer_cancel(&n->timer);
 
+	clear_bit(NAPI_STATE_PREFER_BUSY_POLL, &n->state);
 	clear_bit(NAPI_STATE_DISABLE, &n->state);
 }
 EXPORT_SYMBOL(napi_disable);
@@ -6767,6 +6802,19 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 	if (likely(work < weight))
 		goto out_unlock;
 
+	/* The NAPI context has more processing work, but busy-polling
+	 * is preferred. Exit early.
+	 */
+	if (napi_prefer_busy_poll(n)) {
+		if (napi_complete_done(n, work)) {
+			/* If timeout is not set, we need to make sure
+			 * that the NAPI is re-scheduled.
+			 */
+			napi_schedule(n);
+		}
+		goto out_unlock;
+	}
+
 	/* Drivers must not modify the NAPI state if they
 	 * consume the entire weight.  In such cases this code
 	 * still "owns" the NAPI instance and therefore can
diff --git a/net/core/sock.c b/net/core/sock.c
index 727ea1cc633c..248f6a763661 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1159,6 +1159,12 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 				sk->sk_ll_usec = val;
 		}
 		break;
+	case SO_PREFER_BUSY_POLL:
+		if (valbool && !capable(CAP_NET_ADMIN))
+			ret = -EPERM;
+		else
+			sk->sk_prefer_busy_poll = valbool;
+		break;
 #endif
 
 	case SO_MAX_PACING_RATE:
@@ -1523,6 +1529,9 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 	case SO_BUSY_POLL:
 		v.val = sk->sk_ll_usec;
 		break;
+	case SO_PREFER_BUSY_POLL:
+		v.val = sk->sk_prefer_busy_poll;
+		break;
 #endif
 
 	case SO_MAX_PACING_RATE:
-- 
2.27.0

