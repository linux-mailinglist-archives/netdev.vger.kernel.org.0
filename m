Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 587F710BCA3
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 22:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731772AbfK0VWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 16:22:38 -0500
Received: from www62.your-server.de ([213.133.104.62]:59214 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfK0VWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 16:22:37 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ia4ld-00023l-3D; Wed, 27 Nov 2019 22:22:33 +0100
Received: from [178.197.248.11] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1ia4lc-000N2Z-Gw; Wed, 27 Nov 2019 22:22:32 +0100
Subject: Re: [PATCH 0/3] perf/bpftool: Allow to link libbpf dynamically
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
References: <20191127094837.4045-1-jolsa@kernel.org>
 <CAADnVQLp2VTi9JhtfkLOR9Y1ipNFObOGH9DQe5zbKxz77juhqA@mail.gmail.com>
 <CAEf4BzaDxnF0Ppfo5r5ma3ht033bWjQ78oiBzB=F40_Np=AKhw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <14accea8-a35f-5be3-607c-f5e1e7dff310@iogearbox.net>
Date:   Wed, 27 Nov 2019 22:22:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzaDxnF0Ppfo5r5ma3ht033bWjQ78oiBzB=F40_Np=AKhw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25646/Wed Nov 27 11:06:44 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/27/19 9:24 PM, Andrii Nakryiko wrote:
> On Wed, Nov 27, 2019 at 8:38 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>> On Wed, Nov 27, 2019 at 1:48 AM Jiri Olsa <jolsa@kernel.org> wrote:
>>>
>>> hi,
>>> adding support to link bpftool with libbpf dynamically,
>>> and config change for perf.
>>>
>>> It's now possible to use:
>>>    $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=1
>>>
>>> which will detect libbpf devel package with needed version,
>>> and if found, link it with bpftool.
>>>
>>> It's possible to use arbitrary installed libbpf:
>>>    $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=1 LIBBPF_DIR=/tmp/libbpf/
>>>
>>> I based this change on top of Arnaldo's perf/core, because
>>> it contains libbpf feature detection code as dependency.
>>> It's now also synced with latest bpf-next, so Toke's change
>>> applies correctly.
>>
>> I don't like it.
>> Especially Toke's patch to expose netlink as public and stable libbpf api.
>> bpftools needs to stay tightly coupled with libbpf (and statically
>> linked for that reason).
>> Otherwise libbpf will grow a ton of public api that would have to be stable
>> and will quickly become a burden.

+1, and would also be out of scope from a BPF library point of view.

> I second that. I'm currently working on adding few more APIs that I'd
> like to keep unstable for a while, until we have enough real-world
> usage (and feedback) accumulated, before we stabilize them. With
> LIBBPF_API and a promise of stable API, we are going to over-stress
> and over-design APIs, potentially making them either too generic and
> bloated, or too limited (and thus become deprecated almost at
> inception time). I'd like to take that pressure off for a super-new
> and in flux APIs and not hamper the progress.
> 
> I'm thinking of splitting off those non-stable, sort-of-internal APIs
> into separate libbpf-experimental.h (or whatever name makes sense),
> and let those be used only by tools like bpftool, which are only ever
> statically link against libbpf and are ok with occasional changes to
> those APIs (which we'll obviously fix in bpftool as well). Pahole
> seems like another candidate that fits this bill and we might expose
> some stuff early on to it, if it provides tangible benefits (e.g., BTF
> dedup speeds ups, etc).
> 
> Then as APIs mature, we might decide to move them into libbpf.h with
> LIBBPF_API slapped onto them. Any objections?

I don't think adding yet another libbpf_experimental.h makes sense, it feels
too much of an invitation to add all sort of random stuff in there. We already
do have libbpf.h and libbpf_internal.h, so everything that does not relate to
the /stable and public/ API should be moved from libbpf.h into libbpf_internal.h
such as the netlink helpers, as one example, and bpftool can use these since
in-tree changes also cover the latter just fine. So overall, same page, just
reuse/improve libbpf_internal.h instead of a new libbpf_experimental.h.

Thanks,
Daniel
