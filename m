Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18142E5EBC
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 20:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfJZSxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 14:53:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbfJZSxm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 14:53:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C5B920679;
        Sat, 26 Oct 2019 18:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572116020;
        bh=n+kEyU6+PGJjH2XR+N7wGK//VrFS1Z13Ae9uB82AeLI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f+PlJK6JGofWboFUpywSerq+KYkNablyHTYrQZFjW2c6zm/Rw58UuCkCgvLZKNUg7
         QrBaP+oQvYZrdVfkptjGvWmBPX7ufZVOhY0bZpOcDnRFIzQWMocwNV3mECBdJ3427Z
         0+6SgJpauGaw5bUyJJPXy8GT4HbZjxCrA0ZMd83U=
Date:   Sat, 26 Oct 2019 20:53:38 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Ertman, David M" <david.m.ertman@intel.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>
Subject: Re: [RFC 01/20] ice: Initialize and register multi-function device
 to provide RDMA
Message-ID: <20191026185338.GA804892@kroah.com>
References: <20190927051320.GA1767635@kroah.com>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B2B1A28@ORSMSX101.amr.corp.intel.com>
 <20191023174448.GP23952@ziepe.ca>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B2E0C84@ORSMSX101.amr.corp.intel.com>
 <20191023180108.GQ23952@ziepe.ca>
 <20191024185659.GE260560@kroah.com>
 <20191024191037.GC23952@ziepe.ca>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B2E1D29@ORSMSX101.amr.corp.intel.com>
 <20191025013048.GB265361@kroah.com>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B2E2FE6@ORSMSX101.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2B0E3F215D1AB84DA946C8BEE234CCC97B2E2FE6@ORSMSX101.amr.corp.intel.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 10:27:46PM +0000, Ertman, David M wrote:
> > -----Original Message-----
> > From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> > Sent: Thursday, October 24, 2019 6:31 PM
> > To: Ertman, David M <david.m.ertman@intel.com>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>; Nguyen, Anthony L
> > <anthony.l.nguyen@intel.com>; Kirsher, Jeffrey T
> > <jeffrey.t.kirsher@intel.com>; netdev@vger.kernel.org; linux-
> > rdma@vger.kernel.org; dledford@redhat.com; Ismail, Mustafa
> > <mustafa.ismail@intel.com>; Patil, Kiran <kiran.patil@intel.com>;
> > lee.jones@linaro.org
> > Subject: Re: [RFC 01/20] ice: Initialize and register multi-function device to
> > provide RDMA
> > 
> > On Thu, Oct 24, 2019 at 10:25:36PM +0000, Ertman, David M wrote:
> > > The direct access of the platform bus was unacceptable, and the MFD
> > > sub-system was suggested by Greg as the solution.  The MFD sub-system
> > > uses the platform bus in the background as a base to perform its
> > > functions, since it is a purely software construct that is handy and
> > > fulfills its needs.  The question then is:  If the MFD sub- system is
> > > using the platform bus for all of its background functionality, is the platform
> > bus really only for platform devices?
> > 
> > Yes, how many times do I have to keep saying this?
> > 
> > The platform bus should ONLY be used for devices that are actually platform
> > devices and can not be discovered any other way and are not on any other type
> > of bus.
> > 
> > If you try to add platform devices for a PCI device, I am going to continue to
> > complain.  I keep saying this and am getting tired.
> > 
> > Now yes, MFD does do "fun" things here, and that should probably be fixed up
> > one of these days.  But I still don't see why a real bus would not work for you.
> > 
> > greg "platform devices are dead, long live the platform device" k-h
> 
> > -----Original Message-----
> > From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> > Sent: Thursday, October 24, 2019 6:31 PM
> > To: Ertman, David M <david.m.ertman@intel.com>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>; Nguyen, Anthony L
> > <anthony.l.nguyen@intel.com>; Kirsher, Jeffrey T
> > <jeffrey.t.kirsher@intel.com>; netdev@vger.kernel.org; linux-
> > rdma@vger.kernel.org; dledford@redhat.com; Ismail, Mustafa
> > <mustafa.ismail@intel.com>; Patil, Kiran <kiran.patil@intel.com>;
> > lee.jones@linaro.org
> > Subject: Re: [RFC 01/20] ice: Initialize and register multi-function device to
> > provide RDMA
> > 
> > On Thu, Oct 24, 2019 at 10:25:36PM +0000, Ertman, David M wrote:
> > > The direct access of the platform bus was unacceptable, and the MFD
> > > sub-system was suggested by Greg as the solution.  The MFD sub-system
> > > uses the platform bus in the background as a base to perform its
> > > functions, since it is a purely software construct that is handy and
> > > fulfills its needs.  The question then is:  If the MFD sub- system is
> > > using the platform bus for all of its background functionality, is the platform
> > bus really only for platform devices?
> > 
> > Yes, how many times do I have to keep saying this?
> > 
> > The platform bus should ONLY be used for devices that are actually platform
> > devices and can not be discovered any other way and are not on any other type
> > of bus.
> > 
> > If you try to add platform devices for a PCI device, I am going to continue to
> > complain.  I keep saying this and am getting tired.
> > 
> > Now yes, MFD does do "fun" things here, and that should probably be fixed up
> > one of these days.  But I still don't see why a real bus would not work for you.
> > 
> > greg "platform devices are dead, long live the platform device" k-h
> 
> I'm sorry, the last thing I want to do is to annoy you! I just need to
> figure out where to go from here.  Please, don't take anything I say as
> argumentative.
> 
> I don't understand what you mean by "a real bus".  The irdma driver does
> not have access to any physical bus.  It utilizes resources provided by
> the PCI LAN drivers, but to receive those resources it needs a mechanism
> to "hook up" with the PCI drivers.  The only way it has to locate them
> is to register a driver function with a software based bus of some kind
> and have the bus match it up to a compatible entity to achieve that hook up.
> 
> The PCI LAN driver has a function that controls the PCI hardware, and then
> we want to present an entity for the RDMA driver to connect to.
> 
> To move forward, we are thinking of the following design proposal:
> 
> We could add a new module to the kernel named generic_bus.ko.  This would
> create a new generic software bus and a set of APIs that would allow for
> adding and removing simple generic virtual devices and drivers, not as
> a MFD cell or a platform device. The power management events would also
> be handled by the generic_bus infrastructure (suspend, resume, shutdown).
> We would use this for matching up by having the irdma driver register
> with this generic bus and hook to virtual devices that were added from
> different PCI LAN drivers.
> 
> Pros:
> 1) This would avoid us attaching anything to the platform bus
> 2) Avoid having each PCI LAN driver creating its own software bus
> 3) Provide a common matching ground for generic devices and drivers that
> eliminates problems caused by load order (all dependent on generic_bus.ko)
> 4) Usable by any other entity that wants a lightweight matching system
> or information exchange mechanism
> 
> Cons:
> 1) Duplicates part of the platform bus functionality
> 2) Adds a new software bus to the kernel architecture
> 
> Is this path forward acceptable?

Yes, that is much better.  But how about calling it a "virtual bus"?
It's not really virtualization, but we already have virtual devices
today when you look in sysfs for devices that are created that are not
associated with any specific bus.  So this could take those over quite
nicely!  Look at how /sys/devices/virtual/ works for specifics, you
could create a new virtual bus of a specific "name" and then add devices
to that bus directly.

thanks,

greg k-h
