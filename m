Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BDF4322FD
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 17:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbhJRPhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 11:37:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231893AbhJRPhm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 11:37:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C720B6103D;
        Mon, 18 Oct 2021 15:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634571331;
        bh=q7lcmruj3DqRwUoAeERdWNwhIR2lW91g6h7Kdo5lQp8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Pvv8j5rrguCLZzOjZEgHhY0Txc2BPVnAj4d0dfiw6bV43dEU76xoOTxKNCA5XOFeZ
         yHlL0Mqgywrqr5T8fNQq12o5APx8Zl2HGncM/4pFYOrRxVLbZM+lP03XqA0rpoRVso
         l3BukXmaCXnliqfxezF07+nUVHExtbCmVbG7VpKL2wHlfQYE5Ogl6m/6IZNNhpGETb
         d1Rv6QvwRmX7MtJ6/6GyKNAIAMq+5Towrzub7S7LaNAumjCmZ90nw394bZ970/cTZP
         6JZryrPojvE8chSkiXvJjHZiLyz3zMr+wb0lylbqUIIZm+1Zs8UA1JWIsntfqRRgzI
         zS91iUQ2HG0wA==
Date:   Mon, 18 Oct 2021 10:35:29 -0500
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
Message-ID: <20211018153529.GA2235731@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e7983fec-f4f1-6d31-5e46-f5a427fe55cc@v0yd.nl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 14, 2021 at 12:08:31AM +0200, Jonas Dreßler wrote:
> On 10/12/21 17:39, Bjorn Helgaas wrote:
> > [+cc Vidya, Victor, ASPM L1.2 config issue; beginning of thread:
> > https://lore.kernel.org/all/20211011134238.16551-1-verdre@v0yd.nl/]

> > I wonder if this reset quirk works because pci_reset_function() saves
> > and restores much of config space, but it currently does *not* restore
> > the L1 PM Substates capability, so those T_POWER_ON,
> > Common_Mode_Restore_Time, and LTR_L1.2_THRESHOLD values probably get
> > cleared out by the reset.  We did briefly save/restore it [1], but we
> > had to revert that because of a regression that AFAIK was never
> > resolved [2].  I expect we will eventually save/restore this, so if
> > the quirk depends on it *not* being restored, that would be a problem.
> > 
> > You should be able to test whether this is the critical thing by
> > clearing those registers with setpci instead of doing the reset.  Per
> > spec, they can only be modified when L1.2 is disabled, so you would
> > have to disable it via sysfs (for the endpoint, I think)
> > /sys/.../l1_2_aspm and /sys/.../l1_2_pcipm, do the setpci on the root
> > port, then re-enable L1.2.
> > 
> > [1] https://git.kernel.org/linus/4257f7e008ea
> > [2] https://lore.kernel.org/all/20210127160449.2990506-1-helgaas@kernel.org/
> 
> Hmm, interesting, thanks for those links.
> 
> Are you sure the config values will get lost on the reset? If we only reset
> the port by going into D3hot and back into D0, the device will remain powered
> and won't lose the config space, will it?

I think you're doing a PM reset (transition to D3hot and back to D0).
Linux only does this when PCI_PM_CTRL_NO_SOFT_RESET == 0.  The spec
doesn't actually *require* the device to be reset; it only says the
internal state of the device is undefined after these transitions.
