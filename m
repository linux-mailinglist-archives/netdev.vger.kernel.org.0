Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548F84855E2
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241497AbiAEPb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:31:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59312 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiAEPbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:31:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24E5B617B4;
        Wed,  5 Jan 2022 15:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E8FC36AE0;
        Wed,  5 Jan 2022 15:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641396714;
        bh=nuJNBS2qVoVTLoQDvBf7yMXT+ENwHke+Ux4z4wI3J7A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rQ0518WdRkB8jaK0VpGJuCODnbkaf0Vh/kXOJkH89ptXvW+3CEXEkROzt1PChgizg
         45h6CPGUUmX/F8ACFiFqvy2tgSRzPDnnYp0PKYnHifp1QccbjX8Ie7iy835Pg+B435
         fkGFF3mBtrmF4K7xfChMnerC6BegxwhMg6RRqwdU=
Date:   Wed, 5 Jan 2022 16:31:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Aaron Ma <aaron.ma@canonical.com>
Cc:     kuba@kernel.org, henning.schild@siemens.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        hayeswang@realtek.com, tiwai@suse.de
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Message-ID: <YdW55+x9oVqgNMn7@kroah.com>
References: <20220105151427.8373-1-aaron.ma@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105151427.8373-1-aaron.ma@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 11:14:25PM +0800, Aaron Ma wrote:
> When plugin multiple r8152 ethernet dongles to Lenovo Docks
> or USB hub, MAC passthrough address from BIOS should be
> checked if it had been used to avoid using on other dongles.
> 
> Currently builtin r8152 on Dock still can't be identified.
> First detected r8152 will use the MAC passthrough address.
> 
> v2:
> Skip builtin PCI MAC address which is share MAC address with
> passthrough MAC.
> Check thunderbolt based ethernet.
> 
> v3:
> Add return value.

All of this goes below the --- line.

You have read the kernel documentation for how to do all of this, right?
If not, please re-read it.

> 
> Fixes: f77b83b5bbab ("net: usb: r8152: Add MAC passthrough support for
> more Lenovo Docks")

This line should not be wrapped.



> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> ---
>  drivers/net/usb/r8152.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index f9877a3e83ac..2483dc421dff 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -25,6 +25,7 @@
>  #include <linux/atomic.h>
>  #include <linux/acpi.h>
>  #include <linux/firmware.h>
> +#include <linux/pci.h>

Why does a USB driver care about PCI stuff?

>  #include <crypto/hash.h>
>  #include <linux/usb/r8152.h>
>  
> @@ -1605,6 +1606,7 @@ static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
>  	char *mac_obj_name;
>  	acpi_object_type mac_obj_type;
>  	int mac_strlen;
> +	struct net_device *ndev;
>  
>  	if (tp->lenovo_macpassthru) {
>  		mac_obj_name = "\\MACA";
> @@ -1662,6 +1664,19 @@ static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
>  		ret = -EINVAL;
>  		goto amacout;
>  	}
> +	rcu_read_lock();
> +	for_each_netdev_rcu(&init_net, ndev) {
> +		if (ndev->dev.parent && dev_is_pci(ndev->dev.parent) &&

Ick ick ick.

No, don't go poking around in random parent devices of a USB device,
that is a sure way to break things.

> +				!pci_is_thunderbolt_attached(to_pci_dev(ndev->dev.parent)))

So thunderbolt USB hubs are a problem here?

No, this is not the correct way to handle this at all.  There should be
some sort of identifier on the USB device itself to say that it is in a
docking station and needs to have special handling.  If not, then the
docking station is broken and needs to be returned.

Can you please revert the offending patch first so that people's systems
go back to working properly first?  Then worry about trying to uniquely
identify these crazy devices.

Again, this is not a way to do it, sorry.

greg k-h
