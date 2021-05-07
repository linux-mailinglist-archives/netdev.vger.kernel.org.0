Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F82375DD3
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 02:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbhEGAQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 20:16:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233434AbhEGAQ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 20:16:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A16CB61164;
        Fri,  7 May 2021 00:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620346530;
        bh=3MbcuAzQ8VqoGW3TOUTRbL9At5SJHYYUOB/ZA+UYJMA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KHdIB1hSOc39CdtLTqHrGgKaPDF6n7gr+k5LocW031alajtqJbCOTWJz+ZdTFgr2T
         1rG/dMJQ656arzg5Qi5wVKodCjcHmrMVD92+U5gWHdPtIrps6ng8YlCfRNrI2qgl53
         9F4e3x6eCNd4cnYmVtAoa+yjqYA0vqO04IVneG0bjrhRiGjKcVF0+wFEBuAvoie7pY
         sN/L4L5jXZc7D3FrJN7Z/2QbJVQDHV0OaOmN2GDnZ+fQwm06cvSOmf3aSqjZ+bcddx
         Q4qr+rHeIvkscZcQufUik4ypzrdO4Fa7fhYc0cAKp4njvfQnRwav3Um5nR05m/c7dd
         CXi/IvaL4COCw==
Date:   Thu, 6 May 2021 17:15:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, drivers@pensando.io,
        Allen Hubbe <allenbh@pensando.io>
Subject: Re: [PATCH v3 net] ionic: fix ptp support config breakage
Message-ID: <20210506171529.0d95c9da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210506041846.62502-1-snelson@pensando.io>
References: <20210506041846.62502-1-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  5 May 2021 21:18:46 -0700 Shannon Nelson wrote:
> Driver link failed with undefined references in some
> kernel config variations.

This is really vague and the patch is not very obvious.

>  ionic-y := ionic_main.o ionic_bus_pci.o ionic_devlink.o ionic_dev.o \
>  	   ionic_debugfs.o ionic_lif.o ionic_rx_filter.o ionic_ethtool.o \
> -	   ionic_txrx.o ionic_stats.o ionic_fw.o
> -ionic-$(CONFIG_PTP_1588_CLOCK) += ionic_phc.o
> +	   ionic_txrx.o ionic_stats.o ionic_fw.o ionic_phc.o

So we'd replace a build dependency..

> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
> index a87c87e86aef..30c78808c45a 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
> @@ -1,6 +1,8 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /* Copyright(c) 2017 - 2021 Pensando Systems, Inc */
>  
> +#if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
> +
>  #include <linux/netdevice.h>
>  #include <linux/etherdevice.h>
>  
> @@ -613,3 +615,4 @@ void ionic_lif_free_phc(struct ionic_lif *lif)
>  	devm_kfree(lif->ionic->dev, lif->phc);
>  	lif->phc = NULL;
>  }
> +#endif /* IS_ENABLED(CONFIG_PTP_1588_CLOCK) */

.. with an ifdef around an entire file? Does not feel very clean.

The construct of using:

	drv-$(CONFIG_PTP_1588_CLOCK) += ptp.o

seems relatively common, why does it now work here?

Maybe the config in question has PTP as a module and ionic built in?
Then you should add depends on PTP_1588_CLOCK || !PTP_1588_CLOCK.

Maybe somehow the "ionic-y" confuses kbuild and it should be ionic-objs?

At the very least we need a better explanation in the commit message.
