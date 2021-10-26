Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B4743B1AA
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 13:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235694AbhJZL5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 07:57:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235562AbhJZL5H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 07:57:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9791C60F90;
        Tue, 26 Oct 2021 11:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635249283;
        bh=oNSlDUAVFsAGdDzC+G3y987AE6R4DUYBIDH8CkjX7u8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tEkfaVF8DXq9/rDNDqEmbZycNVNPvS3OcVsETd0T+dlU9wAKVXuY9bL6FgznS+qzU
         R6jo72dh72H8p5xEr6yGXeKoyg/sX13NW67k4sLuHwvPl4puwR18Ir7V7spzUENDsQ
         XoHdoWQwyUr60wgyBJpTSdVIDppgtz3iv+IsftdU9P6wHUNS05oOsytnZdrWumT0DI
         Alpc54Gju4Ux8MDOygNfE/UZSLfRJeSRRxjbDqizv5+v/uarYXGguUmk9xXoPTlmCB
         uyFOQkI9VPgMBbohhHquRSKzop5zOVnw9z1Rg5JwPN0F4nhgj327iIUoF8SebcYPVy
         ngnMS8n2rSx+A==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mfL2A-0001dQ-S9; Tue, 26 Oct 2021 13:54:27 +0200
Date:   Tue, 26 Oct 2021 13:54:26 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     oneukum@suse.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] usbnet: fix error return code in usbnet_probe()
Message-ID: <YXfsclAOm8Zhbac1@hovoldconsulting.com>
References: <20211026112526.2878177-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026112526.2878177-1-wanghai38@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 07:25:26PM +0800, Wang Hai wrote:
> Return error code if usb_maxpacket() returns 0 in usbnet_probe().
> 
> Fixes: 397430b50a36 ("usbnet: sanity check for maxpacket")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---

Good catch. This is embarrassing. I double checked the error path but
failed to notice the missing return value.

>  drivers/net/usb/usbnet.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index 80432ee0ce69..fb5bf7d36d50 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -1790,6 +1790,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
>  	dev->maxpacket = usb_maxpacket (dev->udev, dev->out, 1);
>  	if (dev->maxpacket == 0) {
>  		/* that is a broken device */
> +		status = -EINVAL;

But please use -ENODEV here. -EINVAL is typically reserved for bad user
input.

>  		goto out4;
>  	}

Johan
