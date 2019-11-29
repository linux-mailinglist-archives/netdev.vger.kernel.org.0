Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9EF110DBE7
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 01:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfK3AM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 19:12:58 -0500
Received: from www62.your-server.de ([213.133.104.62]:43690 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbfK3AM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 19:12:58 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iaq82-0002ph-Pq; Sat, 30 Nov 2019 00:56:50 +0100
Received: from [178.197.249.29] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iaq82-000WjV-90; Sat, 30 Nov 2019 00:56:50 +0100
Subject: Re: [PATCH bpf v3] bpftool: Allow to link libbpf dynamically
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>, kubakici@wp.pl
References: <20191128160712.1048793-1-toke@redhat.com>
 <f6e8f6d2-6155-3b20-9975-81e29e460915@iogearbox.net> <87a78evl2v.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9853054b-dc1f-35ba-ba3c-4d0ab01c8f14@iogearbox.net>
Date:   Sat, 30 Nov 2019 00:56:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87a78evl2v.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25648/Fri Nov 29 10:44:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/29/19 3:00 PM, Toke Høiland-Jørgensen wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
>> On 11/28/19 5:07 PM, Toke Høiland-Jørgensen wrote:
>>> From: Jiri Olsa <jolsa@kernel.org>
[...]
>>>    ifeq ($(srctree),)
>>>    srctree := $(patsubst %/,%,$(dir $(CURDIR)))
>>> @@ -63,6 +72,19 @@ RM ?= rm -f
>>>    FEATURE_USER = .bpftool
>>>    FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib
>>>    FEATURE_DISPLAY = libbfd disassembler-four-args zlib
>>> +ifdef LIBBPF_DYNAMIC
>>> +  FEATURE_TESTS   += libbpf
>>> +  FEATURE_DISPLAY += libbpf
>>> +
>>> +  # for linking with debug library run:
>>> +  # make LIBBPF_DYNAMIC=1 LIBBPF_DIR=/opt/libbpf
>>
>> The Makefile already has BPF_DIR which points right now to
>> '$(srctree)/tools/lib/bpf/' and LIBBPF_PATH for the final one and
>> where $(LIBBPF_PATH)libbpf.a is expected to reside. Can't we improve
>> the Makefile to reuse and work with these instead of adding yet
>> another LIBBPF_DIR var which makes future changes in this area more
>> confusing? The libbpf build spills out libbpf.{a,so*} by default
>> anyway.
> 
> I see what you mean; however, LIBBPF_DIR is meant to be specifically an
> override for the dynamic library, not just the path to libbpf.
> 
> Would it be less confusing to overload the LIBBPF_DYNAMIC variable
> instead? I.e.,
> 
> make LIBBPF_DYNAMIC=1
> 
> would dynamically link against the libbpf installed in the system, but
> 
> make LIBBPF_DYNAMIC=/opt/libbpf
> 
> would override that and link against whatever is in /opt/libbpf instead?
> WDYT?

Hm, given perf tool has similar LIB*_DIR vars in place for its libs, it probably
makes sense to stick with this convention as well then. Perhaps better in this
case to just rename s/BPF_DIR/BPF_SRC_DIR/, s/LIBBPF_OUTPUT/LIBBPF_BUILD_OUTPUT/,
and s/LIBBPF_PATH/LIBBPF_BUILD_PATH/ to make their purpose more clear.

One thing that would be good to do as well for this patch is to:

  i) Document both LIBBPF_DYNAMIC and LIBBPF_DIR in the Makefile comment you
     added at the top along with a simple usage example.

ii) Extend tools/testing/selftests/bpf/test_bpftool_build.sh with a dynamic
     linking test case, e.g. building libbpf into a temp dir and pointing
     LIBBPF_DIR to it for bpftool LIBBPF_DYNAMIC=1 build.

Thanks,
Daniel
