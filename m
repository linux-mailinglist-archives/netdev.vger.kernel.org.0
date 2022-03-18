Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B784DE18F
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 20:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbiCRTDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 15:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240294AbiCRTCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 15:02:53 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D894824F296;
        Fri, 18 Mar 2022 12:01:33 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id u17so10197320pfk.11;
        Fri, 18 Mar 2022 12:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7i717u6LO6a0VOY9f4DdTcXS3zXZjEBKu2VfKuhLWAY=;
        b=U3Mxg0tra8PcwND/UoAadSoMqtuNQQ33DPL2V+iorZYaJIf+C4Fq7bKe3q/RZXW762
         2594f9HTKP3o91Y2kXJpV/2vYk++fkVFEqWkilnJk39lMZ4skXp/CLGK18tC7yqX5Agh
         7Pmt6lenWHoEMIC4FLv6mY5U11kVx4X4gqhzCoFM5pFO3Ym5QfMNnm2XSWzpzkUSvGwx
         taifep3jfV8WiKXGK4ESEb+lHXPVzoFcWPkLV9NUeXQmHhrZBM5DXtGQxxQZJEfZnCy6
         tKRwBFsbyHYh1EfpECjoBpuJhE3ngrbuMqAsr2dD8BXZ+Oq8x1Z+LXoMfXbGCUbET488
         HSuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7i717u6LO6a0VOY9f4DdTcXS3zXZjEBKu2VfKuhLWAY=;
        b=At3+p6iTrEKrMBPQruAfWub8zSWEq7aniIzuRKL30271HwDGpQdWJBFG2FME4MEZ+0
         mBiyhNtsYu8JDt/CnMnNArgguBLaETq2KIwzAwurzz4Y6Qm4bvoCN6by5aUMxKfzV8St
         L0/6/HjXCAhAVc/QcM/nM9Vr8+WJOszZmkswWJzVTWk9sRvv+FItvETA3wUSbAfo84A7
         Icn88/F8Ouvd713qFMImZCFVuPirxopfI/9kcs8m9oUs7rmTvfrh3bmH5N09gPRsxcVa
         m/1wea4YBwbQnutDY+hvnLG7MX6BkgDtmYqd0CKdrlrwFGSkB48nkIjnb0zFy9pT2UXK
         I/8g==
X-Gm-Message-State: AOAM5301UIohI7I1kXGf/Cgq5Vr053BoRJsauVd+VSaa2ubh1XmJt+3H
        3vm74ZuLn9owDz4OSvSiOHB/F/gjxyc=
X-Google-Smtp-Source: ABdhPJyM2wzx+4vWZmfz+MlwH0hv/gWcPc+DATbaV1iSYhJISbkPof8xntVAvJP48kk8FfJVC/plBw==
X-Received: by 2002:a05:6a00:1a02:b0:4f7:c25d:2170 with SMTP id g2-20020a056a001a0200b004f7c25d2170mr11696751pfv.53.1647630092782;
        Fri, 18 Mar 2022 12:01:32 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ij17-20020a17090af81100b001c67c964d93sm6472130pjb.2.2022.03.18.12.01.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 12:01:32 -0700 (PDT)
Subject: Re: [PATCH] net: bcmgenet: Use stronger register read/writes to
 assure ordering
To:     Peter Robinson <pbrobinson@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org,
        opendmb@gmail.com, davem@davemloft.net, kuba@kernel.org,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org
References: <20220310045358.224350-1-jeremy.linton@arm.com>
 <f831a4c6-58c9-20bd-94e8-e221369609e8@gmail.com>
 <de28c0ec-56a7-bfff-0c41-72aeef097ee3@arm.com>
 <2167202d-327c-f87d-bded-702b39ae49e1@gmail.com>
 <CALeDE9MerhZWwJrkg+2OEaQ=_9C6PHYv7kQ_XEQ6Kp7aV2R31A@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <472540d2-3a61-beca-70df-d5f152e1cfd1@gmail.com>
