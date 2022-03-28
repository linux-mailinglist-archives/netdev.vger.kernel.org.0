Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C03D4EA137
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 22:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344360AbiC1UQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 16:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344336AbiC1UQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 16:16:18 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0552655F;
        Mon, 28 Mar 2022 13:14:34 -0700 (PDT)
Received: from [192.168.0.4] (ip5f5ae92d.dynamic.kabel-deutschland.de [95.90.233.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 7D20261EA1928;
        Mon, 28 Mar 2022 22:14:30 +0200 (CEST)
Message-ID: <cc77b58d-657e-b9d9-b1cf-9b72973c1623@molgen.mpg.de>
Date:   Mon, 28 Mar 2022 22:14:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: BUG: Bad page state in process systemd-udevd (was: [PATCH v9
 bpf-next 1/9] x86/Kconfig: select HAVE_ARCH_HUGE_VMALLOC with
 HAVE_ARCH_HUGE_VMAP)
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>
Cc:     Rick P Edgecombe <rick.p.edgecombe@intel.com>,
        Song Liu <song@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        iii@linux.ibm.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        regressions@lists.linux.dev, amd-gfx@lists.freedesktop.org
References: <20220204185742.271030-1-song@kernel.org>
 <20220204185742.271030-2-song@kernel.org>
 <14444103-d51b-0fb3-ee63-c3f182f0b546@molgen.mpg.de>
 <7edcd673-decf-7b4e-1f6e-f2e0e26f757a@molgen.mpg.de>
 <7F597B8E-72B3-402B-BD46-4C7F13A5D7BD@fb.com>
 <4a49a98a-d958-8e48-10eb-24bb220e24ed@molgen.mpg.de>
 <44B009D1-2BF8-4C69-9F09-B0F553A48B78@fb.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <44B009D1-2BF8-4C69-9F09-B0F553A48B78@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Song,


Am 28.03.22 um 21:24 schrieb Song Liu:

>> On Mar 27, 2022, at 11:51 PM, Paul Menzel <pmenzel@molgen.mpg.de> wrote:

>> Am 28.03.22 um 08:37 schrieb Song Liu:

[…]

>>>> On Mar 27, 2022, at 3:36 AM, Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>>
>>>> Am 26.03.22 um 19:46 schrieb Paul Menzel:
>>>>> #regzbot introduced: fac54e2bfb5be2b0bbf115fe80d45f59fd773048
>>>>> #regzbot title: BUG: Bad page state in process systemd-udevd
>>>>
>>>>> Am 04.02.22 um 19:57 schrieb Song Liu:
>>>>>> From: Song Liu <songliubraving@fb.com>
>>>>>>
>>>>>> This enables module_alloc() to allocate huge page for 2MB+ requests.
>>>>>> To check the difference of this change, we need enable config
>>>>>> CONFIG_PTDUMP_DEBUGFS, and call module_alloc(2MB). Before the change,
>>>>>> /sys/kernel/debug/page_tables/kernel shows pte for this map. With the
>>>>>> change, /sys/kernel/debug/page_tables/ show pmd for thie map.
>>>>>>
>>>>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>>>>> ---
>>>>>>    arch/x86/Kconfig | 1 +
>>>>>>    1 file changed, 1 insertion(+)
>>>>>>
>>>>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>>>>> index 6fddb63271d9..e0e0d00cf103 100644
>>>>>> --- a/arch/x86/Kconfig
>>>>>> +++ b/arch/x86/Kconfig
>>>>>> @@ -159,6 +159,7 @@ config X86
>>>>>>        select HAVE_ALIGNED_STRUCT_PAGE        if SLUB
>>>>>>        select HAVE_ARCH_AUDITSYSCALL
>>>>>>        select HAVE_ARCH_HUGE_VMAP        if X86_64 || X86_PAE
>>>>>> +    select HAVE_ARCH_HUGE_VMALLOC        if HAVE_ARCH_HUGE_VMAP
>>>>>>        select HAVE_ARCH_JUMP_LABEL
>>>>>>        select HAVE_ARCH_JUMP_LABEL_RELATIVE
>>>>>>        select HAVE_ARCH_KASAN            if X86_64
>>>>> Testing Linus’ current master branch, Linux logs critical messages like below:
>>>>>      BUG: Bad page state in process systemd-udevd  pfn:102e03
>>>>> I bisected to your commit fac54e2bfb5 (x86/Kconfig: select
>>>>> HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP).
>>>> Sorry, I forget to mention, that this is a 32-bit (i686) userspace,
>>>> but a 64-bit Linux kernel, so it might be the same issue as
>>>> mentioned in commit eed1fcee556f (x86: Disable
>>>> HAVE_ARCH_HUGE_VMALLOC on 32-bit x86), but didn’t fix the issue for
>>>> 64-bit Linux kernel and 32-bit userspace.
>>> I will look more into this tomorrow. To clarify, what is the 32-bit
>>> user space that triggers this? Is it systemd-udevd? Is the systemd
>>> also i686?
>>
>> Yes, everything – also systemd – is i686. You can build a 32-bit VM image with grml-debootstrap [1]:
>>
>>     sudo DEBOOTSTRAP=mmdebstrap ~/src/grml-debootstrap/grml-debootstrap --vm --vmfile --vmsize 3G --target /dev/shm/debian-32.img -r sid --arch i686 --filesystem ext4
>>
>> Then run that with QEMU, but pass the 64-bit Linux kernel to QEMU directly with the switches `-kernel` and `-append`, or install the amd64 Linux kernel into the Debian VM image or the package created with `make bindeb-pkg` with `dpkg -i …`.
> 
> Thanks for these information!
> 
> I tried the following, but couldn't reproduce the issue.
> 
> sudo ./grml-debootstrap --vm --vmfile --vmsize 3G --target ../debian-32.img -r sid --arch i386 --filesystem ext4
> 
> Note: s/i686/i386/. Also I run this on Fedora, so I didn't specify DEBOOTSTRAP.
> 
> Then I run it with
> 
> qemu-system-x86_64 \
>    -boot d ./debian-32.img -m 1024 -smp 4 \
>    -kernel ./bzImage \
>    -nographic -append 'root=/dev/sda1 ro console=ttyS0,115200'
> 
> The VM boots fine. The config being used is x86_64_defconfig +
> CONFIG_DRM_FBDEV_EMULATION.
> 
> I wonder whether this is caused by different config or different image.
> Could you please share your config?

Sorry, for leading you on the wrong path. I actually just wanted to help 
getting a 32-bit userspace set up quickly. I haven’t tried reproducing 
the issue in a VM, and used only the ASUS F2A85-M PRO.

Booting the system with `nomodeset`, I didn’t see the error. No idea if 
it’s related to framebuffer handling or specific to AMD graphics device.

> PS: I couldn't figure out the root password of the image, --password
> option of grml-debootstrap doesn't seem to work.

Hmm, I thought it’s asking you during install, but I haven’t done it in 
a while.


Kind regards,

Paul
