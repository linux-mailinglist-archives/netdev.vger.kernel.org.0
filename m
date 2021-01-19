Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078BA2FB139
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 07:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbhASGWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 01:22:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:58266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731911AbhASFob (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 00:44:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A50420707;
        Tue, 19 Jan 2021 05:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611035030;
        bh=ARoB+UWuVqmI6HBQVjLPKm6Lz3T27r5zvxMQw3PNPH0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TTpW4hvXm+IFVIW9dl8WNqoeNjIGEUumWZR0/gXNjhwW8Dvd3gqVLPF1ZBJCbJA9X
         BDi5qJhhlbJ1ZmVDoRPzSk/aEMnI4arRljiMdKscGlvENdHoSap+RMXiEbGjJIUKo9
         ZDvBgxWsE0tGFErVuaSJTKwHuBBWfFtg291lx5nuC63rpEnqLAZDgsHyoVnfWRbECw
         19q6uFVz52tkiIepIwqWLgz4KAXl2LpPd2sslP/ghmXAdZXZN6mPMW8BpEGmJZgND9
         GWvdOarmW5kBFldXfvUflBx4rygRmNvMHPMCs2tMXjuILIB+1DwpmAIdjb+5b83fJr
         HQlPWtlY3dMhQ==
Date:   Tue, 19 Jan 2021 07:43:46 +0200
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
Message-ID: <20210119054346.GD21258@unreal>
References: <20210114162812.268d684a@omen.home.shazbot.org>
 <CAKgT0Ufe1w4PpZb3NXuSxug+OMcjm1RP3ZqVrJmQqBDt3ByOZQ@mail.gmail.com>
 <20210115140619.GA4147@nvidia.com>
 <20210115155315.GJ944463@unreal>
 <CAKgT0UdzCqbLwxSnDTtgha+PwTMW5iVb-3VXbwdMNiaAYXyWzQ@mail.gmail.com>
 <20210116082031.GK944463@unreal>
 <CAKgT0UeKiz=gh+djt83GRBGi8qQWTBzs-qxKj_78N+gx-KtkMQ@mail.gmail.com>
 <20210118072008.GA4843@unreal>
 <20210118132800.GA4835@unreal>
 <CAKgT0UeYb5xz8iehE1Y0s-cyFbsy46bjF83BkA7qWZMkAOLR-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UeYb5xz8iehE1Y0s-cyFbsy46bjF83BkA7qWZMkAOLR-g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 10:21:03AM -0800, Alexander Duyck wrote:
> On Mon, Jan 18, 2021 at 5:28 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Mon, Jan 18, 2021 at 09:20:08AM +0200, Leon Romanovsky wrote:
> > > On Sun, Jan 17, 2021 at 07:16:30PM -0800, Alexander Duyck wrote:
> > > > On Sat, Jan 16, 2021 at 12:20 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > > >
> > > > > On Fri, Jan 15, 2021 at 05:48:59PM -0800, Alexander Duyck wrote:
> > > > > > On Fri, Jan 15, 2021 at 7:53 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > > > > >
> > > > > > > On Fri, Jan 15, 2021 at 10:06:19AM -0400, Jason Gunthorpe wrote:
> > > > > > > > On Thu, Jan 14, 2021 at 05:56:20PM -0800, Alexander Duyck wrote:
> >
> > <...>
> >
> > > > If you want yet another compromise I would be much happier with the PF
> > > > registering the sysfs interfaces on the VFs rather than the VFs
> > > > registering the interface and hoping the PF supports it. At least with
> > > > that you are guaranteed the PF will respond to the interface when it
> > > > is registered.
> > >
> > > Thanks a lot, I appreciate it, will take a look now.
> >
> > I found only two solutions to implement it in this way.
> > Option 1.
> > Allow multi entry write to some new sysfs knob that will receive BDF (or another VF
> > identification) and vector count. Something like this:
> >
> >  echo "0000:01:00.2 123" > sriov_vf_msix_count
> >
> > From one side, that solution is unlikely to be welcomed by Greg KH and from another,
> > it will require a lot of boilerplate code to make it safe and correct.
>
> You are overthinking this. I didn't say the sysfs had to be in the PF
> directory itself. My request was that the PF is what placed the sysfs
> file in the directory since indirectly it is responsible for spawning
> the VF anyway it shouldn't be too much of a lift to have the PF place
> sysfs files in the VF hierarchy.
>
> The main piece I am not a fan of is the fact that the VF is blindly
> registering an interface and presenting it without knowing if it even
> works.
>
> The secondary issue that I see as important, but I am willing to
> compromise on is that the interface makes it appear as though the VF
> configuration space is writable via this sysfs file. My preference
> would be to somehow make it transparent that the PF is providing this
> functionality. I thought it might be easier to do with devlink rather
> than with sysfs which is why I have been preferring devlink. However
> based on your pushback I am willing to give up on that, but I think we
> still need to restructure how the sysfs is being managed.
>
> > Option 2.
> > Create directory under PF device with files writable and organized by VF numbers.
> > It is doable, but will cause to code bloat with no gain at all. Cleaner than now,
> > it won't be.
> >
> > Why the current approach with one file per-proper VF device is not good enough?
>
> Because it is muddying the waters in terms of what is control taking
> place from the VF versus the PF. In my mind the ideal solution if you
> insist on going with the VF sysfs route would be to look at spawning a
> directory inside the VF sysfs specifically for all of the instances
> that will be PF management controls. At least that would give some
> hint that this is a backdoor control and not actually interacting with
> the VF PCI device directly. Then if in the future you have to add more
> to this you have a spot already laid out and the controls won't be
> mistaken for standard PCI controls as they are PF management controls.
>
> In addition you could probably even create a directory on the PF with
> the new control you had added for getting the master count as well as
> look at adding symlinks to the VF files so that you could manage all
> of the resources in one spot. That would result in the controls being
> nicely organized and easy to use.

Thanks, for you inputs.

I'll try offline different variants and will post v4 soon.
