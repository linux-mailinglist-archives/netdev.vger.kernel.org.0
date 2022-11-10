Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB16623F5B
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 11:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiKJKEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 05:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiKJKEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 05:04:41 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD166AECA
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 02:04:39 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N7HVv4Dd4zmVqt;
        Thu, 10 Nov 2022 18:04:23 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 18:04:37 +0800
Message-ID: <2476fb5b-8fc5-f661-691d-04f3b874256a@huawei.com>
Date:   Thu, 10 Nov 2022 18:04:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net] net: liquidio: release resources when liquidio driver
 open failed
To:     Leon Romanovsky <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <dchickles@marvell.com>,
        <sburla@marvell.com>, <fmanlunas@marvell.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <rvatsavayi@caviumnetworks.com>, <gregkh@linuxfoundation.org>,
        <tseewald@gmail.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
References: <20221110013116.270258-1-shaozhengchao@huawei.com>
 <Y2zII4SL4tlwfVi/@unreal>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <Y2zII4SL4tlwfVi/@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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



On 2022/11/10 17:45, Leon Romanovsky wrote:
> On Thu, Nov 10, 2022 at 09:31:16AM +0800, Zhengchao Shao wrote:
>> When liquidio driver open failed, it doesn't release resources. Compile
>> tested only.
>>
>> Fixes: 5b07aee11227 ("liquidio: MSIX support for CN23XX")
>> Fixes: dbc97bfd3918 ("net: liquidio: Add missing null pointer checks")
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> ---
>>   .../net/ethernet/cavium/liquidio/lio_main.c   | 40 ++++++++++++++++---
>>   1 file changed, 34 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
>> index d312bd594935..713689cf212c 100644
>> --- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
>> +++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
>> @@ -1795,12 +1795,15 @@ static int liquidio_open(struct net_device *netdev)
>>   	ifstate_set(lio, LIO_IFSTATE_RUNNING);
>>   
>>   	if (OCTEON_CN23XX_PF(oct)) {
>> -		if (!oct->msix_on)
>> -			if (setup_tx_poll_fn(netdev))
>> -				return -1;
>> +		if (!oct->msix_on) {
>> +			ret = setup_tx_poll_fn(netdev);
>> +			if (ret)
>> +				goto err_poll;
>> +		}
>>   	} else {
>> -		if (setup_tx_poll_fn(netdev))
>> -			return -1;
>> +		ret = setup_tx_poll_fn(netdev);
>> +		if (ret)
>> +			goto err_poll;
>>   	}
> 
> Instead of this hairy code, you can squeeze everything into one if:
> 
> if (!OCTEON_CN23XX_PF(oct) || (OCTEON_CN23XX_PF(oct) && oct->msix_on)) {
>    ret = setup_tx_poll_fn(netdev);
>    if (ret)
>       ,,,
> 
> Thanks
Hi Leon：
	Thank you for your suggestion. I will modify it in V2.

Zhengchao Shao
