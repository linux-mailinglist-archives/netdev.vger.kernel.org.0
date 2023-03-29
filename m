Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F286CEE96
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbjC2QEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjC2QE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 12:04:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05FE7AB2;
        Wed, 29 Mar 2023 09:03:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE95561D84;
        Wed, 29 Mar 2023 16:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12245C4339C;
        Wed, 29 Mar 2023 16:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680105706;
        bh=qcGyMMCG8q3oX9EluJ05zNrLVr7y0RS2BMSTWFdWbQY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=qxD6mvs25qUC0Aygv94Xhxqz08OMzsiT1hKKAi4XfIMhuqZ434Y4B/CbTB+wU80iJ
         QXs6xzzaM1sqCficfrFMsDwIEJNpRu061PyhK2Qwq9lftS8gwzEfkC+qHW3i5n4zrt
         MHBq9Bg1POuxqwoWjU5NPNfiHMWs06MJ8AKyaAJ2SJ42hR08gJ1Ik5vfwH9vP+N61N
         uXY1ZAK43HMvx8VFsKaA3qYw1E3mCPRy86pBQPtzqR4PjnfsJFhCMj1eUsZd6PTUMm
         bm8MwHk2ZBMLSY+ozhSDnPM6g6g+T+ZHO/kCR+ynJ7Y7Fg0/raqtSi6awVFwk1tamL
         apfWbvqB5tVnQ==
Date:   Wed, 29 Mar 2023 11:01:44 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com,
        linux-pci@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH net-next 6/6] mlxsw: pci: Add support for new reset flow
Message-ID: <20230329160144.GA2967030@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCBOdunTNYsufhcn@shredder>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+cc Alex, Lukas for link-disable reset thoughts, beginning of thread:
https://lore.kernel.org/all/cover.1679502371.git.petrm@nvidia.com/]

On Sun, Mar 26, 2023 at 04:53:58PM +0300, Ido Schimmel wrote:
> On Thu, Mar 23, 2023 at 11:51:15AM -0500, Bjorn Helgaas wrote:
> > On Wed, Mar 22, 2023 at 05:49:35PM +0100, Petr Machata wrote:
> > > From: Amit Cohen <amcohen@nvidia.com>
> > > 
> > > The driver resets the device during probe and during a devlink reload.
> > > The current reset method reloads the current firmware version or a pending
> > > one, if one was previously flashed using devlink. However, the reset does
> > > not take down the PCI link, preventing the PCI firmware from being
> > > upgraded, unless the system is rebooted.
> > 
> > Just to make sure I understand this correctly, the above sounds like
> > "firmware" includes two parts that have different rules for loading:
> > 
> >   - Current reset method is completely mlxsw-specific and resets the
> >     mlxsw core but not the PCIe interface; this loads only firmware
> >     part A
> > 
> >   - A PCIe reset resets both the mlxsw core and the PCIe interface;
> >     this loads both firmware part A and part B
> 
> Yes. A few years ago I had to flash a new firmware in order to test a
> fix in the PCIe firmware and the bug still reproduced after a devlink
> reload. Only after a reboot the new PCIe firmware was loaded and the bug
> was fixed. Bugs in PCIe firmware are not common, but we would like to
> avoid the scenario where users must reboot the machine in order to load
> the new firmware.
> 
> > > To solve this problem, a new reset command (6) was implemented in the
> > > firmware. Unlike the current command (1), after issuing the new command
> > > the device will not start the reset immediately, but only after the PCI
> > > link was disabled. The driver is expected to wait for 500ms before
> > > re-enabling the link to give the firmware enough time to start the reset.
> > 
> > I guess the idea here is that the mlxsw driver:
> > 
> >   - Tells the firmware we're going to reset
> >     (MLXSW_REG_MRSR_COMMAND_RESET_AT_PCI_DISABLE)
> > 
> >   - Saves PCI config state
> > 
> >   - Disables the link (mlxsw_pci_link_toggle()), which causes a PCIe
> >     hot reset
> > 
> >   - The firmware notices the link disable and starts its own internal
> >     reset
> > 
> >   - The mlxsw driver waits 500ms
> >     (MLXSW_PCI_TOGGLE_WAIT_BEFORE_EN_MSECS)
> > 
> >   - Enables link and waits for it to be active
> >     (mlxsw_pci_link_active_check()
> > 
> >   - Waits for device to be ready again (mlxsw_pci_device_id_read())
> 
> Correct.
> 
> > So the first question is why you don't simply use
> > pci_reset_function(), since it is supposed to cause a reset and do all
> > the necessary waiting for the device to be ready.  This is quite
> > complicated to do correctly; in fact, we still discover issues there
> > regularly.  There are many special cases in PCIe r6.0, sec 6.6.1, and
> > it would be much better if we can avoid trying to handle them all in
> > individual drivers.
> 
> I see that this function takes the device lock and I think (didn't try)
> it will deadlock if we were to replace the current code with it since we
> also perform a reset during probe where I believe the device lock is
> already taken.
> 
> __pci_reset_function_locked() is another option, but it assumes the
> device lock was already taken, which is correct during probe, but not
> when reset is performed as part of devlink reload.
> 
> Let's put the locking issues aside and assume we can use
> __pci_reset_function_locked(). I'm trying to figure out what it can
> allow us to remove from the driver in favor of common PCI code. It
> essentially invokes one of the supported reset methods. Looking at my
> device, I see the following:
> 
>  # cat /sys/class/pci_bus/0000\:01/device/0000\:01\:00.0/reset_method 
>  pm bus
> 
> So I assume it will invoke pci_pm_reset(). I'm not sure it can work for
> us as our reset procedure requires us to disable the link on the
> downstream port as a way of notifying the device that it should start
> the reset procedure.

Hmmm, pci_pm_reset() puts the device in D3hot, then back to D0.  Spec
says that results in "undefined internal Function state," which
doesn't even sound like a guaranteed reset, but it's what we have, and
in any case, it does not disable the link.

> We might be able to use the "device_specific" method and add quirks in
> "pci_dev_reset_methods". However, I'm not sure what would be the
> benefit, as it basically means moving the code in
> mlxsw_pci_link_toggle() to drivers/pci/quirks.c. Also, when the "probe"
> argument is "true" we can't actually determine if this reset method is
> supported or not, as we can't query that from the configuration space of
> the device in the current implementation. It's queried using a command
> interface that is specific to mlxsw and resides in the driver itself.
> Not usable from drivers/pci/quirks.c.

Spec (PCIe r6.0, sec 6.6.1) says "Disabling a Link causes Downstream
components to undergo a hot reset."  That seems like it *could* be a
general-purpose method of doing a reset, and I don't know why the PCI
core doesn't support it.  Added Alex and Lukas in case they know.

But it sounds like there's some wrinkle with your device?  I suppose a
link disable actually causes a reset, but that reset may not trigger
the firmware reload you need?  If we had a generic "disable link"
reset method, maybe a device quirk could disable it if necessary?

> > Of course, pci_reset_function() does *not* include details like
> > MLXSW_PCI_TOGGLE_WAIT_BEFORE_EN_MSECS.
> > 
> > I assume that flashing the firmware to the device followed by a power
> > cycle (without ever doing MLXSW_REG_MRSR_COMMAND_RESET_AT_PCI_DISABLE)
> > would load the new firmware everywhere.  Can we not do the same with a
> > PCIe reset?
> 
> Yes, that's what we would like to achieve.
> 
> Thanks for the feedback!
