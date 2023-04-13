Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40056E0387
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 03:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjDMBNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 21:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjDMBNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 21:13:13 -0400
Received: from mail-m11875.qiye.163.com (mail-m11875.qiye.163.com [115.236.118.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525A6469E;
        Wed, 12 Apr 2023 18:13:11 -0700 (PDT)
Received: from [0.0.0.0] (unknown [172.96.223.238])
        by mail-m11875.qiye.163.com (Hmail) with ESMTPA id EE365280297;
        Thu, 13 Apr 2023 09:13:00 +0800 (CST)
Message-ID: <60e87b7e-7b82-0d21-408f-157d22822e72@sangfor.com.cn>
Date:   Thu, 13 Apr 2023 09:12:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [RFC PATCH net] sfc: Fix use-after-free due to selftest_work
Content-Language: en-US
To:     Jacob Keller <jacob.e.keller@intel.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pengdonglin@sangfor.com.cn, huangcun@sangfor.com.cn
References: <20230412005013.30456-1-dinghui@sangfor.com.cn>
 <30e4bf50-7950-0b3c-67b5-6028b7114da2@intel.com>
From:   Ding Hui <dinghui@sangfor.com.cn>
In-Reply-To: <30e4bf50-7950-0b3c-67b5-6028b7114da2@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCHk8fVkJIGENMHx1MT0NLTlUTARMWGhIXJBQOD1
        lXWRgSC1lBWUpMSVVCTVVJSUhVSUhDWVdZFhoPEhUdFFlBWU9LSFVKSktISkNVSktLVUtZBg++
X-HM-Tid: 0a87782c5c262eb1kusnee365280297
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MjY6CCo*AT0JPC0NIx09KzAR
        F0tPCklVSlVKTUNKSE9DSENNQkxKVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
        QVlKTElVQk1VSUlIVUlIQ1lXWQgBWUFOTE9NNwY+
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/13 6:34, Jacob Keller wrote:
> 
> 
> On 4/11/2023 5:50 PM, Ding Hui wrote:
>> There is a use-after-free scenario that is:
>>
>> When netif_running() is false, user set mac address or vlan tag to VF,
>> the xxx_set_vf_mac() or xxx_set_vf_vlan() will invoke efx_net_stop()
>> and efx_net_open(), since netif_running() is false, the port will not
>> start and keep port_enabled false, but selftest_worker is scheduled
>> in efx_net_open().
>>
>> If we remove the device before selftest_worker run, the efx is freed,
>> then we will get a UAF in run_timer_softirq() like this:
>>
>> [ 1178.907941] ==================================================================
>> [ 1178.907948] BUG: KASAN: use-after-free in run_timer_softirq+0xdea/0xe90
>> [ 1178.907950] Write of size 8 at addr ff11001f449cdc80 by task swapper/47/0
>> [ 1178.907950]
>> [ 1178.907953] CPU: 47 PID: 0 Comm: swapper/47 Kdump: loaded Tainted: G           O     --------- -t - 4.18.0 #1
>> [ 1178.907954] Hardware name: SANGFOR X620G40/WI2HG-208T1061A, BIOS SPYH051032-U01 04/01/2022
>> [ 1178.907955] Call Trace:
>> [ 1178.907956]  <IRQ>
>> [ 1178.907960]  dump_stack+0x71/0xab
>> [ 1178.907963]  print_address_description+0x6b/0x290
>> [ 1178.907965]  ? run_timer_softirq+0xdea/0xe90
>> [ 1178.907967]  kasan_report+0x14a/0x2b0
>> [ 1178.907968]  run_timer_softirq+0xdea/0xe90
>> [ 1178.907971]  ? init_timer_key+0x170/0x170
>> [ 1178.907973]  ? hrtimer_cancel+0x20/0x20
>> [ 1178.907976]  ? sched_clock+0x5/0x10
>> [ 1178.907978]  ? sched_clock_cpu+0x18/0x170
>> [ 1178.907981]  __do_softirq+0x1c8/0x5fa
>> [ 1178.907985]  irq_exit+0x213/0x240
>> [ 1178.907987]  smp_apic_timer_interrupt+0xd0/0x330
>> [ 1178.907989]  apic_timer_interrupt+0xf/0x20
>> [ 1178.907990]  </IRQ>
>> [ 1178.907991] RIP: 0010:mwait_idle+0xae/0x370
>>
>> I am thinking about several ways to fix the issue:
>>
>> [1] In this RFC, I cancel the selftest_worker unconditionally in
>> efx_pci_remove().
>>
>> [2] Add a test condition, only invoke efx_selftest_async_start() when
>> efx->port_enabled is true in efx_net_open().
>>
>> [3] Move invoking efx_selftest_async_start() from efx_net_open() to
>> efx_start_all() or efx_start_port(), that matching cancel action in
>> efx_stop_port().
>>
>> [4] However, I also notice that in efx_ef10_set_mac_address(), the
>> efx_net_open() depends on original port_enabled, but others are not,
>> if we change all efx_net_open() depends on old state like
>> efx_ef10_set_mac_address() does, the UAF can also be fixed in theory.
>>
>> But I'm not sure which is better, is there any suggestions? Thanks.
>>
> 
> I think this fix makes the most sense to me.
> 
>> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
>> ---
> 
> net patches need a Fixes tag indicating what commit this fixes. This
> being RFC is likely why that was left off?
> 

Thanks.

The commit dd40781e3a4e ("sfc: Run event/IRQ self-test asynchronously 
when interface is brought up") add efx_selftest_async_start() into
efx_net_open(), it was okay then since efx_net_open() was only invoked
by the callback. Base on the original purpose of this commit, the
way [2][3] makes sense.

The commit e340be923012 ("sfc: add ndo_set_vf_mac() function for EF10")
first add efx_ef10_sriov_set_vf_mac(), it invoke efx_net_open(), then
this UAF scenario started.

I'll remove RFC and add Fixes in v2.

Fixes: e340be923012 ("sfc: add ndo_set_vf_mac() function for EF10")

>>   drivers/net/ethernet/sfc/efx.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
>> index 884d8d168862..dd0b2363eed1 100644
>> --- a/drivers/net/ethernet/sfc/efx.c
>> +++ b/drivers/net/ethernet/sfc/efx.c
>> @@ -876,6 +876,8 @@ static void efx_pci_remove(struct pci_dev *pci_dev)
>>   	efx->state = STATE_UNINIT;
>>   	rtnl_unlock();
>>   
>> +	efx_selftest_async_cancel(efx);
>> +
>>   	if (efx->type->sriov_fini)
>>   		efx->type->sriov_fini(efx);
>>   
> 

-- 
Thanks,
- Ding Hui

