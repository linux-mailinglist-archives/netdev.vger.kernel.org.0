Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8963B12979B
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 15:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfLWOjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 09:39:49 -0500
Received: from www62.your-server.de ([213.133.104.62]:41776 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbfLWOjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 09:39:48 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ijOs2-0006DU-Ro; Mon, 23 Dec 2019 15:39:42 +0100
Received: from [185.105.41.126] (helo=linux-9.fritz.box)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ijOs2-000Dco-CN; Mon, 23 Dec 2019 15:39:42 +0100
Subject: Re: [PATCH bpf v3] libbpf: Fix build on read-only filesystems
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-perf-users@vger.kernel.org
References: <CAM9d7ch1=pmgkFbgGr2YignQwdNjke2QeOAFLCFYu8L8J-Z8vw@mail.gmail.com>
 <20191223061326.843366-1-namhyung@kernel.org>
 <CAEf4BzY1HvhkPzR1HE7-reGhfZnfySe-LxQ-5MS7Nx-Uv4oVug@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2d6767c6-ff4c-8f88-f186-23cddbb4969a@iogearbox.net>
Date:   Mon, 23 Dec 2019 15:39:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzY1HvhkPzR1HE7-reGhfZnfySe-LxQ-5MS7Nx-Uv4oVug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25672/Mon Dec 23 10:53:10 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/23/19 7:29 AM, Andrii Nakryiko wrote:
> On Sun, Dec 22, 2019 at 10:14 PM Namhyung Kim <namhyung@kernel.org> wrote:
>>
>> I got the following error when I tried to build perf on a read-only
>> filesystem with O=dir option.
>>
>>    $ cd /some/where/ro/linux/tools/perf
>>    $ make O=$HOME/build/perf
>>    ...
>>      CC       /home/namhyung/build/perf/lib.o
>>    /bin/sh: bpf_helper_defs.h: Read-only file system
>>    make[3]: *** [Makefile:184: bpf_helper_defs.h] Error 1
>>    make[2]: *** [Makefile.perf:778: /home/namhyung/build/perf/libbpf.a] Error 2
>>    make[2]: *** Waiting for unfinished jobs....
>>      LD       /home/namhyung/build/perf/libperf-in.o
>>      AR       /home/namhyung/build/perf/libperf.a
>>      PERF_VERSION = 5.4.0
>>    make[1]: *** [Makefile.perf:225: sub-make] Error 2
>>    make: *** [Makefile:70: all] Error 2
>>
>> It was becaused bpf_helper_defs.h was generated in current directory.
>> Move it to OUTPUT directory.
>>
>> Tested-by: Andrii Nakryiko <andriin@fb.com>
>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>   tools/lib/bpf/Makefile                 | 15 ++++++++-------
>>   tools/testing/selftests/bpf/.gitignore |  1 +
>>   tools/testing/selftests/bpf/Makefile   |  6 +++---
>>   3 files changed, 12 insertions(+), 10 deletions(-)
>>
> 
> [...]
> 
>> diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
>> index 419652458da4..1ff0a9f49c01 100644
>> --- a/tools/testing/selftests/bpf/.gitignore
>> +++ b/tools/testing/selftests/bpf/.gitignore
>> @@ -40,3 +40,4 @@ xdping
>>   test_cpp
>>   /no_alu32
>>   /bpf_gcc
>> +bpf_helper_defs.h
> 
> looks good, thanks!

Applied, thanks!
