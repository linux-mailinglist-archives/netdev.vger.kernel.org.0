Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91E24ECEB2
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 23:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233304AbiC3VZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 17:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbiC3VZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 17:25:55 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F9D212ABA;
        Wed, 30 Mar 2022 14:24:09 -0700 (PDT)
Received: from kbox (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id EC31220DEE59;
        Wed, 30 Mar 2022 14:24:08 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EC31220DEE59
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1648675449;
        bh=ldB55PLaWGwkTJ/8hF8Op9amqeTslGaolYjAZkrAJkM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tOyTby/mYxcvIfexhqlgh+h+ujRQBbTGbJ3+/wpVxLNnJqvddwL5MLmYgNgoxH7Rt
         OC+uQey4tJK0xjiqTQIKU6jJHuDsTfxagWG/q1WxLujcAzIG44/eIYSgRQEdY5XPyE
         AcR55pnpPt8goxRg8FgpR4PtQZGOppu0qkvAn7Wc=
Date:   Wed, 30 Mar 2022 14:24:02 -0700
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <song@kernel.org>, rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] tracing/user_events: Add eBPF interface for user_event
 created events
Message-ID: <20220330212402.GA2719@kbox>
References: <20220329181935.2183-1-beaub@linux.microsoft.com>
 <20220329201057.GA2549@kbox>
 <CAADnVQ+gm4yU9S6y+oeR3TNj82kKX0gk4ey9gVnKXKWy1Js4-A@mail.gmail.com>
 <20220329231137.GA3357@kbox>
 <CAPhsuW4WH4Hn+DaQZui5au=ueG1G5zGYiOACfKm9imG2kGA+KA@mail.gmail.com>
 <20220330163411.GA1812@kbox>
 <CAADnVQKQw+K2CoCW-nA=bngKtjP495wpB1yhEXNjKg4wSeXAWg@mail.gmail.com>
 <20220330191551.GA2377@kbox>
 <1402984893.199881.1648670246676.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402984893.199881.1648670246676.JavaMail.zimbra@efficios.com>
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 03:57:26PM -0400, Mathieu Desnoyers wrote:
> ----- On Mar 30, 2022, at 3:15 PM, Beau Belgrave beaub@linux.microsoft.com wrote:
> 
> > On Wed, Mar 30, 2022 at 11:22:32AM -0700, Alexei Starovoitov wrote:
> >> On Wed, Mar 30, 2022 at 9:34 AM Beau Belgrave <beaub@linux.microsoft.com> wrote:
> >> > > >
> >> > > > But you are fine with uprobe costs? uprobes appear to be much more costly
> >> > > > than a syscall approach on the hardware I've run on.
> >> 
> >> Care to share the numbers?
> >> uprobe over USDT is a single trap.
> >> Not much slower compared to syscall with kpti.
> >> 
> > 
> > Sure, these are the numbers we have from a production device.
> > 
> > They are captured via perf via PERF_COUNT_HW_CPU_CYCLES.
> > It's running a 20K loop emitting 4 bytes of data out.
> > Each 4 byte event time is recorded via perf.
> > At the end we have the total time and the max seen.
> > 
> > null numbers represent a 20K loop with just perf start/stop ioctl costs.
> > 
> > null: min=2863, avg=2953, max=30815
> > uprobe: min=10994, avg=11376, max=146682
> > uevent: min=7043, avg=7320, max=95396
> > lttng: min=6270, avg=6508, max=41951
> > 
> > These costs include the data getting into a buffer, so they represent
> > what we would see in production vs the trap cost alone. For uprobe this
> > means we created a uprobe and attached it via tracefs to get the above
> > numbers.
> 
> [...]
> 
> I assume here that by "lttng" you specifically refer to lttng-ust (LTTng's
> user-space tracer), am I correct ?
> 

Yes, this is ust.

> By removing the "null" baseline overhead, my rough calculations are that the
> average overhead for lttng-ust in your results is (in cpu cycles):
> 
> 6270-2863 = 3555
> 
> So I'm unsure what is the frequency of your CPU, but guessing around 3.5GHz
> this is in the area of 1 microsecond. On an Intel CPU, this is much larger
> than what I would expect. 
> 
> Can you share your test program, hardware characteristics, kernel version,
> glibc version, and whether the program is compiled as a 32-bit or 64-bit
> binary ?
> 

This is how we are measuring:

#define PERF_START() \
do \
{ \
        ioctl(perf_fd, PERF_EVENT_IOC_RESET, 0); \
	ioctl(perf_fd, PERF_EVENT_IOC_ENABLE, 0); \
} while (0)

#define PERF_END(__cycles) \
do \
{ \
	ioctl(perf_fd, PERF_EVENT_IOC_DISABLE, 0); \
	read(perf_fd, &__cycles, sizeof(__cycles)); \
} while (0)

struct perf_event_attr pe;
long long min, max, total;
int i, perf_fd;

memset(&pe, 0, sizeof(pe));

pe.type = PERF_TYPE_HARDWARE;
pe.size = sizeof(pe);
pe.config = PERF_COUNT_HW_CPU_CYCLES;
pe.disabled = 1;
pe.exclude_hv = 1;

perf_fd = perf_event_open(&pe, 0, -1, -1, 0); 

min = max = total = 0;

for (i = 0; i < 20000; ++i)
{
	long long cycles;

	PERF_START();
	probe();
	PERF_END(cycles);

	if (i == 0 || cycles < min)
		min = cycles;

	if (cycles > max)
		max = cycles;

	total += cycles;
}

probe() here could be a call to writev or to the lttng trace call.

> Can you confirm that lttng-ust is not calling one getcpu system call per
> event ? This might be the case if run a 32-bit x86 binary and have a
> glibc < 2.35, or a kernel too old to provide CONFIG_RSEQ or don't have
> CONFIG_RSEQ=y in your kernel configuration. You can validate this by
> running your lttng-ust test program with a system call tracer.
> 

We don't have CONFIG_RSEQ, so that is likely the cause. LTTng is always
going to be the fastest thing out there. It's pure user mode :)

> Thanks,
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com

Thanks,
-Beau
