Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB3665C4EB
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 18:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238119AbjACRRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 12:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238404AbjACRRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 12:17:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFC8335;
        Tue,  3 Jan 2023 09:17:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5BC7B80E12;
        Tue,  3 Jan 2023 17:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8418C433D2;
        Tue,  3 Jan 2023 17:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672766223;
        bh=NjPyEb+7G3mfwu5Ui90hyTTySgvhBTP+HjDquXjxoXI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h8ynO3FjWLUp5rAM+BsXMdghGepwYtxqLiZOaXk2YPMRGSLBeepHNu31slrnTsDQn
         OlXE/K/ZiYE++LiLWZo0ENK9ktqb/RjeCJsMSf9GGWg+v2WljLeKtzD/EWECgfqR2H
         z1KVwPFqiJkW/XGV3rlS76iWh7KFXIgtYjPBBAmChHuRPXhbGKjSW+4WVJE+8zyIVJ
         IB9CDCbfFjJoc2L4eRFNp8qIqFZd18HBS/1reilA1PLXs3qUhbSOMsAq65Dv73yPtk
         M0uS/r/ZNNWJIVOo6LeC8ZeXyPnnNOeVSsH2OfCAfZZh+OtrbUGpgbdz5xHX6PbnBR
         8gfxTblAZanMg==
Date:   Tue, 3 Jan 2023 19:16:58 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Rajat Khandelwal <rajat.khandelwal@linux.intel.com>,
        anthony.l.nguyen@intel.com, netdev@vger.kernel.org,
        rajat.khandelwal@intel.com, jesse.brandeburg@intel.com,
        linux-kernel@vger.kernel.org, edumazet@google.com,
        intel-wired-lan@lists.osuosl.org, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, kuba@kernel.org,
        pabeni@redhat.com, davem@davemloft.net
Subject: Re: [Intel-wired-lan] [PATCH] igc: Mask replay rollover/timeout
 errors in I225_LMVP
Message-ID: <Y7RjCkanr0Ulx3TD@unreal>
References: <Y7QYxAhcUa2JtjSy@unreal>
 <20230103142104.GA996978@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103142104.GA996978@bhelgaas>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 08:21:04AM -0600, Bjorn Helgaas wrote:
> On Tue, Jan 03, 2023 at 02:00:04PM +0200, Leon Romanovsky wrote:
> > On Tue, Jan 03, 2023 at 05:54:02AM -0600, Bjorn Helgaas wrote:
> > > On Tue, Jan 03, 2023 at 11:54:24AM +0200, Leon Romanovsky wrote:
> > > > On Sun, Jan 01, 2023 at 11:34:21AM +0100, Paul Menzel wrote:
> > > > > Am 01.01.23 um 09:32 schrieb Leon Romanovsky:
> > > > > > On Thu, Dec 29, 2022 at 05:56:40PM +0530, Rajat Khandelwal wrote:
> > > > > > > The CPU logs get flooded with replay rollover/timeout AER errors in
> > > > > > > the system with i225_lmvp connected, usually inside thunderbolt devices.
> > > > > > > 
> > > > > > > One of the prominent TBT4 docks we use is HP G4 Hook2, which incorporates
> > > > > > > an Intel Foxville chipset, which uses the igc driver.
> > > > > > > On connecting ethernet, CPU logs get inundated with these errors. The point
> > > > > > > is we shouldn't be spamming the logs with such correctible errors as it
> > > > > > > confuses other kernel developers less familiar with PCI errors, support
> > > > > > > staff, and users who happen to look at the logs.
> > > 
> > > > > > > --- a/drivers/net/ethernet/intel/igc/igc_main.c
> > > > > > > +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> > > 
> > > > > > > +static void igc_mask_aer_replay_correctible(struct igc_adapter *adapter)
> > > 
> > > > > > Shouldn't this igc_mask_aer_replay_correctible function be implemented
> > > > > > in drivers/pci/quirks.c and not in igc_probe()?
> > > > > 
> > > > > Probably. Though I think, the PCI quirk file, is getting too big.
> > > > 
> > > > As long as that file is right location, we should use it.
> > > > One can refactor quirk file later.
> > > 
> > > If a quirk like this is only needed when the driver is loaded, 
> > 
> > This is always the case with PCI devices managed through kernel, isn't it?
> > Users don't care/aware about "broken" devices unless they start to use them.
> 
> Indeed, that's usually the case.  There's a lot of stuff in quirks.c
> that could probably be in drivers instead.

NP, so or deprecate quirks.c and prohibit any change to that file or
don't allow drivers to mangle PCI in their probe routines.
Everything in-between will cause to enormous mess in long run.

Thanks

> 
> Bjorn
