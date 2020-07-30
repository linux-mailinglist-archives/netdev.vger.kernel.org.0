Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F5E232BDA
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 08:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgG3GTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 02:19:07 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56416 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726261AbgG3GTH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 02:19:07 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5D9573CC320AB1973E5C;
        Thu, 30 Jul 2020 14:19:04 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.81) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Thu, 30 Jul 2020
 14:19:03 +0800
Subject: Re: [PATCH net-next] liquidio: Remove unneeded cast from memory
 allocation
To:     Joe Perches <joe@perches.com>, <dchickles@marvell.com>,
        <sburla@marvell.com>, <fmanlunas@marvell.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200724130001.71528-1-wanghai38@huawei.com>
 <2cdef8d442bb5da39aed17bf994a800e768942f7.camel@perches.com>
 <ac99bed4-dabc-a003-374f-206753f937cb@huawei.com>
 <bffcc7d513e186734d224bda6afdd55033b451de.camel@perches.com>
 <2996569e-5e1a-db02-2c78-0ee0d572706d@huawei.com>
 <4299fe666c93018a9a047575e5d68a0bb4dd269f.camel@perches.com>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <192edb77-b811-7ec2-9722-a767fd29cdf0@huawei.com>
Date:   Thu, 30 Jul 2020 14:19:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <4299fe666c93018a9a047575e5d68a0bb4dd269f.camel@perches.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.81]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2020/7/28 23:54, Joe Perches Ð´µÀ:
> On Tue, 2020-07-28 at 21:38 +0800, wanghai (M) wrote:
>> Thanks for your explanation. I got it.
>>
>> Can it be modified like this?
> []
>> +++ b/drivers/net/ethernet/cavium/liquidio/octeon_device.c
>> @@ -1152,11 +1152,8 @@ octeon_register_dispatch_fn(struct octeon_device
>> *oct,
>>
>>                   dev_dbg(&oct->pci_dev->dev,
>>                           "Adding opcode to dispatch list linked list\n");
>> -               dispatch = (struct octeon_dispatch *)
>> -                          vmalloc(sizeof(struct octeon_dispatch));
>> +               dispatch = kmalloc(sizeof(struct octeon_dispatch),
>> GFP_KERNEL);
>>                   if (!dispatch) {
>> -                       dev_err(&oct->pci_dev->dev,
>> -                               "No memory to add dispatch function\n");
>>                           return 1;
>>                   }
>>                   dispatch->opcode = combined_opcode;
> Yes, but the free also needs to be changed.
>
> I think it's:
> ---
>   drivers/net/ethernet/cavium/liquidio/octeon_device.c | 11 ++++-------
>   1 file changed, 4 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_device.c b/drivers/net/ethernet/cavium/liquidio/octeon_device.c
> index 934115d18488..4ee4cb946e1d 100644
> --- a/drivers/net/ethernet/cavium/liquidio/octeon_device.c
> +++ b/drivers/net/ethernet/cavium/liquidio/octeon_device.c
> @@ -1056,7 +1056,7 @@ void octeon_delete_dispatch_list(struct octeon_device *oct)
>   
>   	list_for_each_safe(temp, tmp2, &freelist) {
>   		list_del(temp);
> -		vfree(temp);
> +		kfree(temp);
>   	}
>   }
>   
> @@ -1152,13 +1152,10 @@ octeon_register_dispatch_fn(struct octeon_device *oct,
>   
>   		dev_dbg(&oct->pci_dev->dev,
>   			"Adding opcode to dispatch list linked list\n");
> -		dispatch = (struct octeon_dispatch *)
> -			   vmalloc(sizeof(struct octeon_dispatch));
> -		if (!dispatch) {
> -			dev_err(&oct->pci_dev->dev,
> -				"No memory to add dispatch function\n");
> +		dispatch = kmalloc(sizeof(struct octeon_dispatch), GFP_KERNEL);
> +		if (!dispatch)
>   			return 1;
> -		}
> +
>   		dispatch->opcode = combined_opcode;
>   		dispatch->dispatch_fn = fn;
>   		dispatch->arg = fn_arg;
>
>
>
> .
Thanks for your suggestion. I just sent another patch for this.

"[PATCH net-next] liquidio: Replace vmalloc with kmalloc in 
octeon_register_dispatch_fn()"

>

