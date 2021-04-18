Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14083637DC
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 23:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbhDRV2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 17:28:48 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:52006 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbhDRV2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 17:28:46 -0400
Received: from [192.168.1.18] ([86.243.172.93])
        by mwinf5d25 with ME
        id uMUG2400321Fzsu03MUGK5; Sun, 18 Apr 2021 23:28:16 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 18 Apr 2021 23:28:16 +0200
X-ME-IP: 86.243.172.93
Subject: Re: [PATCH] net/mlx5: Use kasprintf instead of hand-writing it
To:     Bart Van Assche <bvanassche@acm.org>, saeedm@nvidia.com,
        leon@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <46235ec010551d2788483ce636686a61345e40ba.1618643703.git.christophe.jaillet@wanadoo.fr>
 <131988e1-2327-99f8-95e1-778d653c36ec@acm.org>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <8513235a-eed2-7007-a873-6464df8cb3c9@wanadoo.fr>
Date:   Sun, 18 Apr 2021 23:28:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <131988e1-2327-99f8-95e1-778d653c36ec@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 18/04/2021 à 22:03, Bart Van Assche a écrit :
> On 4/17/21 12:16 AM, Christophe JAILLET wrote:
>> 'kasprintf()' can replace a kmalloc/strcpy/strcat sequence.
>> It is less verbose and avoid the use of a magic number (64).
>>
>> Anyway, the underlying 'alloc_workqueue()' would only keep the 24 first
>> chars (i.e. sizeof(struct workqueue_struct->name) = WQ_NAME_LEN).
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>>   drivers/net/ethernet/mellanox/mlx5/core/health.c | 4 +---
>>   1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
>> index 9ff163c5bcde..a5383e701b4b 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
>> @@ -802,12 +802,10 @@ int mlx5_health_init(struct mlx5_core_dev *dev)
>>   	mlx5_fw_reporters_create(dev);
>>   
>>   	health = &dev->priv.health;
>> -	name = kmalloc(64, GFP_KERNEL);
>> +	name = kasprintf(GFP_KERNEL, "mlx5_health%s", dev_name(dev->device));
>>   	if (!name)
>>   		goto out_err;
>>   
>> -	strcpy(name, "mlx5_health");
>> -	strcat(name, dev_name(dev->device));
>>   	health->wq = create_singlethread_workqueue(name);
>>   	kfree(name);
>>   	if (!health->wq)
> 
> Instead of modifying the mlx5 driver, please change the definition of
> the create_singlethread_workqueue() such that it accept a format
> specifier and a variable number of arguments.
> 

Agreed. I've sent another patch serie which is more elegant.
Thanks for the feedback.

CJ

> Thanks,
> 
> Bart.
> 
> 
> 

