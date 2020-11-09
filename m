Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69942AB9AA
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 14:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732364AbgKINLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 08:11:23 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7161 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732340AbgKINLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 08:11:22 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CVBFs2S2Nz15SjZ;
        Mon,  9 Nov 2020 21:11:13 +0800 (CST)
Received: from [10.174.179.62] (10.174.179.62) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Mon, 9 Nov 2020 21:11:12 +0800
Subject: Re: [PATCH V3] fsl/fman: add missing put_devcie() call in
 fman_port_probe()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <madalin.bucur@nxp.com>, <davem@davemloft.net>,
        <florinel.iordache@nxp.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>
References: <20201103112323.1077040-1-yukuai3@huawei.com>
 <20201107090925.1494578-1-yukuai3@huawei.com>
 <20201107140953.1f04c04e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <0efa4731-67d7-fe7a-54ab-a3d3493ad936@huawei.com>
Date:   Mon, 9 Nov 2020 21:11:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20201107140953.1f04c04e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.62]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ÔÚ 2020/11/08 6:09, Jakub Kicinski Ð´µÀ:
> On Sat, 7 Nov 2020 17:09:25 +0800 Yu Kuai wrote:
>> if of_find_device_by_node() succeed, fman_port_probe() doesn't have a
>> corresponding put_device(). Thus add jump target to fix the exception
>> handling for this function implementation.
>>
>> Fixes: 0572054617f3 ("fsl/fman: fix dereference null return value")
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> 
>> @@ -1792,20 +1792,20 @@ static int fman_port_probe(struct platform_device *of_dev)
>>   	if (!fm_node) {
>>   		dev_err(port->dev, "%s: of_get_parent() failed\n", __func__);
>>   		err = -ENODEV;
>> -		goto return_err;
>> +		goto free_port;
> 
> And now you no longer put port_node if jumping from here...

Sincerely apologize for that stupid mistake...

> 
> Also does the reference to put_device() not have to be released when
> this function succeeds?
> 

I'm not sure about that, since fman_port_driver doesn't define other
interface, maybe it reasonable to release it here.

>>   	}
> 
>> @@ -1896,7 +1895,9 @@ static int fman_port_probe(struct platform_device *of_dev)
>>   
>>   	return 0;
>>   
>> -return_err:
>> +put_device:
>> +	put_device(&fm_pdev->dev);
>> +put_node:
>>   	of_node_put(port_node);
>>   free_port:
>>   	kfree(port);
> 
> .
> 
