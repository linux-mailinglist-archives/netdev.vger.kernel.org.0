Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4266A1430
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 01:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjBXANO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 19:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBXANN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 19:13:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3104D15C8F
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 16:13:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 673D9617BA
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 00:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1A1C433D2;
        Fri, 24 Feb 2023 00:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677197591;
        bh=LBbv2K4bzl2jwG35TRIUGZTtUQaMP2wQPXZyP6/gfys=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TOjkrFn1G+SalkbxLzANG+PAQN+aX0SdFAO2eJ5bn0m273prvqmHUeeWE20k8ortL
         h2Tj0YLCGL/lTklizXxLa+cJliZwsEyvgRVow6KatYEwJ0ktXsaYgvyaaqgZNu7GOz
         WMtw8vWAXcsgVnSkx8asnEx79JcHAU7/SiSFO+I7hvS0gYxTDaZi7D7LwNB4F4fIxi
         hfMNCwGqcIb5qAkbnClQWzVSulOu5KQwuYkeBLR3jWCch5D+Fjxnm6v2BlWFXoIfP9
         qk6O1Vzfjat5cdoDy9SHnLFGwIhi5wR2jGc875TUlCMIIJnBtdtVz7EGx6/xZWZ0nY
         8+V/4f4zb0YGQ==
Date:   Thu, 23 Feb 2023 16:13:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        <netdev@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Anthony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [intel-net] ice: remove unnecessary CONFIG_ICE_GNSS
Message-ID: <20230223161309.0e439c5f@kernel.org>
In-Reply-To: <7af17cfa-ae15-f548-1a1b-01397a766066@intel.com>
References: <20230222223558.2328428-1-jacob.e.keller@intel.com>
        <20230222211742.4000f650@kernel.org>
        <7af17cfa-ae15-f548-1a1b-01397a766066@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Feb 2023 14:55:07 -0800 Jacob Keller wrote:
> > I mean instead of s/IS_ENABLED/IS_REACHABLE/ do this:
> > 
> > index 3facb55b7161..198995b3eab5 100644
> > --- a/drivers/net/ethernet/intel/Kconfig
> > +++ b/drivers/net/ethernet/intel/Kconfig
> > @@ -296,6 +296,7 @@ config ICE
> >         default n
> >         depends on PCI_MSI
> >         depends on PTP_1588_CLOCK_OPTIONAL
> > +       depends on GNSS || GNSS=n
> >         select AUXILIARY_BUS
> >         select DIMLIB
> >         select NET_DEVLINK
> > 
> > Or do you really care about building ICE with no GNSS.. ?  
> 
> This would probably also work, but you'd still need #if IS_ENABLED in
> ice_gnss.h to split the stub functions when GNSS is disabled.
> 
> The original author, Arkadiusz, can comment on whether we care about
> building without GNSS support.
> 
> My guess its a "we don't need it for core functionality, so we don't
> want to block building ice if someone doesn't want GNSS for whatever
> reason."

Just to be crystal clear we're talking about the GNSS=m ICE=y case.
I'm suggesting that it should be disallowed at the Kconfig level.
ICE=m/y GNSS=n will still work as expected.
