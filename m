Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68289273831
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 03:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbgIVBsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 21:48:52 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:42226 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728633AbgIVBsv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 21:48:51 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2CFD05FDB7C8BA64F8C9;
        Tue, 22 Sep 2020 09:48:50 +0800 (CST)
Received: from [10.174.179.91] (10.174.179.91) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Tue, 22 Sep 2020 09:48:49 +0800
Subject: Re: [PATCH -next] mlxsw: spectrum_acl_tcam: simplify the return
 expression of ishtp_cl_driver_register()
To:     Ido Schimmel <idosch@nvidia.com>
CC:     Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200921131039.92249-1-miaoqinglang@huawei.com>
 <20200921135158.GC1072139@shredder>
From:   miaoqinglang <miaoqinglang@huawei.com>
Message-ID: <eadef853-e308-f40f-6dd4-e4318a1d7e91@huawei.com>
Date:   Tue, 22 Sep 2020 09:48:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200921135158.GC1072139@shredder>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.91]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



ÔÚ 2020/9/21 21:51, Ido Schimmel Ð´µÀ:
> On Mon, Sep 21, 2020 at 09:10:39PM +0800, Qinglang Miao wrote:
>> Simplify the return expression.
>>
>> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
>> ---
>>   drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c | 8 +-------
>>   1 file changed, 1 insertion(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
>> index 5c0204033..5b4313991 100644
>> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
>> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
>> @@ -289,17 +289,11 @@ static int
>>   mlxsw_sp_acl_tcam_group_add(struct mlxsw_sp_acl_tcam *tcam,
>>   			    struct mlxsw_sp_acl_tcam_group *group)
>>   {
>> -	int err;
>> -
>>   	group->tcam = tcam;
>>   	mutex_init(&group->lock);
>>   	INIT_LIST_HEAD(&group->region_list);
>>   
>> -	err = mlxsw_sp_acl_tcam_group_id_get(tcam, &group->id);
>> -	if (err)
>> -		return err;
>> -
>> -	return 0;
>> +	return mlxsw_sp_acl_tcam_group_id_get(tcam, &group->id);

> There is actually a problem here. We don't call mutex_destroy() on
> error. Should be:
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
> index 5c020403342f..7cccc41dd69c 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
> @@ -292,13 +292,14 @@ mlxsw_sp_acl_tcam_group_add(struct mlxsw_sp_acl_tcam *tcam,
>          int err;
>   
>          group->tcam = tcam;
> -       mutex_init(&group->lock);
>          INIT_LIST_HEAD(&group->region_list);
>   
>          err = mlxsw_sp_acl_tcam_group_id_get(tcam, &group->id);
>          if (err)
>                  return err;
>   
> +       mutex_init(&group->lock);
> +
>          return 0;
>   }
> 
> Then it's symmetric with mlxsw_sp_acl_tcam_group_del(). Do you want to
> send this patch to 'net' or should I? If so, it should have this Fixes
> line:
> 
> Fixes: 5ec2ee28d27b ("mlxsw: spectrum_acl: Introduce a mutex to guard region list updates")
> 
> Thanks
> 
Hi Ido,

Sorry I didn't realize this problem. As for this bugfix patch, I think 
there's no doubt that you are the one who should send it :D.

Thanks.

>>   }
>>   
>>   static void mlxsw_sp_acl_tcam_group_del(struct mlxsw_sp_acl_tcam_group *group)
>> -- 
>> 2.23.0
>>
> .
> 
