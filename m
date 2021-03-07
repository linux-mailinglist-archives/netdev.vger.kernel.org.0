Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF99C330434
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 20:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbhCGTUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 14:20:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231162AbhCGTTy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Mar 2021 14:19:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E01C4650B4;
        Sun,  7 Mar 2021 19:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615144793;
        bh=90FiEZxZT00j65VyfA0AM5/U3rAujXSlyrhkbSDs89E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F60Lam6JqX6gFlpgunyzI2hikGrx0QsW/1cP+3TudKZEyyRkbZ0tc/+ZFfFOxBoOz
         cPlE6GnrbmzmEXzjY5kgfR4oIqSjntgIfM/IvsRQkyDe6fIuRbGlr9f+5jL8TP8+oB
         LoaDvUu8MmM1nAE7zwZmsBaHaoYrtBGUoB2HAjufEMgjiDyjyEi2aVMyQXCMsExpqQ
         yXRbzhU5O/AaqyIgJRlBeAYYRl8lC/wBcnyH1sDdxZgPuEKriWktYShr9wC8ZYDgJg
         xWZnE3tSvkuZM8E6Ib/E1J0YAnrsQvvurVQOOLelMSY5O+2kxsaALgTPTfJtsG++YS
         kBK3RVsmHMnSA==
Date:   Sun, 7 Mar 2021 21:19:49 +0200
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
Message-ID: <YEUnVcW+lIXBlqT1@unreal>
References: <20210301075524.441609-1-leon@kernel.org>
 <CAKgT0Ue=g+1pZCct8Kd0OnkPEP0qhggBF96s=noDoWHMJTL6FA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Ue=g+1pZCct8Kd0OnkPEP0qhggBF96s=noDoWHMJTL6FA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 07, 2021 at 10:55:24AM -0800, Alexander Duyck wrote:
> On Sun, Feb 28, 2021 at 11:55 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > @Alexander Duyck, please update me if I can add your ROB tag again
> > to the series, because you liked v6 more.
> >
> > Thanks
> >
> > ---------------------------------------------------------------------------------
> > Changelog
> > v7:
> >  * Rebase on top v5.12-rc1
> >  * More english fixes
> >  * Returned to static sysfs creation model as was implemented in v0/v1.
>
> Yeah, so I am not a fan of the series. The problem is there is only
> one driver that supports this, all VFs are going to expose this sysfs,
> and I don't know how likely it is that any others are going to
> implement this functionality. I feel like you threw out all the
> progress from v2-v6.

I'm with you here and tried to present the rationale in v6 when had
a discussion with Bjorn, so it is unfair to say "you threw out".

Bjorn expressed his preference, and no one came forward to support v6.

>
> I really feel like the big issue is that this model is broken as you
> have the VFs exposing sysfs interfaces that make use of the PFs to
> actually implement. Greg's complaint was the PF pushing sysfs onto the
> VFs. My complaint is VFs sysfs files operating on the PF. The trick is
> to find a way to address both issues.

It is hard to say something meaningful about Greg's complain, he was
added in the middle of the discussion without much chances to get full
picture.

>
> Maybe the compromise is to reach down into the IOV code and have it
> register the sysfs interface at device creation time in something like
> pci_iov_sysfs_link if the PF has the functionality present to support
> it.

IMHO, it adds nothing.

>
> Also we might want to double check that the PF cannot be unbound while
> the VF is present. I know for a while there it was possible to remove
> the PF driver while the VF was present. The Mellanox drivers may not
> allow it but it might not hurt to look at taking a reference against
> the PF driver if you are allocating the VF MSI-X configuration sysfs
> file.

Right now, we always allocate these sysfs without relation if PF
supports or not. The check is done during write() call to such sysfs
and at that phase we check the existence of the drivers. It greatly
simplifies creation phase.

Thanks
