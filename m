Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0623EACD0
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 23:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236307AbhHLV6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 17:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233038AbhHLV6w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 17:58:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D49D56103E;
        Thu, 12 Aug 2021 21:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628805507;
        bh=mFjwqeJhhnWOrK4xObmOd5G6tPo8S1OwkvlbRpsUnmA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PgP+KKwUZjFDl2U+mo0VQcL6d6g+12uqNAdGWMZ0yQA5untndJ2N2iClBRkMXtyUs
         8XAImILv57d/Mt+suaprWpPQAlWaCWj7Rwhy4OwzPqIyXWjkoM50nLyy18XwfffyQp
         pPRlemkkri3t57YYrbqnbIl/S/tIZbbZH4Dlo67m4H4Z6sGMVCUd79oQzpgeOidGQI
         grFfepqGXiCxkVujPsoHDdQaRUD2sNdNGpHen8mFCCZCxDsGj7g7mwgN1hjNBNYTDY
         3mUwfLm3j//LAUq+u4SDzR+74urSi9FH6H+6VHycS55PsUlEe4BDrt6DyamyECxZT6
         r6xmoJM9gM7gw==
Date:   Thu, 12 Aug 2021 14:58:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     davem@davemloft.net, richardcochran@gmail.com,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH net-next 1/3] ptp: ocp: Fix uninitialized variable
 warning spotted by clang.
Message-ID: <20210812145826.6d795954@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210811183133.186721-2-jonathan.lemon@gmail.com>
References: <20210811183133.186721-1-jonathan.lemon@gmail.com>
        <20210811183133.186721-2-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Aug 2021 11:31:31 -0700 Jonathan Lemon wrote:
> If attempting to flash the firmware with a blob of size 0,
> the entire write loop is skipped and the uninitialized err
> is returned.  Fix by setting to 0 first.
> 
> Also remove a now-unused error handling statement.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  drivers/ptp/ptp_ocp.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
> index 92edf772feed..9b2ba06ebf97 100644
> --- a/drivers/ptp/ptp_ocp.c
> +++ b/drivers/ptp/ptp_ocp.c
> @@ -763,7 +763,7 @@ ptp_ocp_devlink_flash(struct devlink *devlink, struct device *dev,
>  	size_t off, len, resid, wrote;
>  	struct erase_info erase;
>  	size_t base, blksz;
> -	int err;
> +	int err = 0;
>  
>  	off = 0;
>  	base = bp->flash_start;
> @@ -847,8 +847,6 @@ ptp_ocp_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
>  							       "loader",
>  							       buf);
>  		}
> -		if (err)
> -			return err;

Looks like an accidental change, but it's mentioned in the commit log?

>  	}
>  
>  	if (!bp->has_serial)

