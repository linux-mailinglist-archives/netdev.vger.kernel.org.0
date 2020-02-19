Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6598916396D
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 02:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgBSBiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 20:38:04 -0500
Received: from mga18.intel.com ([134.134.136.126]:22398 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbgBSBiD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 20:38:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 17:38:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="436061496"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.26])
  by fmsmga006.fm.intel.com with ESMTP; 18 Feb 2020 17:38:02 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC patch 09/19] bpf: Use BPF_PROG_RUN_PIN_ON_CPU() at simple call sites.
In-Reply-To: <20200214161503.804093748@linutronix.de>
References: <20200214133917.304937432@linutronix.de> <20200214161503.804093748@linutronix.de>
Date:   Tue, 18 Feb 2020 17:39:45 -0800
Message-ID: <87a75ftkwu.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thomas Gleixner <tglx@linutronix.de> writes:

> From: David Miller <davem@davemloft.net>
>
> All of these cases are strictly of the form:
>
> 	preempt_disable();
> 	BPF_PROG_RUN(...);
> 	preempt_enable();
>
> Replace this with BPF_PROG_RUN_PIN_ON_CPU() which wraps BPF_PROG_RUN()
> with:
>
> 	migrate_disable();
> 	BPF_PROG_RUN(...);
> 	migrate_enable();
>
> On non RT enabled kernels this maps to preempt_disable/enable() and on RT
> enabled kernels this solely prevents migration, which is sufficient as
> there is no requirement to prevent reentrancy to any BPF program from a
> preempting task. The only requirement is that the program stays on the same
> CPU.
>
> Therefore, this is a trivially correct transformation.
>
> [ tglx: Converted to BPF_PROG_RUN_PIN_ON_CPU() ]
>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>
> ---
>  include/linux/filter.h    |    4 +---
>  kernel/seccomp.c          |    4 +---
>  net/core/flow_dissector.c |    4 +---
>  net/core/skmsg.c          |    8 ++------
>  net/kcm/kcmsock.c         |    4 +---
>  5 files changed, 6 insertions(+), 18 deletions(-)
>
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -713,9 +713,7 @@ static inline u32 bpf_prog_run_clear_cb(
>  	if (unlikely(prog->cb_access))
>  		memset(cb_data, 0, BPF_SKB_CB_LEN);
>  
> -	preempt_disable();
> -	res = BPF_PROG_RUN(prog, skb);
> -	preempt_enable();
> +	res = BPF_PROG_RUN_PIN_ON_CPU(prog, skb);
>  	return res;
>  }
>  
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -268,16 +268,14 @@ static u32 seccomp_run_filters(const str
>  	 * All filters in the list are evaluated and the lowest BPF return
>  	 * value always takes priority (ignoring the DATA).
>  	 */
> -	preempt_disable();
>  	for (; f; f = f->prev) {
> -		u32 cur_ret = BPF_PROG_RUN(f->prog, sd);
> +		u32 cur_ret = BPF_PROG_RUN_PIN_ON_CPU(f->prog, sd);
>

More a question really, isn't the behavior changing here? i.e. shouldn't
migrate_disable()/migrate_enable() be moved to outside the loop? Or is
running seccomp filters on different cpus not a problem?

-- 
Vinicius
