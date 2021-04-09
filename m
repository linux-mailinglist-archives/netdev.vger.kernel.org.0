Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C0B35988A
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 11:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbhDIJDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 05:03:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36540 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbhDIJDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 05:03:30 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lUn2p-0002Js-BC; Fri, 09 Apr 2021 09:03:15 +0000
Subject: Re: [PATCH][next] mlxsw: spectrum_router: remove redundant
 initialization of variable force
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        petrm@nvidia.com
References: <20210327223334.24655-1-colin.king@canonical.com>
 <YGF+D6fXNIbNVzff@shredder.lan>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <af12da04-aaef-c40e-682c-88fe683448dc@canonical.com>
Date:   Fri, 9 Apr 2021 10:03:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YGF+D6fXNIbNVzff@shredder.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/03/2021 08:13, Ido Schimmel wrote:
> On Sat, Mar 27, 2021 at 10:33:34PM +0000, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> The variable force is being initialized with a value that is
>> never read and it is being updated later with a new value. The
>> initialization is redundant and can be removed.
>>
>> Addresses-Coverity: ("Unused value")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
>> index 6ccaa194733b..ff240e3c29f7 100644
>> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
>> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
>> @@ -5059,7 +5059,7 @@ mlxsw_sp_nexthop_obj_bucket_adj_update(struct mlxsw_sp *mlxsw_sp,
>>  {
>>  	u16 bucket_index = info->nh_res_bucket->bucket_index;
>>  	struct netlink_ext_ack *extack = info->extack;
>> -	bool force = info->nh_res_bucket->force;
>> +	bool force;
> 
> Actually, there is a bug to be fixed here:
> 
> ```
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> index 6ccaa194733b..41259c0004d1 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> @@ -5068,8 +5068,9 @@ mlxsw_sp_nexthop_obj_bucket_adj_update(struct mlxsw_sp *mlxsw_sp,
>         /* No point in trying an atomic replacement if the idle timer interval
>          * is smaller than the interval in which we query and clear activity.
>          */
> -       force = info->nh_res_bucket->idle_timer_ms <
> -               MLXSW_SP_NH_GRP_ACTIVITY_UPDATE_INTERVAL;
> +       if (!force && info->nh_res_bucket->idle_timer_ms <
> +           MLXSW_SP_NH_GRP_ACTIVITY_UPDATE_INTERVAL)
> +               force = true;
>  
>         adj_index = nh->nhgi->adj_index + bucket_index;
>         err = mlxsw_sp_nexthop_update(mlxsw_sp, adj_index, nh, force, ratr_pl);
> ```
> 
> We should only fallback to a non-atomic replacement when the current
> replacement is atomic and the idle timer is too short.
> 
> We currently ignore the value of 'force'. This means that a non-atomic
> replacement ('force' is true) can be made atomic if idle timer is larger
> than 1 second.
> 
> Colin, do you mind if I submit it formally as a fix later this week? I
> want to run it through our usual process. Will mention you in
> Reported-by, obviously.

Sure. Good idea.

> 
>>  	char ratr_pl_new[MLXSW_REG_RATR_LEN];
>>  	char ratr_pl[MLXSW_REG_RATR_LEN];
>>  	u32 adj_index;
>> -- 
>> 2.30.2
>>

