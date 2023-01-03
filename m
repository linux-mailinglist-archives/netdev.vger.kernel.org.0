Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576FA65BF85
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 13:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237506AbjACMAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 07:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232179AbjACMAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 07:00:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D829DDF55;
        Tue,  3 Jan 2023 04:00:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E043612D6;
        Tue,  3 Jan 2023 12:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E8CC433EF;
        Tue,  3 Jan 2023 12:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672747208;
        bh=h9kbUWYnH4uArH2bII+AxBQ3uPevdlLQIWanWnBVjHE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q38z5R7Wd5krBkticzxr5cxpBQ+YI7yuKgc63H0GQ3zlDV7LmPUlvb5iQm6WpJAft
         Sxnd24XCamUMxt+EttTPccaKXWv2elj/CBQI6DyrrnBM8n6z6Tc6c8QD5t33rCug7+
         kTw7DfxbjsTvpcF00WZgEsNDKDXw4JSalHR3exzPEBYor3+A8cE5m6ehbqWRTEt3DG
         K1Ne/T13pWfiG8yUkv9SpoAVh4fWcq+PgsIYlGk1fBbnKjGXyDeDL53c7Lii/Aglbu
         vDhRjcmXUAqCWauLQ9RWopeJiSxYG3ocHhqaugixEKM0qfM8v3yNE2/fPP8cxYi2RO
         2zJEs2gERKq9w==
Date:   Tue, 3 Jan 2023 14:00:04 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Rajat Khandelwal <rajat.khandelwal@linux.intel.com>,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        rajat.khandelwal@intel.com, jesse.brandeburg@intel.com,
        linux-kernel@vger.kernel.org, edumazet@google.com,
        intel-wired-lan@lists.osuosl.org, kuba@kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        anthony.l.nguyen@intel.com, pabeni@redhat.com, davem@davemloft.net
Subject: Re: [Intel-wired-lan] [PATCH] igc: Mask replay rollover/timeout
 errors in I225_LMVP
Message-ID: <Y7QYxAhcUa2JtjSy@unreal>
References: <Y7P7UKpmE8/LsmOn@unreal>
 <20230103115402.GA848993@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103115402.GA848993@bhelgaas>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 05:54:02AM -0600, Bjorn Helgaas wrote:
> On Tue, Jan 03, 2023 at 11:54:24AM +0200, Leon Romanovsky wrote:
> > On Sun, Jan 01, 2023 at 11:34:21AM +0100, Paul Menzel wrote:
> > > Am 01.01.23 um 09:32 schrieb Leon Romanovsky:
> > > > On Thu, Dec 29, 2022 at 05:56:40PM +0530, Rajat Khandelwal wrote:
> > > > > The CPU logs get flooded with replay rollover/timeout AER errors in
> > > > > the system with i225_lmvp connected, usually inside thunderbolt devices.
> > > > > 
> > > > > One of the prominent TBT4 docks we use is HP G4 Hook2, which incorporates
> > > > > an Intel Foxville chipset, which uses the igc driver.
> > > > > On connecting ethernet, CPU logs get inundated with these errors. The point
> > > > > is we shouldn't be spamming the logs with such correctible errors as it
> > > > > confuses other kernel developers less familiar with PCI errors, support
> > > > > staff, and users who happen to look at the logs.
> 
> > > > > --- a/drivers/net/ethernet/intel/igc/igc_main.c
> > > > > +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> 
> > > > > +static void igc_mask_aer_replay_correctible(struct igc_adapter *adapter)
> 
> > > > Shouldn't this igc_mask_aer_replay_correctible function be implemented
> > > > in drivers/pci/quirks.c and not in igc_probe()?
> > > 
> > > Probably. Though I think, the PCI quirk file, is getting too big.
> > 
> > As long as that file is right location, we should use it.
> > One can refactor quirk file later.
> 
> If a quirk like this is only needed when the driver is loaded, 

This is always the case with PCI devices managed through kernel, isn't it?
Users don't care/aware about "broken" devices unless they start to use them.

Thanks
