Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03C6337E7E
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 20:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhCKTwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 14:52:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:49532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229490AbhCKTvz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 14:51:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16F5C64F80;
        Thu, 11 Mar 2021 19:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615492314;
        bh=2KlA7EfVuhHt9Lg7khxrZsPO9Aw6CY4WB7/VJn7+giM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G6o2P1PKtqem7HP4l0h6g27R6D8sLxNRlMz+vpy2lkFpuutiOOpcp9j9ZoGTLyjP0
         eNxsvN85ObsVGUDXX+JOCpZ0W9XRopKRLCu/fY/C9GSiyijxEzH7DgJTGUtfRhKnY5
         f8Y0WJ5qbwqzzH0Tlz6iYfweSZ8/U6R6dQoBqcQW22aqVG15RNSUtj6+7ft8YvQkZ9
         zfMAEq0E1T8Pttquy/dtDzPW9CqAqtmXEP2UX4Oukg1VUBYncQ2IvfouLHRSPKtBn5
         i/IufPLOqP0zteJcueUS1NVBT0bx6Q3a/yMoWlUHOoq/y4KgzgBuNSd89u7g6DDtDp
         IswmIV+KbYXmQ==
Date:   Thu, 11 Mar 2021 21:51:50 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
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
Message-ID: <YEp01m0GiNzOSUV8@unreal>
References: <CAKgT0UevrCLSQp=dNiHXWFu=10OiPb5PPgP1ZkPN1uKHfD=zBQ@mail.gmail.com>
 <20210311181729.GA2148230@bjorn-Precision-5520>
 <CAKgT0UeprjR8QCQMCV8Le+Br=bQ7j2tCE6k6gxK4zCZML5woAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UeprjR8QCQMCV8Le+Br=bQ7j2tCE6k6gxK4zCZML5woAA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 11:37:28AM -0800, Alexander Duyck wrote:
> On Thu, Mar 11, 2021 at 10:17 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> >
> > On Wed, Mar 10, 2021 at 03:34:01PM -0800, Alexander Duyck wrote:
> > > On Wed, Mar 10, 2021 at 11:09 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > > > On Sun, Mar 07, 2021 at 10:55:24AM -0800, Alexander Duyck wrote:
> > > > > On Sun, Feb 28, 2021 at 11:55 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > >
> > > > > > @Alexander Duyck, please update me if I can add your ROB tag again
> > > > > > to the series, because you liked v6 more.
> > > > > >
> > > > > > Thanks
> > > > > >
> > > > > > ---------------------------------------------------------------------------------
> > > > > > Changelog
> > > > > > v7:
> > > > > >  * Rebase on top v5.12-rc1
> > > > > >  * More english fixes
> > > > > >  * Returned to static sysfs creation model as was implemented in v0/v1.

<...>

> > > representors rather than being actual PCIe devices. Having
> > > functionality that only works when the VF driver is not loaded just
> > > feels off. The VF sysfs directory feels like it is being used as a
> > > subdirectory of the PF rather than being a device on its own.
> >
> > Moving "virtfnX_msix_count" to the PF seems like it would mitigate
> > this somewhat.  I don't know how to make this work while a VF driver
> > is bound without making the VF feel even less like a PCIe device,
> > i.e., we won't be able to use the standard MSI-X model.
>
> Yeah, I actually do kind of like that idea. In addition it would
> address one of the things I pointed out as an issue before as you
> could place the virtfn values that the total value in the same folder
> so that it is all in one central spot rather than having to walk all
> over the sysfs hierarchy to check the setting for each VF when trying
> to figure out how the vectors are currently distributed.

User binds specific VF with specific PCI ID to VM, so instead of
changing MSI-X table for that specific VF, he will need to translate
from virtfn25_msix_count to PCI ID.

I also gave an example of my system where I have many PFs and VFs
function numbers are not distributed nicely. On that system virtfn25_msix_count
won't translate to AA:BB:CC.25 but to something else.

Thanks
