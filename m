Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871E72F5779
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729756AbhANCAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729519AbhAMXiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 18:38:00 -0500
Received: from www62.your-server.de (www62.your-server.de [IPv6:2a01:4f8:d0a:276a::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A312C061384;
        Wed, 13 Jan 2021 15:36:35 -0800 (PST)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kzp3Q-0001rR-Al; Wed, 13 Jan 2021 23:55:52 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kzp3Q-000J65-4y; Wed, 13 Jan 2021 23:55:52 +0100
Subject: Re: [PATCH v3 bpf-next 5/7] bpf: support BPF ksym variables in kernel
 modules
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>,
        Yonghong Song <yhs@fb.com>
References: <20210112075520.4103414-1-andrii@kernel.org>
 <20210112075520.4103414-6-andrii@kernel.org>
 <4155ef59-9e5e-f596-f22b-ecd4bde73e85@iogearbox.net>
 <CAADnVQLjv3iLT3yWyR8tK7kAU8sM1giW_cbMcHHQpDCMigivgQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a6075bd0-34f5-29f0-7331-7fe61fd25c12@iogearbox.net>
Date:   Wed, 13 Jan 2021 23:55:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAADnVQLjv3iLT3yWyR8tK7kAU8sM1giW_cbMcHHQpDCMigivgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26048/Wed Jan 13 13:33:31 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/13/21 12:18 AM, Alexei Starovoitov wrote:
> On Tue, Jan 12, 2021 at 8:30 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 1/12/21 8:55 AM, Andrii Nakryiko wrote:
>>> Add support for directly accessing kernel module variables from BPF programs
>>> using special ldimm64 instructions. This functionality builds upon vmlinux
>>> ksym support, but extends ldimm64 with src_reg=BPF_PSEUDO_BTF_ID to allow
>>> specifying kernel module BTF's FD in insn[1].imm field.
>>>
>>> During BPF program load time, verifier will resolve FD to BTF object and will
>>> take reference on BTF object itself and, for module BTFs, corresponding module
>>> as well, to make sure it won't be unloaded from under running BPF program. The
>>> mechanism used is similar to how bpf_prog keeps track of used bpf_maps.
>>>
>>> One interesting change is also in how per-CPU variable is determined. The
>>> logic is to find .data..percpu data section in provided BTF, but both vmlinux
>>> and module each have their own .data..percpu entries in BTF. So for module's
>>> case, the search for DATASEC record needs to look at only module's added BTF
>>> types. This is implemented with custom search function.
>>>
>>> Acked-by: Yonghong Song <yhs@fb.com>
>>> Acked-by: Hao Luo <haoluo@google.com>
>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>> [...]
>>> +
>>> +struct module *btf_try_get_module(const struct btf *btf)
>>> +{
>>> +     struct module *res = NULL;
>>> +#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
>>> +     struct btf_module *btf_mod, *tmp;
>>> +
>>> +     mutex_lock(&btf_module_mutex);
>>> +     list_for_each_entry_safe(btf_mod, tmp, &btf_modules, list) {
>>> +             if (btf_mod->btf != btf)
>>> +                     continue;
>>> +
>>> +             if (try_module_get(btf_mod->module))
>>> +                     res = btf_mod->module;
>>
>> One more thought (follow-up would be okay I'd think) ... when a module references
>> a symbol from another module, it similarly needs to bump the refcount of the module
>> that is owning it and thus disallowing to unload for that other module's lifetime.
>> That usage dependency is visible via /proc/modules however, so if unload doesn't work
>> then lsmod allows a way to introspect that to the user. This seems to be achieved via
>> resolve_symbol() where it records its dependency/usage. Would be great if we could at
>> some point also include the BPF prog name into that list so that this is more obvious.
>> Wdyt?
> 
> I thought about it as well, but plenty of kernel things just grab the ref of ko
> and don't add any way to introspect what piece of kernel is holding ko.
> So this case won't be the first.
> Also if we add it for bpf progs it could be confusing in lsmod.
> Since it currently only shows other ko-s in there.
> Long ago I had an awk script to parse that output to rmmod dependent modules
> before rmmoding the main one. If somebody doing something like this
> bpf prog names in the same place may break things.
> So I think there are more cons than pros.

Hm, true that scripting could break in this case if we were to add bpf prog names in
there. :/ I don't have a better suggestion atm.. we could potentially add something
for the bpf prog info dump via bpftool, but it's a non-obvious location to people who
are used to check deps via lsmod. Also true that we bump ref from plenty of other
locations where it's not directly shown either apart from just the refcnt (e.g. socket
using tcp congctl module etc).
