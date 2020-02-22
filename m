Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9676D168DA8
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 09:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgBVIkz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 22 Feb 2020 03:40:55 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:47359 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgBVIkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 03:40:55 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1j5QKY-0007U5-Vw; Sat, 22 Feb 2020 09:40:11 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 50624100BB5; Sat, 22 Feb 2020 09:40:10 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [patch V2 01/20] bpf: Enforce preallocation for all instrumentation programs
In-Reply-To: <20200222042916.k3r5dj5njoo2ywyj@ast-mbp>
Date:   Sat, 22 Feb 2020 09:40:10 +0100
Message-ID: <87o8tr3thx.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei,

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> On Thu, Feb 20, 2020 at 09:45:18PM +0100, Thomas Gleixner wrote:
>> The assumption that only programs attached to perf NMI events can deadlock
>> on memory allocators is wrong. Assume the following simplified callchain:
>>  	 */
>> -	if (prog->type == BPF_PROG_TYPE_PERF_EVENT) {
>> +	if ((is_tracing_prog_type(prog->type)) {
>
> This doesn't build.
> I assumed the typo somehow sneaked in and proceeded, but it broke
> a bunch of tests:
> Summary: 1526 PASSED, 0 SKIPPED, 54 FAILED
> One can argue that the test are unsafe and broken.
> We used to test all those tests with and without prealloc:
> map_flags = 0;
> run_all_tests();
> map_flags = BPF_F_NO_PREALLOC;
> run_all_tests();
> Then 4 years ago commit 5aa5bd14c5f866 switched hashmap to be no_prealloc
> always and that how it stayed since then. We can adjust the tests to use
> prealloc with tracing progs, but this breakage shows that there could be plenty
> of bpf users that also use BPF_F_NO_PREALLOC with tracing. It could simply
> be because they know that their kprobes are in a safe spot (and kmalloc is ok)
> and they want to save memory. They could be using large max_entries parameter
> for worst case hash map usage, but typical load is low. In general hashtables
> don't perform well after 50%, so prealloc is wasting half of the memory. Since
> we cannot control where kprobes are placed I'm not sure what is the right fix
> here. It feels that if we proceed with this patch somebody will complain and we
> would have to revert, but I'm willing to take this risk if we cannot come up
> with an alternative fix.

Having something which is known to be broken exposed is not a good option
either.

Just assume that someone is investigating a kernel issue. BOFH who is
stuck in the 90's uses perf, kprobes and tracepoints. Now he goes on
vacation and the new kid in the team decides to flip that over to BPF.
So now instead of getting information he deadlocks or crashes the
machine.

You can't just tell him, don't do that then. It's broken by design and
you really can't tell which probes are safe and which are not because
the allocator calls out into whatever functions which might look
completely unrelated.

So one way to phase this out would be:

	if (is_tracing()) {
        	if (is_perf() || IS_ENABLED(RT))
                	return -EINVAL;
                WARN_ONCE(.....)
        }

And clearly write in the warning that this is dangerous, broken and
about to be forbidden. Hmm?

> Going further with the patchset.
>
> Patch 9 "bpf: Use bpf_prog_run_pin_on_cpu() at simple call sites."
> adds new warning:
> ../kernel/seccomp.c: In function ‘seccomp_run_filters’:
> ../kernel/seccomp.c:272:50: warning: passing argument 2 of ‘bpf_prog_run_pin_on_cpu’ discards ‘const’ qualifier from pointer target type [-Wdiscarded-qualifiers]
>    u32 cur_ret = bpf_prog_run_pin_on_cpu(f->prog, sd);

Uurgh. I'm sure I fixed that and then I must have lost it again while
reshuffling stuff. Sorry about that.

> That's where I gave up.

Fair enough.

> I pulled sched-for-bpf-2020-02-20 branch from tip and pushed it into bpf-next.
> Could you please rebase your set on top of bpf-next and repost?
> The logic in all patches looks good.

Will do.

Thanks,

        tglx
