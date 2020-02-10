Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38227158635
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 00:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbgBJXiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 18:38:51 -0500
Received: from www62.your-server.de ([213.133.104.62]:51448 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727452AbgBJXiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 18:38:51 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j1Idc-0000X3-CO; Tue, 11 Feb 2020 00:38:48 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j1Idc-0005Xx-2k; Tue, 11 Feb 2020 00:38:48 +0100
Subject: Re: [PATCH bpf 3/3] selftests/bpf: Test freeing sockmap/sockhash with
 a socket in it
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
References: <20200206111652.694507-1-jakub@cloudflare.com>
 <20200206111652.694507-4-jakub@cloudflare.com>
 <CAADnVQJU4RtAAMH0pL9AQSXDgHGcXOqm15EKZw10c=r-f=bfuw@mail.gmail.com>
 <87eev3aidz.fsf@cloudflare.com>
 <5e40d43715474_2a9a2abf5f7f85c025@john-XPS-13-9370.notmuch>
 <87blq6accb.fsf@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4c35444b-5354-8e45-ca01-ac8d9b389dad@iogearbox.net>
Date:   Tue, 11 Feb 2020 00:38:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87blq6accb.fsf@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.1/25720/Mon Feb 10 12:53:41 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/20 12:52 PM, Jakub Sitnicki wrote:
> On Mon, Feb 10, 2020 at 03:55 AM GMT, John Fastabend wrote:
>> Jakub Sitnicki wrote:
>>> On Sun, Feb 09, 2020 at 03:41 AM CET, Alexei Starovoitov wrote:
>>>> On Thu, Feb 6, 2020 at 3:28 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>>>>
>>>>> Commit 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear
>>>>> down") introduced sleeping issues inside RCU critical sections and while
>>>>> holding a spinlock on sockmap/sockhash tear-down. There has to be at least
>>>>> one socket in the map for the problem to surface.
>>>>>
>>>>> This adds a test that triggers the warnings for broken locking rules. Not a
>>>>> fix per se, but rather tooling to verify the accompanying fixes. Run on a
>>>>> VM with 1 vCPU to reproduce the warnings.
>>>>>
>>>>> Fixes: 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear down")
>>>>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>>>>
>>>> selftests/bpf no longer builds for me.
>>>> make
>>>>    BINARY   test_maps
>>>>    TEST-OBJ [test_progs] sockmap_basic.test.o
>>>> /data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:
>>>> In function ‘connected_socket_v4’:
>>>> /data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:20:11:
>>>> error: ‘TCP_REPAIR_ON’ undeclared (first use in this function); did
>>>> you mean ‘TCP_REPAIR’?
>>>>     20 |  repair = TCP_REPAIR_ON;
>>>>        |           ^~~~~~~~~~~~~
>>>>        |           TCP_REPAIR
>>>> /data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:20:11:
>>>> note: each undeclared identifier is reported only once for each
>>>> function it appears in
>>>> /data/users/ast/net/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c:29:11:
>>>> error: ‘TCP_REPAIR_OFF_NO_WP’ undeclared (first use in this function);
>>>> did you mean ‘TCP_REPAIR_OPTIONS’?
>>>>     29 |  repair = TCP_REPAIR_OFF_NO_WP;
>>>>        |           ^~~~~~~~~~~~~~~~~~~~
>>>>        |           TCP_REPAIR_OPTIONS
>>>>
>>>> Clearly /usr/include/linux/tcp.h is too old.
>>>> Suggestions?
>>>
>>> Sorry for the inconvenience. I see that tcp.h header is missing under
>>> linux/tools/include/uapi/.
>>
>> How about we just add the couple defines needed to sockmap_basic.c I don't
>> see a need to pull in all of tcp.h just for a couple defines that wont
>> change anyways.
> 
> Looking back at how this happened. test_progs.h pulls in netinet/tcp.h:
> 
> # 19 "/home/jkbs/src/linux/tools/testing/selftests/bpf/test_progs.h" 2
> # 1 "/usr/include/netinet/tcp.h" 1 3 4
> # 92 "/usr/include/netinet/tcp.h" 3 4
> 
> A glibc header, which gained TCP_REPAIR_* constants in 2.29 [0]:
> 
> $ git describe --contains 5cd7dbdea13eb302620491ef44837b17e9d39c5a
> glibc-2.29~510
> 
> Pulling in linux/tcp.h would conflict with struct definitions in
> netinet/tcp.h. So redefining the possibly missing constants, like John
> suggests, is the right way out.
> 
> I'm not sure, though, how to protect against such mistakes in the
> future. Any ideas?

We've usually been pulling in header copies into tools/include/. Last bigger one
was in commit 13a748ea6df1 ("bpf: Sync asm-generic/socket.h to tools/") to name
one example, but redefining the way John did for smaller things is also okay,
especially if a header has further dependencies which would then also be needed
under tools/ infra.

> [0] https://sourceware.org/git/?p=glibc.git;a=commit;h=5cd7dbdea13eb302620491ef44837b17e9d39c5a
