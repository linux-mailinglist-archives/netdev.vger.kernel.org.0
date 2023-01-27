Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 924A367E6BE
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 14:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbjA0Nam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 08:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234018AbjA0Nal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 08:30:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98D77A4AE;
        Fri, 27 Jan 2023 05:30:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63984B82114;
        Fri, 27 Jan 2023 13:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC7AC4339B;
        Fri, 27 Jan 2023 13:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674826236;
        bh=hOO4tEkvmkNfnd/kUv2lz7JQJ8CUBZuogljG/l3nIcc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=LQTl5p+qHOhPIdJ+NhcTwSON0xj9q9BDC71p6Pv2bTPFgaSSn3ZbsAF6PKtq+RkyG
         3N38xTMK/R7o6Di97DNpk1aIxU7z9ZGnF8h23i8bVh6sY4EwiHgPFH+qNZYgCRfFMN
         3EKvbxILcjip4hPAwtZ1jA4/v1A4UisVh/Ma+VItJ7WKxlR95QOeMco1O01aPAWH5C
         h/I2/nXxGqsPugCtW3cmgH3INb+B6gTfxL3ZAdwdQ/Lh7+aeoXNNenAnHsChJ0oqkM
         Ujn7pAAenGYQwwYNfGMQIkReJyZ+z43+kYbBzQtZ7pYHeWoMX29L31qEucNu4uzUfG
         5RnU5qYwg/4Qw==
Date:   Fri, 27 Jan 2023 07:30:34 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, netdev@vger.kernel.org,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        ilpo.jarvinen@linux.intel.com, ricardo.martinez@linux.intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        edumazet@google.com, pabeni@redhat.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        linuxwwan_5g@intel.com,
        Madhusmita Sahu <madhusmita.sahu@intel.com>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v5 net-next 3/5] net: wwan: t7xx: PCIe reset rescan
Message-ID: <20230127133034.GA1364550@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f5be4cd-ae84-aa24-cf8f-8261c825fafd@linux.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 03:57:16PM +0530, Kumar, M Chetan wrote:
> On 1/26/2023 8:55 PM, Bjorn Helgaas wrote:
> > On Tue, Jan 24, 2023 at 08:45:43PM -0800, Jakub Kicinski wrote:
> > > On Sat, 21 Jan 2023 19:03:23 +0530 m.chetan.kumar@linux.intel.com wrote:
> > > > From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> > > > 
> > > > PCI rescan module implements "rescan work queue".
> > > > In firmware flashing or coredump collection procedure
> > > > WWAN device is programmed to boot in fastboot mode and
> > > > a work item is scheduled for removal & detection.
> > > > 
> > > > The WWAN device is reset using APCI call as part driver
> > > > removal flow. Work queue rescans pci bus at fixed interval
> > > > for device detection, later when device is detect work queue
> > > > exits.
> > 
> > I'm not sure what's going on here.  Do we need to reset the device
> > when the t7xx driver is loaded so the device will load new
> > firmware when it comes out of reset?
> 
> Flow is, Reset the device to get into firmware download mode then
> update the firmware and later reset it to go back to normal mode.

Thanks, that makes sense, and I'm confident that t7xx is not the only
driver that needs to do something like this, so we should be able to
figure out a nice way to do it.

> > > > +void t7xx_pci_dev_rescan(void)
> > > > +{
> > > > +	struct pci_bus *b = NULL;
> > > > +
> > > > +	pci_lock_rescan_remove();
> > > > +	while ((b = pci_find_next_bus(b)))
> > > > +		pci_rescan_bus(b);
> > 
> > No, this driver absolutely cannot rescan and assign unassigned
> > resources for all the PCI buses in the system.
> 
> T7xx device falls off the bus due to ACPI reset.
> Would you please suggest how we can bring device back on the bus
> without such changes inside driver ?  Will pci_reset_function() help
> in this regard ?

"Falling off the bus" is not very precise language, but it usually
means the device stops responding to PCI transactions like config,
memory, or I/O accesses.

Any kind of reset, whether it's done via ACPI _RST or one of the
mechanisms used by pci_reset_function(), causes a PCI device to stop
responding temporarily.  When the device exits reset, it does some
internal initialization and eventually becomes ready to respond to PCI
transactions again.

The PCI core doesn't do anything to the device to "bring it back on
the bus" other than powering on the device or deasserting whatever
signal initiated the reset in the first place.

For example, if we do the reset via pci_reset_secondary_bus(), we set
the Secondary Bus Reset (PCI_BRIDGE_CTL_BUS_RESET) bit in a bridge,
which triggers a reset for devices below the bridge.  When we clear
Secondary Bus Reset, those devices reinitialize themselves and start
responding to PCI transactions.  pci_reset_secondary_bus() contains a
ssleep(1) to give the device time for that initialization.

The t7xx_pci_dev_rescan() loop calls pci_rescan_bus(), which does
nothing to bring devices back on the bus.  It merely issues config
reads to all the possible device addresses to see which respond.

If t7xx_pci_dev_rescan() seems to bring the device back on the bus, it
is probably simply because it takes time and gives the device time to
finish its initialization.  It doesn't actually *do* anything to the
device other than do a config read to it.

I notice that t7xx_remove_rescan() would actually *remove* the
pci_dev, and pci_rescan_bus() would create a new pci_dev if the t7xx
device responds to a config read.  But this a real mess.  When you
remove the device, the driver is detached from it, and we should no
longer be running any driver code.

If you can use pci_reset_function(), there's no need to remove and
re-enumerate the device, so that should let you get rid of the whole
t7xx_remove_rescan() workqueue.

Bjorn
