Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F25315E5EC
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393014AbgBNQVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:21:35 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55565 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392987AbgBNQVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 11:21:34 -0500
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j2diH-0003Lv-RH; Fri, 14 Feb 2020 17:21:09 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 5D33D101DF7;
        Fri, 14 Feb 2020 17:21:06 +0100 (CET)
Message-Id: <20200214161504.217633021@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 14 Feb 2020 14:39:30 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC patch 13/19] bpf: Use migrate_disable/enable in array macros and cgroup/lirc code.
References: <20200214133917.304937432@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>

Replace the preemption disable/enable with migrate_disable/enable() to
reflect the actual requirement and to allow PREEMPT_RT to substitute it
with an actual migration disable mechanism which does not disable
preemption.

Including the code paths that go via __bpf_prog_run_save_cb().

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/bpf.h    |    8 ++++----
 include/linux/filter.h |    5 +++--
 2 files changed, 7 insertions(+), 6 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -885,7 +885,7 @@ int bpf_prog_array_copy(struct bpf_prog_
 		struct bpf_prog *_prog;			\
 		struct bpf_prog_array *_array;		\
 		u32 _ret = 1;				\
-		preempt_disable();			\
+		migrate_disable();			\
 		rcu_read_lock();			\
 		_array = rcu_dereference(array);	\
 		if (unlikely(check_non_null && !_array))\
@@ -898,7 +898,7 @@ int bpf_prog_array_copy(struct bpf_prog_
 		}					\
 _out:							\
 		rcu_read_unlock();			\
-		preempt_enable();			\
+		migrate_enable();			\
 		_ret;					\
 	 })
 
@@ -932,7 +932,7 @@ int bpf_prog_array_copy(struct bpf_prog_
 		u32 ret;				\
 		u32 _ret = 1;				\
 		u32 _cn = 0;				\
-		preempt_disable();			\
+		migrate_disable();			\
 		rcu_read_lock();			\
 		_array = rcu_dereference(array);	\
 		_item = &_array->items[0];		\
@@ -944,7 +944,7 @@ int bpf_prog_array_copy(struct bpf_prog_
 			_item++;			\
 		}					\
 		rcu_read_unlock();			\
-		preempt_enable();			\
+		migrate_enable();			\
 		if (_ret)				\
 			_ret = (_cn ? NET_XMIT_CN : NET_XMIT_SUCCESS);	\
 		else					\
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -673,6 +673,7 @@ static inline u8 *bpf_skb_cb(struct sk_b
 	return qdisc_skb_cb(skb)->data;
 }
 
+/* Must be invoked with migration disabled */
 static inline u32 __bpf_prog_run_save_cb(const struct bpf_prog *prog,
 					 struct sk_buff *skb)
 {
@@ -698,9 +699,9 @@ static inline u32 bpf_prog_run_save_cb(c
 {
 	u32 res;
 
-	preempt_disable();
+	migrate_disable();
 	res = __bpf_prog_run_save_cb(prog, skb);
-	preempt_enable();
+	migrate_enable();
 	return res;
 }
 

