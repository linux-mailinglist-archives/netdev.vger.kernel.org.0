Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909DA6240B0
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 12:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiKJLG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 06:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKJLG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 06:06:27 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809AE26DD;
        Thu, 10 Nov 2022 03:06:26 -0800 (PST)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N7JtG0clbzRp6Z;
        Thu, 10 Nov 2022 19:06:14 +0800 (CST)
Received: from [10.174.179.215] (10.174.179.215) by
 canpemm500007.china.huawei.com (7.192.104.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 19:06:24 +0800
Subject: Re: [PATCH net] net/mlx5: DR, Fix uninitialized var warning
To:     Roi Dayan <roid@nvidia.com>, <saeedm@nvidia.com>,
        <leon@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <kliteyn@nvidia.com>,
        <mbloch@nvidia.com>, <valex@nvidia.com>, <erezsh@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20221108015314.17928-1-yuehaibing@huawei.com>
 <b464b0af-69a3-ffc9-41f6-3d93f9bc32ce@nvidia.com>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <f7411744-4033-9a06-fe96-428ae5bd7e21@huawei.com>
Date:   Thu, 10 Nov 2022 19:06:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <b464b0af-69a3-ffc9-41f6-3d93f9bc32ce@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/10 16:20, Roi Dayan wrote:
> 
> 
> On 08/11/2022 3:53, YueHaibing wrote:
>> Smatch warns this:
>>
>> drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c:81
>>  mlx5dr_table_set_miss_action() error: uninitialized symbol 'ret'.
>>
>> Fix this by initializing ret with zero.
>>
>> Fixes: 7838e1725394 ("net/mlx5: DR, Expose steering table functionality")
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>  drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
>> index 31d443dd8386..44dea75dabde 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
>> @@ -46,7 +46,7 @@ static int dr_table_set_miss_action_nic(struct mlx5dr_domain *dmn,
>>  int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
>>  				 struct mlx5dr_action *action)
>>  {
>> -	int ret;
>> +	int ret = 0;
>>  
>>  	if (action && action->action_type != DR_ACTION_TYP_FT)
>>  		return -EOPNOTSUPP;
> 
> 
> In this case the default should be an error
> It will be better if ret init to -EOPNOTSUPP and if
> a miss action was not set and replaces ret then goto out.

Thanks for your review， will do that in v2.

> 
>  int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
>                                  struct mlx5dr_action *action)
>  {
> -       int ret;
> +       int ret = -EOPNOTSUPP;
>  
>         if (action && action->action_type != DR_ACTION_TYP_FT)
>                 return -EOPNOTSUPP;
> @@ -67,6 +67,9 @@ int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
>                         goto out;
>         }
>  
> +       if (ret)
> +               goto out;
> +
> 
> .
> 
