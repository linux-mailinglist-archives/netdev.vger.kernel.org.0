Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 076A414900D
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 22:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729828AbgAXVUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 16:20:20 -0500
Received: from www62.your-server.de ([213.133.104.62]:46698 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729604AbgAXVUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 16:20:20 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iv6NC-0007Hv-4z; Fri, 24 Jan 2020 22:20:14 +0100
Received: from [178.197.248.48] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iv6NB-000IWv-Ry; Fri, 24 Jan 2020 22:20:13 +0100
Subject: Re: [Potential Spoof] [PATCH bpf-next] libbpf: improve handling of
 failed CO-RE relocations
To:     Martin Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <Kernel-team@fb.com>
References: <20200124053837.2434679-1-andriin@fb.com>
 <20200124072054.2kr25erckbclkwgv@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzbM7s8JWM8bPq=JdFX-ujkbYUifD7hNUQOGSJpJ7x5NJw@mail.gmail.com>
 <20200124201241.722pbppudaiw4cz4@kafai-mbp.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <379ee6c3-9de1-f552-406d-11fd8216c96b@iogearbox.net>
Date:   Fri, 24 Jan 2020 22:20:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200124201241.722pbppudaiw4cz4@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25705/Fri Jan 24 12:39:10 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/20 9:12 PM, Martin Lau wrote:
> On Fri, Jan 24, 2020 at 10:30:12AM -0800, Andrii Nakryiko wrote:
>> On Thu, Jan 23, 2020 at 11:21 PM Martin Lau <kafai@fb.com> wrote:
>>> On Thu, Jan 23, 2020 at 09:38:37PM -0800, Andrii Nakryiko wrote:
>>>> Previously, if libbpf failed to resolve CO-RE relocation for some
>>>> instructions, it would either return error immediately, or, if
>>>> .relaxed_core_relocs option was set, would replace relocatable offset/imm part
>>>> of an instruction with a bogus value (-1). Neither approach is good, because
>>>> there are many possible scenarios where relocation is expected to fail (e.g.,
>>>> when some field knowingly can be missing on specific kernel versions). On the
>>>> other hand, replacing offset with invalid one can hide programmer errors, if
>>>> this relocation failue wasn't anticipated.
>>>>
>>>> This patch deprecates .relaxed_core_relocs option and changes the approach to
>>>> always replacing instruction, for which relocation failed, with invalid BPF
>>>> helper call instruction. For cases where this is expected, BPF program should
>>>> already ensure that that instruction is unreachable, in which case this
>>>> invalid instruction is going to be silently ignored. But if instruction wasn't
>>>> guarded, BPF program will be rejected at verification step with verifier log
>>>> pointing precisely to the place in assembly where the problem is.
>>>>
>>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>>> ---
>>>>   tools/lib/bpf/libbpf.c | 95 +++++++++++++++++++++++++-----------------
>>>>   tools/lib/bpf/libbpf.h |  6 ++-
>>>>   2 files changed, 61 insertions(+), 40 deletions(-)
>>>>
>>>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>>>> index ae34b681ae82..39f1b7633a7c 100644
>>>> --- a/tools/lib/bpf/libbpf.c
>>>> +++ b/tools/lib/bpf/libbpf.c
>>>> @@ -345,7 +345,6 @@ struct bpf_object {
>>>>
>>>>        bool loaded;
>>>>        bool has_pseudo_calls;
>>>> -     bool relaxed_core_relocs;
>>>>
>>>>        /*
>>>>         * Information when doing elf related work. Only valid if fd
>>>> @@ -4238,25 +4237,38 @@ static int bpf_core_calc_field_relo(const struct bpf_program *prog,
>>>>    */
>>>>   static int bpf_core_reloc_insn(struct bpf_program *prog,
>>>>                               const struct bpf_field_reloc *relo,
>>>> +                            int relo_idx,
>>>>                               const struct bpf_core_spec *local_spec,
>>>>                               const struct bpf_core_spec *targ_spec)
>>>>   {
>>>> -     bool failed = false, validate = true;
>>>>        __u32 orig_val, new_val;
>>>>        struct bpf_insn *insn;
>>>> +     bool validate = true;
>>>>        int insn_idx, err;
>>>>        __u8 class;
>>>>
>>>>        if (relo->insn_off % sizeof(struct bpf_insn))
>>>>                return -EINVAL;
>>>>        insn_idx = relo->insn_off / sizeof(struct bpf_insn);
>>>> +     insn = &prog->insns[insn_idx];
>>>> +     class = BPF_CLASS(insn->code);
>>>>
>>>>        if (relo->kind == BPF_FIELD_EXISTS) {
>>>>                orig_val = 1; /* can't generate EXISTS relo w/o local field */
>>>>                new_val = targ_spec ? 1 : 0;
>>>>        } else if (!targ_spec) {
>>>> -             failed = true;
>>>> -             new_val = (__u32)-1;
>>>> +             pr_debug("prog '%s': relo #%d: substituting insn #%d w/ invalid insn\n",
>>>> +                      bpf_program__title(prog, false), relo_idx, insn_idx);
>>>> +             insn->code = BPF_JMP | BPF_CALL;
>>>> +             insn->dst_reg = 0;
>>>> +             insn->src_reg = 0;
>>>> +             insn->off = 0;
>>>> +             /* if this instruction is reachable (not a dead code),
>>>> +              * verifier will complain with the following message:
>>>> +              * invalid func unknown#195896080
>>>> +              */
>>>> +             insn->imm = 195896080; /* => 0xbad2310 => "bad relo" */
>>> Should this value become a binded contract in uapi/bpf.h so
>>> that the verifier can print a more meaningful name than "unknown#195896080"?
>>
>> It feels a bit premature to fix this in kernel. It's one of many ways
>> we can do this, e.g., alternative would be using invalid opcode
>> altogether. It's not yet clear what's the best way to report this from
>> kernel. Maybe in the future verifier will have some better way to
>> pinpoint where and what problem there is in user's program through
>> some more structured approach than current free-form log.
>>
>> So what I'm trying to say is that we should probably get a bit more
>> experience using these features first and understand what
>> kernel/userspace interface should be for reporting issues like this,
>> before setting anything in stone in verifier. For now, this
>> "unknown#195896080" should be a pretty unique search term :)
> Sure.  I think this value will never be used for real in the life time.
> I was mostly worry this message will be confusing.  May be the loader
> could be improved to catch this and interpret it in a more meaningful
> way.

Agree with both of you that we might want to find a better error reporting
mechanism here in future, but can be done on top of this. Applied, thanks!
