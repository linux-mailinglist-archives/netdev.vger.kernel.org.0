Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8400C3239FA
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 10:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbhBXJyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 04:54:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234828AbhBXJyP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 04:54:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55AC264DE7;
        Wed, 24 Feb 2021 09:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614160414;
        bh=yPq43gjzxrgBKpMUKdRA8k7osexf6QroB0Hwxh2xhRM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J47XGjL/RWEgvCjt9OrrAs8q/K4YqViy0nMAZ8p4k1rMcVhwx8ah2cyG7f8MYtTJJ
         Aa18lAUd3hlWwBwhZFF8MrJ8fxBZw9EF+CuqJhNe+0HGjZJBhl9chcP3AKfX60DiYO
         Gq9N7GACqILJ74Db5NWffmSrH0/xelPdKBaCYYAIsYQpE4Z6B+ffXvCbQ6/TlWNshd
         F1y4uO8SzwqkcEcnmqoCqUv+DLdqyhu4KkYEV3dC8uU73UYYEU1C7IPdxph5cmy3oD
         Ms6S3E6KGOap1wtQovM1ZVzFEHQOWgFkQmocDmq334k7Td6KHIQ0BwtEnpM98k4UVT
         CNwaO6ZY5Z3/A==
Date:   Wed, 24 Feb 2021 11:53:30 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
Subject: Re: [PATCH mlx5-next v6 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <YDYiGmpWDx9I59Qx@unreal>
References: <YDIExpismOnU3c4k@unreal>
 <20210223210743.GA1475710@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223210743.GA1475710@bjorn-Precision-5520>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 03:07:43PM -0600, Bjorn Helgaas wrote:
> On Sun, Feb 21, 2021 at 08:59:18AM +0200, Leon Romanovsky wrote:
> > On Sat, Feb 20, 2021 at 01:06:00PM -0600, Bjorn Helgaas wrote:
> > > On Fri, Feb 19, 2021 at 09:20:18AM +0100, Greg Kroah-Hartman wrote:
> > >
> > > > Ok, can you step back and try to explain what problem you are trying to
> > > > solve first, before getting bogged down in odd details?  I find it
> > > > highly unlikely that this is something "unique", but I could be wrong as
> > > > I do not understand what you are wanting to do here at all.
> > >
> > > We want to add two new sysfs files:
> > >
> > >   sriov_vf_total_msix, for PF devices
> > >   sriov_vf_msix_count, for VF devices associated with the PF
> > >
> > > AFAICT it is *acceptable* if they are both present always.  But it
> > > would be *ideal* if they were only present when a driver that
> > > implements the ->sriov_get_vf_total_msix() callback is bound to the
> > > PF.
> >
> > BTW, we already have all possible combinations: static, static with
> > folder, with and without "sriov_" prefix, dynamic with and without
> > folders on VFs.
> >
> > I need to know on which version I'll get Acked-by and that version I
> > will resubmit.
>
> I propose that you make static attributes for both files, so
> "sriov_vf_total_msix" is visible for *every* PF in the system and
> "sriov_vf_msix_count" is visible for *every* VF in the system.

No problem, this is close to v0/v1.

>
> The PF "sriov_vf_total_msix" show function can return zero if there's
> no PF driver or it doesn't support ->sriov_get_vf_total_msix().
> (Incidentally, I think the documentation should mention that when it
> *is* supported, the contents of this file are *constant*, i.e., it
> does not decrease as vectors are assigned to VFs.)
>
> The "sriov_vf_msix_count" set function can ignore writes if there's no
> PF driver or it doesn't support ->sriov_get_vf_total_msix(), or if a
> VF driver is bound.

Just to be clear, why don't we return EINVAL/EOPNOTSUPP instead of
silently ignore?

Thanks
