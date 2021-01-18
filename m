Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627B12FA193
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 14:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404035AbhARN3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 08:29:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:34536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392217AbhARN2t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 08:28:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E33D206B5;
        Mon, 18 Jan 2021 13:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610976485;
        bh=UmiixWBNdjkivF9FYr78Zj5u4oftJvSEwMizR+p6/xI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=as5qI4UZlYECI4bU/hA/EeenIP9833ek9zOgEhe1lPCGB7xwMlKJfQ4Ef61KFXywS
         i74e+Y8dbyCyZlMVyMndjsqDgFAEFCf/XMyFVnEldQC5u/6vQLsJAT9ICyuvXMH9Wk
         wvIg5i1hy/jBoSODXXzNljfI6dcNYtGucDLihwGohxw28T2l0BVUyWvZzbR7KzdKnd
         /GXmBbtFDM3jt1+yEYKzGJcv6IozhUzCP4/CXVFKMHu3WyBI3HGbKxyxdGZhpVlJbo
         V3g/O6ha/Dte4WUIdQsgmqs17j34NRa780/odsZzHf0VnsU1Xof6bWbjURq31CF597
         fE0n8lkgumeaw==
Date:   Mon, 18 Jan 2021 15:28:00 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH mlx5-next v1 2/5] PCI: Add SR-IOV sysfs entry to read
 number of MSI-X vectors
Message-ID: <20210118132800.GA4835@unreal>
References: <20210114200825.GR4147@nvidia.com>
 <CAKgT0UcaRgY4XnM0jgWRvwBLj+ufiabFzKPyrf3jkLrF1Z8zEg@mail.gmail.com>
 <20210114162812.268d684a@omen.home.shazbot.org>
 <CAKgT0Ufe1w4PpZb3NXuSxug+OMcjm1RP3ZqVrJmQqBDt3ByOZQ@mail.gmail.com>
 <20210115140619.GA4147@nvidia.com>
 <20210115155315.GJ944463@unreal>
 <CAKgT0UdzCqbLwxSnDTtgha+PwTMW5iVb-3VXbwdMNiaAYXyWzQ@mail.gmail.com>
 <20210116082031.GK944463@unreal>
 <CAKgT0UeKiz=gh+djt83GRBGi8qQWTBzs-qxKj_78N+gx-KtkMQ@mail.gmail.com>
 <20210118072008.GA4843@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118072008.GA4843@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 09:20:08AM +0200, Leon Romanovsky wrote:
> On Sun, Jan 17, 2021 at 07:16:30PM -0800, Alexander Duyck wrote:
> > On Sat, Jan 16, 2021 at 12:20 AM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > On Fri, Jan 15, 2021 at 05:48:59PM -0800, Alexander Duyck wrote:
> > > > On Fri, Jan 15, 2021 at 7:53 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > > >
> > > > > On Fri, Jan 15, 2021 at 10:06:19AM -0400, Jason Gunthorpe wrote:
> > > > > > On Thu, Jan 14, 2021 at 05:56:20PM -0800, Alexander Duyck wrote:

<...>

> > If you want yet another compromise I would be much happier with the PF
> > registering the sysfs interfaces on the VFs rather than the VFs
> > registering the interface and hoping the PF supports it. At least with
> > that you are guaranteed the PF will respond to the interface when it
> > is registered.
>
> Thanks a lot, I appreciate it, will take a look now.

I found only two solutions to implement it in this way.
Option 1.
Allow multi entry write to some new sysfs knob that will receive BDF (or another VF
identification) and vector count. Something like this:

 echo "0000:01:00.2 123" > sriov_vf_msix_count

From one side, that solution is unlikely to be welcomed by Greg KH and from another,
it will require a lot of boilerplate code to make it safe and correct.

Option 2.
Create directory under PF device with files writable and organized by VF numbers.
It is doable, but will cause to code bloat with no gain at all. Cleaner than now,
it won't be.

Why the current approach with one file per-proper VF device is not good enough?

Thanks
