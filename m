Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B413E36ABA5
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 06:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhDZE1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 00:27:42 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:54768 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhDZE1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 00:27:42 -0400
Received: from localhost (kumbhalgarh.blr.asicdesigners.com [10.193.185.255])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 13Q4QqHB004459;
        Sun, 25 Apr 2021 21:26:54 -0700
Date:   Mon, 26 Apr 2021 09:56:53 +0530
From:   Raju Rangoju <rajur@chelsio.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cxgb4: Remove redundant assignment to ret
Message-ID: <20210426042648.GA12978@chelsio.com>
References: <1619347023-49996-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1619347023-49996-1-git-send-email-jiapeng.chong@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sunday, April 04/25/21, 2021 at 18:37:03 +0800, Jiapeng Chong wrote:
> Variable ret is set to zero but this value is never read as it is
> overwritten with a new value later on, hence it is a redundant
> assignment and can be removed.
> 
> Cleans up the following clang-analyzer warning:
> 
> drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:3830:2: warning: Value stored
> to 'ret' is never read [clang-analyzer-deadcode.DeadStores].
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> index 80882cf..b9d2d58 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
> @@ -3827,8 +3827,8 @@ int t4_load_phy_fw(struct adapter *adap, int win,
>  		 FW_PARAMS_PARAM_X_V(FW_PARAMS_PARAM_DEV_PHYFW) |
>  		 FW_PARAMS_PARAM_Y_V(adap->params.portvec) |
>  		 FW_PARAMS_PARAM_Z_V(FW_PARAMS_PARAM_DEV_PHYFW_DOWNLOAD));
> -	ret = t4_set_params_timeout(adap, adap->mbox, adap->pf, 0, 1,
> -				    &param, &val, 30000);

Thanks for reporting this. However, the return value of
t4_set_params_timeout() needs to be handled and can not be ignored. Will
send a patch to fix the issue soon.

> +	t4_set_params_timeout(adap, adap->mbox, adap->pf, 0, 1,
> +			      &param, &val, 30000);
>  
>  	/* If we have version number support, then check to see that the new
>  	 * firmware got loaded properly.
> -- 
> 1.8.3.1
> 
