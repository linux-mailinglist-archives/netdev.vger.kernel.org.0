Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBCEF1C5EDB
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 19:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730581AbgEERbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 13:31:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729885AbgEERbJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 13:31:09 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9FE720721;
        Tue,  5 May 2020 17:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588699868;
        bh=RzTvVkH2WVsAJ6Ltt5T27ZrW2749b4NieHGvxtLnG9U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tS/u1wcR0Q37TVJw/uE8YgnBhtgDScfuck9IX7Q0iLQGTfwFyd8odJaD2kcrM82p6
         HjikTR5ZOMjXfxiIlj5H/zEWp1Gzef+QoT68Q1tJlotQrUUW0jX83S4VT/HyNN8eNj
         i+2HZEa5Zj1G4Fze1Kx4NNapdEWOsffuC7brNBus=
Date:   Tue, 5 May 2020 10:31:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH 05/11] net: core: provide devm_register_netdev()
Message-ID: <20200505103105.1c8b0ce3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200505140231.16600-6-brgl@bgdev.pl>
References: <20200505140231.16600-1-brgl@bgdev.pl>
        <20200505140231.16600-6-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 May 2020 16:02:25 +0200 Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> Provide devm_register_netdev() - a device resource managed variant
> of register_netdev(). This new helper will only work for net_device
> structs that have a parent device assigned and are devres managed too.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

> diff --git a/net/core/dev.c b/net/core/dev.c
> index 522288177bbd..99db537c9468 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9519,6 +9519,54 @@ int register_netdev(struct net_device *dev)
>  }
>  EXPORT_SYMBOL(register_netdev);
>  
> +struct netdevice_devres {
> +	struct net_device *ndev;
> +};

Is there really a need to define a structure if we only need a pointer?

> +static void devm_netdev_release(struct device *dev, void *this)
> +{
> +	struct netdevice_devres *res = this;
> +
> +	unregister_netdev(res->ndev);
> +}
> +
> +/**
> + *	devm_register_netdev - resource managed variant of register_netdev()
> + *	@ndev: device to register
> + *
> + *	This is a devres variant of register_netdev() for which the unregister
> + *	function will be call automatically when the parent device of ndev
> + *	is detached.
> + */
> +int devm_register_netdev(struct net_device *ndev)
> +{
> +	struct netdevice_devres *dr;
> +	int ret;
> +
> +	/* struct net_device itself must be devres managed. */
> +	BUG_ON(!(ndev->priv_flags & IFF_IS_DEVRES));
> +	/* struct net_device must have a parent device - it will be the device
> +	 * managing this resource.
> +	 */
> +	BUG_ON(!ndev->dev.parent);

Please convert those to WARN_ON, and return an error. No need to crash
the kernel.

> +	dr = devres_alloc(devm_netdev_release, sizeof(*dr), GFP_KERNEL);
> +	if (!dr)
> +		return -ENOMEM;
> +
> +	ret = register_netdev(ndev);
> +	if (ret) {
> +		devres_free(dr);
> +		return ret;
> +	}
> +
> +	dr->ndev = ndev;
> +	devres_add(ndev->dev.parent, dr);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(devm_register_netdev);
