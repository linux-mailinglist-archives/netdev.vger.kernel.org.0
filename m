Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5BF32D749
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 17:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236276AbhCDQDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 11:03:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:50942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236242AbhCDQDH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 11:03:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E73F64E28;
        Thu,  4 Mar 2021 16:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614873747;
        bh=cGEWlSoCTya/ot2EVTO9KSdGc7xk6jo0zMvEBvDQYHE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=DUOSCaMGuj1tnFivMq/qcuHSVZnHEWqVmUFgwmlm6MqJfY/W1AG+kVeZAaHABqPLa
         WvMkgfPTAGvSItB5FZaRBPTct+V6tD4fVgbQlthxSwzNUrRSzLjWh6rN8vnU3n2Sb/
         msGx4V0vAVg5YmXDKCQk6WIo4HcUNmXjf88Id9PZdwo2rUW/GJOgsnG3DfWUH7YxdA
         IyCRCXsFAdyBC2q8rm1N8sYpDRbfEwg37athcrO63WuY/VM54nKPv5xL11/BeaJd7H
         jFeJjdCai9/XfMc3PKr2FwuD1wpkzN2TCPmIz61e7RnVljNSh+eOV2CvfgpNndWBVs
         Z25hl6GXSAggg==
Date:   Thu, 4 Mar 2021 10:02:25 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org
Subject: Re: [PATCH 3/3] PCI: Convert rtw88 power cycle quirk to shutdown
 quirk
Message-ID: <20210304160225.GA846157@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAd53p62zy64gsmdNYSuV1sxOiB1Hye5R0WkY-gNFf+CKbG12A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+cc Rafael, linux-pm]

On Thu, Mar 04, 2021 at 02:07:18PM +0800, Kai-Heng Feng wrote:
> On Sat, Feb 27, 2021 at 2:17 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > On Fri, Feb 26, 2021 at 02:31:31PM +0100, Heiner Kallweit wrote:
> > > On 26.02.2021 13:18, Kai-Heng Feng wrote:
> > > > On Fri, Feb 26, 2021 at 8:10 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> > > >>
> > > >> On 26.02.2021 08:12, Kalle Valo wrote:
> > > >>> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
> > > >>>
> > > >>>> Now we have a generic D3 shutdown quirk, so convert the original
> > > >>>> approach to a PCI quirk.
> > > >>>>
> > > >>>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > > >>>> ---
> > > >>>>  drivers/net/wireless/realtek/rtw88/pci.c | 2 --
> > > >>>>  drivers/pci/quirks.c                     | 6 ++++++
> > > >>>>  2 files changed, 6 insertions(+), 2 deletions(-)
> > > >>>
> > > >>> It would have been nice to CC linux-wireless also on patches 1-2. I only
> > > >>> saw patch 3 and had to search the rest of patches from lkml.
> > > >>>
> > > >>> I assume this goes via the PCI tree so:
> > > >>>
> > > >>> Acked-by: Kalle Valo <kvalo@codeaurora.org>
> > > >>
> > > >> To me it looks odd to (mis-)use the quirk mechanism to set a device
> > > >> to D3cold on shutdown. As I see it the quirk mechanism is used to work
> > > >> around certain device misbehavior. And setting a device to a D3
> > > >> state on shutdown is a normal activity, and the shutdown() callback
> > > >> seems to be a good place for it.
> > > >> I miss an explanation what the actual benefit of the change is.
> > > >
> > > > To make putting device to D3 more generic, as there are more than one
> > > > device need the quirk.
> > > >
> > > > Here's the discussion:
> > > > https://lore.kernel.org/linux-usb/00de6927-3fa6-a9a3-2d65-2b4d4e8f0012@linux.intel.com/
> > > >
> > >
> > > Thanks for the link. For the AMD USB use case I don't have a strong opinion,
> > > what's considered the better option may be a question of personal taste.
> > > For rtw88 however I'd still consider it over-engineering to replace a simple
> > > call to pci_set_power_state() with a PCI quirk.
> > > I may be biased here because I find it sometimes bothering if I want to
> > > look up how a device is handled and in addition to checking the respective
> > > driver I also have to grep through quirks.c whether there's any special
> > > handling.
> >
> > I haven't looked at these patches carefully, but in general, I agree
> > that quirks should be used to work around hardware defects in the
> > device.  If the device behaves correctly per spec, we should use a
> > different mechanism so the code remains generic and all devices get
> > the benefit.
> >
> > If we do add quirks, the commit log should explain what the device
> > defect is.
> 
> So maybe it's reasonable to put all PCI devices to D3 at shutdown?

I don't know off-hand.  I added Rafael and linux-pm in case they do.

If not, I suggest working up a patch to do that and a commit log that
explains why that's a good idea and then we can have a discussion
about it.  This thread really doesn't have that justification.  It
says "putting device X in D3cold at shutdown saves 0.03w while in S5",
but doesn't explain why that's safe or desirable for all devices.

Bjorn
