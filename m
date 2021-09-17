Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42CE41001F
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 21:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243932AbhIQT7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 15:59:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46914 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234785AbhIQT7q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 15:59:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xUufhCPjaNRSqSTmzo6MuqCC9uQCQ1K+hZmvrzAv/18=; b=IbGBFwYc8KLLLw4UmW82nynD6F
        yHwnktQHy7O5jAdXSkjBdvHEKN11Qxv9LQaWdZSHQm3HsWrbQ7QcuRGrI3hG1uxCAXgdT0UDkaH2u
        TsYDmU4EyfyvdmIlPhz53uycEwO41qaGgWrVcyEDs/iunusK3OMpxh9I/CKsIEjKMOmk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mRJzy-0077OW-Up; Fri, 17 Sep 2021 21:58:14 +0200
Date:   Fri, 17 Sep 2021 21:58:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     min.li.xe@renesas.com
Cc:     richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] ptp: idt82p33: optimize idt82p33_adjtime
Message-ID: <YUTzVmf0W8/RjyK0@lunn.ch>
References: <1631889589-26941-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1631889589-26941-1-git-send-email-min.li.xe@renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 10:39:48AM -0400, min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> The current adjtime implementation is read-modify-write and immediately
> triggered, which is not accurate due to slow i2c bus access. Therefore,
> we will use internally generated 1 PPS pulse as trigger, which will
> improve adjtime accuracy significantly. On the other hand, the new trigger
> will not change TOD immediately but delay it to the next 1 PPS pulse.
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>
> ---
>  drivers/ptp/ptp_idt82p33.c | 221 ++++++++++++++++++++++++++++++---------------
>  drivers/ptp/ptp_idt82p33.h |  28 +++---
>  2 files changed, 165 insertions(+), 84 deletions(-)
> 
> diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c
> index c1c959f..abe628c 100644
> --- a/drivers/ptp/ptp_idt82p33.c
> +++ b/drivers/ptp/ptp_idt82p33.c
> @@ -24,15 +24,10 @@ MODULE_LICENSE("GPL");
>  MODULE_FIRMWARE(FW_FILENAME);
>  
>  /* Module Parameters */
> -static u32 sync_tod_timeout = SYNC_TOD_TIMEOUT_SEC;
> -module_param(sync_tod_timeout, uint, 0);
> -MODULE_PARM_DESC(sync_tod_timeout,
> -"duration in second to keep SYNC_TOD on (set to 0 to keep it always on)");
> -

Despite module parameters not being liked, they are probably also
considered ABI. So you probably cannot remove it.

	   Andrew
