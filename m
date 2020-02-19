Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A148D163FE1
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 10:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgBSJBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 04:01:39 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:37615 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgBSJBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 04:01:38 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j4LE1-0000bh-BZ; Wed, 19 Feb 2020 10:00:57 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 6083A100F56; Wed, 19 Feb 2020 10:00:56 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC patch 09/19] bpf: Use BPF_PROG_RUN_PIN_ON_CPU() at simple call sites.
In-Reply-To: <87a75ftkwu.fsf@linux.intel.com>
References: <20200214133917.304937432@linutronix.de> <20200214161503.804093748@linutronix.de> <87a75ftkwu.fsf@linux.intel.com>
Date:   Wed, 19 Feb 2020 10:00:56 +0100
Message-ID: <875zg3q7cn.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vinicius Costa Gomes <vinicius.gomes@intel.com> writes:

Cc+: seccomp folks 

> Thomas Gleixner <tglx@linutronix.de> writes:
>
>> From: David Miller <davem@davemloft.net>

Leaving content for reference

>> All of these cases are strictly of the form:
>>
>> 	preempt_disable();
>> 	BPF_PROG_RUN(...);
>> 	preempt_enable();
>>
>> Replace this with BPF_PROG_RUN_PIN_ON_CPU() which wraps BPF_PROG_RUN()
>> with:
>>
>> 	migrate_disable();
>> 	BPF_PROG_RUN(...);
>> 	migrate_enable();
>>
>> On non RT enabled kernels this maps to preempt_disable/enable() and on RT
>> enabled kernels this solely prevents migration, which is sufficient as
>> there is no requirement to prevent reentrancy to any BPF program from a
>> preempting task. The only requirement is that the program stays on the same
>> CPU.
>>
>> Therefore, this is a trivially correct transformation.
>>
>> [ tglx: Converted to BPF_PROG_RUN_PIN_ON_CPU() ]
>>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>>
>> ---
>>  include/linux/filter.h    |    4 +---
>>  kernel/seccomp.c          |    4 +---
>>  net/core/flow_dissector.c |    4 +---
>>  net/core/skmsg.c          |    8 ++------
>>  net/kcm/kcmsock.c         |    4 +---
>>  5 files changed, 6 insertions(+), 18 deletions(-)
>>
>> --- a/include/linux/filter.h
>> +++ b/include/linux/filter.h
>> @@ -713,9 +713,7 @@ static inline u32 bpf_prog_run_clear_cb(
>>  	if (unlikely(prog->cb_access))
>>  		memset(cb_data, 0, BPF_SKB_CB_LEN);
>>  
>> -	preempt_disable();
>> -	res = BPF_PROG_RUN(prog, skb);
>> -	preempt_enable();
>> +	res = BPF_PROG_RUN_PIN_ON_CPU(prog, skb);
>>  	return res;
>>  }
>>  
>> --- a/kernel/seccomp.c
>> +++ b/kernel/seccomp.c
>> @@ -268,16 +268,14 @@ static u32 seccomp_run_filters(const str
>>  	 * All filters in the list are evaluated and the lowest BPF return
>>  	 * value always takes priority (ignoring the DATA).
>>  	 */
>> -	preempt_disable();
>>  	for (; f; f = f->prev) {
>> -		u32 cur_ret = BPF_PROG_RUN(f->prog, sd);
>> +		u32 cur_ret = BPF_PROG_RUN_PIN_ON_CPU(f->prog, sd);
>>
>
> More a question really, isn't the behavior changing here? i.e. shouldn't
> migrate_disable()/migrate_enable() be moved to outside the loop? Or is
> running seccomp filters on different cpus not a problem?

In my understanding this is a list of filters and they are independent
of each other.

Kees, Will. Andy?

Thanks,

        tglx
