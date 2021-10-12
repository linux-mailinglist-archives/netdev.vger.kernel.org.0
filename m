Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C61342A869
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 17:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237309AbhJLPlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 11:41:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237218AbhJLPlZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 11:41:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 369AD601FF;
        Tue, 12 Oct 2021 15:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634053163;
        bh=TDrzj6YJ5YoKUelxbExaeF/BmmCZy8EfdKaIUuHLWhg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=S/7fqIYG/DsFJsKUihz8Hfp1cGSl1cOMhegR2iUYl4P6+P9dXVUcfbhOvqQlN15N6
         ObxRCafC/gJCsQVBc9kOxy91NppmpCFutkKyHH2JSLwcGHXSLR/V+NhV+5JjK//kBs
         erV+wtu1y73hLtnz2en92LU7AuwFhhqcvDTVfF8kM0ZBbz7aj9JgdmkVzVZnt0ihWV
         1Ga1I3KLQf+TJktJ6GC8QjYiZNkUxmop/fs1wZ3WLaJYti1051G9ZnbeEHRH5yfsba
         qPqfBbGkwQUarjqHOooHABb3GfXvb93kZVC90UEEW0MyhYp2PWKvC6xFxtp/f5L2Wc
         RasZlf2PimtIA==
Date:   Tue, 12 Oct 2021 10:39:21 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jonas =?iso-8859-1?Q?Dre=DFler?= <verdre@v0yd.nl>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Brian Norris <briannorris@chromium.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Vidya Sagar <vidyas@nvidia.com>,
        Victor Ding <victording@google.com>
Subject: Re: [PATCH] mwifiex: Add quirk resetting the PCI bridge on MS
 Surface devices
Message-ID: <20211012153921.GA1754629@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62bcb73-778d-1958-6c14-d5bdcca85812@v0yd.nl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+cc Vidya, Victor, ASPM L1.2 config issue; beginning of thread:
https://lore.kernel.org/all/20211011134238.16551-1-verdre@v0yd.nl/]

On Tue, Oct 12, 2021 at 10:55:03AM +0200, Jonas Dreßler wrote:
> On 10/11/21 19:02, Pali Rohár wrote:
> > On Monday 11 October 2021 15:42:38 Jonas Dreßler wrote:
> > > The most recent firmware (15.68.19.p21) of the 88W8897 PCIe+USB card
> > > reports a hardcoded LTR value to the system during initialization,
> > > probably as an (unsuccessful) attempt of the developers to fix firmware
> > > crashes. This LTR value prevents most of the Microsoft Surface devices
> > > from entering deep powersaving states (either platform C-State 10 or
> > > S0ix state), because the exit latency of that state would be higher than
> > > what the card can tolerate.
> > 
> > This description looks like a generic issue in 88W8897 chip or its
> > firmware and not something to Surface PCIe controller or Surface HW. But
> > please correct me if I'm wrong here.
> > 
> > Has somebody 88W8897-based PCIe card in non-Surface device and can check
> > or verify if this issue happens also outside of the Surface device?
> > 
> > It would be really nice to know if this is issue in Surface or in 8897.
> 
> Fairly sure the LTR value is something that's reported by the firmware
> and will be the same on all 8897 devices (as mentioned in my reply to Bjorn
> the second-latest firmware doesn't report that fixed LTR value).

I suggested earlier that the LTR values reported by the device might
depend on the electrical characteristics of the link and hence be
platform-dependent, but I think that might be wrong.

The spec (PCIe r5.0, sec 5.5.4) does say that some of the *other*
parameters related to L1.2 entry are platform-dependent:

  Prior to setting either or both of the enable bits for L1.2, the
  values for TPOWER_ON, Common_Mode_Restore_Time, and, if the ASPM
  L1.2 Enable bit is to be Set, the LTR_L1.2_THRESHOLD (both Value
  and Scale fields) must be programmed.  The TPOWER_ON and
  Common_Mode_Restore_Time fields must be programmed to the
  appropriate values based on the components and AC coupling
  capacitors used in the connection linking the two components. The
  determination of these values is design implementation specific.

These T_POWER_ON, Common_Mode_Restore_Time, and LTR_L1.2_THRESHOLD
values are in the L1 PM Substates Control registers.

I don't know of a way for the kernel or the device firmware to learn
these circuit characteristics or the appropriate values, so I think
only system firmware can program the L1 PM Substates Control registers
(a corollary of this is that I don't see a way for hot-plugged devices
to *ever* use L1.2).

I wonder if this reset quirk works because pci_reset_function() saves
and restores much of config space, but it currently does *not* restore
the L1 PM Substates capability, so those T_POWER_ON,
Common_Mode_Restore_Time, and LTR_L1.2_THRESHOLD values probably get
cleared out by the reset.  We did briefly save/restore it [1], but we
had to revert that because of a regression that AFAIK was never
resolved [2].  I expect we will eventually save/restore this, so if
the quirk depends on it *not* being restored, that would be a problem.

You should be able to test whether this is the critical thing by
clearing those registers with setpci instead of doing the reset.  Per
spec, they can only be modified when L1.2 is disabled, so you would
have to disable it via sysfs (for the endpoint, I think)
/sys/.../l1_2_aspm and /sys/.../l1_2_pcipm, do the setpci on the root
port, then re-enable L1.2.

[1] https://git.kernel.org/linus/4257f7e008ea
[2] https://lore.kernel.org/all/20210127160449.2990506-1-helgaas@kernel.org/
