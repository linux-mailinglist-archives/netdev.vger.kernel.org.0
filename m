Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 415C9103044
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 00:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfKSXc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 18:32:28 -0500
Received: from www62.your-server.de ([213.133.104.62]:46576 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbfKSXc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 18:32:27 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iXCyo-0007fr-MF; Wed, 20 Nov 2019 00:32:18 +0100
Received: from [178.197.248.45] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iXCyo-000XJN-Aj; Wed, 20 Nov 2019 00:32:18 +0100
Subject: Re: [PATCH bpf-next 5/6] libbpf: support libbpf-provided extern
 variables
To:     Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
References: <20191117070807.251360-1-andriin@fb.com>
 <20191117070807.251360-6-andriin@fb.com>
 <20191119032127.hixvyhvjjhx6mmzk@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzaNEU_vpa98QF1Ko_AFVX=3ncykEtWy0kiTNW9agsO+xg@mail.gmail.com>
 <CAEf4Bza1T6h+MWadVjuCrPCY7pkyK9kw-fPdaRx2v3yzSsmcbg@mail.gmail.com>
 <7012feeb-c1e8-1228-c8ce-464ea252799c@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a38eda6e-eaed-c266-6ba5-00299902e249@iogearbox.net>
Date:   Wed, 20 Nov 2019 00:32:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <7012feeb-c1e8-1228-c8ce-464ea252799c@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25638/Tue Nov 19 11:04:49 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/19/19 4:58 PM, Alexei Starovoitov wrote:
> On 11/19/19 7:42 AM, Andrii Nakryiko wrote:
>> On Mon, Nov 18, 2019 at 10:57 PM Andrii Nakryiko
>> <andrii.nakryiko@gmail.com> wrote:
>>> On Mon, Nov 18, 2019 at 7:21 PM Alexei Starovoitov
>>> <alexei.starovoitov@gmail.com> wrote:
>>>> On Sat, Nov 16, 2019 at 11:08:06PM -0800, Andrii Nakryiko wrote:
>>>>> Add support for extern variables, provided to BPF program by libbpf. Currently
>>>>> the following extern variables are supported:
>>>>>     - LINUX_KERNEL_VERSION; version of a kernel in which BPF program is
>>>>>       executing, follows KERNEL_VERSION() macro convention;
>>>>>     - CONFIG_xxx values; a set of values of actual kernel config. Tristate,
>>>>>       boolean, and integer values are supported. Strings are not supported at
>>>>>       the moment.
>>>>>
>>>>> All values are represented as 64-bit integers, with the follow value encoding:
>>>>>     - for boolean values, y is 1, n or missing value is 0;
>>>>>     - for tristate values, y is 1, m is 2, n or missing value is 0;
>>>>>     - for integers, the values is 64-bit integer, sign-extended, if negative; if
>>>>>       config value is missing, it's represented as 0, which makes explicit 0 and
>>>>>       missing config value indistinguishable. If this will turn out to be
>>>>>       a problem in practice, we'll need to deal with it somehow.
>>>>
>>>> I read that statement as there is no extensibility for such api.
>>>
>>> What do you mean exactly?
>>>
>>> Are you worried about 0 vs undefined case? I don't think it's going to
>>> be a problem in practice. Looking at my .config, I see that integer
>>> config values set to their default values are still explicitly
>>> specified with those values. E.g.,
>>>
>>> CONFIG_HZ_1000=y
>>> CONFIG_HZ=1000
>>>
>>> CONFIG_HZ default is 1000, if CONFIG_HZ_1000==y, but still I see it
>>> set. So while I won't claim that it's the case for any possible
>>> integer config, it seems to be pretty consistent in practice.
>>>
>>> Also, I see a lot of values set to explicit 0, like:
>>>
>>> CONFIG_BASE_SMALL=0
>>>
>>> So it seems like integers are typically spelled out explicitly in real
>>> configs and I think this 0 default is pretty sane.
>>>
>>> Next, speaking about extensibility. Once we have BTF type info for
>>> externs, our possibilities are much better. It will be possible to
>>> support bool, int, in64 for the same bool value. Libbpf will be able
>>> to validate the range and fail program load if declared extern type
>>> doesn't match actual value type and value range. So I think
>>> extensibility is there, but right now we are enforcing (logically)
>>> everything to be uin64_t. Unfortunately, with the way externs are done
>>> in ELF, I don't know neither type nor size, so can't be more strict
>>> than that.
>>>
>>> If we really need to know whether some config value is defined or not,
>>> regardless of its value, we can have it by convention. E.g.,
>>> CONFIG_DEFINED_XXX will be either 0 or 1, depending if corresponding
>>> CONFIG_XXX is defined explicitly or not. But I don't want to add that
>>> until we really have a use case where it matters.
>>>
>>>>> Generally speaking, libbpf is not aware of which CONFIG_XXX values is of which
>>>>> expected type (bool, tristate, int), so it doesn't enforce any specific set of
>>>>> values and just parses n/y/m as 0/1/2, respectively. CONFIG_XXX values not
>>>>> found in config file are set to 0.
>>>>
>>>> This is not pretty either.
>>>
>>> What exactly: defaulting to zero or not knowing config value's type?
>>> Given all the options, defaulting to zero seems like the best way to
>>> go.
>>>
>>>>> +
>>>>> +             switch (*value) {
>>>>> +             case 'n':
>>>>> +                     *ext_val = 0;
>>>>> +                     break;
>>>>> +             case 'y':
>>>>> +                     *ext_val = 1;
>>>>> +                     break;
>>>>> +             case 'm':
>>>>> +                     *ext_val = 2;
>>>>> +                     break;
>>>
>>> reading some more code from scripts/kconfig/symbol.c, I'll need to
>>> handle N/Y/M and 0x hexadecimals, will add in v2 after collecting some
>>> more feedback on this version.
>>>
>>>>> +             case '"':
>>>>> +                     pr_warn("extern '%s': strings are not supported\n",
>>>>> +                             ext->name);
>>>>> +                     err = -EINVAL;
>>>>> +                     goto out;
>>>>> +             default:
>>>>> +                     errno = 0;
>>>>> +                     *ext_val = strtoull(value, &value_end, 10);
>>>>> +                     if (errno) {
>>>>> +                             err = -errno;
>>>>> +                             pr_warn("extern '%s': failed to parse value: %d\n",
>>>>> +                                     ext->name, err);
>>>>> +                             goto out;
>>>>> +                     }
>>>>
>>>> BPF has bpf_strtol() helper. I think it would be cleaner to pass whatever
>>>> .config has as bytes to the program and let program parse n/y/m, strings and
>>>> integers.
>>>
>>> Config value is not changing. This is an incredible waste of CPU
>>> resources to re-parse same value over and over again. And it's
>>> incredibly much worse usability as well. Again, once we have BTF for
>>> externs, we can just declare values as const char[] and then user will
>>> be able to do its own parsing. Until then, I think pre-parsing values
>>> into convenient u64 types are much better and handles all the typical
>>> cases.
>>
>> One more thing I didn't realize I didn't state explicitly, because
>> I've been thinking and talking about that for so long now, that it
>> kind of internalized completely.
>>
>> These externs, including CONFIG_XXX ones, are meant to interoperate
>> nicely with field relocations within BPF CO-RE concept. They are,
>> among other things, are meant to disable parts of BPF program logic
>> through verifier's dead code elimination by doing something like:
>>
>> if (CONFIG_SOME_FEATURES_ENABLED) {
>>       BPF_CORE_READ(t, some_extra_field);
b>>       /* or */
>>       bpf_helper_that_only_present_when_feature_is_enabled();
>> } else {
>>       /* fallback logic */
>> }
>>
>> With CONFIG_SOME_FEATURES_ENABLED not being a read-only integer
>> constant when BPF program is loaded, this is impossible. So it
>> absolutely must be some sort of easy to use integer constant.
> 
> Hmm. what difference do you see between u64 and char[] ?
> The const propagation logic in the verifier should work the same way.
> If it doesn't it's a bug in the verifier and it's not ok to hack
> extern api to workaround the bug.
> 
> What you're advocating with libbpf-side of conversion to integers
> reminds me of our earlier attempts with cgroup_sysctl hooks where
> we started with ints only to realize that in practice it's too
> limited. Then bpf_strtol was introduced and api got much cleaner.
> Same thing here. Converting char[] into ints or whatever else
> is the job of the program. Not of libbpf. The verifier can be taught
> to optimize bpf_strtol() into const when const char[] is passed in.
> 
> As far as is_enabled() check doing it as 0/1 the way you're proposing
> has in-band signaling issues that you admitted in the commit log.
> For is_enabled() may be new builtin() on llvm side would be better?
> Something like __builtin_preserve_field_info(field, BPF_FIELD_EXISTS)
> but can be used on _any_ extern function or variable.
> Like __builtin_is_extern_resolved(extern_name);
> Then on libbpf side CONFIG_* that are not in config.gz won't be seen
> by the program (instead of seen as 0 in your proposal) and the code
> will look like:
> if (__builtin_is_extern_resolved(CONFIG_NETNS)) {
>     ..do things;
> } else {
> }
> The verifier dead code elimination will take care of branches.

I sort of like the option of __builtin_is_extern_resolved() better than
plain 0 to provide an option for the developer to explicitly check for
that. But I'd like to take a step back in the discussion on the topic of
bpf_object__init_extern_map(). I'm wondering why it must be part of libbpf
at all to read the kernel config and resolve CONFIG_ / LINUX_KERNEL_VERSION
automatically. This feels a bit too much assumptions and automagic resolving.
Can't the application on top of libbpf pass in a callback where the extern
resolution would be outsourced into application rather than in libbpf?
Reason I'm asking is two-fold: i) this concept feels quite generic and my
take is that this could be applied to many other things as well beyond just
plain kernel config, ii) callback would also allow to experiment first what
would work best in practice wrt kernel config as one specific example, and
in a later step, libbpf could provide this as one built-in callback option
for the user to opt-into if its found to be generic/useful enough.

> The BPF program itself doesn't need to read the value of CONFIG_
> it only needs to know whether it was defined.
> Such builtin would match semantics better.
> If CONFIG_ is tri-state doing
> if (*(u8*)CONFIG_FOO == 'y' || *(u8*)CONFIG_FOO == 'm')

Passing in raw buffer feels more natural, agree, but then, again, if we had
a callback it would be up to the one who's implementing it.

> is cleaner than *(u64*)CONFIG_FOO == 1 || 2.
> and constant propagation in the verifier should work the same way.
