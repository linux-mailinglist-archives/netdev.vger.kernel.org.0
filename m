Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFC3EC3AFE
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730403AbfJAQkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:40:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730301AbfJAQkw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:40:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B30C21D80;
        Tue,  1 Oct 2019 16:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948051;
        bh=ejwYFqJF+Z3CCeeyEPbC5ZQuHgcawi1Vkn1mUz3MXhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vR2Uv9AN0+8RuNjQMLnWq/7pfvkWHzeegCaCeWGGm2yZ7cslalTOMZDhFIDYYVqxz
         jfeZQcilsl/h7LijLBHBejWBBiycjfIxyyW+0nBanZ4aq+K7RmPPJGPM/EXE1Sdg9S
         VhqgjhwF3FgpCkWVErwtr4ub/p+TEXUgx3kxhdq8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Allan Zhang <allanzhang@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 55/71] bpf: Fix bpf_event_output re-entry issue
Date:   Tue,  1 Oct 2019 12:39:05 -0400
Message-Id: <20191001163922.14735-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allan Zhang <allanzhang@google.com>

[ Upstream commit 768fb61fcc13b2acaca758275d54c09a65e2968b ]

BPF_PROG_TYPE_SOCK_OPS program can reenter bpf_event_output because it
can be called from atomic and non-atomic contexts since we don't have
bpf_prog_active to prevent it happen.

This patch enables 3 levels of nesting to support normal, irq and nmi
context.

We can easily reproduce the issue by running netperf crr mode with 100
flows and 10 threads from netperf client side.

Here is the whole stack dump:

[  515.228898] WARNING: CPU: 20 PID: 14686 at kernel/trace/bpf_trace.c:549 bpf_event_output+0x1f9/0x220
[  515.228903] CPU: 20 PID: 14686 Comm: tcp_crr Tainted: G        W        4.15.0-smp-fixpanic #44
[  515.228904] Hardware name: Intel TBG,ICH10/Ikaria_QC_1b, BIOS 1.22.0 06/04/2018
[  515.228905] RIP: 0010:bpf_event_output+0x1f9/0x220
[  515.228906] RSP: 0018:ffff9a57ffc03938 EFLAGS: 00010246
[  515.228907] RAX: 0000000000000012 RBX: 0000000000000001 RCX: 0000000000000000
[  515.228907] RDX: 0000000000000000 RSI: 0000000000000096 RDI: ffffffff836b0f80
[  515.228908] RBP: ffff9a57ffc039c8 R08: 0000000000000004 R09: 0000000000000012
[  515.228908] R10: ffff9a57ffc1de40 R11: 0000000000000000 R12: 0000000000000002
[  515.228909] R13: ffff9a57e13bae00 R14: 00000000ffffffff R15: ffff9a57ffc1e2c0
[  515.228910] FS:  00007f5a3e6ec700(0000) GS:ffff9a57ffc00000(0000) knlGS:0000000000000000
[  515.228910] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  515.228911] CR2: 0000537082664fff CR3: 000000061fed6002 CR4: 00000000000226f0
[  515.228911] Call Trace:
[  515.228913]  <IRQ>
[  515.228919]  [<ffffffff82c6c6cb>] bpf_sockopt_event_output+0x3b/0x50
[  515.228923]  [<ffffffff8265daee>] ? bpf_ktime_get_ns+0xe/0x10
[  515.228927]  [<ffffffff8266fda5>] ? __cgroup_bpf_run_filter_sock_ops+0x85/0x100
[  515.228930]  [<ffffffff82cf90a5>] ? tcp_init_transfer+0x125/0x150
[  515.228933]  [<ffffffff82cf9159>] ? tcp_finish_connect+0x89/0x110
[  515.228936]  [<ffffffff82cf98e4>] ? tcp_rcv_state_process+0x704/0x1010
[  515.228939]  [<ffffffff82c6e263>] ? sk_filter_trim_cap+0x53/0x2a0
[  515.228942]  [<ffffffff82d90d1f>] ? tcp_v6_inbound_md5_hash+0x6f/0x1d0
[  515.228945]  [<ffffffff82d92160>] ? tcp_v6_do_rcv+0x1c0/0x460
[  515.228947]  [<ffffffff82d93558>] ? tcp_v6_rcv+0x9f8/0xb30
[  515.228951]  [<ffffffff82d737c0>] ? ip6_route_input+0x190/0x220
[  515.228955]  [<ffffffff82d5f7ad>] ? ip6_protocol_deliver_rcu+0x6d/0x450
[  515.228958]  [<ffffffff82d60246>] ? ip6_rcv_finish+0xb6/0x170
[  515.228961]  [<ffffffff82d5fb90>] ? ip6_protocol_deliver_rcu+0x450/0x450
[  515.228963]  [<ffffffff82d60361>] ? ipv6_rcv+0x61/0xe0
[  515.228966]  [<ffffffff82d60190>] ? ipv6_list_rcv+0x330/0x330
[  515.228969]  [<ffffffff82c4976b>] ? __netif_receive_skb_one_core+0x5b/0xa0
[  515.228972]  [<ffffffff82c497d1>] ? __netif_receive_skb+0x21/0x70
[  515.228975]  [<ffffffff82c4a8d2>] ? process_backlog+0xb2/0x150
[  515.228978]  [<ffffffff82c4aadf>] ? net_rx_action+0x16f/0x410
[  515.228982]  [<ffffffff830000dd>] ? __do_softirq+0xdd/0x305
[  515.228986]  [<ffffffff8252cfdc>] ? irq_exit+0x9c/0xb0
[  515.228989]  [<ffffffff82e02de5>] ? smp_call_function_single_interrupt+0x65/0x120
[  515.228991]  [<ffffffff82e020e1>] ? call_function_single_interrupt+0x81/0x90
[  515.228992]  </IRQ>
[  515.228996]  [<ffffffff82a11ff0>] ? io_serial_in+0x20/0x20
[  515.229000]  [<ffffffff8259c040>] ? console_unlock+0x230/0x490
[  515.229003]  [<ffffffff8259cbaa>] ? vprintk_emit+0x26a/0x2a0
[  515.229006]  [<ffffffff8259cbff>] ? vprintk_default+0x1f/0x30
[  515.229008]  [<ffffffff8259d9f5>] ? vprintk_func+0x35/0x70
[  515.229011]  [<ffffffff8259d4bb>] ? printk+0x50/0x66
[  515.229013]  [<ffffffff82637637>] ? bpf_event_output+0xb7/0x220
[  515.229016]  [<ffffffff82c6c6cb>] ? bpf_sockopt_event_output+0x3b/0x50
[  515.229019]  [<ffffffff8265daee>] ? bpf_ktime_get_ns+0xe/0x10
[  515.229023]  [<ffffffff82c29e87>] ? release_sock+0x97/0xb0
[  515.229026]  [<ffffffff82ce9d6a>] ? tcp_recvmsg+0x31a/0xda0
[  515.229029]  [<ffffffff8266fda5>] ? __cgroup_bpf_run_filter_sock_ops+0x85/0x100
[  515.229032]  [<ffffffff82ce77c1>] ? tcp_set_state+0x191/0x1b0
[  515.229035]  [<ffffffff82ced10e>] ? tcp_disconnect+0x2e/0x600
[  515.229038]  [<ffffffff82cecbbb>] ? tcp_close+0x3eb/0x460
[  515.229040]  [<ffffffff82d21082>] ? inet_release+0x42/0x70
[  515.229043]  [<ffffffff82d58809>] ? inet6_release+0x39/0x50
[  515.229046]  [<ffffffff82c1f32d>] ? __sock_release+0x4d/0xd0
[  515.229049]  [<ffffffff82c1f3e5>] ? sock_close+0x15/0x20
[  515.229052]  [<ffffffff8273b517>] ? __fput+0xe7/0x1f0
[  515.229055]  [<ffffffff8273b66e>] ? ____fput+0xe/0x10
[  515.229058]  [<ffffffff82547bf2>] ? task_work_run+0x82/0xb0
[  515.229061]  [<ffffffff824086df>] ? exit_to_usermode_loop+0x7e/0x11f
[  515.229064]  [<ffffffff82408171>] ? do_syscall_64+0x111/0x130
[  515.229067]  [<ffffffff82e0007c>] ? entry_SYSCALL_64_after_hwframe+0x3d/0xa2

