Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14BD320BA0A
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 22:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725998AbgFZUM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 16:12:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgFZUM4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 16:12:56 -0400
Received: from localhost (mobile-166-170-222-206.mycingular.net [166.170.222.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F61E2070A;
        Fri, 26 Jun 2020 20:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593202375;
        bh=yrG0fTvVHX8EMlp3x7nP44yHBASZyoALarBxI94N914=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=zqJbk/zKLUUXWUje3EeBeJ+aVPVSkonvqRPuuqewT05ysvGSdepv6HT07LoFWA1bp
         nZ50bn/a3j39x7LvMjVPwBT133n/VwB0JIK0r5/kgbOD9eA1XFNBPWruff1fkLTPFX
         d01W279bcoV7wB1ujojiyVZ9b9gA4QNKyJll1stY=
Date:   Fri, 26 Jun 2020 15:12:54 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>, linux-pci@vger.kernel.org,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: Re: [net-next 10/10] net/mlx5e: Add support for PCI relaxed ordering
Message-ID: <20200626201254.GA2932090@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624102258.4410008d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 10:22:58AM -0700, Jakub Kicinski wrote:
> On Wed, 24 Jun 2020 10:34:40 +0300 Aya Levin wrote:
> > >> I think Michal will rightly complain that this does not belong in
> > >> private flags any more. As (/if?) ARM deployments take a foothold
> > >> in DC this will become a common setting for most NICs.  
> > > 
> > > Initially we used pcie_relaxed_ordering_enabled() to
> > >   programmatically enable this on/off on boot but this seems to
> > > introduce some degradation on some Intel CPUs since the Intel Faulty
> > > CPUs list is not up to date. Aya is discussing this with Bjorn.  
> > Adding Bjorn Helgaas
> 
> I see. Simply using pcie_relaxed_ordering_enabled() and blacklisting
> bad CPUs seems far nicer from operational perspective. Perhaps Bjorn
> will chime in. Pushing the validation out to the user is not a great
> solution IMHO.

I'm totally lost, but maybe it doesn't matter because it looks like
David has pulled this series already.

There probably *should* be a PCI core interface to enable RO, but
there isn't one today.

pcie_relaxed_ordering_enabled() doesn't *enable* anything.  All it
does is tell you whether RO is already enabled.

This patch ([net-next 10/10] net/mlx5e: Add support for PCI relaxed
ordering) apparently adds a knob to control RO, but I can't connect
the dots.  It doesn't touch PCI_EXP_DEVCTL_RELAX_EN, and that symbol
doesn't occur anywhere in drivers/net except tg3, myri10ge, and niu.

And this whole series doesn't contain PCI_EXP_DEVCTL_RELAX_EN or
pcie_relaxed_ordering_enabled().

I do have a couple emails from Aya, but they didn't include a patch
and I haven't quite figured out what the question was.

> > > So until we figure this out, will keep this off by default.
> > > 
> > > for the private flags we want to keep them for performance analysis as
> > > we do with all other mlx5 special performance features and flags.
