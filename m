Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690741FC182
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 00:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgFPWXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 18:23:39 -0400
Received: from www62.your-server.de ([213.133.104.62]:41756 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725967AbgFPWXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 18:23:38 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jlJzT-0007Kn-Rd; Wed, 17 Jun 2020 00:23:35 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jlJzT-000IMx-Hw; Wed, 17 Jun 2020 00:23:35 +0200
Subject: Re: [PATCH bpf 2/2] selftests/bpf: add variable-length data
 concatenation pattern test
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>,
        Christoph Hellwig <hch@lst.de>
References: <20200616050432.1902042-1-andriin@fb.com>
 <20200616050432.1902042-2-andriin@fb.com>
 <5fed920d-aeb6-c8de-18c0-7c046bbfb242@iogearbox.net>
 <CAEf4BzZQXKBFNqAtadcK6UArfgMDQ--5P0XA1m2f_d8KG6YRtg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dd14f356-44bc-0ff0-a089-ce9fb9936c62@iogearbox.net>
Date:   Wed, 17 Jun 2020 00:23:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZQXKBFNqAtadcK6UArfgMDQ--5P0XA1m2f_d8KG6YRtg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25845/Tue Jun 16 15:01:35 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/16/20 11:27 PM, Andrii Nakryiko wrote:
> On Tue, Jun 16, 2020 at 1:21 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 6/16/20 7:04 AM, Andrii Nakryiko wrote:
>>> Add selftest that validates variable-length data reading and concatentation
>>> with one big shared data array. This is a common pattern in production use for
>>> monitoring and tracing applications, that potentially can read a lot of data,
>>> but usually reads much less. Such pattern allows to determine precisely what
>>> amount of data needs to be sent over perfbuf/ringbuf and maximize efficiency.
>>>
>>> This is the first BPF selftest that at all looks at and tests
>>> bpf_probe_read_str()-like helper's return value, closing a major gap in BPF
>>> testing. It surfaced the problem with bpf_probe_read_kernel_str() returning
>>> 0 on success, instead of amount of bytes successfully read.
>>>
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>
>> Fix looks good, but I'm seeing an issue in the selftest on my side. With latest
>> Clang/LLVM I'm getting:
>>
>> # ./test_progs -t varlen
>> #86 varlen:OK
>> Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
>>
>> All good, however, the test_progs-no_alu32 fails for me with:
> 
> Yeah, same here. It's due to Clang emitting unnecessary bit shifts
> because bpf_probe_read_kernel_str() is defined as returning 32-bit
> int. I have a patch ready locally, just waiting for bpf-next to open,
> which switches those helpers to return long, which auto-matically
> fixes this test.
> 
> If it's not a problem, I'd just wait for that patch to go into
> bpf-next. If not, I can sprinkle bits of assembly magic around to
> force the kernel to do those bitshifts earlier. But I figured having
> test_progs-no_alu32 failing one selftest temporarily wasn't too bad.

Given {net,bpf}-next will open up soon, another option could be to take in the fix
itself to bpf and selftest would be submitted together with your other improvement;
any objections?

Thanks,
Daniel
