Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10E27DEE1C
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 15:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbfJUNmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 09:42:15 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4741 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728891AbfJUNmK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 09:42:10 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 83E32A0E0AAC3DF61A3B;
        Mon, 21 Oct 2019 21:42:07 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.14) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Mon, 21 Oct 2019
 21:42:05 +0800
Subject: Re: [RFC PATCH 1/2] block: add support for redirecting IO completion
 through eBPF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     <linux-block@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Network Development" <netdev@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Alexei Starovoitov" <ast@kernel.org>, <hare@suse.com>,
        <osandov@fb.com>, <ming.lei@redhat.com>, <damien.lemoal@wdc.com>,
        bvanassche <bvanassche@acm.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
References: <20191014122833.64908-1-houtao1@huawei.com>
 <20191014122833.64908-2-houtao1@huawei.com>
 <CAADnVQ+UJK41VL-epYGxrRzqL_UsC+X=J8EXEn2i8P+TPGA_jg@mail.gmail.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <84032c64-8e5e-6ad1-63ea-57adee7a2875@huawei.com>
Date:   Mon, 21 Oct 2019 21:42:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.8.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+UJK41VL-epYGxrRzqL_UsC+X=J8EXEn2i8P+TPGA_jg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.31.14]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2019/10/16 5:04, Alexei Starovoitov wrote:
> On Mon, Oct 14, 2019 at 5:21 AM Hou Tao <houtao1@huawei.com> wrote:
>>
>> For network stack, RPS, namely Receive Packet Steering, is used to
>> distribute network protocol processing from hardware-interrupted CPU
>> to specific CPUs and alleviating soft-irq load of the interrupted CPU.
>>
>> For block layer, soft-irq (for single queue device) or hard-irq
>> (for multiple queue device) is used to handle IO completion, so
>> RPS will be useful when the soft-irq load or the hard-irq load
>> of a specific CPU is too high, or a specific CPU set is required
>> to handle IO completion.
>>
>> Instead of setting the CPU set used for handling IO completion
>> through sysfs or procfs, we can attach an eBPF program to the
>> request-queue, provide some useful info (e.g., the CPU
>> which submits the request) to the program, and let the program
>> decides the proper CPU for IO completion handling.
>>
>> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ...
>>
>> +       rcu_read_lock();
>> +       prog = rcu_dereference_protected(q->prog, 1);
>> +       if (prog)
>> +               bpf_ccpu = BPF_PROG_RUN(q->prog, NULL);
>> +       rcu_read_unlock();
>> +
>>         cpu = get_cpu();
>> -       if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags))
>> -               shared = cpus_share_cache(cpu, ctx->cpu);
>> +       if (bpf_ccpu < 0 || !cpu_online(bpf_ccpu)) {
>> +               ccpu = ctx->cpu;
>> +               if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags))
>> +                       shared = cpus_share_cache(cpu, ctx->cpu);
>> +       } else
>> +               ccpu = bpf_ccpu;
>>
>> -       if (cpu != ctx->cpu && !shared && cpu_online(ctx->cpu)) {
>> +       if (cpu != ccpu && !shared && cpu_online(ccpu)) {
>>                 rq->csd.func = __blk_mq_complete_request_remote;
>>                 rq->csd.info = rq;
>>                 rq->csd.flags = 0;
>> -               smp_call_function_single_async(ctx->cpu, &rq->csd);
>> +               smp_call_function_single_async(ccpu, &rq->csd);
> 
> Interesting idea.
> Not sure whether such programability makes sense from
> block layer point of view.
> 
>>From bpf side having a program with NULL input context is
> a bit odd. We never had such things in the past, so this patchset
> won't work as-is.
No, it just works.

> Also no-input means that the program choices are quite limited.
> Other than round robin and random I cannot come up with other
> cpu selection idea> I suggest to do writable tracepoint here instead.
> Take a look at trace_nbd_send_request.
> BPF prog can write into 'request'.
> For your use case it will be able to write into 'bpf_ccpu' local variable.
> If you keep it as raw tracepoint and don't add the actual tracepoint
> with TP_STRUCT__entry and TP_fast_assign then it won't be abi
> and you can change it later or remove it altogether.
> 
Your suggestion is much simpler, so there will be no need for adding a new
program type, and all things need to be done are adding a raw tracepoint,
moving bpf_ccpu into struct request, and letting a BPF program to modify it.

I will try and thanks for your suggestions.

Regards,
Tao

> .
> 

