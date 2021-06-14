Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67AA43A70B2
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 22:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbhFNUuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 16:50:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234143AbhFNUuG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 16:50:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD02261153;
        Mon, 14 Jun 2021 20:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623703683;
        bh=VZ6400in4ZAVP2lLy9TDSmmslHkgbbBhADHcm8xX7nU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YVNLE/94WyTGulZqnrfNBZLLv0T1EJ5J8lN8IKrT+Qv6dNjNP14+Fc37aMvTUODRq
         cYZt7X0zDNBRkPt4OKc67Ty8fABYwi+phcoaVAR2asOJBwc2VaOo4cYJYsbwneXIRq
         mQ/kXTEf7qwJde195VKHjhDh1C/Zs/Lzde7viBy9/INXDcqKo83xkHVvjAMit4NHoS
         7mPCeUek//yrkn/2IN/hQovhm2mjHAitZVDtFsP1816yT9Tf3GxrOrTQaZ6axjB7ey
         eEM1Wkx8V0YaKJ6KQ6s9GARqqi3agFmPHp/hmqyNoOU8YR2H9OeYr7aychQ/afQOfH
         ZDLz53k8Zt5Zg==
Date:   Mon, 14 Jun 2021 13:48:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Brelinski, TonyX" <tonyx.brelinski@intel.com>
Subject: Re: [PATCH net-next 5/8] ice: register 1588 PTP clock device object
 for E810 devices
Message-ID: <20210614134802.633be4c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <427ddb2579f14d77b537aae9c2fa9759@intel.com>
References: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
        <20210611162000.2438023-6-anthony.l.nguyen@intel.com>
        <20210611141800.5ebe1d4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ca27bafc-fdc2-c5f1-fc37-1cdf48d393b2@intel.com>
        <20210614110831.65d21c8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <427ddb2579f14d77b537aae9c2fa9759@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Jun 2021 19:50:23 +0000 Keller, Jacob E wrote:
> > > Hmmm.. I thought ppb was a s64, not an s32.
> > >
> > > In general, I believe max_adj is usually capped at 1 billion anyways,
> > > since it doesn't make sense to slow a clock by more than 1billioln ppb,
> > > and increasing it more than that isn't really useful either.  
> > 
> > Do you mean it's capped somewhere in the code to 1B?
> > 
> > I'm no time expert but this is not probability where 1 is a magic
> > value, adjusting clock by 1 - 1ppb vs 1 + 1ppb makes little difference,
> > no? Both mean something is super fishy with the nominal or expected
> > frequency, but the hardware can do that and more.
> > 
> > Flipping the question, if adjusting by large ppb values is not correct,
> > why not cap the adjustment at the value which would prevent the u64
> > overflow?  
> 
> Large ppb values are sometimes used when you want to slew a clock to
> bring it in sync when its a few milliseconds to seconds off, without
> performing a time jump (so that you maintain monotonic increasing
> time).

Ah, you're right, ptp4l will explicitly cap the freq adjustments
based on max_adj from sysfs, so setting max_adj too low could impact
the convergence time in strange scenarios.

> That being said, we are supposed to be checking max_adj, except that
> you're right the conversion to ppb could overflow, and there's no
> check prior to the conversion from scaled_ppm to ppb.
