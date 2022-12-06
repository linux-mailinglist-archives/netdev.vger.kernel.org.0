Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA16643A6B
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 01:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbiLFArZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 19:47:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233171AbiLFArC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 19:47:02 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D3C1F2FF
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 16:46:55 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NR1tk3vL4z15N5d;
        Tue,  6 Dec 2022 08:46:06 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 6 Dec 2022 08:46:53 +0800
Message-ID: <7988ace0-a5a8-8a2f-44e3-f406cd7a33ac@huawei.com>
Date:   Tue, 6 Dec 2022 08:46:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net] net: thunderbolt: fix memory leak in tbnet_open()
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
CC:     <netdev@vger.kernel.org>, <michael.jamet@intel.com>,
        <YehezkelShB@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
References: <20221205115559.3189177-1-shaozhengchao@huawei.com>
 <Y430Od5z5gNI2p0G@black.fi.intel.com>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <Y430Od5z5gNI2p0G@black.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/12/5 21:38, Mika Westerberg wrote:
> Hi,
> 
> On Mon, Dec 05, 2022 at 07:55:59PM +0800, Zhengchao Shao wrote:
>> When tb_ring_alloc_rx() failed in tbnet_open(), it doesn't free ida.
>>
>> Fixes: 180b0689425c ("thunderbolt: Allow multiple DMA tunnels over a single XDomain connection")
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> ---
>>   drivers/net/thunderbolt.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
>> index a52ee2bf5575..70fd61ce15c6 100644
>> --- a/drivers/net/thunderbolt.c
>> +++ b/drivers/net/thunderbolt.c
>> @@ -916,6 +916,7 @@ static int tbnet_open(struct net_device *dev)
>>   		netdev_err(dev, "failed to allocate Rx ring\n");
>>   		tb_ring_free(net->tx_ring.ring);
>>   		net->tx_ring.ring = NULL;
>> +		tb_xdomain_release_out_hopid(xd, hopid);
> 
> Can you move this before tb_ring_free()? Like this:
> 
>    		netdev_err(dev, "failed to allocate Rx ring\n");
>   		tb_xdomain_release_out_hopid(xd, hopid);
>    		tb_ring_free(net->tx_ring.ring);
>    		net->tx_ring.ring = NULL;
> 
> Otherwise looks good to me.
> 
Hi Mika:
	Thank you for your advice. I will send V2.

Zhengchao Shao
