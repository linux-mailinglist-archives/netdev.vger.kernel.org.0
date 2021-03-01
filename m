Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE88327BAA
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbhCAKN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:13:29 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15335 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbhCAKN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 05:13:28 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603cbe1c0001>; Mon, 01 Mar 2021 02:12:44 -0800
Received: from [172.27.13.126] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 1 Mar
 2021 10:12:40 +0000
Subject: Re: [PATCH mellanox-tree] net/mlx5: prevent an integer underflow in
 mlx5_perout_configure()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Saeed Mahameed <saeedm@nvidia.com>, Aya Levin <ayal@nvidia.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        "Pavel Machek (CIP)" <pavel@denx.de>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
References: <YC+LoAcvcQSWLLKX@mwanda>
From:   Eran Ben Elisha <eranbe@nvidia.com>
Message-ID: <e9beab47-4f32-4aa4-cdb6-6fa7402e55de@nvidia.com>
Date:   Mon, 1 Mar 2021 12:12:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YC+LoAcvcQSWLLKX@mwanda>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614593564; bh=raZLqvnuMhG0ehI3YhI7h7P4P5aKBO0bR7+sg545DEM=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=mVtTMM5x28YZhU6aqf8fwXrUwJHi2HKr3t79MnqlTVatZj7HEKv9wCZNSvo5UEAis
         SvL3/IWki9ltMiTwvkHonhAC/VE2PZLGhluj0wIH20zzfcxNa3EgvmJ2Cq/KP+OBYQ
         odu6//96YMe0xKtEgw6z0v/bURV+L/V5KU5li+PzCTODdOHoAiWriVlStev+kXOm28
         eV84ZZJM47FTbkEYYH1dXlnUlI6Rg0Q4oEwSPsGw6yEaY4SyQEXteGDECT614M8jau
         cK7tWlh8M7n6v8N/NId7OiMf/X5TUVvGHOLUUbZyETWKW4jLla9sufwSvRbYlpjtl6
         78nimEfsg64Pg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/19/2021 11:57 AM, Dan Carpenter wrote:
> The value of "sec" comes from the user.  Negative values will lead to
> shift wrapping inside the perout_conf_real_time() function and triggger
> a UBSan warning.
> 
> Add a check and return -EINVAL to prevent that from happening.
> 
> Fixes: 432119de33d9 ("net/mlx5: Add cyc2time HW translation mode support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Saeed, I think this goes through your git tree and you will send a pull
> request to the networking?
> 
>  From static analysis.  Not tested.
> 
>   drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
> index b0e129d0f6d8..286824ca62b5 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
> @@ -516,7 +516,7 @@ static int mlx5_perout_configure(struct ptp_clock_info *ptp,
>   		nsec = rq->perout.start.nsec;
>   		sec = rq->perout.start.sec;
>   
> -		if (rt_mode && sec > U32_MAX)

This if clause was set to reject perout time start sec bigger than 
U32_MAX, as rt mode specifically doesn't support it.

A user negative values protection should be generic for all netdev 
drivers, inside the caller ioctl func, and not part of any driver code.

> +		if (rt_mode && (sec < 0 || sec > U32_MAX))
>   			return -EINVAL;
>   
>   		time_stamp = rt_mode ? perout_conf_real_time(sec, nsec) :
> 
