Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964C537BA35
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 12:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhELKUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 06:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230145AbhELKUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 06:20:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1E87613BE;
        Wed, 12 May 2021 10:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620814740;
        bh=u3IdEUw5iqENTS2r+X9v7WRZxxumpLboTCBqIFW0waI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Damw++OFpp6bVGcaBAW3iz00Q6HIVxmAp9ZH6LY2aKlfVMjMCM+LAI27hsxDqT0nP
         npC1egUSqMZF+etbc/lDdSeMjSXXos5KFrRneyu7IE8NxHXV2JSt9rJ8R5cp3X8rY+
         lDH76ljzAV5M5FhE68TkxU1G6ftSCXNGwVS5GWnVh41svjAs69IS8gYrKWXgyqMhC1
         E3WdXFXmnbOVLkXn5ZuY1C882hMrC3+dX9SghEQ8COx365vxfLuA2IyllilGWm95WO
         CLbY0rPJ98CBHlRfXunyK2uQooDPCKyenCzGEyAPW7wNu7COP/z7UwnAdi8JbM8hta
         FlkvCgJhA0BEQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1lglxH-0004Ob-6b; Wed, 12 May 2021 12:19:03 +0200
Date:   Wed, 12 May 2021 12:19:03 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Denis Joseph Barrow <D.Barow@option.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rustam Kovhaev <rkovhaev@gmail.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: hso: check for allocation failure in
 hso_create_bulk_serial_device()
Message-ID: <YJurlxqQ9L+zzIAS@hovoldconsulting.com>
References: <YJupQPb+Y4vw3rDk@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJupQPb+Y4vw3rDk@mwanda>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 12, 2021 at 01:09:04PM +0300, Dan Carpenter wrote:
> Add a couple checks for if these allocations fail.
> 
> Fixes: 542f54823614 ("tty: Modem functions for the HSO driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/usb/hso.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
> index 3ef4b2841402..3b2a868d7a72 100644
> --- a/drivers/net/usb/hso.c
> +++ b/drivers/net/usb/hso.c
> @@ -2618,9 +2618,13 @@ static struct hso_device *hso_create_bulk_serial_device(
>  		num_urbs = 2;
>  		serial->tiocmget = kzalloc(sizeof(struct hso_tiocmget),
>  					   GFP_KERNEL);
> +		if (!serial->tiocmget)
> +			goto exit;

Nice catch; the next assignment would go boom if this ever failed.

This appears to have been introduced by 

	af0de1303c4e ("usb: hso: obey DMA rules in tiocmget")

>  		serial->tiocmget->serial_state_notification
>  			= kzalloc(sizeof(struct hso_serial_state_notification),
>  					   GFP_KERNEL);
> +		if (!serial->tiocmget->serial_state_notification)
> +			goto exit;
>  		/* it isn't going to break our heart if serial->tiocmget
>  		 *  allocation fails don't bother checking this.
>  		 */

You should remove this comment and drop the conditional on the following
line as well now, though.

Johan
