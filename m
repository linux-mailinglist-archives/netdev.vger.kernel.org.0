Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6E93CF0DB
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 02:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237337AbhGTAAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 20:00:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378032AbhGSXgg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 19:36:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13FC960E0B;
        Tue, 20 Jul 2021 00:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626740235;
        bh=ThAzBxkXRInNWnuCLj/2tYEXJI4QZ0qGGXACtEnXypk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=N9vo0oCzvSPqM5AAbzt5aELIl+pvnm98LRqL9Gad2lSDy0L6vK2L/NVDw3HYhII3c
         CXtQSwzp1DLHTvwCOMmkDoXfu/dZCz4R9FXk5NuFA90a2qZof63QI4JmbcbT6mEi9B
         h1ih9S0n4P1PSZGM1IGJAjGGqicUb56mAv6uZdoPqzZvwSi6t1jsfDRw9R/pS20SYx
         JswE5eXjXXtR7S5xbJPQM6i0WvBpj/HorP1PL2mSc676T0y3Qxp0al7VtRYGis8t8V
         42DdW8w9kH0FgHB+9iCvnSvwMooTK5jkLBbvKR+so53U3CmPzckto2d+PmMO7DEYAY
         cvq9pJtbajRZA==
Date:   Mon, 19 Jul 2021 19:17:13 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Oliver O'Halloran <oohall@gmail.com>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Aaron Ma <aaron.ma@canonical.com>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 1/2] igc: don't rd/wr iomem when PCI is removed
Message-ID: <20210720001713.GA38755@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOSf1CHOrUBfibO0t6Zr2=SZ7GjLTiAzfoKBeZL8RXdcC+Ou3A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 12:49:18PM +1000, Oliver O'Halloran wrote:
> On Mon, Jul 19, 2021 at 8:51 AM Pali Rohár <pali@kernel.org> wrote:
> >
> > And do we have some solution for this kind of issue? There are more PCIe
> > controllers / platforms which do not like MMIO read/write operation when
> > card / link is not connected.
> 
> Do you have some actual examples? The few times I've seen those
> crashes were due to broken firmware-first error handling. The AER
> notifications would be escalated into some kind of ACPI error which
> the kernel didn't have a good way of dealing with so it panicked
> instead.
> 
> Assuming it is a real problem then as Bjorn pointed out this sort of
> hack doesn't really fix the issue because hotplug and AER
> notifications are fundamentally asynchronous. If the driver is
> actively using the device when the error / removal happens then the
> pci_dev_is_disconnected() check will pass and the MMIO will go
> through. If the MMIO is poisonous because of dumb hardware then this
> sort of hack will only paper over the issue.
> 
> > If we do not provide a way how to solve these problems then we can
> > expect that people would just hack ethernet / wifi / ... device drivers
> > which are currently crashing by patches like in this thread.
> >
> > Maybe PCI subsystem could provide wrapper function which implements
> > above pattern and which can be used by device drivers?
> 
> We could do that and I think there was a proposal to add some
> pci_readl(pdev, <addr>) style wrappers at one point.

Obviously this wouldn't help user-space mmaps, but in the kernel,
Documentation/driver-api/device-io.rst [1] does say that drivers are
supposed to use readl() et al even though on most arches it "works"
to just dereference the result of ioremap(), so maybe we could make
a useful wrapper.

Seems like we should do *something*, even if it's just a generic
#define and some examples.  I took a stab at this [2] a couple years
ago, but it was only for the PCI core, and it didn't go anywhere.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/driver-api/device-io.rst?id=v5.13#n160
[2] https://lore.kernel.org/linux-pci/20190822200551.129039-1-helgaas@kernel.org/

> On powerpc
> there's hooks in the arch provided MMIO functions to detect error
> responses and kick off the error handling machinery when a problem is
> detected. Those hooks are mainly there to help the platform detect
> errors though and they don't make life much easier for drivers. Due to
> locking concerns the driver's .error_detected() callback cannot be
> called in the MMIO hook so even when the platform detects errors
> synchronously the driver notifications must happen asynchronously. In
> the meanwhile the driver still needs to handle the 0xFFs response
> safely and there's not much we can do from the platform side to help
> there.
> 
> Oliver
