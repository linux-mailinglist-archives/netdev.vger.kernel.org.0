Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B039A5838AA
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 08:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbiG1GT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 02:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234165AbiG1GT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 02:19:26 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229AC5E337;
        Wed, 27 Jul 2022 23:19:22 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LtgQk4nnWzkY8v;
        Thu, 28 Jul 2022 14:16:46 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 28 Jul 2022 14:19:20 +0800
Message-ID: <4e655ad1-4ff0-b163-1c22-0276ecf69fec@huawei.com>
Date:   Thu, 28 Jul 2022 14:19:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [aarch64] pc : ftrace_set_filter_ip+0x24/0xa0 - lr :
 bpf_trampoline_update.constprop.0+0x428/0x4a0
Content-Language: en-US
To:     Song Liu <song@kernel.org>, Xu Kuohai <xukuohai@huaweicloud.com>
CC:     Bruno Goncalves <bgoncalv@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <CA+QYu4qw6LecuxwAESLBvzEpj9Uv4LobX0rofDgVk_3YHjY7Fw@mail.gmail.com>
 <0051a5c0-aa9f-423e-bba3-6d5732402692@huaweicloud.com>
 <CAPhsuW63ms5bULxcyQroLcRABxwx=6Q0ps189S1AH5jizyzZNA@mail.gmail.com>
