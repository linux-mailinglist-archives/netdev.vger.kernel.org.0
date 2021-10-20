Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08914348FB
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 12:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhJTKed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 06:34:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhJTKec (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 06:34:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96CC161038;
        Wed, 20 Oct 2021 10:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634725938;
        bh=kEIAWD+bpGZoBVbbebOjMIQ0Llna+qN1VaxbtYqNI+k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LQ4CLpU3TAXV4bI+RQS6xx2VnddCqOTSyHGYzDE4b7GyBba/5ghc6EttQzfj36sRD
         ASkrG1uJ8LH6bgfk1OQ/7WWUM5HzvKK06McJ8KGJp6njLDY3zOHpgrFTEp9x5TyB/3
         sV2SWwVtvtzsTnsRdTzad3MbB3lIoooOt1YcgqYr1jVYY9drZxjCByw7x6RX/g0prZ
         pSKYlh+QbyXAL1A8pldZM6txDBCwxeehsVAJHSI6OF3r7DB1Oai/dCO2uQkcEehAEe
         2VXnu5ZJEjrZsbJKXTeI8s0CdcI0wNv6sl2X3OwTB+5KuXPT606BN+q/bHnLXhkC91
         HTktkrnrlJzBQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1md8tD-0006Un-BY; Wed, 20 Oct 2021 12:32:08 +0200
Date:   Wed, 20 Oct 2021 12:32:07 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com
Subject: Re: [PATCH] usbnet: sanity check for maxpacket
Message-ID: <YW/wJ727MSdiLrIY@hovoldconsulting.com>
References: <20211020091733.20085-1-oneukum@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211020091733.20085-1-oneukum@suse.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 11:17:33AM +0200, Oliver Neukum wrote:
> maxpacket of 0 makes no sense and oopdses as we need to divide

typo: oopses

> by it. Give up.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> Reported-by: syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com
> ---
>  drivers/net/usb/usbnet.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index 840c1c2ab16a..396f5e677bf0 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -1788,6 +1788,9 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
>  	if (!dev->rx_urb_size)
>  		dev->rx_urb_size = dev->hard_mtu;
>  	dev->maxpacket = usb_maxpacket (dev->udev, dev->out, 1);
> +	if (dev->maxpacket == 0)
> +		/* that is a broken device */
> +		goto out4;

I'd prefer brackets here since it's a multi-line block. Or just drop the
comment.

>  
>  	/* let userspace know we have a random address */
>  	if (ether_addr_equal(net->dev_addr, node_id))

Other than that, looks good:

Reviewed-by: Johan Hovold <johan@kernel.org>

Johan
