Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2620565BD80
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 10:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237149AbjACJyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 04:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237108AbjACJyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 04:54:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74203B5A;
        Tue,  3 Jan 2023 01:54:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11A2660E97;
        Tue,  3 Jan 2023 09:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DD7C433EF;
        Tue,  3 Jan 2023 09:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672739669;
        bh=BpfDQ8HqIK6YKlZtjbbpD8Zo3Pb/8YhLfqVQpatUtt0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KxJii57/6HLZ5doJil0NXj28Kw4JpRkyPmP7KGXKsLj4q3nx9/+eBuPvve4qqAvvn
         GMp0W+1yVkKF9vK4hhcKvKGJN3KNZaSkG+JskFvdXGm2KNMN25TM2TtDySGpOReh9w
         etMBWuT8aISx+egjmKosD8zICLvqak10muDDkbeiLNHV6yml4gNhmf1C/hs27dC4J2
         R0aBXrrf88B5574M0quLMUDDPuTzV6Kjz+7ONopNNM2l5C+Y8Bbgq73NXEh1SLENuo
         exYF8Yv7UYU/BAQ76jVmo6A1LxSQ0XSdEf7PDK8idSO9P28r+jW+JdSLsVxSc7tDsa
         rOe4mrEXoO92g==
Date:   Tue, 3 Jan 2023 11:54:24 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Rajat Khandelwal <rajat.khandelwal@linux.intel.com>,
        intel-wired-lan@lists.osuosl.org, rajat.khandelwal@intel.com,
        jesse.brandeburg@intel.com, linux-kernel@vger.kernel.org,
        edumazet@google.com, anthony.l.nguyen@intel.com,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        davem@davemloft.net, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Subject: Re: [Intel-wired-lan] [PATCH] igc: Mask replay rollover/timeout
 errors in I225_LMVP
Message-ID: <Y7P7UKpmE8/LsmOn@unreal>
References: <20221229122640.239859-1-rajat.khandelwal@linux.intel.com>
 <Y7FFESJONJqGJUkb@unreal>
 <a4216a94-72b3-4711-bc90-ad564a57b310@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4216a94-72b3-4711-bc90-ad564a57b310@molgen.mpg.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 01, 2023 at 11:34:21AM +0100, Paul Menzel wrote:
> [Cc: +Bjorn, +linux-pci]
> 
> Dear Leon, dear Rajat,
> 
> 
> Am 01.01.23 um 09:32 schrieb Leon Romanovsky:
> > On Thu, Dec 29, 2022 at 05:56:40PM +0530, Rajat Khandelwal wrote:
> > > The CPU logs get flooded with replay rollover/timeout AER errors in
> > > the system with i225_lmvp connected, usually inside thunderbolt devices.
> > > 
> > > One of the prominent TBT4 docks we use is HP G4 Hook2, which incorporates
> > > an Intel Foxville chipset, which uses the igc driver.
> > > On connecting ethernet, CPU logs get inundated with these errors. The point
> > > is we shouldn't be spamming the logs with such correctible errors as it
> > > confuses other kernel developers less familiar with PCI errors, support
> > > staff, and users who happen to look at the logs.
> > > 
> > > Signed-off-by: Rajat Khandelwal <rajat.khandelwal@linux.intel.com>
> > > ---
> > >   drivers/net/ethernet/intel/igc/igc_main.c | 28 +++++++++++++++++++++--
> > >   1 file changed, 26 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> > > index ebff0e04045d..a3a6e8086c8d 100644
> > > --- a/drivers/net/ethernet/intel/igc/igc_main.c
> > > +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> > > @@ -6201,6 +6201,26 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
> > >   	return value;
> > >   }
> > > +#ifdef CONFIG_PCIEAER
> > > +static void igc_mask_aer_replay_correctible(struct igc_adapter *adapter)
> > > +{
> > > +	struct pci_dev *pdev = adapter->pdev;
> > > +	u32 aer_pos, corr_mask;
> > > +
> > > +	if (pdev->device != IGC_DEV_ID_I225_LMVP)
> > > +		return;
> > > +
> > > +	aer_pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ERR);
> > > +	if (!aer_pos)
> > > +		return;
> > > +
> > > +	pci_read_config_dword(pdev, aer_pos + PCI_ERR_COR_MASK, &corr_mask);
> > > +
> > > +	corr_mask |= PCI_ERR_COR_REP_ROLL | PCI_ERR_COR_REP_TIMER;
> > > +	pci_write_config_dword(pdev, aer_pos + PCI_ERR_COR_MASK, corr_mask);
> > 
> > Shouldn't this igc_mask_aer_replay_correctible function be implemented
> > in drivers/pci/quirks.c and not in igc_probe()?
> 
> Probably. Though I think, the PCI quirk file, is getting too big.

As long as that file is right location, we should use it.
One can refactor quirk file later.

Thanks

> 
> 
> Kind regards,
> 
> Paul
