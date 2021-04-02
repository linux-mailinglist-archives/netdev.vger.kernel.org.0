Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2A3352B36
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 16:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235636AbhDBOFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 10:05:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234161AbhDBOFv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Apr 2021 10:05:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1227461056;
        Fri,  2 Apr 2021 14:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617372350;
        bh=fVoUYNHohssOKVGn52qeT2TXNBN6FhnEZQHo90Vjhkg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SxI9WxpEmIFPGtnfLQikuNVa9vdqn1NkxPkmKFm0U0lQYj49ccvXCwTDPeDVe8Feo
         R0UHNdSqX1K4p0KPgLhUNjN5LCihSdMT1+5BXRY91QKt/C89hhNRFupVyMLCtqOTpa
         CRwzXfxvNgKragJK2T18mVBje3d/2LwJ9PXgQvNE=
Date:   Fri, 2 Apr 2021 16:05:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kuba@kernel.org, davem@davemloft.net,
        linux-arm-msm@vger.kernel.org, aleksander@aleksander.es,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bjorn.andersson@linaro.org, manivannan.sadhasivam@linaro.org
Subject: Re: [PATCH net-next v8 2/2] net: Add Qcom WWAN control driver
Message-ID: <YGckvGqSmmVjhZII@kroah.com>
References: <1617372397-13988-1-git-send-email-loic.poulain@linaro.org>
 <1617372397-13988-2-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1617372397-13988-2-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 02, 2021 at 04:06:37PM +0200, Loic Poulain wrote:
