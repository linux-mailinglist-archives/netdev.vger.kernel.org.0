Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9999610C70
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 10:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiJ1IoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 04:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiJ1IoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 04:44:05 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D78B1C4EDE;
        Fri, 28 Oct 2022 01:44:03 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MzGDb0znJzVjDN;
        Fri, 28 Oct 2022 16:39:11 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 28 Oct 2022 16:44:00 +0800
Message-ID: <b14fbd79-31e6-3409-e4f3-dae675219e1b@huawei.com>
Date:   Fri, 28 Oct 2022 16:44:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net] can: af_can: fix NULL pointer dereference in
 can_rx_register()
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <socketcan@hartkopp.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@rempel-privat.de>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
References: <20221028033342.173528-1-shaozhengchao@huawei.com>
 <20221028073339.hx5pyysuyzhdj64q@pengutronix.de>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <20221028073339.hx5pyysuyzhdj64q@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/10/28 15:33, Marc Kleine-Budde wrote:
> On 28.10.2022 11:33:42, Zhengchao Shao wrote:
>> It causes NULL pointer dereference when testing as following:
>> (a) use syscall(__NR_socket, 0x10ul, 3ul, 0) to create netlink socket.
>> (b) use syscall(__NR_sendmsg, ...) to create bond link device and vxcan
>>      link device, and bind vxcan device to bond device (can also use
>>      ifenslave command to bind vxcan device to bond device).
>> (c) use syscall(__NR_socket, 0x1dul, 3ul, 1) to create CAN socket.
>> (d) use syscall(__NR_bind, ...) to bind the bond device to CAN socket.
>>
>> The bond device invokes the can-raw protocol registration interface to
>> receive CAN packets. However, ml_priv is not allocated to the dev,
>> dev_rcv_lists is assigned to NULL in can_rx_register(). In this case,
>> it will occur the NULL pointer dereference issue.
>>
>> The following is the stack information:
>> BUG: kernel NULL pointer dereference, address: 0000000000000008
>> PGD 122a4067 P4D 122a4067 PUD 1223c067 PMD 0
>> Oops: 0000 [#1] PREEMPT SMP
>> RIP: 0010:can_rx_register+0x12d/0x1e0
>> Call Trace:
>> <TASK>
>> raw_enable_filters+0x8d/0x120
>> raw_enable_allfilters+0x3b/0x130
>> raw_bind+0x118/0x4f0
>> __sys_bind+0x163/0x1a0
>> __x64_sys_bind+0x1e/0x30
>> do_syscall_64+0x35/0x80
>> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> </TASK>
>>
>> Fixes: 4e096a18867a ("net: introduce CAN specific pointer in the struct net_device")
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> ---
>>   net/can/af_can.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/can/af_can.c b/net/can/af_can.c
>> index 9503ab10f9b8..ef2697f3ebcb 100644
>> --- a/net/can/af_can.c
>> +++ b/net/can/af_can.c
>> @@ -450,7 +450,7 @@ int can_rx_register(struct net *net, struct net_device *dev, canid_t can_id,
>>   
>>   	/* insert new receiver  (dev,canid,mask) -> (func,data) */
>>   
>> -	if (dev && dev->type != ARPHRD_CAN)
>> +	if (dev && (dev->type != ARPHRD_CAN || dev->ml_priv_type != ML_PRIV_CAN))
> 
> You can use the helper function: can_get_ml_priv() instead of open
> coding the check.
> 
> Reviewed-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> regards,
> Marc
> 
Hi Marc:
	Thank you for your review. And I will fix it in V2.

Zhengchao Shao
