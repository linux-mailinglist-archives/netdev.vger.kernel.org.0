Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEBED33231B
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 11:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhCIKdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 05:33:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:42006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230214AbhCIKdK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 05:33:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 846BF6521D;
        Tue,  9 Mar 2021 10:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615285990;
        bh=M2cf08rDcEvmQ2802aWJqZRsyHo1UzItcfFEfG5uchQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yBFfW2xUFE2SeqKBPmF/HcGD82llH4IVdr4d/Z5L3fzsMoO0jQl8iTn2mahvzmswS
         1KM94bWEK4/yEtqvxYP9QWaJh9LVQMZ5R6ya0qJGvG2H+YnnsDMZjIhJZw4nogpUa2
         /hkVxn6FJGU/oSVQCPDgIcr3J2PTKE01dmUm4vxg=
Date:   Tue, 9 Mar 2021 11:33:07 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        open list <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Hemant Kumar <hemantk@codeaurora.org>
Subject: Re: [PATCH net-next v3] net: Add Qcom WWAN control driver
Message-ID: <YEdO47NAWpO886DC@kroah.com>
References: <1615279336-27227-1-git-send-email-loic.poulain@linaro.org>
 <YEdBfHAYkTGI8sE4@kroah.com>
 <CAMZdPi9dCzH9ufSoRK_szOaVnSsySk-kC5fu2Rb+wy-6snow0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZdPi9dCzH9ufSoRK_szOaVnSsySk-kC5fu2Rb+wy-6snow0Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 09, 2021 at 11:28:49AM +0100, Loic Poulain wrote:
