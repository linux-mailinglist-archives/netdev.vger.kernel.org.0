Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9978958A312
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 00:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235305AbiHDWHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 18:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbiHDWHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 18:07:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C0A26552
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 15:07:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A64F9B82757
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 22:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01963C433D7;
        Thu,  4 Aug 2022 22:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659650858;
        bh=qfk/9I+kxbtQGiqJamV1UuLOtj2XEbuQqZN8vXHny9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CADGFRx9jHN6Ch13uZx7PniqvRSV8UIitAabj6B8K1kA5pEEoEcN5hkH4IhR1WT+u
         R/Wvdj73hTkxFIX9oQcMSgl4+RjYRr/3QujslsVaTM1izjETIYr0wz9chMSGoeCDU5
         CRG73/3ox/CFzCSGB6uQbXV1yYkx+K986q+XuUA1OJSSlmGV05l5r4mo2GhD9pfp0w
         Zad2gkgGsSmb2oneJD4PgRpyKX2hh4NJIPLm/QQtaE/cnYB850qQyata/VAIj1aPgn
         3hDiirn1g6aalq+7WeUNyIM+39Z6hlmqWsp+sR/TvXZtm+YSn5praf9h0l3jQO9PQ/
         miFBKE1O6wjAA==
From:   James Hogan <jhogan@kernel.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Sasha Neftin <sasha.neftin@intel.com>,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        netdev@vger.kernel.org
Subject: Re: [Intel-wired-lan] I225-V (igc driver) hangs after resume in igc_resume/igc_tsn_reset
Date:   Thu, 04 Aug 2022 23:07:34 +0100
Message-ID: <3514132.R56niFO833@saruman>
In-Reply-To: <1838555.CQOukoFCf9@saruman>
References: <4752347.31r3eYUQgx@saruman> <e8f33b45-380f-e73e-3879-0e1a478262e9@molgen.mpg.de> <1838555.CQOukoFCf9@saruman>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, 4 August 2022 22:41:01 BST James Hogan wrote:
> On Thursday, 4 August 2022 14:27:24 BST Paul Menzel wrote:
> > Am 04.08.22 um 15:03 schrieb James Hogan:
> > > On Thursday, 28 July 2022 18:36:31 BST James Hogan wrote:
> > >> On Wednesday, 27 July 2022 15:37:09 BST Vinicius Costa Gomes wrote:
> > >>> Yeah, I agree that it seems like the issue is something else. I would
> > >>> suggest start with the "simple" things, enabling
> > >>> 'CONFIG_PROVE_LOCKING'
> > >>> and looking at the first splat, it could be that what you are seeing
> > >>> is
> > >>> caused by a deadlock somewhere else.
> > >> 
> > >> This is revealing I think (re-enabled PCIE_PTM and enabled
> > >> PROVE_LOCKING).
> > >> 
> > >> In this case it happened within minutes of boot, but a few previous
> > >> attempts with several suspend cycles with the same kernel didn't detect
> > >> the same thing.
> > > 
> > > I hate to nag, but any thoughts on the lockdep recursive locking warning
> > > below? It seems to indicate a recursive taking of rtnl_mutex in
> > > dev_ethtool
> > > and igc_resume, which would certainly seem to point the finger squarely
> > > back at the igc driver.
> > 
> > I hope, the developers will respond quickly. If it is indeed a
> > regression, and you do not want to wait for the developers, you could
> > try to bisect the issue. To speed up the test cycles, I recommend to try
> > to try to reproduce the issue in QEMU/KVM and passing through the
> > network device.
> 
> Unfortunately its new hardware for me, so I don't know if there's a good
> working version of the driver. I've only had constant pain with it so far.
> Frequent failed resumes, hangs on shutdown.
> 
> However I just did a bit more research and found these dead threads from a
> year ago which appear to pinpoint the issue:
> https://lore.kernel.org/all/20210420075406.64105-1-acelan.kao@canonical.com/
> https://lore.kernel.org/all/20210809032809.1224002-1-acelan.kao@canonical.c
> om/

And I just found this patch from December which may have been masked by the 
PTM issues:
https://lore.kernel.org/netdev/20211201185731.236130-1-vinicius.gomes@intel.com/

I'll build and run with that for a few days and see how it goes.

Cheers
James


