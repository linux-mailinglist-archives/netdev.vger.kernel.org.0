Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540CB2B4226
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 12:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbgKPLEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 06:04:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgKPLEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 06:04:45 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970BCC0613CF;
        Mon, 16 Nov 2020 03:04:45 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id q28so2374396pgk.1;
        Mon, 16 Nov 2020 03:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jJrxUz4PSTGuravZWEP1ai3hdAUzwZ/Hs3HSx9Xe8Yc=;
        b=rQjg3j43SKw3BuZ7WXdiO3MvIi+qOHZg7hkXM2AMtUVD7JTmN3ItjB0sx1ecunXj5C
         qZTLI0bwhhpR51p05pa6NvJFVXIGlbMSdxlQONzTk9nYS1i1T1S0I1fM1RLEDJ4dMLPR
         juruIv+4sJYLxV6EWHD2S+L9DgDFCEv39T1vIW0qWkNj6qk7cNW0zsa+GvxT4TWSalUp
         KgHnzULJEc++4/dNoN35nY8qN2ilnzQ+/1vJ26AfaUjoFt3vZcgBbx75fAMxtr1fGY2O
         YxcfRZzdZjWe7BN60ARWmBrH+ci13GJfUZVfspL/c6oX92JpnCmCuAjpvc6xg3Z5luIP
         eQPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jJrxUz4PSTGuravZWEP1ai3hdAUzwZ/Hs3HSx9Xe8Yc=;
        b=F/d4+82aqZ9OEHWOKBqmi186yj5oqB2vcJbXKaAd2rhXgfMluk7YLA0NyM2bT98P1Y
         x4B8KZ1sTlaZqurRwvRKmmM1g9hirAGfRsH8Q9qlKlW/MwCjFuBzhsh4u8/pxmxDOVgX
         BhYXpAFJCG5c33Bpytik2GuLG2/j3mSGfIJ3xACFIBI/HQIcIWBbpwK6QEzhZY4xDE4x
         PIBRdsJkkLdqjuD5ZWpHUjK1zo4Yughx6siAOkDUQhMP4Kkj2Syd1rnlsJoltNr3Yn1B
         wAJ8Tscce1PBxJoA1QJAlqxjxtcqPVA4aTs6XAbAhVgrZdeRLtqsdOO5m5cV12kjGjR/
         4Khw==
X-Gm-Message-State: AOAM532PdcTVkCQsV5vlorImo6Fv7IR/m/ihMBHIW5XA/xg6sbaxn9BT
        MtCm4xe7J1ZxqtpYlXo4OBhPSuIF0zQhzg==
X-Google-Smtp-Source: ABdhPJwhU0wmjh8ga5yoYTNAFrliuTXpsLZp2dfGQ+M//aJ92WXhI8MN3NSN6ozLi9R6rlaoboRdTA==
X-Received: by 2002:a17:90a:a393:: with SMTP id x19mr15278220pjp.8.1605524684580;
        Mon, 16 Nov 2020 03:04:44 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id a23sm15752890pgv.35.2020.11.16.03.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 03:04:43 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next v2 02/10] net: add SO_BUSY_POLL_BUDGET socket option
Date:   Mon, 16 Nov 2020 12:04:08 +0100
Message-Id: <20201116110416.10719-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201116110416.10719-1-bjorn.topel@gmail.com>
References: <20201116110416.10719-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

This option lets a user set a per socket NAPI budget for
busy-polling. If the options is not set, it will use the default of 8.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 arch/alpha/include/uapi/asm/socket.h  |  1 +
 arch/mips/include/uapi/asm/socket.h   |  1 +
 arch/parisc/include/uapi/asm/socket.h |  1 +
 arch/sparc/include/uapi/asm/socket.h  |  1 +
 fs/eventpoll.c                        |  3 ++-
 include/net/busy_poll.h               |  7 +++++--
 include/net/sock.h                    |  2 ++
 include/uapi/asm-generic/socket.h     |  1 +
 net/core/dev.c                        | 21 ++++++++++-----------
 net/core/sock.c                       | 10 ++++++++++
 10 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
index 538359642554..57420356ce4c 100644
--- a/arch/alpha/include/uapi/asm/socket.h
+++ b/arch/alpha/include/uapi/asm/socket.h
@@ -125,6 +125,7 @@
 #define SO_DETACH_REUSEPORT_BPF 68
 
 #define SO_PREFER_BUSY_POLL	69
+#define SO_BUSY_POLL_BUDGET	70
 
 #if !defined(__KERNEL__)
 
diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
index e406e73b5e6e..2d949969313b 100644
--- a/arch/mips/include/uapi/asm/socket.h
+++ b/arch/mips/include/uapi/asm/socket.h
@@ -136,6 +136,7 @@
 #define SO_DETACH_REUSEPORT_BPF 68
 
 #define SO_PREFER_BUSY_POLL	69
+#define SO_BUSY_POLL_BUDGET	70
 
 #if !defined(__KERNEL__)
 
diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
index 1bc46200889d..f60904329bbc 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -117,6 +117,7 @@
 #define SO_DETACH_REUSEPORT_BPF 0x4042
 
 #define SO_PREFER_BUSY_POLL	0x4043
+#define SO_BUSY_POLL_BUDGET	0x4044
 
 #if !defined(__KERNEL__)
 
diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
index 99688cf673a4..848a22fbac20 100644
--- a/arch/sparc/include/uapi/asm/socket.h
+++ b/arch/sparc/include/uapi/asm/socket.h
@@ -118,6 +118,7 @@
 #define SO_DETACH_REUSEPORT_BPF  0x0047
 
 #define SO_PREFER_BUSY_POLL	 0x0048
+#define SO_BUSY_POLL_BUDGET	 0x0049
 
 #if !defined(__KERNEL__)
 
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index e11fab3a0b9e..73c346e503d7 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -397,7 +397,8 @@ static void ep_busy_loop(struct eventpoll *ep, int nonblock)
 	unsigned int napi_id = READ_ONCE(ep->napi_id);
 
 	if ((napi_id >= MIN_NAPI_ID) && net_busy_loop_on())
-		napi_busy_loop(napi_id, nonblock ? NULL : ep_busy_loop_end, ep, false);
+		napi_busy_loop(napi_id, nonblock ? NULL : ep_busy_loop_end, ep, false,
+			       BUSY_POLL_BUDGET);
 }
 
 static inline void ep_reset_busy_poll_napi_id(struct eventpoll *ep)
diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index 0292b8353d7e..2f8f51807b83 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -23,6 +23,8 @@
  */
 #define MIN_NAPI_ID ((unsigned int)(NR_CPUS + 1))
 
+#define BUSY_POLL_BUDGET 8
+
 #ifdef CONFIG_NET_RX_BUSY_POLL
 
 struct napi_struct;
@@ -43,7 +45,7 @@ bool sk_busy_loop_end(void *p, unsigned long start_time);
 
 void napi_busy_loop(unsigned int napi_id,
 		    bool (*loop_end)(void *, unsigned long),
-		    void *loop_end_arg, bool prefer_busy_poll);
+		    void *loop_end_arg, bool prefer_busy_poll, u16 budget);
 
 #else /* CONFIG_NET_RX_BUSY_POLL */
 static inline unsigned long net_busy_loop_on(void)
@@ -106,7 +108,8 @@ static inline void sk_busy_loop(struct sock *sk, int nonblock)
 
 	if (napi_id >= MIN_NAPI_ID)
 		napi_busy_loop(napi_id, nonblock ? NULL : sk_busy_loop_end, sk,
-			       READ_ONCE(sk->sk_prefer_busy_poll));
+			       READ_ONCE(sk->sk_prefer_busy_poll),
+			       READ_ONCE(sk->sk_busy_poll_budget) ?: BUSY_POLL_BUDGET);
 #endif
 }
 
diff --git a/include/net/sock.h b/include/net/sock.h
index d49b89b071b6..77ba2c2737db 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -302,6 +302,7 @@ struct bpf_local_storage;
   *	@sk_max_ack_backlog: listen backlog set in listen()
   *	@sk_uid: user id of owner
   *	@sk_prefer_busy_poll: prefer busypolling over softirq processing
+  *	@sk_busy_poll_budget: napi processing budget when busypolling
   *	@sk_priority: %SO_PRIORITY setting
   *	@sk_type: socket type (%SOCK_STREAM, etc)
   *	@sk_protocol: which protocol this socket belongs in this network family
