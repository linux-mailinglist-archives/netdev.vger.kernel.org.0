Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74FF86B5225
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 21:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbjCJUsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 15:48:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbjCJUsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 15:48:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9B962B68;
        Fri, 10 Mar 2023 12:48:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D365161D57;
        Fri, 10 Mar 2023 20:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB65C433EF;
        Fri, 10 Mar 2023 20:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678481307;
        bh=pwhL7fcFv+C6VAthhepJprmPi4uui+C5GLkJJyMnpCQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=ozz2lUwyrxsz9ZwLT4wIyWWaSf21ywICL4yikpSyYM8mvVvrjcI5qNhGbifXt+Htf
         sKI3XOZNSJELF0YupxjfRqs5rnhK7Mqb9kfYpI046Wu8gjAJ2mCXM5dV6H1Le9zrxY
         apSuHBo1oRkzujmexS6zvPASinj478pK8pkwxlo/8FJ+kzMX/IEBxM/pSWYjxDiwkf
         qyZJfKwL8KtsYNdPwlr78pDxRHLgKGjo8NvPLsHNOL8AoFc5t/C40mwFzjodbJZePC
         Q9zXMq49659n/m3MiGnRvOx8N1inrxDsTGvR3QOcurNPD7Og1qBhT6b4bQwZphL97t
         XZFsCCeFmqvhw==
Date:   Fri, 10 Mar 2023 14:48:25 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>, nic_swsd@realtek.com,
        bhelgaas@google.com, koba.ko@canonical.com,
        acelan.kao@canonical.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, vidyas@nvidia.com,
        rafael.j.wysocki@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH net-next v9 3/5] r8169: Consider chip-specific ASPM can
 be enabled on more cases
Message-ID: <20230310204825.GA1277880@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb2bee03-1b2c-384b-e9c1-5ddf2240c828@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 09:42:04PM +0100, Heiner Kallweit wrote:
> On 09.03.2023 21:17, Bjorn Helgaas wrote:
> > On Sat, Feb 25, 2023 at 11:46:33AM +0800, Kai-Heng Feng wrote:
> >> To really enable ASPM on r8169 NICs, both standard PCIe ASPM and
> >> chip-specific ASPM have to be enabled at the same time.
> >>
> >> Before enabling ASPM at chip side, make sure the following conditions
> >> are met:
> >> 1) Use pcie_aspm_support_enabled() to check if ASPM is disabled by
> >>    kernel parameter.
> >> 2) Use pcie_aspm_capable() to see if the device is capable to perform
> >>    PCIe ASPM.
> >> 3) Check the return value of pci_disable_link_state(). If it's -EPERM,
> >>    it means BIOS doesn't grant ASPM control to OS, and device should use
> >>    the ASPM setting as is.
> >>
> >> Consider ASPM is manageable when those conditions are met.
> >>
> >> While at it, disable ASPM at chip-side for TX timeout reset, since
> >> pci_disable_link_state() doesn't have any effect when OS isn't granted
> >> with ASPM control.
> > 
> > 1) "While at it, ..." is always a hint that maybe this part could be
> > split to a separate patch.
> > 
> > 2) The mix of chip-specific and standard PCIe ASPM configuration is a
> > mess.  Does it *have* to be intermixed at run-time, or could all the
> > chip-specific stuff be done once, e.g., maybe chip-specific ASPM
> > enable could be done at probe-time, and then all subsequent ASPM
> > configuration could done via the standard PCIe registers?
> > 
> > I.e., does the chip work correctly if chip-specific ASPM is enabled,
> > but standard PCIe ASPM config is *disabled*?
> > 
> > The ASPM sysfs controls [1] assume that L0s, L1, L1.1, L1.2 can all be
> > controlled simply by using the standard PCIe registers.  If that's not
> > the case for r8169, things will break when people use the sysfs knobs.
> > 
> This series has been superseded meanwhile and what is being discussed
> here has become obsolete.

For completeness, I guess the replacement of this series is:

  https://lore.kernel.org/all/af076f1f-a034-82e5-8f76-f3ec32a14eaa@gmail.com/
