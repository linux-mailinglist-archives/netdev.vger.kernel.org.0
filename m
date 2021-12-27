Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48BA147FC55
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 12:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236517AbhL0Lvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 06:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233644AbhL0Lvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 06:51:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D338BC06173E;
        Mon, 27 Dec 2021 03:51:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73C9460F8D;
        Mon, 27 Dec 2021 11:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA0CC36AE7;
        Mon, 27 Dec 2021 11:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640605906;
        bh=1BnnIqoK6MlJteUTtWztTf7Gtju/mdvIX754NFttH70=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J+AK5OdpGffw2+VOn2yiS9tEBaWCnw8vpdk7XhM6c9bBMeQVOSgTJ2z/spdPqZ3SP
         Ayooshz9NTBYE/inqxiE7ArzQ+YJ6CN4TtseB+7jVFB7+b+fDtoxcXfMpsi86GCBd9
         zxH5xSoMn3LvfWnuUnebvTfURQBT/nPlstdSpYgs=
Date:   Mon, 27 Dec 2021 12:51:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH v2] asix: Use min() instead of doing it manually
Message-ID: <Ycmo0A/fnezdGhSa@kroah.com>
References: <20211227113839.92352-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211227113839.92352-1-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 27, 2021 at 07:38:39PM +0800, Jiapeng Chong wrote:
> Eliminate following coccicheck warning:
> 
> ./drivers/net/usb/asix_common.c:545:12-13: WARNING opportunity for
> min().
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
> Changes in v2:
>   -Modified commmit message.
> 
>  drivers/net/usb/asix_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
> index 71682970be58..da5a7df312d2 100644
> --- a/drivers/net/usb/asix_common.c
> +++ b/drivers/net/usb/asix_common.c
> @@ -542,7 +542,7 @@ static int __asix_mdio_write(struct net_device *netdev, int phy_id, int loc,
>  out:
>  	mutex_unlock(&dev->phy_mutex);
>  
> -	return ret < 0 ? ret : 0;
> +	return min(ret, 0);

This is not a good idea, as was already pointed out.  Please fix your
tools.

thanks,

greg k-h
