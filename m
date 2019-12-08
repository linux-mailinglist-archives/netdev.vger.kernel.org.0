Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52EE6115FEA
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 01:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfLHAEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 19:04:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44944 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbfLHAEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 19:04:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B783915449D7D;
        Sat,  7 Dec 2019 16:04:22 -0800 (PST)
Date:   Sat, 07 Dec 2019 16:04:22 -0800 (PST)
Message-Id: <20191207.160422.913393771404629217.davem@davemloft.net>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
CC:     ast@kernel.org, daniel@iogearbox.net, tglx@linutronix.de
Subject: [RFC v1 PATCH 3/7] bpf: Remove preemption disable from simple call
 sites.
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Dec 2019 16:04:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


All of these cases are strictly of the form:

	preempt_disable();
	BPF_PROG_RUN(...);
	preempt_enable();

BPF_PROG_RUN() is now a wrapper around __BPF_PROG_RUN()
which disables migration (via RT local locking primitives
or preemption disabling).

Therefore, this is a trivially correct transformation.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/linux/filter.h    | 2 --
 kernel/trace/bpf_trace.c  | 2 --
 net/core/flow_dissector.c | 2 --
 net/kcm/kcmsock.c         | 2 --
 4 files changed, 8 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 1f4a782b6184..a64adc7751e8 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -714,9 +714,7 @@ static inline u32 bpf_prog_run_clear_cb(const struct bpf_prog *prog,
 	if (unlikely(prog->cb_access))
 		memset(cb_data, 0, BPF_SKB_CB_LEN);
 
-	preempt_disable();
 	res = BPF_PROG_RUN(prog, skb);
-	preempt_enable();
 	return res;
 }
 
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index ffc91d4935ac..cc4873cfaab2 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1455,9 +1455,7 @@ static __always_inline
 void __bpf_trace_run(struct bpf_prog *prog, u64 *args)
 {
 	rcu_read_lock();
-	preempt_disable();
 	(void) BPF_PROG_RUN(prog, args);
-	preempt_enable();
 	rcu_read_unlock();
 }
 
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index ca871657a4c4..ffd384ba929f 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -888,9 +888,7 @@ bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
 		     (int)FLOW_DISSECTOR_F_STOP_AT_ENCAP);
 	flow_keys->flags = flags;
 
-	preempt_disable();
 	result = BPF_PROG_RUN(prog, ctx);
-	preempt_enable();
 
 	flow_keys->nhoff = clamp_t(u16, flow_keys->nhoff, nhoff, hlen);
 	flow_keys->thoff = clamp_t(u16, flow_keys->thoff,
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index ea9e73428ed9..d5f9d4d8e06c 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -380,9 +380,7 @@ static int kcm_parse_func_strparser(struct strparser *strp, struct sk_buff *skb)
 	struct bpf_prog *prog = psock->bpf_prog;
 	int res;
 
-	preempt_disable();
 	res = BPF_PROG_RUN(prog, skb);
-	preempt_enable();
 	return res;
 }
 
-- 
2.20.1

