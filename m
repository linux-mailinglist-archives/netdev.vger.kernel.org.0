Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 150F613818D
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 15:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729773AbgAKObz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 09:31:55 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:58275 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729743AbgAKObz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 09:31:55 -0500
X-Originating-IP: 79.86.19.127
Received: from [192.168.0.12] (127.19.86.79.rev.sfr.net [79.86.19.127])
        (Authenticated sender: alexandre@ghiti.fr)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id D0921E0002;
        Sat, 11 Jan 2020 14:31:50 +0000 (UTC)
From:   Alexandre Ghiti <alexandre@ghiti.fr>
Subject: Re: linux-next: build warning after merge of the bpf-next tree
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>, daniel@iogearbox.net,
        ast@kernel.org, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, zong.li@sifive.com
References: <a367af4d-7267-2e94-74dc-2a2aac204080@ghiti.fr>
 <20191018105657.4584ec67@canb.auug.org.au>
 <20191028110257.6d6dba6e@canb.auug.org.au>
 <mhng-0daa1a90-2bed-4b2e-833e-02cd9c0aa73f@palmerdabbelt-glaptop>
Message-ID: <d5d59f54-e391-3659-d4c0-eada50f88187@ghiti.fr>
Date:   Sat, 11 Jan 2020 09:31:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <mhng-0daa1a90-2bed-4b2e-833e-02cd9c0aa73f@palmerdabbelt-glaptop>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/10/20 7:20 PM, Palmer Dabbelt wrote:
> On Fri, 10 Jan 2020 14:28:17 PST (-0800), alexandre@ghiti.fr wrote:
>> Hi guys,
>>
>> On 10/27/19 8:02 PM, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> On Fri, 18 Oct 2019 10:56:57 +1100 Stephen Rothwell 
>>> <sfr@canb.auug.org.au> wrote:
>>>> Hi all,
>>>>
>>>> After merging the bpf-next tree, today's linux-next build (powerpc
>>>> ppc64_defconfig) produced this warning:
>>>>
>>>> WARNING: 2 bad relocations
>>>> c000000001998a48 R_PPC64_ADDR64 _binary__btf_vmlinux_bin_start
>>>> c000000001998a50 R_PPC64_ADDR64 _binary__btf_vmlinux_bin_end
>>>>
>>>> Introduced by commit
>>>>
>>>>    8580ac9404f6 ("bpf: Process in-kernel BTF")
>>> This warning now appears in the net-next tree build.
>>>
>>>
>> I bump that thread up because Zong also noticed that 2 new 
>> relocations for
>> those symbols appeared in my riscv relocatable kernel branch following
>> that commit.
>>
>> I also noticed 2 new relocations R_AARCH64_ABS64 appearing in arm64 
>> kernel.
>>
>> Those 2 weak undefined symbols have existed since commit
>> 341dfcf8d78e ("btf: expose BTF info through sysfs") but this is the fact
>> to declare those symbols into btf.c that produced those relocations.
>>
>> I'm not sure what this all means, but this is not something I expected
>> for riscv for
>> a kernel linked with -shared/-fpie. Maybe should we just leave them to
>> zero ?
>>
>> I think that deserves a deeper look if someone understands all this
>> better than I do.
>
> Can you give me a pointer to your tree and how to build a relocatable 
> kernel?
> Weak undefined symbols have the absolute value 0,


So according to you the 2 new relocations R_RISCV_64 are normal and 
should not
be modified at runtime right ?


> but the kernel is linked at
> an address such that 0 can't be reached by normal means.  When I added 
> support
> to binutils for this I did it in a way that required almost no code --
> essetially I just stopped dissallowing x0 as a possible base register 
> for PCREL
> relocations, which results in 0 always being accessible.  I just 
> wanted to get
> the kernel to build again, so I didn't worry about chasing around all the
> addressing modes.  The PIC/PIE support generates different relocations 
> and I
> wouldn't be surprised if I just missed one (or more likely all) of them.
>
> It's probably a simple fix, though I feel like every time I say that 
> about the
> linker I end up spending a month in there...

You can find it here:

https://github.com/AlexGhiti/riscv-linux/tree/int/alex/riscv_relocatable_v1

Zong fixed the bug introduced by those 2 new relocations and everything 
works
like a charm, so I'm not sure you have to dig in the linker :)

Alex

