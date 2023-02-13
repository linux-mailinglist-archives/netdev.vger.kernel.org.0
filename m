Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91380694E53
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 18:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjBMRqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 12:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjBMRqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 12:46:12 -0500
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA4A1CF6B;
        Mon, 13 Feb 2023 09:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1676310367;
        bh=bjIdrq7E7T3M1MvC4x5lbyHOfWJfEa4UUs+f0ZSzvLo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=kVzPuTIfA2sXNFdhJk/1b1s4uKm8ICG0Z1j0EkuKl4Ak+n+7mXGMI0tGuEJpz9ykd
         m4Yis8VvRX5n3+GHp68aG95M/4efD4oisZWmO5zdDix6w6HfjYkF4Un0Feyh3xUoXQ
         GLilc1pSgwz1NLkZxrDmTVH6UGcB0xDduN3+j2hpKaBWGRrkjaovRMUaWA8TLqqDvX
         vUWMFLkqTk/HMmrVArZxP9mMuWp2AZiSVbMGUsvWZ8puZ28ciZOCgpGwAMQeSWCbCK
         6IcjlC1j9XiM6XrJJpHJqQSEwhThnTbRUr2gV9kFAwfxKTUikdRvhGV1jmSYeBzqVw
         JHSbLcylDKTSw==
Received: from [172.16.0.188] (192-222-180-24.qc.cable.ebox.net [192.222.180.24])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4PFsFp6TdfzlHF;
        Mon, 13 Feb 2023 12:46:06 -0500 (EST)
Message-ID: <52a9f138-45f0-ca05-b67a-d734663984df@efficios.com>
Date:   Mon, 13 Feb 2023 12:46:06 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 7/7] tools/testing/selftests/bpf: replace open-coded 16
 with TASK_COMM_LEN
Content-Language: en-US
To:     Namhyung Kim <namhyung@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Yafang Shao <laoar.shao@gmail.com>,
        John Stultz <jstultz@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>,
        Kajetan Puchalski <kajetan.puchalski@arm.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Qais Yousef <qyousef@google.com>,
        Daniele Di Proietto <ddiproietto@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20211120112738.45980-1-laoar.shao@gmail.com>
 <20211120112738.45980-8-laoar.shao@gmail.com> <Y+QaZtz55LIirsUO@google.com>
 <CAADnVQ+nf8MmRWP+naWwZEKBFOYr7QkZugETgAVfjKcEVxmOtg@mail.gmail.com>
 <CANDhNCo_=Q3pWc7h=ruGyHdRVGpsMKRY=C2AtZgLDwtGzRz8Kw@mail.gmail.com>
 <20230208212858.477cd05e@gandalf.local.home>
 <20230208213343.40ee15a5@gandalf.local.home>
 <20230211140011.4f15a633@gandalf.local.home>
 <CALOAHbAnFHAiMH4QDgS6xN16B31qfhG8tfQ+iioCr9pw3sP=bw@mail.gmail.com>
 <20230211224455.0a4b2914@gandalf.local.home>
 <CAM9d7chx+azdxfNVVtaC_8eM2a57aBFa3hjh0TvjFt-6Xc7r7w@mail.gmail.com>
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <CAM9d7chx+azdxfNVVtaC_8eM2a57aBFa3hjh0TvjFt-6Xc7r7w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023-02-13 12:43, Namhyung Kim wrote:
> Hi Steve,
> 
> On Sat, Feb 11, 2023 at 8:07 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>> On Sun, 12 Feb 2023 11:38:52 +0800
>> Yafang Shao <laoar.shao@gmail.com> wrote:
>>
>>>> Actually, there are cases that this needs to be a number, as b3bc8547d3be6
>>>> ("tracing: Have TRACE_DEFINE_ENUM affect trace event types as well") made
>>>> it update fields as well as the printk fmt.
>>>>
>>>
>>> It seems that TRACE_DEFINE_ENUM(TASK_COMM_LEN) in the trace events
>>> header files would be a better fix.
>>
>> NACK! I much prefer the proper fix that adds the length.
> 
> Can we just have both enum and macro at the same time?
> I guess the enum would fill the BTF and the macro would provide
> backward compatibility.

This is no need to keep the define. The root cause of the issue is 
addressed by this fix:

https://lore.kernel.org/lkml/20230212154620.4d8fe033@gandalf.local.home/

Thanks,

Mathieu

> 
> Thanks,
> Namhyung

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

