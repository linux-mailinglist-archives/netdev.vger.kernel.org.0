Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADDA1C90D
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 14:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbfENMza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 08:55:30 -0400
Received: from mailrelay4-1.pub.mailoutpod1-cph3.one.com ([46.30.210.185]:56124
        "EHLO mailrelay4-1.pub.mailoutpod1-cph3.one.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725916AbfENMza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 08:55:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=haabendal.dk; s=20140924;
        h=content-type:mime-version:message-id:date:references:in-reply-to:subject:cc:
         to:from:from;
        bh=Wa3jMi9KJqQDLWw1Eka2Kg0cxZh4xKk+W+ZTUzGIaG4=;
        b=oxSmO0LUNg00fuse7wmhh0Fuyyv2SvcOl1hI7vbPECEGfOV7VZgHlGPL9+zifZn/c3jfCVy5y6YlM
         XlnOoVjElTVY1N5teGwZlLP3Bo+SZrIgD8+pq6wAPeRiijAZwE2B6ML4xOYeVqx8Mei3K3Jbilp+tb
         +L9lmrDeJgI+EaFQ=
X-HalOne-Cookie: 1b0e2f114696488111d802a7184ddba9a359d67a
X-HalOne-ID: 4e568cd5-7645-11e9-abc4-d0431ea8bb10
Received: from localhost (unknown [193.163.1.7])
        by mailrelay4.pub.mailoutpod1-cph3.one.com (Halon) with ESMTPSA
        id 4e568cd5-7645-11e9-abc4-d0431ea8bb10;
        Tue, 14 May 2019 12:39:25 +0000 (UTC)
From:   Esben Haabendal <esben@haabendal.dk>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Lee Jones <lee.jones@linaro.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mfd: ioc3: Add driver for SGI IOC3 chip
In-Reply-To: <20190409154610.6735-3-tbogendoerfer@suse.de> (Thomas Bogendoerfers's message of "Tue, 9 Apr 2019 17:46:06 +0200")
References: <20190409154610.6735-1-tbogendoerfer@suse.de>
        <20190409154610.6735-3-tbogendoerfer@suse.de>
        <20190508102313.GG3995@dell>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
Date:   Tue, 14 May 2019 14:39:25 +0200
Message-ID: <87mujpky6a.fsf@haabendal.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 09 Apr 2019, Thomas Bogendoerfer wrote:
> 
> diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
> index 358e66b81926..21fe722ebcd8 100644
> --- a/drivers/net/ethernet/sgi/ioc3-eth.c
> +++ b/drivers/net/ethernet/sgi/ioc3-eth.c
>  
>  [ ... ]
>  
> -	err = pci_request_regions(pdev, "ioc3");

Why are you dropping the call to pci_request_regions()?  Shouldn't you
do something similar in the new mfd driver?

When you are use the the BAR 0 resource as mem_base argument to
mfd_add_devices() later on, it will be split into child resources for
the child devices, but they will not be related to the IORESOURCE_MEM
root tree (iomem_resource) anymore.  I don't think that is how it is
supposed to be done, as it will allow random other drivers to request
the exact same memory area.

How/where is the memory resources inserted in the root IORESOURCE_MEM
resource (iomem_resource)?  Or is it allowed to use resources without
inserting it into the root tree?

> +	SET_NETDEV_DEV(dev, &pdev->dev);
> +	ip = netdev_priv(dev);
> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	ip->regs = ioremap(r->start, resource_size(r));
> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	ip->ssram = ioremap(r->start, resource_size(r));

Maybe use devm_platform_ioremap_resource() instead, which handles both
platform_get_resource() and ioremap() in one call..

/Esben
