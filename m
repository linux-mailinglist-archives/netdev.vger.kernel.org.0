Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD58B33872C
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 09:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbhCLIQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 03:16:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:60980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231855AbhCLIQt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 03:16:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3809564F81;
        Fri, 12 Mar 2021 08:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615537008;
        bh=+th6o3hFTevSMkxSLkMv2+q485aey0+OmQKuDPEyXA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1DY3FtOCV8jMzCkv8fqUKyDfbJ7sv2ZqX60TRR0QhHIn7a5+UwMluIW6uAVkxxSkO
         Fooycvewj78zJ1IkRSmQ2M18yfZe/PiTL9CbutBBk4jQ70dSZTLTPI5mm0usxrI90a
         Rmfv5QoqrUeVxmhmPzPy2fKn+llvNE7hGkVAvvD4=
Date:   Fri, 12 Mar 2021 09:16:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kuba@kernel.org, davem@davemloft.net,
        linux-arm-msm@vger.kernel.org, aleksander@aleksander.es,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bjorn.andersson@linaro.org, manivannan.sadhasivam@linaro.org,
        hemantk@codeaurora.org, jhugo@codeaurora.org, rdunlap@infradead.org
Subject: Re: [PATCH net-next v5 2/2] net: Add Qcom WWAN control driver
Message-ID: <YEsjbnOPihKPJYpx@kroah.com>
References: <1615495264-6816-1-git-send-email-loic.poulain@linaro.org>
 <1615495264-6816-2-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615495264-6816-2-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 09:41:04PM +0100, Loic Poulain wrote:
> The MHI WWWAN control driver allows MHI QCOM-based modems to expose
> different modem control protocols/ports to userspace, so that userspace
> modem tools or daemon (e.g. ModemManager) can control WWAN config
> and state (APN config, SMS, provider selection...). A QCOM-based
> modem can expose one or several of the following protocols:
> - AT: Well known AT commands interactive protocol (microcom, minicom...)
> - MBIM: Mobile Broadband Interface Model (libmbim, mbimcli)
> - QMI: QCOM MSM/Modem Interface (libqmi, qmicli)
> - QCDM: QCOM Modem diagnostic interface (libqcdm)
> - FIREHOSE: XML-based protocol for Modem firmware management
>         (qmi-firmware-update)
> 
> The different interfaces are exposed as character devices through the
> WWAN subsystem, in the same way as for USB modem variants.
> 
> Note that this patch is mostly a rework of the earlier MHI UCI
> tentative that was a generic interface for accessing MHI bus from
> userspace. As suggested, this new version is WWAN specific and is
> dedicated to only expose channels used for controlling a modem, and
> for which related opensource user support exist. Other MHI channels
> not fitting the requirements will request either to be plugged to
> the right Linux subsystem (when available) or to be discussed as a
> new MHI driver (e.g AI accelerator, WiFi debug channels, etc...).
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  v2: update copyright (2021)
>  v3: Move driver to dedicated drivers/net/wwan directory
>  v4: Rework to use wwan framework instead of self cdev management
>  v5: Fix errors/typos in Kconfig
> 
>  drivers/net/wwan/Kconfig         |  14 ++
>  drivers/net/wwan/Makefile        |   1 +
>  drivers/net/wwan/mhi_wwan_ctrl.c | 497 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 512 insertions(+)
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
> index ca8bb5a..e18ecda 100644
> --- a/drivers/net/wwan/Makefile
> +++ b/drivers/net/wwan/Makefile
> @@ -6,3 +6,4 @@
>  obj-$(CONFIG_WWAN_CORE) += wwan.o
>  wwan-objs += wwan_core.o wwan_port.o
>  
> +obj-$(CONFIG_MHI_WWAN_CTRL) += mhi_wwan_ctrl.o
> diff --git a/drivers/net/wwan/mhi_wwan_ctrl.c b/drivers/net/wwan/mhi_wwan_ctrl.c
> new file mode 100644
> index 0000000..abda4b0
> --- /dev/null
> +++ b/drivers/net/wwan/mhi_wwan_ctrl.c
> @@ -0,0 +1,497 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2018-2021, The Linux Foundation. All rights reserved.*/
> +
> +#include <linux/kernel.h>
> +#include <linux/mhi.h>
> +#include <linux/mod_devicetable.h>
> +#include <linux/module.h>
> +#include <linux/poll.h>
> +
> +#include "wwan_core.h"
> +
> +#define MHI_WWAN_CTRL_DRIVER_NAME "mhi_wwan_ctrl"
> +#define MHI_WWAN_CTRL_MAX_MINORS 128
> +#define MHI_WWAN_MAX_MTU 0x8000
> +
> +/* MHI wwan device flags */
> +#define MHI_WWAN_DL_CAP		BIT(0)
> +#define MHI_WWAN_UL_CAP		BIT(1)
> +#define MHI_WWAN_CONNECTED	BIT(2)
> +
> +struct mhi_wwan_buf {
> +	struct list_head node;
> +	void *data;
> +	size_t len;
> +	size_t consumed;
> +};
> +
> +struct mhi_wwan_dev {
> +	unsigned int minor;

You never use this, why is it here?

{sigh}

Who reviewed this series before sending it out?

greg k-h
