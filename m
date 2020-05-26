Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E9B1E2569
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgEZP2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:28:47 -0400
Received: from netrider.rowland.org ([192.131.102.5]:35995 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1728166AbgEZP2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 11:28:46 -0400
Received: (qmail 7552 invoked by uid 1000); 26 May 2020 11:28:44 -0400
Date:   Tue, 26 May 2020 11:28:44 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Johan Hovold <johan@kernel.org>,
        Alex Elder <elder@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Felipe Balbi <balbi@kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        greybus-dev@lists.linaro.org, netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        linux-s390@vger.kernel.org,
        "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        "open list:ULTRA-WIDEBAND \(UWB\) SUBSYSTEM:" 
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 8/8] net/iucv: Use the new device_to_pm() helper to
 access struct dev_pm_ops
Message-ID: <20200526152844.GA5809@rowland.harvard.edu>
References: <20200525182608.1823735-1-kw@linux.com>
 <20200525182608.1823735-9-kw@linux.com>
 <20200526063521.GC2578492@kroah.com>
 <20200526150744.GC75990@rocinante>
 <CAJZ5v0grVQhmk=q9_=CbBa8y_8XbTOeqv-Hb6Hivi6ffKsVHmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJZ5v0grVQhmk=q9_=CbBa8y_8XbTOeqv-Hb6Hivi6ffKsVHmQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 05:19:07PM +0200, Rafael J. Wysocki wrote:
> On Tue, May 26, 2020 at 5:07 PM Krzysztof Wilczyński <kw@linux.com> wrote:
> >
> > Hello Greg,
> >
> > [...]
> > > It's "interesting" how using your new helper doesn't actually make the
> > > code smaller.  Perhaps it isn't a good helper function?
> >
> > The idea for the helper was inspired by the comment Dan made to Bjorn
> > about Bjorn's change, as per:
> >
> >   https://lore.kernel.org/driverdev-devel/20191016135002.GA24678@kadam/
> >
> > It looked like a good idea to try to reduce the following:
> >
> >   dev->driver && dev->driver->pm && dev->driver->pm->prepare
> >
> > Into something more succinct.  Albeit, given the feedback from yourself
> > and Rafael, I gather that this helper is not really a good addition.
> 
> IMO it could be used for reducing code duplication like you did in the
> PCI code, but not necessarily in the other places where the code in
> question is not exactly duplicated.

The code could be a little more succinct, although it wouldn't fit every 
usage.  For example,

#define pm_do_callback(dev, method) \
	(dev->driver && dev->driver->pm && dev->driver->pm->callback ? \
	dev->driver->pm->callback(dev) : 0)

Then the usage is something like:

	ret = pm_do_callback(dev, prepare);

Would this be an overall improvement?

Alan Stern
