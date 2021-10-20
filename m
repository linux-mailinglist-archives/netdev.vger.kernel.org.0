Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A00943473B
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 10:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhJTItg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 04:49:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229627AbhJTItf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 04:49:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6611E61057;
        Wed, 20 Oct 2021 08:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634719641;
        bh=D2rCNyd73OW7GU4iaoaB5C+R3+taYHqgJ0OeYBm4wFo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lENvBMmwlWAaV6PbY/ufSrw9CJCtmexnhLrT8HR3CC0f66iO/sxnK2pJ+XZFTUwWA
         /khCgY7SKSx9sHD5DfxULjMa2D6vwNGUNirlg1/awi3FwL3tOxZ5AuikOnhmfP5K0u
         NuFzA5nyuL3KH8595hScGQ5cPuaQl2aSO4yDLyFvnqStyo43LSO7TtXy7dxyFHrv2V
         Vlpjwg4FlLO8GfbWz/BDM0lRoojCV2s12x/XyyIxb3TW2F2OmiHBWj4W0vuqsyDWb7
         +Qwp+eOHNJ7ACGDuPU8PAYSuTtFrLiGTDoyCDkvoZexqPkjmeyMC9Z3qJkCPuilR5y
         C/dA6PFA89Hfg==
Date:   Wed, 20 Oct 2021 10:47:17 +0200
From:   Simon Horman <horms@kernel.org>
To:     =?utf-8?B?Ss61YW4=?= Sacren <sakiwit@gmail.com>
Cc:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: qed_dev: fix redundant check of rc and
 against -EINVAL
Message-ID: <20211020084713.GA3935@kernel.org>
References: <cover.1634621525.git.sakiwit@gmail.com>
 <b187bc8a2a12e20dd54bce71f7de0f8e7c45f249.1634621525.git.sakiwit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b187bc8a2a12e20dd54bce71f7de0f8e7c45f249.1634621525.git.sakiwit@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 12:26:42AM -0600, Jεan Sacren wrote:
> From: Jean Sacren <sakiwit@gmail.com>
> 
> We should first check rc alone and then check it against -EINVAL to
> avoid repeating the same operation multiple times.
> 
> Signed-off-by: Jean Sacren <sakiwit@gmail.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_dev.c | 35 +++++++++++++----------
>  1 file changed, 20 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
> index 18f3bf7c4dfe..fe8bdb4523b5 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
> @@ -3987,30 +3987,35 @@ static int qed_hw_get_resc(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
>  				       QED_RESC_LOCK_RESC_ALLOC, false);
>  
>  	rc = qed_mcp_resc_lock(p_hwfn, p_ptt, &resc_lock_params);
> -	if (rc && rc != -EINVAL) {
> -		return rc;
> -	} else if (rc == -EINVAL) {
> +	if (rc) {
> +		if (rc != -EINVAL)
> +			return rc;
> +
>  		DP_INFO(p_hwfn,
>  			"Skip the max values setting of the soft resources since the resource lock is not supported by the MFW\n");
> -	} else if (!rc && !resc_lock_params.b_granted) {
> +	}
> +
> +	if (!resc_lock_params.b_granted) {

Can it be the case where the condition above is met and !rc is false?
If so your patch seems to have changed the logic of this function.

>  		DP_NOTICE(p_hwfn,
>  			  "Failed to acquire the resource lock for the resource allocation commands\n");
>  		return -EBUSY;
> -	} else {
> -		rc = qed_hw_set_soft_resc_size(p_hwfn, p_ptt);
> -		if (rc && rc != -EINVAL) {
> +	}
> +
> +	rc = qed_hw_set_soft_resc_size(p_hwfn, p_ptt);
> +	if (rc) {
> +		if (rc != -EINVAL) {
>  			DP_NOTICE(p_hwfn,
>  				  "Failed to set the max values of the soft resources\n");
>  			goto unlock_and_exit;
> -		} else if (rc == -EINVAL) {
> -			DP_INFO(p_hwfn,
> -				"Skip the max values setting of the soft resources since it is not supported by the MFW\n");
> -			rc = qed_mcp_resc_unlock(p_hwfn, p_ptt,
> -						 &resc_unlock_params);

nit: it looks like the two lines above would now fit on one.

> -			if (rc)
> -				DP_INFO(p_hwfn,
> -					"Failed to release the resource lock for the resource allocation commands\n");
>  		}
> +
> +		DP_INFO(p_hwfn,
> +			"Skip the max values setting of the soft resources since it is not supported by the MFW\n");
> +		rc = qed_mcp_resc_unlock(p_hwfn, p_ptt,
> +					 &resc_unlock_params);
> +		if (rc)
> +			DP_INFO(p_hwfn,
> +				"Failed to release the resource lock for the resource allocation commands\n");
>  	}
>  
>  	rc = qed_hw_set_resc_info(p_hwfn);
> 
