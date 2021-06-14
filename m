Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2C63A6DF5
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 20:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbhFNSKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 14:10:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233427AbhFNSKh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 14:10:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A239B61075;
        Mon, 14 Jun 2021 18:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623694112;
        bh=qrjuQm9P9B7DB+Umdys0YcvR95UPMm0tJN+AIKoB+Jc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=huiOFekAJEgQPdX/j9JJvixdZpZjCFQjSu9NA+/831ufPdRRuQz7IIdkTXxyXiy8E
         lfYXISkYJvhMXCc+4Rz/6kIeNLFhsIxBhETEqxB2kG3NvY0M5Q3WmaXTb0DCQpD4wH
         umcBmn8BihzMy2qwTXQSRy+s2NsU/CfNhBkDyMxflRYqGbh5GyLfbzKnOPYjmX0/PH
         bT28Z5hkoXGQI3/qZXX+isc7/WQCw//DJ+aBQpaQT5IU4ZoNqLe4yBoiszDe3gJURN
         z8EX/ycLhGGBgfCB0/mzPUDUuidkuRLiSvHIxHYWFv2hNWnTEXJC4ld7s1hzZ98tYn
         9QTiGoN5F5aWw==
Date:   Mon, 14 Jun 2021 11:08:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        davem@davemloft.net, netdev@vger.kernel.org, sassmann@redhat.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: Re: [PATCH net-next 5/8] ice: register 1588 PTP clock device object
 for E810 devices
Message-ID: <20210614110831.65d21c8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ca27bafc-fdc2-c5f1-fc37-1cdf48d393b2@intel.com>
References: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
        <20210611162000.2438023-6-anthony.l.nguyen@intel.com>
        <20210611141800.5ebe1d4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ca27bafc-fdc2-c5f1-fc37-1cdf48d393b2@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Jun 2021 09:43:17 -0700 Jacob Keller wrote:
> >> +static int ice_ptp_adjfine(struct ptp_clock_info *info, long scaled_ppm)
> >> +{
> >> +	struct ice_pf *pf = ptp_info_to_pf(info);
> >> +	u64 freq, divisor = 1000000ULL;
> >> +	struct ice_hw *hw = &pf->hw;
> >> +	s64 incval, diff;
> >> +	int neg_adj = 0;
> >> +	int err;
> >> +
> >> +	incval = ICE_PTP_NOMINAL_INCVAL_E810;
> >> +
> >> +	if (scaled_ppm < 0) {
> >> +		neg_adj = 1;
> >> +		scaled_ppm = -scaled_ppm;
> >> +	}
> >> +
> >> +	while ((u64)scaled_ppm > div_u64(U64_MAX, incval)) {
> >> +		/* handle overflow by scaling down the scaled_ppm and
> >> +		 * the divisor, losing some precision
> >> +		 */
> >> +		scaled_ppm >>= 2;
> >> +		divisor >>= 2;
> >> +	}  
> > 
> > I have a question regarding ppm overflows.
> > 
> > We have the max_adj field in struct ptp_clock_info which is checked
> > against ppb, but ppb is a signed 32 bit and scaled_ppm is a long,
> > meaning values larger than S32_MAX << 16 / 1000 will overflow 
> > the ppb calculation, and therefore the check.
> 
> Hmmm.. I thought ppb was a s64, not an s32.
> 
> In general, I believe max_adj is usually capped at 1 billion anyways,
> since it doesn't make sense to slow a clock by more than 1billioln ppb,
> and increasing it more than that isn't really useful either.

Do you mean it's capped somewhere in the code to 1B?

I'm no time expert but this is not probability where 1 is a magic
value, adjusting clock by 1 - 1ppb vs 1 + 1ppb makes little difference,
no? Both mean something is super fishy with the nominal or expected
frequency, but the hardware can do that and more.

Flipping the question, if adjusting by large ppb values is not correct,
why not cap the adjustment at the value which would prevent the u64
overflow?

I don't really have a preferences here, I'm mostly disturbed by 
the overflow in the ppb vs max_adj check.

> > Are we okay with that? Is my math off? Did I miss some part 
> > of the kernel which filters crazy high scaled_ppm/freq?
> > 
> > Since dialed_freq is updated regardless of return value of .adjfine 
> > the driver has no clear way to reject bad scaled_ppm>  
> 
> I'm not sure. +Richard?
