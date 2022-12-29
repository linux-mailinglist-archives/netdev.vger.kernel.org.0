Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8327658F15
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 17:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbiL2Qeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 11:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbiL2Qea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 11:34:30 -0500
Received: from smtp.smtpout.orange.fr (smtp-25.smtpout.orange.fr [80.12.242.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E3A11C26
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 08:34:27 -0800 (PST)
Received: from [192.168.1.18] ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id AvrKpnmhptht4AvrKpvTPn; Thu, 29 Dec 2022 17:34:25 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 29 Dec 2022 17:34:25 +0100
X-ME-IP: 86.243.100.34
Message-ID: <437145bf-d925-e91e-affd-835d272c55a0@wanadoo.fr>
Date:   Thu, 29 Dec 2022 17:34:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net] fjes: Fix an error handling path in fjes_probe()
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
References: <fde673f106d2b264ad76759195901aae94691b5c.1671569785.git.christophe.jaillet@wanadoo.fr>
 <Y6LZEVU7tKPzjHQ8@localhost.localdomain>
Content-Language: fr, en-US
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <Y6LZEVU7tKPzjHQ8@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 21/12/2022 à 10:59, Michal Swiatkowski a écrit :
> On Tue, Dec 20, 2022 at 09:57:06PM +0100, Christophe JAILLET wrote:
>> A netif_napi_add() call is hidden in fjes_sw_init(). It should be undone
>> by a corresponding netif_napi_del() call in the error handling path of the
>> probe, as already done inthe remove function.
>>
>> Fixes: 265859309a76 ("fjes: NAPI polling function")
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>>   drivers/net/fjes/fjes_main.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
>> index 2513be6d4e11..01b4c9c6adbd 100644
>> --- a/drivers/net/fjes/fjes_main.c
>> +++ b/drivers/net/fjes/fjes_main.c
>> @@ -1370,7 +1370,7 @@ static int fjes_probe(struct platform_device *plat_dev)
>>   	adapter->txrx_wq = alloc_workqueue(DRV_NAME "/txrx", WQ_MEM_RECLAIM, 0);
>>   	if (unlikely(!adapter->txrx_wq)) {
>>   		err = -ENOMEM;
>> -		goto err_free_netdev;
>> +		goto err_del_napi;
>>   	}
>>   
>>   	adapter->control_wq = alloc_workqueue(DRV_NAME "/control",
>> @@ -1431,6 +1431,8 @@ static int fjes_probe(struct platform_device *plat_dev)
>>   	destroy_workqueue(adapter->control_wq);
>>   err_free_txrx_wq:
>>   	destroy_workqueue(adapter->txrx_wq);
>> +err_del_napi:
>> +	netif_napi_del(&adapter->napi);
>>   err_free_netdev:
>>   	free_netdev(netdev);
>>   err_out:
> 
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> 
> I wonder if it won't be better to have fjes_sw_deinit() instead or
> change fjes_sw_init to only netif_napi_add(). You know, to avoid another
> bug here when someone add sth to the fjes_sw_deinit(). This is only
> suggestion, patch looks fine.

hi,

based on Jakub's comment [1], free_netdev() already cleans up NAPIs (see 
[2]).

So would it make more sense to remove netif_napi_del() from the 
.remove() function instead?
The call looks useless to me now.

CJ

[1]: https://lore.kernel.org/all/20221221174043.1191996a@kernel.org/
[2]: https://elixir.bootlin.com/linux/v6.2-rc1/source/net/core/dev.c#L10710

> 
>> -- 
>> 2.34.1
>>
> 