@@ -482,6 +483,7 @@ struct sock {
 	kuid_t			sk_uid;
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	u8			sk_prefer_busy_poll;
+	u16			sk_busy_poll_budget;
 #endif
 	struct pid		*sk_peer_pid;
 	const struct cred	*sk_peer_cred;
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index 7dd02408b7ce..4dcd13d097a9 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -120,6 +120,7 @@
 #define SO_DETACH_REUSEPORT_BPF 68
 
 #define SO_PREFER_BUSY_POLL	69
+#define SO_BUSY_POLL_BUDGET	70
 
 #if !defined(__KERNEL__)
 
diff --git a/net/core/dev.c b/net/core/dev.c
index a08de8cf5efb..a5f907d26ffb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6496,8 +6496,6 @@ static struct napi_struct *napi_by_id(unsigned int napi_id)
 
 #if defined(CONFIG_NET_RX_BUSY_POLL)
 
-#define BUSY_POLL_BUDGET 8
-
 static void __busy_poll_stop(struct napi_struct *napi, bool skip_schedule)
 {
 	if (!skip_schedule) {
@@ -6517,7 +6515,8 @@ static void __busy_poll_stop(struct napi_struct *napi, bool skip_schedule)
 	clear_bit(NAPI_STATE_SCHED, &napi->state);
 }
 
-static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock, bool prefer_busy_poll)
+static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock, bool prefer_busy_poll,
+			   u16 budget)
 {
 	bool skip_schedule = false;
 	unsigned long timeout;
@@ -6549,21 +6548,21 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock, bool
 	/* All we really want here is to re-enable device interrupts.
 	 * Ideally, a new ndo_busy_poll_stop() could avoid another round.
 	 */
-	rc = napi->poll(napi, BUSY_POLL_BUDGET);
+	rc = napi->poll(napi, budget);
 	/* We can't gro_normal_list() here, because napi->poll() might have
 	 * rearmed the napi (napi_complete_done()) in which case it could
 	 * already be running on another CPU.
 	 */
-	trace_napi_poll(napi, rc, BUSY_POLL_BUDGET);
+	trace_napi_poll(napi, rc, budget);
 	netpoll_poll_unlock(have_poll_lock);
-	if (rc == BUSY_POLL_BUDGET)
+	if (rc == budget)
 		__busy_poll_stop(napi, skip_schedule);
 	local_bh_enable();
 }
 
 void napi_busy_loop(unsigned int napi_id,
 		    bool (*loop_end)(void *, unsigned long),
-		    void *loop_end_arg, bool prefer_busy_poll)
+		    void *loop_end_arg, bool prefer_busy_poll, u16 budget)
 {
 	unsigned long start_time = loop_end ? busy_loop_current_time() : 0;
 	int (*napi_poll)(struct napi_struct *napi, int budget);
@@ -6606,8 +6605,8 @@ void napi_busy_loop(unsigned int napi_id,
 			have_poll_lock = netpoll_poll_lock(napi);
 			napi_poll = napi->poll;
 		}
-		work = napi_poll(napi, BUSY_POLL_BUDGET);
-		trace_napi_poll(napi, work, BUSY_POLL_BUDGET);
+		work = napi_poll(napi, budget);
+		trace_napi_poll(napi, work, budget);
 		gro_normal_list(napi);
 count:
 		if (work > 0)
@@ -6620,7 +6619,7 @@ void napi_busy_loop(unsigned int napi_id,
 
 		if (unlikely(need_resched())) {
 			if (napi_poll)
-				busy_poll_stop(napi, have_poll_lock, prefer_busy_poll);
+				busy_poll_stop(napi, have_poll_lock, prefer_busy_poll, budget);
 			preempt_enable();
 			rcu_read_unlock();
 			cond_resched();
@@ -6631,7 +6630,7 @@ void napi_busy_loop(unsigned int napi_id,
 		cpu_relax();
 	}
 	if (napi_poll)
-		busy_poll_stop(napi, have_poll_lock, prefer_busy_poll);
+		busy_poll_stop(napi, have_poll_lock, prefer_busy_poll, budget);
 	preempt_enable();
 out:
 	rcu_read_unlock();
diff --git a/net/core/sock.c b/net/core/sock.c
index e05f2e52b5a8..d422a6808405 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1165,6 +1165,16 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		else
 			WRITE_ONCE(sk->sk_prefer_busy_poll, valbool);
 		break;
+	case SO_BUSY_POLL_BUDGET:
+		if (val > READ_ONCE(sk->sk_busy_poll_budget) && !capable(CAP_NET_ADMIN)) {
+			ret = -EPERM;
+		} else {
+			if (val < 0 || val > U16_MAX)
+				ret = -EINVAL;
+			else
+				WRITE_ONCE(sk->sk_busy_poll_budget, val);
+		}
+		break;
 #endif
 
 	case SO_MAX_PACING_RATE:
-- 
2.27.0

