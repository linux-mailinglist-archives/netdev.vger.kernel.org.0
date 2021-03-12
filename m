Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA51338BD2
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 12:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhCLLt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 06:49:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:49462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231601AbhCLLtU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 06:49:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ACCF64FCE;
        Fri, 12 Mar 2021 11:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615549759;
        bh=cysV+npEIjVnORGDKnnz8lBTbEtDAJ5qTIJIn73jF9s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1IDKBOQcQouCta67Nor3PKjwEYXwWw4pD2yxBBS9IbKw2Uty5k1sL5JMt25JVKgni
         AjOhz4qaJjwoWgPJoIz2XXnQQAISjYZeClWX3UUZE0tjRGp4qQqJnFhd6rBAQkI/tB
         ojhSD8Zk4G1lhNjqMBNo3PhZyqAigHnynSIrVQPc=
Date:   Fri, 12 Mar 2021 12:49:17 +0100
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
        Hemant Kumar <hemantk@codeaurora.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>, rdunlap@infradead.org
Subject: Re: [PATCH net-next v5 1/2] net: Add a WWAN subsystem
Message-ID: <YEtVPRPlRFCIFwza@kroah.com>
References: <1615495264-6816-1-git-send-email-loic.poulain@linaro.org>
 <YEsQobygYgKRQlgC@kroah.com>
 <CAMZdPi-EHirVg7k5XQ2hmZ5O0BT6dLh46crCv4EMwZTHDNC_tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZdPi-EHirVg7k5XQ2hmZ5O0BT6dLh46crCv4EMwZTHDNC_tg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 12:11:50PM +0100, Loic Poulain wrote:
> Hi Greg,
> 
> On Fri, 12 Mar 2021 at 07:56, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Mar 11, 2021 at 09:41:03PM +0100, Loic Poulain wrote:
> > > This change introduces initial support for a WWAN subsystem. Given the
> > > complexity and heterogeneity of existing WWAN hardwares and interfaces,
> > > there is no strict definition of what a WWAN device is and how it should
> > > be represented. It's often a collection of multiple components/devices
> > > that perform the global WWAN feature (netdev, tty, chardev, etc).
> > >
> > > One usual way to expose modem controls and configuration is via high
> > > level protocols such as the well known AT command protocol, MBIM or
> > > QMI. The USB modems started to expose that as character devices, and
> > > user daemons such as ModemManager learnt how to deal with that. This
> > > initial version adds the concept of WWAN port, which can be registered
> > > by any driver to expose one of these protocols. The WWAN core takes
> > > care of the generic part, including character device creation and lets
> > > the driver implementing access (fops) to the selected protocol.
> > >
> > > Since the different components/devices do no necesserarly know about
> > > each others, and can be created/removed in different orders, the
> > > WWAN core ensures that devices being part of the same hardware are
> > > also represented as a unique WWAN device, relying on the provided
> > > parent device (e.g. mhi controller, USB device). It's a 'trick' I
> > > copied from Johannes's earlier WWAN subsystem proposal.
> > >
> > > This initial version is purposely minimalist, it's essentially moving
> > > the generic part of the previously proposed mhi_wwan_ctrl driver inside
> > > a common WWAN framework, but the implementation is open and flexible
> > > enough to allow extension for further drivers.
> > >
> > > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> [...]
> > > +#include <linux/err.h>
> > > +#include <linux/errno.h>
> > > +#include <linux/init.h>
> > > +#include <linux/fs.h>
> > > +#include <linux/idr.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/module.h>
> > > +#include <linux/slab.h>
> > > +#include <linux/types.h>
> > > +#include <linux/wwan.h>
> > > +
> > > +#include "wwan_core.h"
> > > +
> > > +static LIST_HEAD(wwan_list); /* list of registered wwan devices */
> >
> > Why do you need a list as you already have a list of them all in the
> > class structure?
> 
> Thanks, indeed, I can use class helpers for that.
> 
> >
> > > +static DEFINE_IDA(wwan_ida);
> > > +static DEFINE_MUTEX(wwan_global_lock);
> >
> > What is this lock for?  I don't think you need a lock for a ida/idr
> > structure if you use it in the "simple" mode, right?
> >
> > > +struct class *wwan_class;
> >
> > Why is this a global structure?
> 
> It's also used inside wwan_port.c, but we can also retrieve the class
> directly from wwandev->dev.class, so yes it's not strictly necessary
> to have it global.

Ick, no, don't get it from ->dev.class.  Put both of these files into
one .c file, there's no need for two different ones, right?

> > > +             wwandev->usage++;
> >
> > Hah, why?  You now have 2 reference counts for the same structure?
> 
> 'usage' is probably not the right term, but this counter tracks device
> registration life to determine when the device must be unregistered
> from the system (several wwan drivers can be exposed as a unique wwan
> device), while device kref tracks the wwan device life. They are kind
> of coupled, but a device can not be released if not priorly
> unregistered.

This feels totally unneeded and unnecessary.  Just use the built-in
reference counting and all should be fine.  To try to keep
yet-another-reference-count in your structure just means that you have 2
values controlling one life-span.  Ripe for disaster.

> > > +void wwan_port_deinit(void)
> > > +{
> > > +     unregister_chrdev(wwan_major, "wwanport");
> > > +     idr_destroy(&wwan_port_idr);
> > > +}
> >
> >
> > I'm confused, you have 1 class, but 2 different major numbers for this
> > class?  You have a device and ports with different numbers, how are they
> > all tied together?
> 
> There is one wwan class with different device types (wwan devices and
> wwan control ports), a port is a child of a wwan device. Only wwan
> ports are exposed as character devices and IDR is used for getting a
> minor. wwan device IDA is just used to alloc unique wwan device ID.

Ok, that's fine but you need to:

> > > +struct wwan_port {
> > > +     struct wwan_device *wwandev;
> > > +     const struct file_operations *fops;
> > > +     void *private_data;
> > > +     enum wwan_port_type type;
> > > +
> > > +     /* private */
> > > +     unsigned int id;
> > > +     int minor;
> > > +     struct list_head list;
> >
> > So a port is not a device?  Why not?
> 
> A port is represented as a device, device_create is called when port
> is attached to wwan core, but it indeed would make more sense to
> simply make wwan_port a device.

Make this a real device.  That will solve your lifetime rules
automatically and make things simpler.

I feel like we create these types of "driver subsystem frameworks" every
kernel release, and each time I review them people get them wrong.  What
can the driver core do to help make this whole thing easier?

We have misc-device, which makes creating a char device node
dirt-simple, what more can I do to make creating a device class and char
device node interaction simpler to keep everyone from having to write
the same code all the time and have the chance to get it wrong (in
unique ways each time...)

thanks,

greg k-h
