Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B661063AA4D
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 15:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiK1OBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 09:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbiK1OBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 09:01:43 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CA5B7E;
        Mon, 28 Nov 2022 06:01:41 -0800 (PST)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NLRqk517qzqSfk;
        Mon, 28 Nov 2022 21:57:38 +0800 (CST)
Received: from [10.174.176.83] (10.174.176.83) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 28 Nov 2022 22:01:39 +0800
Message-ID: <736584e7-571d-13f9-eb3e-34ce49e71e6c@huawei.com>
Date:   Mon, 28 Nov 2022 22:01:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH wireless] wifi: wilc1000: Fix UAF in wilc_netdev_cleanup()
 when iterator the RCU list
To:     Kalle Valo <kvalo@kernel.org>
CC:     <Ajay.Kathat@microchip.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <Claudiu.Beznea@microchip.com>
References: <20221124151349.2386077-1-zhangxiaoxu5@huawei.com>
 <a6d8f548-bcf4-4a02-df25-3a06aa8f2b42@microchip.com>
 <88650c25-5358-1f03-dc96-fb7fc550fb18@huawei.com> <871qpn72lw.fsf@kernel.org>
From:   "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
In-Reply-To: <871qpn72lw.fsf@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.83]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/11/28 19:14, Kalle Valo wrote:
> "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com> writes:
> 
>> On 2022/11/26 0:17, Ajay.Kathat@microchip.com wrote:
>>>
>>> On 24/11/22 20:43, Zhang Xiaoxu wrote:
>>>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>>>
>>>> There is a UAF read when remove the wilc1000_spi module:
>>>>
>>>>    BUG: KASAN: use-after-free in wilc_netdev_cleanup.cold+0xc4/0xe0 [wilc1000]
>>>>    Read of size 8 at addr ffff888116846900 by task rmmod/386
>>>>
>>>>    CPU: 2 PID: 386 Comm: rmmod Tainted: G                 N 6.1.0-rc6+ #8
>>>>    Call Trace:
>>>>     dump_stack_lvl+0x68/0x85
>>>>     print_report+0x16c/0x4a3
>>>>     kasan_report+0x95/0x190
>>>>     wilc_netdev_cleanup.cold+0xc4/0xe0
>>>>     wilc_bus_remove+0x52/0x60
>>>>     spi_remove+0x46/0x60
>>>>     device_remove+0x73/0xc0
>>>>     device_release_driver_internal+0x12d/0x210
>>>>     driver_detach+0x84/0x100
>>>>     bus_remove_driver+0x90/0x120
>>>>     driver_unregister+0x4f/0x80
>>>>     __x64_sys_delete_module+0x2fc/0x440
>>>>     do_syscall_64+0x38/0x90
>>>>     entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>>>
>>>> Since set 'needs_free_netdev=true' when initialize the net device, the
>>>> net device will be freed when unregister, then use the freed 'vif' to
>>>> find the next will UAF read.
>>>
>>>
>>> Did you test this behaviour on the real device. I am seeing a kernel
>>> crash when the module is unloaded after the connection with an AP.
>>
>> Thanks Ajay, I have no real device, what kind of crash about your
>> scenario?
> 
> If you don't have a real device to test on, please state that clearly in
> the commit log. For example, "Compile tested only" or something like
> that.
Thanks Kalle,

I found this problem with a bpf mock device, and test this patch use
the same way.
> 
> We get way too much untested patches where there's no indication that
> they have had no testing. I'm really concerned about this trend, I'm
> even considering should I just start dropping these kind of untested
> cleanup patches?
>
