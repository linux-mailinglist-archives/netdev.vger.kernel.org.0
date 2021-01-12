Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778DB2F3D73
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406746AbhALVgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:36:52 -0500
Received: from www62.your-server.de ([213.133.104.62]:53260 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436792AbhALUSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 15:18:16 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kzQ6b-0006a9-Dd; Tue, 12 Jan 2021 21:17:29 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kzQ6b-000KJk-7W; Tue, 12 Jan 2021 21:17:29 +0100
Subject: Re: [PATCH bpf 2/2] libbpf: allow loading empty BTFs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>,
        Christopher William Snowhill <chris@kode54.net>
References: <20210110070341.1380086-1-andrii@kernel.org>
 <20210110070341.1380086-2-andrii@kernel.org>
 <e621981d-5c3d-6d92-871b-a98520778363@fb.com>
 <CAEf4BzZhFrHho-F+JyY6wQyWUZ+0cJJLkGv+=DHP4equkkm4iw@mail.gmail.com>
 <31ebd16f-8218-1457-b4e2-3728ab147747@fb.com>
 <CAEf4BzY0xwwH+yD3dvjSjDG1t_w4ktAeo_gM6WQWw676TghJpQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <717c1c8c-4194-0605-3aa3-eb33fdc17711@iogearbox.net>
Date:   Tue, 12 Jan 2021 21:17:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzY0xwwH+yD3dvjSjDG1t_w4ktAeo_gM6WQWw676TghJpQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26047/Tue Jan 12 13:33:56 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/12/21 7:41 AM, Andrii Nakryiko wrote:
> On Mon, Jan 11, 2021 at 5:16 PM Yonghong Song <yhs@fb.com> wrote:
>> On 1/11/21 12:51 PM, Andrii Nakryiko wrote:
>>> On Mon, Jan 11, 2021 at 10:13 AM Yonghong Song <yhs@fb.com> wrote:
>>>> On 1/9/21 11:03 PM, Andrii Nakryiko wrote:
>>>>> Empty BTFs do come up (e.g., simple kernel modules with no new types and
>>>>> strings, compared to the vmlinux BTF) and there is nothing technically wrong
>>>>> with them. So remove unnecessary check preventing loading empty BTFs.
>>>>>
>>>>> Reported-by: Christopher William Snowhill <chris@kode54.net>
>>>>> Fixes: ("d8123624506c libbpf: Fix BTF data layout checks and allow empty BTF")

Fixed up Fixes tag ^^^^^ while applying. ;-)

>>>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>>>>> ---
>>>>>     tools/lib/bpf/btf.c | 5 -----
>>>>>     1 file changed, 5 deletions(-)
>>>>>
>>>>> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
>>>>> index 3c3f2bc6c652..9970a288dda5 100644
>>>>> --- a/tools/lib/bpf/btf.c
>>>>> +++ b/tools/lib/bpf/btf.c
>>>>> @@ -240,11 +240,6 @@ static int btf_parse_hdr(struct btf *btf)
>>>>>         }
>>>>>
>>>>>         meta_left = btf->raw_size - sizeof(*hdr);
>>>>> -     if (!meta_left) {
>>>>> -             pr_debug("BTF has no data\n");
>>>>> -             return -EINVAL;
>>>>> -     }
>>>>
>>>> Previous kernel patch allows empty btf only if that btf is module (not
>>>> base/vmlinux) btf. Here it seems we allow any empty non-module btf to be
>>>> loaded into the kernel. In such cases, loading may fail? Maybe we should
>>>> detect such cases in libbpf and error out instead of going to kernel and
>>>> get error back?
>>>
>>> I did this consciously. Kernel is more strict, because there is no
>>> reasonable case when vmlinux BTF or BPF program's BTF can be empty (at
>>> least not that now we have FUNCs in BTF). But allowing libbpf to load
>>> empty BTF generically is helpful for bpftool, as one example, for
>>> inspection. If you do `bpftool btf dump` on empty BTF, it will just
>>> print nothing and you'll know that it's a valid (from BTF header
>>> perspective) BTF, just doesn't have any types (besides VOID). If we
>>> don't allow it, then we'll just get an error and then you'll have to
>>> do painful hex dumping and decoding to see what's wrong.
>>
>> It is totally okay to allow empty btf in libbpf. I just want to check
>> if this btf is going to be loaded into the kernel, right before it is
>> loading whether libbpf could check whether it is a non-module empty btf
>> or not, if it is, do not go to kernel.
> 
> Ok, I see what you are proposing. We can do that, but it's definitely
> separate from these bug fixes. But, to be honest, I wouldn't bother
> because libbpf will return BTF verification log with a very readable
> "No data" message in it.

Right, seems okay to me for this particular case given the user will be
able to make some sense of it from the log.

Thanks,
Daniel
