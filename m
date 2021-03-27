Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D99334B73F
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 13:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhC0Mia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 08:38:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229627AbhC0Mia (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Mar 2021 08:38:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AF316196C;
        Sat, 27 Mar 2021 12:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616848687;
        bh=Iy5IFoCV3jFpegN8htE9TCzHt5nX7xsGq2wa29AG4Mo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ziWReXLrV1j5Yjp7ZkGCTqN8eYAezPVe1u5PhFiynFczxHVb3G6SAfgEIZJNzpa6p
         UqVs/00MPSpVWyPAe0d4iHjtLcUFqNBrGQ9NHEWS8N+XTUul/t6hmSw5H8gTPX4pP3
         HgNiDe/GfFHofOSACrlbzd6sVu5HYxwLbxgUt24M=
Date:   Sat, 27 Mar 2021 13:38:05 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Keith Busch <kbusch@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <YF8nLR3cVOc0y+Rl@kroah.com>
References: <CAKgT0UcXwNKDSP2ciEjM2AWj2xOZwBxkPCdzkUqDKAMtvTTKPg@mail.gmail.com>
 <20210326193631.GA902426@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326193631.GA902426@bjorn-Precision-5520>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 02:36:31PM -0500, Bjorn Helgaas wrote:
> On Fri, Mar 26, 2021 at 11:50:44AM -0700, Alexander Duyck wrote:
> 
> > I almost wonder if it wouldn't make sense to just partition this up to
> > handle flexible resources in the future. Maybe something like having
> > the directory setup such that you have "sriov_resources/msix/" and
> > then you could have individual files with one for the total and the
> > rest with the VF BDF naming scheme. Then if we have to, we could add
> > other subdirectories in the future to handle things like queues in the
> > future.
> 
> Subdirectories would be nice, but Greg KH said earlier in a different
> context that there's an issue with them [1].  He went on to say tools
> like udev would miss uevents for the subdirs [2].
> 
> I don't know whether that's really a problem in this case -- it
> doesn't seem like we would care about uevents for files that do MSI-X
> vector assignment.
> 
> [1] https://lore.kernel.org/linux-pci/20191121211017.GA854512@kroah.com/
> [2] https://lore.kernel.org/linux-pci/20191124170207.GA2267252@kroah.com/

You can only go "one level deep" on subdirectories tied to a 'struct
device' and have userspace tools know they are still there.  You can do
that by giving an attribute group a "name" for the directory.

Anything more than that just gets very very messy very quickly and I do
not recommend doing that at all.

thanks,

greg k-h