Date:   Fri, 18 Mar 2022 12:01:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CALeDE9MerhZWwJrkg+2OEaQ=_9C6PHYv7kQ_XEQ6Kp7aV2R31A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/22 8:29 AM, Peter Robinson wrote:
> On Fri, Mar 11, 2022 at 3:57 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>>
>>
>> On 3/10/2022 5:09 PM, Jeremy Linton wrote:
>>> On 3/10/22 12:59, Florian Fainelli wrote:
>>>> On 3/9/22 8:53 PM, Jeremy Linton wrote:
>>>>> GCC12 appears to be much smarter about its dependency tracking and is
>>>>> aware that the relaxed variants are just normal loads and stores and
>>>>> this is causing problems like:
>>>>>
>>>>> [  210.074549] ------------[ cut here ]------------
>>>>> [  210.079223] NETDEV WATCHDOG: enabcm6e4ei0 (bcmgenet): transmit
>>>>> queue 1 timed out
>>>>> [  210.086717] WARNING: CPU: 1 PID: 0 at net/sched/sch_generic.c:529
>>>>> dev_watchdog+0x234/0x240
>>>>> [  210.095044] Modules linked in: genet(E) nft_fib_inet nft_fib_ipv4
>>>>> nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6
>>>>> nft_reject nft_ct nft_chain_nat]
>>>>> [  210.146561] ACPI CPPC: PCC check channel failed for ss: 0. ret=-110
>>>>> [  210.146927] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G
>>>>> E     5.17.0-rc7G12+ #58
>>>>> [  210.153226] CPPC Cpufreq:cppc_scale_freq_workfn: failed to read
>>>>> perf counters
>>>>> [  210.161349] Hardware name: Raspberry Pi Foundation Raspberry Pi 4
>>>>> Model B/Raspberry Pi 4 Model B, BIOS EDK2-DEV 02/08/2022
>>>>> [  210.161353] pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS
>>>>> BTYPE=--)
>>>>> [  210.161358] pc : dev_watchdog+0x234/0x240
>>>>> [  210.161364] lr : dev_watchdog+0x234/0x240
>>>>> [  210.161368] sp : ffff8000080a3a40
>>>>> [  210.161370] x29: ffff8000080a3a40 x28: ffffcd425af87000 x27:
>>>>> ffff8000080a3b20
>>>>> [  210.205150] x26: ffffcd425aa00000 x25: 0000000000000001 x24:
>>>>> ffffcd425af8ec08
>>>>> [  210.212321] x23: 0000000000000100 x22: ffffcd425af87000 x21:
>>>>> ffff55b142688000
>>>>> [  210.219491] x20: 0000000000000001 x19: ffff55b1426884c8 x18:
>>>>> ffffffffffffffff
>>>>> [  210.226661] x17: 64656d6974203120 x16: 0000000000000001 x15:
>>>>> 6d736e617274203a
>>>>> [  210.233831] x14: 2974656e65676d63 x13: ffffcd4259c300d8 x12:
>>>>> ffffcd425b07d5f0
>>>>> [  210.241001] x11: 00000000ffffffff x10: ffffcd425b07d5f0 x9 :
>>>>> ffffcd4258bdad9c
>>>>> [  210.248171] x8 : 00000000ffffdfff x7 : 000000000000003f x6 :
>>>>> 0000000000000000
>>>>> [  210.255341] x5 : 0000000000000000 x4 : 0000000000000000 x3 :
>>>>> 0000000000001000
>>>>> [  210.262511] x2 : 0000000000001000 x1 : 0000000000000005 x0 :
>>>>> 0000000000000044
>>>>> [  210.269682] Call trace:
>>>>> [  210.272133]  dev_watchdog+0x234/0x240
>>>>> [  210.275811]  call_timer_fn+0x3c/0x15c
>>>>> [  210.279489]  __run_timers.part.0+0x288/0x310
>>>>> [  210.283777]  run_timer_softirq+0x48/0x80
>>>>> [  210.287716]  __do_softirq+0x128/0x360
>>>>> [  210.291392]  __irq_exit_rcu+0x138/0x140
>>>>> [  210.295243]  irq_exit_rcu+0x1c/0x30
>>>>> [  210.298745]  el1_interrupt+0x38/0x54
>>>>> [  210.302334]  el1h_64_irq_handler+0x18/0x24
>>>>> [  210.306445]  el1h_64_irq+0x7c/0x80
>>>>> [  210.309857]  arch_cpu_idle+0x18/0x2c
>>>>> [  210.313445]  default_idle_call+0x4c/0x140
>>>>> [  210.317470]  cpuidle_idle_call+0x14c/0x1a0
>>>>> [  210.321584]  do_idle+0xb0/0x100
>>>>> [  210.324737]  cpu_startup_entry+0x30/0x8c
>>>>> [  210.328675]  secondary_start_kernel+0xe4/0x110
>>>>> [  210.333138]  __secondary_switched+0x94/0x98
>>>>>
>>>>> The assumption when these were relaxed seems to be that device memory
>>>>> would be mapped non reordering, and that other constructs
>>>>> (spinlocks/etc) would provide the barriers to assure that packet data
>>>>> and in memory rings/queues were ordered with respect to device
>>>>> register reads/writes. This itself seems a bit sketchy, but the real
>>>>> problem with GCC12 is that it is moving the actual reads/writes around
>>>>> at will as though they were independent operations when in truth they
>>>>> are not, but the compiler can't know that. When looking at the
>>>>> assembly dumps for many of these routines its possible to see very
>>>>> clean, but not strictly in program order operations occurring as the
>>>>> compiler would be free to do if these weren't actually register
>>>>> reads/write operations.
>>>>>
>>>>> Its possible to suppress the timeout with a liberal bit of dma_mb()'s
>>>>> sprinkled around but the device still seems unable to reliably
>>>>> send/receive data. A better plan is to use the safer readl/writel
>>>>> everywhere.
>>>>>
>>>>> Since this partially reverts an older commit, which notes the use of
>>>>> the relaxed variants for performance reasons. I would suggest that
>>>>> any performance problems with this commit are targeted at relaxing only
>>>>> the performance critical code paths after assuring proper barriers.
>>>>>
>>>>> Fixes: 69d2ea9c79898 ("net: bcmgenet: Use correct I/O accessors")
>>>>> Reported-by: Peter Robinson <pbrobinson@gmail.com>
>>>>> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
>>>>
>>>> I think this is the correct approach in that it favors correctness over
>>>> speed, however there is an opportunity for maintaining the speed and
>>>> correctness on non-2711 and non-7712 chips where the GENET core is
>>>> interfaced to a system bus (GISB) that guarantees no re-ordering and no
>>>> buffering. I suppose that until we prove that the extra barrier is
>>>> harmful to performance on those chips, we should go with your patch.
>>>>
>>>> It seems like we missed the GENET_IO_MACRO() in bcmgenet.h, while most
>>>> of them deal with the control path which likely does not have any
>>>> re-ordering problem, there is an exception to that which are the
>>>> intrl2_0 and intrl2_1 macros, which I believe *have* to be ordered as
>>>> well in order to avoid spurious or missed interrupts, or maybe there is
>>>> enough barriers in the interrupt processing code that this is moot?
>>>
>>>
>>> Ok, so I spent some time and tracked down exactly which barrier "fixes"
>>> this immediate problem on the rpi4.
>>>
>>> static void bcmgenet_enable_dma(struct bcmgenet_priv *priv, u32 dma_ctrl)
>>>   {
>>>          u32 reg;
>>>
>>> +       dma_mb(); //timeout fix
>>>          reg = bcmgenet_rdma_readl(priv, DMA_CTRL);
>>>          reg |= dma_ctrl;
>>>
>>>
>>> fixes it as well, and keeps all the existing code. Although, granted I
>>> didn't stress the adapter beyond a couple interactive ssh sessions. And
>>> as you mention there are a fair number of other accessors that I didn't
>>> touch which are still relaxed.
>>
>> Thanks! This is really helpful. Doug told me earlier today that he
>> wanted to take a closer look since your initial approach while correct
>> appears a bit heavy handed.
> 
> With 5.17 due in a couple of days could we get a fix in so it works
> for users and optimise the approach with a follow up so that it's not
> broken for common device?

Given the time crunch we should go with Jeremy's patch that uses
stronger I/O access method and then we will work with Jeremy offline to
make sure that our version of GCC12 is exactly the same as his, as well
as the compiler options (like -mtune/-march) to reproduce this.

If we believe this is only a problem with GCC12 and 5.17 in Fedora, then
I would be inclined to remove the Fixes tag such that when we come up
with a more localized solution we do not have to revert "net: bcmgenet:
Use stronger register read/writes to assure ordering" from stable
branches. This would be mostly a courtesy to our future selves, but an
argument could be made that this probably has always existed, and that
different compilers could behave more or less like GCC12.
-- 
Florian
