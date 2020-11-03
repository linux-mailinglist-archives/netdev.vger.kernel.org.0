Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318E32A43C1
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 12:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbgKCLJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 06:09:17 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7581 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgKCLJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 06:09:16 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CQRqm0QTfzLqkX;
        Tue,  3 Nov 2020 19:09:08 +0800 (CST)
Received: from [10.174.179.62] (10.174.179.62) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Tue, 3 Nov 2020 19:09:02 +0800
Subject: Re: [PATCH] fsl/fman: add missing put_devcie() call in
 fman_port_probe()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <madalin.bucur@nxp.com>, <davem@davemloft.net>,
        <florinel.iordache@nxp.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>
References: <20201031105418.2304011-1-yukuai3@huawei.com>
 <20201102173041.7624b7fb@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <cf2e0c7c-ba3e-b04f-488d-4dd0fcb81f7a@huawei.com>
Date:   Tue, 3 Nov 2020 19:09:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20201102173041.7624b7fb@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.62]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/11/03 9:30, Jakub Kicinski wrote:
> On Sat, 31 Oct 2020 18:54:18 +0800 Yu Kuai wrote:
>> if of_find_device_by_node() succeed, fman_port_probe() doesn't have a
>> corresponding put_device(). Thus add jump target to fix the exception
>> handling for this function implementation.
>>
>> Fixes: 0572054617f3 ("fsl/fman: fix dereference null return value")
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> 
>> diff --git a/drivers/net/ethernet/freescale/fman/fman_port.c b/drivers/net/ethernet/freescale/fman/fman_port.c
>> index d9baac0dbc7d..576ce6df3fce 100644
>> --- a/drivers/net/ethernet/freescale/fman/fman_port.c
>> +++ b/drivers/net/ethernet/freescale/fman/fman_port.c
>> @@ -1799,13 +1799,13 @@ static int fman_port_probe(struct platform_device *of_dev)
>>   	of_node_put(fm_node);
>>   	if (!fm_pdev) {
>>   		err = -EINVAL;
>> -		goto return_err;
>> +		goto put_device;
>>   	}
> 
>> @@ -1898,6 +1898,8 @@ static int fman_port_probe(struct platform_device *of_dev)
>>   
>>   return_err:
>>   	of_node_put(port_node);
>> +put_device:
>> +	put_device(&fm_pdev->dev);
>>   free_port:
>>   	kfree(port);
>>   	return err;
> 
> This does not look right. You're jumping to put_device() when fm_pdev
> is NULL?
> 
Hi,

oops, it's a silly mistake. Will fix it in V2 patch.

Thanks,
Yu Kuai

> The order of error handling should be the reverse of the order of
> execution of the function.
> .
> 
