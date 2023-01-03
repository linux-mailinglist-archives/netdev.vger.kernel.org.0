Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF05765BF67
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 12:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbjACLyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 06:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbjACLyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 06:54:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0606572;
        Tue,  3 Jan 2023 03:54:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A0A06124F;
        Tue,  3 Jan 2023 11:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01D8C433EF;
        Tue,  3 Jan 2023 11:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672746843;
        bh=/4mB6P2Bm4GaYOrK2xAGD+BWjqC6TeZT/BUcGYXroUI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=oE+HpvffB1aMuaiplglU2hipGASxDz6CXaHX58XITEWtm9XbLkBkqUL/2ddB3w9Qc
         yqaSl7oN3jI0k+TusgLQuxWxR9Baq3ZFwy+QeiQAl2+C8tMOjHNLrRfyKVvtzsQRnv
         3fFEIOR9vhRIUQbKzplX/+Doj2XWeTQ2yE0wg99Enz/YTnsr1EKYIO0dE8VefTvGhf
         WtxDR2/yg4MwgPyLshBuG1ADxN9QdUQxp/goi6i8qJRfVSdKVenX+gF0iM6bU/HNj8
         yzODfjeG3Wqez6T/O5HEwwZFsVXlPzjCn87NAwv0VZ8ukrGY08hj1RxcPsv067J6O7
         5igxLQPwt/tgg==
Date:   Tue, 3 Jan 2023 05:54:02 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
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
Message-ID: <20230103115402.GA848993@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7P7UKpmE8/LsmOn@unreal>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 11:54:24AM +0200, Leon Romanovsky wrote:
> On Sun, Jan 01, 2023 at 11:34:21AM +0100, Paul Menzel wrote:
> > Am 01.01.23 um 09:32 schrieb Leon Romanovsky:
> > > On Thu, Dec 29, 2022 at 05:56:40PM +0530, Rajat Khandelwal wrote:
> > > > The CPU logs get flooded with replay rollover/timeout AER errors in
> > > > the system with i225_lmvp connected, usually inside thunderbolt devices.
> > > > 
> > > > One of the prominent TBT4 docks we use is HP G4 Hook2, which incorporates
> > > > an Intel Foxville chipset, which uses the igc driver.
> > > > On connecting ethernet, CPU logs get inundated with these errors. The point
> > > > is we shouldn't be spamming the logs with such correctible errors as it
> > > > confuses other kernel developers less familiar with PCI errors, support
> > > > staff, and users who happen to look at the logs.

> > > > --- a/drivers/net/ethernet/intel/igc/igc_main.c
> > > > +++ b/drivers/net/ethernet/intel/igc/igc_main.c

> > > > +static void igc_mask_aer_replay_correctible(struct igc_adapter *adapter)

> > > Shouldn't this igc_mask_aer_replay_correctible function be implemented
> > > in drivers/pci/quirks.c and not in igc_probe()?
> > 
> > Probably. Though I think, the PCI quirk file, is getting too big.
> 
> As long as that file is right location, we should use it.
> One can refactor quirk file later.

If a quirk like this is only needed when the driver is loaded, I think
the driver is a better place than drivers/pci/quirks.c.  If it's in
quirks.c, either we have to replicate driver Kconfig via #ifdefs, or
the kernel contains the quirk for systems that don't need it.

I'm generally not a fan of simply masking errors because they're
annoying.  I'd prefer to figure out the root cause and fix it if
possible.  Or maybe we can tone down or rate-limit the logging so it's
not so alarming.

Bjorn
