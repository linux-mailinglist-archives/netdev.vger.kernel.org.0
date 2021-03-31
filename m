Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B724A35053B
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 19:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhCaRHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 13:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233735AbhCaRHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 13:07:23 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB22C06175F
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 10:07:22 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id x11so1810709qkp.11
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 10:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CBJLgij8JRUpa6bM6F2HzF0AcYEY2HXB4yx3yMAYHWY=;
        b=I3icD9WkMNJ0dAyK1Wv8cpeBrTixRgfSrUKvPdVhK07yhGUYb5MnZRDMK9Vr0FnEEI
         Wl6GG1mls7jaG40HUL5BNvQrQNI/K8/HURlFIyAZkh+HHxmKK3YhuUimgRG87npzRwDj
         xhkgqi9ZQlhHO9MyemttQn9IOX1dUpcLrqMq/AuaN0rDu43guNce+zJyQxCShGZzzhFb
         O58Ig1j6IPpubs+o37HZv0lUXHJwmL807FrPxwRtygMpaLPyZldw4nxt9UFM0e9/HfNx
         pDW+A0FeZuPUMGCpITJKXMZir+Vlygh+VHIOqeL76FiFJxqeLN1YJ6IgjS8M08pyDCUO
         RJhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CBJLgij8JRUpa6bM6F2HzF0AcYEY2HXB4yx3yMAYHWY=;
        b=UeEjVPdMBu/xiUEx54klMrJXaBw0B7pOMNPOJJMJI//GmpBGoeAmw2/8tDmU0nC5gf
         SNqrF7ehW+cmUxw0X1XyD4AyJz9YdiciyjhKJvmk+J1IusXNzh5DOKwQx8HMpg16z3ov
         Z8NsMGrhuHovpQ2ETrSjrAFSu1PCFP5kOLk0BhndFR1IZTEbh4UWreAQDQxWZqQEwl0a
         6I6EyEl6jJ2E8jXxECdWwkPSJxfVE7SkB63I055470RZH8PgUS7HMD9dBxeRSrsZSX0y
         2qXbiSc6LDY2F7poR6CA689hOhfZel5kG3iTFtNxL/ujIMJhT5Aqfvq5n1esSi+eeUT0
         kwAw==
X-Gm-Message-State: AOAM530cML0eb127XB+EwBlrq5esYilSTiwQviN6G6TNY4UFSFWs7FzJ
        m6T81oANLDONQWcIzuDJD85NIQ==
X-Google-Smtp-Source: ABdhPJwAoOIqYtNI2MwGauM5rPZT26vCbcrvCwwOUhjCAPlzbZW+C4ASvagifSG/VZz4tKBdzSM95Q==
X-Received: by 2002:a37:6348:: with SMTP id x69mr4015891qkb.154.1617210441706;
        Wed, 31 Mar 2021 10:07:21 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id h75sm1819948qke.80.2021.03.31.10.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 10:07:21 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1lReJM-006OXG-AR; Wed, 31 Mar 2021 14:07:20 -0300
Date:   Wed, 31 Mar 2021 14:07:20 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Keith Busch <kbusch@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <20210331170720.GY2710221@ziepe.ca>
References: <20210330194716.GV2710221@ziepe.ca>
 <20210330204141.GA1305530@bjorn-Precision-5520>
 <20210330224341.GW2710221@ziepe.ca>
 <YGQY72LnGB6bfIsI@kroah.com>
 <20210331121929.GX2710221@ziepe.ca>
 <YGSPUewD5J+F7ZRe@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGSPUewD5J+F7ZRe@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 05:03:45PM +0200, Greg Kroah-Hartman wrote:
> > It isn't a struct device object at all though, it just organizing
> > attributes.
> 
> That's the point, it really is not.  You are forced to create a real
> object for that subdirectory, and by doing so, you are "breaking" the
> driver/device model.  As is evident by userspace not knowing what is
> going on here.

I'm still not really sure about what this means in practice..

I found an nested attribute in RDMA land so lets see how it behaves.
 
   /sys/class/infiniband/ibp0s9/ <-- This is a struct device/ib_device

Then we have 261 'attribute' files under a ports subdirectory, for
instance:

 /sys/class/infiniband/ibp0s9/ports/1/cm_tx_retries/dreq

Open/read works fine, and the specialty userspace that people built on
this has been working for a long time.

Does udev see the deeply nested attributes? Apparently yes:

$ udevadm info -a /sys/class/infiniband/ibp0s9
    ATTR{ports/1/cm_rx_duplicates/dreq}=="0"
    [..]

Given your remarks, I'm surprised, but it seems to work - I assume if
udevadm shows it then all the rules will work too.

Has udev become confused about what is a struct device? Looks like no:

$ udevadm info -a /sys/class/infiniband/ibp0s9/port
Unknown device "/sys/class/infiniband/ibp0s9/port": No such device

Can you give an example where things go wrong?

(and I inherited this RDMA stuff. In the last two years we moved it
 all to netlink and modern userspace largely no longer touches sysfs,
 but I can't break in-use uAPI)

> > > Does that help?  The rules are:
> > > 	- Once you use a 'struct device', all subdirs below that device
> > > 	  are either an attribute group for that device or a child
> > > 	  device.
> > > 	- A struct device can NOT have an attribute group as a parent,
> > > 	  it can ONLY have another struct device as a parent.
> > > 
> > > If you break those rules, the kernel has the ability to get really
> > > confused unless you are very careful, and userspace will be totally lost
> > > as you can not do anything special there.
> > 
> > The kernel gets confused?
> 
> Putting a kobject as a child of a struct device can easily cause
> confusion as that is NOT what you should be doing.  Especially if you
> then try to add a device to be a child of that kobject. 

That I've never seen. I've only seen people making extra levels of
directories for organizing attributes.

> > How do you fix them? It is uAPI at this point so we can't change the
> > directory names. Can't make them struct devices (userspace would get
> > confused if we add *more* sysfs files)
> 
> How would userspace get confused?  If anything it would suddenly "wake
> up" and see these attributes properly.

We are talking about specialty userspace that is designed to work with
the sysfs layout as-is. Not udev. In some of these subdirs the
userspace does readdir() on - if you start adding random stuff it will
break it.

> > Since it seems like kind of a big problem can we make this allowed
> > somehow?
> 
> No, not at all.  Please do not do that.  I will look into the existing
> users and try to see if I can fix them up.  Maybe start annoying people
> by throwing warnings if you try to register a kobject as a child of a
> device...

How does that mesh with our don't break userspace ideal?? :(

> > Well, from what I understand, it wont be used because udev can't do
> > three level deep attributes, and if that hasn't been a problem in that
> > last 10 years for the existing places, it might not ever be needed in
> > udev at all.
> 
> If userspace is not seeing these attributes then WHY CREATE THEM AT
> ALL???

*udev* is not the userspace! People expose sysfs attributes and then
make specialty userspace to consume them! I've seen it many times now.

> Seriously, what is needing to see these in sysfs if not the tools that
> we have today to use sysfs?  Are you wanting to create new tools instead
> to handle these new attributes?  Maybe just do not create them in the
> first place?

This advice is about 10 years too late :(

Regardless, lets not do deeply nested attributes here in PCI. They are
PITA anyhow.

Jason