> Hi Greg,
> 
> On Tue, 9 Mar 2021 at 10:35, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Mar 09, 2021 at 09:42:16AM +0100, Loic Poulain wrote:
> > > The MHI WWWAN control driver allows MHI Qcom based modems to expose
> > > different modem control protocols/ports to userspace, so that userspace
> > > modem tools or daemon (e.g. ModemManager) can control WWAN config
> > > and state (APN config, SMS, provider selection...). A Qcom based
> > > modem can expose one or several of the following protocols:
> > > - AT: Well known AT commands interactive protocol (microcom, minicom...)
> > > - MBIM: Mobile Broadband Interface Model (libmbim, mbimcli)
> > > - QMI: Qcom MSM/Modem Interface (libqmi, qmicli)
> > > - QCDM: Qcom Modem diagnostic interface (libqcdm)
> > > - FIREHOSE: XML-based protocol for Modem firmware management
> > >         (qmi-firmware-update)
> > >
> > > The different interfaces are exposed as character devices, in the same
> > > way as for USB modem variants (known as modem 'ports').
> > >
> > > Note that this patch is mostly a rework of the earlier MHI UCI
> > > tentative that was a generic interface for accessing MHI bus from
> > > userspace. As suggested, this new version is WWAN specific and is
> > > dedicated to only expose channels used for controlling a modem, and
> > > for which related opensource user support exist. Other MHI channels
> > > not fitting the requirements will request either to be plugged to
> > > the right Linux subsystem (when available) or to be discussed as a
> > > new MHI driver (e.g AI accelerator, WiFi debug channels, etc...).
> > >
> > > This change introduces a new drivers/net/wwan directory, aiming to
> > > be the common place for WWAN drivers.
> > >
> > > Co-developed-by: Hemant Kumar <hemantk@codeaurora.org>
> > > Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
> > > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > > ---
> > >  v2: update copyright (2021)
> > >  v3: Move driver to dedicated drivers/net/wwan directory
> > >
> > >  drivers/net/Kconfig              |   2 +
> > >  drivers/net/Makefile             |   1 +
> > >  drivers/net/wwan/Kconfig         |  26 ++
> > >  drivers/net/wwan/Makefile        |   6 +
> > >  drivers/net/wwan/mhi_wwan_ctrl.c | 559 +++++++++++++++++++++++++++++++++++++++
> > >  5 files changed, 594 insertions(+)
> > >  create mode 100644 drivers/net/wwan/Kconfig
> > >  create mode 100644 drivers/net/wwan/Makefile
> > >  create mode 100644 drivers/net/wwan/mhi_wwan_ctrl.c
> > >
> > > diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> > > index 1ebb4b9..28b18f2 100644
> > > --- a/drivers/net/Kconfig
> > > +++ b/drivers/net/Kconfig
> > > @@ -501,6 +501,8 @@ source "drivers/net/wan/Kconfig"
> > >
> > >  source "drivers/net/ieee802154/Kconfig"
> > >
> > > +source "drivers/net/wwan/Kconfig"
> > > +
> > >  config XEN_NETDEV_FRONTEND
> > >       tristate "Xen network device frontend driver"
> > >       depends on XEN
> > > diff --git a/drivers/net/Makefile b/drivers/net/Makefile
> > > index f4990ff..5da6424 100644
> > > --- a/drivers/net/Makefile
> > > +++ b/drivers/net/Makefile
> > > @@ -68,6 +68,7 @@ obj-$(CONFIG_SUNGEM_PHY) += sungem_phy.o
> > >  obj-$(CONFIG_WAN) += wan/
> > >  obj-$(CONFIG_WLAN) += wireless/
> > >  obj-$(CONFIG_IEEE802154) += ieee802154/
> > > +obj-$(CONFIG_WWAN) += wwan/
> > >
> > >  obj-$(CONFIG_VMXNET3) += vmxnet3/
> > >  obj-$(CONFIG_XEN_NETDEV_FRONTEND) += xen-netfront.o
> > > diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
> > > new file mode 100644
> > > index 0000000..643aa10
> > > --- /dev/null
> > > +++ b/drivers/net/wwan/Kconfig
> > > @@ -0,0 +1,26 @@
> > > +# SPDX-License-Identifier: GPL-2.0-only
> > > +#
> > > +# Wireless WAN device configuration
> > > +#
> > > +
> > > +menuconfig WWAN
> > > +       bool "Wireless WAN"
> > > +       help
> > > +         This section contains Wireless WAN driver configurations.
> > > +
> > > +if WWAN
> > > +
> > > +config MHI_WWAN_CTRL
> > > +     tristate "MHI WWAN control driver for QCOM based PCIe modems"
> > > +     depends on MHI_BUS
> > > +     help
> > > +       MHI WWAN CTRL allow QCOM based PCIe modems to expose different modem
> > > +       control protocols/ports to userspace, including AT, MBIM, QMI, DIAG
> > > +       and FIREHOSE. These protocols can be accessed directly from userspace
> > > +       (e.g. AT commands) or via libraries/tools (e.g. libmbim, libqmi,
> > > +       libqcdm...).
> > > +
> > > +       To compile this driver as a module, choose M here: the module will be
> > > +       called mhi_wwan_ctrl.
> > > +
> > > +endif # WWAN
> > > diff --git a/drivers/net/wwan/Makefile b/drivers/net/wwan/Makefile
> > > new file mode 100644
> > > index 0000000..994a80b
> > > --- /dev/null
> > > +++ b/drivers/net/wwan/Makefile
> > > @@ -0,0 +1,6 @@
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +#
> > > +# Makefile for the Linux WWAN device drivers.
> > > +#
> > > +
> > > +obj-$(CONFIG_MHI_WWAN_CTRL) += mhi_wwan_ctrl.o
> > > diff --git a/drivers/net/wwan/mhi_wwan_ctrl.c b/drivers/net/wwan/mhi_wwan_ctrl.c
> > > new file mode 100644
> > > index 0000000..3904cd0
> > > --- /dev/null
> > > +++ b/drivers/net/wwan/mhi_wwan_ctrl.c
> > > @@ -0,0 +1,559 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +/* Copyright (c) 2018-2021, The Linux Foundation. All rights reserved.*/
> > > +
> > > +#include <linux/kernel.h>
> > > +#include <linux/mhi.h>
> > > +#include <linux/mod_devicetable.h>
> > > +#include <linux/module.h>
> > > +#include <linux/poll.h>
> > > +
> > > +#define MHI_WWAN_CTRL_DRIVER_NAME "mhi_wwan_ctrl"
> >
> > So a driver name is the same as the class that is being created?
> >
> > That feels wrong, shouldn't the "class" be wwan?
> 
> The driver does not aim to be THE wwan implementation, given the
> heterogeneity of WWAN interfaces, so 'wwan' is probably too generic
> for this bus/vendor specific driver. But since we create a new wwan
> subdir, maybe we should create a minimal wwan_sysfs.c, that would
> initially just offer a common class for all WWAN devices (wwan or
> wwan-ports), as a first step to if not standardize, at least group
> such devices under the same hat. Otherwise, we can just use the misc
> class... Any thoughts?

Why isn't this a good api for all wwan devices?  Do you think that this
will not work for others?

A common class would be good, if they all work the same with regards to
a user/kernel api, otherwise it's pointless and not needed :)

And if we are back to the "custom user/kernel api just for this one
driver", then yes, the misc api is the easiest and simplest to use, but
I would wish for better than that for the first wwan driver...

thanks,

greg k-h
