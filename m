Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9021E6404C5
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 11:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbiLBKfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 05:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232800AbiLBKfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 05:35:03 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA62C1BFB;
        Fri,  2 Dec 2022 02:35:02 -0800 (PST)
Received: from kwepemi500014.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NNq7F5ljmz15N2v;
        Fri,  2 Dec 2022 18:34:17 +0800 (CST)
Received: from [10.174.176.189] (10.174.176.189) by
 kwepemi500014.china.huawei.com (7.221.188.232) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 18:34:59 +0800
Message-ID: <52a15a3f-a288-7a7f-e9b3-1096d108e4a3@huawei.com>
Date:   Fri, 2 Dec 2022 18:34:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH] net: microchip: sparx5: Fix missing destroy_workqueue of
 mact_queue
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
References: <20221201134717.25750-1-linqiheng@huawei.com>
 <CALs4sv36FCT6uUAHM8KTGX5GwgeZGNTSLxB2cq7h-K3jxuK+HQ@mail.gmail.com>
 <CALs4sv3w4Gjs2JGr-hHh_XEXoVWJm3t27O=ezy6HEzRXuk2TwA@mail.gmail.com>
From:   Qiheng Lin <linqiheng@huawei.com>
In-Reply-To: <CALs4sv3w4Gjs2JGr-hHh_XEXoVWJm3t27O=ezy6HEzRXuk2TwA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.189]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500014.china.huawei.com (7.221.188.232)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022/12/2 18:02, Pavan Chebbi 写道:
> On Fri, Dec 2, 2022 at 1:36 PM Pavan Chebbi <pavan.chebbi@broadcom.com> wrote:
>>
>> On Thu, Dec 1, 2022 at 6:57 PM Qiheng Lin <linqiheng@huawei.com> wrote:
>>>
>>> The mchp_sparx5_probe() won't destroy workqueue created by
>>> create_singlethread_workqueue() in sparx5_start() when later
>>> inits failed. Add destroy_workqueue in the cleanup_ports case,
>>> also add it in mchp_sparx5_remove()
>>>
>>> Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
>>> ---
>>>   drivers/net/ethernet/microchip/sparx5/sparx5_main.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
>>> index eeac04b84638..b6bbb3c9bd7a 100644
>>> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
>>> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
>>> @@ -887,6 +887,8 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
>>>
>>>   cleanup_ports:
>>>          sparx5_cleanup_ports(sparx5);
>>> +       if (sparx5->mact_queue)
>>> +               destroy_workqueue(sparx5->mact_queue);
>>
>> Would be better if you destroy inside sparx5_start() before returning failure.
>>
> 
> Alternatively you could add the destroy inside sparx5_cleanup_ports()
> that will cover all error exits?

That works functionally, I have considered this modification as well. 
Since I'm not quite sure on the naming, destroying the mact_queue 
belongs to sparx5_cleanup_ports, which they don't contain now.

> 
>>>   cleanup_config:
>>>          kfree(configs);
>>>   cleanup_pnode:
>>> @@ -911,6 +913,7 @@ static int mchp_sparx5_remove(struct platform_device *pdev)
>>>          sparx5_cleanup_ports(sparx5);
>>>          /* Unregister netdevs */
>>>          sparx5_unregister_notifier_blocks(sparx5);
>>> +       destroy_workqueue(sparx5->mact_queue);
>>>
>>>          return 0;
>>>   }
>>> --
>>> 2.32.0
>>>

