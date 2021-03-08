Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926C4331722
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 20:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhCHTU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 14:20:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:47576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229790AbhCHTUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 14:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 996216529E;
        Mon,  8 Mar 2021 19:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615231249;
        bh=esK9fkuRMWQjIb5nJglJWhNgHT/wvvo1endmAFKzgWA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M9XShbf/F0QT4XNnppXFxIhDqbxY+3ueSye/Q70v+fQv6HJauRHkLkOkZ/rGoIU4g
         w15sNA3cIapggePoVAkZP0gpaUipJchpGPP3KSNMWj4DqTznQ8eOZGbAoE0x0QxsEm
         05m/sfhsa9edv1Mv/Zfqje4bwbg+EPv2nSm5OGWpY5j+s1GQaJcGj0WXqf/de2CLzh
         NN+/+HCGy193e+qAieWg2E0DIokIWAUtVpBL/tgJC1YUV0Ob7lxHpwrCVn/oIA1iK7
         2/xypvvHYaQgY4i0l9Sn3zPeYvNik7CyFobBU3Tep5NvOMX73hEVGv7RqZbx21NFJY
         XfpDoUTDaEFdw==
Date:   Mon, 8 Mar 2021 21:20:45 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <YEZ5DRk19Gag06nq@unreal>
References: <20210301075524.441609-1-leon@kernel.org>
 <CAKgT0Ue=g+1pZCct8Kd0OnkPEP0qhggBF96s=noDoWHMJTL6FA@mail.gmail.com>
 <YEUnVcW+lIXBlqT1@unreal>
 <CAKgT0UdzjeD7fnE6kX2qN6V4ZddSV2ZMnONEwGXhwkSwoUXUug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UdzjeD7fnE6kX2qN6V4ZddSV2ZMnONEwGXhwkSwoUXUug@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 08, 2021 at 08:33:03AM -0800, Alexander Duyck wrote:
> On Sun, Mar 7, 2021 at 11:19 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Sun, Mar 07, 2021 at 10:55:24AM -0800, Alexander Duyck wrote:
> > > On Sun, Feb 28, 2021 at 11:55 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > >
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > >
> > > > @Alexander Duyck, please update me if I can add your ROB tag again
> > > > to the series, because you liked v6 more.
> > > >
> > > > Thanks
> > > >
> > > > ---------------------------------------------------------------------------------
> > > > Changelog
> > > > v7:
> > > >  * Rebase on top v5.12-rc1
> > > >  * More english fixes
> > > >  * Returned to static sysfs creation model as was implemented in v0/v1.
> > >
> > > Yeah, so I am not a fan of the series. The problem is there is only
> > > one driver that supports this, all VFs are going to expose this sysfs,
> > > and I don't know how likely it is that any others are going to
> > > implement this functionality. I feel like you threw out all the
> > > progress from v2-v6.
> >
> > I'm with you here and tried to present the rationale in v6 when had
> > a discussion with Bjorn, so it is unfair to say "you threw out".
> >
> > Bjorn expressed his preference, and no one came forward to support v6.
>
> Sorry, it wasn't my intention to be accusatory. I'm just not a fan of
> going back to where we were with v1.
>
> With that said, if it is what Bjorn wants then you are probably better
> off going with that. However if that is the direction we are going in
> then you should probably focus on getting his Reviewed-by or Ack since
> he will ultimately be the maintainer for the code.

I hope that he will do it soon.

>
> > >
> > > I really feel like the big issue is that this model is broken as you
> > > have the VFs exposing sysfs interfaces that make use of the PFs to
> > > actually implement. Greg's complaint was the PF pushing sysfs onto the
> > > VFs. My complaint is VFs sysfs files operating on the PF. The trick is
> > > to find a way to address both issues.
> >
> > It is hard to say something meaningful about Greg's complain, he was
> > added in the middle of the discussion without much chances to get full
> > picture.
>
> Right, but what I am getting at is that the underlying problem is that
> you either have sysfs being pushed onto a remote device, or sysfs that
> is having to call into another device. It's not exactly something we
> have had precedent for enabling before, and either perspective seems a
> bit ugly.

I don't agree with the word "ugly", but it is not the point. The point
is that this interface is backed by the ecosystem and must-to-be for the
right SR-IOV utilization.

>
> > >
> > > Maybe the compromise is to reach down into the IOV code and have it
> > > register the sysfs interface at device creation time in something like
> > > pci_iov_sysfs_link if the PF has the functionality present to support
> > > it.
> >
> > IMHO, it adds nothing.
>
> My thought was to reduce clutter. As I mentioned before with this
> patch set we are enabling sysfs for functionality that is currently
> only exposed by one device. I'm not sure it will be used by many
> others or not. Having these sysfs interfaces instantiated at probe
> time or at creation time in the case of VFs was preferable to me.

I said that in v6 to Bjorn, that I expect up to 2-3 vendors to support
this knob. There are not many devices in the market that are comparable
to the mlx5 both in their complexity and adoption.

Thanks
