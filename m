Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1547B3266D3
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 19:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbhBZSRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 13:17:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:55510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229622AbhBZSRj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 13:17:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1224A64F13;
        Fri, 26 Feb 2021 18:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614363418;
        bh=Hlzi7TUEPRhXjIfXQWQYvXeQG6RW1XmUNj0l3n/OeOo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=d5/LIRfRbRHvpt0bK+w4pz/CE6Oult5tdWSw5eaw7s2SCy/jvCVzcVo1lA1mxerQy
         jbELFdL1v+2gGZOxs+nQWFcPXo9Gl2MLiCPVguMQZ1f4ZBndHFmb8StwstcmmOokN2
         L4tR/sogUxzCxesYyaKXPaQ267Bk30cqtCTLeel6mo/LtJOQJWg2Oi/8cgOYD6PSQ3
         AuRVcXlt4AjpLt0/tDEBDi2a0EXNG1aNZWzWrA/dTdKYfVLQQphN3R3Cf7Ojnwri0Z
         7l82yqzlxyaUqIknVJ+qzEMPnv1Grc34HfwWCRH8XihS7bFdi+sjt3ParYwSJu9jzk
         kJXPVaY4IrQ1Q==
Date:   Fri, 26 Feb 2021 12:16:56 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 3/3] PCI: Convert rtw88 power cycle quirk to shutdown
 quirk
Message-ID: <20210226181656.GA143072@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6db9e75e-52a7-4316-bfd8-cf44b4875f44@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 02:31:31PM +0100, Heiner Kallweit wrote:
> On 26.02.2021 13:18, Kai-Heng Feng wrote:
> > On Fri, Feb 26, 2021 at 8:10 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>
> >> On 26.02.2021 08:12, Kalle Valo wrote:
> >>> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
> >>>
> >>>> Now we have a generic D3 shutdown quirk, so convert the original
> >>>> approach to a PCI quirk.
> >>>>
> >>>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> >>>> ---
> >>>>  drivers/net/wireless/realtek/rtw88/pci.c | 2 --
> >>>>  drivers/pci/quirks.c                     | 6 ++++++
> >>>>  2 files changed, 6 insertions(+), 2 deletions(-)
> >>>
> >>> It would have been nice to CC linux-wireless also on patches 1-2. I only
> >>> saw patch 3 and had to search the rest of patches from lkml.
> >>>
> >>> I assume this goes via the PCI tree so:
> >>>
> >>> Acked-by: Kalle Valo <kvalo@codeaurora.org>
> >>
> >> To me it looks odd to (mis-)use the quirk mechanism to set a device
> >> to D3cold on shutdown. As I see it the quirk mechanism is used to work
> >> around certain device misbehavior. And setting a device to a D3
> >> state on shutdown is a normal activity, and the shutdown() callback
> >> seems to be a good place for it.
> >> I miss an explanation what the actual benefit of the change is.
> > 
> > To make putting device to D3 more generic, as there are more than one
> > device need the quirk.
> > 
> > Here's the discussion:
> > https://lore.kernel.org/linux-usb/00de6927-3fa6-a9a3-2d65-2b4d4e8f0012@linux.intel.com/
> > 
> 
> Thanks for the link. For the AMD USB use case I don't have a strong opinion,
> what's considered the better option may be a question of personal taste.
> For rtw88 however I'd still consider it over-engineering to replace a simple
> call to pci_set_power_state() with a PCI quirk.
> I may be biased here because I find it sometimes bothering if I want to
> look up how a device is handled and in addition to checking the respective
> driver I also have to grep through quirks.c whether there's any special
> handling.

I haven't looked at these patches carefully, but in general, I agree
that quirks should be used to work around hardware defects in the
device.  If the device behaves correctly per spec, we should use a
different mechanism so the code remains generic and all devices get
the benefit.

If we do add quirks, the commit log should explain what the device
defect is.

Bjorn
