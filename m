Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21BF8319BD6
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 10:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhBLJZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 04:25:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:40604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhBLJZK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 04:25:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98A4B64E38;
        Fri, 12 Feb 2021 09:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613121869;
        bh=+2D8dYfapJLCYhEXN5R5hzo32tj97Tg3Vth7gOSDPQE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=U3vfuWFTCb3eYyXkQ7MCtoqmIzP5zJxG1wWSZ52jFF3TfOl7Q0W4BBjWrlbavCLHq
         sh8EqeLoL0i8ezHu8KaBSnx/BmORJB2oMswR+oNRsVyctNZga6TF1crboY+wafFgcf
         KNNwXeeewqlYE1pL6D5A/vglJfmjiffKU8OSd+hn0q2T20gNqoh7MuE8fp+ieNJxZ5
         PMyoFb2ZEgyaFK0BhmwQu8Yxvy1Vgjji3QAh4H66e3K5cfFImJRmOiLwLk1wsT6rin
         rXzRhk6y1wEWHDbhzs4rseLx8qYuDcWKisPyAXwRV7kwlgjtbuRrfKhE0u7usvoVbu
         JZ/3W3+LwraxQ==
Received: by mail-oi1-f171.google.com with SMTP id l19so9315506oih.6;
        Fri, 12 Feb 2021 01:24:29 -0800 (PST)
X-Gm-Message-State: AOAM531mL1FdgnCycAFPR7Ntp8skOvGBQYm2B6yXfqGYtIp4qG3n66CJ
        81B+raiCM/BNtHeaHCrocvfz2ZnvS6myCK0FcB0=
X-Google-Smtp-Source: ABdhPJwnvcnpu7mYcyYmf7HXBqIq29ZhxrA0P0+FAhHgzg6z9h9Nmm70De+POfEXgoNwO8FrKp+bqdh5z+4I03y9X7c=
X-Received: by 2002:aca:2117:: with SMTP id 23mr1245709oiz.4.1613121868865;
 Fri, 12 Feb 2021 01:24:28 -0800 (PST)
MIME-Version: 1.0
References: <1613012611-8489-1-git-send-email-min.li.xe@renesas.com>
 <CAK8P3a3YhAGEfrvmi4YhhnG_3uWZuQi0ChS=0Cu9c4XCf5oGdw@mail.gmail.com> <OSBPR01MB47732017A97D5C911C4528F0BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
In-Reply-To: <OSBPR01MB47732017A97D5C911C4528F0BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 12 Feb 2021 10:24:12 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2KDO4HutsXNJzjmRJTvW1QW4Kt8H7U53_QqpmgvZtd3A@mail.gmail.com>
Message-ID: <CAK8P3a2KDO4HutsXNJzjmRJTvW1QW4Kt8H7U53_QqpmgvZtd3A@mail.gmail.com>
Subject: Re: [PATCH net-next] misc: Add Renesas Synchronization Management
 Unit (SMU) support
To:     Min Li <min.li.xe@renesas.com>
Cc:     Derek Kiernan <derek.kiernan@xilinx.com>,
        Dragan Cvetic <dragan.cvetic@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        gregkh <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 2:40 AM Min Li <min.li.xe@renesas.com> wrote:
> > There should probably be a description of the purpose of the hardware both
> > here and in the patch description.
> >
> > In particular, please explain how it relates to the existing clockmatrix driver.
>
> I just uploaded v2 patch to provide more background info for this change.

It appears that you accidentally dropped the Cc list, adding them back in the
reply.  Also adding the PTP maintainer, as this clearly needs to be reviewed
in the context of the PTP subsystem. Please keep Richard and the netdev
list on Cc in future submissions.

> This driver is developed to be only used by Renesas PTP Clock Manager for
> Linux (pcm4l) software.
>
> This driver supports 1588/PTP releated functionalities that
> specific to Renesas devices but are not supported by general PHC framework.
> So pcm4l will use both the existing PHC driver and this driver to complete
> 1588/PTP support.

Ah, so if this is for a PTP related driver, it should probably be integrated
into the PTP subsystem rather than being a separate class.

> > A pure list of register values seems neither particular portable nor intuitive.
> > How is a user expected to interpret these, and are you sure that any driver
> > for this class would have the same interpretation at the same register index?
> >
>
> Yes we need a way to dump register values when remote debugging with customers.
> And all the Renesas SMU has similar register layout

A sysfs interface is a poor choice for this though -- how can you guarantee that
even future Renesas devices follow the exact same register layout? By
encoding the current hardware generation into the user interface, you
would end up having to emulate this on other chips you want to support later.

If it's only for debugging, best leave it out of the public interface, and only
have it in your own copy of the driver until the bugs are gone, or add a debugfs
interface.

> > Can you explain the purpose of this restriction? Why is it ok for two threads
> > to access the same file descriptor, but not two different file descriptors for
> > the same device?
> >
>
> The mutex is there to provide synchronization to the device access while PHC driver is accessing the device.
> The atomic count is to make sure only one user space program is using the driver at a time.

Then remove the atomic count, as it clearly doesn't do what you describe
when you can have multiple threads access the driver concurrently.

> > Each of these needs a device tree binding. It's usually better to name the
> > compatible strings according to the chips that contain this hardware, such as
> > "renesas,r8a1234567-rsmucdev" instead of "renesas,rsmu-cdev0".
> >
> > Since you don't seem to about the difference between the devices, the driver
> > can also just bind to one of them (usually the oldest) and then the newer
> > devices contain the string as a fallback, so you don't have to update the
> > driver every time another variant gets made.
> >
> >
>
> Actually the device is not spawned from device tree but from Renesas MFD driver (submitted in a separate thread).
> The MFD driver will call mfd_add_devices to create the platform devices. I am not sure if I still need to create binding
> In this case.

If you have an of_device_id table, it needs a binding. It sounds like you
don't need the of_device_id though.

> > This should probably be part of the .c file, as no other driver needs to
> > interface with it.
> >
>
> We actually run a unit test on the driver that needs to access this structure.
> That is why I need to put it in a header

Unit tests are good, but it's better to have them in the kernel.
Can you add the unit test into the patch then?
We now have the kunit framework for running unit tests.

> > This tells me that you got the abstraction the wrong way: the common files
> > should not need to know anything about the specific implementations.
> >
> > Instead, these should be in separate modules that call exported functions
> > from the common code.
> >
> >
>
> I got what you mean. But so far it only supports small set of functions, which is why
> I don't feet it is worth the effort to over abstract things.

Then maybe pick one of the two hardware variants and drop the abstraction you
have. You can then add more features before you add a proper abstraction
layer and then the second driver.

            Arnd
