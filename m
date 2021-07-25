Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34843D4C70
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 08:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhGYF72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 01:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229460AbhGYF70 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 01:59:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0338860F26;
        Sun, 25 Jul 2021 06:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627195197;
        bh=N4Dbqhu4Ia9k/4TthHh5Es4Nq6D+VIxU8smJ2eoEAUM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l3Ex1puXfIt1tSo/Q6IG0C9csxgo3ON2RdU7kcTcXELD07qSk96MIDB86afAMMjMR
         6j2qUDX0KlMTBdKbov2v0yT4/+F5STT4mqeJA7We2+ZgD7I7pGc17kflWdjGTQNaEj
         Tw2DnD0C8D+I4+KjdsUvRtpsavxZKWRoUsU/lWyLXISIHQKAZnmfEgFbY4GnFbqblm
         jmr3wrZmLBhJR9HrkiGLeXsnAvOGPnI3RL9OeYZQAaZwOa7iLjcStk3sKlD4Mpd3k6
         ZDstlTZkWMHAoDh824DpMl6/l7y06AHbq7thtpShFkTzvhmz7bMMsxWL7QUGrTCK+2
         hu/wr8h23Koew==
Date:   Sun, 25 Jul 2021 09:39:53 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Dongdong Liu <liudongdong3@huawei.com>, helgaas@kernel.org,
        hch@infradead.org, kw@linux.com, linux-pci@vger.kernel.org,
        rajur@chelsio.com, hverkuil-cisco@xs4all.nl,
        linux-media@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH V6 7/8] PCI: Add "pci=disable_10bit_tag=" parameter for
 peer-to-peer support
Message-ID: <YP0HOf7kE1aOkqjV@unreal>
References: <1627038402-114183-1-git-send-email-liudongdong3@huawei.com>
 <1627038402-114183-8-git-send-email-liudongdong3@huawei.com>
 <YPqo6M0AKWLupvNU@unreal>
 <a8a8ffee-67e8-c899-3d04-1e28fb72560a@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8a8ffee-67e8-c899-3d04-1e28fb72560a@deltatee.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 10:20:50AM -0600, Logan Gunthorpe wrote:
> 
> 
> 
> On 2021-07-23 5:32 a.m., Leon Romanovsky wrote:
> > On Fri, Jul 23, 2021 at 07:06:41PM +0800, Dongdong Liu wrote:
> >> PCIe spec 5.0 r1.0 section 2.2.6.2 says that if an Endpoint supports
> >> sending Requests to other Endpoints (as opposed to host memory), the
> >> Endpoint must not send 10-Bit Tag Requests to another given Endpoint
> >> unless an implementation-specific mechanism determines that the Endpoint
> >> supports 10-Bit Tag Completer capability. Add "pci=disable_10bit_tag="
> >> parameter to disable 10-Bit Tag Requester if the peer device does not
> >> support the 10-Bit Tag Completer. This will make P2P traffic safe.
> >>
> >> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
> >> ---
> >>  Documentation/admin-guide/kernel-parameters.txt |  7 ++++
> >>  drivers/pci/pci.c                               | 56 +++++++++++++++++++++++++
> >>  drivers/pci/pci.h                               |  1 +
> >>  drivers/pci/pcie/portdrv_pci.c                  | 13 +++---
> >>  drivers/pci/probe.c                             |  9 ++--
> >>  5 files changed, 78 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> >> index bdb2200..c2c4585 100644
> >> --- a/Documentation/admin-guide/kernel-parameters.txt
> >> +++ b/Documentation/admin-guide/kernel-parameters.txt
> >> @@ -4019,6 +4019,13 @@
> >>  				bridges without forcing it upstream. Note:
> >>  				this removes isolation between devices and
> >>  				may put more devices in an IOMMU group.
> >> +		disable_10bit_tag=<pci_dev>[; ...]
> >> +				  Specify one or more PCI devices (in the format
> >> +				  specified above) separated by semicolons.
> >> +				  Disable 10-Bit Tag Requester if the peer
> >> +				  device does not support the 10-Bit Tag
> >> +				  Completer.This will make P2P traffic safe.
> > 
> > I can't imagine more awkward user experience than such kernel parameter.
> > 
> > As a user, I will need to boot the system, hope for the best that system
> > works, write down all PCI device numbers, guess which one doesn't work
> > properly, update grub with new command line argument and reboot the
> > system. Any HW change and this dance should be repeated.
> 
> There are already two such PCI parameters with this pattern and they are
> not that awkward. pci_dev may be specified with either vendor/device IDS
> or with a path of BDFs (which protects against renumbering).

Unfortunately, in the real world, BDF is not so stable. It changes with
addition of new hardware, BIOS upgrades and even broken servers.

Vendor/device IDs doesn't work if you have multiple devices of same
vendor in the system.

> 
> This flag is only useful in P2PDMA traffic, and if the user attempts
> such a transfer, it prints a warning (see the next patch) with the exact
> parameter that needs to be added to the command line.

Dongdong citied PCI spec and it was very clear - don't enable this
feature unless you clearly know that it is safe to enable. This is
completely opposite to the proposal here - always enable and disable
if something is printed to the dmesg.

> 
> This has worked well for disable_acs_redir and was used for
> resource_alignment before that for quite some time. So save a better
> suggestion I think this is more than acceptable.

I don't know about other parameters and their history, but we are not in
90s anymore and addition of modules parameters (for the PCI it is kernel
cmdline arguments) are better to be changed to some configuration tool/sysfs.

Even FW upgrade with such kernel parameter can be problematic.

Thanks

> 
> Logan
