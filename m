Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8783A43B270
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235970AbhJZMdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:33:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235425AbhJZMdS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 08:33:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5394960EBD;
        Tue, 26 Oct 2021 12:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635251454;
        bh=Sjf7b/oeWGiONyuawgadmBHHVmuErKfTpBabVyn5MPQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LPtaD8PAqJ645wMcl9R83O49m5Eo8JqJYW4TP1jHM0+4L1ODZsjyh3B4Kue6MglMu
         5+sTKd/xW7bNhfpInnlSbZabnai2u5Hz9jX0X5nFA4vxEZ/3hamuafbWqyrBLdhbhm
         zWDLrrtFGPavjQf+EoTOh66VHUx3JhVUkGkhvsOsBntvYB4C+swA9dKXr2QYnatapo
         k8/fSk63lb6XO1BH97qxxW0ni8cnsEofqXDNP1d53UJ1EpBT0fU2+6G5VE8LW2F8k2
         I0HG0cIdfNndlfizE8VN/bLQ81usn6UJcBXWxt6Iqb8O5X0R23eevsqvNSZuv/L7qB
         70xtS9eEskPqw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mfLbB-0001iB-JL; Tue, 26 Oct 2021 14:30:38 +0200
Date:   Tue, 26 Oct 2021 14:30:37 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     oneukum@suse.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] usbnet: fix error return code in usbnet_probe()
Message-ID: <YXf07WrHVwk8WF2B@hovoldconsulting.com>
References: <20211026124015.3025136-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026124015.3025136-1-wanghai38@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 08:40:15PM +0800, Wang Hai wrote:
> Return error code if usb_maxpacket() returns 0 in usbnet_probe()
> 
> Fixes: 397430b50a36 ("usbnet: sanity check for maxpacket")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

This needs to go to stable as well as the offending patch is being
backported.

Cc: stable@vger.kernel.org
Reviewed-by: Johan Hovold <johan@kernel.org>

> ---
> v1->v2: change '-EINVAL' to '-ENODEV'
>  drivers/net/usb/usbnet.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index 80432ee0ce69..a33d7fb82a00 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -1790,6 +1790,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
>  	dev->maxpacket = usb_maxpacket (dev->udev, dev->out, 1);
>  	if (dev->maxpacket == 0) {
>  		/* that is a broken device */
> +		status = -ENODEV;
>  		goto out4;
>  	}

Johan