Fixes: a5a3a828cd00 ("bpf: add perf event notificaton support for sock_ops")
Signed-off-by: Allan Zhang <allanzhang@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Stanislav Fomichev <sdf@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20190925234312.94063-2-allanzhang@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index ca1255d145766..3e38a010003c9 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -500,14 +500,17 @@ static const struct bpf_func_proto bpf_perf_event_output_proto = {
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
-static DEFINE_PER_CPU(struct pt_regs, bpf_pt_regs);
-static DEFINE_PER_CPU(struct perf_sample_data, bpf_misc_sd);
+static DEFINE_PER_CPU(int, bpf_event_output_nest_level);
+struct bpf_nested_pt_regs {
+	struct pt_regs regs[3];
+};
+static DEFINE_PER_CPU(struct bpf_nested_pt_regs, bpf_pt_regs);
+static DEFINE_PER_CPU(struct bpf_trace_sample_data, bpf_misc_sds);
 
 u64 bpf_event_output(struct bpf_map *map, u64 flags, void *meta, u64 meta_size,
 		     void *ctx, u64 ctx_size, bpf_ctx_copy_t ctx_copy)
 {
-	struct perf_sample_data *sd = this_cpu_ptr(&bpf_misc_sd);
-	struct pt_regs *regs = this_cpu_ptr(&bpf_pt_regs);
+	int nest_level = this_cpu_inc_return(bpf_event_output_nest_level);
 	struct perf_raw_frag frag = {
 		.copy		= ctx_copy,
 		.size		= ctx_size,
@@ -522,12 +525,25 @@ u64 bpf_event_output(struct bpf_map *map, u64 flags, void *meta, u64 meta_size,
 			.data	= meta,
 		},
 	};
+	struct perf_sample_data *sd;
+	struct pt_regs *regs;
+	u64 ret;
+
+	if (WARN_ON_ONCE(nest_level > ARRAY_SIZE(bpf_misc_sds.sds))) {
+		ret = -EBUSY;
+		goto out;
+	}
+	sd = this_cpu_ptr(&bpf_misc_sds.sds[nest_level - 1]);
+	regs = this_cpu_ptr(&bpf_pt_regs.regs[nest_level - 1]);
 
 	perf_fetch_caller_regs(regs);
 	perf_sample_data_init(sd, 0, 0);
 	sd->raw = &raw;
 
-	return __bpf_perf_event_output(regs, map, flags, sd);
+	ret = __bpf_perf_event_output(regs, map, flags, sd);
+out:
+	this_cpu_dec(bpf_event_output_nest_level);
+	return ret;
 }
 
 BPF_CALL_0(bpf_get_current_task)
-- 
2.20.1

