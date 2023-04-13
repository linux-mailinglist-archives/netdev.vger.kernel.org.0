Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A876E08AA
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 10:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjDMIME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 04:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjDMIMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 04:12:02 -0400
Received: from mail-m11875.qiye.163.com (mail-m11875.qiye.163.com [115.236.118.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141C05FC6;
        Thu, 13 Apr 2023 01:11:55 -0700 (PDT)
Received: from [0.0.0.0] (unknown [172.96.223.238])
        by mail-m11875.qiye.163.com (Hmail) with ESMTPA id 2212A280D4D;
        Thu, 13 Apr 2023 16:11:46 +0800 (CST)
Message-ID: <3921e44e-3cb4-4016-5e6b-1dd52656b7a6@sangfor.com.cn>
Date:   Thu, 13 Apr 2023 16:11:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [RFC PATCH net] sfc: Fix use-after-free due to selftest_work
Content-Language: en-US
To:     Jacob Keller <jacob.e.keller@intel.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ecree.xilinx@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pengdonglin@sangfor.com.cn,
        huangcun@sangfor.com.cn
References: <20230412005013.30456-1-dinghui@sangfor.com.cn>
 <30e4bf50-7950-0b3c-67b5-6028b7114da2@intel.com> <ZDe02xqrX/pP0vEN@gmail.com>
From:   Ding Hui <dinghui@sangfor.com.cn>
In-Reply-To: <ZDe02xqrX/pP0vEN@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCHR9CVkoeSxgeSkpKGRhIHlUTARMWGhIXJBQOD1
        lXWRgSC1lBWUpMSVVCTVVJSUhVSUhDWVdZFhoPEhUdFFlBWU9LSFVKSktPSEhVSktLVUtZBg++
X-HM-Tid: 0a8779abbf712eb1kusn2212a280d4d
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nkk6ISo*UT0QLCw1TTgwEhNW
        Ey8KFCFVSlVKTUNKSExITkpJT0lLVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlKTElVQk1VSUlIVUlIQ1lXWQgBWUFPQ01MNwY+
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/13 15:52, Martin Habets wrote:
> On Wed, Apr 12, 2023 at 03:34:51PM -0700, Jacob Keller wrote:
>>
>>
>> On 4/11/2023 5:50 PM, Ding Hui wrote:
>>> There is a use-after-free scenario that is:
>>>
>>> When netif_running() is false, user set mac address or vlan tag to VF,
>>> the xxx_set_vf_mac() or xxx_set_vf_vlan() will invoke efx_net_stop()
>>> and efx_net_open(), since netif_running() is false, the port will not
>>> start and keep port_enabled false, but selftest_worker is scheduled
>>> in efx_net_open().
>>>
>>> If we remove the device before selftest_worker run, the efx is freed,
>>> then we will get a UAF in run_timer_softirq() like this:
>>>
>>> [ 1178.907941] ==================================================================
>>> [ 1178.907948] BUG: KASAN: use-after-free in run_timer_softirq+0xdea/0xe90
>>> [ 1178.907950] Write of size 8 at addr ff11001f449cdc80 by task swapper/47/0
>>> [ 1178.907950]
>>> [ 1178.907953] CPU: 47 PID: 0 Comm: swapper/47 Kdump: loaded Tainted: G           O     --------- -t - 4.18.0 #1
>>> [ 1178.907954] Hardware name: SANGFOR X620G40/WI2HG-208T1061A, BIOS SPYH051032-U01 04/01/2022
>>> [ 1178.907955] Call Trace:
>>> [ 1178.907956]  <IRQ>
>>> [ 1178.907960]  dump_stack+0x71/0xab
>>> [ 1178.907963]  print_address_description+0x6b/0x290
>>> [ 1178.907965]  ? run_timer_softirq+0xdea/0xe90
>>> [ 1178.907967]  kasan_report+0x14a/0x2b0
>>> [ 1178.907968]  run_timer_softirq+0xdea/0xe90
>>> [ 1178.907971]  ? init_timer_key+0x170/0x170
>>> [ 1178.907973]  ? hrtimer_cancel+0x20/0x20
>>> [ 1178.907976]  ? sched_clock+0x5/0x10
>>> [ 1178.907978]  ? sched_clock_cpu+0x18/0x170
>>> [ 1178.907981]  __do_softirq+0x1c8/0x5fa
>>> [ 1178.907985]  irq_exit+0x213/0x240
>>> [ 1178.907987]  smp_apic_timer_interrupt+0xd0/0x330
>>> [ 1178.907989]  apic_timer_interrupt+0xf/0x20
>>> [ 1178.907990]  </IRQ>
>>> [ 1178.907991] RIP: 0010:mwait_idle+0xae/0x370
>>>
>>> I am thinking about several ways to fix the issue:
>>>
>>> [1] In this RFC, I cancel the selftest_worker unconditionally in
>>> efx_pci_remove().
>>>
>>> [2] Add a test condition, only invoke efx_selftest_async_start() when
>>> efx->port_enabled is true in efx_net_open().
>>>
>>> [3] Move invoking efx_selftest_async_start() from efx_net_open() to
>>> efx_start_all() or efx_start_port(), that matching cancel action in
>>> efx_stop_port().
>>>
>>> [4] However, I also notice that in efx_ef10_set_mac_address(), the
>>> efx_net_open() depends on original port_enabled, but others are not,
>>> if we change all efx_net_open() depends on old state like
>>> efx_ef10_set_mac_address() does, the UAF can also be fixed in theory.
>>>
>>> But I'm not sure which is better, is there any suggestions? Thanks.
>>>
>>
>> I think this fix makes the most sense to me.
> 
> For me this is too late. It leaves a gap where the selftest timer is still running
> but the NIC has already stopped sending events. So we could still get a
> failure "channel %d timed out waiting for event queue" from the selftest.
> 

Yes, assuming not consider removing, scheduled selftest_work if NIC not
brought up actually, we will also get this failure log.

-- 
Thanks,
- Ding Hui




