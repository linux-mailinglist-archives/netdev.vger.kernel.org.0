Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F13D122C6E
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 14:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfLQNAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 08:00:14 -0500
Received: from www62.your-server.de ([213.133.104.62]:44582 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbfLQNAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 08:00:14 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ihCSR-00016t-Ig; Tue, 17 Dec 2019 14:00:11 +0100
Received: from [178.197.249.31] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1ihCSR-0002ZD-82; Tue, 17 Dec 2019 14:00:11 +0100
Subject: Re: [PATCH bpf-next 0/4] Fix perf_buffer creation on systems with
 offline CPUs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
References: <20191212013521.1689228-1-andriin@fb.com>
 <20191216144404.GG14887@linux.fritz.box>
 <CAEf4BzYhmFvhL_DgeXK8xxihcxcguRzox2AXpjBS1BB4n9d7rQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dfb31c60-3c8c-94a2-5302-569096428e9b@iogearbox.net>
Date:   Tue, 17 Dec 2019 14:00:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYhmFvhL_DgeXK8xxihcxcguRzox2AXpjBS1BB4n9d7rQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25666/Tue Dec 17 10:54:52 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/16/19 6:59 PM, Andrii Nakryiko wrote:
> On Mon, Dec 16, 2019 at 6:44 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On Wed, Dec 11, 2019 at 05:35:20PM -0800, Andrii Nakryiko wrote:
>>> This patch set fixes perf_buffer__new() behavior on systems which have some of
>>> the CPUs offline/missing (due to difference between "possible" and "online"
>>> sets). perf_buffer will create per-CPU buffer and open/attach to corresponding
>>> perf_event only on CPUs present and online at the moment of perf_buffer
>>> creation. Without this logic, perf_buffer creation has no chances of
>>> succeeding on such systems, preventing valid and correct BPF applications from
>>> starting.
>>
>> Once CPU goes back online and processes BPF events, any attempt to push into
>> perf RB via bpf_perf_event_output() with flag BPF_F_CURRENT_CPU would silently
> 
> bpf_perf_event_output() will return error code in such case, so it's
> not exactly undetectable by application.

Yeah, true, given there would be no element in the perf map at that slot, the
program would receive -ENOENT and we could account for missed events via per
CPU map or such.

>> get discarded. Should rather perf API be fixed instead of plain skipping as done
>> here to at least allow creation of ring buffer for BPF to avoid such case?
> 
> Can you elaborate on what perf API fix you have in mind? Do you mean
> for perf to allow attaching ring buffer to offline CPU or something
> else?

Yes, was wondering about the former, meaning, possibility to attach ring buffer
to offline CPU.

>>> Andrii Nakryiko (4):
>>>    libbpf: extract and generalize CPU mask parsing logic
>>>    selftests/bpf: add CPU mask parsing tests
>>>    libbpf: don't attach perf_buffer to offline/missing CPUs
>>>    selftests/bpf: fix perf_buffer test on systems w/ offline CPUs
>>>
>>>   tools/lib/bpf/libbpf.c                        | 157 ++++++++++++------
>>>   tools/lib/bpf/libbpf_internal.h               |   2 +
>>>   .../selftests/bpf/prog_tests/cpu_mask.c       |  78 +++++++++
>>>   .../selftests/bpf/prog_tests/perf_buffer.c    |  29 +++-
>>>   4 files changed, 213 insertions(+), 53 deletions(-)
>>>   create mode 100644 tools/testing/selftests/bpf/prog_tests/cpu_mask.c
>>>
>>> --
>>> 2.17.1
>>>

