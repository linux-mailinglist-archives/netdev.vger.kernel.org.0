Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD8926300E
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 16:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730379AbgIIO6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 10:58:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729479AbgIIMaS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 08:30:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A58E421D81;
        Wed,  9 Sep 2020 12:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599654523;
        bh=4HhY12y7N+KPVF8QmaBcDAWyMvyvMqqXX3wDvyIDGr8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fq5z/fdOUgdQz6osW2YWSoPe2iEk2C6WZ8VI+Hi2t+rVU+jPzMiesRwgWZINIq1y1
         HVGLuIdUQQx0+h+NKiNQDnlxzVjUCTCr/bs9xEEV1anVH+5xAyKz3aQXBokqOlz93E
         /3J1RYqWtoDPftxicbW2OZC3B0XoisiA7u90LVEg=
Date:   Wed, 9 Sep 2020 14:28:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Kristian Evensen <kristian.evensen@gmail.com>,
        Paul Gildea <paul.gildea@gmail.com>,
        Carl Yin <carl.yin@quectel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 1/1] net: usb: qmi_wwan: add default rx_urb_size
Message-ID: <20200909122853.GA669308@kroah.com>
References: <20200909091302.20992-1-dnlplm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200909091302.20992-1-dnlplm@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 09, 2020 at 11:13:02AM +0200, Daniele Palmas wrote:
> Add default rx_urb_size to support QMAP download data aggregation
> without needing additional setup steps in userspace.
> 
> The value chosen is the current highest one seen in available modems.
> 
> The patch has the side-effect of fixing a babble issue in raw-ip mode
> reported by multiple users.
> 
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>

Any specific kernel commit that this "fixes:"?

> ---
> Resending with mailing lists added: sorry for the noise.
> 
> Hi Bjørn and all,
> 
> this patch tries to address the issue reported in the following threads
> 
> https://www.spinics.net/lists/netdev/msg635944.html
> https://www.spinics.net/lists/linux-usb/msg198846.html
> https://www.spinics.net/lists/linux-usb/msg198025.html
> 
> so I'm adding the people involved, maybe you can give it a try to
> double check if this is good for you.
> 
> On my side, I performed tests with different QC chipsets without
> experiencing problems.
> 
> Thanks,
> Daniele
> ---
>  drivers/net/usb/qmi_wwan.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 07c42c0719f5..92d568f982b6 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -815,6 +815,10 @@ static int qmi_wwan_bind(struct usbnet *dev, struct usb_interface *intf)
>  	}
>  	dev->net->netdev_ops = &qmi_wwan_netdev_ops;
>  	dev->net->sysfs_groups[0] = &qmi_wwan_sysfs_attr_group;
> +
> +	/* Set rx_urb_size to allow QMAP rx data aggregation */
> +	dev->rx_urb_size = 32768;

Where did this "magic number" come from?

And making an urb size that big can keep some pipelines full, it also
comes at the expense of other potential issues, have you tested this to
see that it really does help in throughput?

And if it does, does this size really need to be that big?  What is it
set to today, the endpoint size?  If so, that's a huge jump...

thanks,

greg k-h
