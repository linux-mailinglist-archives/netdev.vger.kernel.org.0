Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A533379E4
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhCKQsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:48:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:59222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229632AbhCKQsG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 11:48:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9745C64FA7;
        Thu, 11 Mar 2021 16:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615481286;
        bh=aH9SzZcaM4wMI4kKn2IyMx+9vy80XXAzpeDOBCPd+VI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mOMSlG/jZxgBopREPhfXdCMSIfNINhTAnhaScT0pYvozmnjKaApZH5LtNkbRYaui0
         ARI2bTddoZgr6PwkKH43jVNMSZLoZOdlxHmmZSKzPbGUzhkpJ74hzys47xiCwxql6I
         4/eD+rDcEfN5yCFOfu5Wd9zKafi9axSnMCm75Y0w=
Date:   Thu, 11 Mar 2021 17:48:02 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kuba@kernel.org, davem@davemloft.net,
        linux-arm-msm@vger.kernel.org, aleksander@aleksander.es,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bjorn.andersson@linaro.org, manivannan.sadhasivam@linaro.org,
        hemantk@codeaurora.org, jhugo@codeaurora.org
Subject: Re: [PATCH net-next v4 1/2] net: Add a WWAN subsystem
Message-ID: <YEpJwsSy52HFB/IY@kroah.com>
References: <1615480746-28518-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615480746-28518-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 05:39:05PM +0100, Loic Poulain wrote:
> This change introduces initial support for a WWAN subsystem. Given the
> complexity and heterogeneity of existing WWAN hardwares and interfaces,
> there is no strict definition of what a WWAN device is and how it should
> be represented. It's often a collection of multiple components/devices
> that perform the global WWAN feature (netdev, tty, chardev, etc).
> 
> One usual way to expose modem controls and configuration is via high
> level protocols such as the well known AT command protocol, MBIM or
> QMI. The USB modems started to expose that as character devices, and
> user daemons such as ModemManager learnt how to deal with that. This
> initial version adds the concept of WWAN port, which can be registered
> by any driver to expose one of these protocols. The WWAN core takes
> care of the generic part, including character device creation and lets
> the driver implementing access (fops) to the selected protocol.
> 
> Since the different components/devices do no necesserarly know about
> each others, and can be created/removed in different orders, the
> WWAN core ensures that devices being part of the same hardware are
> also represented as a unique WWAN device, relying on the provided
> parent device (e.g. mhi controller, USB device). It's a 'trick' I
> copied from Johannes's earlier WWAN subsystem proposal.
> 
> This initial version is purposely minimalist, it's essentially moving
> the generic part of the previously proposed mhi_wwan_ctrl driver inside
> a common WWAN framework, but the implementation is open and flexible
> enough to allow extension for further drivers.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  drivers/net/Kconfig          |   2 +
>  drivers/net/Makefile         |   1 +
>  drivers/net/wwan/Kconfig     |  19 ++++++
>  drivers/net/wwan/Makefile    |   8 +++
>  drivers/net/wwan/wwan_core.c | 150 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/net/wwan/wwan_core.h |  20 ++++++
>  drivers/net/wwan/wwan_port.c | 136 +++++++++++++++++++++++++++++++++++++++
>  include/linux/wwan.h         | 121 ++++++++++++++++++++++++++++++++++
>  8 files changed, 457 insertions(+)
>  create mode 100644 drivers/net/wwan/Kconfig
>  create mode 100644 drivers/net/wwan/Makefile
>  create mode 100644 drivers/net/wwan/wwan_core.c
>  create mode 100644 drivers/net/wwan/wwan_core.h
>  create mode 100644 drivers/net/wwan/wwan_port.c
>  create mode 100644 include/linux/wwan.h

What changed from the last version(s)?  That should be below the ---
somewhere, right?

v5?

thanks,

greg k-h
