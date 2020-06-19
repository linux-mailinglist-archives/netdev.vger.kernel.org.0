Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35DC201DF6
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 00:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbgFSWVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 18:21:11 -0400
Received: from www62.your-server.de ([213.133.104.62]:38464 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728906AbgFSWVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 18:21:11 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jmPNk-0006d4-Go; Sat, 20 Jun 2020 00:21:08 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jmPNk-000NDN-7d; Sat, 20 Jun 2020 00:21:08 +0200
Subject: Re: [PATCH bpf-next 1/2] bpf: switch most helper return values from
 32-bit int to 64-bit long
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
References: <20200617202112.2438062-1-andriin@fb.com>
 <5eeb0e5dcb010_8712abba49be5bc91@john-XPS-13-9370.notmuch>
 <CAEf4BzZi5pMTC9Fq53Mi_mXUm-EQZDyqS_pxEYuGoc0J1ETGUA@mail.gmail.com>
 <5eebb95299a20_6d292ad5e7a285b835@john-XPS-13-9370.notmuch>
 <CAEf4BzZmWO=hO0kmtwkACEfHZm+H7+FZ+5moaLie2=13U3xU=g@mail.gmail.com>
 <5eebf9321e11a_519a2abc9795c5bc21@john-XPS-13-9370.notmuch>
 <5eec09418954e_27ce2adb0816a5b8f7@john-XPS-13-9370.notmuch>
 <45321002-2676-0f5b-c729-5526e503ebd2@iogearbox.net>
 <CAEf4Bzb-nqK0Z=GaWWejriSqqGd6D5Cz_w689N7_51D+daGyvw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <24ac4e42-5831-f698-02f4-5f63d4620f1c@iogearbox.net>
Date:   Sat, 20 Jun 2020 00:21:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4Bzb-nqK0Z=GaWWejriSqqGd6D5Cz_w689N7_51D+daGyvw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25848/Fri Jun 19 15:01:57 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/19/20 8:41 PM, Andrii Nakryiko wrote:
> On Fri, Jun 19, 2020 at 6:08 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 6/19/20 2:39 AM, John Fastabend wrote:
>>> John Fastabend wrote:
>>>> Andrii Nakryiko wrote:
>>>>> On Thu, Jun 18, 2020 at 11:58 AM John Fastabend
>>>>> <john.fastabend@gmail.com> wrote:
>>>
>>> [...]
>>>
>>>>> That would be great. Self-tests do work, but having more testing with
>>>>> real-world application would certainly help as well.
>>>>
>>>> Thanks for all the follow up.
>>>>
>>>> I ran the change through some CI on my side and it passed so I can
>>>> complain about a few shifts here and there or just update my code or
>>>> just not change the return types on my side but I'm convinced its OK
>>>> in most cases and helps in some so...
>>>>
>>>> Acked-by: John Fastabend <john.fastabend@gmail.com>
>>>
>>> I'll follow this up with a few more selftests to capture a couple of our
>>> patterns. These changes are subtle and I worry a bit that additional
>>> <<,s>> pattern could have the potential to break something.
>>>
>>> Another one we didn't discuss that I found in our code base is feeding
>>> the output of a probe_* helper back into the size field (after some
>>> alu ops) of subsequent probe_* call. Unfortunately, the tests I ran
>>> today didn't cover that case.
>>>
>>> I'll put it on the list tomorrow and encode these in selftests. I'll
>>> let the mainainers decide if they want to wait for those or not.
>>
>> Given potential fragility on verifier side, my preference would be that we
>> have the known variations all covered in selftests before moving forward in
>> order to make sure they don't break in any way. Back in [0] I've seen mostly
>> similar cases in the way John mentioned in other projects, iirc, sysdig was
>> another one. If both of you could hack up the remaining cases we need to
>> cover and then submit a combined series, that would be great. I don't think
>> we need to rush this optimization w/o necessary selftests.
> 
> There is no rush, but there is also no reason to delay it. I'd rather
> land it early in the libbpf release cycle and let people try it in
> their prod environments, for those concerned about such code patterns.

Andrii, define 'delay'. John mentioned above to put together few more
selftests today so that there is better coverage at least, why is that
an 'issue'? I'm not sure how you read 'late in release cycle' out of it,
it's still as early. The unsigned optimization for len <= MAX_LEN is
reasonable and makes sense, but it's still one [specific] variant only.

> I don't have a list of all the patterns that we might need to test.
> Going through all open-source BPF source code to identify possible
> patterns and then coding them up in minimal selftests is a bit too
> much for me, honestly.

I think we're probably talking past each other. John wrote above:

 >>> I'll follow this up with a few more selftests to capture a couple of our
 >>> patterns. These changes are subtle and I worry a bit that additional
 >>> <<,s>> pattern could have the potential to break something.

So submitting this as a full series together makes absolutely sense to me,
so there's maybe not perfect but certainly more confidence that also other
patterns where the shifts optimized out in one case are then appearing in
another are tested on a best effort and run our kselftest suite.

Thanks,
Daniel
