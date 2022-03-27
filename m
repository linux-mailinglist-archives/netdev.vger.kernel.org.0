Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14D84E873D
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 12:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbiC0Kh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 06:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbiC0Khz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 06:37:55 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E4452B26;
        Sun, 27 Mar 2022 03:36:13 -0700 (PDT)
Received: from [192.168.1.11] (dynamic-078-055-201-104.78.55.pool.telefonica.de [78.55.201.104])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id C11CF61EA1923;
        Sun, 27 Mar 2022 12:36:09 +0200 (CEST)
Message-ID: <7edcd673-decf-7b4e-1f6e-f2e0e26f757a@molgen.mpg.de>
Date:   Sun, 27 Mar 2022 12:36:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: BUG: Bad page state in process systemd-udevd (was: [PATCH v9
 bpf-next 1/9] x86/Kconfig: select HAVE_ARCH_HUGE_VMALLOC with
 HAVE_ARCH_HUGE_VMAP)
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
To:     Song Liu <song@kernel.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kernel-team@fb.com, peterz@infradead.org, x86@kernel.org,
        iii@linux.ibm.com, Song Liu <songliubraving@fb.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Rick P Edgecombe <rick.p.edgecombe@intel.com>,
        regressions@lists.linux.dev
References: <20220204185742.271030-1-song@kernel.org>
 <20220204185742.271030-2-song@kernel.org>
 <14444103-d51b-0fb3-ee63-c3f182f0b546@molgen.mpg.de>
In-Reply-To: <14444103-d51b-0fb3-ee63-c3f182f0b546@molgen.mpg.de>
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


Am 26.03.22 um 19:46 schrieb Paul Menzel:
> #regzbot introduced: fac54e2bfb5be2b0bbf115fe80d45f59fd773048
> #regzbot title: BUG: Bad page state in process systemd-udevd

> Am 04.02.22 um 19:57 schrieb Song Liu:
>> From: Song Liu <songliubraving@fb.com>
>>
>> This enables module_alloc() to allocate huge page for 2MB+ requests.
>> To check the difference of this change, we need enable config
>> CONFIG_PTDUMP_DEBUGFS, and call module_alloc(2MB). Before the change,
>> /sys/kernel/debug/page_tables/kernel shows pte for this map. With the
>> change, /sys/kernel/debug/page_tables/ show pmd for thie map.
>>
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>>   arch/x86/Kconfig | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 6fddb63271d9..e0e0d00cf103 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -159,6 +159,7 @@ config X86
>>       select HAVE_ALIGNED_STRUCT_PAGE        if SLUB
>>       select HAVE_ARCH_AUDITSYSCALL
>>       select HAVE_ARCH_HUGE_VMAP        if X86_64 || X86_PAE
>> +    select HAVE_ARCH_HUGE_VMALLOC        if HAVE_ARCH_HUGE_VMAP
>>       select HAVE_ARCH_JUMP_LABEL
>>       select HAVE_ARCH_JUMP_LABEL_RELATIVE
>>       select HAVE_ARCH_KASAN            if X86_64
> 
> Testing Linus’ current master branch, Linux logs critical messages like 
> below:
> 
>      BUG: Bad page state in process systemd-udevd  pfn:102e03
> 
> I bisected to your commit fac54e2bfb5 (x86/Kconfig: select 
> HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP).

Sorry, I forget to mention, that this is a 32-bit (i686) userspace, but 
a 64-bit Linux kernel, so it might be the same issue as mentioned in 
commit eed1fcee556f (x86: Disable HAVE_ARCH_HUGE_VMALLOC on 32-bit x86), 
but didn’t fix the issue for 64-bit Linux kernel and 32-bit userspace.


Kind regards,

Paul
