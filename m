Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00FE56FD48
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 11:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbiGKJx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 05:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233809AbiGKJxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 05:53:05 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C6A7ADD51;
        Mon, 11 Jul 2022 02:25:26 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9865415BF;
        Mon, 11 Jul 2022 02:25:25 -0700 (PDT)
Received: from [10.57.43.82] (unknown [10.57.43.82])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E3E43F73D;
        Mon, 11 Jul 2022 02:25:22 -0700 (PDT)
Message-ID: <8d282e87-c1c8-f7a0-631b-8d569c2154a6@arm.com>
Date:   Mon, 11 Jul 2022 10:25:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 2/8] perf evsel: Do not request ptrauth sample field if
 not supported
Content-Language: en-US
To:     Vince Weaver <vincent.weaver@maine.edu>,
        Andrew Kilroy <andrew.kilroy@arm.com>
Cc:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Tom Rix <trix@redhat.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, llvm@lists.linux.dev
References: <20220704145333.22557-1-andrew.kilroy@arm.com>
 <20220704145333.22557-3-andrew.kilroy@arm.com>
 <d67dff7-73c3-e5a-eb7b-f132e8f565cc@maine.edu>
From:   James Clark <james.clark@arm.com>
In-Reply-To: <d67dff7-73c3-e5a-eb7b-f132e8f565cc@maine.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06/07/2022 17:01, Vince Weaver wrote:
> On Mon, 4 Jul 2022, Andrew Kilroy wrote:
> 
>> A subsequent patch alters perf to perf_event_open with the
>> PERF_SAMPLE_ARCH_1 bit on.
>>
>> This patch deals with the case where the kernel does not know about the
>> PERF_SAMPLE_ARCH_1 bit, and does not know to send the pointer
>> authentication masks.  In this case the perf_event_open system call
>> returns -EINVAL (-22) and perf exits with an error.
>>
>> This patch causes userspace process to re-attempt the perf_event_open
>> system call but without asking for the PERF_SAMPLE_ARCH_1 sample
>> field, allowing the perf_event_open system call to succeed.
> 
> So in this case you are leaking ARM64-specific info into the generic 
> perf_event_open() call?  Is there any way the kernel could implement this 
> without userspace having to deal with the issue?

Hi Vince,

The alternative to this change is just to call it "PERF_SAMPLE_POINTER_AUTH_MASK"
and then it's not Arm specific, it's just that only Arm implements it for now.
This is definitely an option.

But if no platform ever implements something similar then that bit is wasted.
The intention of adding "PERF_SAMPLE_ARCH_1" was to prevent wasting that bit.
But as you say, maybe making it arch specific isn't the right way either.

I wouldn't say the perf_event_open call is currently generic though, lots of
it already requires knowledge of the current platform, and searching for 'x86'
in the docs for it gives 10 matches.

> 
> There are a few recent ARM64 perf_event related patches that are pushing 
> ARM specific interfaces into the generic code, with the apparent 
> assumption that it will just be implemented in the userspace perf tool.  
> However there are a number of outside-the-kernel codebases that also use 
> perf_event_open() and it seems a bit onerous if all of them have to start 
> adding a lot of extra ARM64-specific code, especially because as far as I 

Because pointer auth is a hardware feature, other tools have no choice but
to implement this if they do Dwarf based stack unwinding. There is no way
around that. The pointers are stored mangled and they don't make sense
without masking them. GDB has already implemented support for it. If they
don't do Dwarf based stack unwinding then they can carry on as they are
and everything will still work.

> can tell there haven't been any documentation patches included for the 
> Makefile.

We plan to update the docs for the syscall, but it's in another repo, and
we'll wait for this change to be finalised first. I'm not sure what you
mean about the Makefile?

Thanks
James

> 
> The other recent change that's annoying for userspace is the addition of 
> the ARM-specific /proc/sys/kernel/perf_user_access that duplicates 
> functionality found in /sys/devices/cpu/rdpmc
> 
> Vince Weaver
> vincent.weaver@maine.edu
