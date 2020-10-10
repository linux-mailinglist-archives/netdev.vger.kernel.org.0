Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A23289CA5
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 02:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbgJJAQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 20:16:46 -0400
Received: from www62.your-server.de ([213.133.104.62]:44950 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728706AbgJJALX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 20:11:23 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kR2TS-0007rQ-JC; Sat, 10 Oct 2020 02:10:58 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kR2TS-000PQ3-D9; Sat, 10 Oct 2020 02:10:58 +0200
Subject: Re: [PATCH bpf-next v4 3/6] bpf: allow for map-in-map with dynamic
 inner array map entries
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20201009224007.30447-1-daniel@iogearbox.net>
 <20201009224007.30447-4-daniel@iogearbox.net>
 <CAEf4BzYHRi3zBWcVYo=1oB2mcWaW_7HmKsSw6X2PU1deyXXaDw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f89ec10b-c0b8-8449-f820-730026ca0f3a@iogearbox.net>
Date:   Sat, 10 Oct 2020 02:10:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYHRi3zBWcVYo=1oB2mcWaW_7HmKsSw6X2PU1deyXXaDw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25952/Fri Oct  9 15:52:40 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/10/20 1:01 AM, Andrii Nakryiko wrote:
> On Fri, Oct 9, 2020 at 3:40 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
[...]
>>          *insn++ = BPF_ALU64_IMM(BPF_ADD, map_ptr, offsetof(struct bpf_array, value));
>>          *insn++ = BPF_LDX_MEM(BPF_W, ret, index, 0);
>>          if (!map->bypass_spec_v1) {
>> @@ -496,8 +499,10 @@ static int array_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
>>   static bool array_map_meta_equal(const struct bpf_map *meta0,
>>                                   const struct bpf_map *meta1)
>>   {
>> -       return meta0->max_entries == meta1->max_entries &&
>> -               bpf_map_meta_equal(meta0, meta1);
>> +       if (!bpf_map_meta_equal(meta0, meta1))
>> +               return false;
>> +       return meta0->map_flags & BPF_F_INNER_MAP ? true :
>> +              meta0->max_entries == meta1->max_entries;
> 
> even if meta1 doesn't have BPF_F_INNER_MAP, it's ok, because all the
> accesses for map returned from outer map lookup will not inline, is
> that right? So this flag only matters for the inner map's prototype.

Not right now, we would have to open code bpf_map_meta_equal() to cut out that
bit from the meta0/1 flags comparison. I wouldn't change bpf_map_meta_equal()
itself given that bit can be reused for different purpose for other map types.

> You also mentioned that not inlining array access should still be
> fast. So I wonder, what if we just force non-inlined access for inner
> maps of ARRAY type? Would it be too bad of a hit for existing
> applications?

Fast in the sense of that we can avoid a retpoline given the direct call
to array_map_lookup_elem() as opposed to bpf_map_lookup_elem(). In the
array_map_gen_lookup() we even have insn level optimizations such as
replacing BPF_MUL with BPF_LSH with immediate elem size on power of 2
#elems as well as avoiding spectre masking (which the call one has not),
presumably for cases like XDP we might want the best implementation if
usage allows it.

> The benefit would be that everything would just work without a special
> flag. If perf hit isn't prohibitive, it might be worthwhile to
> simplify user experience?

Taking the above penalty aside for same sized-elems, simplest one would have
been to just set inner_map_meta->ops to &array_map_no_inline_ops inside the
bpf_map_meta_alloc().
