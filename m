Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C5460E37F
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 16:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbiJZOiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 10:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234358AbiJZOh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 10:37:56 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63466BA25B;
        Wed, 26 Oct 2022 07:37:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AC0E9CE2295;
        Wed, 26 Oct 2022 14:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7462EC433C1;
        Wed, 26 Oct 2022 14:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666795072;
        bh=y2U35Pk+CmD/Ks0JVJ0GmzyJIulw6nH1nLCwcfBn04Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RuU5wBDipXRYa4nCxyKvqv0eTq2JoVlhhjn5FTT7ZmDJrG8uF2LJt1LAf/00IMyuO
         BG8py7QRzsNGuuIE9EJScbHsBRmNbQCSiQ/YUqthNMOUTnnUj3LTKjUCbj7slPVU5u
         xaFztWPUG8uKYghyJAWiJyNg+pqleuh0WkzIY9o0=
Date:   Wed, 26 Oct 2022 16:37:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux@ew.tq-group.com
Subject: Re: [RFC 1/5] misc: introduce notify-device driver
Message-ID: <Y1lGPRvKMbNDs1iK@kroah.com>
References: <cover.1666786471.git.matthias.schiffer@ew.tq-group.com>
 <db30127ab4741d4e71b768881197f4791174f545.1666786471.git.matthias.schiffer@ew.tq-group.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db30127ab4741d4e71b768881197f4791174f545.1666786471.git.matthias.schiffer@ew.tq-group.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 03:15:30PM +0200, Matthias Schiffer wrote:
> A notify-device is a synchronization facility that allows to query
> "readiness" across drivers, without creating a direct dependency between
> the driver modules. The notify-device can also be used to trigger deferred
> probes.
> 
> Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> ---
>  drivers/misc/Kconfig          |   4 ++
>  drivers/misc/Makefile         |   1 +
>  drivers/misc/notify-device.c  | 109 ++++++++++++++++++++++++++++++++++
>  include/linux/notify-device.h |  33 ++++++++++
>  4 files changed, 147 insertions(+)
>  create mode 100644 drivers/misc/notify-device.c
>  create mode 100644 include/linux/notify-device.h
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 358ad56f6524..63559e9f854c 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -496,6 +496,10 @@ config VCPU_STALL_DETECTOR
>  
>  	  If you do not intend to run this kernel as a guest, say N.
>  
> +config NOTIFY_DEVICE
> +	tristate "Notify device"
> +	depends on OF
> +
>  source "drivers/misc/c2port/Kconfig"
>  source "drivers/misc/eeprom/Kconfig"
>  source "drivers/misc/cb710/Kconfig"
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index ac9b3e757ba1..1e8012112b43 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -62,3 +62,4 @@ obj-$(CONFIG_HI6421V600_IRQ)	+= hi6421v600-irq.o
>  obj-$(CONFIG_OPEN_DICE)		+= open-dice.o
>  obj-$(CONFIG_GP_PCI1XXXX)	+= mchp_pci1xxxx/
>  obj-$(CONFIG_VCPU_STALL_DETECTOR)	+= vcpu_stall_detector.o
> +obj-$(CONFIG_NOTIFY_DEVICE)	+= notify-device.o
> diff --git a/drivers/misc/notify-device.c b/drivers/misc/notify-device.c
> new file mode 100644
> index 000000000000..42e0980394ea
> --- /dev/null
> +++ b/drivers/misc/notify-device.c
> @@ -0,0 +1,109 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +
> +#include <linux/device/class.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/notify-device.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +
> +static void notify_device_release(struct device *dev)
> +{
> +	of_node_put(dev->of_node);
> +	kfree(dev);
> +}
> +
> +static struct class notify_device_class = {
> +	.name = "notify-device",
> +	.owner = THIS_MODULE,
> +	.dev_release = notify_device_release,
> +};
> +
> +static struct platform_driver notify_device_driver = {

Ick, wait, this is NOT a platform device, nor driver, so it shouldn't be
either here.  Worst case, it's a virtual device on the virtual bus.

But why is this a class at all?  Classes are a representation of a type
of device that userspace can see, how is this anything that userspace
cares about?

Doesn't the device link stuff handle all of this type of "when this
device is done being probed, now I can" problems?  Why is a whole new
thing needed?

thanks,

greg k-h
