Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1002F67D027
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 16:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbjAZP0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 10:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbjAZP0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 10:26:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA96E93E6;
        Thu, 26 Jan 2023 07:25:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B576B81CC0;
        Thu, 26 Jan 2023 15:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50C2C433EF;
        Thu, 26 Jan 2023 15:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674746754;
        bh=RPUA4JH2jMe4RjW6UY8ohwD1XnJ4ZRgpkSpDUl9Wqbc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=dy30E4CoimoXuS07cBIkJ9HKwdhUEwpJOmxe5NMRtY/QrTekyTsSyqvcdf1SVxEE7
         yovxQvwWKiuJ4GCFSvkTfGrcUREYSG/t6VhHRzioXYFrdvx0OW323YkHai9AShZXUp
         OsDP/ibGiTk84l1lAwUk+Di+ybwP5U2cttf1eGxE5fqgey69eysFpuC4UuxDzDQmy2
         isx9m9yq7SF/udzB8OwRZ9YbWhCnjH9RFmRvQszASmRnQ+pQdRszh9zW+BiCyLQxGv
         OyDw17MIUWb60Xo7RWFv1Nj7pGrcWpqMIEKDpaWWo4jCrQ8QzDiKZv6bofIOGIJMyX
         GabUanj2jjiqg==
Date:   Thu, 26 Jan 2023 09:25:52 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        m.chetan.kumar@linux.intel.com, netdev@vger.kernel.org,
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
Message-ID: <20230126152552.GA1265322@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124204543.550d88e3@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 08:45:43PM -0800, Jakub Kicinski wrote:
> Hi Bjorn,
> 
> any objections to the kind of shenanigans this is playing?

Yes, thanks for asking.  Drivers definitely should not have to do this
sort of thing.

> On Sat, 21 Jan 2023 19:03:23 +0530 m.chetan.kumar@linux.intel.com wrote:
> > From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> > 
> > PCI rescan module implements "rescan work queue".
> > In firmware flashing or coredump collection procedure
> > WWAN device is programmed to boot in fastboot mode and
> > a work item is scheduled for removal & detection.
> > 
> > The WWAN device is reset using APCI call as part driver
> > removal flow. Work queue rescans pci bus at fixed interval
> > for device detection, later when device is detect work queue
> > exits.

I'm not sure what's going on here.  Do we need to reset the device
when the t7xx driver is loaded so the device will load new firmware
when it comes out of reset?

There are a few drivers that do that, e.g., with pci_reset_function().

> > +static struct remove_rescan_context t7xx_rescan_ctx;

Apparently this only supports a single t7xx instance in a system?  Not
good.

> > +void t7xx_pci_dev_rescan(void)
> > +{
> > +	struct pci_bus *b = NULL;
> > +
> > +	pci_lock_rescan_remove();
> > +	while ((b = pci_find_next_bus(b)))
> > +		pci_rescan_bus(b);

No, this driver absolutely cannot rescan and assign unassigned
resources for all the PCI buses in the system.

Bjorn