> The MHI WWWAN control driver allows MHI QCOM-based modems to expose
> different modem control protocols/ports via the WWAN framework, so that
> userspace modem tools or daemon (e.g. ModemManager) can control WWAN
> config and state (APN config, SMS, provider selection...). A QCOM-based
> modem can expose one or several of the following protocols:
> - AT: Well known AT commands interactive protocol (microcom, minicom...)
> - MBIM: Mobile Broadband Interface Model (libmbim, mbimcli)
> - QMI: QCOM MSM/Modem Interface (libqmi, qmicli)
> - QCDM: QCOM Modem diagnostic interface (libqcdm)
> - FIREHOSE: XML-based protocol for Modem firmware management
>         (qmi-firmware-update)
> 
> Note that this patch is mostly a rework of the earlier MHI UCI
> tentative that was a generic interface for accessing MHI bus from
> userspace. As suggested, this new version is WWAN specific and is
> dedicated to only expose channels used for controlling a modem, and
> for which related opensource userpace support exist.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  v2: update copyright (2021)
>  v3: Move driver to dedicated drivers/net/wwan directory
>  v4: Rework to use wwan framework instead of self cdev management
>  v5: Fix errors/typos in Kconfig
>  v6: - Move to new wwan interface, No need dedicated call to wwan_dev_create
>      - Cleanup code (remove legacy from mhi_uci, unused defines/vars...)
>      - Remove useless write_lock mutex
>      - Add mhi_wwan_wait_writable and mhi_wwan_wait_dlqueue_lock_irq helpers
>      - Rework locking
>      - Add MHI_WWAN_TX_FULL flag
>      - Add support for NONBLOCK read/write
>  v7: Fix change log (mixed up 1/2 and 2/2)
>  v8: - Implement wwan_port_ops (instead of fops)
>      - Remove all mhi wwan data obsolete members (kref, lock, waitqueues)
>      - Add tracking of RX buffer budget
>      - Use WWAN TX flow control function to stop TX when MHI queue is full
> 
>  drivers/net/wwan/Kconfig         |  14 +++
>  drivers/net/wwan/Makefile        |   2 +
>  drivers/net/wwan/mhi_wwan_ctrl.c | 253 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 269 insertions(+)
>  create mode 100644 drivers/net/wwan/mhi_wwan_ctrl.c
> 
> diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
> index 545fe54..ce0bbfb 100644
> --- a/drivers/net/wwan/Kconfig
> +++ b/drivers/net/wwan/Kconfig
> @@ -19,4 +19,18 @@ config WWAN_CORE
>  	  To compile this driver as a module, choose M here: the module will be
>  	  called wwan.
>  
> +config MHI_WWAN_CTRL
> +	tristate "MHI WWAN control driver for QCOM-based PCIe modems"
> +	select WWAN_CORE
> +	depends on MHI_BUS
> +	help
> +	  MHI WWAN CTRL allows QCOM-based PCIe modems to expose different modem
> +	  control protocols/ports to userspace, including AT, MBIM, QMI, DIAG
> +	  and FIREHOSE. These protocols can be accessed directly from userspace
> +	  (e.g. AT commands) or via libraries/tools (e.g. libmbim, libqmi,
> +	  libqcdm...).
> +
> +	  To compile this driver as a module, choose M here: the module will be
> +	  called mhi_wwan_ctrl
> +
>  endif # WWAN
> diff --git a/drivers/net/wwan/Makefile b/drivers/net/wwan/Makefile
> index 934590b..556cd90 100644
> --- a/drivers/net/wwan/Makefile
> +++ b/drivers/net/wwan/Makefile
> @@ -5,3 +5,5 @@
>  
>  obj-$(CONFIG_WWAN_CORE) += wwan.o
>  wwan-objs += wwan_core.o
> +
> +obj-$(CONFIG_MHI_WWAN_CTRL) += mhi_wwan_ctrl.o
> diff --git a/drivers/net/wwan/mhi_wwan_ctrl.c b/drivers/net/wwan/mhi_wwan_ctrl.c
> new file mode 100644
> index 0000000..f2fab23
> --- /dev/null
> +++ b/drivers/net/wwan/mhi_wwan_ctrl.c
> @@ -0,0 +1,253 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2021, Linaro Ltd <loic.poulain@linaro.org> */
> +#include <linux/kernel.h>
> +#include <linux/mhi.h>
> +#include <linux/mod_devicetable.h>
> +#include <linux/module.h>
> +#include <linux/wwan.h>
> +
> +/* MHI wwan flags */
> +#define MHI_WWAN_DL_CAP		BIT(0)
> +#define MHI_WWAN_UL_CAP		BIT(1)
> +#define MHI_WWAN_STARTED	BIT(2)
> +
> +#define MHI_WWAN_MAX_MTU	0x8000
> +
> +struct mhi_wwan_dev {
> +	/* Lower level is a mhi dev, upper level is a wwan port */
> +	struct mhi_device *mhi_dev;
> +	struct wwan_port *wwan_port;
> +
> +	/* State and capabilities */
> +	unsigned long flags;
> +	size_t mtu;
> +
> +	/* Protect against concurrent TX and TX-completion (bh) */
> +	spinlock_t tx_lock;
> +
> +	struct work_struct rx_refill;
> +	atomic_t rx_budget;

Why is this atomic if you have a real lock already?


> +};
> +
> +static bool mhi_wwan_ctrl_refill_needed(struct mhi_wwan_dev *mhiwwan)
> +{
> +	if (!test_bit(MHI_WWAN_STARTED, &mhiwwan->flags))
> +		return false;
> +
> +	if (!test_bit(MHI_WWAN_DL_CAP, &mhiwwan->flags))
> +		return false;

What prevents these bits from being changed right after reading them?

> +
> +	if (!atomic_read(&mhiwwan->rx_budget))
> +		return false;

Why is this atomic?  What happens if it changes right after returning?

This feels really odd.

> +
> +	return true;
> +}
> +
> +void __mhi_skb_destructor(struct sk_buff *skb)
> +{
> +	struct mhi_wwan_dev *mhiwwan = skb_shinfo(skb)->destructor_arg;
> +
> +	/* RX buffer has been consumed, increase the allowed budget */
> +	atomic_inc(&mhiwwan->rx_budget);

So this is a reference count?  What is this thing?

> +
> +	if (mhi_wwan_ctrl_refill_needed(mhiwwan))
> +		schedule_work(&mhiwwan->rx_refill);

What if refill is needed right after this check?  Did you just miss the
call?


> +static const struct mhi_device_id mhi_wwan_ctrl_match_table[] = {
> +	{ .chan = "DUN", .driver_data = WWAN_PORT_AT },
> +	{ .chan = "MBIM", .driver_data = WWAN_PORT_MBIM },
> +	{ .chan = "QMI", .driver_data = WWAN_PORT_QMI },
> +	{ .chan = "DIAG", .driver_data = WWAN_PORT_QCDM },
> +	{ .chan = "FIREHOSE", .driver_data = WWAN_PORT_FIREHOSE },

Wait, I thought these were all going to be separate somehow.  Now they
are all muxed back together?

totally confused,

greg k-h