From:   Xu Kuohai <xukuohai@huawei.com>
In-Reply-To: <CAPhsuW63ms5bULxcyQroLcRABxwx=6Q0ps189S1AH5jizyzZNA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/2022 11:54 AM, Song Liu wrote:
> On Wed, Jul 27, 2022 at 8:18 PM Xu Kuohai <xukuohai@huaweicloud.com> wrote:
>>
>> On 7/27/2022 6:40 PM, Bruno Goncalves wrote:
>>> Hello,
>>>
>>> Recently we started to hit the following panic when testing the
>>> net-next tree on aarch64. The first commit that we hit this is
>>> "b3fce974d423".
>>>
>>> [   44.517109] audit: type=1334 audit(1658859870.268:59): prog-id=19 op=LOAD
>>> [   44.622031] Unable to handle kernel NULL pointer dereference at
>>> virtual address 0000000000000010
>>> [   44.624321] Mem abort info:
>>> [   44.625049]   ESR = 0x0000000096000004
>>> [   44.625935]   EC = 0x25: DABT (current EL), IL = 32 bits
>>> [   44.627182]   SET = 0, FnV = 0
>>> [   44.627930]   EA = 0, S1PTW = 0
>>> [   44.628684]   FSC = 0x04: level 0 translation fault
>>> [   44.629788] Data abort info:
>>> [   44.630474]   ISV = 0, ISS = 0x00000004
>>> [   44.631362]   CM = 0, WnR = 0
>>> [   44.632041] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000100ab5000
>>> [   44.633494] [0000000000000010] pgd=0000000000000000, p4d=0000000000000000
>>> [   44.635202] Internal error: Oops: 96000004 [#1] SMP
>>> [   44.636452] Modules linked in: xfs crct10dif_ce ghash_ce virtio_blk
>>> virtio_console virtio_mmio qemu_fw_cfg
>>> [   44.638713] CPU: 2 PID: 1 Comm: systemd Not tainted 5.19.0-rc7 #1
>>> [   44.640164] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
>>> [   44.641799] pstate: 00400005 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>>> [   44.643404] pc : ftrace_set_filter_ip+0x24/0xa0
>>> [   44.644659] lr : bpf_trampoline_update.constprop.0+0x428/0x4a0
>>> [   44.646118] sp : ffff80000803b9f0
>>> [   44.646950] x29: ffff80000803b9f0 x28: ffff0b5d80364400 x27: ffff80000803bb48
>>> [   44.648721] x26: ffff8000085ad000 x25: ffff0b5d809d2400 x24: 0000000000000000
>>> [   44.650493] x23: 00000000ffffffed x22: ffff0b5dd7ea0900 x21: 0000000000000000
>>> [   44.652279] x20: 0000000000000000 x19: 0000000000000000 x18: ffffffffffffffff
>>> [   44.654067] x17: 0000000000000000 x16: 0000000000000000 x15: ffffffffffffffff
>>> [   44.655787] x14: ffff0b5d809d2498 x13: ffff0b5d809d2432 x12: 0000000005f5e100
>>> [   44.657535] x11: abcc77118461cefd x10: 000000000000005f x9 : ffffa7219cb5b190
>>> [   44.659254] x8 : ffffa7219c8e0000 x7 : 0000000000000000 x6 : ffffa7219db075e0
>>> [   44.661066] x5 : ffffa7219d3130e0 x4 : ffffa7219cab9da0 x3 : 0000000000000000
>>> [   44.662837] x2 : 0000000000000000 x1 : ffffa7219cb7a5c0 x0 : 0000000000000000
>>> [   44.664675] Call trace:
>>> [   44.665274]  ftrace_set_filter_ip+0x24/0xa0
>>> [   44.666327]  bpf_trampoline_update.constprop.0+0x428/0x4a0
>>> [   44.667696]  __bpf_trampoline_link_prog+0xcc/0x1c0
>>> [   44.668834]  bpf_trampoline_link_prog+0x40/0x64
>>> [   44.669919]  bpf_tracing_prog_attach+0x120/0x490
>>> [   44.671011]  link_create+0xe0/0x2b0
>>> [   44.671869]  __sys_bpf+0x484/0xd30
>>> [   44.672706]  __arm64_sys_bpf+0x30/0x40
>>> [   44.673678]  invoke_syscall+0x78/0x100
>>> [   44.674623]  el0_svc_common.constprop.0+0x4c/0xf4
>>> [   44.675783]  do_el0_svc+0x38/0x4c
>>> [   44.676624]  el0_svc+0x34/0x100
>>> [   44.677429]  el0t_64_sync_handler+0x11c/0x150
>>> [   44.678532]  el0t_64_sync+0x190/0x194
>>> [   44.679439] Code: 2a0203f4 f90013f5 2a0303f5 f9001fe1 (f9400800)
>>> [   44.680959] ---[ end trace 0000000000000000 ]---
>>> [   44.682111] Kernel panic - not syncing: Oops: Fatal exception
>>> [   44.683488] SMP: stopping secondary CPUs
>>> [   44.684551] Kernel Offset: 0x2721948e0000 from 0xffff800008000000
>>> [   44.686095] PHYS_OFFSET: 0xfffff4a380000000
>>> [   44.687144] CPU features: 0x010,00022811,19001080
>>> [   44.688308] Memory Limit: none
>>> [   44.689082] ---[ end Kernel panic - not syncing: Oops: Fatal exception ]---
>>>
>>> more logs:
>>> https://s3.us-east-1.amazonaws.com/arr-cki-prod-datawarehouse-public/datawarehouse-public/2022/07/26/redhat:597047279/build_aarch64_redhat:597047279_aarch64/tests/1/results_0001/console.log/console.log
>>>
>>> https://datawarehouse.cki-project.org/kcidb/tests/4529120
>>>
>>> CKI issue tracker: https://datawarehouse.cki-project.org/issue/1434
>>>
> 
> Thanks for the report. I assume the build doesn't have
> CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS.Does the tracker have
> a link to the config file?
> 

There is no direct call on arm64 yet, so the macro can't be enabled.

>>
>> Hello,
>>
>> It's caused by a NULL tr->fops passed to ftrace_set_filter_ip:
>>
>> if (tr->func.ftrace_managed) {
>>           ftrace_set_filter_ip(tr->fops, (unsigned long)ip, 0, 0);
>>           ret = register_ftrace_direct_multi(tr->fops, (long)new_addr);
>> }
>>
>> Could you test it with the following patch?
>>
>> --- a/kernel/bpf/trampoline.c
>> +++ b/kernel/bpf/trampoline.c
>> @@ -255,8 +255,15 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
>>                   return -ENOENT;
>>
>>           if (tr->func.ftrace_managed) {
>> -               ftrace_set_filter_ip(tr->fops, (unsigned long)ip, 0, 0);
>> -               ret = register_ftrace_direct_multi(tr->fops,(long)new_addr);
>> +               if (tr->fops)
>> +                       ret = ftrace_set_filter_ip(tr->fops, (unsigned long)ip,
>> +                                                  0, 0);
>> +               else
>> +                       ret = -ENOTSUPP;
>> +
>> +               if (!ret)
>> +                       ret = register_ftrace_direct_multi(tr->fops,
>> +                                                          (long)new_addr);
>>           } else {
>>                   ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_addr);
>>           }
>>
>> Thanks.
> 
> The fix looks good to me. Thanks!
> Acked-by: Song Liu <songliubraving@fb.com>
> 
> Song
> .

