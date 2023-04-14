Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551AD6E21A6
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 13:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjDNLF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 07:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjDNLFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 07:05:54 -0400
Received: from mail-m11875.qiye.163.com (mail-m11875.qiye.163.com [115.236.118.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B3F526F;
        Fri, 14 Apr 2023 04:05:36 -0700 (PDT)
Received: from [0.0.0.0] (unknown [172.96.223.238])
        by mail-m11875.qiye.163.com (Hmail) with ESMTPA id C45BC280AB2;
        Fri, 14 Apr 2023 19:04:02 +0800 (CST)
Message-ID: <a7cb0d9e-7519-f90c-bd58-eab9ee82b3dc@sangfor.com.cn>
Date:   Fri, 14 Apr 2023 19:03:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC PATCH net] sfc: Fix use-after-free due to selftest_work
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ecree.xilinx@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pengdonglin@sangfor.com.cn,
        huangcun@sangfor.com.cn
References: <20230412005013.30456-1-dinghui@sangfor.com.cn>
 <ZDew+TqjrcK+zSgW@gmail.com>
 <7a1de6be-8956-b1d5-6351-c7c2fb3bf9f4@sangfor.com.cn>
 <ZDkgm/Ub/zXIU7+p@gmail.com>
Content-Language: en-US
From:   Ding Hui <dinghui@sangfor.com.cn>
In-Reply-To: <ZDkgm/Ub/zXIU7+p@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCSEodVk4dSxlJSUJKShpKQ1UTARMWGhIXJBQOD1
        lXWRgSC1lBWUpMSVVCTVVJSUhVSUhDWVdZFhoPEhUdFFlBWU9LSFVKSktISkNVSktLVUtZBg++
X-HM-Tid: 0a877f6fd0462eb1kusnc45bc280ab2
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OBQ6USo5Lz0VMBo4SipWNhhP
        AVFPCzZVSlVKTUNKT0xLSU9MQ01MVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlKTElVQk1VSUlIVUlIQ1lXWQgBWUFOSE5PNwY+
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/14 17:44, Martin Habets wrote:
> On Thu, Apr 13, 2023 at 04:35:08PM +0800, Ding Hui wrote:
>> On 2023/4/13 15:37, Martin Habets wrote:
>>> On Wed, Apr 12, 2023 at 08:50:13AM +0800, Ding Hui wrote:
>>>> There is a use-after-free scenario that is:
>>>>
>>>> When netif_running() is false, user set mac address or vlan tag to VF,
>>>> the xxx_set_vf_mac() or xxx_set_vf_vlan() will invoke efx_net_stop()
>>>> and efx_net_open(), since netif_running() is false, the port will not
>>>> start and keep port_enabled false, but selftest_worker is scheduled
>>>> in efx_net_open().
>>>>
>>>> If we remove the device before selftest_worker run, the efx is freed,
>>>> then we will get a UAF in run_timer_softirq() like this:
>>>>
>>>> [ 1178.907941] ==================================================================
>>>> [ 1178.907948] BUG: KASAN: use-after-free in run_timer_softirq+0xdea/0xe90
>>>> [ 1178.907950] Write of size 8 at addr ff11001f449cdc80 by task swapper/47/0
>>>> [ 1178.907950]
>>>> [ 1178.907953] CPU: 47 PID: 0 Comm: swapper/47 Kdump: loaded Tainted: G           O     --------- -t - 4.18.0 #1
>>>> [ 1178.907954] Hardware name: SANGFOR X620G40/WI2HG-208T1061A, BIOS SPYH051032-U01 04/01/2022
>>>> [ 1178.907955] Call Trace:
>>>> [ 1178.907956]  <IRQ>
>>>> [ 1178.907960]  dump_stack+0x71/0xab
>>>> [ 1178.907963]  print_address_description+0x6b/0x290
>>>> [ 1178.907965]  ? run_timer_softirq+0xdea/0xe90
>>>> [ 1178.907967]  kasan_report+0x14a/0x2b0
>>>> [ 1178.907968]  run_timer_softirq+0xdea/0xe90
>>>> [ 1178.907971]  ? init_timer_key+0x170/0x170
>>>> [ 1178.907973]  ? hrtimer_cancel+0x20/0x20
>>>> [ 1178.907976]  ? sched_clock+0x5/0x10
>>>> [ 1178.907978]  ? sched_clock_cpu+0x18/0x170
>>>> [ 1178.907981]  __do_softirq+0x1c8/0x5fa
>>>> [ 1178.907985]  irq_exit+0x213/0x240
>>>> [ 1178.907987]  smp_apic_timer_interrupt+0xd0/0x330
>>>> [ 1178.907989]  apic_timer_interrupt+0xf/0x20
>>>> [ 1178.907990]  </IRQ>
>>>> [ 1178.907991] RIP: 0010:mwait_idle+0xae/0x370
>>>>
>>>> I am thinking about several ways to fix the issue:
>>>>
>>>> [1] In this RFC, I cancel the selftest_worker unconditionally in
>>>> efx_pci_remove().
>>>>
>>>> [2] Add a test condition, only invoke efx_selftest_async_start() when
>>>> efx->port_enabled is true in efx_net_open().
>>>>
>>>> [3] Move invoking efx_selftest_async_start() from efx_net_open() to
>>>> efx_start_all() or efx_start_port(), that matching cancel action in
>>>> efx_stop_port().
>>>
>>> I think moving this to efx_start_port() is best, as you say to match
>>> the cancel in efx_stop_port().
>>>
>>
>> If moving to efx_start_port(), should we worry about that IRQ_TIMEOUT
>> is still enough?
> 
> 1 second is a long time for a machine running code, so it does not worry me.
> 
>> I'm not sure if there is a long time waiting from starting of schedule
>> selftest_work to the ending of efx_net_open().
> 
> I see your point. Looking at efx_start_all() there is the call to
> efx_start_datapath() after the call to efx_net_open(), which takes a
                                          ^^^^^^^^^^^^
Do you mean efx_start_port()?

> relatively long time (well under 200ms though).
> Logically it would be better to move efx_selftest_async_start() after this
> call. What do you think?

Agree with you.

> The point here is that efx_start_all() calls efx_start_port() early, and
> efx_stop_all() also calls efx_stop_port() early. The calling sequence is
> correct but they are not the strict inverse of each other.
> 

Yeah, that is what I noticed monitor_work does.
Then I'll move efx_selftest_async_start() into efx_start_all(), follows
the monitor_work.

-- 
Thanks,
- Ding Hui

