Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A1834B19B
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 22:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhCZVzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 17:55:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230316AbhCZVzS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 17:55:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C511A61A28;
        Fri, 26 Mar 2021 21:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616795718;
        bh=ThOTtOeCaalPjDMF552REQ8hQV0MTtvPsHurWmKDojI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=VHBWue9AqowGvGaqNHQVQjjTSM3sRba/Tp8NCZ1pilQpjtMFuqerC1clg9u0IjTBc
         xFQvm8dTY4pn2sTLcPnNgpOPSy8vERd/0Uv2qvz9OAbwVr76hoCqeP+4yXpn5Yzs/u
         rJHD0xUEWxzYBXhkC9B968yauVcSnKVLqBxvnZMo2y0zOTrnSEerzoT980r7DoXImv
         rGUiDaLG4Jr8HNgN+UrqSHkF1z/uvlXtMVi0DtxjeC/g7PVQ6/C/XN3dVIz3iCp5WR
         UF+ptOuEmkiwwaciNER6iQ9/G+8ddcrIxKkV1JOA+ZDXGkHlKYObKv3pkLKSdkxTUJ
         tOteo3S5Tz+gw==
Date:   Fri, 26 Mar 2021 16:55:16 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Viresh Kumar <vireshk@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>,
        Ion Badulescu <ionut@badula.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Peter Chen <Peter.Chen@nxp.com>,
        Felipe Balbi <balbi@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, dmaengine@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] PCI: Remove pci_try_set_mwi
Message-ID: <20210326215516.GA916324@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YF5VVjQ7q/JBSR1Z@smile.fi.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 11:42:46PM +0200, Andy Shevchenko wrote:
> On Fri, Mar 26, 2021 at 04:26:55PM -0500, Bjorn Helgaas wrote:
> > [+cc Randy, Andrew (though I'm sure you have zero interest in this
> > ancient question :))]
> > 
> > On Wed, Dec 09, 2020 at 09:31:21AM +0100, Heiner Kallweit wrote:
> > > pci_set_mwi() and pci_try_set_mwi() do exactly the same, just that the
> > > former one is declared as __must_check. However also some callers of
> > > pci_set_mwi() have a comment that it's an optional feature. I don't
> > > think there's much sense in this separation and the use of
> > > __must_check. Therefore remove pci_try_set_mwi() and remove the
> > > __must_check attribute from pci_set_mwi().
> > > I don't expect either function to be used in new code anyway.
> > 
> > There's not much I like better than removing things.  But some
> > significant thought went into adding pci_try_set_mwi() in the first
> > place, so I need a little more convincing about why it's safe to
> > remove it.
> > 
> > The argument should cite the discussion about adding it.  I think one
> > of the earliest conversations is here:
> > https://lore.kernel.org/linux-ide/20070404213704.224128ec.randy.dunlap@oracle.com/
> 
> It's solely PCI feature which is absent on PCIe.
>
> So, if there is a guarantee that the driver never services a device connected
> to old PCI bus, it's okay to remove the call (it's no-op on PCIe anyway).

Yes, I'm aware that MWI is a no-op on PCIe.  If we want to argue that
we don't need to support Conventional PCI devices, that should be
explicit, and we could remove pci_set_mwi() completely.  But I don't
think we're ready to drop Conventional PCI support.

> OTOH, PCI core may try MWI itself for every device (but this is an opposite,
> what should we do on broken devices that do change their state based on that
> bit while violating specification).
> 
> In any case
> 
> Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Thanks!

Bjorn
