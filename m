Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF932272657
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbgIUNwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:52:06 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:3830 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbgIUNwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 09:52:06 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f68afa90001>; Mon, 21 Sep 2020 06:50:33 -0700
Received: from localhost (10.124.1.5) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 21 Sep 2020 13:52:02
 +0000
Date:   Mon, 21 Sep 2020 16:51:58 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Qinglang Miao <miaoqinglang@huawei.com>
CC:     Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] mlxsw: spectrum_acl_tcam: simplify the return
 expression of ishtp_cl_driver_register()
Message-ID: <20200921135158.GC1072139@shredder>
References: <20200921131039.92249-1-miaoqinglang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200921131039.92249-1-miaoqinglang@huawei.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600696233; bh=gE2fNCr4NwcEx9iSuQNwYxoJRE1QPBnOkOu1EucRaxI=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy;
        b=pYkaNYaH3ueP6f5CncBswUwYqFIYVLP52hKGqfXFwzoWkdqfZcjdhtni5fSef8kpH
         UPujLYwUCAT4BjrW1w7mDJ+p1IiKPgoqnYR3nYT4QbSHLiF/9wgtQx1lT7QBsOj3nB
         V5rU8DNTGPdnLfiS4Rbhq1EtGKl1McquyJ9oVCxpV4cZGSlIVmUh5b92azR2XGOcFd
         stki/nt1HClAhxnYo3u5k148LtcQtEk5FXRXaungN611N9F457bUfMVRR8QoF4Q6zC
         L3YWlEtyccRk/uj/I2YEoFKy23tJL+UCk8/mwT5Z1hWe56S38Ei9XF/LH0Ja/NwxCO
         8CKz1G4m3bX3Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 09:10:39PM +0800, Qinglang Miao wrote:
> Simplify the return expression.
> 
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
> index 5c0204033..5b4313991 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
> @@ -289,17 +289,11 @@ static int
>  mlxsw_sp_acl_tcam_group_add(struct mlxsw_sp_acl_tcam *tcam,
>  			    struct mlxsw_sp_acl_tcam_group *group)
>  {
> -	int err;
> -
>  	group->tcam = tcam;
>  	mutex_init(&group->lock);
>  	INIT_LIST_HEAD(&group->region_list);
>  
> -	err = mlxsw_sp_acl_tcam_group_id_get(tcam, &group->id);
> -	if (err)
> -		return err;
> -
> -	return 0;
> +	return mlxsw_sp_acl_tcam_group_id_get(tcam, &group->id);

There is actually a problem here. We don't call mutex_destroy() on
error. Should be:

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index 5c020403342f..7cccc41dd69c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -292,13 +292,14 @@ mlxsw_sp_acl_tcam_group_add(struct mlxsw_sp_acl_tcam *tcam,
        int err;
 
        group->tcam = tcam;
-       mutex_init(&group->lock);
        INIT_LIST_HEAD(&group->region_list);
 
        err = mlxsw_sp_acl_tcam_group_id_get(tcam, &group->id);
        if (err)
                return err;
 
+       mutex_init(&group->lock);
+
        return 0;
 }

Then it's symmetric with mlxsw_sp_acl_tcam_group_del(). Do you want to
send this patch to 'net' or should I? If so, it should have this Fixes
line:

Fixes: 5ec2ee28d27b ("mlxsw: spectrum_acl: Introduce a mutex to guard region list updates")

Thanks

>  }
>  
>  static void mlxsw_sp_acl_tcam_group_del(struct mlxsw_sp_acl_tcam_group *group)
> -- 
> 2.23.0
> 
