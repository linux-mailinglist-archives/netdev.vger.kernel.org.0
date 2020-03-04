Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89E931793B1
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 16:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729536AbgCDPiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 10:38:08 -0500
Received: from www62.your-server.de ([213.133.104.62]:41454 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgCDPiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 10:38:08 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j9W5y-0007cP-BH; Wed, 04 Mar 2020 16:38:02 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux.fritz.box)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j9W5y-0002AM-0p; Wed, 04 Mar 2020 16:38:02 +0100
Subject: Re: [PATCH v3 bpf-next 1/3] bpf: switch BPF UAPI #define constants
 used from BPF program side to enums
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
References: <20200303003233.3496043-1-andriin@fb.com>
 <20200303003233.3496043-2-andriin@fb.com>
 <fb80ddac-d104-d0b7-8bed-694d20b62d61@iogearbox.net>
 <CAEf4BzZWXRX_TrFSPb=ORcfun8B+GdGOAF6C29B-3xB=NaJO7A@mail.gmail.com>
 <87blpc4g14.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <945cf1c4-78bb-8d3c-10e3-273d100ce41c@iogearbox.net>
Date:   Wed, 4 Mar 2020 16:38:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87blpc4g14.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25741/Wed Mar  4 15:15:26 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/20 10:37 AM, Toke Høiland-Jørgensen wrote:
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>> On Tue, Mar 3, 2020 at 3:01 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>
>>> On 3/3/20 1:32 AM, Andrii Nakryiko wrote:
>>>> Switch BPF UAPI constants, previously defined as #define macro, to anonymous
>>>> enum values. This preserves constants values and behavior in expressions, but
>>>> has added advantaged of being captured as part of DWARF and, subsequently, BTF
>>>> type info. Which, in turn, greatly improves usefulness of generated vmlinux.h
>>>> for BPF applications, as it will not require BPF users to copy/paste various
>>>> flags and constants, which are frequently used with BPF helpers. Only those
>>>> constants that are used/useful from BPF program side are converted.
>>>>
>>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>>
>>> Just thinking out loud, is there some way this could be resolved generically
>>> either from compiler side or via additional tooling where this ends up as BTF
>>> data and thus inside vmlinux.h as anon enum eventually? bpf.h is one single
>>> header and worst case libbpf could also ship a copy of it (?), but what about
>>> all the other things one would need to redefine e.g. for tracing? Small example
>>> that comes to mind are all these TASK_* defines in sched.h etc, and there's
>>> probably dozens of other similar stuff needed too depending on the particular
>>> case; would be nice to have some generic catch-all, hmm.
>>
>> Enum convertion seems to be the simplest and cleanest way,
>> unfortunately (as far as I know). DWARF has some extensions capturing
>> #defines, but values are strings (and need to be parsed, which is pain
>> already for "1 << 1ULL"), and it's some obscure extension, not a
>> standard thing. I agree would be nice not to have and change all UAPI
>> headers for this, but I'm not aware of the solution like that.
> 
> Since this is a UAPI header, are we sure that no userspace programs are
> using these defines in #ifdefs or something like that?

Hm, yes, anyone doing #ifdefs on them would get build issues. Simple example:

enum {
         FOO = 42,
//#define FOO   FOO
};

#ifndef FOO
# warning "bar"
#endif

int main(int argc, char **argv)
{
         return FOO;
}

$ gcc -Wall -O2 foo.c
foo.c:7:3: warning: #warning "bar" [-Wcpp]
     7 | # warning "bar"
       |   ^~~~~~~

Commenting #define FOO FOO back in fixes it as we discussed in v2:

$ gcc -Wall -O2 foo.c
$

There's also a flag_enum attribute, but with the experiments I tried yesterday
night I couldn't get a warning to trigger for anonymous enums at least, so that
part should be ok.

I was about to push the series out, but agree that there may be a risk for #ifndefs
in the BPF C code. If we want to be on safe side, #define FOO FOO would be needed.

Thanks,
Daniel
