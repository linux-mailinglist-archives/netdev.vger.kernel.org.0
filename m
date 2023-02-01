Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25FA668618E
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 09:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbjBAIXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 03:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjBAIXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 03:23:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287CC5D132
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 00:23:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82377616EF
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 08:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF40C433D2;
        Wed,  1 Feb 2023 08:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675239802;
        bh=XV+Zu3jDEW9EZhFPMj71z1hFPGnuEG1NkA1g8JyiObk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SKZFG3Gp+RJsaXKBQ9I1wQBfHFH/c6oMEQOzee1VjWePf0qv9+s9MKh7RNGbyu9PA
         wXY3vsZ8dFGYt+xnlebTOdNAlFZGQ4DBYkyo061Yrmfp03yhfu65PkMF3uppvyGfiL
         ecY6IZHH+fFMZwkuZAw90p2XThC0YncxD3O2u9wHwvfj5QhMN9Qw9IySnq8f1Sm0W2
         2/Suq4V11fXD0/5icVc9B0ineKQn6RqwH6PnikIbEDoDyMgfdWvfoW3jpyFhGaMAIE
         X+qaPr8EKZwMIL450065iyrugmpcjIiIcXGtjo2aDEWuYhJd4ySsqKp3/O8lTFLRSS
         o1dV6AhbidHWg==
Date:   Wed, 1 Feb 2023 10:23:17 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/8][pull request] Intel Wired LAN: Remove
 redundant Device Control Error Reporting Enable
Message-ID: <Y9ohdVec3y9lu48e@unreal>
References: <20230130192519.686446-1-anthony.l.nguyen@intel.com>
 <Y9jQpjLPkRR/emeH@unreal>
 <CAErSpo64=miv7++wUhHKx=mnN1Rmh3u+cTaPxngbj4nd=9spjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAErSpo64=miv7++wUhHKx=mnN1Rmh3u+cTaPxngbj4nd=9spjQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 12:05:37PM -0600, Bjorn Helgaas wrote:
> On Tue, Jan 31, 2023 at 2:26 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Mon, Jan 30, 2023 at 11:25:11AM -0800, Tony Nguyen wrote:
> > > Bjorn Helgaas says:
> > >
> > > Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is native"),
> > > the PCI core sets the Device Control bits that enable error reporting for
> > > PCIe devices.
> > >
> > > This series removes redundant calls to pci_enable_pcie_error_reporting()
> > > that do the same thing from several NIC drivers.
> > >
> > > There are several more drivers where this should be removed; I started with
> > > just the Intel drivers here.
> > > ---
> > > TN: Removed mention of AER driver as this was taken through PCI tree [1]
> > > and fixed a typo.
> > >
> > > [1] https://lore.kernel.org/all/20230126231527.GA1322015@bhelgaas/
> > >
> > > The following are changes since commit 90e8ca0abb05ada6c1e2710eaa21688dafca26f2:
> > >   Merge branch 'devlink-next'
> > > and are available in the git repository at:
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 10GbE
> > >
> > > Bjorn Helgaas (8):
> > >   e1000e: Remove redundant pci_enable_pcie_error_reporting()
> > >   fm10k: Remove redundant pci_enable_pcie_error_reporting()
> > >   i40e: Remove redundant pci_enable_pcie_error_reporting()
> > >   iavf: Remove redundant pci_enable_pcie_error_reporting()
> > >   ice: Remove redundant pci_enable_pcie_error_reporting()
> > >   igb: Remove redundant pci_enable_pcie_error_reporting()
> > >   igc: Remove redundant pci_enable_pcie_error_reporting()
> > >   ixgbe: Remove redundant pci_enable_pcie_error_reporting()
> > >
> > >  drivers/net/ethernet/intel/e1000e/netdev.c    | 7 -------
> > >  drivers/net/ethernet/intel/fm10k/fm10k_pci.c  | 5 -----
> > >  drivers/net/ethernet/intel/i40e/i40e_main.c   | 4 ----
> > >  drivers/net/ethernet/intel/iavf/iavf_main.c   | 5 -----
> > >  drivers/net/ethernet/intel/ice/ice_main.c     | 3 ---
> > >  drivers/net/ethernet/intel/igb/igb_main.c     | 5 -----
> > >  drivers/net/ethernet/intel/igc/igc_main.c     | 5 -----
> > >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 5 -----
> > >  8 files changed, 39 deletions(-)
> >
> > I see that you didn't touch any other places except drivers/net/ethernet/intel/.
> > Are you planning to remove other occurrences too?
> >
> > ➜  kernel git:(rdma-next) git grep pci_enable_pcie_error_reporting -- drivers/infiniband/
> > drivers/infiniband/hw/hfi1/pcie.c:      (void)pci_enable_pcie_error_reporting(pdev);
> > drivers/infiniband/hw/qib/qib_pcie.c:   ret = pci_enable_pcie_error_reporting(pdev);
> 
> Yes, definitely, I just haven't had a chance yet.  Some of the others
> are a little more complicated than the simple removals for the Intel
> drivers.

Great, I'll wait for your patch :)

Thanks.

> 
> Bjorn
