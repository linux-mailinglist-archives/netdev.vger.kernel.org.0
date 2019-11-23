Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 814A0107CD0
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 05:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfKWEjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 23:39:21 -0500
Received: from mga06.intel.com ([134.134.136.31]:35372 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbfKWEjV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 23:39:21 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 20:39:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,232,1571727600"; 
   d="scan'208";a="205590768"
Received: from dpdk-virtio-tbie-2.sh.intel.com (HELO ___) ([10.67.104.74])
  by fmsmga008.fm.intel.com with ESMTP; 22 Nov 2019 20:39:17 -0800
Date:   Sat, 23 Nov 2019 12:39:51 +0800
From:   Tiwei Bie <tiwei.bie@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191123043951.GA364267@___>
References: <134058913.35624136.1574222360435.JavaMail.zimbra@redhat.com>
 <20191120133835.GC22515@ziepe.ca>
 <20191120102856.7e01e2e2@x1.home>
 <20191120181108.GJ22515@ziepe.ca>
 <20191120150732.2fffa141@x1.home>
 <20191121030357.GB16914@ziepe.ca>
 <5dcef4ab-feb5-d116-b2a9-50608784a054@redhat.com>
 <20191121141732.GB7448@ziepe.ca>
 <721e49c2-a2e1-853f-298b-9601c32fcf9e@redhat.com>
 <20191122180214.GD7448@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191122180214.GD7448@ziepe.ca>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 02:02:14PM -0400, Jason Gunthorpe wrote:
> On Fri, Nov 22, 2019 at 04:45:38PM +0800, Jason Wang wrote:
> > On 2019/11/21 下午10:17, Jason Gunthorpe wrote:
> > > On Thu, Nov 21, 2019 at 03:21:29PM +0800, Jason Wang wrote:
> > > > > The role of vfio has traditionally been around secure device
> > > > > assignment of a HW resource to a VM. I'm not totally clear on what the
> > > > > role if mdev is seen to be, but all the mdev drivers in the tree seem
> > > > > to make 'and pass it to KVM' a big part of their description.
> > > > > 
> > > > > So, looking at the virtio patches, I see some intended use is to map
> > > > > some BAR pages into the VM.
> > > > Nope, at least not for the current stage. It still depends on the
> > > > virtio-net-pci emulatio in qemu to work. In the future, we will allow such
> > > > mapping only for dorbell.
> > > There has been a lot of emails today, but I think this is the main
> > > point I want to respond to.
> > > 
> > > Using vfio when you don't even assign any part of the device BAR to
> > > the VM is, frankly, a gigantic misuse, IMHO.
> > 
> > That's not a compelling point. 
> 
> Well, this discussion is going nowhere.

You removed JasonW's other reply in above quote. He said it clearly
that we do want/need to assign parts of device BAR to the VM.

> 
> > > Just needing userspace DMA is not, in any way, a justification to use
> > > vfio.
> > > 
> > > We have extensive library interfaces in the kernel to do userspace DMA
> > > and subsystems like GPU and RDMA are full of example uses of this kind
> > > of stuff.
> > 
> > I'm not sure which library did you mean here. Is any of those library used
> > by qemu? If not, what's the reason?
> 
> I mean the library functions in the kernel that vfio uses to implement
> all the user dma stuff. Other subsystems use them too, it is not
> exclusive to vfio.

IIUC, your point is to suggest us invent new DMA API for userspace to
use instead of leveraging VFIO's well defined DMA API. Even if we don't
use VFIO at all, I would imagine it could be very VFIO-like (e.g. caps
for BAR + container/group for DMA) eventually.

> 
> > > Further, I do not think it is wise to design the userspace ABI around
> > > a simplistict implementation that can't do BAR assignment,
> > 
> > Again, the vhost-mdev follow the VFIO ABI, no new ABI is invented, and
> > mmap() was kept their for mapping device regions.
> 
> The patches have a new file in include/uapi.

I guess you didn't look at the code. Just to clarify, there is no
new file introduced in include/uapi. Only small vhost extensions to
the existing vhost uapi are involved in vhost-mdev.

> 
