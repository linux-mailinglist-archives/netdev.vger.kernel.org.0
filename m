Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6717B3CD0D1
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235789AbhGSIsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:48:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234868AbhGSIso (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 04:48:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D24D60240;
        Mon, 19 Jul 2021 08:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626682422;
        bh=0TE5z1JwXY+ttzhYw+dqHxv31KAXFHmt/AZXZQRPKEk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oWbFMB5aDV3OXGYjtcSxVa7L7v6T+xq91Sy/9s0bYFGq0eORYxBMSV/Kqkx7AbvFO
         lrxlaP6M3LHNnmc+J1FFxh8jrqdEtrRcywtw0sOgZk6fwjW3tdYjhwZ+V4dipbXtbe
         nUZoSI6rI3WKqQLtNIMZqbfrPAbuwAkjEp4jZpMLn+b1nOggU4zCWAblcaFs6+d6+k
         p9Nk7EgpoCfveNsBAgEFO+GWHe5u9vMcHimhKwhzIqINvHluzEKV7S62kpPA4lQPrs
         xNqEB/4kM/owBHg8WHnJOFtzEjjJ6xg/f2rWaz0ogQ8aycQm2Aw4yOH5m8LBp3RHOK
         VC6hh9Ebms8Fw==
Received: by pali.im (Postfix)
        id E64CEADB; Mon, 19 Jul 2021 10:13:39 +0200 (CEST)
Date:   Mon, 19 Jul 2021 10:13:39 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Oliver O'Halloran <oohall@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Aaron Ma <aaron.ma@canonical.com>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 1/2] igc: don't rd/wr iomem when PCI is removed
Message-ID: <20210719081339.52inudhug3rgpbed@pali>
References: <CAOSf1CGVpogQGAatuY_N0db6OL2BFegGtj6VTLA9KFz0TqYBQg@mail.gmail.com>
 <20210708154550.GA1019947@bjorn-Precision-5520>
 <CAOSf1CHtHLyEHC58jwemZS6j=jAU2OrrYitkUYmdisJtuFu4dw@mail.gmail.com>
 <20210718225059.hd3od4k4on3aopcu@pali>
 <CAOSf1CHOrUBfibO0t6Zr2=SZ7GjLTiAzfoKBeZL8RXdcC+Ou3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOSf1CHOrUBfibO0t6Zr2=SZ7GjLTiAzfoKBeZL8RXdcC+Ou3A@mail.gmail.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 19 July 2021 12:49:18 Oliver O'Halloran wrote:
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

I have experience and examples with pci aardvark controller. When card
is disconnected it sends synchronous abort to CPU when doing MMIO read
operation. One example is in this linux-usb thread:

https://lore.kernel.org/linux-usb/20210505120117.4wpmo6fhvzznf3wv@pali/t/#u

I can trigger this issue at least for xhci, nvme and ath drivers.

> Assuming it is a real problem then as Bjorn pointed out this sort of
> hack doesn't really fix the issue because hotplug and AER
> notifications are fundamentally asynchronous.

In case of pci aardvark it is not AER notification. And for MMIO read it
is synchronous abort.

Anyway, hotplug events are really asynchronous, but there is main issue
that this hotplug disconnect event instruct device driver to "unbind"
and e.g. these ethernet or usb controllers try to do MMIO operations in
their cleanup / remove / unbind phase, even when card is already
"disconnected" in PCI subsystem.

> If the driver is
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
> pci_readl(pdev, <addr>) style wrappers at one point. On powerpc
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
