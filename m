Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A29E2A4050
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 10:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbgKCJcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 04:32:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:40408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbgKCJcq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 04:32:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69A10223BD;
        Tue,  3 Nov 2020 09:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604395965;
        bh=IrV4h0rvAGQFEgmyY4cuxqFV+gpefvvnyQJqDUsME3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1FEPBqXYPwCDlxZrsBNgbv2PQxi4axoAfn6avNNmtBODJlGOZb/OcadPpYwk2CR6o
         cyuOSWUNaT+gmCmN/IsYKxix5LyehVhBY3imN8/P5g4eWmlAW48qcsczhDHgT1OC8/
         MIRWMEVLNZ7OL+tWm3mo9pUHqIyF7JjP0DpMhzro=
Date:   Tue, 3 Nov 2020 10:32:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hayes Wang <hayeswang@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH net-next v2] net/usb/r8153_ecm: support ECM mode for
 RTL8153
Message-ID: <20201103093241.GA79239@kroah.com>
References: <1394712342-15778-387-Taiwan-albertk@realtek.com>
 <1394712342-15778-388-Taiwan-albertk@realtek.com>
 <20201031160838.39586608@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <dc7fd1d4d1c544e8898224c7d9b54bda@realtek.com>
 <20201102114718.0118cc12@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102114718.0118cc12@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 11:47:18AM -0800, Jakub Kicinski wrote:
> On Mon, 2 Nov 2020 07:20:15 +0000 Hayes Wang wrote:
> > Jakub Kicinski <kuba@kernel.org>
> > > Can you describe the use case in more detail?
> > > 
> > > AFAICT r8152 defines a match for the exact same device.
> > > Does it not mean that which driver is used will be somewhat random
> > > if both are built?  
> > 
> > I export rtl_get_version() from r8152. It would return none zero
> > value if r8152 could support this device. Both r8152 and r8153_ecm
> > would check the return value of rtl_get_version() in porbe().
> > Therefore, if rtl_get_version() return none zero value, the r8152
> > is used for the device with vendor mode. Otherwise, the r8153_ecm
> > is used for the device with ECM mode.
> 
> Oh, I see, I missed that the rtl_get_version() checking is the inverse
> of r8152.
> 
> > > > +/* Define these values to match your device */
> > > > +#define VENDOR_ID_REALTEK		0x0bda
> > > > +#define VENDOR_ID_MICROSOFT		0x045e
> > > > +#define VENDOR_ID_SAMSUNG		0x04e8
> > > > +#define VENDOR_ID_LENOVO		0x17ef
> > > > +#define VENDOR_ID_LINKSYS		0x13b1
> > > > +#define VENDOR_ID_NVIDIA		0x0955
> > > > +#define VENDOR_ID_TPLINK		0x2357  
> > > 
> > > $ git grep 0x2357 | grep -i tplink
> > > drivers/net/usb/cdc_ether.c:#define TPLINK_VENDOR_ID	0x2357
> > > drivers/net/usb/r8152.c:#define VENDOR_ID_TPLINK		0x2357
> > > drivers/usb/serial/option.c:#define TPLINK_VENDOR_ID			0x2357
> > > 
> > > $ git grep 0x17ef | grep -i lenovo
> > > drivers/hid/hid-ids.h:#define USB_VENDOR_ID_LENOVO		0x17ef
> > > drivers/hid/wacom.h:#define USB_VENDOR_ID_LENOVO	0x17ef
> > > drivers/net/usb/cdc_ether.c:#define LENOVO_VENDOR_ID	0x17ef
> > > drivers/net/usb/r8152.c:#define VENDOR_ID_LENOVO		0x17ef
> > > 
> > > Time to consolidate those vendor id defines perhaps?  
> > 
> > It seems that there is no such header file which I could include
> > or add the new vendor IDs.
> 
> Please create one. (Adding Greg KH to the recipients, in case there is
> a reason that USB subsystem doesn't have a common vendor id header.)

There is a reason, it's a nightmare to maintain and handle merges for,
just don't do it.

Read the comments at the top of the pci_ids.h file if you are curious
why we don't even do this for PCI device ids anymore for the past 10+
years.

So no, please do not create such a common file, it is not needed or a
good idea.

thanks,

greg k-h
