Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21EB3502E6
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 17:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235592AbhCaPEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 11:04:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235452AbhCaPDs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 11:03:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56FE561008;
        Wed, 31 Mar 2021 15:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617203028;
        bh=863aX93AcJHX1oErxRoyJSXA0uo+jfXjrQ8F/dyxdH8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xh1wvdJgrfNbVSxMWd2RWOfST3I77c9iE+kBXf899KrVQhqBj520UpRXxmLxnFxE1
         ccntcEOWgLFxmyp0WUOygh+8bKxGtpuYOrStECMBzTuZgdVjtp4/gpnPQLiXP6K2yZ
         +TxHrU1ngxOkpxDCyCX1cFbSkR+E4fF3UyJi94q8=
Date:   Wed, 31 Mar 2021 17:03:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
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
Message-ID: <YGSPUewD5J+F7ZRe@kroah.com>
References: <20210330194716.GV2710221@ziepe.ca>
 <20210330204141.GA1305530@bjorn-Precision-5520>
 <20210330224341.GW2710221@ziepe.ca>
 <YGQY72LnGB6bfIsI@kroah.com>
 <20210331121929.GX2710221@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331121929.GX2710221@ziepe.ca>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 09:19:29AM -0300, Jason Gunthorpe wrote:
> On Wed, Mar 31, 2021 at 08:38:39AM +0200, Greg Kroah-Hartman wrote:
> > On Tue, Mar 30, 2021 at 07:43:41PM -0300, Jason Gunthorpe wrote:
> > > > With 0000:01:00.0/sriov/BB:DD.F/vf_msix_count, sriov/ will contain
> > > > 1 file and 1K subdirectories.
> > > 
> > > The smallest directory sizes is with the current patch since it
> > > re-uses the existing VF directory. Do we care about directory size at
> > > the sysfs level?
> > 
> > No, that should not matter.
> > 
> > The "issue" here is that you "broke" the device chain here by adding a
> > random kobject to the directory tree: "BB:DD.F"
> > 
> > Again, devices are allowed to have attributes associated with it to be
> > _ONE_ subdirectory level deep.
> > 
> > So, to use your path above, this is allowed:
> > 	0000:01:00.0/sriov/vf_msix_count
> > 
> > as these are sriov attributes for the 0000:01:00.0 device, but this is
> > not:
> > 	0000:01:00.0/sriov/BB:DD.F/vf_msix_count
> > as you "threw" a random kobject called BB:DD.F into the middle.
> >
> > If you want to have "BB:DD.F" in there, then it needs to be a real
> > struct device and _THEN_ it needs to point its parent to "0000:01:00.0",
> > another struct device, as "sriov" is NOT ANYTHING in the heirachy here
> > at all.
> 
> It isn't a struct device object at all though, it just organizing
> attributes.

That's the point, it really is not.  You are forced to create a real
object for that subdirectory, and by doing so, you are "breaking" the
driver/device model.  As is evident by userspace not knowing what is
going on here.

> > Does that help?  The rules are:
> > 	- Once you use a 'struct device', all subdirs below that device
> > 	  are either an attribute group for that device or a child
> > 	  device.
> > 	- A struct device can NOT have an attribute group as a parent,
> > 	  it can ONLY have another struct device as a parent.
> > 
> > If you break those rules, the kernel has the ability to get really
> > confused unless you are very careful, and userspace will be totally lost
> > as you can not do anything special there.
> 
> The kernel gets confused?

Putting a kobject as a child of a struct device can easily cause
confusion as that is NOT what you should be doing.  Especially if you
then try to add a device to be a child of that kobject.  Now the kernel
core can not walk all devices in the correct order and lots of other
problems that you are lucky you do not hit.

> I'm not sure I understand why userspace gets confused. I can guess
> udev has some issue, but everything else seems OK, it is just a path.

No, it is not a "path".

Again, here are the driver/device model rules:
	- once you have a "struct device", only "struct device" can be
	  children.
	- You are allowed to place attributes in subdirectories if you
	  want to make things cleaner.  Don't make me doubt giving that
	  type of permission to people by trying to abuse it by going
	  "lower" than one level.
	- If you have to represent something dynamic below a struct
	  device that is not an attribute, make it a real struct device.

And userspace "gets confused" because it thinks it can properly walk the
tree and get a record of all devices in the system.  When you put a
kobject in there just to make a new subdirectory, you break the
notification model and everything else.

Again, do not do that.

> > > > I'm dense and don't fully understand Greg's subdirectory comment.
> > > 
> > > I also don't know udev well enough. I've certainly seen drivers
> > > creating extra subdirectories using kobjects.
> > 
> > And those drivers are broken.  Please point them out to me and I will be
> > glad to go fix them.  Or tell their authors why they are broken :)
> 
> How do you fix them? It is uAPI at this point so we can't change the
> directory names. Can't make them struct devices (userspace would get
> confused if we add *more* sysfs files)

How would userspace get confused?  If anything it would suddenly "wake
up" and see these attributes properly.

> Grep for kobject_init_and_add() under drivers/ and I think you get a
> pretty good overview of the places.

Yes, lots of places where people are abusing things and it should not be
done.  Do not add to the mess by knowingly adding broken code please.

> Since it seems like kind of a big problem can we make this allowed
> somehow?

No, not at all.  Please do not do that.  I will look into the existing
users and try to see if I can fix them up.  Maybe start annoying people
by throwing warnings if you try to register a kobject as a child of a
device...

> > > > But it doesn't seem like that level of control would be in a udev rule
> > > > anyway.  A PF udev rule might *start* a program to manage MSI-X
> > > > vectors, but such a program should be able to deal with whatever
> > > > directory structure we want.
> > >
> > > Yes, I can't really see this being used from udev either. 
> > 
> > It doesn't matter if you think it could be used, it _will_ be used as
> > you are exposing this stuff to userspace.
> 
> Well, from what I understand, it wont be used because udev can't do
> three level deep attributes, and if that hasn't been a problem in that
> last 10 years for the existing places, it might not ever be needed in
> udev at all.

If userspace is not seeing these attributes then WHY CREATE THEM AT
ALL???

Seriously, what is needing to see these in sysfs if not the tools that
we have today to use sysfs?  Are you wanting to create new tools instead
to handle these new attributes?  Maybe just do not create them in the
first place?

> > > I assume there is also the usual race about triggering the uevent
> > > before the subdirectories are created, but we have the
> > > dev_set_uevent_suppress() thing now for that..
> > 
> > Unless you are "pci bus code" you shouldn't be using that :)
> 
> There are over 40 users now.

Let's not add more if you do not have to.  PCI has not needed it so far,
no need to rush to add it here if at all possible please.

thanks,

greg k-h
